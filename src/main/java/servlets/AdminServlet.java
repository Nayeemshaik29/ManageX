package servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import daos.TaskDAO;
import daos.UserDAO;
import models.Task;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private TaskDAO taskDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() {
        taskDAO = new TaskDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        switch (action) {
            case "addTask":
                addTask(request, response, session);
                break;
            case "deleteTask":
                deleteTask(request, response);
                break;
            case "assignRole":
                assignRole(request, response);
                break;
            default:
                response.sendRedirect("admin-dashboard.jsp");
        }
    }
    
    private void addTask(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        try {
            Task task = new Task();
            task.setTitle(request.getParameter("title"));
            task.setDescription(request.getParameter("description"));

            // Priority - force lowercase to match ENUM
            String priority = request.getParameter("priority");
            if (priority != null) {
                task.setPriority(priority.toLowerCase());
            } else {
                task.setPriority("medium"); // default
            }

            // assignedTo
            String assignedToStr = request.getParameter("assignedTo");
            task.setAssignedTo((assignedToStr != null && !assignedToStr.isEmpty())
                    ? Integer.parseInt(assignedToStr) : 0);

            // teamId
            String teamIdStr = request.getParameter("teamId");
            task.setTeamId((teamIdStr != null && !teamIdStr.isEmpty())
                    ? Integer.parseInt(teamIdStr) : 0);

            // Dates
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");

            String startDateStr = request.getParameter("startDate");
            if (startDateStr != null && !startDateStr.isEmpty()) {
                java.util.Date parsed = sdf.parse(startDateStr);
                System.out.println(parsed);
                task.setStartDate(new java.sql.Date(parsed.getTime()));
            }

            String deadlineStr = request.getParameter("deadline");
            if (deadlineStr != null && !deadlineStr.isEmpty()) {
                java.util.Date parsed = sdf.parse(deadlineStr);
                task.setDeadline(new java.sql.Date(parsed.getTime()));
            }

            // created_by
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                response.sendRedirect("admin-dashboard.jsp?error=session_expired");
                return;
            }
            task.setCreatedBy(userId);

            if (taskDAO.addTask(task)) {
                response.sendRedirect("admin-dashboard.jsp?success=task_added");
            } else {
                response.sendRedirect("admin-dashboard.jsp?error=task_add_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-dashboard.jsp?error=invalid_input");
        }
    }



    private void deleteTask(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            
            if (taskDAO.deleteTask(taskId)) {
                response.sendRedirect("admin-dashboard.jsp?success=task_deleted");
            } else {
                response.sendRedirect("admin-dashboard.jsp?error=task_delete_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-dashboard.jsp?error=invalid_input");
        }
    }
    
    private void assignRole(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String newRole = request.getParameter("newRole");
            
            if (userDAO.updateUserRole(userId, newRole)) {
                response.sendRedirect("admin-dashboard.jsp?success=role_assigned");
            } else {
                response.sendRedirect("admin-dashboard.jsp?error=role_assign_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-dashboard.jsp?error=invalid_input");
        }
    }
}