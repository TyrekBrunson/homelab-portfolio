#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════════════╗
# ║   Home Lab Documentation Site — Directory & Placeholder Setup    ║
# ║   Run from inside your "Home Lab/" folder:  bash setup.sh        ║
# ╚═══════════════════════════════════════════════════════════════════╝

# ── Colors ──────────────────────────────────────────────────────────
GRN='\033[0;32m'; YLW='\033[1;33m'; BLU='\033[0;34m'
CYN='\033[0;36m'; RED='\033[0;31m'; DIM='\033[2m'; RST='\033[0m'
BOLD='\033[1m'

# ── Helpers ─────────────────────────────────────────────────────────
made_dirs=0; made_files=0; skipped=0

mkd() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
    echo -e "  ${GRN}+${RST} ${BLU}dir${RST}   $1"
    (( made_dirs++ ))
  else
    echo -e "  ${DIM}·${RST} ${DIM}exists${RST} $1"
  fi
}

# touch only if file does not already exist — never overwrites real content
mkf() {
  local path="$1"; local note="$2"
  if [ ! -f "$path" ]; then
    # Write a one-line placeholder comment so the file isn't totally empty
    echo "# PLACEHOLDER — replace with real file: $(basename "$path")${note:+ ($note)}" > "$path"
    echo -e "  ${YLW}+${RST} ${CYN}file${RST}  $path"
    (( made_files++ ))
  else
    echo -e "  ${DIM}·${RST} ${DIM}exists${RST} $path"
    (( skipped++ ))
  fi
}

# ── Banner ───────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GRN}╔══════════════════════════════════════════════════════╗${RST}"
echo -e "${BOLD}${GRN}║  Tyrek Brunson — Home Lab Site Setup                ║${RST}"
echo -e "${BOLD}${GRN}╚══════════════════════════════════════════════════════╝${RST}"
echo ""

# ── Confirm we're in the right place ────────────────────────────────
if [ ! -f "index.html" ]; then
  echo -e "${RED}✗  index.html not found.${RST}"
  echo -e "   Run this script from inside your ${BOLD}Home Lab/${RST} folder."
  echo -e "   Example:  cd ~/Projects/Home\\ Lab && bash setup.sh"
  echo ""
  exit 1
fi

echo -e "${DIM}Working directory: $(pwd)${RST}"
echo ""

# ════════════════════════════════════════════════════
# 1.  CORE DIRECTORIES
# ════════════════════════════════════════════════════
echo -e "${BOLD}[ Directories ]${RST}"

mkd "images"
mkd "images/homelab"
mkd "images/projects"
mkd "images/CompTIA Certs"   # mirrors your existing folder name
mkd "resume"                 # holds your downloadable resume file

echo ""

# ════════════════════════════════════════════════════
# 1.5  AUTO-RENAME: Hytale screenshots already sitting
#      in images/projects/ under their original
#      Screenshot_YYYYMMDD_HHMMSS.png names
# ════════════════════════════════════════════════════
echo -e "${BOLD}[ Hytale Screenshot Auto-Rename ]${RST}"
echo -e "${DIM}  Renaming raw Screenshot_*.png files in images/projects/ to their${RST}"
echo -e "${DIM}  documented hytale-NN-*.png names${RST}"

renamed=0

# Renames $1 -> $2 (both relative to images/projects/) if $1 exists.
# Won't overwrite $2 if it already exists and looks like a real image (>2KB).
rename_shot() {
  local src="images/projects/$1"
  local dst="images/projects/$2"
  if [ -f "$src" ]; then
    if [ -f "$dst" ] && [ "$(stat -c%s "$dst" 2>/dev/null || echo 0)" -gt 2048 ]; then
      echo -e "  ${DIM}·${RST} skip — ${CYN}$2${RST} already exists"
    else
      mv -f "$src" "$dst"
      echo -e "  ${GRN}✓${RST} $1 ${GRN}→${RST} ${CYN}$2${RST}"
      (( renamed++ ))
    fi
  fi
}

