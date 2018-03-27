## Build Containers for any Git branch and Deploy the containers in AWS ECS.
	
	This application itself is a container and hence is reliable (  In case of issues AWS ECS will retstart the process. ECS knows about the issues by checking /dbi/_healthcheck response ). This is useful for dev env where any sort of pipeline does not make any sense. This allows a developed to test out a feature branch by giving a deploy request to server. 

		curl -X POST http://localhost:8083/dbi/startBuild \
        -H 'content-type: application/json' \
        -H 'postman-token: c0d2794a-ee61-4434-0905-25c004cab172' \
        -d '{ "github_branch_name":"develop" }'

    The server then invokes scripts/start-build.sh as a child env ( passes the AWS credentials to child process ). This sript itself deploys the container in AWS ECS and restarts the containers in ECS. This server has check to receive one request at a time, Subsequent requests are dropeed intimating users of the same. The server also prints the child process logs to console so that it could be forwarded to cloud watch for monitering.

1. scripts/start-server.sh : 
	
	1.1. Starts the docker engine deamon. 
	1.2. Starts the node app( which serves the deploy requests).

2. scripts/start-build.sh :
	
	2.1. Takes pull from the repo configured in the file ( please go through the configuration ). To enable pull from the desired repo ssh pulic key needs to be added to the git repo and private key should be put in id_rsa file( present on the root path of the repo ).

	2.2. Builds the container using a script available in the repo 'build-docker.sh' ( Create a script which builds the container and make it part of the repo, as different repos may have different build steps).

	2.3. Logs in into the AWS ECS using the credentials and pushes the container. Stop the running dev container.

## Flow :
	
	Starting the container ( using docker run/ ECS deployment ) runs  `scripts/start-server.sh`. This start the server as well as docker deamon. Making depoy call to the server ('refer curl command above') invokes `scripts/start-build.sh`. This script does everything. Once the process is complete The app collects logs for the child process and dumps it onto console for logging and monitoring.

Steps to deploy the server locally (without docker)

Prerequsites :
1. docker, java, node, maven

2. steps to start server
	export AWS_ACCESS_KEY_ID=
	export AWS_SECRET_ACCESS_KEY=
	export slack_webhook_url=

	2.1. start docker
		sh run.sh docker
	2.2. start node ( do not use now )
		sh run.sh //this does not work as it is not able to push the code to repo
