ALLOWED_BINS = {"/usr/bin/jq", "/usr/bin/grep", "/usr/bin/cat"}
ALLOWED_READ_PATHS = re.compile(r"^/data/corp_docs/|^/tmp/allowlisted/")
DENY_NETWORKS = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16", "169.254.169.254"]

def enforce_action(cmd, args, env):
    if cmd not in ALLOWED_BINS:
        raise PermissionError(f"Binary {cmd} not allowed")
    if "--exec" in args or "eval" in args:
        raise PermissionError("Dynamic execution blocked")
    # Network: only allow public API endpoints (allowlist)
    if "curl" in cmd:
        url = extract_url(args)
        if any(url.startswith(ip) for ip in DENY_NETWORKS):
            raise PermissionError("Internal network blocked")
    return subprocess.run([cmd] + args, env=env, timeout=5)