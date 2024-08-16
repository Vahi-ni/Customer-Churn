-- select all data from table
SELECT *
FROM customer_churn;
-- understand table columns and data types
DESCRIBE customer_churn;
-- gives the total number of customer cases
SELECT COUNT(*) FROM customer_churn;
-- handling missing values
SELECT 
    COLUMN_NAME, 
    (SELECT COUNT(*) FROM customer_churn WHERE `COLUMN_NAME` IS NULL) AS null_count
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_SCHEMA = 'finalproject'
    AND TABLE_NAME = 'customer_churn';
    
 -- summary statistics
 SELECT
    COUNT(*) AS `total_customers`,
    AVG(`Age`) AS `avg_age`,
    AVG(`Monthly Charge`) AS `avg_monthly_charge`,
    MAX(`Total Charges`) AS `max_total_charges`,
    MIN(`Total Charges`) AS `min_total_charges`
FROM `customer_churn`;


-- 1. find total no of customers and churn rate
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN `CustomerStatus` = 'Churned' THEN 1 ELSE 0 END) AS total_churned,
    (SUM(CASE WHEN `CustomerStatus` = 'Churned' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate
FROM 
    `customer_churn`;
    -- 2. avg age of churned customers
    SELECT 
    AVG(`Age`) AS avg_age_churned
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned';
    -- 3. Most common contract types among churned customers
    SELECT 
    `Contract`, 
    COUNT(*) AS count
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned'
GROUP BY 
    `Contract`
ORDER BY 
    count DESC
LIMIT 1;
-- 4. Analyze the distribution of monthly charges among churned customers
SELECT 
    `Monthly Charge`,
    COUNT(*) AS count
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned'
GROUP BY 
    `Monthly Charge`
ORDER BY 
    `Monthly Charge`;
  -- 5. Create a query to identify the contract types that are most prone to churn
SELECT 
    c.`Contract`,
    COUNT(*) AS `churned_count`,
    (COUNT(*) * 100.0 / total_counts.`total_count`) AS `churn_rate`
FROM 
    `finalproject`.`customer_churn` c
JOIN (
    SELECT 
        `Contract`, 
        COUNT(*) AS `total_count`
    FROM 
        `finalproject`.`customer_churn`
    GROUP BY 
        `Contract`
) AS total_counts
ON c.`Contract` = total_counts.`Contract`
WHERE 
    c.`CustomerStatus` = 'Churned'
GROUP BY 
    c.`Contract`, total_counts.`total_count`
ORDER BY 
    `churn_rate` DESC;


    -- 6. Identify customers with high total charges who have churned
    SELECT 
    `Customer ID`, 
    `Total Charges`
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned'
ORDER BY 
    `Total Charges` DESC
LIMIT 10;
-- 7. Calculate the total charges distribution for churned and non-churned customers
SELECT 
    `CustomerStatus`,
    COUNT(*) AS count,
    AVG(`Total Charges`) AS avg_total_charges,
    MIN(`Total Charges`) AS min_total_charges,
    MAX(`Total Charges`) AS max_total_charges
FROM 
    `customer_churn`
GROUP BY 
    `CustomerStatus`;
    -- 8. Calculate the average monthly charges for different contract types among churned customers
    SELECT 
    `Contract`,
    AVG(`Monthly Charge`) AS avg_monthly_charge
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned'
GROUP BY 
    `Contract`;
    -- 9. Identify customers who have both online security and online backup services and have not churned
    SELECT 
    `Customer ID`
FROM 
    `customer_churn`
WHERE 
    `Online Security` = 'Yes' 
    AND `Online Backup` = 'Yes' 
    AND `CustomerStatus` != 'Churned';
    -- 10. Determine the most common combinations of services among churned customers:
    SELECT 
    `Online Security`, 
    `Online Backup`, 
    `Device Protection Plan`, 
    `Premium Tech Support`, 
    `Streaming TV`, 
    `Streaming Movies`, 
    `Streaming Music`, 
    COUNT(*) AS count
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned'
GROUP BY 
    `Online Security`, `Online Backup`, `Device Protection Plan`, `Premium Tech Support`, 
    `Streaming TV`, `Streaming Movies`, `Streaming Music`
ORDER BY 
    count DESC
LIMIT 5;
-- 11. Identify the average total charges for customers grouped by gender and marital status
SELECT 
    `Gender`, 
    `Married`, 
    AVG(`Total Charges`) AS avg_total_charges
FROM 
    `customer_churn`
GROUP BY 
    `Gender`, `Married`;
-- 12. Calculate the average monthly charges for different age groups among churned customers
    SELECT 
    CASE 
        WHEN `Age` < 30 THEN 'Under 30'
        WHEN `Age` BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS age_group,
    AVG(`Monthly Charge`) AS avg_monthly_charge
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned'
GROUP BY 
    age_group;
-- 13. Determine the average age and total charges for customers with multiple lines and online backup:
SELECT 
    AVG(`Age`) AS avg_age,
    AVG(`Total Charges`) AS avg_total_charges
FROM 
    `customer_churn`
WHERE 
    `Multiple Lines` = 'Yes' 
    AND `Online Backup` = 'Yes';
-- 14. Identify the contract types with the highest churn rate among senior citizens (age 65 and over)
SELECT 
    `Contract`,
    COUNT(*) AS churned_count,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM `customer_churn` WHERE `Contract` = c.`Contract` AND `Age` >= 65)) AS churn_rate
