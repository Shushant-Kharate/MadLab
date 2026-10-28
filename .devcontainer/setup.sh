#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
if [ ! -d /opt/flutter ]; then
  sudo git clone --depth 1 --branch 3.47.6 https://github.com/flutter/flutter.git /opt/flutter
  sudo chown -R "$(id -u):$(id -g)" /opt/flutter
fi
export PATH="/opt/flutter/bin:$PATH"
printf '\nexport PATH="/opt/flutter/bin:$PATH"\n' >> "$HOME/.bashrc"
flutter config --enable-web
flutter precache --web
flutter --version
