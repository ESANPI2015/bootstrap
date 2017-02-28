#!/bin/sh
set -e

# location where the "default.xml" for the repo tool lives
REPO_MANIFEST_SERVER=https://github.com/ESANPI2015
REPO_MANIFEST_REPO=bootstrap.git
REPO_MANIFEST_URL=$REPO_MANIFEST_SERVER/$REPO_MANIFEST_REPO
REPO_MANIFEST_BRANCH=master

# setup our exit-handler
exit_handler()
{
    trap - INT TERM EXIT
    # just to be sure that we are where we started
    cd "$THIS_SCRIPT_CALLED_FROM_DIR"
    echo ""
    echo "problem occured. unkown state. consider removing '${TARGET_DIR}'."
    echo ""
    exit
}
# now the trap is armed
trap exit_handler INT TERM EXIT

# keep this as directory to get back into after an error
THIS_SCRIPT_CALLED_FROM_DIR=`pwd`

# having default location, can be overridden by the first argument
TARGET_NAME=${1:-mydevfolder}
TARGET_DIR=$(readlink --canonicalize ${TARGET_NAME})

# creating a directory if the directory is not present
if [ ! -d "${TARGET_DIR}" ]; then
    mkdir --verbose --parents "${TARGET_DIR}"
else
    echo "the folder '${TARGET_DIR}' already exists, will not proceed"
    exit
fi

cd "$TARGET_DIR"

# the "repo" tool. only downloaded+initialized once in the beginning
REPO=repo
REPO_BIN=$(readlink --canonicalize $TARGET_DIR/$REPO)

# Downloading repo and making it into an executable file. at first: check that
# the file is present
if [ ! -x "$REPO_BIN" ]; then
    echo "downloading the '$REPO' tool into '$REPO_BIN'"
    wget http://commondatastorage.googleapis.com/git-repo-downloads/repo -P $TARGET_DIR
    chmod a+x "$REPO_BIN"
else
    echo "the file '$REPO_BIN' already exists, will not proceed"
    exit
fi

# initialing the repo tool
${REPO_BIN} init \
    --manifest-url=${REPO_MANIFEST_URL} \
    --manifest-branch=${REPO_MANIFEST_BRANCH}
# downloading content
${REPO_BIN} sync

# just to be sure that we are where we started
cd "$THIS_SCRIPT_CALLED_FROM_DIR"

# removing the added traps allows normal exiting
trap - INT TERM EXIT

echo "all is good. bootstrap placed in '${TARGET_DIR}'"
