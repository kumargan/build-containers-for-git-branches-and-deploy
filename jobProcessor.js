var cmd=require('node-cmd');
var request = require('request');
var build_under_progress=false;
var Slack = require('node-slackr');
var fs = require('fs');

//Add "slack_webhook_url" to env for sending slack notifications
var slack = new Slack(process.env.slack_webhook_url,{
  channel: "#xxxx_events",
  username: "auto_deploy_dev",
  icon_url: "https://www.google.co.in/imgres?imgurl=https%3A%2F%2Fimage.slidesharecdn.com%2Fw5jxenheqvmb1ci4llaq-signature-9d57fa9c7d324166570cd06f6b5d3e2dac908dbe8373338701be7e2d36406a0c-poli-150514161033-lva1-app6891%2F95%2Foperating-opnfv-deploy-it-test-it-run-it-11-638.jpg%3Fcb%3D1431621055&imgrefurl=https%3A%2F%2Fwww.slideshare.net%2FOPNFV%2F5-nfv-wc-operatingopnfvbrockners-final&docid=hyqAeGVWzMGvxM&tbnid=TVo3ac_71EBgiM%3A&vet=10ahUKEwihme333vfWAhUESo8KHUdNAvsQMwjkASgVMBU..i&w=638&h=359&bih=930&biw=1676&q=deploy&ved=0ahUKEwihme333vfWAhUESo8KHUdNAvsQMwjkASgVMBU&iact=mrc&uact=8",
  icon_emoji: ":robot_face:"
});

/*
    Accepts build request. Declines if a build is already in progress.
*/
function startBuild(req, res) {
    console.log('build request submitted for branch ', req.body.github_branch_name);
    if (!build_under_progress) {
        build_under_progress = true;
        setTimeout(processJob, 1,req.body.github_branch_name); //process the request async
        res.send(' build started, please check the server after some time ');
    } else{
      console.log("build request dropped as a build is in progress..")
      res.send(' build under progress, please try after some time( 10 min) ');
    }

}

/*
    invokes a child process which runs the sscript tart-build.sh. This script handles all activities.
*/
function processJob(github_branch_name) {

    cmd.get(' bash ./scripts/start-build.sh '+github_branch_name
      ,
      function(err, data, stderr){
            if (!err) {
               console.log(' build succesful')
               build_under_progress=false;
               fs.readFile('build.logs', 'utf8', function(err, contents) {
                    console.log(contents);
                });
               sendToSlack("deployed in dev env, branch : "+github_branch_name)
            } else {
               console.log('error', err)
            }
 
        }
    );
}

/*
    send messages to slack channels
*/
function sendToSlack(message) {
    slack.notify(message, function(err, result){
    console.log(err,result);
});


}

module.exports = {
    startBuild
}