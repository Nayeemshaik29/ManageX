package servlets;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import daos.FeedbackDAO;
import daos.TaskDAO;
import daos.TeamDAO;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/teamleader")
public class TeamLeaderServlet extends HttpServlet {
    private TaskDAO taskDAO;
    private TeamDAO teamDAO;
    private FeedbackDAO feedbackDAO;
    
    @Override
    public void init() {
        taskDAO = new TaskDAO();
        teamDAO = new TeamDAO();
        feedbackDAO = new FeedbackDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        
        if (session == null || !"team_leader".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        switch (action) {
            case "createTeam":
                createTeam(request, response, session);
                break;
            case "setPriority":
                setPriority(request, response);
                break;
            case "setDates":
                setDates(request, response);
                break;
            case "giveFeedback":
                giveFeedback(request, response, session);
                break;
            case "addMember":
                addMember(request, response);
                break;
            default:
                response.sendRedirect("leader-dashboard.jsp");
        }
    }
    
    private void createTeam(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        try {
            String teamName = request.getParameter("teamName");
            int leaderId = (Integer) session.getAttribute("userId");
            
            if (teamDAO.createTeam(teamName, leaderId)) {
                response.sendRedirect("leader-dashboard.jsp?success=team_created");
            } else {
                response.sendRedirect("leader-dashboard.jsp?error=team_create_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("leader-dashboard.jsp?error=invalid_input");
        }
    }
    
    private void setPriority(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            String priority = request.getParameter("priority");
            
            if (taskDAO.updateTaskPriority(taskId, priority)) {
                response.sendRedirect("leader-dashboard.jsp?success=priority_updated");
            } else {
                response.sendRedirect("leader-dashboard.jsp?error=priority_update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("leader-dashboard.jsp?error=invalid_input");
        }
    }
    
    private void setDates(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            Date startDate = Date.valueOf(request.getParameter("startDate"));
            Date deadline = Date.valueOf(request.getParameter("deadline"));
            
            if (taskDAO.updateTaskDates(taskId, startDate, deadline)) {
                response.sendRedirect("leader-dashboard.jsp?success=dates_updated");
            } else {
                response.sendRedirect("leader-dashboard.jsp?error=dates_update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("leader-dashboard.jsp?error=invalid_input");
        }
    }
    
    private void giveFeedback(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            String feedbackText = request.getParameter("feedbackText");
            int givenBy = (Integer) session.getAttribute("userId");
            
            if (feedbackDAO.addFeedback(taskId, givenBy, feedbackText)) {
                response.sendRedirect("leader-dashboard.jsp?success=feedback_added");
            } else {
                response.sendRedirect("leader-dashboard.jsp?error=feedback_add_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("leader-dashboard.jsp?error=invalid_input");
        }
    }
    
    private void addMember(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int teamId = Integer.parseInt(request.getParameter("teamId"));
            int memberId = Integer.parseInt(request.getParameter("memberId"));
            
            if (teamDAO.addMemberToTeam(teamId, memberId)) {
                response.sendRedirect("leader-dashboard.jsp?success=member_added");
            } else {
                response.sendRedirect("leader-dashboard.jsp?error=member_add_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("leader-dashboard.jsp?error=invalid_input");
        }
    }
}