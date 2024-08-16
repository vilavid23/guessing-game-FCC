#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

min=1
max=1000
random_number=$(( $RANDOM % ($max - $min + 1) + $min ))

START() {
echo Enter your username:
read USERNAME

MEMBER=$($PSQL "SELECT username FROM games WHERE username = '$USERNAME'")
BEST_GAME=$(echo $($PSQL "SELECT MIN(guess) FROM games WHERE username='$USERNAME'") | sed "s/ //g")
GAMES_PLAYED=$(echo $($PSQL "SELECT COUNT(game_id) FROM games WHERE username = '$USERNAME'") | sed "s/ //g")


if [[ -z $MEMBER ]]
then
INSERT_USER=$($PSQL "INSERT INTO players(username) VALUES('$USERNAME')")
echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."

else
echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi


echo -e "\nGuess the secret number between 1 and 1000:"

GUESS 
}

GUESS() {
  TRIES=0
  GUESS=0
  while [[ $GUESS = 0 ]]
  do
  read USER_GUESS
  if [[ ! $USER_GUESS =~ ^[0-9]+$ ]]
  then
  echo "That is not an integer, guess again:"
  elif [[ $USER_GUESS = $random_number ]]
  then
  TRIES=$(($TRIES + 1))
  echo -e "\nYou guessed it in $TRIES tries. The secret number was $random_number. Nice job!"
  INSERT_GAME=$($PSQL "INSERT INTO games(username, guess) VALUES('$USERNAME', $TRIES)")
  GUESS=1

  elif [[ $USER_GUESS > $random_number ]]
  then
  echo -e "\nIt's lower than that, guess again:"
  TRIES=$(($TRIES + 1))
  else
  echo -e "\nIt's higher than that, guess again:"
  TRIES=$(($TRIES + 1))
  fi  
  done
}

START
