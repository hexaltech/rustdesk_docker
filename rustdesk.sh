sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl enable --now docker

mkdir -p ~/rustdesk-server/{hbbs,hbbr}
cd ~/rustdesk-server

vim docker-compose.yml

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

docker-compose up -d

cat ~/rustdesk-server/hbbs/id_ed25519.pub
cat ~/rustdesk-server/hbbr/id_ed25519.pub
