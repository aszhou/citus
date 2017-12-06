-- CTE cannot be outside of FROM/WHERE clause
WITH cte_basic AS (
	SELECT * FROM users_table
)
SELECT cte_basic, user_id FROM users_table;


WITH cte_1 AS (
	WITH cte_1_1 AS (
		SELECT * FROM users_table
	),
	cte_1_2 AS (
		SELECT cte_1_1
	)
	SELECT user_id FROM cte_1_2
)
SELECT * FROM users_table WHERE user_id IN (SELECT * FROM cte_1);


-- CTE in FROM/WHERE is usable
WITH cte_1 AS (
	WITH cte_1_1 AS (
		SELECT * FROM users_table WHERE value_2 IN (1, 2, 3)
	)
	SELECT user_id, value_2 FROM users_table WHERE user_id IN (
		SELECT user_id FROM cte_1_1
	)
)
SELECT * FROM cte_1 WHERE value_2 NOT IN (SELECT value_2 FROM cte_1);

WITH cte_1 AS (
	WITH cte_1_1 AS (
		SELECT * FROM users_table WHERE value_2 IN (1, 2, 3)
	)
	SELECT user_id, value_2 FROM users_table WHERE user_id IN (
		SELECT user_id FROM cte_1_1
	)
)
SELECT * FROM cte_1 WHERE value_2 IN (
		SELECT 
			value_2 
		FROM 
			cte_1 
		WHERE 
			user_id IN (2, 3, 4) 
		ORDER BY 
			1 
		LIMIT 
			10
	)
ORDER BY 
	1, 2 
LIMIT 
	10;


-- the same CTEs in FROM and WHERE
SELECT * FROM 
(
	WITH cte AS (
		SELECT user_id, value_2 FROM users_table
	)
	SELECT * FROM cte WHERE value_2 IN (SELECT user_id FROM cte)
) ctes
ORDER BY 
	1, 2
LIMIT 10;


-- two different CTEs in FROM and WHERE
SELECT * FROM 
(
	WITH cte_from AS (
		SELECT user_id, value_2 FROM users_table
	),
	cte_where AS (
		SELECT value_2 FROM events_table
	)
	SELECT * FROM cte_from WHERE value_2 IN (SELECT * FROM cte_where)
) binded_ctes
ORDER BY 
	1, 2
LIMIT 10;


SELECT * FROM 
(
	WITH cte_from AS (
		SELECT user_id, value_2 FROM users_table
	),
	cte_where AS (
		SELECT value_2 FROM events_table-- WHERE user_id in (SELECT user_id FROM cte_from)
	)
	SELECT * FROM cte_from WHERE value_2 IN (SELECT * FROM cte_where)
) binded_ctes
WHERE binded_ctes.user_id IN (
	WITH another_cte AS (
		SELECT user_id FROM events_table WHERE value_2 IN (1, 2, 3)
	)
	SELECT * FROM another_cte
)
ORDER BY
	1, 2
LIMIT
	10;