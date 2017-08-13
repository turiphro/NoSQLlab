SELECT title FROM movies WHERE title ILIKE 'stardust%';

SELECT COUNT(*) FROM movies WHERE title !~* '^the.*';

SELECT title FROM movies WHERE title @@ 'night & day';

-- clasify Star Wars
SELECT name,
    cube_ur_coord('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)', position) AS score
FROM genres
WHERE cube_ur_coord('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)', position) > 0;

-- Closest movies to Star Wars
SELECT title,
    cube_distance(genre, '(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)') as distance
FROM movies
ORDER BY distance ASC
LIMIT 5;
