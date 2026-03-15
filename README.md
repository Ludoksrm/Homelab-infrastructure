# 🏠 Homelab Infrastructure

## Présentation

Ce dépôt documente mon homelab personnel, construit pour automatiser mon appartement et expérimenter des technologies d’infrastructure.

Le projet a commencé avec un Raspberry Pi 4 hébergeant Home Assistant.

Avec l’ajout progressif :

- d’intégrations domotiques
- d’automatisations
- de caméras IP
  
le Raspberry Pi est rapidement devenu limité :

- surcharge CPU
- baisse du framerate vidéo
- architecture monolithique
- point de défaillance unique
  
L’infrastructure a donc évolué vers une architecture virtualisée basée sur Proxmox VE, permettant de séparer les services et d’améliorer la stabilité.

Ce laboratoire me permet aujourd’hui d’expérimenter :

- l’administration systèmes
- la virtualisation
- les conteneurs
- la domotique
- les services auto-hébergés
  
🎯 Objectifs du projet
Les objectifs principaux de ce homelab sont :
centraliser la domotique de l’appartement
expérimenter des technologies d’infrastructure
apprendre l’administration systèmes Linux
déployer des services auto-hébergés
comprendre les architectures distribuées
🖥 Architecture
L’infrastructure repose sur deux serveurs Proxmox afin de séparer les rôles :
un serveur laboratoire / stockage
un serveur domotique
Architecture simplifiée :

```
Internet
   │
Box Internet
   │
Routeur
   │
Réseau local
   │
├── Proxmox Node 1
│   ├ TrueNAS
│   ├ Docker (tests)
│   ├ Ollama
│   ├ Calibre-Web
│   └ OpenClaw
│
└── Proxmox Node 2
    ├ Home Assistant
    ├ MQTT
    ├ Zigbee2MQTT
    ├ Node-RED
    ├ ESPHome
    ├ Vaultwarden
    ├ Nginx Proxy Manager
    ├ MotionEye
    └ Frigate (Docker + go2rtc)
   ```
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
Ollama
Objectif :
stockage
expérimentation
tests d’applications
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
Grafana
MariaDB
WireGuard
Tailscale
Cloudflared
🏠 Domotique
L’infrastructure domotique repose sur plusieurs services interconnectés.
Architecture :

Zigbee devices
      │
Zigbee2MQTT
      │
MQTT broker
      │
Home Assistant
      │
Node-RED
Objectif :
automatiser les scénarios domotiques
centraliser les équipements
intégrer capteurs et actionneurs.
🎥 Vidéosurveillance
Le système de vidéosurveillance repose sur deux solutions.
Frigate
NVR basé sur l’IA utilisant :
Docker
go2rtc
Google Coral TPU (USB)
Déploiement :

Proxmox
   │
LXC Debian
   │
Docker
   │
Frigate + go2rtc
Fonctions :
détection d’objets
analyse vidéo locale
intégration avec Home Assistant
MotionEye
MotionEye est utilisé pour :
visualiser les flux RTSP
monitorer les caméras
📷 Caméras
Caméras utilisées :
Xiaomi Yi 1080p (firmware yi-hack)
Reolink E1 Zoom
Reolink E1 Pro
Protocoles :
RTSP
ONVIF (via go2rtc pour certaines caméras)
Architecture vidéo :

Caméras IP
   │
RTSP / ONVIF
   │
go2rtc
   │
├ Frigate (détection IA)
└ MotionEye (visualisation)
💾 Sauvegardes
Sauvegardes actuelles :

Proxmox Backup
   ↓
SSD local 240 Go
Évolution prévue :

Proxmox Backup
   ↓
NAS TrueNAS
🧠 Compétences développées
Ce homelab m’a permis de travailler sur :
virtualisation
conteneurs
infrastructure Linux
stockage NAS
domotique
vidéosurveillance locale
automatisation
Technologies utilisées :
Proxmox VE
Docker
Home Assistant
TrueNAS
Frigate
Node-RED
🚀 Prochaines évolutions
Améliorations prévues :
activation de l’enregistrement vidéo Frigate
monitoring de l’infrastructure
accès distant sécurisé
sauvegardes NAS
supervision du homelab
👨‍💻 Contexte
Ce projet est né à l’origine d’un besoin simple : automatiser mon appartement.
La première version reposait sur un Raspberry Pi 4 exécutant Home Assistant.
Avec le temps, plusieurs besoins sont apparus :
ajout d’équipements domotiques
automatisations plus complexes
intégration de caméras IP
expérimentation de nouveaux services
Les limites du Raspberry Pi (ressources limitées et point de défaillance unique) ont conduit à migrer vers une infrastructure virtualisée basée sur Proxmox VE.
Aujourd’hui, ce homelab sert à :
gérer la domotique
tester de nouveaux services auto-hébergés
expérimenter différentes architectures
Plusieurs services sont actuellement installés mais encore en phase de test ou de déploiement, afin d’explorer différentes solutions et comprendre leur fonctionnement.
