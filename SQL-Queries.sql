ALTER TABLE album2 RENAME TO album;

-- Q.1 Who is the Senior Most Employee based on Job Title?
SELECT concat(first_name, ' ', last_name) FROM employee ORDER BY levels DESC LIMIT 1;

-- Q.2 	Which countries have the most invoices?
SELECT billing_country, count(billing_country) AS count FROM invoice GROUP BY billing_country ORDER BY count DESC LIMIT 1;

-- Q.3 What are top 3 value of Total invoice?
SELECT * FROM invoice ORDER BY total DESC LIMIT 3;

-- Q.4 Which city has highest amount of invoices?
SELECT billing_city, sum(total) as total_amount FROM invoice GROUP BY billing_city ORDER BY total_amount DESC LIMIT 1;

-- Q.5 Which customer has spent the most money?
select customer_id, sum(total) as total from invoice group by customer_id order by total desc limit 1;

-- Q.6 Write Query to return email, first name, last name of all Rock Genre Music listeners, order by email starting with A?
Select distinct email, first_name, last_name from customer
join invoice ON customer.customer_id = invoice.customer_id
join invoice_line ON invoice.invoice_id = invoice_line.invoice_id
where track_id IN(
	SELECT track_id from track
    JOIN genre ON track.genre_id = genre.genre_id
    where genre.name LIKE 'Rock'
) ORDER BY email ASC;

-- Q.7 Write Query that that returns the artist name and total track count of top 10 rock bands?
Select artist.name, count(artist.artist_id) as numberOfSongs from track 
JOIN album ON album.album_id=track.album_id
JOIN artist ON artist.artist_id = album.artist_id
WHERE genre_id = (SELECT genre_id from genre where name LIKE 'Rock') GROUP BY artist.name ORDER BY numberOfSongs DESC LIMIT 10;

-- Q.8 Return all the track name that have length longer than the average song length, return name and millisecond, and order by song length as longest first?
select name, milliseconds from track where milliseconds>(select AVG(milliseconds) from track) Order by milliseconds DESC;

-- Q.9 Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent?
WITH best_selling_artist AS(
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales FROM invoice_line
    JOIN track ON track.track_id=invoice_line.track_id
    JOIN album ON album.album_id=track.album_id
    JOIN artist ON artist.artist_id = album.artist_id
    GROUP BY 1 ORDER BY 3 DESC LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4 ORDER BY 5 DESC;

-- Q.10 Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres?
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
SELECT * FROM popular_genre WHERE RowNo <= 1;

-- Q.11 Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount?
WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1;