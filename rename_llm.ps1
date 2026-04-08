$oldPath = "e:\june2\SmolChat-Android\app\src\main\java\com\monicauditya\june\llm"
$newPath = "e:\june2\SmolChat-Android\app\src\main\java\com\monicauditya\june\inference"
if (Test-Path $oldPath) {
    Rename-Item -Path $oldPath -NewName "inference"
}
$encoding = New-Object System.Text.UTF8Encoding($False)
$files = Get-ChildItem -Path "e:\june2\SmolChat-Android\app\src\main\java\com\monicauditya\june\" -Recurse -File -Include *.kt
foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName)
    if ($content -match 'com\.monicauditya\.june\.llm') {
        $content = $content -replace 'com\.monicauditya\.june\.llm', 'com.monicauditya.june.inference'
        [System.IO.File]::WriteAllText($f.FullName, $content, $encoding)
        Write-Host "Updated $($f.FullName)"
    }
}
Write-Host "Renamed and mapped imports successfully."
