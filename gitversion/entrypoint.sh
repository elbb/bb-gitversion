#!/bin/bash
set -o errexit   # abort on nonzero exitstatus
set -o pipefail  # don't hide errors within pipes

if [ -z "${GV_GIT}" ]; then
  echo "No git folder supplied. Using default source '/repo'."
  GV_GIT=/repo
fi

if [ -z "${GV_GEN}" ]; then
  echo "No generation folder supplied. Using default destination '/repo'."
  GV_GEN=/repo
fi

if [ -z "${GV_USERID}" ]; then
  echo "No user id supplied. Using default id '9001'"
  GV_USERID=9001
fi

useradd --shell /bin/bash -u ${GV_USERID} -o -c "" -m user

###### generate json ######

# generate json file with git version infos
GV_JSON_DIR=${GV_GEN}/json
mkdir -p ${GV_JSON_DIR}
dotnet /app/GitVersion.dll gittools/gitversion:5.1.4-linux-ubuntu-18.04-netcoreapp3.1 ${GV_GIT} > ${GV_JSON_DIR}/gitversion.json

###### generate env file ######

# create or clear file
GV_ENV_DIR=${GV_GEN}/env
mkdir -p ${GV_ENV_DIR}
> ${GV_ENV_DIR}/gitversion.env


# parse json and create sourceable file with git version infos
for s in $(cat ${GV_JSON_DIR}/gitversion.json | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ); do
  echo "export GitVersion_$s" >> $GV_ENV_DIR/gitversion.env
done

###### generate plain files ######

# create folder
GV_PLAIN_DIR=${GV_GEN}/plain
mkdir -p ${GV_PLAIN_DIR}

for s in $(cat ${GV_JSON_DIR}/gitversion.json | jq -r keys[] ); do
  > ${GV_PLAIN_DIR}/${s}
  echo $(cat ${GV_JSON_DIR}/gitversion.json | jq -r .${s} ) >> ${GV_PLAIN_DIR}/${s}
done

# change ownership to local user
chown -R user:user ${GV_GEN}

