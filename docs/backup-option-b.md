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

# ==============================================================================
# NOM DU SCRIPT : backup_configs.sh
# DESCRIPTION    : Sauvegarde quotidienne incrémentielle des configs du Node 2
# DESTINATION    : Node 1 (TrueNAS) via Rsync
# ==============================================================================

# --- CONFIGURATION ---
SOURCE="/opt/docker/config"                # Dossier source à sauvegarder
DEST_USER="root"                           # Utilisateur sur le Node 1
DEST_IP="192.168.0.x"                      # IP de ton TrueNAS (Node 1)
DEST_DIR="/mnt/tank/backups/daily_configs"  # Chemin de destination sur le NAS
LOG="/var/log/backup_rsync.log"            # Fichier de suivi

# --- EXECUTION ---
echo "--- Début du backup : $(date) ---" >> $LOG

# Exécution de rsync :
# -a : archive (conserve les permissions)
# -v : verbeux (détaille dans le log)
# -z : compression pendant le transfert
# --delete : efface sur la destination ce qui a été supprimé à la source
rsync -avz --delete $SOURCE $DEST_USER@$DEST_IP:$DEST_DIR >> $LOG 2>&1

# Vérification du code de sortie
if [ $? -eq 0 ]; then
    echo "✅ Succès : Synchronisation terminée." >> $LOG
else
    echo "❌ Erreur : Problème lors de la synchronisation." >> $LOG
fi

echo "--- Fin du backup : $(date) ---" >> $LOG
echo "--------------------------------------" >> $LOG
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
