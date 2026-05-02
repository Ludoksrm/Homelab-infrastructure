# ⚡ Projet : Résilience électrique (UPS-NUT)

L'onduleur APC est actuellement physiquement relié au Node 2. L'objectif est de transformer cette protection locale en une protection globale pour tout le cluster Proxmox.

## Objectif
Utiliser l'onduleur APC relié au Node 2 pour protéger l'ensemble du cluster.

## Fonctionnement (Maître/Esclave)
1. **Node 2 (Master)** : Lit l'état de la batterie via USB et diffuse l'info sur le réseau.
2. **Node 1 (Slave)** : Reçoit l'alerte via le protocole **NUT** (Network UPS Tools).

## Scénario de coupure
En cas de batterie faible, le Node 1 s'éteint en premier, suivi du Node 2, garantissant l'intégrité des données ZFS et des bases de données.

- Serveur (Maître) : Configurer NUT-Server sur le Node 2 pour lire les données USB de l'onduleur.
- Client (Esclave) : Installer NUT-Client sur le Node 1 pour qu'il reçoive les alertes de coupure via le réseau.
- Automatisation : Scripter l'extinction sécurisée (Shutdown) :
  - Extinction des VM/LXC du Node 1.
  - Extinction du Node 1.
  - Extinction des services du Node 2.
  - Extinction finale du Node 2.

📊 Mise à jour du Schéma de Résilience

Voici comment la communication va circuler entre tes deux HP ProDesk :
Extrait de code
```plaintext
graph LR
    subgraph "Sécurité Électrique"
    UPS[Onduleur APC] -- USB -- Master[Node 2: Proxmox]
    Master -- Réseau LAN / NUT -- Slave[Node 1: Proxmox]
    end

    style UPS fill:#795548,stroke:#333,color:#fff
    style Master fill:#f96,stroke:#333
```
