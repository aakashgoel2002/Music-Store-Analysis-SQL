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


