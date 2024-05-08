#!/bin/bash

cp -r /secrets/aws-cli/.aws ~

# AccessURL="[AZURE_BLOB_URL]"
OGINALBaseFolder="/dataCorrect/dataverse-files"
BaseFolder="/dataverse/dataverse-files"

#BASEURL="https://....blob.core.windows.net/data1"
FILEPATH="/dataCorrect/dataverse-files/"
LogFile="./checkETAG_2024.log"


while true; do

	if [ -f "${LogFile}" ]; then
		line=$(head -n 1 "${LogFile}")

		IFS=':' read -r -a arrayFerst <<< "$line"

        if [ "is not equal" == "${arrayFerst[0]}" ]; then

            IFS=" --  " read -r -a arraySecend <<< "${arrayFerst[1]}"
            FileCopy="${arraySecend[0]}"
            CheckMd5Database="${arraySecend[1]}"

            if [ ! -z ${OGINALBaseFolder}/"${FileCopy}" ]; then
                md5BlobBase64=$(curl -s "${BASEURL}${FILEPATH}${FileCopy}${KEYWINDOWSBLOB}" -I -q | grep "Content-MD5: " | awk '{ print $2 }' | base64 -di)

                if [ $? -eq 0 ]; then
                    md5Blob=$(echo -n "$md5BlobBase64" | xxd -p)
                    if [ "${CheckMd5Database}" == "${md5Blob}" ]; then

                        cp -fa ${OGINALBaseFolder}${FileCopy} ${BaseFolder}${FileCopy} 
                        aws s3 cp ${OGINALBaseFolder}${FileCopy} s3://URL/ --recursive

                        sed '1d' "${LogFile}" > "${LogFile}.tmp"
                        mv "${LogFile}.tmp" "${LogFile}"
                    fi
                fi
            fi
        fi

        if [ ! -s "${LogFile}" ]; then
            rm "${LogFile}"
            exit 0
        fi
    fi
done