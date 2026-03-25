# Prerequisites Installation Guide

## Table of Contents

- [Overview](#overview)
- [Node.js 18+ Installation](#nodejs-18-installation)
  - [Windows](#nodejs-windows)
  - [macOS](#nodejs-macos)
  - [Linux](#nodejs-linux)
  - [Verification](#nodejs-verification)
- [Java 17+ Installation](#java-17-installation)
  - [Windows](#java-windows)
  - [macOS](#java-macos)
  - [Linux](#java-linux)
  - [Verification](#java-verification)
- [Python 3.10+ Installation](#python-310-installation)
  - [Windows](#python-windows)
  - [macOS](#python-macos)
  - [Linux](#python-linux)
  - [Verification](#python-verification)
- [Docker and Docker Compose Installation](#docker-and-docker-compose-installation)
  - [Windows](#docker-windows)
  - [macOS](#docker-macos)
  - [Linux](#docker-linux)
  - [Verification](#docker-verification)
- [Git Installation](#git-installation)
  - [Windows](#git-windows)
  - [macOS](#git-macos)
  - [Linux](#git-linux)
  - [Verification](#git-verification)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)

## Overview

This guide will help you install all the tools needed to develop and run the Enterprise Insight RAG v1.0 application. You don't need any prior experience - just follow the steps for your operating system.

The tools you'll install are:

- **Node.js 18+**: For running the mobile app development environment
- **Java 17+**: For running the authentication service
- **Python 3.10+**: For running the AI service
- **Docker and Docker Compose**: For running databases locally
- **Git**: For version control and code management

## Node.js 18+ Installation

Node.js is a JavaScript runtime that lets you run JavaScript code outside of a web browser. We use it to build and run the mobile application.

### <a name="nodejs-windows"></a>Windows

1. Visit the official Node.js website: [https://nodejs.org/](https://nodejs.org/)
2. Click the "LTS" (Long Term Support) button to download the installer
3. Run the downloaded `.msi` file
4. Follow the installation wizard:
   - Accept the license agreement
   - Keep the default installation location
   - Make sure "Add to PATH" is checked
   - Click "Install"
5. Restart your computer to ensure PATH changes take effect

### <a name="nodejs-macos"></a>macOS

**Option 1: Using the Official Installer**

1. Visit the official Node.js website: [https://nodejs.org/](https://nodejs.org/)
2. Click the "LTS" button to download the `.pkg` installer
3. Run the downloaded file and follow the installation wizard
4. Enter your password when prompted

**Option 2: Using Homebrew (Recommended)**

If you have Homebrew installed:

```bash
brew install node@18
```

### <a name="nodejs-linux"></a>Linux

**Ubuntu/Debian:**

```bash
# Update package list
sudo apt update

# Install Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Verify npm is installed
npm --version
```

**Fedora/RHEL/CentOS:**

```bash
# Install Node.js 18.x
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo dnf install -y nodejs

# Verify npm is installed
npm --version
```

### <a name="nodejs-verification"></a>Verification

Open a new terminal or command prompt and run:

```bash
node --version
```

You should see output like `v18.x.x` or higher.

Also verify npm (Node Package Manager) is installed:

```bash
npm --version
```

You should see output like `9.x.x` or higher.

## Java 17+ Installation

Java is a programming language and runtime environment. We use it to run the authentication service built with Spring Boot.

### <a name="java-windows"></a>Windows

**Using Eclipse Temurin (Recommended - Free and Open Source)**

1. Visit [https://adoptium.net/](https://adoptium.net/)
2. Select:
   - Version: 17 (LTS)
   - Operating System: Windows
   - Architecture: x64
3. Click "Download"
4. Run the downloaded `.msi` installer
5. Follow the installation wizard:
   - Accept the license
   - Check "Set JAVA_HOME variable"
   - Check "Add to PATH"
   - Click "Install"
6. Restart your computer

### <a name="java-macos"></a>macOS

**Option 1: Using Homebrew (Recommended)**

```bash
brew install openjdk@17
```

After installation, add Java to your PATH:

```bash
echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Option 2: Using Eclipse Temurin**

1. Visit [https://adoptium.net/](https://adoptium.net/)
2. Select macOS and download the `.pkg` installer
3. Run the installer and follow the wizard

### <a name="java-linux"></a>Linux

**Ubuntu/Debian:**

```bash
# Update package list
sudo apt update

# Install OpenJDK 17
sudo apt install -y openjdk-17-jdk

# Set JAVA_HOME
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
source ~/.bashrc
```

**Fedora/RHEL/CentOS:**

```bash
# Install OpenJDK 17
sudo dnf install -y java-17-openjdk-devel

# Set JAVA_HOME
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk' >> ~/.bashrc
source ~/.bashrc
```

### <a name="java-verification"></a>Verification

Open a new terminal or command prompt and run:

```bash
java --version
```

You should see output like `openjdk 17.x.x` or higher.

Also verify the Java compiler:

```bash
javac --version
```

You should see output like `javac 17.x.x` or higher.

## Python 3.10+ Installation

Python is a programming language widely used for AI and machine learning. We use it to run the AI service with FastAPI.

### <a name="python-windows"></a>Windows

1. Visit the official Python website: [https://www.python.org/downloads/](https://www.python.org/downloads/)
2. Click "Download Python 3.10.x" or higher
3. Run the downloaded `.exe` installer
4. **IMPORTANT**: Check "Add Python to PATH" at the bottom of the installer
5. Click "Install Now"
6. Wait for installation to complete
7. Restart your computer

### <a name="python-macos"></a>macOS

**Option 1: Using Homebrew (Recommended)**

```bash
brew install python@3.10
```

**Option 2: Using the Official Installer**

1. Visit [https://www.python.org/downloads/](https://www.python.org/downloads/)
2. Download the macOS installer for Python 3.10 or higher
3. Run the downloaded `.pkg` file
4. Follow the installation wizard

### <a name="python-linux"></a>Linux

**Ubuntu/Debian:**

```bash
# Update package list
sudo apt update

# Install Python 3.10
sudo apt install -y python3.10 python3.10-venv python3-pip

# Set Python 3.10 as default (optional)
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
```

**Fedora/RHEL/CentOS:**

```bash
# Install Python 3.10
sudo dnf install -y python3.10 python3-pip

# Create symlink if needed
sudo ln -s /usr/bin/python3.10 /usr/bin/python3
```

### <a name="python-verification"></a>Verification

Open a new terminal or command prompt and run:

```bash
python3 --version
```

Or on Windows:

```bash
python --version
```

You should see output like `Python 3.10.x` or higher.

Also verify pip (Python Package Installer):

```bash
pip3 --version
```

Or on Windows:

```bash
pip --version
```

You should see output like `pip 22.x.x` or higher.

## Docker and Docker Compose Installation

Docker lets you run applications in isolated containers. We use it to run PostgreSQL, Neo4j, and Redis databases locally without installing them directly on your computer.

### <a name="docker-windows"></a>Windows

**Requirements:**
- Windows 10 64-bit: Pro, Enterprise, or Education (Build 19041 or higher)
- OR Windows 11 64-bit

**Steps:**

1. Visit [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
2. Click "Download for Windows"
3. Run the downloaded `Docker Desktop Installer.exe`
4. Follow the installation wizard:
   - Accept the license
   - Use WSL 2 instead of Hyper-V (recommended)
   - Click "Install"
5. Restart your computer when prompted
6. Launch Docker Desktop from the Start menu
7. Wait for Docker to start (you'll see a green icon in the system tray)

**Note:** Docker Desktop includes Docker Compose automatically.

### <a name="docker-macos"></a>macOS

**Requirements:**
- macOS 11 or newer

**Steps:**

1. Visit [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
2. Click "Download for Mac"
3. Choose the correct version:
   - **Apple Silicon (M1/M2/M3)**: Download "Mac with Apple chip"
   - **Intel**: Download "Mac with Intel chip"
4. Open the downloaded `.dmg` file
5. Drag Docker to your Applications folder
6. Launch Docker from Applications
7. Grant permissions when prompted
8. Wait for Docker to start (you'll see a whale icon in the menu bar)

**Note:** Docker Desktop includes Docker Compose automatically.

### <a name="docker-linux"></a>Linux

**Ubuntu/Debian:**

```bash
# Remove old versions
sudo apt remove docker docker-engine docker.io containerd runc

# Update package list
sudo apt update

# Install dependencies
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to docker group (to run without sudo)
sudo usermod -aG docker $USER

# Log out and log back in for group changes to take effect
```

**Fedora:**

```bash
# Remove old versions
sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest

# Install dependencies
sudo dnf install -y dnf-plugins-core

# Add Docker repository
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Install Docker Engine
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to docker group
sudo usermod -aG docker $USER

# Log out and log back in for group changes to take effect
```

### <a name="docker-verification"></a>Verification

Open a new terminal or command prompt and run:

```bash
docker --version
```

You should see output like `Docker version 24.x.x` or higher.

Verify Docker Compose:

```bash
docker compose version
```

You should see output like `Docker Compose version v2.x.x` or higher.

Test Docker is working:

```bash
docker run hello-world
```

You should see a message saying "Hello from Docker!" confirming Docker is installed correctly.

## Git Installation

Git is a version control system that tracks changes to your code. We use it to manage the project repository and collaborate with other developers.

### <a name="git-windows"></a>Windows

1. Visit [https://git-scm.com/download/win](https://git-scm.com/download/win)
2. Download the installer (64-bit recommended)
3. Run the downloaded `.exe` file
4. Follow the installation wizard:
   - Accept the license
   - Keep default installation location
   - Select components: keep defaults
   - Choose default editor (VS Code recommended if installed)
   - Choose "Git from the command line and also from 3rd-party software"
   - Use bundled OpenSSH
   - Use OpenSSL library
   - Checkout Windows-style, commit Unix-style line endings
   - Use MinTTY terminal
   - Keep other defaults
   - Click "Install"
5. Restart your terminal or command prompt

### <a name="git-macos"></a>macOS

**Option 1: Using Homebrew (Recommended)**

```bash
brew install git
```

**Option 2: Using Xcode Command Line Tools**

```bash
xcode-select --install
```

**Option 3: Using the Official Installer**

1. Visit [https://git-scm.com/download/mac](https://git-scm.com/download/mac)
2. Download the installer
3. Run the downloaded file and follow the wizard

### <a name="git-linux"></a>Linux

**Ubuntu/Debian:**

```bash
sudo apt update
sudo apt install -y git
```

**Fedora/RHEL/CentOS:**

```bash
sudo dnf install -y git
```

### <a name="git-verification"></a>Verification

Open a new terminal or command prompt and run:

```bash
git --version
```

You should see output like `git version 2.x.x` or higher.

Configure Git with your name and email:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

Verify configuration:

```bash
git config --list
```

You should see your name and email in the output.

## Troubleshooting

### Node.js Issues

**Problem:** `node: command not found` or `npm: command not found`

**Solution:**
- Restart your terminal or command prompt
- On Windows, restart your computer
- Verify Node.js is in your PATH: `echo $PATH` (macOS/Linux) or `echo %PATH%` (Windows)
- Reinstall Node.js and ensure "Add to PATH" is checked

### Java Issues

**Problem:** `java: command not found` or `JAVA_HOME not set`

**Solution:**
- Restart your terminal
- Set JAVA_HOME manually:
  - Windows: `setx JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-17.x.x-hotspot"`
  - macOS/Linux: Add to `~/.bashrc` or `~/.zshrc`: `export JAVA_HOME=/path/to/java`
- Verify with: `echo $JAVA_HOME` (macOS/Linux) or `echo %JAVA_HOME%` (Windows)

### Python Issues

**Problem:** `python: command not found` or `pip: command not found`

**Solution:**
- Try `python3` instead of `python`
- Try `pip3` instead of `pip`
- On Windows, reinstall Python and check "Add Python to PATH"
- On macOS/Linux, create an alias: `alias python=python3` in `~/.bashrc` or `~/.zshrc`

### Docker Issues

**Problem:** `docker: command not found` or `Cannot connect to Docker daemon`

**Solution:**
- Ensure Docker Desktop is running (Windows/macOS)
- On Linux, start Docker: `sudo systemctl start docker`
- On Linux, add user to docker group: `sudo usermod -aG docker $USER` then log out and back in
- Restart Docker Desktop (Windows/macOS)

**Problem:** Docker Desktop won't start on Windows

**Solution:**
- Enable WSL 2: Open PowerShell as Administrator and run `wsl --install`
- Enable Virtualization in BIOS (restart computer, enter BIOS, enable VT-x/AMD-V)
- Update Windows to the latest version

### Git Issues

**Problem:** `git: command not found`

**Solution:**
- Restart your terminal
- On Windows, restart your computer
- Verify Git is in your PATH
- Reinstall Git

**Problem:** Git asks for username/password repeatedly

**Solution:**
- Set up credential helper:
  - Windows: `git config --global credential.helper wincred`
  - macOS: `git config --global credential.helper osxkeychain`
  - Linux: `git config --global credential.helper store`

### General Issues

**Problem:** Command not found after installation

**Solution:**
- Close and reopen your terminal
- On Windows, restart your computer
- Check if the tool is in your PATH environment variable

**Problem:** Permission denied errors on macOS/Linux

**Solution:**
- Use `sudo` before the command (e.g., `sudo apt install ...`)
- For Docker, add user to docker group: `sudo usermod -aG docker $USER`

## Next Steps

Congratulations! You've installed all the required tools. You're now ready to set up the Enterprise Insight RAG project.

Continue to the [Setup Guide](SETUP_GUIDE.md) to:
- Clone the repository
- Configure environment variables
- Install project dependencies
- Run the application locally

If you encounter any issues not covered in this guide, please:
- Check the official documentation for each tool
- Search for error messages online
- Ask for help from the development team
- Open an issue on the project repository

