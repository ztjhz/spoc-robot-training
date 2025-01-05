#!/bin/bash

### TC1 Job Script ###
 
#SBATCH --partition=UGGPU-TC1
#SBATCH --qos=normal
#SBATCH --gres=gpu:1

### Specify Memory allocate to this job ###
#SBATCH --mem=64G

### Specify number of core (CPU) to allocate to per node ###
#SBATCH --ntasks-per-node=1

#SBATCH --cpus-per-task=20 

### Specify number of node to compute ###
#SBATCH --nodes=1

### Optional: Specify node to execute the job ###
### Remove 1st # at next line for the option to take effect ###
##SBATCH --nodelist=TC1N07

### Specify Time Limit, format: <min> or <min>:<sec> or <hr>:<min>:<sec> or <days>-<hr>:<min>:<sec> or <days>-<hr> ### 
#SBATCH --time=360

### Specify name for the job, filename format for output and error ###
#SBATCH --job-name=eval_baseline
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

export WANDB_API_KEY="<WANDB_API>"
export WANDB_NOTES="Eval baseline"

export OBJAVERSE_DATA_BASE_DIR="objaverse_assets"
export OBJAVERSE_HOUSES_BASE_DIR="objaverse_houses"
export OBJAVERSE_DATA_DIR="objaverse_assets/2023_07_28"
export OBJAVERSE_HOUSES_DIR="objaverse_houses/houses_2023_07_28"
export PYTHONPATH="./"

cd /home/FYP/tohj0037/spoc-robot-training


python -m training.offline.online_eval \
  --shuffle \
  --eval_subset minival \
  --output_basedir eval_log \
  --test_augmentation \
  --task_type ObjectNavType \
  --input_sensors raw_navigation_camera raw_manipulation_camera last_actions an_object_is_in_hand \
 nav_task_relevant_object_bbox manip_task_relevant_object_bbox nav_accurate_object_bbox manip_accurate_object_bbox \
  --house_set objaverse \
  --num_workers 5 \
  --gpu_devices 0 \
  --wandb_logging True \
  --wandb_entity_name jinghua \
  --wandb_project_name fyp_spoc \
  --training_run_id aifda3fp \
  --ckptStep 26000 \
