#!bin bash
# this scripts uses build-docker.sh file present in project to build a praticular branch and push.
# The ECS container needs to have roles for ECR.

build_logs=`pwd`build.logs
echo "log path " $build_logs
echo "starting build"

repoName=git-repo-name
dockerLocalRepo=local-repo-name:latest
dockerRemoteRepo=account.dkr.ecr.us-east-1.amazonaws.com/image-name:latest
ecsServiceName=service-name
ecsClusterName=cluster-name

if [ -d "$repoName" ]; then
	echo " repo already available " > $build_logs
else
  	git clone git@github.com:TimeInc/$repoName.git > $build_logs
fi

cd ./$repoName
git checkout $1 >> $build_logs
git pull git@github.com:TimeInc/$repoName.git >> $build_logs

sh build-docker.sh >> $build_logs

echo "pushing the container" >> $build_logs

$(aws ecr get-login --no-include-email --region us-east-1) >> $build_logs
docker tag $dockerLocalRepo $dockerRemoteRepo >> $build_logs
docker push $dockerRemoteRepo >> $build_logs

aws ecs list-tasks --cluster $ecsClusterName --service $ecsServiceName --region us-east-1 | jq '.taskArns[]' | while read taskARN; do   echo $taskARN | cut -c2-$((${#taskARN} - 1)); aws ecs stop-task --task `echo $taskARN | cut -c2-$((${#taskARN} - 1))` --cluster $ecsClusterName --region us-east-1;   done; 

rm -rf ../$repoName
