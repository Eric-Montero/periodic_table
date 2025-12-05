#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# no argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

ARG="$1"

# build query depending on argument type
if [[ $ARG =~ ^[0-9]+$ ]]
then
  WHERE="e.atomic_number = $ARG"
else
  # treat as name or symbol (case-insensitive)
  WHERE="e.symbol ILIKE '$ARG' OR e.name ILIKE '$ARG'"
fi

QUERY="SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
FROM elements e
JOIN properties p USING(atomic_number)
JOIN types t USING(type_id)
WHERE $WHERE;"

RESULT="$($PSQL "$QUERY")"

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$RESULT"

# trim spaces
ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | sed 's/^ *//;s/ *$//')
NAME=$(echo $NAME | sed 's/^ *//;s/ *$//')
SYMBOL=$(echo $SYMBOL | sed 's/^ *//;s/ *$//')
TYPE=$(echo $TYPE | sed 's/^ *//;s/ *$//')
MASS=$(echo $MASS | sed 's/^ *//;s/ *$//')
MELT=$(echo $MELT | sed 's/^ *//;s/ *$//')
BOIL=$(echo $BOIL | sed 's/^ *//;s/ *$//')

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
