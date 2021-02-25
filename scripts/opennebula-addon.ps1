$download_uri = "https://github.com/OpenNebula/addon-context-windows/releases/download/v5.10.0/one-context-5.10.0.msi"
$installer_path = "C:\Windows\Temp\one-context-5.10.0.msi"
$install_log = "C:\ProgramData\packer\install_one-context.log"

function Get-Installer {
  $progressPreference = "silentlyContinue"
  Invoke-WebRequest -OutFile $installer_path $download_uri
}

function Install-one-context {
  $p = Start-Process -PassThru -FilePath msiexec -ArgumentList "/i $installer_path /qn /l*v $install_log /norestart REBOOT=ReallySuppress"
  Wait-Process -Id $p.id -Timeout 240
  if (($p.ExitCode -ne 0) -and ($p.ExitCode -ne 3010)) {
    $p.ExitCode
    Write-Error "ERROR: problem encountered during one-context install"
  }
}

Write-Host "BEGIN: opennebula-addon.ps1"
Write-Host "Downloading one-context from $download_uri"
Get-Installer
Write-Host "Installing one-context"
Install-one-context
Write-Host "END: opennebula-addon.ps1"