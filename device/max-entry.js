'use strict';
// Node for Max loads user scripts as modules, not as the process entry point.
require('./bridge').start(require('max-api'));
