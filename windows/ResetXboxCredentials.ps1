$CredentialsToDelete = "Xbl*" # Example, can be adjusted for other apps
foreach ($Credential in $CredentialsToDelete) {
  $Credentials = cmdkey.exe /list:($CredentialsToDelete) | Select-String -Pattern "Target:"
  $Credentials = $Credentials -replace " ", "" -replace "Target:", ""
}
foreach ($Credential in $Credentials) {
  cmdkey.exe /delete $Credential | Out-Null
}