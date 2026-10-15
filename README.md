# llama-snapdragon

llama.cpp compilé pour **Windows sur Snapdragon** (X Elite, X Plus, X2…) avec le **NPU Hexagon** et le **GPU Adreno** : deux backends absents des releases officielles. Locaryn télécharge ce moteur quand le mode NPU est activé sur un PC Snapdragon.

## Autoriser le NPU (une fois par PC)

Windows ne charge les bibliothèques du NPU que si elles sont signées par un certificat de confiance. Celles-ci sont signées par le certificat de Locaryn (`locaryn-htp.cer`, inclus). Pour l'autoriser :

1. Ouvrez **PowerShell en administrateur** dans le dossier du moteur (Locaryn indique où).
2. Lancez :
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\activer-npu.ps1
   ```
3. Redémarrez le PC.

Ce script ajoute le certificat aux autorités de confiance de la machine et active le **mode test-signing** de Windows (`bcdedit /set TESTSIGNING ON`). Un filigrane « Mode de test » apparaît sur le bureau. Si `bcdedit` refuse, désactivez **Secure Boot** dans l'UEFI, puis relancez le script.

Pour tout annuler : `desactiver-npu.ps1` en administrateur, puis redémarrer.

Sans cette étape, Locaryn utilise le GPU Adreno à la place.

## Pilotes

Le NPU doit apparaître dans le Gestionnaire de périphériques, sous **Processeurs neuronaux** (pilote Qualcomm « Hexagon NPU », à jour via Windows Update ou le site du fabricant).

## Construire

Chaque tag `b*` (par exemple `b11003-locaryn.1`) lance la CI (`windows-11-arm`) : SDK Hexagon et OpenCL allégés de [snapdragon-toolchain](https://github.com/snapdragon-toolchain), preset `arm64-windows-snapdragon-release` de llama.cpp, catalogue des bibliothèques NPU signé avec le secret `HTP_CERT_PFX_B64`.

Licence de llama.cpp : MIT.
