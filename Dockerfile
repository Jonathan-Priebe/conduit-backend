# Python Image for Project
FROM python:3.5-slim

# Set Workdirectory
WORKDIR /app

# Copie Project files
COPY . /app

# Install dependencies
RUN python -m pip install --no-cache-dir -r requirements.txt

# Make entrypoint.sh executable
RUN chmod +x /app/entrypoint.sh

# Expose Port
EXPOSE 3000

# Run Backend-Server
ENTRYPOINT ["/bin/sh", "-c", "/app/entrypoint.sh"]