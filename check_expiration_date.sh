#!/bin/bash

# Check if the GlideinWMS Frontend Certificates are less than a month away from expiring
# Diego Davila
# March 3rd, 2020

# Seconds in a month
THRESHOLD=$((3600*24*30))

# Check if service cert expires in less that the $THRESHOLD
openssl x509 -in /home/frontend/.globus/vocms080/frontend01/frontend01cert.pem -noout -checkend $THRESHOLD
if [ $? == 1 ]
then
    SERVICE_DATE=`openssl x509 -in /home/frontend/.globus/vocms080/frontend01/frontend01cert.pem -noout -enddate`
    MSG1="Frontend service certificate of: $HOSTNAME will expire $SERVICE_DATE"
fi

# Check if pilot cert expires in less that the $THRESHOLD
openssl x509 -in /home/frontend/.globus/vocms080/cmspilot01/cmspilot01cert.pem -noout -checkend $THRESHOLD
if [ $? == 1 ]
then
    PILOT_DATE=`openssl x509 -in /home/frontend/.globus/vocms080/cmspilot01/cmspilot01cert.pem -noout -enddate`
    MSG2="Frontend pilot certificate of: $HOSTNAME will expire $PILOT_DATE"
fi

if [ ! -z "$MSG1$MSG2" ]
then
        echo -e "$MSG1\n$MSG2" | mail -s "FE cert expires in less than 30 days" didavila@ucsd.edu
fi

