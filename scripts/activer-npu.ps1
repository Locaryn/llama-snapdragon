# Autorise le NPU Hexagon pour le moteur Locaryn sur un PC Snapdragon (Windows ARM).
#
# À lancer VOUS-MÊME, dans un PowerShell ouvert en administrateur, puis
# redémarrer le PC. Ce script :
#   1. ajoute le certificat public de Locaryn (locaryn-htp.cer) aux magasins
#      « Autorités de certification racines de confiance » et « Éditeurs
#      approuvés » de la machine ;
#   2. active le mode « test-signing » de Windows (bcdedit), sans lequel Windows
#      refuse de charger les bibliothèques NPU signées par un autre que Microsoft.
#
# Conséquences : le filigrane « Mode de test » s'affiche sur le bureau, et
# Secure Boot doit parfois être désactivé dans le BIOS/UEFI pour que bcdedit
# accepte la commande. Pour tout annuler : desactiver-npu.ps1, puis redémarrer.

$ErrorActionPreference = "Stop"
$cer = Join-Path $PSScriptRoot "locaryn-htp.cer"
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Ouvrez PowerShell en tant qu'administrateur, puis relancez ce script." -ForegroundColor Red
    exit 1
}
Import-Certificate -FilePath $cer -CertStoreLocation Cert:\LocalMachine\Root | Out-Null
Import-Certificate -FilePath $cer -CertStoreLocation Cert:\LocalMachine\TrustedPublisher | Out-Null
bcdedit /set TESTSIGNING ON
if ($LASTEXITCODE -ne 0) {
    Write-Host "bcdedit a refusé : désactivez Secure Boot dans l'UEFI, puis relancez ce script." -ForegroundColor Yellow
    exit 1
}
Write-Host "Terminé. Redémarrez le PC : le NPU sera utilisable par Locaryn." -ForegroundColor Green