rename_shot "Screenshot_20260614_174551.png" "hytale-01-boot-auth.png"
rename_shot "Screenshot_20260614_175012.png" "hytale-02-auth-success.png"
rename_shot "Screenshot_20260614_175133.png" "hytale-03-files-initial.png"
rename_shot "Screenshot_20260614_175734.png" "hytale-04-files-backup.png"
rename_shot "Screenshot_20260614_175904.png" "hytale-05-startbat.png"
rename_shot "Screenshot_20260614_180319.png" "hytale-06-config-json.png"
rename_shot "Screenshot_20260614_181231.png" "hytale-07-hostname.png"
rename_shot "Screenshot_20260614_181533.png" "hytale-08-firewall-rule.png"
rename_shot "Screenshot_20260614_181652.png" "hytale-09-ipconfig.png"
rename_shot "Screenshot_20260614_181922.png" "hytale-10-launcher-private.png"
rename_shot "Screenshot_20260614_181948.png" "hytale-11-edit-server.png"
rename_shot "Screenshot_20260614_182147.png" "hytale-12-ingame-dungeon.png"
rename_shot "Screenshot_20260614_182334.png" "hytale-13-ingame-chat.png"
rename_shot "Screenshot_20260614_182357.png" "hytale-14-server-log-chat.png"
rename_shot "Screenshot_20260614_182538.png" "hytale-15-server-log-op.png"
rename_shot "Screenshot_20260614_182602.png" "hytale-16-ingame-operator.png"
rename_shot "Screenshot_20260614_182923.png" "hytale-17-router-portforward.png"
rename_shot "Screenshot_20260614_184138.png" "hytale-18-launcher-both-servers.png"
rename_shot "Screenshot_20260614_184148.png" "hytale-19-connecting.png"

if [ "$renamed" -eq 0 ]; then
  echo -e "  ${DIM}· no matching Screenshot_*.png files found (already renamed?)${RST}"
else
  echo -e "  ${GRN}Renamed $renamed screenshot(s)${RST}"
fi

echo ""

# ════════════════════════════════════════════════════
# 2.  HOMELAB PHOTOS  →  images/homelab/
# ════════════════════════════════════════════════════
echo -e "${BOLD}[ Hardware & Lab Photos ]${RST}"
echo -e "${DIM}  images/homelab/ — drop real photos here, same filenames${RST}"

# Main PC
mkf "images/homelab/pc-front.jpg"        "Main PC front view"
mkf "images/homelab/pc-inside.jpg"       "Main PC internal build"
mkf "images/homelab/desk-setup.jpg"      "Full desk setup"

# Alienware / Proxmox
mkf "images/homelab/alienware-front.jpg" "Alienware Alpha R1 front view"
mkf "images/homelab/proxmox-ui.png"      "Proxmox VE dashboard screenshot"

# Network
mkf "images/homelab/network-diagram.png" "Network topology diagram"

# General lab gallery (photo1–photo4 used by the lab gallery section)
mkf "images/homelab/photo1.jpg"          "Lab gallery photo 1"
mkf "images/homelab/photo2.jpg"          "Lab gallery photo 2"
mkf "images/homelab/photo3.jpg"          "Lab gallery photo 3"
mkf "images/homelab/photo4.jpg"          "Lab gallery photo 4"

echo ""

# ════════════════════════════════════════════════════
# 3.  PROJECT SCREENSHOTS  →  images/projects/
# ════════════════════════════════════════════════════
echo -e "${BOLD}[ Project Screenshots ]${RST}"
echo -e "${DIM}  images/projects/ — drop real screenshots here, same filenames${RST}"

# Computer Repair Report Generator
mkf "images/projects/report-gen-1.png"   "Report Generator — main UI"
mkf "images/projects/report-gen-2.png"   "Report Generator — secondary view"

# Active Directory Lab — Part 1
mkf "images/projects/ad-lab-1.png"       "AD Lab — ADUC OU structure"
mkf "images/projects/ad-lab-2.png"       "AD Lab — user/group creation"
mkf "images/projects/ad-lab-3.png"       "AD Lab — domain controller / Server Manager"

# Active Directory Lab — Part 2 (GPO)
mkf "images/projects/ad-gpo-1.png"       "AD Lab GPO — GPMC console overview"
mkf "images/projects/ad-gpo-2.png"       "AD Lab GPO — Password Policy settings"
mkf "images/projects/ad-gpo-3.png"       "AD Lab GPO — Drive Mapping GPO"
mkf "images/projects/ad-gpo-4.png"       "AD Lab GPO — USB restriction policy"

# Active Directory Lab — Part 3 (Domain Join & GPO Testing)
mkf "images/projects/ad-gpo-join-1.png"  "AD Lab Part 3 — Domain join system properties"
mkf "images/projects/ad-gpo-join-2.png"  "AD Lab Part 3 — Welcome to domain message"
mkf "images/projects/ad-gpo-test-1.png"  "AD Lab Part 3 — gpupdate /force output"
mkf "images/projects/ad-gpo-test-2.png"  "AD Lab Part 3 — Control Panel blocked by GPO"

