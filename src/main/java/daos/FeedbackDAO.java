package daos;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import models.Feedback;

public class FeedbackDAO {
    
    public boolean addFeedback(int taskId, int givenBy, String feedbackText) {
        String query = "INSERT INTO feedback (task_id, given_by, feedback_text) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, taskId);
            pstmt.setInt(2, givenBy);
            pstmt.setString(3, feedbackText);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Feedback> getFeedbackByTask(int taskId) {
        List<Feedback> feedbacks = new ArrayList<>();
        String query = "SELECT f.*, u.full_name as given_by_name, t.title as task_title " +
                      "FROM feedback f " +
                      "JOIN users u ON f.given_by = u.user_id " +
                      "JOIN tasks t ON f.task_id = t.task_id " +
                      "WHERE f.task_id = ? ORDER BY f.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, taskId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackId(rs.getInt("feedback_id"));
                feedback.setTaskId(rs.getInt("task_id"));
                feedback.setGivenBy(rs.getInt("given_by"));
                feedback.setFeedbackText(rs.getString("feedback_text"));
                feedback.setCreatedAt(rs.getTimestamp("created_at"));
                feedback.setGivenByName(rs.getString("given_by_name"));
                feedback.setTaskTitle(rs.getString("task_title"));
                feedbacks.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
    
    public List<Feedback> getAllFeedback() {
        List<Feedback> feedbacks = new ArrayList<>();
        String query = "SELECT f.*, u.full_name as given_by_name, t.title as task_title " +
                      "FROM feedback f " +
                      "JOIN users u ON f.given_by = u.user_id " +
                      "JOIN tasks t ON f.task_id = t.task_id " +
                      "ORDER BY f.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackId(rs.getInt("feedback_id"));
                feedback.setTaskId(rs.getInt("task_id"));
                feedback.setGivenBy(rs.getInt("given_by"));
                feedback.setFeedbackText(rs.getString("feedback_text"));
                feedback.setCreatedAt(rs.getTimestamp("created_at"));
                feedback.setGivenByName(rs.getString("given_by_name"));
                feedback.setTaskTitle(rs.getString("task_title"));
                feedbacks.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
}