# Windows Command-Line Mailer

[Česká verze](README.md)

A simple tool for sending emails from the Windows command line using a batch file (`.bat`) and PowerShell.

## Features

*   Sending emails with recipient, subject, and message body.
*   Support for CC (Carbon Copy) and BCC (Blind Carbon Copy).
*   Attachment support.
*   Configuration of SMTP server, port, credentials, and sender address via an external configuration file.
*   Compatible with Windows 7 and newer.
*   **Current limitations:** The script in its current version does not support proper handling of diacritics, HTML code, or most special characters in the email body or subject when used via `mailer.bat`. Issues may arise, especially with encoding.

## Requirements

*   Windows 7 or newer.
*   PowerShell 2.0 or newer (standard component of Windows 7 and higher).

## File Structure

```
.
├── .gitignore             # Specifies files ignored by Git
├── mailer.bat             # Main execution script
├── maillib/               # Subfolder for auxiliary files
│   ├── .mailer.example    # Example configuration file (template)
│   ├── .mailer            # Your local configuration file (created from .mailer.example, ignored by Git)
│   └── MailSender.ps1     # PowerShell script with sending logic
├── README.md              # Czech version of this documentation
└── README.en.md           # This file (English version)
```

## Configuration

Before first use, it is necessary to set the SMTP server parameters:

1.  Create a copy of the `maillib/.mailer.example` file and name it `maillib/.mailer`.
2.  Open the `maillib/.mailer` file in a text editor and modify the following values:

    *   `SmtpServer`: Address of your SMTP server (e.g., `smtp.gmail.com`, `smtp-relay.gmail.com`).
    *   `SmtpPort`: Port of your SMTP server (e.g., `587` or `465`).
    *   `SmtpUsername`: Your username for logging into the SMTP server.
    *   `SmtpPassword`: Your password for the SMTP server. **Important:** For Gmail with 2-Step Verification, use an "App Password".
    *   `EmailFromAddress`: The email address that will be displayed as the sender of the email.
    *   `UseSsl`: Set to `true` to use SSL/TLS encryption (recommended), or `false` otherwise.

Example content of the `maillib/.mailer` file:
```ini
SmtpServer=smtp.example.com
SmtpPort=587
SmtpUsername=user@example.com
SmtpPassword=MySuperSecretPassword
EmailFromAddress=sender@example.com
UseSsl=true
```

## Usage

Run `mailer.bat` from the command line (`cmd.exe` or PowerShell) with the required arguments:

```batch
mailer.bat /to "recipient@example.com" /subject "Message Subject" /body "Message Body" [/cc "cc@example.com"] [/bcc "bcc@example.com"] [/attachment "C:\path\to\attachment.txt"]
```

**Arguments:**

*   `/to "address"`: (Required) Email address of the recipient.
*   `/subject "text"`: (Required) Subject of the email.
*   `/body "text"`: (Required) Body of the email.
*   `/cc "addresses"`: (Optional) Email addresses for CC, comma-separated.
*   `/bcc "addresses"`: (Optional) Email addresses for BCC, comma-separated.
*   `/attachment "path"`: (Optional) Full path to the file to be attached.
*   `/?`: Displays help.

**Examples:**

*   Sending a simple email:
    ```batch
    mailer.bat /to "john.doe@example.com" /subject "Test" /body "This is a test message."
    ```

*   Sending an email with an attachment:
    ```batch
    mailer.bat /to "jane.smith@example.com" /subject "Documents" /body "Sending requested documents in attachment." /attachment "D:\contracts\ContractDraft.pdf"
    ```

*   Sending an email with CC and BCC:
    ```batch
    mailer.bat /to "recipient@example.com" /subject "Information with copies" /body "This is important information." /cc "boss@example.com,assistant@example.com" /bcc "secret@example.com"
    ```

*   Displaying help (in PowerShell, `.\mailer.bat` must be used):
    ```batch
    .\mailer.bat /?
    ```

## Compatibility

This tool was primarily developed and tested on Windows 11. However, it has been designed with backward compatibility in mind and should be functional on Windows 7 and newer systems that include PowerShell version 2.0 or higher.

## Disclaimer

This software is provided "as is", without any express or implied warranty. In no event shall the author be liable for any damages arising from the use of this software. Use of this software is at your own risk. The author reserves the right not to provide active support and does not guarantee immediate fixes for any bugs.
