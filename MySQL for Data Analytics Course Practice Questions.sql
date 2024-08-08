# MySQL for Data Analytics Course

# PRACTICE QUESTIONS

# Querying Basics ------

# 1. Football Perfection ------
	# Identify the Football teams that scored over 400 points and had 80 or less fouls.

SELECT team
FROM football
WHERE points_scored > 400
AND penalties <= 80;

# 2. Area Code ------
	# Write a query to return all of the phone numbers that have an area code of 701 (this means the phone numbers begins with 701).

SELECT *
FROM phone_numbers 
WHERE numbers LIKE '701%'
LIMIT 10;
	
# 3. Country ------
	# Select all columns where the country is Canada, France, or Italy.
	# Order by Country in alphabetical order.

SELECT * FROM country
WHERE country IN ('Canada', 'France', 'Italy')
ORDER BY country
LIMIT 10;

# Data Types + Functions ------

# 1. Profit Margin ------
	# Determine the profit margin for each product.
	# The profit margin is derived by subtracting the Purchase Price from the Sale Price and then applying a 7% tax on that amount.
	# Present the product name along with its corresponding profit (round to 2 decimal places).
	# Order products by largest profit to smallest and products alphabetically.

SELECT product_name,
ROUND((sales_price - purchase_price) * 0.93, 2)
AS 'profit_margin'
FROM products
ORDER BY profit_margin DESC, product_name;

# 2. Gamer Tags ------
	# Create a gamer tag for each player in the tournament.
	# Select the first 3 characters of their first name and combine that with the year they were born.
	# Your output should have their first name, last name, and gamer tag called "gamer_tag"
	# Order output on gamertag in alphabetical order.

SELECT first_name, last_name, 
CONCAT(SUBSTRING(first_name, 1, 3),
YEAR(birth_date)) AS 'gamer_tag'
FROM gamer_tags
ORDER BY gamer_tag
LIMIT 10;

# 3. Company Wide Increase ------
	# If our company hits its yearly targets, every employee receives a salary increase depending on what level you are in the company.
	# Give each Employee who is a level 1 a 10% increase, level 2 a 15% increase, and level 3 a 200% increase.
	# Include this new column in your output as ‘new_salary’.

SELECT *,
CASE
	WHEN pay_level = 1 THEN salary * 1.1
	WHEN pay_level = 2 THEN salary * 1.15
	ELSE salary * 3
END AS 'new_salary'
FROM employees;

# Group By ------

# 1. Average Gaming Session ------
	# What was the average time spent, per user, gaming on their computer?

SELECT user_id,
AVG(minutes_per_session) AS avg_time_gaming
FROM sessions
WHERE activity = 'Gaming'
GROUP BY user_id;

# 2. Duplicate Emails ------
	# There’s recently been an error on our server where some emails were duplicated. We need to identify those emails so we can remove the duplicates.
	# Write a SQL query to report all the duplicate emails and how many times they are in the database.
	# Output should be in alphabetical order.

SELECT email, COUNT(email) AS count
FROM emails
GROUP BY email
HAVING COUNT(email) > 1
ORDER by email;

# Joins ------

#1. Movie-aholic ------
	# Find the customer who has watched the greatest number of movies.
	# Return the Customer name.
	# Example: If Ron watched “Lord of the Rings” 3 times and “Star Wars” 2 times (totaling 5 viewings), Leslie watched 4 movies, and Tom watched 2 movies, Ron, with his 5 total viewings, would be the answer.

SELECT c.name
FROM customers c
JOIN date_viewed dv
ON c.customer_id = dv.customer_id
GROUP BY c.name
ORDER BY COUNT(dv.view_date) DESC
LIMIT 1;

# 2. Boss ------
	# My boss wants a report that shows each employee and their boss’s name so he can try to memorize it before our quarterly social event.
	# Provide an output that includes the employee name matched with the name of their boss.
	# If they don’t have a boss, still include them in the output.
	# Order output on employee name alphabetically.

