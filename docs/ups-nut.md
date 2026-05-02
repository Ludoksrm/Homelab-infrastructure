# ⚡ Projet : Résilience Électrique (UPS-NUT)

L'objectif est de transformer une protection locale en une protection globale pour tout le cluster Proxmox.

## 🎯 Objectif

Utiliser l'onduleur APC relié au Node 2 pour protéger l'intégrité des données de l'ensemble du cluster (Node 1 & Node 2).

## 🛠️ Architecture Maître/Esclave

Pour pallier l'absence de double branchement USB, nous utilisons le réseau local pour synchroniser l'extinction.

| Rôle | Machine | Service | Connexion |
| :--- | :--- | :--- | :--- |
| **MASTER** | **Node 2** | `nut-server` | **USB Physique** (Onduleur APC) |
| **SLAVE** | **Node 1** | `nut-client` | **Réseau (LAN)** |

### Schéma Logique
```plaintext
[ Onduleur APC ]
       │
 (Lien Physique USB)
       │
       ▼
[ Node 2 : Proxmox ] <--- MASTER (Serveur NUT)
       │
 (Communication Réseau LAN)
       │
       ▼
[ Node 1 : Proxmox ] <--- SLAVE (Client NUT)
```

## 🔄 Scénario de Coupure (Sequence de Shutdown)

En cas de batterie faible, l'automatisation suit un ordre strict pour éviter toute corruption des données (notamment le pool ZFS du Node 1) :

  1.__Alerte__ : L'onduleur signale un état Low Battery au Node 2.
  2. __Notification__ : Le Node 2 diffuse l'ordre de fermeture au Node 1 via le réseau.
  3. __Phase 1 (Node 1)__ :
    - Arrêt des VM/LXC (Nextcloud, Ollama, etc.).
    - Démontage sécurisé du pool ZFS.
    - Extinction complète du Node 1.
  4.__Phase 2 (Node 2)__ :
    - Arrêt de la Domotique (Home Assistant, Zigbee2MQTT).
    - Arrêt du NVR (Frigate).
    - Extinction finale du Node 2.

  ### __[!IMPORTANT]__
  Cette séquence garantit que le stockage (Node 1) est hors ligne avant que le cerveau domotique (Node 2) ne s'éteigne.

## 📅 Roadmap de mise en œuvre

   - [ ] Branchement de l'onduleur sur le Node 2.

   - [ ] Installation et configuration de `nut-server` (Master).

   - [ ] Installation et configuration de `nut-client` (Slave) sur le Node 1.

   - [ ] Test de coupure réelle pour valider la séquence de shutdown.

## ⌨️ Guide d'Installation technique (NUT)

### 🏗️ 1. Configuration du Master (Node 2)
Le Node 2 est le serveur qui communique physiquement avec l'onduleur via USB.

**1. Installation**

Connectez-vous en SSH sur le Node 2 et installez les paquets nécessaires :
```bash
apt update && apt install nut nut-server nut-client usbutils -y
```

### 2. Identification de l'onduleur

Vérifiez que l'onduleur est bien vu par le système :
```Bash
lsusb
```
(Vous devriez voir une ligne mentionnant American Power Conversion).

### 3. Configuration des fichiers (/etc/nut/)

  - nut.conf : Définir le mode de fonctionnement.
    ```Plaintext
    MODE=netserver
    ```
  - ups.conf : Définir le pilote de l'onduleur.
    ```Plaintext
    [apc]
        driver = usbhid-ups
        port = auto
        desc = "Onduleur APC ProDesk"
    ```
  - upsd.conf : Autoriser l'écoute sur le réseau local (IP du Node 2).

    ```Plaintext
    LISTEN 0.0.0.0 3493
    ```
*   **`upsd.users`** : Créer les comptes pour le Master et le Slave.
    ```text
    [upsmon_master]
        password = VOTRE_MOT_DE_PASSE_FORT
        upsmon master

    [upsmon_slave]
        password = MOT_DE_PASSE_SLAVE
        upsmon slave
    ```
*   **`upsmon.conf`** : Configurer la surveillance locale.
    ```text
    MONITOR apc@localhost 1 upsmon_master VOTRE_MOT_DE_PASSE_FORT master
    SHUTDOWNCMD "/sbin/shutdown -h +0"
    ```

---

## 🛰️ Étape 2 : Configuration du Slave (Node 1)

Le Node 1 va "écouter" le Node 2 via le réseau.

### 1. Installation
Connectez-vous en SSH sur le Node 1 :
```bash
apt update && apt install nut-client
```

### 2. Configuration des fichiers (/etc/nut/)

  - nut.conf : Définir le mode.
  ```Plaintext
    MODE=netclient
  ```
*   **`upsmon.conf`** : Pointer vers le Node 2 (remplacez `IP_NODE_2`).
    ```text
    MONITOR apc@IP_NODE_2 1 upsmon_slave MOT_DE_PASSE_SLAVE slave
    SHUTDOWNCMD "/sbin/shutdown -h +0"
    ```

---

## 🚀 Étape 3 : Lancement et Vérification

### Sur le Node 2 (Master)
Redémarrez les services :
```bash
systemctl restart nut-server nut-client
upsc apc@localhost
```
(La commande upsc doit vous renvoyer une liste de données : charge batterie, voltage, etc.)

### __Sur le Node 1 (Slave)__

Vérifiez qu'il arrive à lire les données du Master :
```Bash
upsc apc@IP_NODE_2
```

## 🔄 Ordre de Shutdown (Automatique avec NUT)

Grâce à cette configuration :

  1. Dès que l'onduleur passe en batterie faible, le Node 2 (Master) change son statut.
  2. Le __Node 1__ (Slave) voit le changement de statut et lance immédiatement son propre SHUTDOWNCMD.
  3. Le __Node 2__ attend que les clients soient déconnectés (ou un délai imparti) avant de s'éteindre lui-même en dernier.

  ### __[!TIP]__
  __Sécurité ZFS__ : Sur le Node 1, NUT lancera l'arrêt du système, ce qui déclenchera automatiquement l'exportation propre de vos pools ZFS par Proxmox avant l'extinction.
