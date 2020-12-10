#!/usr/bin/zsh
set -ex

if [ ! -d "/data/epic-kitchens-100-annotations" ]
then
	git clone https://github.com/epic-kitchens/epic-kitchens-100-annotations.git
fi

if [ ! -d "/data/epic-kitchen-all" ]
then
	pushd /data/epic-kitchen-all
	aws s3 cp --recursive s3://geniehai/jackiey/dataset/ ./
	for a in *.tar
	do
	    echo $a
	    a_dir=`expr $a : '\(.*\).tar'`
	    mkdir $a_dir
	    tar -xf $a -C . --no-same-owner
	    rm $a
	done
	popd
fi