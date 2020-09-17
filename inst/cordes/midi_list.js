const easymidi = require('easymidi');
const ipts = easymidi.getInputs();
console.log(JSON.stringify(ipts));