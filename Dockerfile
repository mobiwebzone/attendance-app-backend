# Assuming your base image is Debian 11 (Bullseye) compatible, e.g.,
# FROM python:3.9-slim-bullseye
# FROM debian:bullseye-slim

# --- START OF THE CORRECTED AND BROKEN-DOWN SECTION ---

# Step 1: Install initial dependencies needed for adding the repo and the ODBC driver
# Added 'lsb-release' which is needed for $(lsb_release -cs)
RUN apt-get update && \
    apt-get install -y \
    curl \
    gnupg \
    unixodbc \
    lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Step 2: Add Microsoft's GPG key and repository using the modern method (replaces apt-key)
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/11/prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/mssql-release.list

# Step 3: Update apt cache again and install the ODBC driver
RUN apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
    rm -rf /var/lib/apt/lists/*

# Step 4: Upgrade pip (optional, but good practice)
RUN pip install --upgrade pip

# --- END OF THE CORRECTED SECTION ---

# ... Your other Dockerfile commands should follow here (e.g., COPY, WORKDIR, EXPOSE, CMD)