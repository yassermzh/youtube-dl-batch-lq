var sys = require('sys');
var exec = require('child_process').exec;
var links = require('./youtube-happiness-links.json')
function puts(error, stdout, stderr) { sys.puts(stdout) }
exec("~/path/to/nodejs/restartscript.sh", puts);
