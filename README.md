# Holistic University Platform

A comprehensive full-stack university management system with AI-powered features, built with Next.js, Supabase, and modern web technologies.

## 🚀 Features

- **Role-based Authentication**: Student, Teacher, Warden, Vendor, Admin roles
- **AI-Powered Assistant**: RAG-based campus assistant using OpenAI and Pinecone
- **File Management**: Upload, summarize, and search through educational resources
- **Hostel Management**: Leave applications and approval workflow
- **Mess Management**: Daily menus, meal booking, and vendor analytics
- **Event Management**: Create and approve campus events
- **Analytics Dashboard**: Admin insights and metrics
- **Demo Mode**: Auto-tour functionality with Playwright recording

## 🛠️ Tech Stack

- **Frontend**: Next.js 14, React, TypeScript, Tailwind CSS
- **Backend**: Next.js API Routes
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
- **Vector Database**: Pinecone
- **AI/ML**: OpenAI (GPT-4, Embeddings)
- **File Storage**: Supabase Storage
- **Deployment**: Vercel + Supabase
- **Testing**: Jest, Playwright

## 📋 Prerequisites

- Node.js 18+ and npm
- Supabase account and project
- OpenAI API key
- Pinecone account and index
- Git

## 🔧 Local Development Setup

### 1. Clone and Install Dependencies

```bash
git clone <your-repo-url>
cd holistic-university-platform
npm install
```

### 2. Environment Variables

Copy `.env.example` to `.env.local` and fill in your credentials:

```bash
cp .env.example .env.local
```

Required environment variables:
- `NEXT_PUBLIC_SUPABASE_URL`: Your Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`: Your Supabase anonymous key
- `SUPABASE_SERVICE_ROLE_KEY`: Your Supabase service role key
- `OPENAI_API_KEY`: Your OpenAI API key
- `PINECONE_API_KEY`: Your Pinecone API key
- `PINECONE_ENVIRONMENT`: Your Pinecone environment
- `PINECONE_INDEX_NAME`: Your Pinecone index name (default: university-rag)

### 3. Database Setup

Run the database migrations and seed data:

```bash
npm run db:setup
npm run db:seed
```

### 4. Start Development Server

```bash
npm run dev
```

Visit `http://localhost:3000` to see the application.

## 👥 Demo Accounts

The seed script creates the following demo accounts:

- **Admin**: admin@uni.test / DemoPass123!
- **Teacher**: teacher1@uni.test / Tpass123
- **Student**: student1@uni.test / Spass123
- **Warden**: warden@uni.test / Wpass123
- **Vendor**: vendor@uni.test / Vpass123

## 🎬 Demo Mode

Access the auto-tour demo at `/demo-mode` or run the Playwright recording:

```bash
npm run demo:record
```

This will generate a `demo.mp4` file showing all platform features.

## 🧪 Testing

Run the test suite:

```bash
npm test
npm run test:e2e
```

## 🚀 Deployment

### Automatic Deployment (GitHub Actions)

1. Set up the following secrets in your GitHub repository:
   - `VERCEL_TOKEN`
   - `VERCEL_ORG_ID`
   - `VERCEL_PROJECT_ID`
   - All environment variables from `.env.example`

2. Push to main branch to trigger automatic deployment

### Manual Deployment

```bash
npm run deploy
```

## 📁 Project Structure

```
src/
├── app/                    # Next.js 14 app directory
│   ├── api/               # API routes
│   ├── auth/              # Authentication pages
│   ├── dashboard/         # Role-based dashboards
│   └── demo-mode/         # Auto-tour demo
├── components/            # Reusable UI components
├── lib/                   # Utilities and configurations
├── types/                 # TypeScript type definitions
└── utils/                 # Helper functions

supabase/
├── migrations/            # Database migrations
└── seed.sql              # Initial data

scripts/
├── demo-record.js        # Playwright demo recording
└── deploy.js             # Deployment script
```

## 🔒 Security Features

- Role-based access control (RBAC)
- JWT token validation
- Supabase Row Level Security (RLS)
- CORS protection
- Input validation and sanitization

## 📊 Analytics & Monitoring

The admin dashboard provides insights on:
- User activity and engagement
- File uploads and AI usage
- Leave applications and approvals
- Meal bookings and cancellations
- Event participation

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details.

## 🆘 Troubleshooting

See `HOW_TO_FIX_DEPLOYMENT.md` for common issues and solutions.