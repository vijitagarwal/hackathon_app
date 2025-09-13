import { Pinecone } from '@pinecone-database/pinecone';
import { OpenAI } from 'openai';

const pinecone = new Pinecone({
  apiKey: process.env.PINECONE_API_KEY!,
});

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY!,
});

const indexName = process.env.PINECONE_INDEX_NAME || 'university-rag';

export const getIndex = () => {
  return pinecone.index(indexName);
};

export const createEmbedding = async (text: string) => {
  try {
    const response = await openai.embeddings.create({
      model: 'text-embedding-ada-002',
      input: text,
    });
    
    return response.data[0].embedding;
  } catch (error) {
    console.error('Error creating embedding:', error);
    throw error;
  }
};

export const upsertDocument = async (
  id: string,
  text: string,
  metadata: Record<string, any>
) => {
  try {
    const embedding = await createEmbedding(text);
    const index = getIndex();
    
    await index.upsert([
      {
        id,
        values: embedding,
        metadata: {
          ...metadata,
          text,
        },
      },
    ]);
    
    return { success: true };
  } catch (error) {
    console.error('Error upserting document:', error);
    throw error;
  }
};

export const searchSimilarDocuments = async (
  query: string,
  topK: number = 5,
  filter?: Record<string, any>
) => {
  try {
    const queryEmbedding = await createEmbedding(query);
    const index = getIndex();
    
    const searchResponse = await index.query({
      vector: queryEmbedding,
      topK,
      includeMetadata: true,
      filter,
    });
    
    return searchResponse.matches || [];
  } catch (error) {
    console.error('Error searching documents:', error);
    throw error;
  }
};

export const deleteDocument = async (id: string) => {
  try {
    const index = getIndex();
    await index.deleteOne(id);
    return { success: true };
  } catch (error) {
    console.error('Error deleting document:', error);
    throw error;
  }
};

export const generateResponse = async (
  query: string,
  context: string[],
  sources: string[]
) => {
  try {
    const systemPrompt = `You are a helpful campus assistant for a university platform. 
    Use the provided context to answer questions about university resources, policies, and information.
    Always cite your sources when possible and be concise but informative.
    If you cannot find relevant information in the context, say so clearly.`;
    
    const userPrompt = `Context from university resources:
${context.join('\n\n')}

Sources: ${sources.join(', ')}

Question: ${query}

Please provide a helpful answer based on the context above.`;

    const response = await openai.chat.completions.create({
      model: 'gpt-4',
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userPrompt },
      ],
      max_tokens: 500,
      temperature: 0.7,
    });
    
    return response.choices[0].message.content || 'I apologize, but I could not generate a response.';
  } catch (error) {
    console.error('Error generating response:', error);
    throw error;
  }
};

export const generateSummary = async (text: string, title: string) => {
  try {
    const prompt = `Please create a concise 3-bullet point summary of the following educational resource titled "${title}":

${text}

Format your response as exactly 3 bullet points, each starting with "• " and being one clear, informative sentence.`;

    const response = await openai.chat.completions.create({
      model: 'gpt-4',
      messages: [
        { role: 'user', content: prompt },
      ],
      max_tokens: 200,
      temperature: 0.5,
    });
    
    return response.choices[0].message.content || 'Summary could not be generated.';
  } catch (error) {
    console.error('Error generating summary:', error);
    throw error;
  }
};