FROM 
    `customer_churn` c
WHERE 
    `CustomerStatus` = 'Churned'
    AND `Age` >= 65
GROUP BY 
    `Contract`
ORDER BY 
    churn_rate DESC;
    -- 15. Calculate the average monthly charges for customers who have multiple lines and streaming TV
    SELECT 
    AVG(`Monthly Charge`) AS avg_monthly_charge
FROM 
    `customer_churn`
WHERE 
    `Multiple Lines` = 'Yes' 
    AND `Streaming TV` = 'Yes';
-- 16. Identify the customers who have churned and used the most online services
SELECT 
    `Customer ID`,
    (`Online Security` = 'Yes') + (`Online Backup` = 'Yes') + (`Device Protection Plan` = 'Yes') + 
    (`Premium Tech Support` = 'Yes') + (`Streaming TV` = 'Yes') + (`Streaming Movies` = 'Yes') + 
    (`Streaming Music` = 'Yes') AS online_services_count
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned'
ORDER BY 
    online_services_count DESC
LIMIT 10;
-- 17. Calculate the average age and total charges for customers with different combinations of streaming services
SELECT 
    `Streaming TV`, 
    `Streaming Movies`, 
    `Streaming Music`, 
    AVG(`Age`) AS avg_age,
    AVG(`Total Charges`) AS avg_total_charges
FROM 
    `customer_churn`
GROUP BY 
    `Streaming TV`, `Streaming Movies`, `Streaming Music`;
-- 18. Identify the gender distribution among customers who have churned and are on yearly contracts
SELECT 
    `Gender`, 
    COUNT(*) AS count
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned'
    AND `Contract` IN ('One Year', 'Two Year')
GROUP BY 
    `Gender`;
-- 19. Calculate the average monthly charges and total charges for customers who have churned, grouped by contract type and internet service type
SELECT 
    `Contract`, 
    `Internet Service`,
    AVG(`Monthly Charge`) AS avg_monthly_charge,
    AVG(`Total Charges`) AS avg_total_charges
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned'
GROUP BY 
    `Contract`, `Internet Service`;
-- 20. Find the customers who have churned and are not using online services, and their average total charges:
 SELECT 
    `Customer ID`, 
    `Total Charges`
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned'
    AND `Online Security` = 'No'
    AND `Online Backup` = 'No'
    AND `Streaming TV` = 'No'
    AND `Streaming Movies` = 'No'
    AND `Streaming Music` = 'No';
