<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Task Management System - Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body.login-page {
            background-image: url('https://png.pngtree.com/background/20250104/original/pngtree-task-management-business-planning-app-illustration-vector-picture-image_15392537.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .card { background-color: rgba(255, 255, 255, 0.95); border-radius: 15px; padding: 20px; }
        .animate-fade-in { animation: fadeIn 1s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
        h2 { font-weight: bold; }
    </style>
</head>
<body class="login-page">
    <div class="container">
        <div class="row justify-content-center align-items-center min-vh-100">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-lg animate-fade-in">
                    <div class="card-body p-5">
                        <div class="text-center mb-4">
                            <h2 class="mb-3">📝 Register</h2>
                            <p class="text-muted">Create your account</p>
                        </div>

                        <!-- Error messages -->
                        <% String error = request.getParameter("error"); %>
<% if (error != null) { %>
    <div class="alert alert-danger alert-dismissible fade show">
        <% if ("duplicate".equals(error)) { %>
            ⚠️ Username or Email already exists. Please try another.
        <% } else if ("insert_failed".equals(error)) { %>
            ❌ Registration failed. Please try again.
        <% } else if ("db_error".equals(error)) { %>
            ❌ Database error occurred. Contact admin.
        <% } else { %>
            ❌ Unknown error. Please try again.
        <% } %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } %>


                        <!-- Success message -->
                        <% if ("1".equals(request.getParameter("success"))) { %>
                            <div class="alert alert-success alert-dismissible fade show">
                                ✅ Registration successful! You can now 
                                <a href="login.jsp" class="text-success fw-bold">Login</a>.
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>

                        <!-- Registration Form -->
                        <form action="register" method="post">
                            <div class="mb-3">
                                <label for="fullName" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                            </div>
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            <div class="mb-3">
                                <label for="role" class="form-label">Role</label>
                                <select class="form-select" id="role" name="role" required>
                                    <option value="">-- Select Role --</option>
                                    <option value="admin">Admin</option>
                                    <option value="team_leader">Team Leader</option>
                                    <option value="team_member">Team Member</option>
                                </select>
                            </div>
                            <div class="mb-4">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-success w-100 mb-3">Register</button>
                        </form>

                        <p class="text-center mt-3">
                            Already have an account? 
                            <a href="login.jsp" class="btn btn-outline-primary btn-sm">Login here</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