# AD Lab Part 3 — Troubleshooting screenshots
mkf "images/projects/ts-settings-crash.png"      "Troubleshooting — Settings app crashing"
mkf "images/projects/ts-event-viewer.png"         "Troubleshooting — Event Viewer DCOM 10010 error"
mkf "images/projects/ts-gpresult.png"             "Troubleshooting — gpresult showing NoControlPanel"
mkf "images/projects/ts-gpo-security-filter.png"  "Troubleshooting — GPO Security Filtering fix in GPMC"
mkf "images/projects/ts-settings-fixed.png"       "Troubleshooting — Settings working after fix"

# AD Lab Part 3 — Troubleshooting Issue 2 (DNS / Domain Join)
mkf "images/projects/ts2-domain-error.png"         "Troubleshooting 2 — Domain controller could not be contacted error"
mkf "images/projects/ts2-wrong-dns.png"            "Troubleshooting 2 — ipconfig showing router as DNS (192.168.1.254)"
mkf "images/projects/ts2-nslookup-fail.png"        "Troubleshooting 2 — nslookup ProxMox.local failing via router"
mkf "images/projects/ts2-nslookup-fixed.png"       "Troubleshooting 2 — nslookup resolving correctly through DC"
mkf "images/projects/ts2-domain-joined.png"        "Troubleshooting 2 — Welcome to ProxMox.local domain message"

# Active Directory Lab — Part 4 (File Services & FSRM)
mkf "images/projects/ad-fs-share-perms.png"  "AD Lab Part 4 — Share Permissions dialog"
mkf "images/projects/ad-fs-ntfs-perms.png"   "AD Lab Part 4 — NTFS Permissions / Security tab"
mkf "images/projects/ad-fs-map-drive.png"    "AD Lab Part 4 — Map Network Drive dialog on client"
mkf "images/projects/ad-fs-gpo-map.png"      "AD Lab Part 4 — GPO Drive Map preferences editor"
mkf "images/projects/ad-fs-quota.png"        "AD Lab Part 4 — FSRM Quota configuration"
mkf "images/projects/ad-fs-filescreen.png"   "AD Lab Part 4 — FSRM File Screen configuration"

# Active Directory Lab — Part 5 (Security Policies)
mkf "images/projects/ad-sec-password-policy.png"  "AD Lab Part 5 — Password Policy GPO settings"
mkf "images/projects/ad-sec-complexity-fail.png"  "AD Lab Part 5 — Weak password rejected by complexity policy"
mkf "images/projects/ad-sec-lockout-policy.png"   "AD Lab Part 5 — Account Lockout Policy settings"
mkf "images/projects/ad-sec-lockout-test.png"     "AD Lab Part 5 — Account locked out message after failed attempts"
mkf "images/projects/ad-sec-user-rights.png"      "AD Lab Part 5 — User Rights Assignment GPO"
mkf "images/projects/ad-sec-deny-local.png"       "AD Lab Part 5 — Deny logon locally error on server"
mkf "images/projects/ad-sec-pso-admin.png"        "AD Lab Part 5 — Admin PSO in AD Administrative Center"
mkf "images/projects/ad-sec-pso-users.png"        "AD Lab Part 5 — User PSO in AD Administrative Center"

# Active Directory Lab — Part 6 (Service Accounts)
mkf "images/projects/ad-svc-account-aduc.png"  "AD Lab Part 6 — Service account in ADUC"
mkf "images/projects/ad-svc-autologon.png"     "AD Lab Part 6 — Sysinternals Autologon tool"
mkf "images/projects/ad-svc-startup-folder.png" "AD Lab Part 6 — shell:startup folder with Chrome shortcut"
mkf "images/projects/ad-svc-fullscreen.png"    "AD Lab Part 6 — Browser in fullscreen kiosk mode"
mkf "images/projects/ad-svc-gpo-restrict.png"  "AD Lab Part 6 — Restrict logon GPO settings"
mkf "images/projects/ad-svc-deny-test.png"     "AD Lab Part 6 — Standard user denied local logon"

# Active Directory Lab — Part 7 (File Sharing & NTFS Permissions)
mkf "images/projects/ad-fs2-share-perms.png"       "AD Lab Part 7 — Share Permissions dialog (HR activity)"
mkf "images/projects/ad-fs2-ntfs-perms.png"        "AD Lab Part 7 — NTFS Permissions (Vendor write-only)"
mkf "images/projects/ad-fs2-disable-inherit.png"   "AD Lab Part 7 — Disable Inheritance on Licenses subfolder"
mkf "images/projects/ad-fs2-explicit-seniorit.png" "AD Lab Part 7 — Explicit Senior IT permissions on Licenses"

