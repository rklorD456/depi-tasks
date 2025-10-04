# 🧩 Continuous Integration (CI) — Spring Petclinic with Ngrok

This repository uses **GitHub Actions** to automate the build, containerization, and deployment of the **Spring Petclinic** application.  
The workflow runs inside GitHub’s CI environment and exposes the application publicly using **Ngrok**, while sending **Slack notifications** for job status updates.

---

## 📘 Overview

This CI pipeline ensures that every change to the `main` branch is automatically:

1. **Built** with Maven using JDK 21  
2. **Packaged** into a Docker image  
3. **Deployed** locally inside a container  
4. **Exposed** to the internet via an Ngrok tunnel  
5. **Monitored** and reported via Slack notifications  

It’s designed for quick testing, demo sharing, or showcasing your Spring Boot app without deploying it to a traditional hosting service.

---

## 🧠 Workflow Logic

Below is a breakdown of each step executed by the CI pipeline.

### 1. **Trigger Events**

The workflow runs automatically when:

- A commit is pushed to the `main` branch  
- A pull request targets `main`  
- A manual run is triggered using **workflow_dispatch** (with optional input to control how long Ngrok stays alive)

```yaml
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:
    inputs:
      ngrok_duration:
        default: '180'
```

> 🕒 Default Ngrok duration: **180 seconds (3 minutes)**

---

### 2. **Build Phase**

#### 🧾 Checkout Code
The repository’s code is fetched into the GitHub Actions runner.

#### ☕ Set Up JDK 21
Installs and configures **Java 21 (Temurin distribution)** for Maven builds.

#### 📦 Cache Maven Dependencies
Caches the local Maven repository (`~/.m2`) to speed up future builds.

#### 🧰 Build with Maven
Executes:
```bash
mvn clean package -DskipTests
```
This compiles the project and produces a JAR file in the `target/` directory.

---

### 3. **Containerization Phase**

#### 🐋 Build Docker Image
The generated JAR file is copied to `app.jar` and used to build a Docker image:
```bash
docker build -t spring-petclinic .
```

#### ▶️ Run Container
Starts the Spring Petclinic app locally inside Docker, exposing **port 8080**.

The workflow waits briefly for the container to start before proceeding.

---

### 4. **Ngrok Tunnel Setup**

#### 🌐 Install Ngrok
Ngrok and `jq` (a JSON parser) are installed for creating secure tunnels and reading tunnel information.

#### 🚀 Start Tunnel
Ngrok creates a public HTTPS URL that forwards traffic to the local Docker container:
```bash
ngrok http 8080
```

The workflow then retrieves the tunnel’s public URL using:
```bash
curl -s http://127.0.0.1:4040/api/tunnels
```

✅ The app’s public URL is printed in the logs and stored in `$GITHUB_ENV` for later use.

Example output:
```
🔗 App is publicly accessible at: https://abc123.ngrok.io
```

#### ⏳ Keep Tunnel Alive
Ngrok remains active for the specified duration (default: 180 seconds) so you can test or preview the app.

---

### 5. **Notifications**

#### 💬 Slack Integration
At the end of the workflow (regardless of success or failure), a message is sent to a Slack channel via webhook.

Example messages:
- ✅ **Success:** `CI - Spring Petclinic with Ngrok succeeded on branch main!`
- ❌ **Failure:** `CI - Spring Petclinic with Ngrok failed on branch main!`

---

### 6. **Failure Handling**

If the job fails, the workflow automatically prints the **Docker container logs** to help with debugging.

---

## 🔐 Required Secrets

| Secret Name | Description |
|--------------|-------------|
| `NGROK_AUTHTOKEN` | Your Ngrok authentication token (from [ngrok.com](https://dashboard.ngrok.com/get-started/setup)) |
| `SLACK_WEBHOOK_URL` | Slack webhook URL for sending notifications |

Add these secrets under your repository’s **Settings → Secrets and variables → Actions**.

---

## ⚙️ Optional Input Parameters

| Input | Description | Default |
|--------|--------------|----------|
| `ngrok_duration` | Duration (in seconds) to keep the Ngrok tunnel alive | `180` |

You can modify this value when manually triggering the workflow via the **“Run workflow”** button in GitHub Actions.

---

## 🧾 Example Output

When the workflow completes, logs will display:

```
Waiting for app to start...
🔗 App is publicly accessible at: https://1234abcd.ngrok.io
Keeping ngrok alive for 180 seconds...
✅ CI - Spring Petclinic with Ngrok succeeded on branch main!
```

---

## 🎯 Benefits

- ✅ Fully automated CI pipeline  
- 🐳 Containerized build environment  
- 🌍 Instant public access via Ngrok (no external hosting required)  
- 💬 Real-time Slack notifications  
- 🧱 Ready for CD extension (e.g., deployment to cloud environments)

---

## 🧩 Future Enhancements

- Add **integration tests** before containerization  
- Integrate with **GitHub Environments** for multi-stage deployment  
- Extend with **CD pipeline** to deploy automatically after successful build  
