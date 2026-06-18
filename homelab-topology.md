# Homelab Network Topology

Mermaid diagram — paste into any Mermaid-compatible renderer (GitHub markdown, Obsidian, mermaid.live, etc).

```mermaid
graph TD
    INTERNET((Internet)) -->|Fiber| GW

    GW["**AT&T BGW320-505**<br/>ONT + Router<br/>192.168.1.254"]

    GW -->|Ethernet| TV["Google TV Streamer"]
    GW -->|Ethernet| AP1["**Deco M5 #1**<br/>TP-Link AC1300 Mesh<br/>(wired uplink)"]
    GW -->|Ethernet| SW1["**TL-SG105 #1**<br/>5-port Gigabit Switch"]

    AP1 -.->|Wireless backhaul| AP2["Deco M5 #2"]
    AP1 -.->|Wireless backhaul| AP3["Deco M5 #3"]

    SW1 -->|Ethernet| PC["**CachyOS Main PC**<br/>Ryzen 7 9800X3D / RX 9070 XT<br/>Ollama+ROCm, Open WebUI,<br/>SearXNG, Sunshine"]
    SW1 -->|Ethernet| LT["**HP 15-dw3xxx**<br/>Omarchy 3.8.2 (Hyprland)<br/>work / homelab laptop"]
    SW1 -->|Ethernet| SD["Steam Deck Dock"]
    SW1 -->|Ethernet, long run| SW2["**TL-SG105 #2**<br/>5-port Gigabit Switch"]

    SW2 -->|Ethernet| WIN["**HP ZBook 17 G2**<br/>Windows 11 Pro · 24GB RAM<br/>Jellyfin, Emby, Syncthing,<br/>storage hub, Palworld server"]
    SW2 -->|Ethernet| PVE["**Proxmox Host**<br/>AD lab, Hytale server,<br/>Kali Linux, future projects"]

    classDef gateway fill:#1a2e1a,stroke:#3fb950,color:#c9d1d9,stroke-width:2px
    classDef switch fill:#0d1b2e,stroke:#58a6ff,color:#c9d1d9,stroke-width:2px
    classDef ap fill:#2e2410,stroke:#d29922,color:#c9d1d9,stroke-width:2px
    classDef host fill:#161b22,stroke:#6e7681,color:#c9d1d9,stroke-width:1px
    classDef hypervisor fill:#241a2e,stroke:#a78bfa,color:#c9d1d9,stroke-width:2px

    class GW gateway
    class SW1,SW2 switch
    class AP1,AP2,AP3 ap
    class PC,LT,SD,TV,WIN host
    class PVE hypervisor
```

## Device reference

| Device | Role | Connects to | Notes |
|---|---|---|---|
| AT&T BGW320-505 | ONT + Router | WAN / Internet | 192.168.1.254, root of network |
| Google TV Streamer | Media client | BGW320 (wired) | |
| Deco M5 #1 | Access point (mesh root) | BGW320 (wired) | Wired uplink, extends mesh wirelessly |
| Deco M5 #2 | Access point | Deco M5 #1 (wireless) | Mesh backhaul |
| Deco M5 #3 | Access point | Deco M5 #1 (wireless) | Mesh backhaul |
| TL-SG105 #1 | Unmanaged switch | BGW320 (wired) | 5-port gigabit |
| CachyOS Main PC | Workstation | TL-SG105 #1 | Ryzen 7 9800X3D, RX 9070 XT — Ollama/ROCm, Open WebUI, SearXNG, Sunshine |
| HP 15-dw3xxx | Laptop | TL-SG105 #1 | Omarchy 3.8.2, Hyprland — work + homelab projects |
| Steam Deck Dock | Handheld dock | TL-SG105 #1 | |
| TL-SG105 #2 | Unmanaged switch | TL-SG105 #1 (long run) | 5-port gigabit, homelab core segment |
| HP ZBook 17 G2 | Media/storage server | TL-SG105 #2 | Windows 11 Pro — Jellyfin, Emby, Syncthing, central storage, Palworld server |
| Proxmox Host | Hypervisor | TL-SG105 #2 | AD lab, Hytale server, Kali Linux, future projects |

## Notes
- Wired links are solid lines; the Deco mesh wireless backhaul is dashed.
- Switch 2 is reached via a long Ethernet run from Switch 1 — consider this if you ever want to relocate gear or troubleshoot link drops on that run.
- The CachyOS PC now also runs Sunshine for game streaming, in addition to its self-hosted AI stack.
