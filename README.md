# docker-stack-collection

This repository contains a set of docker-compose and backup shell scripts made for use with docker swarm. 
Additionally, a minimalistic nginx config file is included that can be used as a base.
Everything is functional and can be used immediately, but things like database passwords etc. should be adjusted.
More information for this configuration can be found in the README file in the individual docker folders.

## Getting Started

The general structure is the same for every docker container: 
- The nginx.conf provides a minimalistic configuration. 
- The backup.sh script makes a backup of all important files like database or additional attachments. It is recommended to add the back.sh file e.g. as a cron job and run it in a fixed interval. 
- The docker-compose.yml can be executed with docker swarm and provides a functional but minimalistic docker container. 

Inside the backup.sh and docker-compose.yml are some variables that need to be changed like passwords to encrypt the backups or the databases.
More information can be found in the specific readme files.