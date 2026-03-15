🏠 Homelab Infrastructure
Présentation
Ce dépôt documente mon homelab personnel, construit pour :
automatiser mon appartement
expérimenter des technologies d’infrastructure
apprendre l’administration systèmes et réseaux
tester des services auto-hébergés
Le projet a commencé avec un Raspberry Pi 4 hébergeant Home Assistant.
Avec l’ajout :
d’intégrations domotiques
d’automatisations
de caméras IP
le Raspberry Pi est rapidement devenu limité :
CPU saturé
baisse du framerate des caméras
architecture monolithique
point de défaillance unique

🖥 Architecture globale
Mermaid
graph TD

Internet --> Box[Box Internet]
Box --> Router[Routeur]

Router --> Node1[Proxmox Node 1 - labo / stockage]
Router --> Node2[Proxmox Node 2 - domotique]

Node1 --> TrueNAS
Node1 --> DockerTest
Node1 --> Calibre
Node1 --> OpenClaw
Node1 --> Ollama

Node2 --> HAOS
Node2 --> MQTT
Node2 --> Zigbee2MQTT
Node2 --> NodeRED
Node2 --> ESPHome
Node2 --> Vaultwarden
Node2 --> NginxProxy

Node2 --> MotionEye

Node2 --> LXCFrigate
LXCFrigate --> Docker
Docker --> Frigate
Docker --> go2rtc

go2rtc --> Frigate
go2rtc --> MotionEye

Coral[Google Coral TPU] --> Frigate

Frigate --> HAOS
🖥 Infrastructure matérielle
Node 1 — serveur laboratoire / stockage
Machine : HP ProDesk
Stockage :
SSD 256 Go : système Proxmox
disque USB 1 To : ZFS
Services :
TrueNAS
Docker (tests)
Calibre-Web
OpenClaw
Ollama (expérimentation IA locale)
Objectif :
stockage
tests d’applications
laboratoire d’expérimentation
Node 2 — serveur domotique
Machine : HP ProDesk
Stockage :
SSD 256 Go : VM / LXC
SSD 240 Go : sauvegardes Proxmox
SSD 120 Go : stockage caméras (prévu)
Services actifs :
Home Assistant
MQTT
Zigbee2MQTT
Node-RED
ESPHome
Vaultwarden
Nginx Proxy Manager
MotionEye
Frigate
Services installés mais non encore utilisés :
MariaDB
Grafana
WireGuard
Tailscale
Cloudflared
🏠 Domotique
Stack principale :
Home Assistant
MQTT
Zigbee2MQTT
Node-RED
ESPHome
Objectif :
centraliser les équipements domotiques
automatiser les scénarios
intégrer les capteurs et actionneurs
Architecture :
Plain text
Zigbee devices
    ↓
Zigbee2MQTT
    ↓
MQTT broker
    ↓
Home Assistant
    ↓
Node-RED / automatisations
🎥 Vidéosurveillance locale
L’infrastructure vidéo repose sur deux solutions complémentaires.
Frigate
NVR basé sur l’IA.
Déploiement :
Plain text
Proxmox
 → LXC Debian
   → Docker
     → Frigate
     → go2rtc
Accélération IA :
Google Coral TPU (USB)
Fonctions :
détection d’objets
intégration Home Assistant
analyse vidéo locale
MotionEye
Utilisé pour :
visualisation simple des flux
monitoring rapide des caméras
Protocoles utilisés :
RTSP
📷 Caméras
2 × Xiaomi Yi 1080p (firmware yi-hack)
1 × Reolink E1 Zoom
1 × Reolink E1 Pro
Protocoles utilisés :
RTSP (principal)
ONVIF via go2rtc pour certaines caméras Reolink
Architecture vidéo :
Mermaid
graph TD

Cam1[Xiaomi Yi hack #1] --> RTSP
Cam2[Xiaomi Yi hack #2] --> RTSP
Cam3[Reolink E1 Zoom] --> RTSP
Cam4[Reolink E1 Pro] --> RTSP

RTSP --> Go2RTC[go2rtc]

Go2RTC --> Frigate
Go2RTC --> MotionEye

Frigate --> HAOS[Home Assistant]

Coral[Google Coral TPU] --> Frigate
💾 Sauvegardes
Sauvegardes actuelles :
Plain text
Proxmox Backup
   → SSD local 240 Go
Évolution prévue :
Plain text
Proxmox Backup
   → stockage local
   → NAS TrueNAS
🧠 Compétences développées
Ce homelab m’a permis de travailler sur :
virtualisation
conteneurs
infrastructure Linux
stockage NAS
domotique
NVR vidéo
automatisation
IA locale
Technologies utilisées :
Proxmox VE
Docker
Home Assistant
TrueNAS
Frigate
Node-RED
🚀 Prochaines évolutions
activation de l’enregistrement Frigate
mise en place du monitoring (Grafana)
accès distant sécurisé
sauvegardes NAS
supervision de l’infrastructure
L’infrastructure a donc évolué vers une plateforme virtualisée basée sur Proxmox VE, avec séparation des services.