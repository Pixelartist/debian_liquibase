#!/bin/bash
GITHUBAUTHCALL=$(echo $GITHUBPROJECTFULLPATH | sed "s/https:\/\//https:\/\/$TOKEN:x-oauth-basic@/g")
git clone -b master $GITHUBAUTHCALL $PROJECTTARGETPATH

echo "driver: org."$LIQUIBASE_DRIVER".Driver" > /opt/telecare/repo/liquibase.properties
echo "url: jdbc:"$LIQUIBASE_DRIVER"://"$LIQUIBASE_DATABASEURL >> /opt/telecare/repo/liquibase.properties
echo "username: "$LIQUIBASE_USERNAME >> /opt/telecare/repo/liquibase.properties
echo "password: "$LIQUIBASE_PASSWORD >> /opt/telecare/repo/liquibase.properties
