#!/usr/bin/env bash

# Dynamic libraries need to be lazily loaded so that torch
# can be imported on system without a GPU
LDFLAGS="${LDFLAGS//-Wl,-z,now/-Wl,-z,lazy}"

if [[ "$cuda_compiler_version" == "None" ]]; then
  export FORCE_CUDA=0
else
  export CUDA_NVCC_FLAGS="$CUDA_NVCC_FLAGS -O3"
  if [[ ${cuda_compiler_version} == 11.8* ]]; then
      export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9+PTX"
  else
      echo "unsupported cuda version. edit build.sh"
      exit 1
  fi
  export FORCE_CUDA=1
fi

${PYTHON} -m pip install . -vv
