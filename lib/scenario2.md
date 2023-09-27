# Scenario 2
- Adding one peer (peer2 to the same organization)
- In order to achieve this, we can use the peer base that we just created in the vm..then we must create the cryptography materials 
- The ip address for the Scenario 2 will be 192.168.1.230
## Install couchdb instance for this new peer machine
```
sudo docker run \
    -d \
    -p 5989:5984 \
    -e COUCHDB_BIND_ADDRESS=127.0.0.1 \
    -e COUCHDB_USER=admin \
    -e COUCHDB_PASSWORD=12341234 \
    -v /home/peer/couchdb:/opt/couchdb/data \
    --name couchdb \
    couchdb

 curl -X PUT http://admin:12341234@localhost:5989/_users
 curl -X PUT http://admin:12341234@127.0.0.1:5989/_replicator
 curl -X PUT http://admin:12341234@localhost:5989/_global_changes
```
## Install cadvisor instance as well
```
docker run -d --name=cadvisor -p 8080:8080 --volume=/:/rootfs:ro --volume=/var/run:/var/run:ro --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro google/cadvisor
```
## Generate cryptographic materials
- Register the msp of the peer
```
fabric-ca-client register -d -u https://localhost:7779 --id.type peer --id.affiliation org1.doctor --id.name peer2 --id.secret 12341234 --csr.names "C=PT,ST=Porto,L=Aliados,O=Hospital" --csr.hosts "192.168.1.230,peer2,127.0.0.1" --csr.cn peer2 --tls.certfiles tls-root-cert/tls-root-cert.pem --mspdir int-ca/iteradm/msp/
```
- Enroll the msp of the peer
```
fabric-ca-client enroll -d -u https://peer2:12341234@192.168.1.78:7779 --id.type peer  --csr.cn peer2 --csr.names "C=PT,ST=Porto,L=Aliados,O=Hospital" --csr.hosts "192.168.1.230,peer2,127.0.0.1" --tls.certfiles tls-root-cert/tls-root-cert.pem --mspdir ../../cryptographic-materials/peer2/msp
```
- Register tls certificate
```
fabric-ca-client register -d -u https://localhost:7777 --id.name peer2 --id.secret 12341234 --id.type peer --id.affiliation org1.doctor  --csr.names "C=PT,ST=Porto,L=Aliados,O=Hospital" --csr.cn peer2 --csr.hosts "192.168.1.230,peer2,127.0.0.1" --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --mspdir tls-ca/tlsadmin/msp/
```
- Enroll tls certificate
```
fabric-ca-client enroll -d -u https://peer2:12341234@192.168.1.78:7777 --id.type peer2 --id.affiliation org1.doctor  --csr.names "C=PT,ST=Porto,L=Aliados,O=Hospital" --csr.cn peer2 --csr.hosts "192.168.1.230,peer2,127.0.0.1" --tls.certfiles tls-cas/tls-root-ca.pem --mspdir ../tls-msp --enrollment.profile tls
```