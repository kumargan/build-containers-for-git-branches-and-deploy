#!bin bash
# This is docker script to create this contsiner itself ( This container when deployed to ECS allows a realiable deployment machine for dev env at a very low cost)

echo "*************************************** Clean UP *******************************************"
echo "deleting dangling images from docker engine"
docker rmi -f `docker images --filter 'dangling=true' -q --no-trunc`
docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null	
echo "***************************************   Build  *******************************************"
echo "building docker image"
docker build -t build-containers-for-git-branches-and-deploy:latest .
echo "docker image build successful "