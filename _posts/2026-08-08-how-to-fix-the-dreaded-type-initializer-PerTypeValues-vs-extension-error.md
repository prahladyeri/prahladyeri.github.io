---
layout: post
title: "Fix: 'The type initializer for PerTypeValues threw an exception' in Visual Studio"
tags: dotnet visual-studio windows
published: true
image: /uploads/dotnet-feature-image.png
---

Yesterday, I was trying to install the [RDLC Report Designer Extension](https://marketplace.visualstudio.com/items?itemName=ProBITools.MicrosoftRdlcReportDesignerforVisualStudio2022&ssr=false) for my Visual Studio 2022 and I was greeted with a strange and obnoxious error right after double-clicking the vsix installation file:

> The type initializer for 'PerTypeValues'1' threw an exception.

Unfortunately, this error is notorious for being overly generic and turning up at the most inopportune moments. Consequently, the Internet is quite littered with both the diagnostic logs and varied solutions. After a lengthy troubleshooting session, I was finally able to install the extension successfully, and I hope one of these methods works for you.

### What Didn't Work Initially

First, I tried the most obvious solutions:
* Ensured Visual Studio was completely closed during installation.
* Cleared temp folders like `%localappdata%\temp` and `%localappdata%\Microsoft\VisualStudio\17.0_XXXXXXXX`.
* Executed `VSIXInstaller.exe` directly from an elevated Administrator command prompt:

```bash
"C:\Program Files\Microsoft Visual Studio\Installer\resources\app\ServiceHub\Services\Microsoft.VisualStudio.Setup.Service\VSIXInstaller.exe" "C:\Path\To\Your\DownloadedExtension.vsix"
```

* Tried [repairing the Visual Studio installation](https://developercommunity.visualstudio.com/t/Cant-installupdate-extensions-in-VS-20/10781598?sort=newest&type=idea).
* Checked for Global Assembly Cache (GAC) mismatches. According to [Microsoft Developer Community logs](https://developercommunity.visualstudio.com/t/VSIX-Installer-exception:-The-type-init/10542953?sort=newest), this exception is often linked to a broken `System.Runtime.CompilerServices.Unsafe` assembly mismatch in the GAC. Force-registering the correct version didn't resolve it in my case either.

---

### The Workaround: Manual Extraction

Since automated installation kept failing, I resorted to a manual workaround: extracting the VSIX package directly into Visual Studio's extensions directory.

*(Note: `.vsix` files are simply ZIP archives. You can rename the file extension to `.zip` or open it with 7-Zip/WinRAR).*

1. Extract the `.vsix` package contents into a dedicated folder inside:
`C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\Extensions\<ExtensionNameFolder>`
2. Relaunch Visual Studio.

If Visual Studio still doesn't recognize the extension after copying, try applying the following tweaks.

---

### Tweaks That Resolved the Issue

#### Tweak 1: Reset Configuration via Developer Command Prompt

1. Close all Visual Studio instances.
2. Open the **Developer Command Prompt for VS 2022** (as Administrator).
3. Reset settings and update configuration:

```bash
devenv /ResetSettings
devenv /updateConfiguration
```

4. Reopen Visual Studio 2022, navigate to **Extensions > Manage Extensions**, and check if the extension is active.

#### Tweak 2: Fix Manifest Restrictions for Enterprise/Professional SKUs

Certain marketplace listings (including older builds of the RDLC Report Designer) contain a manifest target restriction that limits installation strictly to the Community edition, causing the installer engine to throw initialization errors on Professional or Enterprise editions:

1. Open `extension.vsixmanifest` inside the extracted folder using Notepad.
2. Update the `InstallationTarget.Id` value from `Microsoft.VisualStudio.Community` to `Microsoft.VisualStudio.IntegratedShell`:

```xml
<InstallationTarget Id="Microsoft.VisualStudio.IntegratedShell" Version="[17.0,19.0)"/>

```

---

### Additional Fixes Worth Trying

If you are still stuck, try these additional fixes:

* **Clear `ComponentModelCache`:** Delete the folder located at `%localappdata%\Microsoft\VisualStudio\17.0_<InstanceID>\ComponentModelCache` and restart Visual Studio to force it to rebuild its extension MEF cache.
* **Unblock the VSIX File:** Right-click your downloaded `.vsix` file, open **Properties**, check **Unblock** at the bottom, and click **Apply**.
* **Force Extension Cache Refresh:** Touch or create a zero-byte file named `extensions.configuration.changed` inside `C:\Program Files\Microsoft Visual Studio\2022\<Edition>\Common7\IDE\Extensions\` before launching Visual Studio.

Troubleshooting Visual Studio installation errors often feels like navigating the Triwizard Tournament maze, but hopefully, one of these routes helps you cross the finish line! Happy Coding.