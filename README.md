
# NODE RUNNER Dogecoin Node Docker Setup

![Dogecoin Logo](path/to/logo.png)

## Overview

This setup provides a Docker container that installs and configures a Dogecoin node, along with several utilities, and resumes installation even after a system restart. The container will detect the operating system and install the Dogecoin node accordingly.

## Prerequisites

- Docker
- Docker Compose

### What is Docker?

Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow a developer to package up an application with all parts it needs, such as libraries and other dependencies, and ship it all out as one package.

### What is Docker Compose?

Docker Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application's services. Then, with a single command, you create and start all the services from your configuration.

## Instructions

### Step 1: Install Docker and Docker Compose

#### For Windows and Mac:

1. Download Docker Desktop from [Docker's official website](https://www.docker.com/products/docker-desktop).
2. Follow the installation instructions for your operating system.
3. Once installed, Docker and Docker Compose come bundled together.

#### For Linux:

1. Install Docker:

   ```sh
   sudo apt-get update
   sudo apt-get install \
       apt-transport-https \
       ca-certificates \
       curl \
       gnupg \
       lsb-release

   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

   echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

   sudo apt-get update
   sudo apt-get install docker-ce docker-ce-cli containerd.io
   ```

2. Install Docker Compose:

   ```sh
   sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   ```

3. Verify the installation:

   ```sh
   docker --version
   docker-compose --version
   ```

### Step 2: Clone the Repository

Clone the repository containing the Docker setup files:

```sh
git clone https://github.com/yourusername/dogecoin-node-setup.git
cd dogecoin-node-setup
```

### Step 3: Build the Docker Image

To build the Docker image, run the following command:

```sh
docker build -t dogecoin-node .
```

### Step 4: Run the Docker Container

To start the Docker container, run the following command:

```sh
docker-compose up -d
```

### Step 5: Verify Dogecoin Node Status

To check the status of the Dogecoin node, run the following command:

```sh
docker exec -it dogecoin_node dogecoin-cli getblockchaininfo
```

## Utilities Included

The following utilities are included and cloned into the doginals directory:

- APE DUNES GUI
- APE Image Converter
- BC Auto Scripts
- BC Snapshot
- BCxHeim Recurse
- BP MetaData Merger
- BP TelegramBot
- SirDuney DUNES

## Resuming Installation

If the Docker container is stopped or the system is restarted, the installation can be resumed by starting the container again:

```sh
docker-compose up -d
```

The state management script will ensure that the Dogecoin node starts and the installation resumes as needed.

## Adding Pictures

To add pictures, place your images in the appropriate directory and reference them in this README file as shown below:

```markdown
![Alt Text](path/to/image.png)
```

## Troubleshooting

If you encounter any issues, check the logs for more details:

```sh
docker logs dogecoin_node
```

For further assistance, consult the documentation for Docker and Docker Compose.

This setup ensures a smooth installation and configuration of a Dogecoin node with additional utilities, while handling system restarts gracefully.
