# 1. Start from the official lightweight Bun image
FROM oven/bun:1.1-slim

# 2. Install Git and CA certificates to prevent network handshaking errors
RUN apt-get update && apt-get install -y \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 3. Set the working directory inside the container
WORKDIR /app

# 4. Clone the repository directly into the container
RUN git clone https://github.com/UseInterstellar/Interstellar-Astro.git .

# 5. HARDENED INSTALLATION LAYER
# Configures network timeout allowances, clears potential lock cache, and installs
RUN bun config set network-timeout 300000 && \
    bun install --backend=copyfile --no-save || bun install

# 6. Build the Astro production assets
RUN bun run build

# 7. Expose port 8080 for web traffic
EXPOSE 8080

# 8. Define the environment variable for Koyeb's router
ENV PORT=8080

# 9. Start the proxy server backend
CMD ["bun", "start"]
