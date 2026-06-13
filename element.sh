PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
INPUT=$1
if [ -z "$INPUT" ]
then
   echo "Please provide an element as an argument."
   exit 0
else
   if [[ $INPUT =~ ^[0-9]+$ ]]
   then
      TYPE="number"
   elif [[ $INPUT =~ ^[A-Z][a-z]?$ ]]
   then
      TYPE="symbol"
   else
      TYPE="name"
   fi
   if [[ $TYPE == "number" ]]
   then
      RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                  FROM elements e
                  INNER JOIN properties p USING(atomic_number)
                  INNER JOIN types t USING(type_id)
                  WHERE e.atomic_number = $INPUT;")

      if [[ -z $RESULT ]]
      then
         echo "I could not find that element in the database."
      else
         IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"
         echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      fi
   fi
   if [[ $TYPE == "symbol" ]]
   then
      RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                  FROM elements e
                  INNER JOIN properties p USING(atomic_number)
                  INNER JOIN types t USING(type_id)
                  WHERE e.symbol = '$INPUT';")

      if [[ -z $RESULT ]]
      then
         echo "I could not find that element in the database."
      else
         IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"
         echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      fi
   fi
   if [[ $TYPE == "name" ]]
   then
      RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                  FROM elements e
                  INNER JOIN properties p USING(atomic_number)
                  INNER JOIN types t USING(type_id)
                  WHERE e.name = '$INPUT';")

      if [[ -z $RESULT ]]
      then
         echo "I could not find that element in the database."
      else
         IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"
         echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      fi
   fi
fi
