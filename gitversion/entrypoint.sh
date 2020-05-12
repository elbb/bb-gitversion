#!/bin/bash
set -o errexit   # abort on nonzero exitstatus
set -o pipefail  # don't hide errors within pipes

if [ ! -z "$GIT_PATH" ]; then
  # using eval to determine if input is a command or a directory
  d=$(eval "$GIT_PATH" 2> /dev/null)
  # directory
  if [ "$?" != "0" ]; then
    p=${GIT_PATH}
  # command
  else
    echo GIT_PATH is a command.
    p=${d}
  fi
  # create path if not existent
  [ ! -d "$p" ] &&  echo creating ${p} && mkdir -p ${p}
  GIT=${p}
else
  # fallback
  GIT="/git"
fi

if [ ! -z "$GEN_PATH" ]; then
  # using eval to determine if input is a command or a directory
  d=$(eval "$GEN_PATH" 2> /dev/null)
  # directory
  if [ "$?" != "0" ]; then
    p=${GEN_PATH}
  # command
  else
    echo GEN_PATH is a command.
    p=${d}
  fi
  # create path if not existent
  [ ! -d "$p" ] &&  echo creating ${p} && mkdir -p ${p}
  GEN=${p}
else
  # fallback
  GEN="/gen"
fi


# check if /git is a git repository
if [ ! -d "/git" ]; then
  echo "No git repository supplied. use docker -v PATH_TO_YOUR_REPO:/git"
  exit 1
fi

if [ -z "${USERID}" ]; then
  echo "No user id supplied. Using default id '9001'"
  USERID=9001
fi

useradd --shell /bin/bash -u ${USERID} -o -c "" -m user

###### generate json ######

# generate json file with git version infos
JSON_DIR=${GEN}/json
mkdir -p ${JSON_DIR}
dotnet /app/GitVersion.dll gittools/gitversion:5.1.4-linux-ubuntu-18.04-netcoreapp3.1 ${GIT} > ${JSON_DIR}/gitversion.json

###### generate env file ######

# create or clear file
ENV_DIR=${GEN}/env
mkdir -p ${ENV_DIR}
> ${ENV_DIR}/gitversion.env


# parse json and create sourceable file with git version infos
for s in $(cat ${JSON_DIR}/gitversion.json | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ); do
  echo "export GitVersion_$s" >> $ENV_DIR/gitversion.env
done

###### generate plain files ######

# create folder
PLAIN_DIR=${GEN}/plain
mkdir -p ${PLAIN_DIR}

for s in $(cat ${JSON_DIR}/gitversion.json | jq -r keys[] ); do
  > ${PLAIN_DIR}/${s}
  echo $(cat ${JSON_DIR}/gitversion.json | jq -r .${s} ) >> ${PLAIN_DIR}/${s}
done

# change ownership to local user
chown -R user:user ${GEN}

echo "Generation complete."