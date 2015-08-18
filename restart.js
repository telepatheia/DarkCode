// https://github.com/Unitech/pm2

var exec = require('child_process').exec;

exec("pm2 restart all", function(error, stdout, stderr){
	process.exit(0);
})