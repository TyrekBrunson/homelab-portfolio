# Images Folder Guide

## Folder Structure

images/
├── certs/       ← CompTIA badge PNGs (drag from Credly)
├── homelab/     ← Lab/desk photos, network diagrams
└── projects/    ← Screenshots of your project UIs

## How to add images

### Cert badges
1. Go to credly.com → your badge → Share → Download PNG
2. Drop it here: images/certs/comptia-securityplus.png
3. In index.html search for "cert-badge-placeholder" for that cert
4. Replace the <div class="cert-badge-placeholder">...</div>
   with: <img src="images/certs/comptia-securityplus.png" alt="Security+">

### Lab photos
1. Drop photos into images/homelab/
2. In index.html find the matching img-placeholder div
3. Replace: <div class="img-placeholder">...</div>
   with: <img src="images/homelab/yourphoto.jpg" alt="Description">

### Network diagram
- Save as: images/homelab/network-diagram.png
- Find "Add: images/homelab/network-diagram.png" in index.html and replace

### Project screenshots
- Save to: images/projects/
- Find the project card and replace img-placeholder-sm divs with <img> tags
