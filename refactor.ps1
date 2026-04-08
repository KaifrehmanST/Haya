$ErrorActionPreference = "Stop"

$rootDir = "e:\june2\SmolChat-Android"

Write-Output "Starting text replacements..."
# 1. Text Replacement
Get-ChildItem -Path $rootDir -Recurse -File | Where-Object {
    $_.FullName -notmatch "\\\.git\\" -and
    $_.Extension -in @(".kt", ".java", ".xml", ".kts", ".pro")
} | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $newContent = $content
    $changed = $false

    if ($newContent -match "io\.shubham0204\.smollmandroid") {
        $newContent = $newContent -replace "io\.shubham0204\.smollmandroid", "com.monicauditya.june"
        $changed = $true
    }
    if ($newContent -match "io\.shubham0204\.smollm") {
        $newContent = $newContent -replace "io\.shubham0204\.smollm", "com.monicauditya.smollm"
        $changed = $true
    }
    if ($newContent -match "io\.shubham0204\.smolvectordb") {
        $newContent = $newContent -replace "io\.shubham0204\.smolvectordb", "com.monicauditya.smolvectordb"
        $changed = $true
    }
    if ($newContent -match "io\.shubham0204\.hf_model_hub_api") {
        $newContent = $newContent -replace "io\.shubham0204\.hf_model_hub_api", "com.monicauditya.hf_model_hub_api"
        $changed = $true
    }
    if ($newContent -match "SmolChatApplication") {
        $newContent = $newContent -replace "SmolChatApplication", "JuneApplication"
        $changed = $true
    }

    if ($changed) {
        # Using UTF8 encoding to avoid converting characters wrongly
        [System.IO.File]::WriteAllText($_.FullName, $newContent, [System.Text.Encoding]::UTF8)
    }
}

Write-Output "Renaming Application class file..."
# 2. File and Directory Rename
$appFile = Get-ChildItem -Path $rootDir -Recurse -Filter "SmolChatApplication.kt" | Select-Object -First 1
if ($appFile) {
    Rename-Item -Path $appFile.FullName -NewName "JuneApplication.kt"
}

Write-Output "Moving directories..."
function Move-PackageDir {
    param($srcModule, $oldLeaf, $newLeaf)
    
    foreach ($sourceSet in @("main", "androidTest", "test")) {
        $baseDir = Join-Path $rootDir "$srcModule\src\$sourceSet\java\io\shubham0204\$oldLeaf"
        if (Test-Path $baseDir) {
            $destDir = Join-Path $rootDir "$srcModule\src\$sourceSet\java\com\monicauditya\$newLeaf"
            $null = New-Item -ItemType Directory -Force -Path $destDir
            Move-Item -Path "$baseDir\*" -Destination $destDir -Force
        }
    }
}

Move-PackageDir "app" "smollmandroid" "june"
Move-PackageDir "smollm" "smollm" "smollm"
Move-PackageDir "hf-model-hub-api" "hf_model_hub_api" "hf_model_hub_api"
Move-PackageDir "smolvectordb" "smolvectordb" "smolvectordb"

Write-Output "Cleaning up empty old directories..."
# Clean up any remaining empty "io\shubham0204" directories
Get-ChildItem -Path $rootDir -Recurse -Directory -Filter "shubham0204" | ForEach-Object {
    if ((Get-ChildItem $_.FullName -Recurse -File).Count -eq 0) {
        Remove-Item $_.FullName -Recurse -Force
    }
}
Get-ChildItem -Path $rootDir -Recurse -Directory -Filter "io" | ForEach-Object {
    if ((Get-ChildItem $_.FullName -Recurse -File).Count -eq 0) {
        Remove-Item $_.FullName -Recurse -Force
    }
}

Write-Output "Refactoring script completed."
