# Blockchain Course – Local Geth Clique PoA Network

This repository contains scripts and configuration files for setting up a **local Ethereum Clique Proof of Authority (PoA) network** with 3 nodes using [Geth](https://geth.ethereum.org/).

---

## 📌 Prerequisites
- Virtual machine with **Ubuntu 20.04 LTS**
- Access to the internet
- Git installed
- Home directory set as `/home/ubuntu`

---

## 🚀 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/alex-bratu/blockchain_course.git
   cd blockchain_course
   ```

2. **Install Geth**
   ```bash
   sudo chmod +x install_geth.sh
   ./install_geth.sh
   source ~/.bashrc
   ```

3. **Verify installation**
   ```bash
   geth version
   ```
   ✅ Expected output:
   ```
   Geth
   Version: 1.13.15-stable
   Git Commit: c5ba367eb6232e3eddd7d6226bfd374449c63164
   Git Commit Date: 20240417
   Architecture: arm64
   Go Version: go1.21.6
   Operating System: linux
   ```

---

## 🔑 Create Accounts

Each node requires an Ethereum account:

```bash
# Node 1
geth --datadir node1/ account new
# Node 2
geth --datadir node2/ account new
# Node 3
geth --datadir node3/ account new
```

👉 Notes:
- Save the **public addresses** (without the `0x` prefix).
- Use a password for each account and store it in `node#/password.txt`.

---

## ⚙️ Configure Nodes

1. **Set VM IP in configs**  
   Replace the `HTTPHost = "IP"` line in each `config.toml` with the VM’s IPv4 address:
   ```bash
   hostname -I | awk '{print $1}'
   ```

2. **Update `genesis.json`**  
   Replace `--ADDR--` with Node 1’s account address (found in the keystore).

   ```bash
   ls /home/ubuntu/blockchain_course/node1/keystore/UTC* | awk -F '--' '{print $3}'
   ```

3. **Initialize nodes**
   ```bash
   geth --datadir node1/ init genesis.json
   geth --datadir node2/ init genesis.json
   geth --datadir node3/ init genesis.json
   ```

---

## ▶️ Start Node 1

Run Node 1 as the initial signer (replace `--ADDR--` with Node 1’s address):

```bash
geth --config /home/ubuntu/blockchain_course/node1/config.toml   --verbosity 3   --gcmode 'archive'   --unlock '0x--ADDR--'   --password /home/ubuntu/blockchain_course/node1/password.txt   --miner.etherbase '0x--ADDR--'   --mine
```

---

## 🔍 Attach to Node 1 Console

In another terminal:
```bash
geth attach /home/ubuntu/blockchain_course/node1/geth.ipc
```

From the console:

- Get the **enode**:
  ```javascript
  admin.nodeInfo.enode
  ```

- Exit console:
  ```javascript
  exit
  ```

---

## 🔗 Connect Nodes 2 and 3

1. Add Node 1’s enode to `config.toml` of Node 2 and Node 3 under:
   ```toml
   StaticNodes=["enode://<NODE1_ENODE>@127.0.0.1:30303"]
   ```

2. Start Node 2:
   ```bash
   geth --config /home/ubuntu/blockchain_course/node2/config.toml      --verbosity 3      --gcmode 'archive'      --unlock '0x--ADDR-NODE2--'      --password /home/ubuntu/blockchain_course/node2/password.txt      --miner.etherbase '0x--ADDR-NODE2--'      --mine
   ```

3. Start Node 3:
   ```bash
   geth --config /home/ubuntu/blockchain_course/node3/config.toml      --verbosity 3      --gcmode 'archive'      --unlock '0x--ADDR-NODE3--'      --password /home/ubuntu/blockchain_course/node3/password.txt      --miner.etherbase '0x--ADDR-NODE3--'      --mine
   ```

👉 To get node addresses:
```bash
# Node 2
ls /home/ubuntu/blockchain_course/node2/keystore/UTC* | awk -F '--' '{print $3}'
# Node 3
ls /home/ubuntu/blockchain_course/node3/keystore/UTC* | awk -F '--' '{print $3}'
```

---

## 🛠 Monitoring & Clique Operations

Attach again to Node 1 console:
```bash
geth attach /home/ubuntu/blockchain_course/node1/geth.ipc
```

- See connected peers:
  ```javascript
  admin.peers
  ```

- See current signers:
  ```javascript
  clique.getSigners()
  ```

- Propose a new signer:
  ```javascript
  clique.propose("0x--ADDR--", true)
  ```

---

## 🖼️ Network Topology Diagram

```text
          +------------------+
          |     Node 1       |
          |  Initial Signer  |
          |  (enode exposed) |
          +------------------+
                 ^
                 |
     ----------------------------
     |                          |
+------------+           +------------+
|   Node 2   |           |   Node 3   |
|   Signer   |           |   Signer   |
+------------+           +------------+
```

---

## ✅ Summary
You now have a **3-node local Ethereum Clique PoA network** running with:
- Node 1 as the initial signer  
- Nodes 2 and 3 connected via enode  
- The ability to monitor peers, signers, and vote new signers  

---

👨‍💻 Happy experimenting with Ethereum Clique PoA!
