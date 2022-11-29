dotnet build --configuration Release

# update manifest
$xml = [Xml] (Get-Content ".\HookGenPatcher\HookGenPatcher.csproj")
$manifest = Get-Content ".\Thunderstore\manifest.json" | ConvertFrom-Json

$modversion = $xml.Project.PropertyGroup.Version
$desc = $xml.Project.PropertyGroup.Description

Write-Output "Mod Version: $modversion"
Write-Output "Description: $desc"

$manifest.description = $desc
$manifest.version_number = $modversion

$manifest | ConvertTo-Json | Out-File ".\Thunderstore\manifest.json"

Copy-Item -Path ".\HookGenPatcher\bin\Release\net6.0\*.dll" -Destination ".\Thunderstore\BepInEx\patchers\Bepinex.MonoMod.HookGenPatcher.IL2CPP"
#Copy-Item -Path ".\HookGenPatcher\bin\Release\net6.0\win-x64\*.exe" -Destination ".\Thunderstore\BepInEx\patchers\Bepinex.MonoMod.HookGenPatcher.IL2CPP"
#Copy-Item -Path ".\HookGenPatcher\bin\Release\net6.0\win-x64\*.xml" -Destination ".\Thunderstore\BepInEx\patchers\Bepinex.MonoMod.HookGenPatcher.IL2CPP"
Compress-Archive -Path ".\Thunderstore\*" -CompressionLevel "Optimal" -DestinationPath ".\HookGenPatcher.IL2CPP-$modversion.zip" -Force