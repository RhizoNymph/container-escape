FROM node:22-alpine

# Minimal tools + enough to run Claude Code
RUN apk add --no-cache \
    bash \
    coreutils \
    procps \
    curl \
    strace \
    util-linux \
    git

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Non-root user
RUN adduser -D -s /bin/bash prisoner
USER prisoner
WORKDIR /home/prisoner

# Claude config directory
RUN mkdir -p /home/prisoner/.claude

ENTRYPOINT []
CMD ["sleep", "infinity"]
