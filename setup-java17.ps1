# Setup Java 17 Environment
# Run this script in PowerShell to configure Java 17 for the project

$Java17Path = "C:\Program Files\Eclipse Adoptium\jdk-17.0.19+10"

# Set environment variables
$env:JAVA_HOME = $Java17Path
$env:PATH = "$Java17Path\bin;" + $env:PATH

# Verify
Write-Host "✅ Java 17 configured!" -ForegroundColor Green
java -version
Write-Host ""
Write-Host "Now you can run: mvn clean package -DskipTests" -ForegroundColor Cyan
