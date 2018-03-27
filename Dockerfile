FROM jpetazzo/dind:latest

RUN apt-get update && apt-get install -y software-properties-common && \
	add-apt-repository ppa:openjdk-r/ppa && apt-get update && apt-get install -y openjdk-8-jdk && \ 
	wget -qO- https://deb.nodesource.com/setup_7.x | bash - && apt-get -y install nodejs

RUN apt-get update && apt-get -y install maven && \  
	apt-get install jq &&\
	apt-get update && apt-get install -y git && \
	wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py && pip install --upgrade awscli
	
COPY . .

RUN mkdir ~/.ssh && \
	echo "Host github.com\n\tStrictHostKeyChecking no\n" > ~/.ssh/config && \
	echo "\tIdentityFile /id_rsa" >> ~/.ssh/config && \
	chmod 400 id_rsa && npm i

EXPOSE 8083
	
CMD ["sh","./scripts/start-server.sh"] 
	
