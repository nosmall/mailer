#Requires -Version 2.0

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$To,

    [Parameter(Mandatory=$true)]
    [string]$Subject,

    [Parameter(Mandatory=$true)]
    [string]$Body,

    [Parameter(Mandatory=$false)]
    [string]$Attachment,

    [Parameter(Mandatory=$false)]
    [string[]]$Cc,

    [Parameter(Mandatory=$false)]
    [string[]]$Bcc
)

# Nastavení kódování výstupu pro konzoli
$OutputEncoding = [System.Text.Encoding]::UTF8

# --- Načtení konfigurace z externího souboru ---
$ConfigFilePath = Join-Path -Path $PSScriptRoot -ChildPath ".mailer"
$Config = @{}

if (Test-Path $ConfigFilePath) {
    Get-Content $ConfigFilePath | ForEach-Object {
        $line = $_.Trim()
        if ($line -and $line -notmatch "^\s*#" -and $line -match "=") {
            $name, $value = $line.Split("=", 2).Trim()
            $Config[$name] = $value
        }
    }
} else {
    Write-Error "Konfiguracni soubor '$ConfigFilePath' nebyl nalezen."
    exit 1
}

# Přiřazení konfiguračních hodnot proměnným
$SmtpServer = $Config["SmtpServer"]
$SmtpPort = $Config["SmtpPort"]
$SmtpUsername = $Config["SmtpUsername"]
$SmtpPassword = $Config["SmtpPassword"]
$EmailFromAddress = $Config["EmailFromAddress"]
$UseSslString = $Config["UseSsl"]

# Kontrola povinných konfiguračních hodnot
if (-not $SmtpServer -or -not $SmtpPort -or -not $SmtpUsername -or -not $SmtpPassword -or -not $EmailFromAddress -or -not $UseSslString) {
    Write-Error "Nektera z povinnych polozek v konfiguracnim souboru '$ConfigFilePath' chybi nebo je prazdna."
    Write-Error "Ocekavane polozky: SmtpServer, SmtpPort, SmtpUsername, SmtpPassword, EmailFromAddress, UseSsl"
    exit 1
}

# Převod SmtpPort na integer a UseSsl na boolean
try {
    $SmtpPort = [int]$SmtpPort
} catch {
    Write-Error "Hodnota SmtpPort ('$SmtpPort') v konfiguracnim souboru neni platne cele cislo."
    exit 1
}

$UseSsl = $false
if ($UseSslString -eq "true") {
    $UseSsl = $true
} elseif ($UseSslString -ne "false") {
    Write-Error "Hodnota UseSsl ('$UseSslString') v konfiguracnim souboru musi byt 'true' nebo 'false'."
    exit 1
}
# --- Konec načtení konfigurace ---

# Vytvoření přihlašovacích údajů
# Heslo je potřeba převést na SecureString
$SecurePassword = ConvertTo-SecureString -String $SmtpPassword -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($SmtpUsername, $SecurePassword)

# Parametry pro Send-MailMessage
$MailParams = @{
    From = $EmailFromAddress # Pouzije se adresa definovana v $EmailFromAddress
    To = $To
    Subject = $Subject
    Body = $Body
    SmtpServer = $SmtpServer
    Port = $SmtpPort
    Credential = $Credential
    Encoding = ([System.Text.Encoding]::UTF8) # Zajištění správného kódování pro české znaky
}

if ($UseSsl) {
    $MailParams.UseSsl = $true
}

if ($Cc) {
    $MailParams.Cc = $Cc
}

if ($Bcc) {
    $MailParams.Bcc = $Bcc
}

if (-not [string]::IsNullOrEmpty($Attachment)) {
    if (Test-Path $Attachment) {
        $MailParams.Attachments = $Attachment
    } else {
        Write-Warning "Priloha nebyla nalezena na ceste: $Attachment"
        # Můžete se rozhodnout, zda v tomto případě e-mail neodeslat, nebo odeslat bez přílohy
        # Prozatím skript poběží dál a odešle e-mail bez přílohy, pokud nebyla nalezena.
    }
}

try {
    Write-Verbose "Pokousim se odeslat e-mail na $To s predmetem '$Subject'..." -Verbose
    Send-MailMessage @MailParams
    Write-Verbose "E-mail byl uspesne zarazen k odeslani." -Verbose
    # Exit s kódem 0 pro úspěch (pro BAT soubor)
    exit 0
}
catch {
    Write-Error "Chyba pri odesilani e-mailu: $($_.Exception.Message)"
    # Exit s kódem 1 pro neúspěch (pro BAT soubor)
    exit 1
}
