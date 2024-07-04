#!/bin/bash

# Detect OS type
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS_TYPE="ubuntu"
elif [[ "$OSTYPE" == "msys" ]]; then
    OS_TYPE="windows"
else
    echo "Unsupported OS type"
    exit 1
fi

# Build Docker image
docker build --build-arg OS_TYPE=$OS_TYPE -t doginals .
