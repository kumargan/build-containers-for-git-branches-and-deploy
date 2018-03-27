#!bin bash

if [ $1 = "docker" ];
then
	
	docker stop `cat process.pid`
	cp /dev/null process.pid
	echo "building  new container" 
	sh build-container.sh
	echo "starting  new container"
	docker run -d -p 8083:8083 --privileged -e slack_webhook_url=$slack_webhook_url -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY build-containers-for-git-branches-and-deploy > process.pid
else
	if [[ $OSTYPE == darwin* ]];
	then
		echo "stopping old process" 
		kill `cat process.pid`
		cp /dev/null process.pid
		echo "building  new app" 
		npm i
		echo "starting  new app" 
		npm start & 
		echo $! > process.pid
	else
		echo "stopping old process" 
		pm2 stop build-containers-for-git-branches-and-deploy
		pm2 delete all
		echo "building  new app" 
		npm i
		echo "starting  new app" 
		pm2 start app.js --name="build-containers-for-git-branches-and-deploy"
	fi
fi

