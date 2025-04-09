# --- Configuration ---
$dockerDesktopPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"
$postgresContainerName = "postgres-db"
$waitSeconds = 2
# --- End Configuration ---

Write-Host "`n--- Checking Docker Desktop ---"
$dockerRunning = Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue

if (-not $dockerRunning) {
    Write-Host "Docker Desktop is not running. Attempting to start..."
    if (Test-Path $dockerDesktopPath) {
        Start-Process -FilePath $dockerDesktopPath
        Write-Host "Waiting for Docker Desktop to initialize (approx 30s)..."
        Start-Sleep -Seconds 30
    } else {
        Write-Host "Docker Desktop not found at $dockerDesktopPath. Please start it manually."
        Pause
        exit
    }
} else {
    Write-Host "Docker Desktop is running."
}

Write-Host "`n--- Checking PostgreSQL Container ($postgresContainerName) ---"
$containerId = docker ps -q -f "name=$postgresContainerName"

if (-not $containerId) {
    Write-Host "PostgreSQL container is not running. Starting with docker-compose..."
    docker-compose up -d db
    if ($LASTEXITCODE -ne 0) {
        Write-Error "ERROR: Failed to start PostgreSQL container with docker-compose."
        Pause
        exit
    }
    Write-Host "Waiting $waitSeconds seconds for the database to initialize..."
    Start-Sleep -Seconds $waitSeconds
} else {
    Write-Host "PostgreSQL container is already running (ID: $containerId)"
}

Write-Host "`n--- Applying Database Migrations (if needed) ---"
npm run db:push
if ($LASTEXITCODE -ne 0) {
    Write-Error "ERROR: Failed to apply database migrations. Check logs above."
    Pause
    exit
}

# --- Open Browser ---
Start-Process "http://localhost:3000/"

# --- Minimize PowerShell Window Properly ---
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Window {
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@

$psWindow = Get-Process -Id $PID
if ($psWindow.MainWindowHandle -ne 0) {
    [Window]::ShowWindow($psWindow.MainWindowHandle, 6)  # 6 = SW_MINIMIZE
}

# --- Start the Application Server ---
Write-Host "`n--- Starting Application Server ---"
npm run dev

Write-Host "`n--- Script Finished. Press any key to exit. ---"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
