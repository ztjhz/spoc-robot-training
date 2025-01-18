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
#SBATCH --job-name=finetune_lora_with_last_action_success
#SBATCH --output=/home/FYP/tohj0037/spoc-robot-training/logs/output_%x_%j.out
#SBATCH --error=/home/FYP/tohj0037/spoc-robot-training/logs/error_%x_%j.err

### Your script for computation ###
echo "Job started on: $(date)"

source /home/FYP/tohj0037/miniconda3/bin/activate
conda activate spoc

export VULKAN_SDK=/home/FYP/tohj0037/vulkan-sdk/x86_64
export PATH=$VULKAN_SDK/bin:$PATH
export LD_LIBRARY_PATH=$VULKAN_SDK/lib:$LD_LIBRARY_PATH
export VK_LAYER_PATH=$VULKAN_SDK/share/vulkan/explicit_layer.d
export VK_ADD_LAYER_PATH=$VULKAN_SDK/share/vulkan/explicit_layer.d

export WANDB_API_KEY="<WANDB_API_KEY>"
export WANDB_NOTES="Finetune LoRA with last_action_success (freeze original + train embedding + train LoRA)"

export OBJAVERSE_DATA_BASE_DIR="objaverse_assets"
export OBJAVERSE_HOUSES_BASE_DIR="objaverse_houses"
export OBJAVERSE_DATA_DIR="objaverse_assets/2023_07_28"
export OBJAVERSE_HOUSES_DIR="objaverse_houses/houses_2023_07_28"
export PYTHONPATH="./"

cd /home/FYP/tohj0037/spoc-robot-training


python -m training.offline.train_pl \
  --max_samples 459816 \
  --eval_max_samples 100 \
  --eval_every 50 \
  --save_every 2000 \
  --model_version siglip_base_3_double_det \
  --sliding_window 100 \
  --per_gpu_batch 4 \
  --accumulate_grad_batches 1 \
  --lr 0.01 \
  --data_dir /home/FYP/tohj0037/spoc-robot-training/data/all \
  --dataset_version OBJECTNAV \
  --model EarlyFusionCnnTransformer \
  --input_sensors raw_navigation_camera raw_manipulation_camera last_actions an_object_is_in_hand \
 nav_task_relevant_object_bbox manip_task_relevant_object_bbox nav_accurate_object_bbox manip_accurate_object_bbox \
 last_action_success \
  --precision 16-mixed \
  --loss action \
  --max_epochs 400 \
  --output_dir /home/FYP/tohj0037/spoc-robot-training/train_logs \
  --num_nodes 1 \
  --wandb_logging True \
  --wandb_entity_name jinghua \
  --wandb_project_name fyp_spoc \
  --freeze_original True \
  --use_lora \
  --lora_target_modules self_attn multihead_attn linear1 linear2 \
  --init_model \
  --ckpt_dir /home/FYP/tohj0037/spoc-robot-training/pretrained_models/SigLIP-ViTb-3-double-det-CHORES-S \

echo "Job ended on: $(date)"
