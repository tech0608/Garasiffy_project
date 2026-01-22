@echo off
echo ==========================================
echo   Garasifyy Auto-Deploy Fixer
echo ==========================================
echo.
echo 1. Building Web App (Release Mode)...
echo    PLEASE WAIT, this may take 1-2 minutes...
call flutter build web --release --base-href "/" --no-tree-shake-icons
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Build Gagal! Pastikan tidak ada error di kodingan.
    pause
    exit /b %errorlevel%
)

echo.
echo 2. Adding Build Files to Git...
git add build/web -f

echo.
echo 3. Committing Changes...
git commit -m "Deploy: Manual Netlify Fix"

echo.
echo 4. Pushing to GitHub...
git push origin main

echo.
echo ==========================================
echo   SELESAI! Silakan cek Netlify sekarang.
echo ==========================================
pause
