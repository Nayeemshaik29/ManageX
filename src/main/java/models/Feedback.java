package models;

import java.sql.Timestamp;

public class Feedback {
    private int feedbackId;
    private int taskId;
    private int givenBy;
    private String feedbackText;
    private Timestamp createdAt;
    private String givenByName;
    private String taskTitle;
    
    // Constructors
    public Feedback() {}
    
    // Getters and Setters
    public int getFeedbackId() { return feedbackId; }
    public void setFeedbackId(int feedbackId) { this.feedbackId = feedbackId; }
    
    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }
    
    public int getGivenBy() { return givenBy; }
    public void setGivenBy(int givenBy) { this.givenBy = givenBy; }
    
    public String getFeedbackText() { return feedbackText; }
    public void setFeedbackText(String feedbackText) { this.feedbackText = feedbackText; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getGivenByName() { return givenByName; }
    public void setGivenByName(String givenByName) { this.givenByName = givenByName; }
    
    public String getTaskTitle() { return taskTitle; }
    public void setTaskTitle(String taskTitle) { this.taskTitle = taskTitle; }
}