#! /bin/bash

# --------------------------------------------------------------------------------------------
# This script is run after the container is started and the workspace is mounted.
# It is used to perform any final setup steps that need to be done after the container is started.
# --------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------
# Configure local cache proxies if the server at 192.168.13.3 is reachable.
# All checks are best-effort; script continues normally if the server is unreachable.
# --------------------------------------------------------------------------------------------
CACHE_HOST=192.168.13.3

# npm registry (Verdaccio on :4873) — always reset to default first, then override if available
npm config set registry https://registry.npmjs.org/
if nc -z -w2 $CACHE_HOST 4873 2>/dev/null; then
  npm config set registry http://$CACHE_HOST:4873/
  echo "npm registry set to local cache ($CACHE_HOST:4873)"
fi

# Squid proxy (:3128) — set http_proxy/https_proxy for curl, cargo, bundle, etc.
if nc -z -w2 $CACHE_HOST 3128 2>/dev/null; then
  export http_proxy=http://$CACHE_HOST:3128
  export https_proxy=http://$CACHE_HOST:3128
  export no_proxy=localhost,127.0.0.1,ps.localhost
  echo "Squid proxy set ($CACHE_HOST:3128)"
fi

# --------------------------------------------------------------------------------------------
# This is intended to install npm packages in the post create command of the devcontainer.json file.
# Which means they are installed as the vscode user and can be upgraded.
# --------------------------------------------------------------------------------------------

# Install Playwright 1.52.0 (matching playwright-ruby-client version)
# Skip if browsers are already cached (this script runs on every container start)
# Use Akamai CDN directly — the primary Azure CDN returns 400 errors on ARM64 Linux
#
# We install browser dependencies manually because Playwright's --with-deps flag
# may not recognise Debian Trixie package names. The packages below are the Trixie
# equivalents of the libraries Chromium needs.
if ! ls -d /home/vscode/.cache/ms-playwright/chromium-* >/dev/null 2>&1; then
  # Install Playwright browser dependencies with correct Debian Trixie package names
  sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    fonts-unifont \
    fonts-liberation \
    libasound2t64 \
    libatk-bridge2.0-0t64 \
    libatk1.0-0t64 \
    libatspi2.0-0t64 \
    libcairo2 \
    libcups2t64 \
    libdbus-1-3 \
    libdrm2 \
    libegl1 \
    libenchant-2-2 \
    libevent-2.1-7t64 \
    libfontconfig1 \
    libfreetype6 \
    libgbm1 \
    libgdk-pixbuf-2.0-0 \
    libglib2.0-0t64 \
    libgl1 \
    libgtk-3-0t64 \
    libharfbuzz0b \
    libicu76 \
    libjpeg62-turbo \
    liblcms2-2 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpng16-16t64 \
    libvpx9 \
    libwebp7 \
    libwebpdemux2 \
    libwoff1 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    libxt6t64 \
    xvfb \
  && sudo rm -rf /var/lib/apt/lists/*

  PLAYWRIGHT_DOWNLOAD_HOST=https://playwright-akamai.azureedge.net \
    npm install -g playwright@1.52.0 && \
    PLAYWRIGHT_DOWNLOAD_HOST=https://playwright-akamai.azureedge.net \
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=1 \
    npx playwright@1.52.0 install chromium
else
  echo "Playwright browsers already installed, skipping download."
fi

if ! command -v claude >/dev/null 2>&1; then
  curl -fsSL --retry 3 --retry-delay 5 https://claude.ai/install.sh | bash \
    || echo "WARNING: claude.ai install failed (possibly 429). Continuing." >&2
fi


# --------------------------------------------------------------------------------------------
# Credentials need to be writable as they are in a volume
# --------------------------------------------------------------------------------------------
sudo chown -R vscode:vscode /home/vscode/.config/gh /home/vscode/.claude
