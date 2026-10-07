#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -X -t -A -c"

print_services() {
  echo "~~~~~ MY SALON ~~~~~"
  echo
  echo "Welcome to My Salon, how can I help you?"
  echo
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;")
  echo "$SERVICES" | awk -F'|' '{print $1 ") " $2}'
}

while true; do
  print_services
  read SERVICE_ID_SELECTED

  if [[ -z "$SERVICE_ID_SELECTED" || ! "$SERVICE_ID_SELECTED" =~ ^[0-9]+$ ]]; then
    echo
    echo "I could not find that service. What would you like today?"
    echo
    continue
  fi

  SERVICE_EXISTS=$($PSQL "SELECT EXISTS(SELECT 1 FROM services WHERE service_id = $SERVICE_ID_SELECTED);")

  if [[ "$SERVICE_EXISTS" == "t" ]]; then
    break
  fi

  echo
  echo "I could not find that service. What would you like today?"
  echo
done

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

while true; do
  echo
  echo "What's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

  if [[ -n "$CUSTOMER_ID" ]]; then
    break
  fi

  echo
  echo "I don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  $PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME');"
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
  break
done

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID;")

echo
printf "What time would you like your %s, %s?\n" "$SERVICE_NAME" "$CUSTOMER_NAME"
read SERVICE_TIME

$PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');"

echo
printf "I have put you down for a %s at %s, %s.\n" "$SERVICE_NAME" "$SERVICE_TIME" "$CUSTOMER_NAME"
