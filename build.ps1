$ErrorActionPreference = "Stop"
$base = Split-Path -Parent $MyInvocation.MyCommand.Path
$csc = Join-Path $env:WINDIR "Microsoft.NET\Framework64\v4.0.30319\csc.exe"
$fw = Join-Path $env:WINDIR "Microsoft.NET\Framework64\v4.0.30319"
$refs = @(
    (Join-Path $fw "System.dll"),
    (Join-Path $fw "System.Core.dll"),
    (Join-Path $fw "System.Web.Extensions.dll"),
    (Join-Path $fw "System.Windows.Forms.dll"),
    (Join-Path $fw "System.Drawing.dll")
)
$refArgs = $refs | ForEach-Object { "/r:$_" }
$src = Get-ChildItem (Join-Path $base "src\*.cs") | ForEach-Object { $_.FullName }
$out = Join-Path $base "CATIAQuickKeys.exe"
$icon = Join-Path $base "app.ico"
$manifest = Join-Path $base "app.manifest"
$cscArgs = @(
    "/nologo", "/target:winexe", "/platform:x64", "/optimize+",
    "/win32manifest:$manifest",
    "/out:$out"
) + $refArgs + $src
if (Test-Path $icon) { $cscArgs = @("/win32icon:$icon") + $cscArgs }
& $csc $cscArgs
if ($LASTEXITCODE -ne 0) { throw "Build failed with exit code $LASTEXITCODE" }
Write-Host "Built: $out"
