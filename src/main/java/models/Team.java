package models;

public class Team {
    private int teamId;
    private String teamName;
    private int leaderId;
    private String leaderName;
    
    // Constructors
    public Team() {}
    
    public Team(int teamId, String teamName, int leaderId) {
        this.teamId = teamId;
        this.teamName = teamName;
        this.leaderId = leaderId;
    }
    
    // Getters and Setters
    public int getTeamId() { return teamId; }
    public void setTeamId(int teamId) { this.teamId = teamId; }
    
    public String getTeamName() { return teamName; }
    public void setTeamName(String teamName) { this.teamName = teamName; }
    
    public int getLeaderId() { return leaderId; }
    public void setLeaderId(int leaderId) { this.leaderId = leaderId; }
    
    public String getLeaderName() { return leaderName; }
    public void setLeaderName(String leaderName) { this.leaderName = leaderName; }
}