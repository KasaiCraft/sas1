const express = require('express');
const dotenv = require('dotenv');
const cookieParser = require('cookie-parser');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

const userRoutes = require('./routes/userRoutes');
const projectRoutes = require('./routes/projectRoutes');
const stripeRoutes = require('./routes/stripeRoutes');
const referralRoutes = require('./routes/referralRoutes');
const clientPortalRoutes = require('./routes/clientPortalRoutes');

app.use(express.json());
app.use(cookieParser());

app.get('/', (req, res) => {
  res.send('ClientFlow API is running!');
});

app.use('/api/users', userRoutes);
app.use('/api/projects', projectRoutes);
app.use('/api/stripe', stripeRoutes);
app.use('/api/referrals', referralRoutes);
app.use('/api/client-portal', clientPortalRoutes);

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});