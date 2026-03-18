# Task 4: Architecture Document - WordPress Deployment

## 1. System Connectivity
The application follows this flow: 
**User** (Browser) → **EC2 Instance** (Public IP) → **Docker Engine** → **WordPress Container** (Port 80) + **MySQL Container** (Port 3306) → **EBS Volume** (/mnt/mysql-data). [1, 2]

## 2. Persistent Storage (EBS)
I used an 8GB EBS volume for MySQL data because containers are ephemeral. [3, 4] To make the volume usable by the Linux operating system, I formatted it with the **ext4 filesystem**, which allows Linux to organize files and folders on the disk. [5, 6] Without this volume, any data stored inside the MySQL container would be permanently lost if the container restarted or the EC2 instance was stopped. [2, 3]

## 3. Security Configuration
I opened two specific ports in the Security Group:
* **Port 22 (SSH):** To allow administrative access to the server. [7]
* **Port 80 (HTTP):** To allow public web traffic to reach the WordPress site. [7]
* **Risk:** Port 22 is currently open to the entire internet (0.0.0.0/0), which is a security risk. [8] While I used a password in my scripts for this lab, in a **real production environment**, I would use more secure methods like **Environment Variables** or a **Secrets Manager** to protect sensitive credentials. [9, 10]

## 4. Failure Analysis
If the EC2 instance crashed right now:
* **What breaks:** The running WordPress website would go offline. [8] Any data currently being processed in the server's **RAM (memory)** would be lost.
* **What survives:** All database data already written to the **EBS volume** and the backups previously sent to the **S3 bucket** would survive because they exist independently of the EC2 instance. [8, 11, 12]

## 5. Scalability
To handle 100x more users, I would move the database to a managed service like **Amazon RDS** and use an **Elastic Load Balancer (ELB)** to distribute traffic across multiple EC2 instances. [8, 13] Additionally, I would implement **Auto Scaling Groups** to automatically add or remove EC2 instances based on high traffic demands. [14, 15]
