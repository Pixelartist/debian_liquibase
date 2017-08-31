#!/bin/bash
GITHUBAUTHCALL=$(echo $GITHUBPROJECTFULLPATH | sed "s/https:\/\//https:\/\/$TOKEN:x-oauth-basic@/g")
git clone -b master $GITHUBAUTHCALL $PROJECTTARGETPATH

echo "driver: org."$liquibase_driver".Driver" > /opt/telecare/repo/liquibase.properties
echo "url: jdbc:"$liquibase_driver"://"$liquibase_url >> /opt/telecare/repo/liquibase.properties
echo "username: "$liquibase_username >> /opt/telecare/repo/liquibase.properties
echo "password: "$liquibase_password >> /opt/telecare/repo/liquibase.properties
