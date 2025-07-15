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