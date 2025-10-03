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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <style>
        /* ----- Palette ----- */
        :root {
            --bg-base: #F5F7FA;
            --bg-surface: #FFFFFF;
            --color-primary: #4F46E5;
            --color-secondary: #10B981;
            --color-warning: #F59E0B;
            --color-danger: #EF4444;
            --text-dark: #111827;
            --text-secondary: #6B7280;
        }

        body {
            background-color: var(--bg-base);
            color: var(--text-dark);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .dashboard-header {
            background: var(--color-primary);
            position: relative;
            color: white;
        }
        .dashboard-header .overlay {
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.3);
        }
        .dashboard-header .container {
            position: relative;
            z-index: 1;
        }

        .card {
            background-color: var(--bg-surface);
            border: none;
            border-radius: 0.5rem;
            transition: transform 0.15s ease, box-shadow 0.15s ease;
        }
        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.1);
        }

        .card-header {
            background-color: var(--color-primary);
            color: white;
            border-top-left-radius: 0.5rem;
            border-top-right-radius: 0.5rem;
        }

        .card-title {
            font-weight: 600;
        }

        .table thead th {
            background-color: var(--bg-base);
            color: var(--text-secondary);
            font-weight: 600;
        }

        .btn-primary {
            background-color: var(--color-primary);
            border-color: var(--color-primary);
            color: white;
        }
        .btn-primary:hover {
            background-color: darken(var(--color-primary), 10%);
            border-color: darken(var(--color-primary), 10%);
        }

        .btn-success {
            background-color: var(--color-secondary);
            border-color: var(--color-secondary);
        }
        .btn-success:hover {
            background-color: darken(var(--color-secondary), 10%);
        }

        .btn-danger {
            background-color: var(--color-danger);
            border-color: var(--color-danger);
        }
        .btn-danger:hover {
            background-color: darken(var(--color-danger), 10%);
        }

        /* Badge / Status classes */
        .badge.bg-danger { background-color: var(--color-danger) !important; }
        .badge.bg-warning { background-color: var(--color-warning) !important; color: var(--text-dark); }
        .badge.bg-info { background-color: var(--color-primary) !important; }
        .badge.bg-secondary { background-color: var(--text-secondary) !important; color: white; }
        .badge.bg-success { background-color: var(--color-secondary) !important; }
        .badge.bg-primary { background-color: var(--color-primary) !important; }

        a.btn-outline-light {
            color: white;
            border-color: white;
        }
        a.btn-outline-light:hover {
            background-color: white;
            color: var(--color-primary);
        }
    </style>
</head>
<body>
    <header class="dashboard-header">
        <div class="overlay"></div>
        <div class="container py-4 text-center text-white">
            <h1 class="fw-bold"><i class="bi bi-speedometer2"></i> Admin Dashboard</h1>
            <p class="mb-0">Welcome, <%= session.getAttribute("fullName") %></p>
            <a href="logout" class="btn btn-outline-light btn-sm mt-2">Logout</a>
        </div>
    </header>

    <div class="container-fluid mt-4">
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

        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title"><i class="bi bi-list-task"></i> Total Tasks</h5>
                        <h2><%= allTasks.size() %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title"><i class="bi bi-people"></i> Total Users</h5>
                        <h2><%= allUsers.size() %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title"><i class="bi bi-diagram-3"></i> Total Teams</h5>
                        <h2><%= allTeams.size() %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title"><i class="bi bi-person-badge"></i> Team Members</h5>
                        <h2><%= teamMembers.size() %></h2>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6 mb-4">
                <div class="card shadow-sm">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="bi bi-plus-circle"></i> Add New Task</h5>
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

            <div class="col-md-6 mb-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="bi bi-person-lines-fill"></i> Assign/Change User Role</h5>
                    </div>
                    <div class="card-body">
                        <form action="admin" method="post">
                            <input type="hidden" name="action" value="assignRole">
                            <div class="mb-3">
                                <label class="form-label">Select User</label>
                                <select class="form-select" name="userId" required>
                                    <option value="">Choose a user</option>
                                    <% for (User user : allUsers) { 
                                        if (user.getUserId() != 1) { %>
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

        <div class="card shadow-sm">
            <div class="card-header" style="background-color: var(--text-dark);">
                <h5 class="mb-0 text-white"><i class="bi bi-table"></i> All Tasks</h5>
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
