# update with github
set -ex

pushd epic-kitchen-lstm
MODEL_HEAD=`git rev-parse HEAD`
if [ -n "${MODEL_VERSION}" ] && [ "${MODEL_VERSION}" != "${MODEL_HEAD}" ]; then
  git fetch
  git checkout ${MODEL_VERSION}
fi
popd