#!/bin/bash

export PGPASSWORD=`cat /secrets/db/password`
cp -r /secrets/aws-cli/.aws ~

# 
LogDir="/opt/payara/appserver/glassfish/domains/domain1/logs/"
if [ ! -d "${LogDir}" ]; then
	LogDir="/var/log/"
fi

if [ ! -d "/mnt/" ]; then
	 mkdir -p "/mnt/"
fi

LogFile="${LogDir}checkETag_`date +%Y%m%d_%H%M%z`.log"

if [ ! -f "/mnt/dataverse_checkETag.txt" ]; then
	psql -h ${DATAVERSE_DB_HOST} -U ${DATAVERSE_DB_USER} ${POSTGRES_DATABASE} -f ${INIT_SCRIPTS_FOLDER}/cronjob/checkfiles.sql | grep S3 | awk '{split($0,a,"|"); print a[2] a[3]}' | sed "s/S3:\/\/$aws_bucket_name://" > /tmp/dataverse_checkETag.txt
fi

#while read p; do
while true; do

	line=$(head -n 1 /mnt/dataverse_checkETag.txt)

	IFS=' ' read -a arrayData <<< "$line"
	#echo ${arrayData[0]}

	s3ETag=$(aws s3api --endpoint https://$aws_endpoint head-object --bucket $aws_bucket_name --key ${arrayData[0]}  2> /dev/null | jq .ETag | sed 's/\"//g' | sed 's/\\//g')
	

	if [ -z "${s3ETag}" ]; then
		echo "is not exist in the s3 storage: ${arrayData[0]}" >> ${LogFile}
	else

		if [ "${s3ETag}" != "${arrayData[1]}" ]; then
			echo "is not equal: ${arrayData[0]}" >> ${LogFile}
		fi
	fi

	#tail -n +2 "/mnt/dataverse_checkETag.txt" > "/mnt/dataverse_checkETag.txt.tmp"
	#mv "/mnt/dataverse_checkETag.txt.tmp" "/mnt/dataverse_checkETag.txt"

	sed '1d' "/mnt/dataverse_checkETag.txt"

	if [ ! -s "/mnt/dataverse_checkETag.txt" ]; then
		exit 0
	fi

	sleep 1s
done


rm /mnt/dataverse_checkETag.txt