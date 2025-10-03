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
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        .card {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .card:hover {
            transform: translateY(-2px);
        }
        .table-hover tbody tr:hover {
            background-color: rgba(102, 126, 234, 0.05);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%); box-shadow: 0 2px 15px rgba(0,0,0,0.1);">
        <div class="container-fluid">
            <a class="navbar-brand text-white fw-bold" href="#">🎯 Team Member Dashboard</a>
            <div class="d-flex">
                <span class="navbar-text text-white me-3">
                    Welcome, <strong><%= session.getAttribute("fullName") %></strong>
                </span>
                <a href="logout" class="btn btn-outline-light btn-sm" style="border-radius: 8px;">Logout</a>
            </div>
        </div>
    </nav>
    
    <div class="container-fluid mt-4 px-4">
        <!-- Success/Error Messages -->
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 10px; border-left: 4px solid #10b981;">
                <strong>Success!</strong> Operation completed successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert" style="border-radius: 10px; border-left: 4px solid #ef4444;">
                <strong>Error!</strong> Operation failed. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <!-- Statistics Cards -->
        <div class="row mb-4 g-4">
            <div class="col-md-3">
                <div class="card text-white h-100" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3); border-radius: 15px;">
                    <div class="card-body d-flex flex-column justify-content-between">
                        <div>
                            <h6 class="card-title text-uppercase fw-light mb-2" style="letter-spacing: 1px;">Total Tasks</h6>
                            <h1 class="display-4 fw-bold mb-0"><%= myTasks.size() %></h1>
                        </div>
                        <div class="mt-3">
                            <i class="bi bi-list-task" style="font-size: 2rem; opacity: 0.3;"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white h-100" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); border: none; box-shadow: 0 8px 20px rgba(17, 153, 142, 0.3); border-radius: 15px;">
                    <div class="card-body d-flex flex-column justify-content-between">
                        <div>
                            <h6 class="card-title text-uppercase fw-light mb-2" style="letter-spacing: 1px;">Completed</h6>
                            <h1 class="display-4 fw-bold mb-0"><%= completedCount %></h1>
                        </div>
                        <div class="mt-3">
                            <i class="bi bi-check-circle" style="font-size: 2rem; opacity: 0.3;"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white h-100" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); border: none; box-shadow: 0 8px 20px rgba(240, 147, 251, 0.3); border-radius: 15px;">
                    <div class="card-body d-flex flex-column justify-content-between">
                        <div>
                            <h6 class="card-title text-uppercase fw-light mb-2" style="letter-spacing: 1px;">In Progress</h6>
                            <h1 class="display-4 fw-bold mb-0"><%= inProgressCount %></h1>
                        </div>
                        <div class="mt-3">
                            <i class="bi bi-hourglass-split" style="font-size: 2rem; opacity: 0.3;"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white h-100" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); border: none; box-shadow: 0 8px 20px rgba(79, 172, 254, 0.3); border-radius: 15px;">
                    <div class="card-body d-flex flex-column justify-content-between">
                        <div>
                            <h6 class="card-title text-uppercase fw-light mb-2" style="letter-spacing: 1px;">Pending</h6>
                            <h1 class="display-4 fw-bold mb-0"><%= pendingCount %></h1>
                        </div>
                        <div class="mt-3">
                            <i class="bi bi-clock-history" style="font-size: 2rem; opacity: 0.3;"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Give Feedback Form -->
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card" style="border: none; box-shadow: 0 4px 20px rgba(0,0,0,0.08); border-radius: 15px;">
                    <div class="card-header text-white" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 15px 15px 0 0; padding: 1.25rem;">
                        <h5 class="mb-0 fw-bold">💬 Give Feedback on Tasks</h5>
                    </div>
                    <div class="card-body p-4">
                        <form action="teammember" method="post">
                            <input type="hidden" name="action" value="giveFeedback">
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold text-secondary">Select Task</label>
                                    <select class="form-select" name="taskId" required style="border-radius: 10px; border: 2px solid #e2e8f0; padding: 0.75rem;">
                                        <option value="">Choose a task</option>
                                        <% for (Task task : myTasks) { %>
                                            <option value="<%= task.getTaskId() %>">
                                                <%= task.getTitle() %>
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold text-secondary">Your Feedback</label>
                                    <textarea class="form-control" name="feedbackText" rows="1" required style="border-radius: 10px; border: 2px solid #e2e8f0; padding: 0.75rem;"></textarea>
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">&nbsp;</label>
                                    <button type="submit" class="btn text-white w-100 fw-semibold" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; border-radius: 10px; padding: 0.75rem;">
                                        Submit
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- My Tasks Table -->
        <div class="card mb-4" style="border: none; box-shadow: 0 4px 20px rgba(0,0,0,0.08); border-radius: 15px;">
            <div class="card-header text-white" style="background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%); border-radius: 15px 15px 0 0; padding: 1.25rem;">
                <h5 class="mb-0 fw-bold">📋 My Assigned Tasks</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0" style="border-radius: 0 0 15px 15px; overflow: hidden;">
                        <thead style="background-color: #f8f9fa;">
                            <tr>
                                <th class="py-3 px-4 fw-semibold text-secondary" style="border: none;">ID</th>
                                <th class="py-3 px-4 fw-semibold text-secondary" style="border: none;">Title</th>
                                <th class="py-3 px-4 fw-semibold text-secondary" style="border: none;">Description</th>
                                <th class="py-3 px-4 fw-semibold text-secondary" style="border: none;">Priority</th>
                                <th class="py-3 px-4 fw-semibold text-secondary" style="border: none;">Status</th>
                                <th class="py-3 px-4 fw-semibold text-secondary" style="border: none;">Team</th>
                                <th class="py-3 px-4 fw-semibold text-secondary" style="border: none;">Start Date</th>
                                <th class="py-3 px-4 fw-semibold text-secondary" style="border: none;">Deadline</th>
                                <th class="py-3 px-4 fw-semibold text-secondary" style="border: none;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (myTasks.isEmpty()) { %>
                                <tr>
                                    <td colspan="9" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox" style="font-size: 3rem; opacity: 0.3;"></i>
                                        <p class="mt-3 mb-0">No tasks assigned yet</p>
                                    </td>
                                </tr>
                            <% } else { %>
                                <% for (Task task : myTasks) { %>
                                    <tr>
                                        <td class="py-3 px-4" style="border-color: #f1f5f9;"><%= task.getTaskId() %></td>
                                        <td class="py-3 px-4 fw-semibold" style="border-color: #f1f5f9;"><%= task.getTitle() %></td>
                                        <td class="py-3 px-4" style="border-color: #f1f5f9;"><%= task.getDescription() %></td>
                                        <td class="py-3 px-4" style="border-color: #f1f5f9;">
                                            <span class="badge" style="background: <%= getPriorityGradient(task.getPriority()) %>; padding: 0.5rem 1rem; border-radius: 8px; font-weight: 600;">
                                                <%= task.getPriority().toUpperCase() %>
                                            </span>
                                        </td>
                                        <td class="py-3 px-4" style="border-color: #f1f5f9;">
                                            <span class="badge" style="background: <%= getStatusGradient(task.getStatus()) %>; padding: 0.5rem 1rem; border-radius: 8px; font-weight: 600;">
                                                <%= task.getStatus().replace("_", " ").toUpperCase() %>
                                            </span>
                                        </td>
                                        <td class="py-3 px-4" style="border-color: #f1f5f9;"><%= task.getTeamName() != null ? task.getTeamName() : "No Team" %></td>
                                        <td class="py-3 px-4" style="border-color: #f1f5f9;"><%= task.getStartDate() %></td>
                                        <td class="py-3 px-4" style="border-color: #f1f5f9;"><%= task.getDeadline() %></td>
                                        <td class="py-3 px-4" style="border-color: #f1f5f9;">
                                            <% if (!"completed".equals(task.getStatus())) { %>
                                                <form action="teammember" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="completeTask">
                                                    <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                                                    <button type="submit" class="btn btn-sm text-white fw-semibold" 
                                                            style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); border: none; border-radius: 8px; padding: 0.5rem 1rem;"
                                                            onclick="return confirm('Mark this task as completed?')">
                                                        ✓ Complete
                                                    </button>
                                                </form>
                                            <% } else { %>
                                                <span style="color: #10b981; font-weight: 600;">✓ Completed</span>
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
        <div class="card mb-4" style="border: none; box-shadow: 0 4px 20px rgba(0,0,0,0.08); border-radius: 15px;">
            <div class="card-header text-white" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); border-radius: 15px 15px 0 0; padding: 1.25rem;">
                <h5 class="mb-0 fw-bold">💭 Recent Feedback</h5>
            </div>
            <div class="card-body p-4">
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
                    <div class="text-center py-4">
                        <i class="bi bi-chat-left-text" style="font-size: 3rem; opacity: 0.2; color: #667eea;"></i>
                        <p class="text-muted mt-3 mb-0">No feedback yet</p>
                    </div>
                <% } else { %>
                    <div class="row g-3">
                        <% for (Feedback feedback : myFeedback) { %>
                            <div class="col-12">
                                <div class="p-4" style="background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); border-radius: 12px; border-left: 4px solid #667eea;">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h6 class="mb-0 fw-bold text-dark"><%= feedback.getTaskTitle() %></h6>
                                        <small class="text-muted"><%= feedback.getCreatedAt() %></small>
                                    </div>
                                    <p class="mb-2 text-secondary"><%= feedback.getFeedbackText() %></p>
                                    <small class="text-muted">
                                        <span style="color: #667eea; font-weight: 600;">—</span> <%= feedback.getGivenByName() %>
                                    </small>
                                </div>
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
        
        String getPriorityGradient(String priority) {
            switch(priority.toLowerCase()) {
                case "critical": return "linear-gradient(135deg, #ef4444 0%, #dc2626 100%)";
                case "high": return "linear-gradient(135deg, #f59e0b 0%, #d97706 100%)";
                case "medium": return "linear-gradient(135deg, #3b82f6 0%, #2563eb 100%)";
                case "low": return "linear-gradient(135deg, #6b7280 0%, #4b5563 100%)";
                default: return "linear-gradient(135deg, #6b7280 0%, #4b5563 100%)";
            }
        }
        
        String getStatusGradient(String status) {
            switch(status.toLowerCase()) {
                case "completed": return "linear-gradient(135deg, #10b981 0%, #059669 100%)";
                case "in_progress": return "linear-gradient(135deg, #667eea 0%, #764ba2 100%)";
                case "pending": return "linear-gradient(135deg, #f59e0b 0%, #d97706 100%)";
                default: return "linear-gradient(135deg, #6b7280 0%, #4b5563 100%)";
            }
        }
    %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>