/*Please add ; after each select statement*/
CREATE PROCEDURE alarmClocks()
BEGIN
    SELECT input_date, DATE(input_date), DAYOFYEAR(DATE(input_date)), (DAYOFYEAR(input_date) % 7), CONCAT(YEAR(input_date), '-01-01'), TIME(input_date)
    INTO @input_date, @input_date_day, @day_year, @day_mod, @start_year, @time_input
    FROM userInput;

    SELECT 
        dataDays.alarm_date
        -- dataDays.n,
        -- only_date,
        -- @input_date_day,
        -- @day_year
    FROM (SELECT
        days.n,
        -- @start_year,
        ADDDATE(@start_year, INTERVAL days.n DAY) as only_date,
        ADDTIME(ADDDATE(@start_year, INTERVAL days.n DAY), @time_input) as alarm_date
    FROM (
        SELECT 
            a.N + b.N * 10 + c.N * 100 AS n
        FROM
            (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
           ,(SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
           ,(SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) c
        -- ORDER BY n
    ) days
    WHERE 
        (days.n = (@day_year-1) AND YEAR(ADDDATE(@start_year, INTERVAL days.n DAY)) = YEAR(@start_year)) OR (
            days.n >= @day_year AND days.n < 366 AND YEAR(ADDDATE(@start_year, INTERVAL days.n DAY)) = YEAR(@start_year) AND 
            ( DAYOFYEAR(ADDDATE(@start_year, INTERVAL days.n DAY)) % 7 = @day_mod -- OR 
              -- DATE(ADDDATE(@input_date, INTERVAL days.n DAY)) = DATE(@input_date_day)
            )
        )
    ) dataDays
    ORDER BY 
        dataDays.alarm_date;
END