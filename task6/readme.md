# My App with Docker

This project runs a web application and a PostgreSQL database using Docker Compose.

---

## Setup

Before you start, you need to create two files.

1.  Create a file named `.env.app` with this content:
    ```env
    DATABASE_HOST=db
    DATABASE_USER=myuser
    DATABASE_PASSWORD=mypassword
    DATABASE_NAME=mydb
    DATABASE_PORT=5432
    APP_PORT=8080
    ```

2.  Create a file named `.env.db` with this content:
    ```env
    POSTGRES_USER=myuser
    POSTGRES_PASSWORD=mypassword
    POSTGRES_DB=mydb
    ```

---

## How to Run

* **To start** the application and database:
    ```bash
    docker-compose up -d --build
    ```

* **To stop** everything:
    ```bash
    docker-compose down
    ```

* **To see the logs**:
    ```bash
    docker-compose logs -f
    ```

---

## Access the App

Once it's running, you can open your app at: **http://localhost:8080**