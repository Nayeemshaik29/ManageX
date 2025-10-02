<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Management System - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Full page background */
        body.login-page {
            background-image: url('https://plus.unsplash.com/premium_vector-1697729510037-b7f652020cb1?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZGVza3RvcCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Card styling */
        .card {
            background-color: rgba(255, 255, 255, 0.95); /* Slight transparency for readability */
            border-radius: 15px;
            padding: 20px;
        }

        .animate-fade-in {
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 {
            font-weight: bold;
        }

        /* Smaller card for test credentials */
        .card.bg-light {
            background-color: rgba(240, 240, 240, 0.9) !important;
        }
    </style>
</head>
<body class="login-page">
    <div class="container">
        <div class="row justify-content-center align-items-center min-vh-100">
            <div class="col-md-5">
                <div class="card shadow-lg animate-fade-in">
                    <div class="card-body p-5">
                        <div class="text-center mb-4">
                            <h2 class="mb-3">🎯 Task Manager</h2>
                            <p class="text-muted">Sign in to continue</p>
                        </div>
                        
                        <% if (request.getParameter("error") != null) { %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <% if ("invalid_credentials".equals(request.getParameter("error"))) { %>
                                    Invalid username or password!
                                <% } else { %>
                                    An error occurred. Please try again.
                                <% } %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>
                        
                        <% if (request.getParameter("message") != null) { %>
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                You have been logged out successfully!
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>
                        
                        <form action="login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required autofocus>
                            </div>
                            <div class="mb-4">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 mb-3">Login</button>
                        </form>
                        
                        <!-- Link to Register -->
                        <p class="text-center mt-3">
                            Don't have an account? 
                            <a href="register.jsp" class="btn btn-outline-success btn-sm">Register here</a>
                        </p>
                        
                        <div class="card bg-light mt-4 p-3">
                            <div class="card-body">
                                <h6 class="card-title">Test Credentials:</h6>
                                <small>
                                    <strong>Admin:</strong> admin / password123<br>
                                    <strong>Team Leader:</strong> leader1 / password123<br>
                                    <strong>Team Member:</strong> member1 / password123
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
