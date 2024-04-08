#!/bin/bash

AccessURL="https://pdvtstdatanfs.blob.core.windows.net/data1?sp=rcw&st=2023-03-27T11:20:31Z&se=2023-03-28T19:20:31Z&spr=https&sv=2021-12-02&sr=c&sig=2UTzVDaCoxBvfHO2pFKeU5saQipSJs9m4nEg9XgC0oY%3D"
BaseFolder="/dataverse/dataverse-files"
LogFile="checkETAG_2024.log"


while IFS=': ' read -r -a arrayFerst ; do
    #IFS=': ' read -r -a arrayFerst <<< "$string"

    if [ "is not equal" == "${arrayFerst[0]}" ]

        IFS=' --  ' read -r -a arraySecend <<< "${arrayFerst[1]}"

        FileCopy="${arraySecend[0]}"
        if [ ! -z "${FileCopy}" ]; then
            #azcopy copy "${BaseFolder}/${FileCopy}" "${AccessURL}" --preserve-smb-info=true
            echo "${BaseFolder}/${FileCopy}"
        fi
    fi
done < "$LogFile"