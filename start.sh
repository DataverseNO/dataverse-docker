#!/bin/bash
docker-compose up -d
sleep 60
docker cp ./profile dataverse:/home/payara/.profile
su - payara
docker exec dataverse env > /home/payara/.profile
docker exec dataverse su - payara;source /home/payara/.profile;env
docker exec dataverse su - payara;env
docker exec dataverse asadmin --user=admin --passwordfile=/opt/payara/passwordFile deploy /opt/payara/deployments/dataverse.war
#docker rm dataverse:/home/payara/.profile

