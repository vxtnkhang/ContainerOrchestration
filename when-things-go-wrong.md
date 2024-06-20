## Static Pod: coredns (kube-system)

Issue: 

- `coredns` pod from `kube-system` namespace can not start
- `longhorn` pods failure: host not found in upstream "longhorn-backend"

Cause: Some Linux distribution uses a local DNS resolver by default

Workaround: 

    # kubectl edit cm coredns -n kube-system
    ...
        forward . 1.1.1.1
    ...