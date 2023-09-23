# Info
- This  repository is meanted to create a base for creating peers and orderers in the context of hyper ledger fabric network
- This will be created inside of virtual machines but we can indeed export the image and replicate
- The configurations will open the ports for the listening of the components metrics 
# Requirements
- We will create 2 vm's
- The os will be a debian
- We already have ca's setted
- We need couch-db instances for the peers
- We should have  a client to generate cryptographic materials againsour CAS
# Peer
- Firstly we changed the network configuration file just for having the right  ip addressin place. In ubuntu, we can e easily do this  by accessing: /etc/netplan. Edit the file in there and add a ip like this:
```
    # This is the network config written by 'subiquity'
network:
  ethernets:
    enp0s3:
      dhcp4: true
      addresses: [192.168.1.100/24]
  version: 2
```
- We should  install go,peer image of fabric, fabric binaries and  couch-db
- This is the base tree configuration
```
├── bin
│   ├── configtxgen
│   ├── configtxlator
│   ├── cryptogen
│   ├── discover
│   ├── fabric-ca-client
│   ├── fabric-ca-server
│   ├── ledgerutil
│   ├── orderer
│   ├── osnadmin
│   └── peer
├── chaincode
├── config
├── data-vault
├── install-fabric.sh
└── snapshots
```
