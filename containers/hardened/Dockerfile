FROM alpine:3.21

# Node.js + minimal tools
RUN apk add --no-cache \
    bash \
    coreutils \
    procps \
    curl \
    strace \
    util-linux \
    git \
    nodejs \
    npm

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Non-root user
RUN adduser -D -u 1000 -s /bin/bash prisoner
USER prisoner
WORKDIR /home/prisoner

# Claude config directory
RUN mkdir -p /home/prisoner/.claude

CMD ["sleep", "infinity"]
