FROM continuumio/miniconda3

# Set up the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Create conda environment
RUN conda create -n hardware_agent python=3.10.13 && \
    echo "source activate hardware_agent" > ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc && conda activate hardware_agent"

# install dependencies
RUN /bin/bash -c "pip install -e . && pip install pypdf PILLOW network matplotlib pydantic==2.10.1 \
    langchain==0.3.14 langchain_openai==0.2.14 langchain_community==0.3.14 \
    chromadb==0.4.24 IPython markdownify sentence_transformers==2.7.0 \
    chainlit"

# Install necessary build tools and pip
RUN apt-get update && \
    apt-get install -y git autoconf gperf build-essential flex bison && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install prerequisite tools
RUN git clone https://github.com/steveicarus/iverilog.git && cd iverilog \
    && sh ./autoconf.sh && ./configure --prefix=/usr/local && make -j4 && make install

# Set environment variables
ENV PATH=/usr/local

# Set environment variables
ENV PYTHONPATH=/app:$PYTHONPATH