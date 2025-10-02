package daos;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import models.Task;

public class TaskDAO {
    
	public boolean addTask(Task task) {
	    String query = "INSERT INTO tasks (title, description, priority, assigned_to, team_id, " +
	                   "start_date, deadline, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
	    
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(query)) {
	        
	        pstmt.setString(1, task.getTitle());
	        pstmt.setString(2, task.getDescription());
	        pstmt.setString(3, task.getPriority());

	        // assigned_to
	        if (task.getAssignedTo() > 0) {
	            pstmt.setInt(4, task.getAssignedTo());
	        } else {
	            pstmt.setNull(4, java.sql.Types.INTEGER);
	        }

	        // team_id
	        if (task.getTeamId() > 0) {
	            pstmt.setInt(5, task.getTeamId());
	        } else {
	            pstmt.setNull(5, java.sql.Types.INTEGER);
	        }

	        // start_date
	        if (task.getStartDate() != null) {
	            pstmt.setDate(6, task.getStartDate());
	        } else {
	            pstmt.setNull(6, java.sql.Types.DATE);
	        }

	        // deadline
	        if (task.getDeadline() != null) {
	            pstmt.setDate(7, task.getDeadline());
	        } else {
	            pstmt.setNull(7, java.sql.Types.DATE);
	        }

	        pstmt.setInt(8, task.getCreatedBy());

	        return pstmt.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}
    
    public List<Task> getAllTasks() {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT t.*, u.full_name as assigned_name, tm.team_name " +
                      "FROM tasks t " +
                      "LEFT JOIN users u ON t.assigned_to = u.user_id " +
                      "LEFT JOIN teams tm ON t.team_id = tm.team_id " +
                      "ORDER BY t.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                tasks.add(extractTaskFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }
    
    public List<Task> getTasksByTeamId(int teamId) {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT t.*, u.full_name as assigned_name, tm.team_name " +
                      "FROM tasks t " +
                      "LEFT JOIN users u ON t.assigned_to = u.user_id " +
                      "LEFT JOIN teams tm ON t.team_id = tm.team_id " +
                      "WHERE t.team_id = ? ORDER BY t.deadline";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, teamId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                tasks.add(extractTaskFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }
    
    public List<Task> getTasksByUserId(int userId) {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT t.*, u.full_name as assigned_name, tm.team_name " +
                      "FROM tasks t " +
                      "LEFT JOIN users u ON t.assigned_to = u.user_id " +
                      "LEFT JOIN teams tm ON t.team_id = tm.team_id " +
                      "WHERE t.assigned_to = ? ORDER BY t.deadline";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                tasks.add(extractTaskFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }
    
    public boolean updateTaskPriority(int taskId, String priority) {
        String query = "UPDATE tasks SET priority = ? WHERE task_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, priority);
            pstmt.setInt(2, taskId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateTaskDates(int taskId, Date startDate, Date deadline) {
        String query = "UPDATE tasks SET start_date = ?, deadline = ? WHERE task_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setDate(1, startDate);
            pstmt.setDate(2, deadline);
            pstmt.setInt(3, taskId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean completeTask(int taskId) {
        String query = "UPDATE tasks SET status = 'completed', completed_at = NOW() WHERE task_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, taskId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteTask(int taskId) {
        String query = "DELETE FROM tasks WHERE task_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, taskId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Task extractTaskFromResultSet(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setTaskId(rs.getInt("task_id"));
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));
        task.setPriority(rs.getString("priority"));
        task.setStatus(rs.getString("status"));
        task.setAssignedTo(rs.getInt("assigned_to"));
        task.setTeamId(rs.getInt("team_id"));
        task.setStartDate(rs.getDate("start_date"));
        task.setDeadline(rs.getDate("deadline"));
        task.setCreatedBy(rs.getInt("created_by"));
        task.setAssignedToName(rs.getString("assigned_name"));
        task.setTeamName(rs.getString("team_name"));
        return task;
    }

	
}