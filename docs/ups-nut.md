# ⚡ Projet : Résilience électrique (UPS-NUT)

## Objectif
Utiliser l'onduleur APC relié au Node 2 pour protéger l'ensemble du cluster.

## Fonctionnement (Maître/Esclave)
1. **Node 2 (Master)** : Lit l'état de la batterie via USB et diffuse l'info sur le réseau.
2. **Node 1 (Slave)** : Reçoit l'alerte via le protocole **NUT** (Network UPS Tools).

## Scénario de coupure
En cas de batterie faible, le Node 1 s'éteint en premier, suivi du Node 2, garantissant l'intégrité des données ZFS et des bases de données.
