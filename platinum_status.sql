--Adding platinum status and filling out the conditions for if a customer has paid over $200 (TRUE) or not (FALSE)

ALTER TABLE customer
ADD COLUMN platinum BOOLEAN;

SELECT *
FROM customer

CREATE OR REPLACE PROCEDURE plat()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customer
	SET platinum = TRUE
	WHERE customer_id IN (
		SELECT customer_id
		FROM payment
		GROUP BY customer_id
		HAVING SUM(amount) > 200);
		
	UPDATE customer
	SET platinum = FALSE
	WHERE customer_id IN (
		SELECT customer_id
		FROM payment
		GROUP BY customer_id
		HAVING SUM(amount) < 200
		
);
COMMIT;
END;
$$

CALL plat();