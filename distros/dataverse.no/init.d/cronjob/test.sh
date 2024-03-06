#!/bin/bash
line='S3://2002-green-dataversenotest1:185a0170e18-2a067fdd4e75 | 10.21337/FK2/JZJWZE/V44S0V/185a0170e18-2a067fdd4e75 | 173487'
source=`echo $line|awk {'print $1'}`
#target=`echo $line|awk {'print $3'}`
target=`echo $line|awk {'print $3'}|awk -F/ {'print $1"/"$3$4'}`
echo "cp" $source $target
