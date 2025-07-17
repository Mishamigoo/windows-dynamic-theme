# Caminho do registro
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"

# Cria a chave se não existir (não afeta PCs novos)
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Valores padrão para modo claro
$modoClaro = @{
    "AppsUseLightTheme" = 1
    "SystemUsesLightTheme" = 1
}

# Obter valores atuais
$temaAnterior = @{
    "AppsUseLightTheme" = 1
    "SystemUsesLightTheme" = 1
}
try {
    $temaAnterior["AppsUseLightTheme"] = Get-ItemPropertyValue -Path $regPath -Name "AppsUseLightTheme"
    $temaAnterior["SystemUsesLightTheme"] = Get-ItemPropertyValue -Path $regPath -Name "SystemUsesLightTheme"
} catch {
    # Pode não existir ainda
}

# Define as chaves para modo claro
foreach ($key in $modoClaro.Keys) {
    Set-ItemProperty -Path $regPath -Name $key -Value $modoClaro[$key] -Force
}

# Limpa as chaves (opcional, mas aqui incluído pois o modo automático pode recriar)
Remove-ItemProperty -Path $regPath -Name "AppsUseLightTheme" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path $regPath -Name "SystemUsesLightTheme" -ErrorAction SilentlyContinue

# Por garantia, recria com valores padrão (modo claro)
foreach ($key in $modoClaro.Keys) {
    Set-ItemProperty -Path $regPath -Name $key -Value $modoClaro[$key] -Force
}

# Se estava diferente, reinicia o explorer
if ($temaAnterior["AppsUseLightTheme"] -ne 1 -or $temaAnterior["SystemUsesLightTheme"] -ne 1) {
    Start-Sleep -Milliseconds 300
    Stop-Process -Name explorer -Force
    Start-Process explorer.exe
    Write-Output "🎨 Tema revertido para Claro e explorer reiniciado."
} else {
    Write-Output "✅ Tema já estava em modo Claro. Nenhuma reinicialização necessária."
}
