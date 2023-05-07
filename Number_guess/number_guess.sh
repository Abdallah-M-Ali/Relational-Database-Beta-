#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\nEnter your username:"
read USERNAME

RANDOM_NUMBER=$((1 + RANDOM % 1000))


SEARCH_USERNAME=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
if [[ -z $SEARCH_USERNAME ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_NEW_USER=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
  GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM records WHERE user_id='$USER_ID'")
  BEST_GAME=$($PSQL "SELECT MIN(game_record) FROM records WHERE user_id='$USER_ID'")
  echo -e "\nWelcome back, $SEARCH_USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo -e "\nGuess the secret number between 1 and 1000:"
# USER_GUES=""


TRIES=0

while [[ "$USER_GUES" != $RANDOM_NUMBER ]]
do
  read USER_GUES
  ((TRIES++))
  if [[ $USER_GUES =~ ^[0-9]+$ ]]
  then
    if [[ $USER_GUES -lt $RANDOM_NUMBER ]]
    then
      echo -e "\nIt's higher than that, guess again:"
      # GANE_INPUT=$($PSQL "INSERT INTO games(result) VALUES ('false')")
    elif [[ $USER_GUES -gt $RANDOM_NUMBER ]]
    then
      echo -e "\nIt's lower than that, guess again:"
      # GANE_INPUT=$($PSQL "INSERT INTO games(result) VALUES ('false')")
    else
      # GANE_INPUT=$($PSQL "INSERT INTO games(result) VALUES ('true')")
      # TRIES=$($PSQL "SELECT COUNT(game_id) FROM games")
      echo -e "\nYou guessed it in $TRIES tries. The secret number was $USER_GUES. Nice job!"
    fi
  else
    echo -e "\nThat is not an integer, guess again:"
  fi
done
RECORD_INPUT=$($PSQL "INSERT INTO records(user_id, game_record) VALUES ('$USER_ID', '$TRIES')")
# CLEAN_GAMES=$($PSQL "DELETE FROM games")
