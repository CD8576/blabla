# 1. Use the absolute latest version of Bun to match modern lockfile versions
FROM oven/bun:latest

# 2. Install Git and standard system libraries
RUN apt-get update && apt-get install -y \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 3. Set the working directory
WORKDIR /app

# 4. Clone the repository directly into the container
RUN git clone https://github.com/UseInterstellar/Interstellar-Astro.git .

# 5. FIX THE LOCKFILE ERROR
# We delete any mismatched lockfile (bun.lock, bun.lockb, or pnpm-lock.yaml) 
# and force Bun to create a clean, valid version.
RUN rm -f bun.lockb bun.lock pnpm-lock.yaml package-lock.json && \
    bun config set network-timeout 300000 && \
    bun install --backend=copyfile

# 6. Build the Astro production assets
RUN bun run build

# 7. Expose the port
EXPOSE 8080
ENV PORT=8080

# 8. Start the proxy server
CMD ["bun", "start"]