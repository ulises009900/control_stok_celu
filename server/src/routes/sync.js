const express = require('express');
const { requireAuth } = require('../middleware/auth');
const genericSyncRouter = require('../sync/genericSyncRouter');
const salesSyncRouter = require('../sync/salesSyncRouter');

const router = express.Router();

router.use(requireAuth);
router.use('/sales', salesSyncRouter);
router.use('/', genericSyncRouter);

module.exports = router;
