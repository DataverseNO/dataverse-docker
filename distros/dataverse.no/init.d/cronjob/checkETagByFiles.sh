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
if [ ! -f "/mnt/checkETagByFiles.txt" ]; then
	echo "`date +%Y%m%d_%H%M%z`: Start psql" > ${LogFile}
	psql -h ${DATAVERSE_DB_HOST} -U ${DATAVERSE_DB_USER} ${POSTGRES_DATABASE} -f ${INIT_SCRIPTS_FOLDER}/cronjob/checkETagByFiles.sql | grep S3 | awk '{split($0,a,"|"); print a[2] a[3]}' | sed "s/S3:\/\/$aws_bucket_name://" > /mnt/checkETagByFiles.txt
	echo "`date +%Y%m%d_%H%M%z`: END psql" >> ${LogFile}
fi

#while read p; do
while true; do

	if [ -f "/mnt/checkETagByFiles.txt" ]; then
		line=$(head -n 1 /mnt/checkETagByFiles.txt)

		IFS=' ' read -a arrayData <<< "$line"
		#echo ${arrayData[0]}

		s3ETag=$(aws s3api --endpoint https://$aws_endpoint head-object --bucket $aws_bucket_name --key ${arrayData[0]}  2> /dev/null | jq .ETag | sed 's/\"//g' | sed 's/\\//g')
		

		if [ -z "${s3ETag}" ]; then
			echo "is not exist in the s3 storage: ${arrayData[0]} --  ${arrayData[1]}" >> ${LogFile}
		else

			if [ "${s3ETag}" != "${arrayData[1]}" ]; then
				echo "is not equal: ${arrayData[0]} --  ${arrayData[1]}" >> ${LogFile}
			fi
		fi

		#tail -n +2 "/mnt/checkETagByFiles.txt" > "/mnt/checkETagByFiles.txt.tmp"
		sed '1d' "/mnt/checkETagByFiles.txt" > "/mnt/checkETagByFiles.txt.tmp"
		mv "/mnt/checkETagByFiles.txt.tmp" "/mnt/checkETagByFiles.txt"

		if [ ! -s "/mnt/checkETagByFiles.txt" ]; then
			rm /mnt/checkETagByFiles.txt
			exit 0
		fi

		sleep 1s
	fi
done

exit 0