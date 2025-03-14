Invoke-Expression (&starship init powershell)
$Env:STARSHIP_CONFIG = "${env:USERPROFILE}\.config\starship\starship.toml"
$Env:EDITOR = "code"