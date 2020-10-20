@echo off
cd "C:\PC.RADIO\"
curl --fail --output "C:\PC.RADIO\yp.xml" "http://dir.xiph.org/yp.xml"
"C:\Program Files\GNURadio-3.7\gr-python27\python.exe" "C:\PC.RADIO\cgi-bin\set_random.py"
del /f "C:\PC.RADIO\yp.xml"
echo.
echo.
echo All Done!
echo.
echo.
pause
