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
