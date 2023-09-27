#!/bin/bash

docker run \
  -d \
  --name peer2 \
  -p 7051:7051 \
  -p 9443:9443  \
  -e FABRIC_CFG_PATH=/tmp/hyperledger/org1/peer2/config\
  -e CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock \
  -e FABRIC_LOGGING_SPEC=debug \
  -e CORE_PEER_GOSSIP_SKIPHANDSHAKE=true \
  -v /var/run:/var/run \
  -v /home/peer/peer:/tmp/hyperledger/org1/peer2 \
  -w /tmp/hyperledger/org1/peer2\
   hyperledger/fabric-peer