@echo off

echo ====================================
echo  Step 1: Applying SpotX...
echo ====================================

:: Write SpotX downloader to a ps1 file and run it - same pattern as all other steps
echo [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 > "%TEMP%\spotx_run.ps1"
echo try { >> "%TEMP%\spotx_run.ps1"
echo     $tmp = Join-Path $env:TEMP 'spotx_script.ps1' >> "%TEMP%\spotx_run.ps1"
echo     (iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/SpotX/main/run.ps1').Content ^| Set-Content $tmp -Encoding UTF8 >> "%TEMP%\spotx_run.ps1"
echo } catch { >> "%TEMP%\spotx_run.ps1"
echo     $tmp = Join-Path $env:TEMP 'spotx_script.ps1' >> "%TEMP%\spotx_run.ps1"
echo     (iwr -useb 'https://spotx-official.github.io/SpotX/run.ps1').Content ^| Set-Content $tmp -Encoding UTF8 >> "%TEMP%\spotx_run.ps1"
echo } >> "%TEMP%\spotx_run.ps1"
echo & $tmp -new_theme -block_update_on -podcasts_off -adsections_off -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -language en >> "%TEMP%\spotx_run.ps1"

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "%TEMP%\spotx_run.ps1"

if %errorlevel% neq 0 (
    echo [ERROR] SpotX failed with code %errorlevel%
    pause & exit /b %errorlevel%
)

echo.
echo ====================================
echo  Step 2: Installing Spicetify CLI...
echo ====================================

echo [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 > "%TEMP%\spicetify_install.ps1"
echo $script = (iwr -useb 'https://raw.githubusercontent.com/spicetify/cli/main/install.ps1').Content >> "%TEMP%\spicetify_install.ps1"
echo $script = $script -replace '(?s)\$choice\s*=\s*\$Host\.UI\.PromptForChoice.*?(?=\n\S)', '' >> "%TEMP%\spicetify_install.ps1"
echo Invoke-Expression $script >> "%TEMP%\spicetify_install.ps1"

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -NonInteractive -ExecutionPolicy Bypass -File "%TEMP%\spicetify_install.ps1"

if %errorlevel% neq 0 (
    echo [ERROR] Spicetify CLI install failed with code %errorlevel%
    pause & exit /b %errorlevel%
)

echo.
echo ====================================
echo  Step 3: Installing Marketplace...
echo ====================================

echo [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 > "%TEMP%\spicetify_marketplace.ps1"
echo $script = (iwr -useb 'https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.ps1').Content >> "%TEMP%\spicetify_marketplace.ps1"
echo Invoke-Expression $script >> "%TEMP%\spicetify_marketplace.ps1"

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -NonInteractive -ExecutionPolicy Bypass -File "%TEMP%\spicetify_marketplace.ps1"

echo.
echo ====================================
echo  Step 4: Re-applying Spicetify...
echo ====================================

echo $env:PATH += ';' + [System.Environment]::GetEnvironmentVariable('PATH','User') > "%TEMP%\spicetify_apply.ps1"
echo spicetify apply >> "%TEMP%\spicetify_apply.ps1"

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -NonInteractive -ExecutionPolicy Bypass -File "%TEMP%\spicetify_apply.ps1"

echo.
echo ====================================
echo  All done! Open Spotify - Marketplace
echo  is in the left sidebar.
echo ====================================

exit /b
