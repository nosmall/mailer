# Windows Command-Line Mailer

[English Version](README.en.md)

Jednoduchý nástroj pro odesílání e-mailů z příkazové řádky Windows pomocí dávkového souboru (`.bat`) a PowerShellu.

## Funkce

*   Odesílání e-mailů s příjemcem, předmětem a tělem zprávy.
*   Podpora pro přílohy.
*   Konfigurace SMTP serveru, portu, přihlašovacích údajů a adresy odesílatele přes externí konfigurační soubor.
*   Kompatibilní s Windows 7 a novějšími.

## Požadavky

*   Windows 7 nebo novější.
*   PowerShell 2.0 nebo novější (standardní součást Windows 7 a vyšších).

## Struktura souborů

```
.
├── .gitignore             # Specifikuje soubory ignorované Gitem
├── mailer.bat             # Hlavní spouštěcí skript
├── maillib/               # Podsložka pro pomocné soubory
│   ├── .mailer.example    # Vzorový konfigurační soubor (šablona)
│   ├── .mailer            # Váš lokální konfigurační soubor (vytvořený z .mailer.example, ignorován Gitem)
│   └── MailSender.ps1     # PowerShell skript s logikou odesílání
├── README.md              # Tento soubor (Česká verze)
└── README.en.md           # Anglická verze této dokumentace
```

## Konfigurace

Před prvním použitím je nutné nastavit parametry SMTP serveru:

1.  Vytvořte kopii souboru `maillib/.mailer.example` a pojmenujte ji `maillib/.mailer`.
2.  Otevřete soubor `maillib/.mailer` v textovém editoru a upravte následující hodnoty:

    *   `SmtpServer`: Adresa vašeho SMTP serveru (např. `smtp.gmail.com`, `smtp-relay.gmail.com`).
    *   `SmtpPort`: Port vašeho SMTP serveru (např. `587` nebo `465`).
    *   `SmtpUsername`: Vaše uživatelské jméno pro přihlášení k SMTP serveru.
    *   `SmtpPassword`: Vaše heslo pro SMTP server. **Důležité:** Pro Gmail s dvoufázovým ověřením použijte "Heslo pro aplikace".
    *   `EmailFromAddress`: E-mailová adresa, která se zobrazí jako odesílatel e-mailu.
    *   `UseSsl`: Nastavte na `true` pro použití SSL/TLS šifrování (doporučeno), nebo `false` jinak.

Příklad obsahu souboru `maillib/.mailer`:
```ini
SmtpServer=smtp.example.com
SmtpPort=587
SmtpUsername=user@example.com
SmtpPassword=MojeSuperTajneHeslo
EmailFromAddress=odesilatel@example.com
UseSsl=true
```

## Použití

Spusťte `mailer.bat` z příkazové řádky (`cmd.exe` nebo PowerShell) s požadovanými argumenty:

```batch
mailer.bat /to "prijemce@example.com" /subject "Predmet zpravy" /body "Telo zpravy" [/attachment "C:\cesta\k\priloze.txt"]
```

**Argumenty:**

*   `/to "adresa"`: (Povinné) E-mailová adresa příjemce.
*   `/subject "text"`: (Povinné) Předmět e-mailu.
*   `/body "text"`: (Povinné) Tělo e-mailu.
*   `/attachment "cesta"`: (Volitelné) Plná cesta k souboru, který má být přiložen.
*   `/?`: Zobrazí nápovědu.

**Příklady:**

*   Odeslání jednoduchého e-mailu:
    ```batch
    mailer.bat /to "jan.novak@example.com" /subject "Test" /body "Toto je testovaci zprava."
    ```

*   Odeslání e-mailu s přílohou:
    ```batch
    mailer.bat /to "jana.svobodova@example.com" /subject "Dokumenty" /body "Posilam pozadovane dokumenty v priloze." /attachment "D:\smlouvy\NavrhSmlouvy.pdf"
    ```

*   Zobrazení nápovědy (v PowerShellu je třeba použít `.\mailer.bat`):
    ```batch
    .\mailer.bat /?
    ```

## Kompatibilita

Tento nástroj byl primárně vyvinut a testován v prostředí Windows 11. Byl však navržen s důrazem na zpětnou kompatibilitu a měl by být funkční na systémech Windows 7 a novějších, které obsahují PowerShell verze 2.0 nebo vyšší.

## Vyloučení odpovědnosti

Tento software je poskytován "tak, jak je", bez jakékoli výslovné či implicitní záruky. V žádném případě autor nenese odpovědnost za jakékoli škody vzniklé použitím tohoto softwaru. Použití tohoto softwaru je na vlastní nebezpečí. Autor si vyhrazuje právo neposkytovat aktivní podporu ani negarantuje okamžité opravy případných chyb.
