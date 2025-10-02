package servlets;


import javax.servlet.ServletException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import daos.FeedbackDAO;
import daos.TaskDAO;

import java.io.IOException;

@WebServlet("/teammember")
public class TeamMemberServlet extends HttpServlet {
    private TaskDAO taskDAO;
    private FeedbackDAO feedbackDAO;
    
    @Override
    public void init() {
        taskDAO = new TaskDAO();
        feedbackDAO = new FeedbackDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        
        if (session == null || !"team_member".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        switch (action) {
            case "completeTask":
                completeTask(request, response);
                break;
            case "giveFeedback":
                giveFeedback(request, response, session);
                break;
            default:
                response.sendRedirect("member-dashboard.jsp");
        }
    }
    
    private void completeTask(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            
            if (taskDAO.completeTask(taskId)) {
                response.sendRedirect("member-dashboard.jsp?success=task_completed");
            } else {
                response.sendRedirect("member-dashboard.jsp?error=task_complete_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("member-dashboard.jsp?error=invalid_input");
        }
    }
    
    private void giveFeedback(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            String feedbackText = request.getParameter("feedbackText");
            int givenBy = (Integer) session.getAttribute("userId");
            
            if (feedbackDAO.addFeedback(taskId, givenBy, feedbackText)) {
                response.sendRedirect("member-dashboard.jsp?success=feedback_added");
            } else {
                response.sendRedirect("member-dashboard.jsp?error=feedback_add_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("member-dashboard.jsp?error=invalid_input");
        }
    }
}