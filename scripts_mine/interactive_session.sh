#!/bin/bash

# Request an interactive session with a GPU
salloc \
  --partition=UGGPU-TC1 \
  --qos=normal \
  --gres=gpu:1 \
  --mem=64G \
  --ntasks-per-node=1 \
  --nodes=1 \
  --time=360
