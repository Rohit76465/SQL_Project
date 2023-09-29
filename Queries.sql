/* Q1: Who is the senior most employee based on job title? */
 
/*
SELECT*
FROM employee
ORDER BY levels DESC
LIMIT 1
*/


/* Q2: Which countries have the most Invoices? */

/*
SELECT COUNT(billing_country) AS no_of_invoices,billing_country
FROM invoice
GROUP BY billing_country
ORDER BY no_of_invoices DESC
LIMIT 1
*/


/* Q3: What are top 3 values of total invoice? */

/*
SELECT total 
FROM invoice 
ORDER BY total DESC
LIMIT 3
*/


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

/*
SELECT SUM(total) as S ,billing_city
FROM invoice
GROUP BY billing_city
ORDER BY S DESC
*/


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

/*
SELECT C.customer_id,SUM(i.total_spent_$) AS summ , C.first_name,C.last_name
FROM customer AS C
INNER JOIN invoice AS I
ON C.customer_id= I.customer_id
GROUP BY C.customer_id
ORDER BY summ DESC
LIMIT 1
*/


/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

/*1st method*/

/*
select distinct first_name,last_name,email
from customer 
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in ( SELECT track_id
                    FROM track
				    join genre on track.genre_id=genre.genre_id
				    where genre.name LIKE'Rock'
				   )
                    
order by email 
*/


/*2nd method*/

/*
select distinct first_name,last_name,email
from customer 
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in ( SELECT track_id
                    FROM track
                    WHERE genre_id IN( SELECT genre_id 
									   from genre 
									   where name='Rock' ) 
				  )
group by first_name,last_name,email
order by email 
*/


/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

/*1st method*/

/*
select artist.name , count(artist.name) as number_of_songs
from artist 
join album on artist.artist_id=album.artist_id
join track on album.album_id=track.album_id
where genre_id in (select genre_id 
				  from genre
				  where genre.name='Rock' 
				  )
group by artist.name
order by number_of_songs desc
limit 10
*/

/*2nd method*/

/*
select artist.artist_id,artist.name , count(artist.artist_id) as number_of_songs
from artist 
join album on artist.artist_id=album.artist_id
join track on album.album_id=track.album_id
where genre_id in (select genre_id 
				  from genre
				  where genre.name='Rock' 
				  )
group by artist.artist_id
order by number_of_songs desc
limit 10
*/
				  
/* 3rd method*/

/*
SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;
*/

/*4th method*/

/*
select artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs
from artist 
join album on artist.artist_id=album.artist_id
join track on album.album_id=track.album_id
join genre on track.genre_id=genre.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;
*/


/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

/*
select name,milliseconds
from track
where milliseconds > (select avg(milliseconds) 
					  from track)
order by milliseconds desc;
*/


/* Q9: Who is the best Artist as per the sales. Find how much amount was spent by each customer on this artist? Write a query to returns customer id, customer name, artist name and total spent by these customers */

/*
with best_selling_artist as 
(
	select ar.artist_id as artist_id,ar.name as artist_name,sum(il.unit_price*il.quantity) as sales_of_artist
	from artist as ar
	join album as al on ar.artist_id=al.artist_id
	join track as tr on al.album_id=tr.album_id
	join invoice_line as il on tr.track_id=il.track_id
	group by 1,2
	order by 3 desc
	limit 1
)

select c.customer_id,c.first_name,c.last_name,bsa.artist_name,sum(il.unit_price*il.quantity) as total_spent
from customer as c
join invoice as i on c.customer_id=i.customer_id
join invoice_line as il on i.invoice_id=il.invoice_id
join track as tr on il.track_id=tr.track_id
join album as al on tr.album_id=al.album_id
join best_selling_artist as bsa on al.artist_id=bsa.artist_id
group by 1,2,3,4
order by total_spent desc
*/


/* Q10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. */


/*
with popular_genre as 
(
    select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id, 
	row_number() over(partition by customer.country order by count(invoice_line.quantity) DESC) AS RowNo 
    from invoice_line 
	join invoice on invoice.invoice_id = invoice_line.invoice_id
	join customer on customer.customer_id = invoice.customer_id
	join track on track.track_id = invoice_line.track_id
	join genre on genre.genre_id = track.genre_id
	group by  2,3,4
	order by 1 desc
	
)
select * from popular_genre where RowNo <= 1
*/


/* Q11: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. */

/*
with customer_country_spent as
(
	select customer.customer_id , first_name , last_name , billing_country , sum(total_spent_$) as total_spent,
	      row_number() over(partition by billing_country order by sum(total_spent_$) desc ) as row_no
	from customer
	join invoice on customer.customer_id=invoice.customer_id
	group by 1,2,3,4
	order by 4 asc, 5 desc
)

select*from customer_country_spent where row_no = 1
*/














					 

					 





































