#!/bin/bash

/usr/bin/apt-get install patch -y
/usr/bin/curl -o $DOCROOT_DIR/Bundle.properties.patch  https://raw.githubusercontent.com/DataverseNO/dataverse-docker/dataverse.no-dev/distros/dataverse.no/modification/Bundle.properties.patch
/usr/bin/patch /opt/payara/appserver/glassfish/domains/domain1/applications/dataverse/WEB-INF/classes/propertyFiles/Bundle.properties $DOCROOT_DIR/Bundle.properties.patch


