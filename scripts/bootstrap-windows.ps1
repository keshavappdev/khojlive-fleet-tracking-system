$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) { throw "Flutter SDK must be installed and in PATH" }
foreach ($app in @("driver", "dispatcher")) {
  $platform = if ($app -eq "driver") { "android" } else { "web" }
  Write-Host "Generating Flutter $platform host scaffold: $app"
  $source = "apps/$app/lib/main.dart"
  $backup = Get-Content -Raw $source
  flutter create --project-name "khojlive_$app" --org com.khojlive --platforms=$platform "apps/$app"
  if ($LASTEXITCODE -ne 0) { throw "flutter create failed for $app" }
  Set-Content -Path $source -Value $backup -Encoding UTF8
}
Write-Host "Flutter scaffold created. Review generated Android manifest permissions before tracking."

$manifest = "apps/driver/android/app/src/main/AndroidManifest.xml"
if (Test-Path $manifest) {
  $xml = Get-Content -Raw $manifest
  if ($xml -notmatch 'android.permission.ACCESS_FINE_LOCATION') {
    $permissions = @'
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
'@
    $xml = $xml -replace '<manifest', '<manifest'
    $xml = $xml -replace '<application', "$permissions`n    <application"
    Set-Content -Path $manifest -Value $xml -Encoding UTF8
  }
}
Write-Host "Driver manifest foreground-location permissions applied. Background tracking is not yet implemented."
