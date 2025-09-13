import { createClient } from '@supabase/supabase-js';
import { upsertDocument, generateSummary } from './pinecone';
import * as pdfParse from 'pdf-parse';
import * as mammoth from 'mammoth';

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
);

export const extractTextFromFile = async (
  fileBuffer: Buffer,
  fileName: string,
  mimeType: string
): Promise<string> => {
  try {
    let text = '';
    
    if (mimeType === 'application/pdf') {
      const pdfData = await pdfParse(fileBuffer);
      text = pdfData.text;
    } else if (
      mimeType === 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ||
      mimeType === 'application/msword'
    ) {
      const result = await mammoth.extractRawText({ buffer: fileBuffer });
      text = result.value;
    } else if (mimeType === 'text/plain') {
      text = fileBuffer.toString('utf-8');
    } else {
      throw new Error(`Unsupported file type: ${mimeType}`);
    }
    
    return text.trim();
  } catch (error) {
    console.error('Error extracting text from file:', error);
    throw new Error('Failed to extract text from file');
  }
};

export const chunkText = (text: string, chunkSize: number = 1000, overlap: number = 200): string[] => {
  const chunks: string[] = [];
  let start = 0;
  
  while (start < text.length) {
    const end = Math.min(start + chunkSize, text.length);
    const chunk = text.slice(start, end);
    
    // Try to break at sentence boundaries
    if (end < text.length) {
      const lastSentence = chunk.lastIndexOf('.');
      const lastNewline = chunk.lastIndexOf('\n');
      const breakPoint = Math.max(lastSentence, lastNewline);
      
      if (breakPoint > start + chunkSize * 0.5) {
        chunks.push(text.slice(start, breakPoint + 1).trim());
        start = breakPoint + 1 - overlap;
      } else {
        chunks.push(chunk.trim());
        start = end - overlap;
      }
    } else {
      chunks.push(chunk.trim());
      break;
    }
  }
  
  return chunks.filter(chunk => chunk.length > 0);
};

export const processAndStoreFile = async (
  resourceId: string,
  fileName: string,
  fileBuffer: Buffer,
  mimeType: string,
  metadata: {
    title: string;
    uploadedBy: string;
    department?: string;
    subject?: string;
  }
) => {
  try {
    // Extract text from file
    const fullText = await extractTextFromFile(fileBuffer, fileName, mimeType);
    
    if (!fullText || fullText.length < 10) {
      throw new Error('File contains insufficient text content');
    }
    
    // Generate AI summary
    const summary = await generateSummary(fullText, metadata.title);
    
    // Update resource with summary
    await supabase
      .from('resources')
      .update({ ai_summary: summary })
      .eq('id', resourceId);
    
    // Chunk the text for vector storage
    const chunks = chunkText(fullText);
    
    // Store each chunk in Pinecone
    const chunkPromises = chunks.map((chunk, index) => {
      const chunkId = `${resourceId}_chunk_${index}`;
      const chunkMetadata = {
        resourceId,
        fileName,
        title: metadata.title,
        uploadedBy: metadata.uploadedBy,
        department: metadata.department || '',
        subject: metadata.subject || '',
        chunkIndex: index,
        totalChunks: chunks.length,
      };
      
      return upsertDocument(chunkId, chunk, chunkMetadata);
    });
    
    await Promise.all(chunkPromises);
    
    return {
      success: true,
      summary,
      chunksStored: chunks.length,
    };
  } catch (error) {
    console.error('Error processing file:', error);
    throw error;
  }
};

export const deleteFileFromVector = async (resourceId: string) => {
  try {
    // Note: In a production environment, you'd want to query Pinecone
    // to find all chunks for this resource and delete them
    // For now, we'll assume chunk IDs follow the pattern resourceId_chunk_N
    
    // This is a simplified approach - in production, you'd query first
    const deletePromises = [];
    for (let i = 0; i < 100; i++) { // Assume max 100 chunks
      const chunkId = `${resourceId}_chunk_${i}`;
      deletePromises.push(
        import('./pinecone').then(({ deleteDocument }) => 
          deleteDocument(chunkId).catch(() => {}) // Ignore errors for non-existent chunks
        )
      );
    }
    
    await Promise.all(deletePromises);
    
    return { success: true };
  } catch (error) {
    console.error('Error deleting file from vector store:', error);
    throw error;
  }
};

export const searchResources = async (
  query: string,
  filters?: {
    department?: string;
    subject?: string;
    uploadedBy?: string;
  }
) => {
  try {
    const { searchSimilarDocuments } = await import('./pinecone');
    
    const pineconeFilter: Record<string, any> = {};
    if (filters?.department) pineconeFilter.department = filters.department;
    if (filters?.subject) pineconeFilter.subject = filters.subject;
    if (filters?.uploadedBy) pineconeFilter.uploadedBy = filters.uploadedBy;
    
    const results = await searchSimilarDocuments(query, 10, pineconeFilter);
    
    // Group results by resource ID and get unique resources
    const resourceMap = new Map();
    
    results.forEach((result) => {
      const resourceId = result.metadata?.resourceId;
      if (resourceId && !resourceMap.has(resourceId)) {
        resourceMap.set(resourceId, {
          resourceId,
          title: result.metadata?.title,
          score: result.score,
          snippet: result.metadata?.text?.substring(0, 200) + '...',
        });
      }
    });
    
    return Array.from(resourceMap.values());
  } catch (error) {
    console.error('Error searching resources:', error);
    throw error;
  }
};