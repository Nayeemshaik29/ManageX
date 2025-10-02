package servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import daos.UserDAO;
import models.User;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        User user = userDAO.authenticate(username, password);
        
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("role", user.getRole());
            
            // Redirect based on role
            switch (user.getRole()) {
                case "admin":
                    response.sendRedirect("admin-dashboard.jsp");
                    break;
                case "team_leader":
                    response.sendRedirect("leader-dashboard.jsp");
                    break;
                case "team_member":
                    response.sendRedirect("member-dashboard.jsp");
                    break;
                default:
                    response.sendRedirect("login.jsp?error=invalid_role");
            }
        } else {
            response.sendRedirect("login.jsp?error=invalid_credentials");
        }
    }
}