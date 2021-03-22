#!/bin/bash
set -o errexit   # abort on nonzero exitstatus
set -o pipefail  # don't hide errors within pipes

if [ ! -z "$GIT_PATH" ]; then
  GIT=$(realpath ${GIT_PATH})
else
  GIT="/git"
fi

if [ ! -z "$GEN_PATH" ]; then
  GEN=$(realpath ${GEN_PATH})
else
  GEN="/gen"
fi

# check if /git is a git repository
if [ ! -d "${GIT}" ]; then
  echo "No git repository supplied. use docker -v PATH_TO_YOUR_REPO:${GIT}"
  exit 1
fi

# for detached branches we checkout GIT_BRANCH explicitly
if [ ! -z "${GIT_BRANCH}" ]; then
  cd ${GIT}
  git checkout ${GIT_BRANCH}
  cd -
fi

if [ -z "${USERID}" ]; then
  echo "No user id supplied. Using default id '9001'"
  USERID=9001
fi

adduser -s /bin/bash -D -H -u ${USERID} user

if [ -z "$DEFAULT_BRANCH" ]; then
  DEFAULT_BRANCH=master
fi
sed 's?@@MASTER@@?'${DEFAULT_BRANCH}'?g' /tools/GitVersion.yaml > /tmp/GitVersion.yaml

###### generate json ######

# generate json file with git version infos
JSON_DIR=${GEN}/json
mkdir -p ${JSON_DIR}
/tools/dotnet-gitversion ${GIT} /config /tmp/GitVersion.yaml > ${JSON_DIR}/gitversion.json

###### append branch version to json ######
if [ "$(cat ${JSON_DIR}/gitversion.json | jq -r .BranchName)" == "${DEFAULT_BRANCH}" ]; then
    targetVersion="FullSemVer"
else
    targetVersion="InformationalVersion"
fi
targetVersionInfo=$(cat ${JSON_DIR}/gitversion.json | jq -r .${targetVersion})
cat ${JSON_DIR}/gitversion.json | jq --arg value ${targetVersionInfo} '.+{BranchVersion: $value }' > /tmp/gitversion2.json
targetVersionInfoDockerLabel=$(sed 's/+/-/g' <<< ${targetVersionInfo})
cat /tmp/gitversion2.json | jq --arg value ${targetVersionInfoDockerLabel} '.+{BranchVersionDockerLabel: $value }' > /tmp/gitversion3.json
fullSemVerDockerLabel=$(sed 's/+/-/g' <<< $(cat ${JSON_DIR}/gitversion.json | jq -r .FullSemVer))
cat /tmp/gitversion3.json | jq --arg value ${fullSemVerDockerLabel} '.+{FullSemVerDockerLabel: $value }' > ${JSON_DIR}/gitversion.json

###### generate env file ######

# create or clear file
ENV_DIR=${GEN}/env
mkdir -p ${ENV_DIR}
> ${ENV_DIR}/gitversion.env

# parse json and create sourceable file with git version infos
for s in $(cat ${JSON_DIR}/gitversion.json | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ); do
  if [ "${VERBOSE}" == "1" ]; then
    echo "GitVersion_$s"
  fi
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

###### generate cpp header file ######

# create folder
CPP_DIR=${GEN}/cpp
mkdir -p ${CPP_DIR}

# control paramaters to generate the cpp header file
TEMPLATE_FILE=/tools/templates/cpp/version.h.j2
INPUT_FILE=${JSON_DIR}/gitversion.json
OUTPUT_DIR=${CPP_DIR}/elbb
mkdir -p ${OUTPUT_DIR}
OUTPUT_FILE=${OUTPUT_DIR}/version.h

# generate cpp header file
/tools/gen_cpp_header/gen_version_header.py ${TEMPLATE_FILE} ${INPUT_FILE} ${OUTPUT_FILE}

# change ownership to local user
chown -R user:user ${GEN}

echo "Generation complete."
