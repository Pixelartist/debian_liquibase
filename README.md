# debian_liquibase
Debian 9 meets liquibase meets pentaho

How to build the image
docker build -t Name of the Image --build-arg TOKEN=Github deployment token --build-arg GITHUBPROJECTFULLPATH=Full path to the repository --build-arg PROJECTTARGETPATH=Path where liquibase repo needs to be cloned --build-arg LIQUIBASE_DRIVER=which db driver --build-arg LIQUIBASE_DATABASEURL=host of the database --build-arg LIQUIBASE_USERNAME=Username for the connection --build-arg LIQUIBASE_PASSWORD=password for the connection .

ARG TOKEN
ARG GITHUBPROJECTFULLPATH
ARG PROJECTTARGETPATH
ARG LIQUIBASE_DRIVER=postgresql
ARG LIQUIBASE_DATABASEURL
ARG LIQUIBASE_USERNAME
ARG LIQUIBASE_PASSWORD

Since this is a docker it uses root to run everything - bad habit.
