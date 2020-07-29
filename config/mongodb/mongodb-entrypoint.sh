#!/bin/bash

# Admin User
MONGODB_ADMIN_USER=${MONGO_INITDB_ROOT_USERNAME}
MONGODB_ADMIN_PASS=${MONGO_INITDB_ROOT_PASSWORD}

# Application Database User
MONGODB_APPLICATION_DATABASE=${MONGO_APPLICATION_DATABASE:-"admin"}
MONGODB_APPLICATION_USER=${MONGO_APPLICATION_USER}
MONGODB_APPLICATION_PASS=${MONGO_APPLICATION_PASS}

# Wait for MongoDB to boot
RET=1
while [[ RET -ne 0 ]]; do
  echo "=> Waiting for confirmation of MongoDB service startup..."
  sleep 5
  mongo admin --eval "help" >/dev/null 2>&1
  RET=$?
done

# Create the admin user
#echo "=> Creating admin user with a password in MongoDB"
#mongo admin --eval "db.createUser({user: '$MONGODB_ADMIN_USER', pwd: '$MONGODB_ADMIN_PASS', roles:[{role:'root',db:'admin'}]});"

#sleep 3

# If we've defined the MONGODB_APPLICATION_DATABASE environment variable and it's a different database
# than admin, then create the user for that database.
# First it authenticates to Mongo using the admin user it created above.
# Then it switches to the REST API database and runs the createUser command
# to actually create the user and assign it to the database.
for DB_NAME in $(echo $MONGODB_APPLICATION_DATABASE | tr "," "\n"); do
  if [ "$DB_NAME" != "admin" ]; then
    echo "=> Creating a $DB_NAME database user with a password in MongoDB"
    mongo admin -u $MONGODB_ADMIN_USER -p $MONGODB_ADMIN_PASS <<EOF
echo "Using $DB_NAME database"
use $DB_NAME
db.createUser({user: '$MONGODB_APPLICATION_USER', pwd: '$MONGODB_APPLICATION_PASS', roles:[{role:'readWrite', db:'$DB_NAME'}]})
EOF
  fi
done
sleep 1
echo "MongoDB configured successfully. You may now connect to the DB."
