*[Home](README.md)*

# Node.js & npm Setup Guide — Windows 11

## What You'll Install

- **Node.js** v24 (current LTS / stable)
- **npm** v11 (comes bundled with Node.js — no separate install needed)

---

## Step 1 — Download Node.js

1. Go to **[https://nodejs.org](https://nodejs.org)**
2. Click the **"Get Node.js"** button
3. Click the `Windows Installer (.msi)` button to download the installer

---

## Step 2 — Run the Installer

1. Open the downloaded `.msi` file
2. Click **Next** through the prompts, accepting the licence agreement
3. Leave all default settings as-is (install path, features, etc.)
4. On the **"Tools for Native Modules"** screen, you can leave the checkbox **unchecked** unless you know you need it
5. Click **Install**, then **Finish**

---

## Step 3 — Verify the Installation

Open **Command Prompt** or **PowerShell** and run:

```
node --version
```
```
npm --version
```

You should see version numbers printed for both. If you do, you're done ✅

---

## Troubleshooting

**Command not found after install?**
Restart your terminal (or your PC) — the PATH environment variable needs to refresh.

*[Home](README.md)*
