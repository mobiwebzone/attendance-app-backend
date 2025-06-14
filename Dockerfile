# Assuming your base image is Debian 11 (Bullseye) compatible
# Example: FROM python:3.9-slim-bullseye or FROM debian:bullseye-slim

# Step 1: Install initial dependencies needed for adding the repo and the ODBC driver
RUN apt-get update && \
    apt-get install -y \
    curl \
    gnupg \
    unixodbc \
    lsb-release && \ # lsb-release is needed for $(lsb_release -cs) command
    rm -rf /var/lib/apt/lists/*

# Step 2: Add Microsoft's GPG key and repository using the modern method
# Create the directory for apt keyrings if it doesn't exist
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/11/prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/mssql-release.list

# Step 3: Update apt cache again and install the ODBC driver
RUN apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
    # Clean up apt cache to reduce image size
    rm -rf /var/lib/apt/lists/*

# Step 4: Upgrade pip (good practice, can be in a separate RUN command)
RUN pip install --upgrade pip