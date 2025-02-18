# 1. Use an NVIDIA CUDA base image for Ubuntu 20.04.
FROM nvidia/cuda:11.7.1-base-ubuntu20.04

# 2. Update package lists, install software-properties-common (needed for adding PPAs),
#    add the deadsnakes PPA for Python 3.12 packages, update again,
#    then install Python 3.12, its venv, pip, git, build-essential, libgl1-mesa-glx (for OpenCV),
#    and clang (required for compiling or processing prompts).
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install -y \
        python3.12 \
        python3.12-venv \
        python3-pip \
        git \
        build-essential \
        libgl1-mesa-glx \
        clang \
    && rm -rf /var/lib/apt/lists/*

# 3. Set the working directory inside the container to /app.
WORKDIR /app

# 4. Copy the entire exo repository (all files) into /app.
COPY . /app

# 5. Create a virtual environment using Python 3.12, activate it, upgrade pip,
#    and install exo from source in editable mode.
RUN python3.12 -m venv .venv && \
    . .venv/bin/activate && \
    python3.12 -m pip install --upgrade pip && \
    python3.12 -m pip install llvmlite && \
    python3.12 -m pip install -e . 

# 6. Expose port 52415 used by exo's ChatGPT-like WebUI.
EXPOSE 52415

# 7. Set the default command to run exo from the virtual environment.
CMD [".venv/bin/exo"]
