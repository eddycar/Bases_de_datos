
-- Join
-- 1. Utilizando la base de datos de movies, queremos conocer, por un lado, los
-- títulos y el nombre del género de todas las series de la base de datos.
SELECT title, genre_id, genres.id, name FROM series
JOIN genres ON genre_id = genres.id;
-- 2. Por otro, necesitamos listar los títulos de los episodios junto con el nombre y
-- apellido de los actores que trabajan en cada uno de ellos.
SELECT title, episodes.id, episode_id, CONCAT(first_name," ", last_name) as fullName
FROM episodes 
JOIN actor_episode ON episodes.id = episode_id
JOIN actors ON actor_id = actors.id;
-- 3. Para nuestro próximo desafío, necesitamos obtener a todos los actores o
-- actrices (mostrar nombre y apellido) que han trabajado en cualquier película
-- de la saga de La Guerra de las galaxias.
SELECT title, movies.id, movie_id, actor_id, actors.id, CONCAT(first_name," ", last_name) as fullName 
FROM movies
JOIN actor_movie ON movies.id = movie_id
JOIN actors ON actor_id = actors.id
WHERE title LIKE "%guerra de las galaxias%";
-- 4. Crear un listado a partir de la tabla de películas, mostrar un reporte de la
-- cantidad de películas por nombre de género.
SELECT genre_id, COUNT(*) FROM movies
GROUP BY genre_id;
