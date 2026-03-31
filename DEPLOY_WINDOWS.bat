@echo off
REM ================================================================
REM Playa Bowls Nashville — Deploy to GitHub + Vercel (Windows)
REM Double-click this file, or run it in a terminal.
REM ================================================================

SET GITHUB_USERNAME=hwanderson05-beep
SET REPO_NAME=playa-bowls-nashville

echo.
echo 🌴  Playa Bowls Nashville — Deploy Script
echo =========================================
echo.

REM Check for gh CLI
where gh >nul 2>nul
IF ERRORLEVEL 1 (
  echo Please install GitHub CLI from https://cli.github.com then re-run this script.
  pause
  exit /b 1
)

REM Login
echo Checking GitHub authentication...
gh auth status >nul 2>nul
IF ERRORLEVEL 1 (
  echo Opening browser to log in...
  gh auth login --web -h github.com
)
echo GitHub authenticated.
echo.

REM Create repo and push
echo Creating GitHub repo and pushing code...
gh repo create %REPO_NAME% --public --description "Playa Bowls Nashville Astro website" --source=. --remote=origin --push
echo.
echo Repo live at: https://github.com/%GITHUB_USERNAME%/%REPO_NAME%
echo.

REM Install Vercel CLI
where vercel >nul 2>nul
IF ERRORLEVEL 1 (
  echo Installing Vercel CLI...
  npm install -g vercel
)

REM Deploy
echo Deploying to Vercel...
vercel --prod --yes

echo.
echo All done! Check your Vercel dashboard for the live URL.
pause
