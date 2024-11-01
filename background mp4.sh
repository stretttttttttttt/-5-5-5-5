#!/bin/bash

# Masukkan link video yang ingin digunakan sebagai background
VIDEO_URL="https://files.catbox.moe/7lux14.mp4"
BASE_HTML="/var/www/pterodactyl/resources/views/layouts/base.blade.php"
CSS_FILE="/var/www/pterodactyl/public/themes/pterodactyl/css/app.css"

# Tambahkan elemen video di HTML
sudo sed -i '/<body>/a <video autoplay muted loop id="background-video"><source src="'"$VIDEO_URL"'" type="video/mp4">Your browser does not support the video tag.</video>' "$BASE_HTML"

# Tambahkan CSS untuk video background
sudo tee -a "$CSS_FILE" > /dev/null <<EOT
#background-video {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    z-index: -1;
}
EOT

echo "Background video berhasil diterapkan. Silakan refresh Pterodactyl Panel."
