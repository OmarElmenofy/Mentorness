1- SELECT P.P_ID, L.Dev_ID, P.PNAME, L.difficulty Difficulty_level
FROM Player_Details P
JOIN Level_Details L ON P.P_ID = L.P_ID
WHERE L.level= 0;
-----------

2-SELECT P.L1_code, Avg (L.kill_count) as avg_kill_count
FROM Player_Details P
JOIN Level_Details L ON P.P_ID = L.P_ID
WHERE L.lives_earned = 2 AND L.stages_crossed >= 3
GROUP BY P.L1_code;
-----------

3- SELECT  L.difficulty, SUM(L.stages_crossed) AS total_stages_crossed
FROM Level_Details L
JOIN Player_Details P ON L.P_ID = P.P_ID
WHERE L.Dev_ID LIKE 'zm%' AND L.level = 2 
GROUP BY L.difficulty
ORDER BY total_stages_crossed DESC;
-----------

4- SELECT P_ID, COUNT (DISTINCT(start_datetime)) as total_unique_dates
FROM Level_Details
GROUP BY P_ID
HAVING COUNT (DISTINCT(start_datetime)) > 1;
-----------

5- SELECT P_ID, level, SUM (kill_count) AS SUM_KILL_COUNT
FROM Level_Details
WHERE kill_count > (select AVG (kill_count) FROM Level_Details WHERE Difficulty = 'Medium')
GROUP BY P_ID, level;
-----------

6- SELECT L.level, P.L1_code, P.L2_code SUM (L.lives_earned) AS total_lives_earned
FROM Level_Details L
JOIN Player_Details P ON L.P_ID = P.P_ID
WHERE L.level NOT IN (0)
GROUP BY L.level, P.L1_code,P.L2_code
ORDER BY L.level ASC;
-----------

7- SELECT TOP 3 (score), Dev_ID, difficulty, ROW_NUMBER() OVER (PARTITION BY Dev_ID ORDER BY score DESC) AS ROWNUMBER
   FROM Level_Details
   GROUP BY Dev_ID, score, difficulty;  
-----------

8- SELECT DEV_ID , MIN (start_datetime) AS MIN_start_datetime
FROM Level_Details
GROUP BY DEV_ID;
-----------

9- WITH Ranked_difficulty AS (
       SELECT
              DEV_ID, score, difficulty, Rank () over ( partition by difficulty order by score DESC ) as Ranked
       FROM Level_Details)
   SELECT Dev_ID, Difficulty, score,Ranked
   FROM Ranked_difficulty
   WHERE Ranked < 6;
-----------

10- SELECT DEV_ID,P_ID, MIN (start_datetime) AS MIN_start_datetime
FROM Level_Details
GROUP BY  Dev_ID, P_ID;
-----------

11- >>>WINDOW FUNCTION :
SELECT 
    P_ID, 
    start_datetime, 
    SUM(Kill_Count) OVER (PARTITION BY P_ID, start_datetime ORDER BY start_datetime) AS total_kills   
FROM 
    Level_Details;

--- WITHOUT WINDOW FUNCTION :
SELECT 
    P_ID, 
    start_datetime, 
    SUM(Kill_Count) AS SUM_Kill_Count
FROM 
    Level_Details
GROUP BY P_ID, start_datetime
ORDER BY P_ID,start_datetime;
-----------

12- WITH NEW_TABLE AS (
    SELECT 
        P_ID, 
        Stages_crossed, 
        start_datetime, 
        ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY start_datetime DESC) AS RN 
    FROM 
        Level_Details
)

SELECT 
    P_ID,start_datetime,  
    SUM(Stages_crossed) AS cumulative_stages_crossed
FROM 
    NEW_TABLE 
WHERE 
    RN > 1 
GROUP BY 
    P_ID, start_datetime;
--------------

13- SELECT TOP 3 SUM (score) AS Highest_score, Dev_ID, P_ID
    FROM Level_Details
    GROUP BY Dev_ID,P_ID
    ORDER BY Highest_score DESC;
----------------

14- SELECT P_ID, SUM (score) AS SUM_Score
    FROM Level_Details
    GROUP BY P_ID
    HAVING SUM(score) > 0.5 * (SELECT AVG(score) FROM Level_Details)
--------------

15- CREATE PROCEDURE FindTopHeadshotsCount(
    @n INT
)
AS
BEGIN
    SET NOCOUNT ON;

    WITH RankedHeadshots AS (
        SELECT 
            L.Dev_ID,
            L.difficulty,
            L.headshots_count,
            ROW_NUMBER() OVER (PARTITION BY L.Dev_ID ORDER BY L.headshots_count ASC) AS RN
        FROM 
            Level_Details L
    )
    SELECT 
        Dev_ID,
        difficulty,
        headshots_count,
        RN
    FROM 
        RankedHeadshots
    WHERE 
        RN <= @n;
END;


