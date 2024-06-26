#!/bin/bash

# Federated login activation 
# https://guides.dataverse.org/en/latest/installation/shibboleth.html
if [ "${azure_json_file}" ]; then
    curl -X POST -H 'Content-type: application/json' --upload-file ${azure_json_file} http://localhost:8080/api/admin/authenticationProviders
fi
