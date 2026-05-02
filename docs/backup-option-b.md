# 💾 Sauvegarde Granulaire (Option B) - Rsync

Ce guide documente la mise en place d'une sauvegarde quotidienne des fichiers de configuration (YAML, conf, scripts) du **Node 2** vers le **Node 1**.

## 🎯 Objectif
Compléter la sauvegarde hebdomadaire Proxmox par une synchronisation légère et incrémentielle chaque nuit à 03h00.

## 🛠️ Mise en œuvre

### 1. Clés SSH (Accès sans mot de passe)
Indispensable pour l'automatisation via Cron.
- Sur le **Node 2** : `ssh-keygen -t ed25519`
- Envoi vers **Node 1** : `ssh-copy-id root@192.168.0.x`

### 2. Le Script : `scripts/backup_configs.sh`
```bash
#!/bin/bash
# --- CONFIGURATION ---
SOURCE="/opt/docker/config"
DEST_USER="root"
DEST_IP="192.168.0.x"
DEST_DIR="/mnt/tank/backups/daily_configs"
LOG="/var/log/backup_rsync.log"

# --- EXECUTION ---
echo "--- Début du backup : $(date) ---" >> $LOG
rsync -avz --delete $SOURCE $DEST_USER@$DEST_IP:$DEST_DIR >> $LOG 2>&1
echo "--- Fin du backup : $(date) ---" >> $LOG
```

### 3. Planification (Crontab)
Ajouter via crontab -e sur le Node 2 
```bash
00 03 * * * /bin/bash /root/scripts/backup_configs.sh
```

### 📊 Stratégie de Résilience
| Type de Backup | Fréquence | Cible (Support) | Utilité / Risque couvert |
| :--- | :--- | :--- | :--- |
| **Image Proxmox** | Hebdomadaire (Dim. 01h) | SSD dédié (`Local-Backup`) | **Crash matériel** (SSD système HS, perte totale du Node). |
| **Rsync (Option B)** | Quotidienne (03h00) | NAS (Node 1 - TrueNAS) | **Erreur humaine** (mauvaise config, suppression de fichier). |
