#!/bin/bash
token=$(curl -s 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net' -H Metadata:true | jq -r '.access_token')
 curl -s 'https://p-dvtst-inf-dvkey.vault.azure.net/secrets/asadminLogin?api-version=2016-10-01' -H "Authorization: Bearer $token" | jq -r '.value'

