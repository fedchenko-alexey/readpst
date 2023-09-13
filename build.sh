#! /bin/bash

set -e
set -x

git submodule update --init

yes | cp -rf gsf-config.h ./libgsf 
yes | cp -rf config.h ./libpst 

rm -rf build
mkdir build
pushd build

conan install .. --build=missing
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . -- -j

popd

cp build/bin/readpst ./
