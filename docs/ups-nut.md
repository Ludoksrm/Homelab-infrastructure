# ⚡ Gestion de l'onduleur (UPS-NUT)

## Objectif
Protéger le cluster contre les coupures de courant et assurer une extinction propre.

## Configuration logicielle (Projet)
- **Master** : Node 2 (Lien USB physique).
- **Slave** : Node 1 (Écoute via le réseau).
- **Service** : Network UPS Tools (NUT).

## Ordre d'extinction automatique
1. Services non critiques (Node 1).
2. Node 1 (Slave).
3. Domotique & Sécurité (Node 2).
4. Node 2 (Master).
