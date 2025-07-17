# Caminho do registro
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"

# Função: retorna o tema atual
function Get-TemaAtual {
    $apps = Get-ItemPropertyValue -Path $regPath -Name "AppsUseLightTheme" -ErrorAction SilentlyContinue
    $system = Get-ItemPropertyValue -Path $regPath -Name "SystemUsesLightTheme" -ErrorAction SilentlyContinue
    if ($apps -eq 1 -and $system -eq 1) {
        return "Claro"
    } elseif ($apps -eq 0 -and $system -eq 0) {
        return "Escuro"
    } else {
        return "Indefinido"
    }
}

# Função: define tema
function Set-Tema {
    param([string]$Tema)
    if ($Tema -eq "Claro") {
        Set-ItemProperty -Path $regPath -Name "AppsUseLightTheme" -Value 1 -Force
        Set-ItemProperty -Path $regPath -Name "SystemUsesLightTheme" -Value 1 -Force
    } elseif ($Tema -eq "Escuro") {
        Set-ItemProperty -Path $regPath -Name "AppsUseLightTheme" -Value 0 -Force
        Set-ItemProperty -Path $regPath -Name "SystemUsesLightTheme" -Value 0 -Force
    }
    Start-Sleep -Milliseconds 300
    Stop-Process -Name explorer -Force
    Start-Process explorer.exe
}

# Obtém geolocalização de São Paulo
$client = New-Object System.Net.WebClient
$url = "https://api.sunrisesunset.io/json?lat=-23.5505&lng=-46.6333&timezone=America/Sao_Paulo"
$response = $client.DownloadString($url) | ConvertFrom-Json
$horarios = $response.results

# Hora atual
$agora = Get-Date

# Decide tema baseado na hora
if ($agora -ge $horarios.Sunrise -and $agora -lt $horarios.Sunset) {
    $temaDesejado = "Claro"
} else {
    $temaDesejado = "Escuro"
}

# Verifica tema atual
$temaAtual = Get-TemaAtual

# Só altera se necessário
if ($temaAtual -ne $temaDesejado) {
    Set-Tema -Tema $temaDesejado
    Write-Output "🎨 Tema alterado para: $temaDesejado"
} else {
    Write-Output "✅ Tema já está em '$temaAtual'. Nenhuma alteração feita."
}
