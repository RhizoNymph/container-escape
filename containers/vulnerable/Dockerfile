FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# System tools for exploration
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    ca-certificates \
    iproute2 \
    mount \
    fdisk \
    util-linux \
    procps \
    kmod \
    python3 \
    strace \
    netcat-openbsd \
    coreutils \
    git \
    && rm -rf /var/lib/apt/lists/*

# Node.js (for Claude Code)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Non-root user with passwordless sudo (Claude Code refuses --dangerously-skip-permissions as root)
RUN apt-get update && apt-get install -y --no-install-recommends sudo \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -s /bin/bash researcher \
    && echo "researcher ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/researcher

USER researcher
WORKDIR /home/researcher
RUN mkdir -p /home/researcher/.claude

CMD ["sleep", "infinity"]
