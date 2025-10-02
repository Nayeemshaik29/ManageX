<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, models.*, daos.*" %>
<%
    if (session.getAttribute("user") == null || !"team_member".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int memberId = (Integer) session.getAttribute("userId");
    TaskDAO taskDAO = new TaskDAO();
    FeedbackDAO feedbackDAO = new FeedbackDAO();
    
    List<Task> myTasks = taskDAO.getTasksByUserId(memberId);
    List<Feedback> allFeedback = feedbackDAO.getAllFeedback();

    // ✅ Count variables (instead of lambdas)
    int completedCount = 0;
    int inProgressCount = 0;
    int pendingCount = 0;

    for (Task t : myTasks) {
        if ("completed".equals(t.getStatus())) {
            completedCount++;
        } else if ("in_progress".equals(t.getStatus())) {
            inProgressCount++;
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
    <title>Team Member Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">🎯 Team Member Dashboard</a>
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
                        <h2><%= myTasks.size() %></h2>
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
                        <h5 class="card-title">In Progress</h5>
                        <h2><%= inProgressCount %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body">
                        <h5 class="card-title">Pending</h5>
                        <h2><%= pendingCount %></h2>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Give Feedback Form -->
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">💬 Give Feedback on Tasks</h5>
                    </div>
                    <div class="card-body">
                        <form action="teammember" method="post">
                            <input type="hidden" name="action" value="giveFeedback">
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Select Task</label>
                                    <select class="form-select" name="taskId" required>
                                        <option value="">Choose a task</option>
                                        <% for (Task task : myTasks) { %>
                                            <option value="<%= task.getTaskId() %>">
                                                <%= task.getTitle() %>
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Your Feedback</label>
                                    <textarea class="form-control" name="feedbackText" rows="1" required></textarea>
                                </div>
                                <div class="col-md-2 mb-3">
                                    <label class="form-label">&nbsp;</label>
                                    <button type="submit" class="btn btn-primary w-100">Submit</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- My Tasks Table -->
        <div class="card">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0">📋 My Assigned Tasks</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Description</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th>Team</th>
                                <th>Start Date</th>
                                <th>Deadline</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (myTasks.isEmpty()) { %>
                                <tr>
                                    <td colspan="9" class="text-center">No tasks assigned yet</td>
                                </tr>
                            <% } else { %>
                                <% for (Task task : myTasks) { %>
                                    <tr>
                                        <td><%= task.getTaskId() %></td>
                                        <td><strong><%= task.getTitle() %></strong></td>
                                        <td><%= task.getDescription() %></td>
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
                                        <td><%= task.getTeamName() != null ? task.getTeamName() : "No Team" %></td>
                                        <td><%= task.getStartDate() %></td>
                                        <td><%= task.getDeadline() %></td>
                                        <td>
                                            <% if (!"completed".equals(task.getStatus())) { %>
                                                <form action="teammember" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="completeTask">
                                                    <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                                                    <button type="submit" class="btn btn-success btn-sm" 
                                                            onclick="return confirm('Mark this task as completed?')">
                                                        ✓ Complete
                                                    </button>
                                                </form>
                                            <% } else { %>
                                                <span class="text-success">✓ Completed</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <!-- Recent Feedback Section -->
        <div class="card mt-4">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">💭 Recent Feedback</h5>
            </div>
            <div class="card-body">
                <% 
                List<Feedback> myFeedback = new ArrayList<>();
                for (Feedback fb : allFeedback) {
                    for (Task task : myTasks) {
                        if (fb.getTaskId() == task.getTaskId()) {
                            myFeedback.add(fb);
                            break;
                        }
                    }
                }
                
                if (myFeedback.isEmpty()) { %>
                    <p class="text-muted">No feedback yet</p>
                <% } else { %>
                    <div class="list-group">
                        <% for (Feedback feedback : myFeedback) { %>
                            <div class="list-group-item">
                                <div class="d-flex w-100 justify-content-between">
                                    <h6 class="mb-1"><%= feedback.getTaskTitle() %></h6>
                                    <small class="text-muted"><%= feedback.getCreatedAt() %></small>
                                </div>
                                <p class="mb-1"><%= feedback.getFeedbackText() %></p>
                                <small class="text-muted">- <%= feedback.getGivenByName() %></small>
                            </div>
                        <% } %>
                    </div>
                <% } %>
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
