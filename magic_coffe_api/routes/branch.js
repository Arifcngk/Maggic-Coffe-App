const express = require('express');
const router = express.Router();
const branchController = require('../controller/branchController');

router.get('/branches', branchController.getAllBranches);

module.exports = router;
