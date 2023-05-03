#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"

SERVICES(){
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME" 
  done

  read SERVICE_ID_SELECTED
  SERVICE_AVAILABILITY=$($PSQL "SELECT service_id FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  if [[ -z $SERVICE_AVAILABILITY ]]
  then
    #retrn to the services menu again
    echo -e "\nI could not find that service. What would you like today?"
    SERVICES
  else
    # check the customer info
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE PHONE = '$CUSTOMER_PHONE'")
    
    # chek the name
    if [[ -z $CUSTOMER_NAME ]]
    then
      # know the customer name
      echo -e "\nI don't have a record for that phone number, What's your name?"
      read CUSTOMER_NAME

      # insert new customer
      INSERT_CUSTOMER=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi
      # know the time of the services
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE PHONE = '$CUSTOMER_PHONE'")
      echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME"
      read SERVICE_TIME

      # make an appointment
      INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
      echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    
  fi
}

SERVICES