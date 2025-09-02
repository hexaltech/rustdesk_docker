# RustDesk Auto-Hébergé avec Docker (HBBS + HBBR)

Ce dépôt contient les fichiers et instructions pour installer RustDesk en version auto-hébergée sur Docker, avec les services **HBBS** (serveur d'identification) et **HBBR** (serveur relais).

---

## Étapes d'installation

1. **Mettre à jour le système et installer Docker**

```bash
sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl enable --now docker
```

2. **Créer les dossiers pour HBBS et HBBR**

```bash
mkdir -p ~/rustdesk-server/{hbbs,hbbr}
cd ~/rustdesk-server
```

3. **Créer le fichier `docker-compose.yml`**
   Contenu du fichier :

```yaml
version: '3'
services:
  hbbs:
    image: rustdesk/rustdesk-server:latest
    container_name: hbbs
    ports:
      - "21115:21115"
      - "21116:21116"
      - "21116:21116/udp"
      - "21118:21118"
    command: hbbs -r 127.0.0.1:21117 -k _
    volumes:
      - ./hbbs:/root
    restart: unless-stopped

  hbbr:
    image: rustdesk/rustdesk-server:latest
    container_name: hbbr
    ports:
      - "21117:21117"
      - "21119:21119"
    command: hbbr -k _
    volumes:
      - ./hbbr:/root
    restart: unless-stopped
```

4. **Lancer les containers**

```bash
docker-compose up -d
```

5. **Récupérer les clés publiques pour le client RustDesk**

```bash
cat ~/rustdesk-server/hbbs/id_ed25519.pub
cat ~/rustdesk-server/hbbr/id_ed25519.pub
```

---

Ces clés publiques seront utilisées pour connecter vos clients RustDesk à votre serveur auto-hébergé.
