# Scenario 1
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
- Register tls profile for org1 adm
```
fabric-ca-client register -d -u https://localhost:7777 --id.name adm --id.secret 12341234 --id.type admin --id.affiliation org1 --csr.names  "C=PT,ST=Porto,L=Aliados,O=Universidade do minho" --csr.cn peer1  --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp/ --enrollment.profile tls
```
- Enroll tls profile for org1 adm
```
fabric-ca-client enroll -d -u https://adm:12341234@localhost:7777  --id.type admin --id.affiliation org1 --csr.names  "C=PT,ST=Porto,L=Aliados,O=Universidade do minho" --csr.cn peer1  --tls.certfiles tls-root-cert/tls-root-cert.pem --mspdir tls-msp/admin/msp --enrollment.profile tls
```
- After generating all of this cryptographic material, we can put it in the destinated vm, and the tree will be something like this:
```
├── admin-msp
│   ├── cacerts
│   │   └── localhost-7779.pem
│   ├── intermediatecerts
│   │   └── localhost-7779.pem
│   ├── IssuerPublicKey
│   ├── IssuerRevocationPublicKey
│   ├── keystore
│   │   └── key.pem
│   ├── signcerts
│   │   └── cert.pem
│   └── user
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
│   ├── basic.tar.gz
│   └── core.yaml
├── data-vault
├── install-fabric.sh
├── msp
│   ├── cacerts
│   │   └── 192-168-1-78-7779.pem
│   ├── intermediatecerts
│   │   └── 192-168-1-78-7779.pem
│   ├── IssuerPublicKey
│   ├── IssuerRevocationPublicKey
│   ├── keystore
│   │   └── key.pem
│   ├── signcerts
│   │   └── cert.pem
│   └── user
├── snapshots
├── tls-msp
│   ├── cacerts
│   ├── IssuerPublicKey
│   ├── IssuerRevocationPublicKey
│   ├── keystore
│   │   └── key.pem
│   ├── signcerts
│   │   └── cert.pem
│   ├── tlscacerts
│   │   └── tls-192-168-1-78-7777.pem
│   └── user
└── tls-msp-admin
    ├── cacerts
    │   └── localhost-7777.pem
    ├── IssuerPublicKey
    ├── IssuerRevocationPublicKey
    ├── keystore
    │   └── key.pem
    ├── signcerts
    │   └── cert.pem
    └── user
```
- After this, we will configure a script to start the container, opening all  of the  necessary ports for establishing metrics and also configure the core.yaml file
## orderer1
- Register msp for orderer
```
fabric-ca-client register -d -u https://localhost:7779 --id.name orderer --id.secret 12341234 --id.type orderer --csr.cn orderer --csr.names "C=PT,ST=Porto,L=Aliados,O=Universidade do minho" --csr.hosts "192.168.1.101,orderer,127.0.0.1,localhost" --tls.certfiles tls-root-cert/tls-root-cert.pem --mspdir int-ca/iteradm/msp
```
- Enroll msp for orderer
```
fabric-ca-client enroll -d -u https://orderer:12341234@192.168.1.78:7779  --id.type orderer --csr.cn orderer --csr.names "C=PT,ST=Porto,L=Aliados,O=Universidade do minho" --csr.hosts "192.168.1.101,orderer,127.0.0.1,localhost" --tls.certfiles tls-root-cert/tls-root-cert.pem --mspdir ../../cryptographic-materials/orderer1/msp
```
- register orderer tls
```
fabric-ca-client register -d -u https://localhost:7777 --id.name orderer --id.secret 12341234 --id.type orderer --csr.cn orderer --csr.names "C=PT,ST=Porto,L=Aliados,O=Universidade do minho" --csr.hosts "192.168.1.101,orderer,127.0.0.1,localhost" --tls.certfiles tls-root-cert/tls-root-cert.pem --mspdir tls-ca/iteradm/msp
```
- enroll orderer tls