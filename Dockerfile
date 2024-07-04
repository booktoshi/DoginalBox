# Multi-stage build setup
ARG OS_TYPE

# For Ubuntu 22.04
FROM ubuntu:22.04 as ubuntu

# Update and install necessary packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils \
    libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev \
    libdb5.3++-dev libdb5.3++ libdb5.3-dev libzmq3-dev libminiupnpc-dev curl nano git python3-pip jq

# Download and install Dogecoin binaries
RUN echo "Downloading and installing Dogecoin binaries..." && \
    curl -L https://github.com/dogecoin/dogecoin/releases/download/v1.14.7/dogecoin-1.14.7-x86_64-linux-gnu.tar.gz | tar -xz && \
    mv dogecoin-1.14.7/bin/* /usr/local/bin/

# Start the Dogecoin node and run for 90 seconds, then stop it
RUN echo "Starting Dogecoin node for initial setup..." && \
    dogecoind -daemon && \
    sleep 90 && \
    echo "Stopping Dogecoin node..." && \
    dogecoin-cli stop

# Create and configure dogecoin.conf
RUN echo "Creating and configuring dogecoin.conf..." && \
    mkdir -p /root/.dogecoin && \
    echo -e "rpcuser=user\nrpcpassword=pass\nrpcallowip=127.0.0.1\nmaxconnections=50\nrpcport=22555\nport=22556\nlisten=1\nserver=1\ndaemon=1\n" > /root/.dogecoin/dogecoin.conf

# Start the Dogecoin node again and wait for it to be fully synced
RUN echo "Starting Dogecoin node again..." && \
    dogecoind -daemon && \
    sleep 10 && \
    echo "Waiting for Dogecoin node to sync..." && \
    until dogecoin-cli getblockchaininfo | jq -e '.initialblockdownload == false'; do echo "Syncing..."; sleep 30; done

# Install NVM
RUN echo "Installing NVM..." && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Ensure NVM is sourced correctly
ENV NVM_DIR="/root/.nvm"
ENV NODE_VERSION="stable"
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION"

# Clone Doginals repository
RUN echo "Cloning Doginals repository..." && \
    git clone https://github.com/booktoshi/doginals.git /root/doginals

# Set the working directory
WORKDIR /root/doginals

# Install npm packages
RUN echo "Installing npm packages..." && \
    /bin/bash -c "source $NVM_DIR/nvm.sh && npm install"

# Create a new wallet
RUN echo "Creating a new Doginals wallet..." && \
    /bin/bash -c "source $NVM_DIR/nvm.sh && node . wallet new"

# Copy private key from .wallet.json and import it to Dogecoin node
RUN echo "Importing private key to Dogecoin node..." && \
    privateKey=$(cat .wallet.json | jq -r '.privkey') && \
    dogecoin-cli importprivkey $privateKey 'wallet1' false

# Sync the wallet to the node
RUN echo "Syncing the Doginals wallet to the Dogecoin node..." && \
    /bin/bash -c "source $NVM_DIR/nvm.sh && node . wallet sync"

# Copy and install Dunes Etcher
RUN echo "Setting up Dunes Etcher..." && \
    COPY doginals-main /root/doginals
WORKDIR /root/doginals/dunes-etcher
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && npm install"

# Create a new wallet for Dunes Etcher
RUN echo "Creating a new wallet for Dunes Etcher..." && \
    /bin/bash -c "source $NVM_DIR/nvm.sh && node . wallet new"

# Copy private key from .wallet.json and import it to Dogecoin node
RUN echo "Importing private key for Dunes Etcher to Dogecoin node..." && \
    privateKey=$(cat .wallet.json | jq -r '.privkey') && \
    dogecoin-cli importprivkey $privateKey 'wallet2' false

# Sync the wallet to the node
RUN echo "Syncing the Dunes Etcher wallet to the Dogecoin node..." && \
    /bin/bash -c "source $NVM_DIR/nvm.sh && node . wallet sync"

# Return to Doginals directory
WORKDIR /root/doginals

# Add a script to manage the state and timer
COPY manage.sh /usr/local/bin/manage.sh
RUN chmod +x /usr/local/bin/manage.sh

# Expose necessary ports
EXPOSE 22555 22556

# Start the state management script
CMD ["sh", "-c", "/usr/local/bin/manage.sh"]

# For Windows Server Core
FROM mcr.microsoft.com/windows/servercore:ltsc2022 as windows

# Set environment variables for Powershell
SHELL ["powershell", "-Command"]

# Update and install necessary packages
RUN Invoke-WebRequest -Uri https://aka.ms/vs/16/release/vs_buildtools.exe -OutFile vs_buildtools.exe ; \
    Start-Process -FilePath .\vs_buildtools.exe -ArgumentList '--quiet', '--wait', '--add', 'Microsoft.VisualStudio.Workload.VCTools', '--includeRecommended' -NoNewWindow -Wait ; \
    Remove-Item -Force vs_buildtools.exe

# Install Chocolatey
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install necessary tools and libraries using Chocolatey
RUN choco install -y git curl nano python3 jq

# Download and install Dogecoin binaries
RUN Invoke-WebRequest -Uri https://github.com/dogecoin/dogecoin/releases/download/v1.14.7/dogecoin-1.14.7-win64.zip -OutFile dogecoin.zip ; \
    Expand-Archive -Path dogecoin.zip -DestinationPath C:\dogecoin ; \
    Remove-Item -Force dogecoin.zip

# Add Dogecoin binaries to PATH
RUN $env:Path += ';C:\dogecoin\dogecoin-1.14.7\bin'

# Start the Dogecoin node and run for 90 seconds, then stop it
RUN echo "Starting Dogecoin node for initial setup..." && \
    Start-Process -FilePath 'dogecoind.exe' -ArgumentList '-daemon' -NoNewWindow ; \
    Start-Sleep -Seconds 90 && \
    echo "Stopping Dogecoin node..." && \
    Start-Process -FilePath 'dogecoin-cli.exe' -ArgumentList 'stop' -NoNewWindow -Wait

# Create and configure dogecoin.conf
RUN echo "Creating and configuring dogecoin.conf..." && \
    New-Item -Path 'C:\Users\ContainerAdministrator\AppData\Roaming\Dogecoin' -ItemType Directory -Force ; \
    Set-Content -Path 'C:\Users\ContainerAdministrator\AppData\Roaming\Dogecoin\dogecoin.conf' -Value "rpcuser=user`nrpcpassword=pass`nrpcallowip=127.0.0.1`nmaxconnections=50`nrpcport=22555`nport=22556`nlisten=1`nserver=1`ndaemon=1"

# Start the Dogecoin node again and wait for it to be fully synced
RUN echo "Starting Dogecoin node again..." && \
    Start-Process -FilePath 'dogecoind.exe' -ArgumentList '-daemon' -NoNewWindow ; \
    Start-Sleep -Seconds 10 && \
    echo "Waiting for Dogecoin node to sync..." && \
    while ((Invoke-WebRequest -Uri http://localhost:22555/rest/chaininfo.json).Content | ConvertFrom-Json).initialblockdownload -eq $true) { Write-Host "Syncing..."; Start-Sleep -Seconds 30 }

# Install NVM
RUN echo "Installing NVM..." && \
    Invoke-WebRequest -Uri https://github.com/coreybutler/nvm-windows/releases/download/1.1.9/nvm-setup.exe -OutFile nvm-setup.exe ; \
    Start-Process -FilePath .\nvm-setup.exe -ArgumentList '/S' -NoNewWindow -Wait ; \
    Remove-Item -Force nvm-setup.exe

# Install Node.js using NVM
RUN & "C:\Program Files\nvm\nvm.exe" install stable ; \
    & "C:\Program Files\nvm\nvm.exe" use stable

# Clone Doginals repository
RUN echo "Cloning Doginals repository..." && \
    git clone https://github.com/booktoshi/doginals.git C:\doginals

# Set the working directory
WORKDIR C:\doginals

# Install npm packages
RUN echo "Installing npm packages..." && \
    npm install

# Create a new wallet
RUN echo "Creating a new Doginals wallet..." && \
    node . wallet new

# Copy private key from .wallet.json and import it to Dogecoin node
RUN echo "Importing private key to Dogecoin node..." && \
    $wallet = Get-Content .wallet.json | ConvertFrom-Json; \
    $privateKey = $wallet.privkey; \
    Start-Process -FilePath 'dogecoin-cli.exe' -ArgumentList "importprivkey $privateKey 'wallet1' false" -NoNewWindow -Wait

# Sync the wallet to the node
RUN echo "Syncing the Doginals wallet to the Dogecoin node..." && \
    node . wallet sync

# Copy and install Dunes Etcher
RUN echo "Setting up Dunes Etcher..." && \
    COPY doginals-main\* C:\doginals
WORKDIR C:\doginals\dunes-etcher
RUN npm install

# Create a new wallet for Dunes Etcher
RUN echo "Creating a new wallet for Dunes Etcher..." && \
    node . wallet new

# Copy private key from .wallet.json and import it to Dogecoin node
RUN echo "Importing private key for Dunes Etcher to Dogecoin node..." && \
    $wallet = Get-Content .wallet.json | ConvertFrom-Json; \
    $privateKey = $wallet.privkey; \
    Start-Process -FilePath 'dogecoin-cli.exe' -ArgumentList "importprivkey $privateKey 'wallet2' false" -NoNewWindow -Wait

# Sync the wallet to the node
RUN echo "Syncing the Dunes Etcher wallet to the Dogecoin node..." && \
    node . wallet sync

# Return to Doginals directory
WORKDIR C:\doginals

# Add a script to manage the state and timer
COPY manage.ps1 C:\manage.ps1
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    ./manage.ps1

# Expose necessary ports
EXPOSE 22555 22556

# Start the state management script
CMD ["powershell.exe", "C:\\manage.ps1"]

# Select the appropriate stage based on OS_TYPE
FROM ${OS_TYPE}
