#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
if [[ $WINNER != 'winner' && $OPPONENT != 'opponent' ]]
  then
  #get winner_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  #if not found
  if [[ -z $WINNER_ID ]]
    then 
    #insert winner
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')");
    if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]]
      then
      echo Inserted into teams, $WINNER
    fi
    # get new winner_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi
  #get opponent_id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  #if not found
  if [[ -z $OPPONENT_ID ]]
    then 
    #insert opponent
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')");
    if [[ $INSERT_OPPONENT_RESULT == 'INSERT 0 1' ]]
      then
      echo Inserted into teams, $OPPONENT
    fi
     #get new opponent_id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi

    # insert into games
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(winner_id, opponent_id, year, round, winner_goals, opponent_goals) VALUES($WINNER_ID, $OPPONENT_ID, $YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS)")

    if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into games, $WINNER_ID : $OPPONENT_ID
    fi
fi



done
# $($PSQL "");