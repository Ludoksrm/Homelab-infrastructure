# 🛠️ Détails du Matériel (Node 2)

Le Node 2 est le hub physique de l'appartement. Les périphériques USB sont redirigés (Passthrough) vers les VM/LXC concernés.

### Contrôleurs Zigbee
1. **Sonoff Zigbee 3.0 Dongle Plus (P)** : Gère le réseau de production via **Zigbee2MQTT**.
2. **Clé Popp Zigbee** : Dédiée aux tests via l'intégration **ZHA** dans Home Assistant.
   *Note : Les deux réseaux utilisent des canaux différents (ex: 11 et 20) pour éviter les interférences.*

### Autres périphériques
* **Google Coral TPU** : Déchargement de l'IA Frigate (CPU < 10%).
* **Onduleur APC** : Protection contre les coupures et micro-coupures.

### Gestion des fréquences Zigbee

Pour éviter les interférences entre la production, les tests et le Wi-Fi de l'appartement, les canaux ont été fixés comme suit :
| Périphérique | Usage | Canal | Logiciel |
| :--- | :--- | :--- | :--- |
| `Sonoff Dongle P` | **Production** | `11` | Zigbee2MQTT |
| `Clé Popp` | **Tests / ZHA** | `20` | Home Assistant (ZHA) |
