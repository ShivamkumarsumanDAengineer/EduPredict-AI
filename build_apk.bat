@echo off
echo ========================================================
echo       EduPredict AI - Android APK Build Tool
echo ========================================================
echo.

where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flutter is not found in your system PATH!
    echo Please install Flutter or open this project in VS Code and run "Flutter: Download SDK".
    echo.
    pause
    exit /b 1
)

echo [1/3] Fetching Flutter dependencies...
call flutter pub get

echo.
echo [2/3] Compiling Release Android APK...
call flutter build apk --release

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo [SUCCESS] APK created successfully!
    echo Location: build\app\outputs\flutter-apk\app-release.apk
    echo ========================================================
    echo.
    explorer build\app\outputs\flutter-apk
) else (
    echo.
    echo [ERROR] Android build failed. Check that Android SDK and JDK 17 are installed.
)

pause

