#!/bin/bash

### TC1 Job Script ###
 
#SBATCH --partition=UGGPU-TC1
#SBATCH --qos=normal
#SBATCH --gres=gpu:1

### Specify Memory allocate to this job ###
#SBATCH --mem=64G

### Specify number of core (CPU) to allocate to per node ###
#SBATCH --ntasks-per-node=1

### Specify number of node to compute ###
#SBATCH --nodes=20

### Optional: Specify node to execute the job ###
### Remove 1st # at next line for the option to take effect ###
##SBATCH --nodelist=TC1N07

### Specify Time Limit, format: <min> or <min>:<sec> or <hr>:<min>:<sec> or <days>-<hr>:<min>:<sec> or <days>-<hr> ### 
#SBATCH --time=360

### Specify name for the job, filename format for output and error ###
#SBATCH --job-name=eval_pretrained_model
#SBATCH --output=/home/FYP/tohj0037/spoc-robot-training/logs/output_%x_%j.out
#SBATCH --error=/home/FYP/tohj0037/spoc-robot-training/logs/error_%x_%j.err

### Your script for computation ###
source /home/FYP/tohj0037/miniconda3/bin/activate
conda activate spoc

export VULKAN_SDK=/home/FYP/tohj0037/vulkan-sdk/x86_64
export PATH=$VULKAN_SDK/bin:$PATH
export LD_LIBRARY_PATH=$VULKAN_SDK/lib:$LD_LIBRARY_PATH
export VK_LAYER_PATH=$VULKAN_SDK/share/vulkan/explicit_layer.d
export VK_ADD_LAYER_PATH=$VULKAN_SDK/share/vulkan/explicit_layer.d

cd /home/FYP/tohj0037/spoc-robot-training
bash scripts/eval_pretrained_model.sh
