#!/bin/bash
# --------------------------------------------------------
# Webcam Setup Script
# Works for: MacBook Air 2013 (FaceTimeHD) + Asus VivoBook (Sonix)
# Author: Maverick Seneris
# --------------------------------------------------------

set -e

echo "⚙️  Installing webcam support..."

# --- Essentials ---
sudo pacman -S --noconfirm base-devel git dkms linux-headers v4l-utils guvcview

# --- Check device ---
if lsusb | grep -q "05ac:8510"; then
  echo "🍏 Detected Apple FaceTimeHD camera"

  # Install DKMS driver + firmware
  yay -S --noconfirm facetimehd-dkms-git facetimehd-firmware

  # Ensure firmware path exists
  sudo mkdir -p /lib/firmware/facetimehd

  # Add safe buffer param
  echo "options facetimehd vb2_alloc=0" | sudo tee /etc/modprobe.d/facetimehd.conf

  # Auto-load at boot
  echo facetimehd | sudo tee /etc/modules-load.d/facetimehd.conf

  echo "✅ FaceTimeHD setup complete. Reboot to activate."

elif lsusb | grep -q "322e:2113"; then
  echo "🟦 Detected Sonix UVC Webcam (VivoBook)"

  # UVC driver is kernel-native
  sudo modprobe uvcvideo

  # Optional tweak for smoother capture
  echo 'options uvcvideo nodrop=1 timeout=5000 quirks=0x80' | sudo tee /etc/modprobe.d/uvcvideo.conf

  # Auto-load at boot
  echo uvcvideo | sudo tee /etc/modules-load.d/uvcvideo.conf

  echo "✅ Sonix UVC webcam ready to use."

else
  echo "⚠️  No known webcam detected. Please connect or check lsusb output."
fi

echo "Done."
