#!/usr/bin/zsh
set -ex

if [ ! -d "./epic-kitchen-lstm/pretrained" ]
then
	pushd epic-kitchen-lstm
	aws s3 cp --recursive s3://geniehai/jackiey/pretrained/ ./pretrained/
	popd
fi