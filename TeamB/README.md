# WordPress Deployment - Team B (DevOps Engineer Team)

## Objective
The goal of this exercise is to provision an AWS EC2 instance, install MySQL, and set up a database for WordPress. The DevOps Engineering team is responsible for ensuring that the database is correctly configured and ready for use by WordPress.

## Project Structure
```
wordpress-DB
├── TeamB (DevOps Engineer)
│   ├── terraform/        # Terraform scripts for provisioning
│   │   ├── main.tf       # Terraform configuration file
│   ├── ansible/          # Ansible playbooks for MySQL setup
│   │   ├── inventory     # Ansible inventory file
│   │   ├── wp.config.yml # Ansible playbook for MySQL configuration
│   ├── deploy.sh         # Deployment script to run Terraform and Ansible together
│   ├── README.md         # This document
```
---

## Deployment Steps
### Step 1: Use the Deployment Script
To provision the EC2 instance and configure MySQL in one step, run the `deploy.sh` script, or manuaally execute using terraform init, terraform plan, terraform apply, and the ansible playbook.
1. **Make the script executable**:
   ```bash
   chmod +x deploy.sh
   ```

2. **Run the script**:
   ```bash
   ./deploy.sh
   ```

This will:
- Run **Terraform** to provision the EC2 instance.
- Retrieve the **EC2 Public IP** and update the Ansible inventory.
- Execute **Ansible** to install and configure MySQL.

---

## Step-by-Step Breakdown
### **Step 1: Provision EC2 Instance using Terraform**
We use **Terraform** to create an EC2 instance and set up security groups.

#### **1. Navigate to the Terraform directory**:
```bash
cd terraform/
terraform init
```

#### **2. Apply Terraform configuration**:
```bash
terraform apply -auto-approve
```

#### **3. Terraform Provisions:**
- An **EC2 instance**  Ubuntu.
- A **Security Group** allowing:
  - SSH (port **22**)
  - HTTP (port **80**)
  - MySQL (port **3306**) 
- Generates output variables (e.g., public IP for SSH access).

---

### **Step 2: Configure MySQL with Ansible**
Once the EC2 instance is provisioned, we use **Ansible** to install and configure MySQL.

#### **1. Verify Ansible inventory file (`inventory`) contains the EC2 instance IP**.
#### **2. Run the MySQL setup playbook**:
```bash
cd ansible/
ansible-playbook -i inventory wp.config.yml
```

#### **3. What Ansible Playbook (`wp.config.yml`) Does**:
- Updates the package cache.
- Installs MySQL and required Python modules.
- Starts and enables the MySQL service.
- Creates a **WordPress database (`teama_db`)**.
- Creates a **MySQL user (`teama_admin`)** with password authentication.
- Grants necessary privileges to the user.
- Flushes privileges and removes unnecessary test databases.

---

## Database Credentials for Team A
MySQL has been set up, **we will share the following credentials with the cloud strategy Team**:
- **Database Name**:
- **Username

