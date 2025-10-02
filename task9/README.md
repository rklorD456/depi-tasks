# Task 9: Deploying Spring PetClinic with Ansible and Docker

## 📝 Overview

This project automates the deployment of the Spring PetClinic application and a MySQL database using Docker Compose, all managed by an Ansible playbook.

## ✨ Features

* **Automated Deployment:** Uses Ansible to set up the server and deploy the application.
* **Containerized:** The application and database run in separate Docker containers.
* **Idempotent:** The playbook uses the official `community.docker.docker_compose` module and can be run multiple times without causing errors.
* **Corrected Configuration:** Includes fixes for running the PetClinic application, including updating to Java 21 to solve environment incompatibilities.

## 🚀 Setup and Deployment

### Step 1: Prerequisites (On Your Local Machine)

Make sure you have Ansible installed and have added the required Docker collection:
```bash
ansible-galaxy collection install community.docker
```

### Step 2: Project Structure

Organize your project files locally as follows:
```
/task9/
├── deploy-petclinic.yml      # The main Ansible playbook
├── docker-compose.yml        # The Docker Compose configuration
├── hosts.ini                 # Your Ansible inventory file
└── spring-petclinic/         # The application source code
    └── Dockerfile            # The corrected Dockerfile
```

### Step 3: Get the Application Source Code

Clone the official PetClinic repository into your project directory. This will create the `spring-petclinic` folder.
```bash
git clone [https://github.com/spring-projects/spring-petclinic.git](https://github.com/spring-projects/spring-petclinic.git)
```

### Step 4: Configure and Deploy

1.  **Add your server's IP** to the `hosts.ini` file.
2.  **Run the Ansible playbook:**
    ```bash
    ansible-playbook -i hosts.ini deploy-petclinic.yml
    ```

## ✅ Verification

1.  **Check the Containers:** SSH into your server and run `sudo docker ps`. You should see two containers running: `petclinic-mysql` and `petclinic-app`.

2.  **Access the Application:** Open your web browser and go to `http://<your_server_ip_here>:8088`.

---

## 🔧 Challenges and Solutions

This project encountered several issues during deployment. Here is a brief summary of the problems and how they were solved.

### 1. Application Crashed on Start
* **Problem:** The Spring Boot application would crash immediately with a `NullPointerException` related to a bug in the Spring Actuator metrics library.
* **Solution:** We disabled the specific metric causing the crash by adding an environment variable in `docker-compose.yml`:
    ```yaml
    - MANAGEMENT_METRICS_BINDER_PROCESSOR_ENABLED=false
    ```

### 2. Database Connection Refused
* **Problem:** The application container would start faster than the MySQL container, causing a "Connection refused" error.
* **Solution:** We made the `app` service wait for the database to be fully healthy by updating the `depends_on` condition in `docker-compose.yml`:
    ```yaml
    depends_on:
      mysql:
        condition: service_healthy
    ```

### 3. Java and EC2 Incompatibility
* **Problem:** The application still failed due to a deep incompatibility between the Java 17 base image and the EC2 instance's environment.
* **Solution:** We updated the project's `Dockerfile` to build and run the application on a more modern **Java 21** base image.

### 4. Server Disk Space
* **Problem:** The EC2 instance repeatedly ran out of disk space (`no space left on device`).
* **Solution:** We cleaned up all unused Docker data with `sudo docker system prune -a --volumes`. The long-term solution is to use an EC2 instance with a larger storage volume.
