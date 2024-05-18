# Use the official Ubuntu 22.04 as a base image
FROM ubuntu:22.04

# Update and install necessary packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils \
    libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev \
    libdb5.3++-dev libdb5.3++ libdb5.3-dev libzmq3-dev libminiupnpc-dev curl nano git python3-pip

# Download and install Dogecoin binaries
RUN curl -L https://github.com/dogecoin/dogecoin/releases/download/v1.14.7/dogecoin-1.14.7-x86_64-linux-gnu.tar.gz | tar -xz && \
    mv dogecoin-1.14.7/bin/* /usr/local/bin/

# Start the Dogecoin node and run for 60 seconds, then stop it
RUN dogecoind -daemon && \
    sleep 60 && \
    dogecoin-cli stop

# Create and configure dogecoin.conf
RUN mkdir -p /root/.dogecoin && \
    echo -e "rpcuser=user\nrpcpassword=pass\nrpcallowip=127.0.0.1\nmaxconnections=50\nrpcport=22555\nport=22556\nlisten=1\nserver=1\ndaemon=1\n" > /root/.dogecoin/dogecoin.conf

# Install NVM and Node.js
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    bash -c "source /root/.bashrc && nvm install stable"

# Clone Doginals repository
RUN git clone https://github.com/booktoshi/doginals.git /root/doginals

# Set the working directory
WORKDIR /root

# Add a script to manage the state and timer
COPY manage.sh /usr/local/bin/manage.sh
RUN chmod +x /usr/local/bin/manage.sh

# Start the state management script
CMD ["sh", "-c", "/usr/local/bin/manage.sh"]
