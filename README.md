# 📋 Task Management System

<div align="center">

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Bootstrap](https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white)
![Servlets](https://img.shields.io/badge/Servlets-007396?style=for-the-badge&logo=java&logoColor=white)

**A comprehensive role-based task management web application built with Java Servlets, JSP, MySQL, and Bootstrap 5**

[Features](#-features) • [Tech Stack](#-tech-stack) • [Setup](#-setup-instructions) • [Database](#-database-schema) • [Screenshots](#-screenshots)

</div>

---

## ✨ Features

### 🔐 **Authentication & Role-Based Access Control (RBAC)**
- Secure login system with role-based routing
- Three distinct user roles: **Admin**, **Team Leader**, **Team Member**
- Session management with automatic role-based dashboard redirection

### 👨‍💼 **Admin Dashboard**
- **User Management**: View total users, create and manage user roles
- **Task Oversight**: Monitor all tasks across teams with priority and status tracking
- **Team Management**: View team structure and member count
- **Role Assignment**: Dynamically assign or change user roles
- **System Statistics**: Real-time metrics for tasks, users, teams, and members

### 👔 **Team Leader Dashboard**
- **Team Creation**: Create and manage multiple teams
- **Task Assignment**: Create tasks with priority levels, deadlines, and team assignments
- **Member Management**: Add members to teams and monitor team composition
- **Progress Tracking**: View task completion rates (completed vs pending)
- **Feedback System**: Provide feedback on team member task performance
- **Task Actions**: Set priorities and update task details

### 👨‍💻 **Team Member Dashboard**
- **Task Overview**: View personal task statistics (total, completed, in progress, pending)
- **Task Management**: Mark tasks as complete with a single click
- **Feedback Submission**: Provide feedback on assigned tasks
- **Recent Feedback**: View feedback history from team leaders
- **Task Details**: Access comprehensive task information including description, priority, status, and deadlines

### 🎨 **Modern UI/UX**
- Fully responsive Bootstrap 5 design
- Intuitive color-coded dashboards:
  - Admin: Deep purple theme
  - Team Leader: Purple gradient theme
  - Team Member: Dark navy theme
- Office-themed login page with modern illustrations
- Status badges (COMPLETED, PENDING, CRITICAL, HIGH)
- Interactive forms with date pickers and dropdowns

---

## 🏗️ System Architecture

```
┌─────────────┐
│   Browser   │
└──────┬──────┘
       │
       ▼
┌─────────────────────────┐
│   Presentation Layer    │
│   (JSP + Bootstrap 5)   │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│   Controller Layer      │
│   (Java Servlets)       │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│   Business Logic Layer  │
│   (DAO Pattern)         │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│   Data Access Layer     │
│   (JDBC + MySQL)        │
└─────────────────────────┘
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| **Backend** | Java Servlets (JDK 8+), JDBC |
| **Frontend** | JSP, HTML5, CSS3, Bootstrap 5 |
| **Database** | MySQL 8.0 |
| **Server** | Apache Tomcat 9.0+ |
| **IDE** | Eclipse IDE / IntelliJ IDEA |
| **Tools** | MySQL Workbench, Maven (optional) |
| **Design Pattern** | MVC, DAO Pattern |

---

## 📦 Setup Instructions

### Prerequisites
- ✅ JDK 8 or higher
- ✅ Apache Tomcat 9.0+
- ✅ MySQL 8.0+
- ✅ Eclipse IDE or IntelliJ IDEA

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/yourusername/task-management-system.git
cd task-management-system
```

### 2️⃣ Database Setup
Open MySQL Workbench and execute the [database schema](#-database-schema) provided below.

### 3️⃣ Configure Database Connection
Edit `DatabaseConnection.java` with your MySQL credentials:
```java
private static final String URL = "jdbc:mysql://localhost:3306/task_management_db";
private static final String USER = "root";
private static final String PASSWORD = "your_mysql_password";
```

### 4️⃣ Import Project to Eclipse
1. Open Eclipse IDE
2. File → Import → Existing Projects into Workspace
3. Select the cloned repository folder
4. Add Tomcat 9.0 server to Eclipse

### 5️⃣ Deploy and Run
1. Right-click project → Run As → Run on Server
2. Select Tomcat 9.0 and click Finish
3. Access the application at: **http://localhost:8080/TaskManagementSystem/**

---

## 🗄️ Database Schema

### Entity Relationship Overview
```
users (1) ──┬── (N) team_members (N) ── (1) teams
            │
            ├── (N) tasks (assigned_to)
            │
            └── (N) feedback (given_by)
```

### SQL Schema
```sql
-- Create Database
CREATE DATABASE IF NOT EXISTS task_management_db;
USE task_management_db;

-- Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'team_leader', 'team_member') NOT NULL DEFAULT 'team_member',
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Teams Table
CREATE TABLE teams (
    team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(100) NOT NULL,
    leader_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (leader_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Team Members Junction Table
CREATE TABLE team_members (
    team_id INT,
    member_id INT,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (team_id, member_id),
    FOREIGN KEY (team_id) REFERENCES teams(team_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Tasks Table
CREATE TABLE tasks (
    task_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    priority ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    status ENUM('pending', 'in_progress', 'completed') DEFAULT 'pending',
    assigned_to INT NULL,
    team_id INT NULL,
    start_date DATE,
    deadline DATE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (assigned_to) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (team_id) REFERENCES teams(team_id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Feedback Table
CREATE TABLE feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    task_id INT NOT NULL,
    given_by INT,
    feedback_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    FOREIGN KEY (given_by) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Insert Default Admin User
INSERT INTO users (username, password, full_name, role, email)
VALUES ('admin', 'admin123', 'System Administrator', 'admin', 'admin@task.com');
```

### Database Queries for Testing
```sql
-- View all data
SELECT * FROM users;
SELECT * FROM teams;
SELECT * FROM team_members;
SELECT * FROM tasks;
SELECT * FROM feedback;
```

---

## 👥 User Roles & Capabilities

| Role | Key Capabilities | Dashboard Access |
|------|------------------|------------------|
| 🔴 **Admin** | • Manage all users and roles<br>• View system-wide statistics<br>• Create and delete tasks<br>• Assign/change user roles<br>• Monitor all teams | Admin Dashboard |
| 🟡 **Team Leader** | • Create and manage teams<br>• Assign tasks to team members<br>• Set task priorities and deadlines<br>• Provide feedback on tasks<br>• Track team progress | Team Leader Dashboard |
| 🟢 **Team Member** | • View assigned tasks<br>• Mark tasks as complete<br>• Submit feedback on tasks<br>• Track personal progress<br>• View recent feedback | Team Member Dashboard |

---

## 📸 Screenshots

### 🔐 Login & Registration
<div align="center">
<table>
<tr>
<td width="50%">

![Login Page](docs/screenshots/login.png)

**Modern Login Interface**
- Office-themed design
- Role-based authentication
- Secure credential management

</td>
<td width="50%">

![Registration Page](docs/screenshots/register.png)

**User Registration**
- Role selection dropdown
- Form validation
- Email verification

</td>
</tr>
</table>
</div>

### 👨‍💼 Admin Dashboard

![Admin Dashboard](docs/screenshots/admin-dashboard.png)

**Features:**
- System-wide statistics (Total Tasks, Users, Teams, Members)
- Add new tasks with priority and assignment
- Assign/change user roles
- View all tasks with status tracking
- Delete tasks functionality

### 👔 Team Leader Dashboard

![Team Leader Dashboard](docs/screenshots/team-leader-dashboard.png)

**Features:**
- Team overview with task completion metrics (Completed: 1, Pending: 1)
- Create new teams and add members
- Task management with priority settings (Critical, High, Low, Medium)
- Feedback submission system
- Set task priorities and update details

### 👨‍💻 Team Member Dashboard

![Team Member Dashboard](docs/screenshots/team-member-dashboard.png)

**Features:**
- Personal task statistics (Total: 1, Completed: 0, In Progress: 0, Pending: 1)
- Complete tasks with one click
- Submit feedback on tasks
- View recent feedback from leaders with timestamps
- View detailed task information (Description, Priority, Status, Deadline)

---

## 📷 Setting Up Screenshots

To display the screenshots in your README:

1. **Create a screenshots folder in your repository:**
   ```
   TaskManagementSystem/
   ├── docs/
   │   └── screenshots/
   │       ├── login.png
   │       ├── register.png
   │       ├── admin-dashboard.png
   │       ├── team-leader-dashboard.png
   │       └── team-member-dashboard.png
   ```

2. **Save your application screenshots** (the images you shared with me) with these exact names

3. **Commit and push to GitHub:**
   ```bash
   git add docs/screenshots/
   git commit -m "Add application screenshots"
   git push origin main
   ```

4. **Alternative:** If you want to use a different path, update the image paths in the README:
   ```markdown
   ![Login Page](your-path/login.png)
   ```

> **Tip:** Make sure your screenshots are optimized (not too large) for faster loading. Recommended max width: 1200px

---

## 🔑 Test Credentials

```
Admin Account:
Username: admin
Password: admin123

Test Team Leader & Member accounts can be created via the registration page.
```

---

## 🚀 Future Enhancements

- [ ] 📧 **Email Notifications** - Automated task assignment and deadline reminders
- [ ] 📊 **Analytics Dashboard** - Visual charts for productivity tracking
- [ ] 📂 **File Attachments** - Attach documents and images to tasks
- [ ] 🔔 **Real-time Notifications** - WebSocket-based live updates
- [ ] 📱 **Mobile Application** - Native Android/iOS apps
- [ ] 🔒 **Password Encryption** - Implement BCrypt hashing
- [ ] 🌐 **REST API** - Expose endpoints for third-party integrations
- [ ] 📅 **Calendar View** - Visualize tasks in a calendar layout
- [ ] 👤 **Profile Management** - User avatars and settings
- [ ] 🔍 **Advanced Search** - Filter and search tasks

---

## 📄 Project Structure

```
TaskManagementSystem/
├── src/
│   ├── com.task.controller/    # Servlets
│   ├── com.task.dao/            # Data Access Objects
│   ├── com.task.model/          # Entity Classes
│   └── com.task.util/           # Database Connection
├── WebContent/
│   ├── WEB-INF/
│   │   └── web.xml              # Deployment Descriptor
│   ├── css/                     # Custom Stylesheets
│   ├── js/                      # JavaScript Files
│   ├── login.jsp
│   ├── register.jsp
│   ├── adminDashboard.jsp
│   ├── teamLeaderDashboard.jsp
│   └── teamMemberDashboard.jsp
├── database/
│   └── schema.sql               # Database Schema
└── README.md
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


---


<div align="center">

### ⭐ Star this repository if you find it helpful!

Made with ❤️ and ☕ using Java

</div>
```
