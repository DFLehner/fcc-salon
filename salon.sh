#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"


MAIN_MENU() {
if [[ "$1" ]] ; then
    echo -e "\n$1"
else
    echo -e "\n ~~~~~Schedule an outdoor activity~~~~~ \n"
    echo -e "\n Welcome. Enter a number from 1 to 4 to schedule an appointment for one of the following activities:\n" 
fi

GET_ACTIVITIES=$($PSQL "SELECT service_id , name FROM services ORDER BY service_id;")
echo "$GET_ACTIVITIES" | while IFS='|' read SERVICE_ID SERVICE
    do
    echo "$SERVICE_ID) $SERVICE"
    done
read SERVICE_ID_SELECTED
#Check service has been chosen.
if [[ -z $SERVICE_ID_SELECTED ]]
  then MAIN_MENU "Please input a number to select a service."
       return
fi
#Check service chosen is valid.
GET_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
if [[ -z $GET_SERVICE ]] 
then MAIN_MENU "Please select a valid service."
     return
fi
#Ask for telephone number:
echo -e "\nWhat's your phone number?\n"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")
if [[ -z $CUSTOMER_NAME ]]
    then echo "What's your name?" 
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers( name, phone ) VALUES ( '$CUSTOMER_NAME', '$CUSTOMER_PHONE' );")
fi
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
echo "What time do you want to book your activity?"
read SERVICE_TIME
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments( customer_id, service_id, time ) VALUES ( '$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME' );")
echo -e "I have put you down for a $GET_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
}


MAIN_MENU