# Active Directory Lab — Part 8 (Advanced NTFS — Inheritance & Effective Permissions)
mkf "images/projects/ad-fs3-common-inherit.png"     "AD Lab Part 8 — Common folder inheritance cascading to subfolders"
mkf "images/projects/ad-fs3-disable-convert.png"    "AD Lab Part 8 — Disable Inheritance / Convert dialog"
mkf "images/projects/ad-fs3-project-group.png"      "AD Lab Part 8 — Project group with Full Control on subfolder"
mkf "images/projects/ad-fs3-explicit-deny-john.png" "AD Lab Part 8 — Explicit Deny Read for John Doe"
mkf "images/projects/ad-fs3-deny-warning.png"       "AD Lab Part 8 — Deny precedence warning dialog"

# Active Directory Lab — Part 9 (Access-Based Enumeration)
mkf "images/projects/ad-abe-groups-users.png"   "AD Lab Part 9 — HR and IT groups with test users in ADUC"
mkf "images/projects/ad-abe-ntfs-hr.png"        "AD Lab Part 9 — HR folder NTFS permissions (HR Department only)"
mkf "images/projects/ad-abe-share-perms.png"    "AD Lab Part 9 — Department Shares share permissions"
mkf "images/projects/ad-abe-enable-setting.png" "AD Lab Part 9 — Enabling ABE in Server Manager"
mkf "images/projects/ad-abe-hr-view.png"        "AD Lab Part 9 — HR user view (only HR folder visible)"
mkf "images/projects/ad-abe-it-view.png"        "AD Lab Part 9 — IT user view (only IT folder visible)"

# Hytale Dedicated Server project — fallback placeholders.
# (The rename step above should have already filled these in from your
#  Screenshot_*.png files; these only get created if a source was missing.)
mkf "images/projects/hytale-01-boot-auth.png"             "Hytale server boot + OAuth2 device authorization"
mkf "images/projects/hytale-02-auth-success.png"          "OAuth2 authentication successful, encrypted credentials"
mkf "images/projects/hytale-03-files-initial.png"         "Initial Hytale server directory listing"
mkf "images/projects/hytale-04-files-backup.png"          "Server directory with backup folder created"
mkf "images/projects/hytale-05-startbat.png"              "Start.bat launch script (AOT cache + backups)"
mkf "images/projects/hytale-06-config-json.png"           "config.json server configuration"
mkf "images/projects/hytale-07-hostname.png"              "hostname command output"
mkf "images/projects/hytale-08-firewall-rule.png"         "PowerShell New-NetFirewallRule for Hytale UDP 5520"
mkf "images/projects/hytale-09-ipconfig.png"              "ipconfig showing local IP address"
mkf "images/projects/hytale-10-launcher-private.png"      "Hytale launcher — Private Servers list"
mkf "images/projects/hytale-11-edit-server.png"           "Edit Server dialog with local IP connection address"
mkf "images/projects/hytale-12-ingame-dungeon.png"        "In-game view of the Hytale world"
mkf "images/projects/hytale-13-ingame-chat.png"           "In-game chat message sent to the server"
mkf "images/projects/hytale-14-server-log-chat.png"       "Server console log showing chat message received"
mkf "images/projects/hytale-15-server-log-op.png"         "Server console log showing op add command"
mkf "images/projects/hytale-16-ingame-operator.png"       "In-game notification confirming operator status"
mkf "images/projects/hytale-17-router-portforward.png"    "AT&T router NAT/Gaming port forwarding (Hytale + Jellyfin/Emby/Sunshine)"
mkf "images/projects/hytale-18-launcher-both-servers.png" "Hytale launcher showing public and private server entries"
mkf "images/projects/hytale-19-connecting.png"            "Connecting to the Hytale server screen"

# Self-Hosted Services
mkf "images/homelab/jellyfin-ui.png"  "Jellyfin media server interface — name this file exactly"
# Note: images/pihole-dashboard.png already present

# AI Inference Stack
mkf "images/projects/ai-stack-1.png"     "AI Stack — Open WebUI interface"
mkf "images/projects/ai-stack-2.png"     "AI Stack — Ollama / ROCm GPU output"

echo ""

