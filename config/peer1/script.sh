#!/bin/bash

docker run \
  --name peer1 \
  -p 7051:7051 \
  -p 9443:9443  \
  -e FABRIC_CFG_PATH=/tmp/hyperledger/org1/peer1/config\
  -e CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock \
  -e FABRIC_LOGGING_SPEC=debug \
  -e CORE_PEER_GOSSIP_SKIPHANDSHAKE=true \
  -v /var/run:/var/run \
  -v /home/peer/peer:/tmp/hyperledger/org1/peer1 \
  -w /tmp/hyperledger/org1/peer1\
   hyperledger/fabric-peer