FROM runpod/worker-comfyui:5.5.0-base

# Install system dependencies (git + build tools)
RUN apt-get update && apt-get install -y git build-essential python3-dev && rm -rf /var/lib/apt/lists/*

# Enable comfy command
RUN ln -s /comfyui/comfy/cli.py /usr/local/bin/comfy && chmod +x /usr/local/bin/comfy

# Install custom nodes
RUN comfy node install wavespeed@1.1.8
RUN comfy node install comfyui-custom-scripts@1.2.5
RUN comfy node install comfyui-post-processing-nodes@1.0.1
RUN comfy node install comfyui-wd14-tagger@1.0.1
RUN \ 
    comfy node install comfyui-easy-use@1.3.4 && \
    comfy node install comfyui-supir@1.0.2 && \
    comfy node install comfyui-florence2@1.0.6 && \
    comfy node install comfyui-rmbg@2.9.3 && \
    comfy node install rgthree-comfy && \
    comfy node install comfy-pack

# Install requirements for custom nodes
RUN for dir in /comfyui/custom_nodes/*; do \
  if [ -f "$dir/requirements.txt" ]; then pip install -r "$dir/requirements.txt"; fi; \
done

# Download models
RUN comfy model download --url https://huggingface.co/Kijai/flux-fp8/resolve/main/flux-vae-bf16.safetensors --relative-path models/vae --filename flux-vae-bf16.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/stable-diffusion-3.5-fp8/resolve/main/text_encoders/clip_l.safetensors --relative-path models/clip --filename clip_l.safetensors
RUN comfy model download --url https://huggingface.co/Kijai/SUPIR_pruned/resolve/main/SUPIR-v0F_fp16.safetensors --relative-path models/checkpoints --filename SUPIR-v0F_fp16.safetensors
RUN comfy model download --url https://huggingface.co/Kijai/SUPIR_pruned/resolve/main/SUPIR-v0Q_fp16.safetensors --relative-path models/checkpoints --filename SUPIR-v0Q_fp16.safetensors
RUN comfy model download --url https://huggingface.co/grilder/Jib_Mix_Realistic_XL/resolve/main/jibMixRealisticXL_v10Lightning46Step.safetensors --relative-path models/checkpoints --filename jibMixRealisticXL_v10Lightning46Step.safetensors
RUN comfy model download --url https://huggingface.co/lllyasviel/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors --relative-path models/clip --filename t5xxl_fp16.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/flux1-kontext-dev_ComfyUI/resolve/main/split_files/diffusion_models/flux1-dev-kontext_fp8_scaled.safetensors --relative-path models/unet --filename flux1-dev-kontext_fp8_scaled.safetensors
