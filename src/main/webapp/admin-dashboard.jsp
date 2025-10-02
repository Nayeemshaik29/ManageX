<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, models.*, daos.*" %>
<%
    if (session.getAttribute("user") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    TaskDAO taskDAO = new TaskDAO();
    UserDAO userDAO = new UserDAO();
    TeamDAO teamDAO = new TeamDAO();
    
    List<Task> allTasks = taskDAO.getAllTasks();
    List<User> allUsers = userDAO.getAllUsers();
    List<User> teamMembers = userDAO.getUsersByRole("team_member");
    List<Team> allTeams = teamDAO.getAllTeams();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-danger">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">🎯 Admin Dashboard</a>
            <div class="d-flex">
                <span class="navbar-text text-white me-3">
                    Welcome, <%= session.getAttribute("fullName") %>
                </span>
                <a href="logout" class="btn btn-outline-light btn-sm">Logout</a>
            </div>
        </div>
    </nav>
    
    <div class="container-fluid mt-4">
        <!-- Success/Error Messages -->
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Operation completed successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                Operation failed. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <div class="card-body">
                        <h5 class="card-title">Total Tasks</h5>
                        <h2><%= allTasks.size() %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body">
                        <h5 class="card-title">Total Users</h5>
                        <h2><%= allUsers.size() %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body">
                        <h5 class="card-title">Total Teams</h5>
                        <h2><%= allTeams.size() %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-white">
                    <div class="card-body">
                        <h5 class="card-title">Team Members</h5>
                        <h2><%= teamMembers.size() %></h2>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <!-- Add Task Form -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">➕ Add New Task</h5>
                    </div>
                    <div class="card-body">
                        <form action="admin" method="post">
                            <input type="hidden" name="action" value="addTask">
                            <div class="mb-3">
                                <label class="form-label">Task Title</label>
                                <input type="text" class="form-control" name="title" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <textarea class="form-control" name="description" rows="3" required></textarea>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Priority</label>
                                    <select class="form-select" name="priority" required>
                                        <option value="low">Low</option>
                                        <option value="medium" selected>Medium</option>
                                        <option value="high">High</option>
                                        <option value="critical">Critical</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Assign To</label>
                                    <select class="form-select" name="assignedTo" required>
                                        <option value="">Select Member</option>
                                        <% for (User member : teamMembers) { %>
                                            <option value="<%= member.getUserId() %>"><%= member.getFullName() %></option>
                                        <% } %>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Team</label>
                                    <select class="form-select" name="teamId" required>
                                        <option value="">Select Team</option>
                                        <% for (Team team : allTeams) { %>
                                            <option value="<%= team.getTeamId() %>"><%= team.getTeamName() %></option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Start Date</label>
                                    <input type="date" class="form-control" name="startDate" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Deadline</label>
                                    <input type="date" class="form-control" name="deadline" required>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Add Task</button>
                        </form>
                    </div>
                </div>
            </div>
            
            <!-- Assign Roles Form -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">👤 Assign/Change User Role</h5>
                    </div>
                    <div class="card-body">
                        <form action="admin" method="post">
                            <input type="hidden" name="action" value="assignRole">
                            <div class="mb-3">
                                <label class="form-label">Select User</label>
                                <select class="form-select" name="userId" required>
                                    <option value="">Choose a user</option>
                                    <% for (User user : allUsers) { 
                                        if (user.getUserId() != 1) { // Don't allow changing admin role
                                    %>
                                        <option value="<%= user.getUserId() %>">
                                            <%= user.getFullName() %> (<%= user.getRole() %>)
                                        </option>
                                    <% }} %>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">New Role</label>
                                <select class="form-select" name="newRole" required>
                                    <option value="team_leader">Team Leader</option>
                                    <option value="team_member">Team Member</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success w-100">Assign Role</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- All Tasks Table -->
        <div class="card">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0">📋 All Tasks</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th>Assigned To</th>
                                <th>Team</th>
                                <th>Deadline</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Task task : allTasks) { %>
                                <tr>
                                    <td><%= task.getTaskId() %></td>
                                    <td><%= task.getTitle() %></td>
                                    <td>
                                        <span class="badge bg-<%= getPriorityClass(task.getPriority()) %>">
                                            <%= task.getPriority().toUpperCase() %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge bg-<%= getStatusClass(task.getStatus()) %>">
                                            <%= task.getStatus().replace("_", " ").toUpperCase() %>
                                        </span>
                                    </td>
                                    <td><%= task.getAssignedToName() != null ? task.getAssignedToName() : "Unassigned" %></td>
                                    <td><%= task.getTeamName() != null ? task.getTeamName() : "No Team" %></td>
                                    <td><%= task.getDeadline() %></td>
                                    <td>
                                        <form action="admin" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="deleteTask">
                                            <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                                            <button type="submit" class="btn btn-danger btn-sm" 
                                                    onclick="return confirm('Are you sure?')">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <%!
        String getPriorityClass(String priority) {
            switch(priority.toLowerCase()) {
                case "critical": return "danger";
                case "high": return "warning";
                case "medium": return "info";
                case "low": return "secondary";
                default: return "secondary";
            }
        }
        
        String getStatusClass(String status) {
            switch(status.toLowerCase()) {
                case "completed": return "success";
                case "in_progress": return "primary";
                case "pending": return "warning";
                default: return "secondary";
            }
        }
    %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>