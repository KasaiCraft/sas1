# ClientFlow SaaS Tool

ClientFlow is a SaaS tool designed for freelancers and agencies to manage clients, projects, payments, and referrals.

## Features

- **Client Portal**: Clients can view project status, upload files, and approve milestones.
- **Payments (Stripe)**: Freelancers can send invoices and clients can pay via Stripe Checkout. Supports recurring subscriptions for SaaS plans.
- **Referral System**: Users can get a referral link and earn credit for paid signups.

## Tech Stack

- **Backend**: Node.js + Express
- **Database**: PostgreSQL
- **Auth**: JWT + Cookies
- **Frontend**: Next.js + Tailwind (Not implemented in this backend-focused setup)
- **Payments**: Stripe API
- **File Storage**: AWS S3

## Getting Started

### Prerequisites

- Node.js (v14 or higher)
- PostgreSQL
- AWS S3 Bucket
- Stripe Account

### Installation

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd sas
    ```

2.  **Install dependencies**:
    ```bash
    npm install
    ```

### Database Setup

1.  **Create a PostgreSQL database**.

2.  **Run the SQL schema** provided in `database.sql` to set up the necessary tables:
    ```sql
    -- Users (Freelancers/Agencies)
    CREATE TABLE users (
      id SERIAL PRIMARY KEY,
      email VARCHAR(255) UNIQUE,
      password_hash TEXT,
      stripe_customer_id TEXT,
      plan_type VARCHAR(20) -- 'free', 'starter', 'pro'
    );

    -- Referrals
    CREATE TABLE referrals (
      id SERIAL PRIMARY KEY,
      referrer_id INTEGER REFERENCES users(id),
      referee_id INTEGER REFERENCES users(id),
      earned_credit BOOLEAN DEFAULT false
    );

    -- Projects
    CREATE TABLE projects (
      id SERIAL PRIMARY KEY,
      user_id INTEGER REFERENCES users(id),
      client_name TEXT,
      status TEXT -- 'draft', 'in_progress', 'completed'
    );

    -- Invoices (Stripe)
    CREATE TABLE invoices (
      id SERIAL PRIMARY KEY,
      project_id INTEGER REFERENCES projects(id),
      stripe_invoice_id TEXT,
      amount INTEGER,
      paid BOOLEAN DEFAULT false
    );
    ```

### Environment Variables

Create a `.env` file in the root directory of the project with the following variables:

```
DATABASE_URL=postgresql://user:password@host:port/database
JWT_SECRET=your_jwt_secret_key_for_jwt_tokens
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=whsec_your_stripe_webhook_secret (optional, for webhooks)
AWS_ACCESS_KEY_ID=your_aws_access_key_id
AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
AWS_S3_BUCKET_NAME=your_s3_bucket_name
AWS_REGION=your_aws_region (e.g., us-east-1)
BASE_URL=http://localhost:5000 (or your deployed backend URL)
PORT=5000
```

-   `DATABASE_URL`: Connection string for your PostgreSQL database.
-   `JWT_SECRET`: A strong, random string for signing JWT tokens.
-   `STRIPE_SECRET_KEY`: Your Stripe secret API key.
-   `STRIPE_WEBHOOK_SECRET`: (Optional) Your Stripe webhook secret for verifying webhook events.
-   `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_S3_BUCKET_NAME`, `AWS_REGION`: Your AWS credentials and S3 bucket details for file storage.
-   `BASE_URL`: The base URL of your backend application, used for generating referral links and Stripe redirect URLs.
-   `PORT`: The port on which the Express server will run.

### Running the Application

To start the development server:

```bash
npm run dev
```

To start the application in production mode:

```bash
npm start
```

The API will be running at `http://localhost:5000` (or the `PORT` you configured).

## API Endpoints

### User Authentication

-   `POST /api/users/signup`: Register a new user.
-   `POST /api/users/login`: Log in a user and receive a JWT token.

### Projects

-   `POST /api/projects`: Create a new project (requires authentication).
-   `GET /api/projects`: Get all projects for the authenticated user.
-   `GET /api/projects/:id`: Get a single project by ID.
-   `PUT /api/projects/:id`: Update a project by ID.
-   `DELETE /api/projects/:id`: Delete a project by ID.

### Payments (Stripe)

-   `POST /api/stripe/create-checkout-session`: Create a Stripe Checkout session for a one-time payment.
-   `POST /api/stripe/webhook`: Stripe webhook endpoint for handling payment events.

### Referrals

-   `GET /api/referrals/generate`: Generate a referral link for the authenticated user.
-   `POST /api/referrals/track-signup`: Track a new user signup via a referral link.

### Client Portal

-   `GET /api/client-portal/projects/:projectId/status`: Get project status for a client.
-   `POST /api/client-portal/projects/:projectId/upload`: Upload files to a project.
-   `POST /api/client-portal/projects/:projectId/approve-milestone`: Approve a milestone for a project.

## Next Steps (Frontend)

This setup provides the backend API. For a complete SaaS tool, you would build a frontend application using Next.js and Tailwind CSS that interacts with these API endpoints.