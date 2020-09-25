@echo off
cd "C:\PC.RADIO\"
start /MIN "Music Player Daemon" "C:\PC.RADIO\mpd.exe" "C:\PC.RADIO\mpd.conf" --kill --no-daemon --stderr --verbose
start /MIN "CGI HTTP Server" "C:\Program Files\GNURadio-3.7\gr-python27\python.exe" -m CGIHTTPServer 1234
"C:\PC.RADIO\mpc.exe" stop > NUL
"C:\PC.RADIO\mpc.exe" clear > NUL
"C:\PC.RADIO\mpc.exe" volume 50 > NUL
type "C:\PC.RADIO\playlist.db" | "C:\PC.RADIO\mpc.exe" add > NUL
start chrome --kiosk "http://localhost:1234/index.html"
rem start firefox --kiosk "http://localhost:1234/index.html"
rem start msedge --kiosk "http://localhost:1234/index.html"