# ════════════════════════════════════════════════════
# 4.  CERT ASSETS  (skip if already present)
# ════════════════════════════════════════════════════
echo -e "${BOLD}[ Certification Assets ]${RST}"
echo -e "${DIM}  images/ — badge PNGs + PDFs (existing files preserved)${RST}"

# Badge PNGs — only create placeholders if the real ones are missing
mkf "images/A+-png.png"         "CompTIA A+ badge PNG — replace with real badge"
mkf "images/Network+-png.png"   "CompTIA Network+ badge PNG — replace with real badge"
mkf "images/Security+-png.png"  "CompTIA Security+ badge PNG — replace with real badge"

# CIOS / CSIS — displayed as embedded PDFs in the site
mkf "images/CIOS_Certified.pdf"  "CIOS cert PDF — used as inline preview in cert card"
mkf "images/CSIS_Certified.pdf"  "CSIS cert PDF — used as inline preview in cert card"

# Full certificate PDFs (long filenames matching index.html links)
mkf "images/CompTIA A+ ce certificate.pdf"                                 "Full A+ certificate"
mkf "images/CompTIA Network+ ce certificate.pdf"                           "Full Network+ certificate"
mkf "images/CompTIA Security+ ce certificate.pdf"                          "Full Security+ certificate"
mkf "images/CompTIA IT Operations Specialist – CIOS certificate.pdf"       "Full CIOS certificate"
mkf "images/CompTIA Secure Infrastructure Specialist – CSIS certificate.pdf" "Full CSIS certificate"

# Portrait
mkf "images/Picture of me.jpg"  "Portrait photo used on About Me page"

# Downloadable resume
mkf "resume/Tyrek_Brunson_Resume.docx"  "Full resume — linked from About Me page"

# Education certificate images
mkf "images/associate-degree-certificate.jpg"  "Associate in Science certificate — Midlands Technical College"
mkf "images/usc-comptia-certificate.jpg"        "USC CompTIA Certification Program — Certificate of Completion"

echo ""

# ════════════════════════════════════════════════════
# 5.  OPTIONAL FUTURE PAGES (stub HTML files)
# ════════════════════════════════════════════════════
echo -e "${BOLD}[ Future Page Stubs ]${RST}"
echo -e "${DIM}  Stub files for expanding the site later${RST}"

mkf "ad-lab.html"       "Standalone Active Directory lab deep-dive page"
mkf "proxmox.html"      "Standalone Proxmox VE setup page"
mkf "ai-stack.html"     "Standalone AI stack documentation page"
mkf "network.html"      "Standalone network topology page"

echo ""

# ════════════════════════════════════════════════════
# 6.  SUMMARY
# ════════════════════════════════════════════════════
echo -e "${BOLD}${GRN}╔══════════════════════════════════════════════════════╗${RST}"
echo -e "${BOLD}${GRN}║  Setup complete!                                     ║${RST}"
echo -e "${BOLD}${GRN}╚══════════════════════════════════════════════════════╝${RST}"
echo ""
echo -e "  ${GRN}+${RST} Directories created : ${BOLD}${made_dirs}${RST}"
echo -e "  ${YLW}+${RST} Placeholder files   : ${BOLD}${made_files}${RST}"
echo -e "  ${DIM}·${RST} Already existed      : ${BOLD}${skipped}${RST}  ${DIM}(untouched)${RST}"
echo ""
echo -e "${BOLD}Next steps:${RST}"
echo -e "  1. Replace placeholder files with your real photos / screenshots."
echo -e "  2. Open ${BOLD}index.html${RST} in a browser to preview the site."
echo -e "  3. Search ${BOLD}\"HOW TO UPDATE\"${RST} in index.html to find every editable section."
echo ""
echo -e "${DIM}File layout:${RST}"
echo -e "  ${BLU}Home Lab/${RST}"
echo -e "  ├── index.html"
echo -e "  ├── setup.sh            ${DIM}← this script${RST}"
echo -e "  ├── images/"
echo -e "  │   ├── homelab/        ${DIM}← hardware & lab photos${RST}"
echo -e "  │   ├── projects/       ${DIM}← project screenshots${RST}"
echo -e "  │   ├── A+-png.png      ${DIM}← cert badge PNGs${RST}"
echo -e "  │   ├── *.pdf           ${DIM}← cert PDFs (CIOS, CSIS, full certs)${RST}"
echo -e "  │   └── Picture of me.jpg"
echo -e "  ├── ad-lab.html         ${DIM}← future pages${RST}"
echo -e "  ├── proxmox.html"
echo -e "  ├── ai-stack.html"
echo -e "  └── network.html"
echo ""
