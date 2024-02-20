#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "truncate table games, teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get winner team
    WINNER_TEAM="$($PSQL "select team_id from teams where name='$WINNER'")"
    # if not found
    if [[ -z $WINNER_TEAM ]]
    then
      # insert winner team
      WINNER_TEAM_RESULT="$($PSQL "insert into teams(name) values('$WINNER')")"
      
      # get winner team
      WINNER_TEAM="$($PSQL "select team_id from teams where name='$WINNER'")"
    fi

    # get opponent team
    OPPONENT_TEAM="$($PSQL "select team_id from teams where name='$OPPONENT'")"
    # if not found
    if [[ -z $OPPONENT_TEAM ]]
    then
      # insert opponent team
      OPPONENT_TEAM_RESULT="$($PSQL "insert into teams(name) values('$OPPONENT')")"

      # get opponent team
      OPPONENT_TEAM="$($PSQL "select team_id from teams where name='$OPPONENT'")"
    fi

    # insert game
    GAME_RESULT="$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_TEAM, $OPPONENT_TEAM, $WINNER_GOALS, $OPPONENT_GOALS)")"
  fi
done