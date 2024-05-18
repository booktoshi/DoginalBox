#!/bin/bash

# Start the Dogecoin node
dogecoind -daemon

# Wait for the node to start
sleep 10

# Check the node status
dogecoin-cli getblockchaininfo

# Keep the script running
while true; do
    sleep 60
    echo "Dogecoin node is running..."
done
