--1 Who was the top scorer from the game between UCLA Bruins v Oregon Ducks in season 2017 which took place at Pauley Pavilion?
SELECT
    games.season,
    games.venue_name,
    games.h_name AS home_team,
    games.a_name AS away_name,
    players.full_name AS player_name,
    players.points AS total_points
  FROM
    `bigquery-public-data.ncaa_basketball.mbb_games_sr` AS games
  LEFT JOIN `bigquery-public-data.ncaa_basketball.mbb_players_games_sr` AS players
    ON games.game_id = players.game_id
  WHERE
    games.season=2017 AND 
    games.venue_name='Pauley Pavilion' AND
    games.h_name='Bruins' AND 
    games.a_name='Ducks'
  ORDER BY 6 DESC
  LIMIT 1