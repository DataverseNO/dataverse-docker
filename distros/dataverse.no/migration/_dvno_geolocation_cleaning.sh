#!/bin/bash
export PGPASSWORD=`cat /secrets/db/password`
psql -U dataverse dataverse -h postgres  -f /tmp/dvno_geolocation_cleaning20240320.sql
