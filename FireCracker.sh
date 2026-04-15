sudo jailer --id ai-session \
  --exec-file /usr/bin/firecracker \
  --uid 10001 --gid 10001 \
  --netns /var/run/netns/ainet \
  -- --config-file /etc/fc/ai-vm-config.json