SELECT e.employee_name AS 'employee', b.employee_name AS 'boss'
FROM boss e
LEFT JOIN boss b
ON e.boss_id = b.employee_id
ORDER BY employee;

# Subqueries ------

# 1. Bad Bonuses ------
	# Everyone at Analyst Builder is supposed to receive a bonus at the end of the year.
	# Unfortunately some people didn’t receive their bonus as promised.
	# Write a query to determine the employees who did not receive their bonus so we can notify accounting.
	# Return their id and name in the output. Order the id from lowest to highest.

SELECT employee_id, name
FROM employee
WHERE employee_id NOT IN 
	(SELECT emp_id
	FROM bonus)
ORDER BY employee_id;

# 2. Most Orders ------
	# Write an SQL query to identify the customer who had the largest number of orders.
	# Return the customer_id and number of orders, but if 2 customers had the same amount of orders, return them both.

SELECT customer_id, number_of_orders
FROM orders
WHERE number_of_orders = (
	SELECT MAX(number_of_orders)
	FROM orders
);

# 3. Media Addicts ------
	# Social Media Addiction can be a crippling disease affecting millions every year.
	# We need to identity people who may fall into that category.
	# Write a query to find the people who spent a higher than average amount of time on social media.
	# Provide just their first names alphabetically so we can reach out to them individually.

SELECT first_name
FROM users
WHERE user_id IN (
	SELECT user_id
	FROM user_time
	WHERE media_time_minutes > (
		SELECT AVG(media_time_minutes)
		FROM user_time
		)
	)
ORDER BY first_name;

# Window Functions ------

# 1. Customers Largest Orders
	# We want to take a look at each customers purchases and give them their own row number.
	# Break the rows out by the customer and give each row a number based off the amount spent starting from the highest to the lowest.

SELECT customer_id, amount,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY amount DESC) AS row_num
FROM purchases;

# 2.	Art Ranking
	# Each artist was given a rating by 3 separate judges.
	# Write a query to combine those scores and rank the artists from highest to lowest. If there is a tie, the next ranking after it should be the next number sequentially, meaning there will be a gap in the next rank.
	# Output should include the artist, their total_score, and rank.
	# Order your output from smallest to largest rank. If there is a a tie, order on the artist_id as well as from smallest to largest.

SELECT artist_id,
SUM(score) AS total_score,
RANK() OVER(ORDER BY total_score DESC) AS rank_
FROM rankings
GROUP BY artist_id
ORDER BY total_score DESC, artist_id ASC;

# Data Cleaning ------

# 1. Breaking Out Column ------
	# The address in this table are in a very strange format. We actually need them broken out into street address, city, state, and zip code, but currently it’s pretty unusable
	# Write a query to break out this column into street, city, state, and zip_code with those names exactly.

SELECT
SUBSTRING_INDEX(address, '- ', 1) AS street,
SUBSTRING_INDEX(SUBSTRING_INDEX(address, '- ', 2), '- ', -1) AS city,
SUBSTRING_INDEX(SUBSTRING_INDEX(address, '- ', -2), '- ', 1) AS state,
SUBSTRING_INDEX(address, '- ', -1) AS zip_code
FROM addresses;

# 2. Contact Information ------
	# Write a query to report the first and last name of each person in the people table. Join to the contacts tale and return the email for each person as well.
	# If they don’t have an email, we need to create one for them. Use their first and last name to create a gmail for them.
	# Example: Jenny Fisher’s email would become jenny.fisher@gmail.com
	# Output should include first name, last name, and email. All emails should be populated.
	# Order the output on email address alphabetically.
	# Note this can be done in a few ways, but we can use a function called “COALESCE” which will check for NULL values and if it is NULL, it will populate it with whatever you put in there.

SELECT first_name,
last_name,
COALESCE(email, CONCAT(LOWER(first_name), '.', LOWER(last_name), '@gmail.com')) AS email
FROM contacts c
JOIN people p
ON c.id = p.id
ORDER BY email;



