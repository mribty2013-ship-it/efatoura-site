# Assemble les pages internes du site : _src\pages\<page>.html (métadonnées + contenu) dans le gabarit commun.
# Usage : powershell -ExecutionPolicy Bypass -File _src\build.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$layout = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'layout.html'))
$nav = @(
  @('fonctionnalites.html', 'Fonctionnalités'),
  @('cabinets.html', 'Cabinets comptables'),
  @('securite.html', 'Sécurité &amp; conformité'),
  @('telecharger.html', 'Télécharger'),
  @('contact.html', 'Contact')
)
foreach ($f in Get-ChildItem (Join-Path $PSScriptRoot 'pages') -Filter *.html) {
  $src = [IO.File]::ReadAllText($f.FullName)
  $meta = @{}
  foreach ($m in [regex]::Matches($src, '(?m)^<!--\s*(\w+):\s*(.+?)\s*-->\s*$')) { $meta[$m.Groups[1].Value] = $m.Groups[2].Value }
  $body = [regex]::Replace($src, '(?m)^<!--\s*\w+:.*-->\s*\r?\n', '')
  $links = ($nav | ForEach-Object {
      $cur = if ($_[0] -eq $f.Name) { ' aria-current="page"' } else { '' }
      "      <li><a href=`"$($_[0])`"$cur>$($_[1])</a></li>"
    }) -join "`n"
  $page = $layout.Replace('{{title}}', $meta.title).Replace('{{description}}', $meta.description).
    Replace('{{path}}', $f.Name).Replace('{{nav}}', $links).Replace('{{content}}', $body.Trim())
  [IO.File]::WriteAllText((Join-Path $root $f.Name), $page, (New-Object Text.UTF8Encoding $false))
  Write-Host "Page : $($f.Name)"
}
