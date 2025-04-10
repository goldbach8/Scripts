# capacity_control.ps1
$tenantId = $env:TENANT_ID
$appId = $env:CLIENT_ID
$appSecret = $env:CLIENT_SECRET
$capacityId = $env:CAPACITY_ID
$action = $env:CAPACITY_ACTION  # "start" o "stop"

# Obtener token
$body = @{
    grant_type    = "client_credentials"
    scope         = "https://graph.microsoft.com/.default"
    client_id     = $appId
    client_secret = $appSecret
}
$tokenResponse = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Body $body
$authHeader = @{ Authorization = "Bearer $($tokenResponse.access_token)" }

# Construir URL
if ($action -eq "start") {
    $uri = "https://api.powerbi.com/v1.0/myorg/capacities/$capacityId/Resume"
} elseif ($action -eq "stop") {
    $uri = "https://api.powerbi.com/v1.0/myorg/capacities/$capacityId/Suspend"
} else {
    Write-Error "CAPACITY_ACTION debe ser 'start' o 'stop'"
    exit 1
}

# Ejecutar acción
Invoke-RestMethod -Method Post -Uri $uri -Headers $authHeader
Write-Output "Acción $action ejecutada con éxito"
