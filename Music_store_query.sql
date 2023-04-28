/*Q1: Find the employee with the highest job title*/
SELECT title, last_name, first_name 
FROM employee
ORDER BY levels DESC
LIMIT 1;

/*Q2: Find the countries with the most invoices*/
SELECT COUNT(*) AS num_invoices, billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY num_invoices DESC;

/* Q3: Find the top 3 invoice values*/
SELECT total 
FROM invoice
ORDER BY total DESC
LIMIT 3;

/*Q4: Find the city with the highest total invoice amount*/
SELECT billing_city, SUM(total) AS total_invoice_amount
FROM invoice
GROUP BY billing_city
ORDER BY total_invoice_amount DESC
LIMIT 1;

/* Find the customer who spent the most money*/
SELECT customer.customer_id, first_name, last_name, SUM(total) AS total_spending
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total_spending DESC
LIMIT 1;
/*Retrieve the email,first_name,last_name and genre of all customers who have purchased Rock music.
Sort the results alphabetically by email address. */
SELECT DISTINCT email, first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoiceline ON invoice.invoice_id = invoiceline.invoice_id
WHERE track_id IN (
  SELECT track_id FROM track
  JOIN genre ON track.genre_id = genre.genre_id
  WHERE genre.name = 'Rock'
)
ORDER BY email;

/* select  all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

SELECT name,miliseconds
FROM track
WHERE miliseconds > (
	SELECT AVG(miliseconds) AS avg_track_length
	FROM track )
ORDER BY miliseconds DESC;

/* Returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres.*/
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1