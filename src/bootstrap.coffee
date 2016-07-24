exports.parse = require('./parser')()
exports.validate = require('./validator')()
exports.generate = require('./generator')()

# Expose module on window object in browser
if typeof window != 'undefined' && window
    window.smoothieConfig = exports
