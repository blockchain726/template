<#
  Reassemble the split archives and load every image into Docker (Windows host).

    .\restore.ps1                 # restore all images
    .\restore.ps1 -Name mysql-8.0 # restore a single image

  Requires: docker in PATH.
#>
param([string]$Name)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
Add-Type -AssemblyName System.IO.Compression.FileSystem

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  throw "docker not found in PATH"
}

$dirs = if ($Name) {
  @(Get-Item (Join-Path "images" $Name))
} else {
  Get-ChildItem "images" -Directory | Sort-Object Name
}

$tmp = Join-Path $env:TEMP ("imgrestore-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
try {
  foreach ($d in $dirs) {
    $n = $d.Name
    Write-Host "==> $n : joining parts" -ForegroundColor Cyan
    $parts = Get-ChildItem $d.FullName -Filter "$n.zip.part*" | Sort-Object Name
    if (-not $parts) { throw "no parts found in $($d.FullName)" }
    $zip = Join-Path $tmp "$n.zip"
    $out = [System.IO.File]::Create($zip)
    try {
      foreach ($p in $parts) {
        $in = [System.IO.File]::OpenRead($p.FullName)
        try { $in.CopyTo($out) } finally { $in.Dispose() }
      }
    } finally { $out.Dispose() }

    # Verify against the recorded zip checksum
    $expected = (Select-String -Path (Join-Path $d.FullName "MANIFEST.txt") -Pattern '^zip_sha256:\s*(\S+)').Matches[0].Groups[1].Value
    $actual = (Get-FileHash $zip -Algorithm SHA256).Hash.ToLower()
    if ($actual -ne $expected) { throw "$n checksum mismatch: expected $expected got $actual" }
    Write-Host "    checksum OK" -ForegroundColor Green

    Write-Host "==> $n : unzipping" -ForegroundColor Cyan
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $tmp)

    Write-Host "==> $n : docker load" -ForegroundColor Cyan
    docker load -i (Join-Path $tmp "$n.tar")
    if ($LASTEXITCODE -ne 0) { throw "docker load failed for $n" }

    Remove-Item (Join-Path $tmp "$n.zip"), (Join-Path $tmp "$n.tar") -Force -ErrorAction SilentlyContinue
  }
} finally {
  Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "`nDone. Loaded images:" -ForegroundColor Green
docker images
