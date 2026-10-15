# Annule activer-npu.ps1 : retire le certificat de Locaryn et coupe le mode
# test-signing. À lancer en administrateur, puis redémarrer le PC.
$ErrorActionPreference = "Continue"
Get-ChildItem Cert:\LocalMachine\Root, Cert:\LocalMachine\TrustedPublisher |
    Where-Object { $_.Subject -eq "CN=Locaryn HTP Signing" } |
    Remove-Item
bcdedit /set TESTSIGNING OFF
Write-Host "Terminé. Redémarrez le PC." -ForegroundColor Green
