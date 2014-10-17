#!/usr/bin/env node

var sys = require('sys');
var exec = require('child_process').exec;
var async = require('async');
var fs = require('fs');
var path = require('path');

if (process.argv.length<3){
	console.log('Usage: youtube-batch-dl filename');
	process.exit();
} 

var filename = process.argv[2];
if (!fs.existsSync(filename)) {
	console.log('Usage: youtube-batch-dl filename');
	process.exit();
} 

try {
	videos = fs.readFileSync(filename, 'utf8');
        videos = JSON.parse(videos);
} catch (e) {
	console.log('Usage: youtube-batch-dl filename');
	process.exit();
}

var cnt = 0;
console.log(videos);

async.eachLimit(videos, 1, function(video, done){
    cnt++;
    //if ([53,54].indexOf(video.id)==-1) {done(); return;}
    console.log('to download: [%s] %s', video.id, video.link);
    if (fs.existsSync(video.title+'.mp4')) {
        console.log('%s exists', video.title);
	done();
	return;
    }
    var ls = exec(["sh youtube-dl-dash.sh", video.link, "\""+video.title+"\""].join(' '), function(error, stdout, stderr) {
	done();
	sys.puts(stdout)
    });

    ls.on('exit', function (code) {
	console.log('Child process exited with exit code '+code);
	// done()
    });
    ls.on('stdout', function (data) {
	console.log(data);
    });
    ls.on('stderr', function (data) {
	console.log(data);
    });
})
