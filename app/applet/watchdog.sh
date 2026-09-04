#!/bin/bash

# Watchdog Script untuk 9Router & Cloudflared Tunnel

while true; do
    # 1. Cek 9Router
    if ! pgrep -f "9router" > /dev/null; then
        echo "[$(date)] 9Router mati/tidak terdeteksi. Memulai ulang..."
        export INITIAL_PASSWORD="admin123"
        nohup 9router --tray > /tmp/9router.log 2>&1 &
    fi

    # 2. Cek Cloudflared Tunnel untuk port 20128
    if ! pgrep -f "cloudflared.*20128" > /dev/null; then
        echo "[$(date)] Cloudflared Tunnel mati/tidak terdeteksi. Memulai ulang..."
        rm -f /tmp/cloudflared.log
        nohup ./cloudflared tunnel --protocol http2 --url http://localhost:20128 > /tmp/cloudflared.log 2>&1 &
    fi

    sleep 10
done
