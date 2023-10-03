/*Introduction

Welcome to the SQL Joins lab!

In this lab, you will be working with the Sakila database on movie rentals. Specifically, you will be practicing how to perform joins on multiple tables in SQL. Joining multiple tables is a fundamental concept in SQL, allowing you to combine data from different tables to answer complex queries. Furthermore, you will also practice how to use aggregate functions to calculate summary statistics on your joined data.
Challenge - Joining on multiple tables

Write SQL queries to perform the following tasks using the Sakila database:

    List the number of films per category.
    Retrieve the store ID, city, and country for each store.
    Calculate the total revenue generated by each store in dollars.
    Determine the average running time of films for each category.
    Identify the film categories with the longest average running time.
    Display the top 10 most frequently rented movies in descending order.
    Determine if "Academy Dinosaur" can be rented from Store 1.
    Provide a list of all distinct film titles, along with their availability status in the inventory. Include a column indicating whether each title is 'Available' or 'NOT available.' Note that there are 42 titles that are not in the inventory, and this information can be obtained using a CASE statement combined with IFNULL."

Here are some tips to help you successfully complete the lab:

Tip 1: This lab involves joins with multiple tables, which can be challenging. Take your time and follow the steps we discussed in class:

    Make sure you understand the relationships between the tables in the database. This will help you determine which tables to join and which columns to use in your joins.
    Identify a common column for both tables to use in the ON section of the join. If there isn't a common column, you may need to add another table with a common column.
    Decide which table you want to use as the left table (immediately after FROM) and which will be the right table (immediately after JOIN).
    Determine which table you want to include all records from. This will help you decide which type of JOIN to use. If you want all records from the first table, use a LEFT JOIN. If you want all records from the second table, use a RIGHT JOIN. If you want records from both tables only where there is a match, use an INNER JOIN.
    Use table aliases to make your queries easier to read and understand. This is especially important when working with multiple tables.
    Write the query

Tip 2: Break down the problem into smaller, more manageable parts. For example, you might start by writing a query to retrieve data from just two tables before adding additional tables to the join. Test your queries as you go, and check the output carefully to make sure it matches what you expect. This process takes time, so be patient and go step by step to build your query incrementally.
*/

USE sakila;
show tables;

# List the number of films per category.
SELECT c.name AS category_name, COUNT(1) AS number_of_films
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name;

# Retrieve the store ID, city, and country for each store.
SELECT s.store_id, ci.city, co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

# Calculate the total revenue generated by each store in dollars.
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

# Determine the average running time of films for each category.
SELECT c.name AS category_name, AVG(f.length) AS avg_run_time
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

# Identify the film categories with the longest average running time.
SELECT c.name AS category_name, AVG(f.length) AS avg_run_time
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY avg_run_time DESC
LIMIT 5;

# Display the top 10 most frequently rented movies in descending order.
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 10;

# Determine if "Academy Dinosaur" can be rented from Store 1.
SELECT f.title, i.store_id
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE f.title = "Academy Dinosaur" AND i.store_id = 1;

# Provide a list of all distinct film titles
SELECT f.title,
CASE 
    WHEN SUM(CASE WHEN i.inventory_id IS NULL THEN 0 ELSE 1 END) = 0 THEN 'NOT available'
    ELSE 'Available'
END AS availability_status
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.title;