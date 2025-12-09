# Создаём нормальные имена
sudo tee /etc/systemd/system/btrfs-scrub-root.service > /dev/null <<'EOF'
[Unit]
Description=Monthly Btrfs scrub on /
After=local-fs.target
RequiresMountsFor=/

[Service]
Type=oneshot
ExecStart=/usr/bin/btrfs scrub start -B /
ExecStartPost=/usr/bin/btrfs scrub status /
Nice=19
IOSchedulingClass=idle
EOF

sudo tee /etc/systemd/system/btrfs-scrub-root.timer > /dev/null <<'EOF'
[Timer]
OnCalendar=*-*-01 05:00:00
RandomizedDelaySec=4h
Persistent=true
Unit=btrfs-scrub-root.service
[Install]
WantedBy=timers.target
EOF

# Включаем
sudo systemctl daemon-reload
sudo systemctl enable --now btrfs-scrub-root.timer
