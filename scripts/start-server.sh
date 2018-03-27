#!bin bash
#starts docker engine within the container and runs as deamon
PORT=4444 wrapdocker &
#start the server which accepts build requests and orchestrates build
npm start