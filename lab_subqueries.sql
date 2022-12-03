use sakila;
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(inventory_id) from inventory where film_id in 
(select film_id from film where title = 'Hunchback Impossible');

-- 2. List all films whose length is longer than the average of all the films.
select film_id, title from film where length > (select avg(length) from film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
select actor_id, concat(first_name, ' ', last_name) as actor_name from actor where actor_id in
(select actor_id from film_actor join film on film_actor.film_id = film.film_id
where film.title = 'Alone Trip');

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select film_id, title from film where film_id in 
(select film_id from film_category join category on film_category.category_id = category.category_id where category.name = 'Family');

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
select concat(first_name, ' ', last_name) as customer_name, email from customer where customer_id in 
(select c.address_id from customer c join address a on c.address_id = a.address_id
join city on a.city_id = city.city_id join country on city.country_id = country.country_id where country.country = 'Canada'); 

-- 6. Which are films starred by the most prolific actor?
select film_id, title, a.actor_name from film join
(select film_actor.actor_id, concat(first_name, ' ',last_name) as actor_name, count(film_id) as number_of_films from film_actor join actor 
on film_actor.actor_id = actor.actor_id group by actor_id order by number_of_films desc limit 1) as a ;

-- 7. Films rented by most profitable customer.
select c.film_id, c.title, a.customer_name from 
(select film.film_id, film.title, customer_id from film join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id) as c
 join 
 (select c.customer_id, concat(first_name, ' ', last_name) as customer_name, sum(p.amount) as payment_amount from customer c join payment p on c.customer_id = p.customer_id 
group by customer_id order by payment_amount desc limit 1) as a 
on c.customer_id = a.customer_id;

-- 8.Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
select c.customer_id, concat(first_name, ' ', last_name) as customer_name, sum(p.amount) as total_amount_spent from customer c 
join payment p on c.customer_id = p.customer_id 
having total_amount_spent > (select avg(total_amount_spent) from (select customer_id, SUM(amount) as total_amount_spent from payment b group by customer_id) as b);