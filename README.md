MikroTik PPPoE Auto-Disconnect for Expired Users

![MikroTik](https://img.shields.io/badge/Platform-MikroTik%20RouterOS-red)
![License](https://img.shields.io/badge/License-MIT-blue)
![Function](https://img.shields.io/badge/Function-Billing%20Automation-purple)

## 📖 Overview
Managing monthly bills for 1000+ PPPoE users manually is a nightmare. This repository provides a **Production-Ready Script** that automates the process of disconnecting expired users.

Instead of manually disabling secrets, this script checks the **"Comment"** section of each user for an expiry date (Format: `EXP: YYYY-MM-DD`). If the date has passed, the user is automatically disabled and their active session is terminated.

## 🛠 Features
- 📅 **Date-Based Logic:** Compares System Date with User's Expiry Date.
- 🚫 **Instant Termination:** Kills active PPPoE connections immediately upon expiration.
- 🔒 **Auto-Disable:** Disables the PPP Secret so they cannot reconnect.
- 📝 **Log Generation:** Creates a log entry for every user disconnected (Auditable).

## ⚙️ How It Works
1.  **Admin Input:** When creating a user, the Admin adds a comment: `Client Name | EXP: 2026-02-01`.
2.  **Scheduler:** The script runs every night at 12:00 AM.
3.  **Parsing:** It reads the date from the comment.
4.  **Action:** If `CurrentDate > ExpiryDate`, the user is disabled.

## 🚀 Installation Guide

### Step 1: Create the Script
Go to **System > Scripts**, create a new script named `auto_suspend`, and paste the code from `billing_script.rsc`.

### Step 2: Create a Scheduler
Go to **System > Scheduler** and add a new schedule:
- **Name:** `Daily_Billing_Check`
- **Interval:** `1d 00:00:00`
- **On Event:** `/system script run auto_suspend`

## ⚠️ Important
Ensure your Router's **System Clock (NTP)** is synchronized. If the date is wrong, users might get disconnected incorrectly.

---
**Author:** Sheikh Alamin Santo  
*Cloud Infrastructure Specialist & System Administrator*
