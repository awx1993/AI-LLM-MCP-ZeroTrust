docker run \
  --security-opt=no-new-privileges \
  --security-opt=apparmor:ai-profile \
  --security-opt=seccomp=./ai-seccomp.json \
  --cap-drop=ALL \
  --cap-add=NET_RAW,NET_ADMIN? No — drop all, add none. \
  --read-only \
  --tmpfs /tmp:noexec,nosuid,size=64M \
  --network=none \   # or user-defined bridge with egress deny
  --mount type=bind,src=/data/readonly-corp-docs,dst=/docs,ro \
  aiai:latest