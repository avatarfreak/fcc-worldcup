#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
cat ./games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOAL OPP_GOAL
do
  #WINNER
  if [[ $WINNER != "winner" ]]
  then
    # get winner_id
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  # if not found winner_id
  if [[ -z $WINNER_ID ]]
  then
    # Insert winner into teams
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
    then
      echo "Insert winner into teams, $WINNER"
    fi      
  fi

  # get opponent_id
  OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  # if not found opponent_id
  if [[ -z $OPP_ID ]]
  then
    # Insert opponent into teams
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted opponent into teams, $OPPONENT"
    fi    
  fi
  # get new OPPONENT_ID
  OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

   # get new WINNER_ID
   WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

   # INSERT INTO GAMES
   INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES($YEAR, $WIN_ID, $OPP_ID, $WIN_GOAL, $OPP_GOAL, '$ROUND')")
   if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
   then
     echo "Insert WINNER and OPPONENT into games, $WINNER:$OPPONENT"
   fi
  fi
done
