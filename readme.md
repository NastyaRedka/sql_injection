# Fork project wojciechtrapkowski/sql_injection

This project was forked from  (https://github.com/wojciechtrapkowski/sql_injection) for demonstrates SQL Injection.
# Vulnerable Website with SQL Injection Demonstration

This project showcases a simple website vulnerable to SQL Injection. The website is built with PHP and SQLite and runs inside a Docker container. It allows demonstration of how SQL Injection attacks can be used to bypass authentication mechanisms.

### How SQL Injection Works

By submitting specially crafted inputs into the form fields of the login page, attackers can manipulate the SQL query used to authenticate users. This can result in bypassing the authentication mechanism.

Example SQL Injection Attack

	•	Username: admin' --
	•	Password: anything

This works because the SQL query becomes:

SELECT * FROM users WHERE username = 'admin' --' AND password = 'anything';

The -- sequence comments out the remainder of the SQL query, effectively bypassing the password check.

### Getting Started

Prerequisites

- Docker installed on your machine

Installation & Setup

1.	Clone the Repository

```bash
git clone <repository-url>
cd <repository-directory>
```

2.	Build the Docker Image

Build the Docker image using the following command:

```bash
docker build -t vulnerable-website .
```

3.	Run the Docker Container

Run the website by starting the Docker container:

```
docker run -d -p 8080:80 vulnerable-website
```

4.	Access the Website

Open your browser and navigate to:

http://localhost:8080

To stop and remove working containers run
```
docker stop <container_id>
docker rm <container_id>
```

To remove the Docker image
```
docker rmi vulnerable-website
```


### How to Perform SQL Injection

To bypass authentication, follow these steps:

1.	Go to the login page of the website.
2.	Enter the following in the username field:

```
admin' --
```

You can put anything in the password field.

3.	Submit the form, and you should be logged in as an administrator.

### Using sqlmap

sqlmap is an open-source penetration testing tool that automates the process of detecting and exploiting SQL injection vulnerabilities in web applications.

#### Testing it in our simple app

Clone the repository
```
git clone https://github.com/sqlmapproject/sqlmap
```


```bash
python3 sqlmap/sqlmap.py -u "http://localhost:8080/handle_login.php" --data="username=admin&password=test&method=vulnerable" --risk=3 --level=5
```

### Project Structure

- Dockerfile: Defines the environment and dependencies for the project.
- handle_login.php: The main PHP file handling the form submission and user authentication.
- index.html: Simple login page.
- database.db: The SQLite database file containing user information.
- styles.css: The CSS file for basic styling of the web page.

### Warning

This project is for educational purposes only.
It demonstrates how SQL Injection attacks can compromise a web application’s security. Never use vulnerable code in production environments!
