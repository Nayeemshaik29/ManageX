package daos;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import models.Team;

public class TeamDAO {
    
    public boolean createTeam(String teamName, int leaderId) {
        String query = "INSERT INTO teams (team_name, leader_id) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, teamName);
            pstmt.setInt(2, leaderId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Team> getAllTeams() {
        List<Team> teams = new ArrayList<>();
        String query = "SELECT t.*, u.full_name as leader_name FROM teams t " +
                      "LEFT JOIN users u ON t.leader_id = u.user_id " +
                      "ORDER BY t.team_name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                Team team = new Team();
                team.setTeamId(rs.getInt("team_id"));
                team.setTeamName(rs.getString("team_name"));
                team.setLeaderId(rs.getInt("leader_id"));
                team.setLeaderName(rs.getString("leader_name"));
                teams.add(team);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return teams;
    }
    
    public List<Team> getTeamsByLeader(int leaderId) {
        List<Team> teams = new ArrayList<>();
        String query = "SELECT * FROM teams WHERE leader_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, leaderId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Team team = new Team();
                team.setTeamId(rs.getInt("team_id"));
                team.setTeamName(rs.getString("team_name"));
                team.setLeaderId(rs.getInt("leader_id"));
                teams.add(team);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return teams;
    }
    
    public boolean addMemberToTeam(int teamId, int memberId) {
        String query = "INSERT INTO team_members (team_id, member_id) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, teamId);
            pstmt.setInt(2, memberId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}