$encoding = New-Object System.Text.UTF8Encoding($False)
$files = Get-ChildItem -Path "e:\june2\SmolChat-Android" -Recurse -File -Include *.java,*.kt,*.xml,*.kts,*.pro,*.md,*.txt
foreach ($file in $files) {
    if ($file.FullName -match "\\\.git\\") { continue }
    
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        Write-Host "Fixing BOM in $($file.FullName)"
        $content = [System.IO.File]::ReadAllText($file.FullName)
        [System.IO.File]::WriteAllText($file.FullName, $content, $encoding)
    }
}
Write-Host "BOM fix complete."
