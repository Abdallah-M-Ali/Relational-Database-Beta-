#!/bin/bash

if [[ $1 == "" ]]
then
  echo "Please provide an element as an argument."
else
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    SEARCH_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  else
    SEARCH_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' or name = '$1'")
  fi
  if [[ -z $SEARCH_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    # find info with the atomic number
     ELEMENT_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number = $SEARCH_RESULT")
    echo "$ELEMENT_RESULT" | while IFS="|" read LAST NUMBER SYMBOL NAME MASS MELTING BOILING TYPE
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi

