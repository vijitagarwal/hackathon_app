# Deployment Troubleshooting Guide

## Common Issues and Solutions

### 1. Supabase Connection Issues

**Problem**: "Invalid API key" or connection timeouts

**Solutions**:
- Verify your Supabase URL and keys in environment variables
- Check if your Supabase project is active and not paused
- Ensure RLS policies are correctly configured
- Test connection with: `npm run test:db`

### 2. Pinecone Vector Database Issues

**Problem**: "Index not found" or embedding failures

**Solutions**:
- Create a Pinecone index with dimension 1536 (OpenAI embeddings)
- Verify your Pinecone API key and environment
- Check index name matches `PINECONE_INDEX_NAME` env var
- Test with: `npm run test:pinecone`

### 3. OpenAI API Issues

**Problem**: Rate limits or API key errors

**Solutions**:
- Check your OpenAI API key is valid and has credits
- Implement retry logic for rate limits
- Use environment-specific rate limiting
- Monitor usage in OpenAI dashboard

### 4. Vercel Deployment Failures

**Problem**: Build failures or function timeouts

**Solutions**:
- Check build logs in Vercel dashboard
- Verify all environment variables are set
- Ensure function timeout limits (10s for hobby plan)
- Use `vercel --debug` for detailed logs

### 5. File Upload Issues

**Problem**: Large files failing to upload

**Solutions**:
- Check Supabase storage bucket policies
- Verify file size limits (default 50MB)
- Implement chunked uploads for large files
- Check CORS settings in Supabase

### 6. Authentication Problems

**Problem**: Users can't log in or session expires

**Solutions**:
- Verify Supabase auth settings
- Check JWT secret configuration
- Ensure proper redirect URLs in Supabase
- Clear browser cookies and localStorage

### 7. Database Migration Errors

**Problem**: Migration failures or schema conflicts

**Solutions**:
- Run migrations in order: `npm run db:migrate`
- Check for conflicting table names
- Verify RLS policies don't block migrations
- Reset database if needed: `npm run db:reset`

### 8. Performance Issues

**Problem**: Slow page loads or API responses

**Solutions**:
- Enable Next.js caching: `npm run build`
- Optimize database queries with indexes
- Implement pagination for large datasets
- Use Vercel Edge Functions for better performance

### 9. CORS Errors

**Problem**: Cross-origin request blocked

**Solutions**:
- Configure CORS in API routes
- Check Supabase CORS settings
- Verify domain whitelist in production
- Use proper headers in fetch requests

### 10. Environment Variable Issues

**Problem**: Variables not loading in production

**Solutions**:
- Prefix client variables with `NEXT_PUBLIC_`
- Verify variables are set in Vercel dashboard
- Check for typos in variable names
- Restart deployment after adding variables

## Quick Diagnostic Commands

```bash
# Test database connection
npm run test:db

# Test AI services
npm run test:ai

# Check build locally
npm run build

# Verify environment
npm run env:check

# Reset everything
npm run reset:all
```

## Getting Help

1. Check the GitHub Issues for similar problems
2. Review Vercel deployment logs
3. Check Supabase logs and metrics
4. Contact support with error logs and environment details

## Emergency Recovery

If the platform is completely broken:

1. Revert to last working commit
2. Run database reset: `npm run db:reset`
3. Re-seed data: `npm run db:seed`
4. Redeploy: `npm run deploy`

## Monitoring and Alerts

Set up monitoring for:
- API response times
- Database connection health
- File upload success rates
- User authentication failures
- AI service availability

Use tools like:
- Vercel Analytics
- Supabase Metrics
- OpenAI Usage Dashboard
- Custom health check endpoints