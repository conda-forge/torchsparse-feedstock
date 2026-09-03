#!/usr/bin/env bash

# Dynamic libraries need to be lazily loaded so that torch
# can be imported on system without a GPU
LDFLAGS="${LDFLAGS//-Wl,-z,now/-Wl,-z,lazy}"

if [[ "$cuda_compiler_version" == "None" ]]; then
  export FORCE_CUDA=0
else
  export CUDA_NVCC_FLAGS="$CUDA_NVCC_FLAGS -O3"
  # CF_TORCH_CUDA_ARCH_LIST is set by pytorch's activation scripts to match the arch list pytorch was built with.
  # See https://github.com/conda-forge/pytorch-cpu-feedstock/blob/main/recipe/activate.sh
  if [[ -z "${CF_TORCH_CUDA_ARCH_LIST:-}" ]]; then
    echo "CF_TORCH_CUDA_ARCH_LIST is not set. Ensure the correct pytorch is installed and its activation scripts have run."
    exit 1
  fi
  export TORCH_CUDA_ARCH_LIST="${CF_TORCH_CUDA_ARCH_LIST}"
  echo "TORCH_CUDA_ARCH_LIST is set to ${TORCH_CUDA_ARCH_LIST}"
  export FORCE_CUDA=1
fi

${PYTHON} -m pip install . -vv
