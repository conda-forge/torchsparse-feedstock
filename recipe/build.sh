#!/usr/bin/env bash

if [[ "$cuda_compiler_version" == "None" ]]; then
  export FORCE_CUDA=0
else
  export FORCE_CUDA=1
fi

${PYTHON} -m pip install . -vv
