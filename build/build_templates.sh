#!/bin/bash

# author: 	Antje Janosch
# date:		2023-12-21

# this script copies all scripting templates from single files into one template file
# it adds repository / tag information

# expects input parameters:
# $1 - 	source folder of the single templates
#		has to follow the pattern /path/to/{scripting language}/{template type}/
#		e.g. /path/to/Python/snippets/
# $2 - destination folder for the template file

OIFS="$IFS"
IFS=$'\n'

SOURCE_FOLDER=$1
DEST_FOLDER=$2

SEARCH_PATTERN="# name: .*"

# for testing only
#TAG_REPO="# repository: scriptingRepo"
#TAG_RELEASE="# release: releaseTag"
REPO=$GITHUB_SERVER_URL/$GITHUB_REPOSITORY
RELEASE="test_build"
COMMIT=$GITHUB_SHA

TAG_REPO="# github_repository: $REPO"
TAG_RELEASE="# github_release: $RELEASE"
TAG_COMMIT="# github_sha: $COMMIT"

echo $TAG_REPO
echo $TAG_RELEASE
echo $TAG_COMMIT

echo "Build template file from $SOURCE_FOLDER"

TEMPLATE_FILES=`find $SOURCE_FOLDER -name *.txt -type f`

TYPE=`basename $SOURCE_FOLDER`
LANG=`basename $(dirname $SOURCE_FOLDER)`

DEST_FILE="${DEST_FOLDER}/${LANG}_${TYPE}_templates.txt"
echo $DEST_FILE

for file in $TEMPLATE_FILES; do
	echo "Processing template $file"
	sed "s/$SEARCH_PATTERN/&\n$TAG_REPO\n$TAG_RELEASE\n$TAG_COMMIT/" $file >> $DEST_FILE
	echo "" >> $DEST_FILE
	echo "" >> $DEST_FILE
done

TEMPLATE_PREVIEWS=`find $SOURCE_FOLDER -name *.png -type f`	

for file in $TEMPLATE_PREVIEWS; do
	echo "Copy $file"
	cp $file $DEST_FOLDER
done

IFS="$OIFS"
