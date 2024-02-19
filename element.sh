PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ $1 ]]
then
  # if atomic_number in input
  if [[ $1 =~ ^[1-9]+$ ]]
  then 
    # get element info
    ATOMIC_NUMBER=$1
    IFS='|' read -r  ATOMIC_MASS NAME SYMBOL TYPE MELTING_POINT BOILING_POINT \
    <<< "$($PSQL "SELECT  atomic_mass, name, symbol, type,  melting_point_celsius, boiling_point_celsius from properties inner join elements using (atomic_number) inner join types using (type_id) where atomic_number = $1 ")"
  else 
    # if symbol in input
    if [[ $1 =~ ^[A-Z][a-zA-Z]$ || $1 =~ ^[A-Z]$ ]]
    then
      # get element info
      SYMBOL=$1
      IFS='|' read -r  ATOMIC_NUMBER ATOMIC_MASS NAME TYPE MELTING_POINT BOILING_POINT \
      <<< "$($PSQL "SELECT  atomic_number, atomic_mass, name, type,  melting_point_celsius, boiling_point_celsius from properties inner join elements using (atomic_number) inner join types using (type_id) where symbol = '$1'")"
    else 
      # if name in input
      if [[ $1 =~ ^[a-zA-Z]+$ ]]
      then
        # get element info
        NAME=$1
        IFS='|' read -r ATOMIC_NUMBER ATOMIC_MASS SYMBOL TYPE MELTING_POINT BOILING_POINT \
        <<< "$($PSQL "SELECT atomic_number, atomic_mass, symbol, type, melting_point_celsius, boiling_point_celsius from properties inner join elements using (atomic_number) inner join types using (type_id) where name = '$1'")"
      fi
    fi
  fi
  # if element info found
  if [[ ! -z $ATOMIC_NUMBER && ! -z $NAME ]]
  then
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  # if not found
  else
    echo "I could not find that element in the database."
  fi
else 
  # if there is no argument 
  echo  "Please provide an element as an argument."
fi 
