# Average Turn Around Time
SELECT MONTH(Submission_Date) AS Month, AVG(Turnaround_Days) As Average_Intake
FROM Mock_Grading_Operations
GROUP BY MONTH(Submission_Date)

SELECT AVG(Turnaround_Days) As Turnaround
FROM Mock_Grading_Operations

# TAT by Service Level
SELECT Service_Level, AVG(Turnaround_Days) As Turn_around_by_service
FROM Mock_Grading_Operations
GROUP BY Service_Level

# Peak Submission Periods by Service Level
SELECT Service_Level, MONTH(Submission_Date) AS Month, COUNT(*) AS Submissions 
FROM Mock_Grading_Operations
GROUP BY Service_Level, MONTH(Submission_Date)

# Error Rate
SELECT ROUND((SUM(CAST(Error AS FLOAT)) / COUNT(*)) * 100, 2) As Error_Rate
FROM Mock_Grading_Operations

# Error Rate by Service Level 
SELECT Service_Level,
ROUND((SUM(CAST(Error AS FLOAT)) / COUNT(*)) * 100, 2) As Error_Rate
FROM Mock_Grading_Operations
GROUP BY Service_Level

# Average Feedback Score
SELECT AVG(Customer_Feedback_Score) AS Average_Feedback_Score
FROM Mock_Grading_Operations

# Top Customer Submission
SELECT Customer_ID, COUNT(*) AS Total_submissions
FROM Mock_Grading_Operations
GROUP BY Customer_ID
ORDER BY Total_submissions DESC


# Feedback vs. TAT Buckets
SELECT 
  CASE 
    WHEN Turnaround_Days <= 7 THEN '0-7 days'
    WHEN Turnaround_Days BETWEEN 8 AND 14 THEN '8-14 days'
    ELSE '15+ days'
  END AS TAT_Bucket,
  AVG(Customer_Feedback_Score) AS Avg_Feedback
FROM Mock_Grading_Operations
GROUP BY 
  CASE 
    WHEN Turnaround_Days <= 7 THEN '0-7 days'
    WHEN Turnaround_Days BETWEEN 8 AND 14 THEN '8-14 days'
    ELSE '15+ days'
  END
ORDER BY TAT_Bucket;

# Feedback vs. TAT Buckets based on Service Level
SELECT 
  CASE 
    WHEN Turnaround_Days <= 7 THEN '0-7 days'
    WHEN Turnaround_Days BETWEEN 8 AND 14 THEN '8-14 days'
    ELSE '15+ days'
  END AS TAT_Bucket,
  Service_Level,
  AVG(Customer_Feedback_Score) AS Avg_Feedback
FROM Mock_Grading_Operations
GROUP BY 
  CASE 
    WHEN Turnaround_Days <= 7 THEN '0-7 days'
    WHEN Turnaround_Days BETWEEN 8 AND 14 THEN '8-14 days'
    ELSE '15+ days'
  END
  , Service_Level
ORDER BY TAT_Bucket;

# Error Rate vs. Service Level Over Time
SELECT 
  FORMAT(Submission_Date, 'yyyy-MM') AS Month,
  Service_Level,
  ROUND((SUM(CAST(Error AS FLOAT)) / COUNT(*)) * 100, 2) AS Error_Rate_Percent
FROM Mock_Grading_Operations
GROUP BY FORMAT(Submission_Date, 'yyyy-MM'), Service_Level
ORDER BY Month, Service_Level;

# Revenue Opportunity
SELECT 
  Service_Level,
  COUNT(*) AS Total_Submissions,
  SUM(Total_Grading_Fee) AS Total_Revenue,
  ROUND(SUM(Total_Grading_Fee) * 1.0 / (SELECT SUM(Total_Grading_Fee) FROM Mock_Grading_Operations) * 100, 2) AS Revenue_Share_Percent
FROM Mock_Grading_Operations
GROUP BY Service_Level
ORDER BY Total_Revenue DESC;

# Identify Bottlenecks During Peak Periods
SELECT 
  FORMAT(Submission_Date, 'yyyy-MM') AS Month,
  COUNT(*) AS Submission_Volume,
  ROUND((SUM(CAST(Error AS FLOAT)) / COUNT(*)) * 100, 2) AS Error_Rate_Percent
FROM Mock_Grading_Operations
GROUP BY FORMAT(Submission_Date, 'yyyy-MM')
ORDER BY Month;

# Total Revenue
SELECT SUM(Total_Grading_Fee) As Total_Revenue
FROM Mock_Grading_Operations
