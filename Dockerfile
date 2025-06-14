# Start your Dockerfile with a FROM instruction.
# Choose a base image that suits your application (e.g., a Python image on Debian 11 'bullseye').
FROM python:3.9-slim-bullseye # <-- THIS LINE IS ESSENTIAL AND WAS MISSING

# --- START OF THE CORRECTED AND BROKEN-DOWN SECTION (from our previous discussion) ---

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

# --- YOUR OTHER DOCKERFILE COMMANDS SHOULD FOLLOW HERE ---
# These are essential for setting up your application's environment:

# Set the working directory inside the container
WORKDIR /app

# Copy your requirements file and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the rest of your application code
COPY . .

# Expose the port your application listens on (e.g., 8000 for web apps)
EXPOSE 8000

# Define the command to run your application when the container starts
# Replace 'gunicorn app:app --bind 0.0.0.0:$PORT' with your actual start command
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:$PORT"]