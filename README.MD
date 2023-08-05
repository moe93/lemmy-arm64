# Lemmy ARM64 Images

[hub.docker.com/r/modeh93/lemmy/tags](https://hub.docker.com/r/modeh93/lemmy/tags)

This is mostly for personal use. You're free to use the created images if you want, but I can't promise timely updates, bug fixes, vulnerability fixes, etc. I'll try to keep this up-to-date for as long as I'm using lemmy.

If lemmy starts releasing official ARM64 images again, you should use those instead.

# Build Time

Duration in seconds for step 6 (build).


**Virtualized ARM Ubuntu 22.04LTS on host MacBook M1 Pro (BuildX)**
- 379s to compile

**ARM64 (native)**
- 451s on Hetzner VPS cax41 (16 Core, 32 GB RAM, Ampere Altra Q80-30)
    - You can pay by the hour, so this only works out to about $0.04 per build.