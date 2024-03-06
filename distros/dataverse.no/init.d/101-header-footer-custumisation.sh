#!/bin/bash

wget https://raw.githubusercontent.com/DataverseNO/dataverse-docker/dataverse.no/distros/dataverse.no/modification/custom-header.html -O /tmp/custom-header.html    
wget https://raw.githubusercontent.com/DataverseNO/dataverse-docker/dataverse.no/distros/dataverse.no/modification/custom-footer.html -O /tmp/custom-footer.html

curl -X PUT -d https://site.uit.no/dataverseno/about/ http://localhost:8080/api/admin/settings/:NavbarAboutUrl
#curl -X PUT -d https://site.uit.no/dataverseno/deposit/ http://localhost:8080/api/admin/settings/:NavbarGuidesUrl
curl -X PUT -d '/logos/navbar/logo.png' http://localhost:8080/api/admin/settings/:LogoCustomizationFile
#curl -X PUT -d '/tmp/custom-header.html' http://localhost:8080/api/admin/settings/:HeaderCustomizationFile
curl -X PUT -d '/tmp/custom-footer.html' http://localhost:8080/api/admin/settings/:FooterCustomizationFile
#curl -X PUT -d http://site.uit.no/dataverseno/deposit/ http://localhost:8080/api/admin/settings/:GuidesBaseUrl
#curl -X PUT -d '' http://localhost:8080/api/admin/settings/:GuidesVersion
curl -X PUT -d https://site.uit.no/dataverseno/support/ http://localhost:8080/api/admin/settings/:NavbarSupportUrl
curl -X PUT -d https://site.uit.no/dataverseno/about/policy-framework/access-and-use-policy/  http://localhost:8080/api/admin/settings/:ApplicationPrivacyPolicyUrl

#file.dataFilesTab.metadata.header=Metadata

if [ ! -z ${TESTBANNER+x} ];
	then 
		curl -X PUT -d '/tmp/custom-header.html' http://localhost:8080/api/admin/settings/:HeaderCustomizationFile
        else
		curl -X PUT -d '' http://localhost:8080/api/admin/settings/:HeaderCustomizationFile
     	fi