-- 21. Calculate the average monthly charges and total charges for customers who have churned, grouped by the number of dependents:
SELECT 
    `Number of Dependents`,
    AVG(`Monthly Charge`) AS avg_monthly_charge,
    AVG(`Total Charges`) AS avg_total_charges
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned'
GROUP BY 
    `Number of Dependents`;
-- 22. Identify the customers who have churned, and their contract duration in months (for monthly contracts)
SELECT 
    `Customer ID`,
    `Tenure in Months`
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned'
    AND `Contract` = 'Month-to-Month';
-- 23. Determine the average age and total charges for customers who have churned, grouped by internet service and phone service
SELECT 
    `Internet Service`, 
    `Phone Service`, 
    AVG(`Age`) AS avg_age,
    AVG(`Total Charges`) AS avg_total_charges
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned'
GROUP BY 
    `Internet Service`, `Phone Service`;
-- 24. Create a view to find the customers with the highest monthly charges in each contract type
CREATE VIEW `highest_monthly_charges_per_contract` AS
SELECT 
    c.`Customer ID`, 
    c.`Contract`, 
    c.`Monthly Charge`
FROM 
    `customer_churn` c
JOIN 
    (
        SELECT 
            `Contract`, 
            MAX(`Monthly Charge`) AS max_monthly_charge
        FROM 
            `customer_churn`
        GROUP BY 
            `Contract`
    ) mc
ON 
    c.`Contract` = mc.`Contract` 
    AND c.`Monthly Charge` = mc.max_monthly_charge;
SELECT * FROM `highest_monthly_charges_per_contract`;

-- 25. Create a view to identify customers who have churned and the average monthly charges compared to the overall average
CREATE VIEW churned_vs_overall_avg AS
SELECT 
    `Customer ID`, 
    `Monthly Charge`, 
    (SELECT AVG(`Monthly Charge`) FROM `customer_churn`) AS overall_avg_monthly_charge
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned';
    SELECT * FROM `churned_vs_overall_avg`;

-- 26. Create a view to find the customers who have churned and their cumulative total charges over time
CREATE VIEW churned_cumulative_total_charges AS
SELECT 
    `Customer ID`, 
    `Tenure in Months`,
    SUM(`Total Charges`) OVER (ORDER BY `Tenure in Months` ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_total_charges
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned';
    SELECT * FROM `churned_cumulative_total_charges`;
-- 27. CREATE PROCEDURE calculate_churn_rate()
CREATE VIEW `churned_customers_cumulative_charges` AS
SELECT 
    `Customer ID`, 
    `Total Charges`, 
    SUM(`Total Charges`) OVER (ORDER BY `Customer ID`) AS `Cumulative Total Charges`
FROM 
    `customer_churn`
WHERE 
    `CustomerStatus` = 'Churned';
SELECT * FROM `churned_customers_cumulative_charges`;

-- 28. CREATE PROCEDURE high_value_at_risk_customers()
DELIMITER //

CREATE PROCEDURE `Calculate_Churn_Rate` ()
BEGIN
    DECLARE total_customers INT;
    DECLARE churned_customers INT;
    DECLARE churn_rate DECIMAL(5, 2);
    
    -- Calculate the total number of customers
    SELECT COUNT(*) INTO total_customers FROM `customer_churn`;
    
    -- Calculate the number of churned customers
    SELECT COUNT(*) INTO churned_customers FROM `customer_churn` WHERE `CustomerStatus` = 'Churned';
    
    -- Calculate the churn rate
    IF total_customers > 0 THEN
        SET churn_rate = (churned_customers / total_customers) * 100;
    ELSE
        SET churn_rate = 0;
    END IF;
    
    -- Return the churn rate as a result set
    SELECT churn_rate AS `Churn Rate (%)`, churned_customers AS `Churned Customers`, total_customers AS `Total Customers`;
END //

DELIMITER ;
CALL `Calculate_Churn_Rate` ();

