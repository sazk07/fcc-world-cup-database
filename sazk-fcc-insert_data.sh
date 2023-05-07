
#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE games, teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != 'winner' ]]
  then
    # get team_id from winner
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE  name = '$WINNER'" )
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert team from winner
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER') ")
      #get new team_id from winner
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE  name = '$WINNER'" )
    fi
    #get team_id from opponent
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE  name = '$OPPONENT'" )
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert team from opponent
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT') ")
      #get new team_id from opponent
       TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE  name = '$OPPONENT'" )
    fi
  fi

  if [[ $YEAR != 'year' ]]
  then
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE  name = '$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE  name = '$OPPONENT'")
      INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done

