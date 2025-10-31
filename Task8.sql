USE travel_agency;

DROP TABLE IF EXISTS loyalty_points;
 
 -- creating loyalty_points table
CREATE TABLE loyalty_points (
    loyalty_id INT AUTO_INCREMENT PRIMARY KEY,
    traveller_id INT,
    points INT DEFAULT 0,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (traveller_id) REFERENCES travellers(traveller_id)
);

-- Inserting sample data into the table
INSERT INTO loyalty_points (traveller_id, points) VALUES (1, 100);
INSERT INTO loyalty_points (traveller_id, points) VALUES (2, 150);
INSERT INTO loyalty_points (traveller_id, points) VALUES (3, 200);
INSERT INTO loyalty_points (traveller_id, points) VALUES (4, 120);
INSERT INTO loyalty_points (traveller_id, points) VALUES (5, 90);
SELECT * FROM loyalty_points;
-- creating add_loyalty_points stored procedure to give loyalty points to travellers
-- If traveller is not in table it also has condition to add new traveller and add points to them
DELIMITER $$

CREATE PROCEDURE add_loyalty_points(
    IN p_traveller_id INT,
    IN p_points INT
)
BEGIN
    IF EXISTS (SELECT 1 FROM loyalty_points WHERE traveller_id = p_traveller_id) THEN
        UPDATE loyalty_points 
        SET points = points + p_points,
            last_updated = CURRENT_TIMESTAMP
        WHERE traveller_id = p_traveller_id;
    ELSE
        INSERT INTO loyalty_points (traveller_id, points, last_updated)
        VALUES (p_traveller_id, p_points, CURRENT_TIMESTAMP);
    END IF;
END $$

DELIMITER ;

-- Adding points to existing traveller/ calling the stored procedure
CALL add_loyalty_points(1, 50);

-- Adding new traveller who isnt in loyalty points table
CALL add_loyalty_points(6, 120);


-- creating function to convert points to reward in rupees.
DELIMITER $$

CREATE FUNCTION get_reward_value(p_traveller_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE reward_value DECIMAL(10,2);
    DECLARE points_value INT;

    -- Get the traveller's points
    SELECT points INTO points_value
    FROM loyalty_points
    WHERE traveller_id = p_traveller_id;

    -- Convert to rupees (₹10 per point)
    SET reward_value = points_value * 10;

    RETURN reward_value;
END $$

DELIMITER ;

-- testing the function
SELECT traveller_id, points, get_reward_value(traveller_id) AS reward_in_inr
FROM loyalty_points;

-- Procedure with if-else condition to categorize traveller's membership based on points they earned
DELIMITER $$

CREATE PROCEDURE check_loyalty_status(
    IN p_traveller_id INT,
    OUT membership VARCHAR(50)
)
BEGIN
    DECLARE pts INT;

    SELECT points INTO pts
    FROM loyalty_points
    WHERE traveller_id = p_traveller_id;

    IF pts > 200 THEN
        SET membership = 'Gold Member';
    ELSEIF pts > 100 THEN
        SET membership = 'Silver Member';
    ELSE
        SET membership = 'Regular Member';
    END IF;
END $$

DELIMITER ;

-- testing the procedure
CALL check_loyalty_status(1, @result);
SELECT @result;

-- Stored procedure with loop to countdown days till the trip day comes
DELIMITER $$

CREATE PROCEDURE countdown_trip(IN start_day INT)
BEGIN
    DECLARE day INT;

    SET day = start_day;

    countdown_loop: LOOP
        IF day = 0 THEN
            SELECT 'Trip Day! Have fun!' AS message;
            LEAVE countdown_loop;
        END IF;

        SELECT CONCAT('Only ', day, ' days left for your trip!') AS message;

        SET day = day - 1;
    END LOOP;
END $$

DELIMITER ;

CALL countdown_trip(5);


-- Function with if condition to categorize travellers based on budgets
DELIMITER $$

CREATE FUNCTION traveller_budget_category(p_traveller_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE traveller_budget INT;

    -- Get the traveller's budget from the table
    SELECT budget_inr INTO traveller_budget
    FROM travellers
    WHERE traveller_id = p_traveller_id;

    -- Decide category based on budget
    IF traveller_budget >= 50000 THEN
        RETURN 'Luxury Traveller';
    ELSEIF traveller_budget >= 20000 THEN
        RETURN 'Comfort Traveller';
    ELSE
        RETURN 'Budget Traveller';
    END IF;
END $$

DELIMITER ;

-- Testing the function
SELECT traveller_id, budget_inr, traveller_budget_category(traveller_id) AS category
FROM travellers;
