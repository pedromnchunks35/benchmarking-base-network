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
- Put the current path associated to the variables $FABRIC_CA_CLIENT_HOME and $FABRIC_CA_HOME
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
- Now that we have the base for the peer, we can clone  the image and start from there to construct what we wish for a simple benchmarking
# Orderer
# Simple Network for the benchmarking
## peer1 (we are assuming that the client got established)
- Register peer1 identity
```
fabric-ca-client register -d -u https://localhost:7779 --id.type peer --id.affiliation org1.doctor --id.name peer1 --id.secret 12341234 --csr.names "C=PT,ST=Porto,L=Aliados,O=Hospital" --csr.hosts "192.168.1.100,peer1,127.0.0.1,172.17.0.2" --csr.cn peer1 --tls.certfiles tls-root-cert/tls-root-cert.pem --mspdir int-ca/iteradm/msp/
```
- Enroll peer1 identity
```
fabric-ca-client enroll -d -u https://peer1:12341234@192.168.1.78:7779 --id.type peer --id.affiliation org1.doctor  --csr.cn peer1 --csr.names "C=PT,ST=Porto,L=Aliados,O=Hospital" --csr.hosts "192.168.1.100,peer1,127.0.0.1" --tls.certfiles tls-root-cert/tls-root-cert.pem --mspdir ../../cryptographic-materials/peer1/msp/
```
- Register peer1 tls identity
```
fabric-ca-client register -d -u https://localhost:7777 --id.name peer1 --id.secret 12341234 --id.type peer --id.affiliation org1.doctor  --csr.names "C=PT,ST=Porto,L=Aliados,O=Hospital" --csr.cn peer1 --csr.hosts "192.168.1.100,peer1,127.0.0.1,172.17.0.2" --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --mspdir tls-ca/tlsadmin/msp/
```
- Enroll peer1 tls indentity
```
fabric-ca-client enroll -d -u https://peer1:12341234@192.168.1.78:7777 --id.type peer --id.affiliation org1.doctor  --csr.names "C=PT,ST=Porto,L=Aliados,O=Hospital" --csr.cn peer1 --csr.hosts "192.168.1.100,peer1,127.0.0.1,172.17.0.2" --tls.certfiles tls-cas/tls-root-ca.pem --mspdir ../tls-msp --enrollment.profile tls
```
- Register adm from org1 which must be from iter-org1
```
fabric-ca-client register -d -u https://localhost:7779 --id.name adm-iter --id.secret 12341234 --id.type admin --id.affiliation org1 --csr.names  "C=PT,ST=Porto,L=Aliados,O=Universidade do minho" --csr.cn peer1  --tls.certfiles tls-root-cert/tls-root-cert.pem --mspdir int-ca/iteradm/msp/
```
- Enroll adm from org1
```
fabric-ca-client enroll -d -u https://adm-iter:12341234@localhost:7779 --id.type admin --id.affiliation org1  --csr.names "C=PT,ST=Porto,L=Aliados,O=Universidade do minho" --csr.cn peer1  --tls.certfiles tls-root-cert/tls-root-cert.pem   --mspdir ../../cryptographic-materials/peer1/admin-msp
```
- Register tls profile for org1
```
fabric-ca-client register -d -u https://localhost:7777 --id.name adm --id.secret 12341234 --id.type admin --id.affiliation org1 --csr.names  "C=PT,ST=Porto,L=Aliados,O=Universidade do minho" --csr.cn peer1  --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp/
```
- Enroll tls profile for org1
```
fabric-ca-client enroll -d -u https://adm:12341234@localhost:7777  --id.type admin --id.affiliation org1 --csr.names  "C=PT,ST=Porto,L=Aliados,O=Universidade do minho" --csr.cn peer1  --tls.certfiles tls-root-cert/tls-root-cert.pem --mspdir tls-msp/admin/msp
```