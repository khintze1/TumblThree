# Harvest Data
$harvestPath = "$env:APPVEYOR_BUILD_FOLDER\src\TumblThree\TumblThree.Presentation\bin\$env:PLATFORM\Release"
$fileVersion = (Get-Item "$harvestPath\TumblThree.exe").VersionInfo.ProductVersion

# Artifacts Paths
$artifactsPath = "$env:APPVEYOR_BUILD_FOLDER\artifacts"
$applicationArtifactsPath = "$artifactsPath\Application\TumblThree"
$translationArtifactsPath = "$artifactsPath\Translations\TumblThree"

New-Item -ItemType Directory -Force -Path $applicationArtifactsPath
New-Item -ItemType Directory -Force -Path $translationArtifactsPath

# Copy in Application Artifacts
#Get-ChildItem -Path "$harvestPath\*" -Include *.exe,*.dll,*.config | Copy-Item -Destination $applicationArtifactsPath
Get-ChildItem -Path "$harvestPath\*" -Include *.exe,*.dll,*.config -Exclude d3dcompiler_47.dll,libEGL.dll,libGLESv2.dll | Copy-Item -Destination $applicationArtifactsPath
#New-Item -ItemType Directory -Force -Path "$applicationArtifactsPath\en"
#Get-ChildItem -Path "$harvestPath\en\*" | Copy-Item -Destination "$applicationArtifactsPath\en"
# CEF
Get-ChildItem -Path "$harvestPath\*" -Include CefSharp.BrowserSubprocess.exe | Copy-Item -Destination $applicationArtifactsPath
Get-ChildItem -Path "$harvestPath\*" -Include libcef.dll | Copy-Item -Destination $applicationArtifactsPath
Get-ChildItem -Path "$harvestPath\*" -Include chrome_elf.dll | Copy-Item -Destination $applicationArtifactsPath
Get-ChildItem -Path "$harvestPath\*" -Include icudtl.dat | Copy-Item -Destination $applicationArtifactsPath
Get-ChildItem -Path "$harvestPath\*" -Include snapshot_blob.bin | Copy-Item -Destination $applicationArtifactsPath
Get-ChildItem -Path "$harvestPath\*" -Include v8_context_snapshot.bin | Copy-Item -Destination $applicationArtifactsPath
Get-ChildItem -Path "$harvestPath\*" -Include *.pak | Copy-Item -Destination $applicationArtifactsPath
New-Item -ItemType Directory -Force -Path "$applicationArtifactsPath\locales"
Get-ChildItem -Path "$harvestPath\locales\*" -Include en-US.pak | Copy-Item -Destination "$applicationArtifactsPath\locales"

# Copy in Translation Artifacts
$translationFolders = dir -Directory $harvestPath | where-object { $_.Name.Length -eq 2 }
foreach ($tf in $translationFolders) {
    $tfTarget = "$translationArtifactsPath\$tf"
    New-Item -ItemType Directory -Force -Path "$tfTarget"
    Get-ChildItem -Path "$harvestPath\$tf\*" | Copy-Item -Destination "$tfTarget"
}

# Zip Application
$applicationZipPath = "$artifactsPath\TumblThree-v$fileVersion-$env:PLATFORM-Application.zip"
Compress-Archive -Path "$artifactsPath\Application\TumblThree\" -DestinationPath "$applicationZipPath"

# Zip Translations
$translationZipPath = "$artifactsPath\TumblThree-v$fileVersion-$env:PLATFORM-Translations.zip"
Compress-Archive -Path "$artifactsPath\Translations\TumblThree\" -DestinationPath "$translationZipPath"
