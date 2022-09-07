@echo off
mode con:cols=100 lines=30
query session
echo
set /p usersession= Enter the session ID: 
mstsc /shadow:%usersession% /control /noconsentprompt

