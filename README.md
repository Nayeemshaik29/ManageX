# ✅ Task Management System  

A **role-based web application** for managing tasks, teams, and feedback — built with **Java Servlets, JSP, MySQL, and Bootstrap**.  
Designed for **Admins, Team Leaders, and Team Members** to collaborate efficiently.  

<p align="center">
  <img src="https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white"/>
  <img src="https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=oracle&logoColor=white"/>
  <img src="https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white"/>
  <img src="https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white"/>
  <img src="https://img.shields.io/badge/Tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black"/>
</p>

---

## ✨ Features

- 🔐 **Authentication & RBAC** – Admin, Team Leader, Member  
- 👨‍💼 **Admin** – Manage users, tasks, and system stats  
- 👔 **Team Leaders** – Create teams, assign tasks, give feedback  
- 👨‍💻 **Team Members** – View/complete tasks, track progress  
- 🎨 **UI** – Bootstrap 5, responsive, modern dashboards  

---

## 🏗️ Architecture  

Browser → JSP/Bootstrap (UI) → Servlets (Controller)
→ DAO Layer (Business) → MySQL (Data Layer)

---

## 🛠️ Tech Stack  

- **Backend:** Java Servlets (JDK 8+), JDBC  
- **Frontend:** JSP, HTML5, CSS3, Bootstrap 5  
- **Database:** MySQL 8.0  
- **Server:** Apache Tomcat 9.0  
- **Tools:** Eclipse IDE, MySQL Workbench  

---

## 📦 Setup Instructions  

1️⃣ Clone the repository  
```bash
git clone https://github.com/yourusername/task-management-system.git
2️⃣ Configure Database (DatabaseConnection.java)
private static final String URL = "jdbc:mysql://localhost:3306/task_management_db";
private static final String USER = "root";
private static final String PASSWORD = "your_mysql_password";
3️⃣ Import Project → Eclipse → Add Tomcat Server
4️⃣ Run on Server → Access at:
👉 http://localhost:8080/TaskManagementSystem/

🗄️ Database Schema
users: user_id, username, password, role
teams: team_id, team_name, leader_id
tasks: task_id, title, description, priority, status
feedback: feedback_id, task_id, given_by, feedback_text
<p align="center"> <img src="https://img.icons8.com/color/96/000000/database.png"/> </p>
👥 Roles
Role	Capabilities
🔴 Admin	Manage users, roles, system tasks
🟡 Leader	Create teams, assign tasks, feedback
🟢 Member	View/complete tasks, submit feedback
📸 Screenshots
<p align="center"> <img src="https://dummyimage.com/600x350/eeeeee/000000&text=Login+Page" width="45%"/> <img src="https://dummyimage.com/600x350/eeeeee/000000&text=Dashboard" width="45%"/> </p>
🔑 Test Credentials
Admin:
Username: admin
Password: password123
Leader / Member accounts are preloaded in the DB.
🚀 Future Enhancements
📧 Email Notifications
📊 Analytics & Reports
📂 File Attachments
📱 Mobile App
📄 License
This project is licensed under the MIT License.
<p align="center">Made with ❤️ in Java</p> ```
