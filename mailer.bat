@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

rem Verze aplikace
rem MAJOR - hlavní verze, mění se při nekompatibilních změnách
rem MINOR - vedlejší verze, mění se při přidání funkcionality
rem PATCH - opravy chyb, mění se při opravách chyb
set "APP_VERSION=1.1.0"

rem Inicializace proměnných
set "to_param="
set "subject_param="
set "body_param="
set "attachment_param="
set "cc_param="
set "bcc_param="
set "show_help=0"

rem Zpracování argumentů
:loop
if "%1"=="" goto end_loop
set "arg1=%~1"
set "arg2=%~2"

if /i "!arg1!"=="/to" (
    set "to_param=!arg2!"
    shift
    shift
    goto loop
)
if /i "!arg1!"=="/subject" (
    set "subject_param=!arg2!"
    shift
    shift
    goto loop
)
if /i "!arg1!"=="/body" (
    set "body_param=!arg2!"
    shift
    shift
    goto loop
)
if /i "!arg1!"=="/attachment" (
    set "attachment_param=!arg2!"
    shift
    shift
    goto loop
)
if /i "!arg1!"=="/cc" (
    set "cc_param=!arg2!"
    shift
    shift
    goto loop
)
if /i "!arg1!"=="/bcc" (
    set "bcc_param=!arg2!"
    shift
    shift
    goto loop
)
if /i "!arg1!"=="/?" (set "show_help=1" & goto end_loop)
if /i "!arg1!"=="-h" (set "show_help=1" & goto end_loop)
if /i "!arg1!"=="--help" (set "show_help=1" & goto end_loop)
if /i "!arg1!"=="/version" (echo Verze: !APP_VERSION! & goto end)
if /i "!arg1!"=="-v" (echo Verze: !APP_VERSION! & goto end)
if /i "!arg1!"=="--version" (echo Verze: !APP_VERSION! & goto end)

echo Neznámý parametr: !arg1!
set "show_help=1"
goto end_loop

:end_loop

if "%show_help%"=="1" goto help
if "%to_param%"=="" (echo Chyba: Parametr /to je povinny. & set "show_help=1")
if "%subject_param%"=="" (echo Chyba: Parametr /subject je povinny. & set "show_help=1")
if "%body_param%"=="" (echo Chyba: Parametr /body je povinny. & set "show_help=1")
if "%show_help%"=="1" goto help

rem Sestavení cesty k PowerShell skriptu (očekává se v podsložce 'maillib')
set "script_path=%~dp0maillib\MailSender.ps1"

rem Sestavení PowerShell příkazu
set "ps_core_command=& \"!script_path!\" -To '!to_param!' -Subject '!subject_param!' -Body '!body_param!'"
if not "!attachment_param!"=="" (
    set "ps_core_command=!ps_core_command! -Attachment '!attachment_param!'"
)
if not "!cc_param!"=="" (
    set "ps_core_command=!ps_core_command! -Cc '!cc_param!'"
)
if not "!bcc_param!"=="" (
    set "ps_core_command=!ps_core_command! -Bcc '!bcc_param!'"
)
set "ps_full_command=[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; !ps_core_command!"

rem Spuštění PowerShell skriptu
echo Odesilam e-mail...
powershell.exe -ExecutionPolicy Bypass -NoProfile -NonInteractive -Command "!ps_full_command!"
echo(
if errorlevel 1 (
    echo Chyba pri odesilani e-mailu. Zkontrolujte vystup PowerShellu.
) else (
    echo E-mail byl uspesne zarazen k odeslani.
)
goto end

:help
echo(
echo Pouziti: mailer.bat /to "prijemce" /subject "predmet" /body "telo_emailu" [/attachment "cesta_k_priloze"] [/cc "kopie"] [/bcc "skryta_kopie"]
echo(
echo Parametry:
echo   - /to          E-mailova adresa prijemce (povinne).
echo   - /subject     Predmet e-mailu (povinne).
echo   - /body        Obsah (telo) e-mailu (povinne).
echo   - /attachment  Cesta k souboru prilohy (volitelne).
echo   - /cc          E-mailove adresy pro kopii (volitelne, oddelene carkou).
echo   - /bcc         E-mailove adresy pro skrytou kopii (volitelne, oddelene carkou).
echo   - /version     Zobrazi verzi aplikace (aliasy: -v, --version).
echo   - /?           Zobrazi tuto napovedu.
echo(
echo Priklad:
echo   mailer.bat /to "nekdo@example.com" /subject "Testovaci email" /body "Toto je test."
echo   mailer.bat /to "nekdo@example.com" /subject "Email s prilohou" /body "Viz priloha." /attachment "C:\dokumenty\priloha.pdf"
echo   mailer.bat /to "prijemce@example.com" /subject "Email s kopii" /body "Test" /cc "kopie@example.com,dalsi.kopie@example.com"
echo(
goto end

:end
endlocal
