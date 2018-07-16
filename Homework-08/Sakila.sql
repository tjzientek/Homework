-- Created by T.J. Zientek
-- Created on 2018-07-15

USE sakila;

-- 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name' FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters `GEN`
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order
SELECT last_name, first_name FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name;

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
ALTER TABLE actor ADD COLUMN middle_name VARCHAR(30) NULL AFTER first_name;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE actor MODIFY COLUMN middle_name BLOB;

-- 3c. Now delete the `middle_name` column.
ALTER TABLE actor DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS 'LastName Count' FROM actor GROUP BY last_name ORDER BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS 'LastName Count' FROM actor GROUP BY last_name HAVING COUNT(*) > 1 ORDER BY last_name;

-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'Groucho' and last_name = 'Williams';

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single 
-- query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as 
-- that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, 
-- HOWEVER! (Hint: update the record using a unique identifier.)
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Harpo';
UPDATE actor SET first_name = 'Groucho' WHERE actor_id = 172;

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`
SELECT s.first_name, s.last_name, ad.address, ad.address2, c.city, ad.postal_code
FROM staff AS s
JOIN address AS ad ON (s.address_id = ad.address_id)
JOIN city AS c ON (ad.city_id = c.city_id)
ORDER BY s.first_name, s.last_name;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`
SELECT s.first_name, s.last_name, SUM(p.amount)
FROM staff AS s
JOIN payment AS p ON (s.staff_id = p.staff_id)
WHERE p.payment_date < '2005-09-01'
GROUP BY s.first_name, s.last_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join
SELECT f.title, COUNT(fa.actor_id) as 'Number of Actors'
FROM film AS f
INNER JOIN film_actor AS fa ON (f.film_id = fa.film_id)
GROUP BY f.title
ORDER BY f.title;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT f.title, COUNT(i.inventory_id) as 'Inventory Count'
FROM film AS f
JOIN inventory AS i ON (f.film_id = i.film_id)
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.title;

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
-- List the customers alphabetically by last name
SELECT c.first_name, c.last_name, SUM(p.amount) as 'Total Amount Paid'
FROM customer AS c
JOIN payment AS p ON (c.customer_id = p.customer_id)
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the 
-- letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` 
-- whose language is English.
SELECT f.title
FROM film AS f
WHERE (f.title LIKE 'K%' or f.title LIKE 'Q%') and f.language_id IN (
	SELECT l.language_id FROM language AS l WHERE l.name = 'English'
);

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id IN (
	SELECT fa.actor_id FROM film_actor AS fa WHERE fa.film_id IN (
    SELECT f.film_id FROM film AS f WHERE f.title = 'Alone Trip'
))
ORDER BY a.first_name, a.last_name;

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian 
-- customers. Use joins to retrieve this information.
SELECT c.first_name, c.last_name, c.email
FROM customer AS c
JOIN address AS ad ON (c.address_id = ad.address_id)
JOIN city AS ci ON (ad.city_id = ci.city_id)
JOIN country AS co ON (ci.country_id = co.country_id)
WHERE co.country = 'Canada'
ORDER BY first_name, last_name;

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies 
-- categorized as family films.
SELECT f.title, ca.name
FROM film AS f
JOIN film_category AS fc ON (f.film_id = fc.film_id)
JOIN category AS ca ON (fc.category_id = ca.category_id)
WHERE ca.name = 'Family'
ORDER BY f.title;

-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(r.rental_id) as 'Number of Times Rented'
FROM film AS f
JOIN inventory AS i ON (f.film_id = i.film_id)
JOIN rental AS r ON (i.inventory_id = r.inventory_id)
GROUP BY f.title
ORDER BY COUNT(r.rental_id) desc, f.title;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT sto.store_id, SUM(p.amount) as 'Amount'
FROM store AS sto
JOIN staff AS sta ON (sto.store_id = sta.store_id)
JOIN payment AS p ON (sta.staff_id = p.staff_id)
GROUP BY sto.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT sto.store_id, ci.city, co.country
FROM store AS sto
JOIN address AS ad ON (sto.address_id = ad.address_id)
JOIN city AS ci ON (ad.city_id = ci.city_id)
JOIN country AS co ON (ci.country_id = co.country_id)
ORDER BY ci.city;

-- 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, 
-- film_category, inventory, payment, and rental.)
SELECT ca.name, SUM(p.amount) AS 'Gross Revenue'
FROM category AS ca
JOIN film_category AS fc ON (ca.category_id = fc.category_id)
JOIN inventory AS i ON (fc.film_id = i.film_id)
JOIN rental AS r ON (i.inventory_id = r.inventory_id)
JOIN payment AS p ON (r.rental_id = p.rental_id)
GROUP BY ca.name
ORDER BY SUM(p.amount) desc
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use 
-- the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres AS 
SELECT ca.name, SUM(p.amount) AS 'Gross Revenue'
FROM category AS ca
JOIN film_category AS fc ON (ca.category_id = fc.category_id)
JOIN inventory AS i ON (fc.film_id = i.film_id)
JOIN rental AS r ON (i.inventory_id = r.inventory_id)
JOIN payment AS p ON (r.rental_id = p.rental_id)
GROUP BY ca.name
ORDER BY SUM(p.amount) desc
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_genres;






