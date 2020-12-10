#!/usr/bin/zsh
set -ex

if [ ! -d "./epic-kitchen-lstm/pretrained" ]
then
	mkdir -p ./epic-kitchen-lstm/pretrained
	pushd epic-kitchen-lstm
	aws s3 cp --recursive s3://geniehai/jackiey/pretrained/ ./pretrained/
	popd
fi