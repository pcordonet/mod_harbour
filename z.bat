@echo off
cls
rem Inicialitzar repo git -> git init
rem Clonar el repositori -> git clone https://github.com/carles9000/mod_harbour.git
rem Inicialitzar origen -> git remote add origin https://github.com/carles9000/mod_harbour.git

rem *** Actualitzar ***
@echo Conectant amb repositori git...
@echo ===============================
git pull origin master
pause
