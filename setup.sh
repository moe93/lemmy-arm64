# noninteractive is just there so I don't get bugged with useless popups. this script does not actually work non interactively.

DEBIAN_FRONTEND=noninteractive apt update;
DEBIAN_FRONTEND=noninteractive apt upgrade -y;

DEBIAN_FRONTEND=noninteractive apt install ca-certificates curl gnupg git;
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg;
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null;
DEBIAN_FRONTEND=noninteractive apt update;
DEBIAN_FRONTEND=noninteractive apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin;

# Remove built-in rust installation and re-install using rustup
DEBIAN_FRONTEND=noninteractive apt remove -y cargo;
DEBIAN_FRONTEND=noninteractive apt autoremove -y;
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh;

# --------------------------------------
# NEED TO RESTART SHELL HERE
# MOVE BOTTOM PORTION TO A DIFFERENT SCRIPT
# OR FIGURE OUT A WAY TO RESTART SHELL WITHOUT INTERRUPTING
# THE SCRIPT'S EXECUTION.
# --------------------------------------

# Install the x86_64 Linux target
# (or whatever architecture we are building this on)
rustup target add x86_64-unknown-linux-musl

# Make scripts executable
chmod +x amd64.sh;
chmod +x build.sh;
chmod +x build_ui.sh;

# Final
docker login -u modeh93; # should prompt for password.
sudo ./amd64.sh
