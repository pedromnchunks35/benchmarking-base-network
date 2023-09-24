#!/bin/bash
docker run \
  -d \
  --name orderer \
  -e FABRIC_CFG_PATH=/tmp/hyperledger/deploy-orderer/config \
  -p 7050:7050 \
  -p 7053:7053 \
  -p 9443:9443 \
  -v /home/orderer/orderer:/tmp/hyperledger/deploy-orderer/ \
  hyperledger/fabric-orderer