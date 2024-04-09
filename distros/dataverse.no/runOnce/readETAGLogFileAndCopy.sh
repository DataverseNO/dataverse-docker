#!/bin/bash

AccessURL="[AZURE_BLOB_URL]"
BaseFolder="/dataverse/dataverse-files"
LogFile="./checkETAG_2024.log"


while read p; do
    IFS=':' read -r -a arrayFerst <<< "$p"

    if [ "is not equal" == "${arrayFerst[0]}" ]; then

        IFS=" --  " read -r -a arraySecend <<< "${arrayFerst[1]}"

        FileCopy="${arraySecend[0]}"
        if [ ! -z "${FileCopy}" ]; then
            echo "${BaseFolder}/${FileCopy}"
            azcopy copy "${BaseFolder}/${FileCopy}" "${AccessURL}" --preserve-smb-info=true
        fi
    fi
done < "${LogFile}"
