<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, daos.TaskDAO, daos.TeamDAO, daos.UserDAO, models.Task, models.Team, models.User" %>

<%
    if (session.getAttribute("user") == null || !"team_leader".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int leaderId = (Integer) session.getAttribute("userId");
    TaskDAO taskDAO = new TaskDAO();
    TeamDAO teamDAO = new TeamDAO();
    UserDAO userDAO = new UserDAO();
    
    List<Team> myTeams = teamDAO.getTeamsByLeader(leaderId);
    List<Task> allTasks = new ArrayList<>();
    for (Team team : myTeams) {
        allTasks.addAll(taskDAO.getTasksByTeamId(team.getTeamId()));
    }
    List<User> teamMembers = userDAO.getUsersByRole("team_member");

    // ✅ Replace stream counts with manual counters
    int completedCount = 0;
    int pendingCount = 0;
    for (Task t : allTasks) {
        if ("completed".equals(t.getStatus())) {
            completedCount++;
        } else if ("pending".equals(t.getStatus())) {
            pendingCount++;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Team Leader Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-warning">
        <div class="container-fluid">
            <a class="navbar-brand text-dark" href="#">🎯 Team Leader Dashboard</a>
            <div class="d-flex">
                <span class="navbar-text text-dark me-3">
                    Welcome, <%= session.getAttribute("fullName") %>
                </span>
                <a href="logout" class="btn btn-outline-dark btn-sm">Logout</a>
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
                        <h5 class="card-title">My Teams</h5>
                        <h2><%= myTeams.size() %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body">
                        <h5 class="card-title">Total Tasks</h5>
                        <h2><%= allTasks.size() %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body">
                        <h5 class="card-title">Completed</h5>
                        <h2><%= completedCount %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-white">
                    <div class="card-body">
                        <h5 class="card-title">Pending</h5>
                        <h2><%= pendingCount %></h2>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <!-- Create Team Form -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">👥 Create New Team</h5>
                    </div>
                    <div class="card-body">
                        <form action="teamleader" method="post">
                            <input type="hidden" name="action" value="createTeam">
                            <div class="mb-3">
                                <label class="form-label">Team Name</label>
                                <input type="text" class="form-control" name="teamName" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Create Team</button>
                        </form>
                        
                        <hr>
                        
                        <h6>My Teams:</h6>
                        <ul class="list-group">
                            <% for (Team team : myTeams) { %>
                                <li class="list-group-item">
                                    <strong><%= team.getTeamName() %></strong>
                                    <button class="btn btn-sm btn-outline-primary float-end" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#addMemberModal<%= team.getTeamId() %>">
                                        Add Member
                                    </button>
                                </li>
                                
                                <!-- Add Member Modal -->
                                <div class="modal fade" id="addMemberModal<%= team.getTeamId() %>" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Add Member to <%= team.getTeamName() %></h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <form action="teamleader" method="post">
                                                <div class="modal-body">
                                                    <input type="hidden" name="action" value="addMember">
                                                    <input type="hidden" name="teamId" value="<%= team.getTeamId() %>">
                                                    <div class="mb-3">
                                                        <label class="form-label">Select Member</label>
                                                        <select class="form-select" name="memberId" required>
                                                            <option value="">Choose a member</option>
                                                            <% for (User member : teamMembers) { %>
                                                                <option value="<%= member.getUserId() %>">
                                                                    <%= member.getFullName() %>
                                                                </option>
                                                            <% } %>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                    <button type="submit" class="btn btn-primary">Add Member</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        </ul>
                    </div>
                </div>
            </div>
            
            <!-- Give Feedback Form -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">💬 Give Feedback</h5>
                    </div>
                    <div class="card-body">
                        <form action="teamleader" method="post">
                            <input type="hidden" name="action" value="giveFeedback">
                            <div class="mb-3">
                                <label class="form-label">Select Task</label>
                                <select class="form-select" name="taskId" required>
                                    <option value="">Choose a task</option>
                                    <% for (Task task : allTasks) { %>
                                        <option value="<%= task.getTaskId() %>">
                                            <%= task.getTitle() %> - <%= task.getStatus() %>
                                        </option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Feedback</label>
                                <textarea class="form-control" name="feedbackText" rows="4" required></textarea>
                            </div>
                            <button type="submit" class="btn btn-success w-100">Submit Feedback</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Tasks Table -->
        <div class="card">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0">📋 Team Tasks & Progress</h5>
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
                                <th>Start Date</th>
                                <th>Deadline</th>
                                <th>Actions</th>
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
                                    <td><%= task.getStartDate() %></td>
                                    <td><%= task.getDeadline() %></td>
                                    <td>
                                        <button class="btn btn-warning btn-sm" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#priorityModal<%= task.getTaskId() %>">
                                            Set Priority
                                        </button>
                                        <button class="btn btn-info btn-sm" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#datesModal<%= task.getTaskId() %>">
                                            Set Dates
                                        </button>
                                    </td>
                                </tr>
                                
                                <!-- Priority Modal -->
                                <div class="modal fade" id="priorityModal<%= task.getTaskId() %>" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Set Priority: <%= task.getTitle() %></h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <form action="teamleader" method="post">
                                                <div class="modal-body">
                                                    <input type="hidden" name="action" value="setPriority">
                                                    <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                                                    <div class="mb-3">
                                                        <label class="form-label">Priority Level</label>
                                                        <select class="form-select" name="priority" required>
                                                            <option value="low" <%= "low".equals(task.getPriority()) ? "selected" : "" %>>Low</option>
                                                            <option value="medium" <%= "medium".equals(task.getPriority()) ? "selected" : "" %>>Medium</option>
                                                            <option value="high" <%= "high".equals(task.getPriority()) ? "selected" : "" %>>High</option>
                                                            <option value="critical" <%= "critical".equals(task.getPriority()) ? "selected" : "" %>>Critical</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                    <button type="submit" class="btn btn-warning">Update Priority</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Dates Modal -->
                                <div class="modal fade" id="datesModal<%= task.getTaskId() %>" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Set Dates: <%= task.getTitle() %></h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <form action="teamleader" method="post">
                                                <div class="modal-body">
                                                    <input type="hidden" name="action" value="setDates">
                                                    <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                                                    <div class="mb-3">
                                                        <label class="form-label">Start Date</label>
                                                        <input type="date" class="form-control" name="startDate" 
                                                               value="<%= task.getStartDate() %>" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Deadline</label>
                                                        <input type="date" class="form-control" name="deadline" 
                                                               value="<%= task.getDeadline() %>" required>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                    <button type="submit" class="btn btn-info">Update Dates</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
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
