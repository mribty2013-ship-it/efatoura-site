# Contrôle des liens du site statique. Les fichiers locaux sont vérifiés sur le disque.
# Les adresses http(s) reçoivent une requête HEAD, puis GET si HEAD est refusé.
$root = Split-Path -Parent $PSScriptRoot
$files = Get-ChildItem $root -Recurse -Include *.html,*.css,*.js,*.svg -File |
  Where-Object { $_.FullName -notmatch '\\_src\\' }
$hrefs = [System.Collections.Generic.HashSet[string]]::new()
foreach ($f in $files) {
  $text = Get-Content -Raw -LiteralPath $f.FullName
  foreach ($m in [regex]::Matches($text, '(?:href|src)\s*=\s*"([^"]+)"')) {
    [void]$hrefs.Add($m.Groups[1].Value)
  }
}
$bad = 0
foreach ($href in ($hrefs | Sort-Object)) {
  if ($href -match '^(mailto:|tel:|data:|#)') { continue }
  if ($href -match '[\s''+]') { continue }
  if ($href -match '^https?://') {
    try {
      $r = Invoke-WebRequest -Uri $href -Method Head -MaximumRedirection 5 -UseBasicParsing -TimeoutSec 25
      $code = [int]$r.StatusCode
    } catch {
      if ($_.Exception.Response) { $code = [int]$_.Exception.Response.StatusCode } else { $code = 0 }
      if ($code -in 405, 403, 0) {
        try {
          $r = Invoke-WebRequest -Uri $href -Method Get -MaximumRedirection 5 -UseBasicParsing -TimeoutSec 25
          $code = [int]$r.StatusCode
        } catch {
          if ($_.Exception.Response) { $code = [int]$_.Exception.Response.StatusCode } else { $code = 0 }
        }
      }
    }
    if ($href -match '^https?://[^/]+$' -and $code -eq 404) { Write-Host "NOTE  origine  $href"; continue }
    if ($code -ge 400 -or $code -eq 0) { $bad++; Write-Host "ECHEC $code  $href" } else { Write-Host "OK    $code  $href" }
  } else {
    $rel = (($href -split '#')[0] -split '\?')[0].TrimStart('/')
    if (-not $rel) { continue }
    $path = Join-Path $root ($rel -replace '/', '\')
    if (Test-Path -LiteralPath $path) { Write-Host "OK    fichier  $href" } else { $bad++; Write-Host "ECHEC absent  $href" }
  }
}
if ($bad -gt 0) { exit 1 }
