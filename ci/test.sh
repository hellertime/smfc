#!/bin/bash
set -e
set -x

this_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
proj_dir=$(realpath ${this_dir}/../)

. /etc/os-release

CMAKE="cmake"
case ${ID} in
  centos|rhel)
    MAJOR_VERSION="$(echo $VERSION_ID | cut -d. -f1)"
    if test $MAJOR_VERSION = 7 ; then
      CMAKE="cmake3"
      source /opt/rh/devtoolset-8/enable
    fi
esac

: ${BUILD_GENERATOR:="Unix Makefiles"}
build_cmd="make VERBOSE=1"
if [ "${BUILD_GENERATOR}" = "Ninja" ]; then
  build_cmd="ninja -v"
fi

# setup temp dirs
build_dir=$(mktemp -d)
trap "rm -rf ${build_dir}" EXIT

(
  cd ${build_dir}
  ${CMAKE} -G"${BUILD_GENERATOR}" ${proj_dir}
  ${build_cmd} -j$(nproc)
  ls -l bin
  ldd bin/smf_demo_server | grep smf-deps-install
  ldd bin/smf_demo_server | grep -v smf-deps-install
)