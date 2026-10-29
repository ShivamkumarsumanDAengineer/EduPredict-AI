@echo off
echo ========================================================
echo        EduPredict AI - Mobile Web Server
echo ========================================================
echo.
for /f "tokens=4" %%a in ('route print ^| findstr 0.0.0.0.*0.0.0.0') do (
    set LOCAL_IP=%%a
)

echo Starting mobile server...
echo.
echo ========================================================
echo   Open this URL in your phone's browser (same Wi-Fi):
echo.
echo        http://10.196.18.239:8080
echo.
echo ========================================================
echo.
python -m http.server 8080 --bind 0.0.0.0
pause

