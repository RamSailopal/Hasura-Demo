# Hasura demo

A demonstation of creating a local Hasura environment with SQL migration scripts to create a table that can then be used to test GraphQL via the Hasura browser.

## Provisioning

    git clone https://github.com/RamSailopal/Hasura-Demo.git
    cd Hasura-Demo
    docker-compose up -d

Using a postgres client such as [pgAdmin](https://www.pgadmin.org/), create a connection to the database. Host name/address will be **localhost** and the password will be **postgrespassword**

Create a new database called **test**

Navigate to your Hasura web console via the address http://localhost:8080

Click on the **Data** tab and then click on the **Manage** button next to **Databases**

Click on **Connect Database** and then **Connect Existing Database**

Enter a name for the database and then use **PG_DATABASE_URL** for the environmental variable.

Once the database is configured in Hasura, the migrations can be run to create the test **players** database

## Database migration

From a terminal cli, run:

    docker exec -it hasura-hasura-cli-1 /bin/bash
    cd /home/hasura
    hasura migrate apply --endpoint "http://graphql-engine:8080" --database-name test --admin-secret postgrespassword

This will create a table called players and add two player entries for Kevin Philips and Bob Taylor respectively. The migration occurs via three steps, one for an initial create table, one for insert 'Kevin Philips' and one for insert 'Bob Taylor'. The three steps will be referenced via different incremented directories held within **migration/test** Each directory holds two sql statements **up.sql** and **down.sql** up.sql holds the sql for a normal migration and down.sql holds the sql for rolling back a given migration.

## Rolling back a given migration

In our particular case, three migrations have taken place and any number of these migration can be rolled back. For example, to roll back the last table insert for Bob Taylor, we would run:

    hasura migrate apply --down 1 --endpoint "http://graphql-engine:8080" --database-name test --admin-secret postgrespassword

To remove the table all together via rolling back all the migrations, we would run:

    hasura migrate apply --down 3 --endpoint "http://graphql-engine:8080" --database-name test --admin-secret postgrespassword

## Creating additional migrations
 
To create additional incremental changes to a given database run:

    hasura migrate create players

This will create another sequential directory called xxxx..._players in **migrations/test** along with empty up and down.sql files to be editted as required.


## Running GraphQL against the table

In the Hasura console, click on the **API** tab.

Enter the query accordingly i.e. to get all entries:

        query GetPlayers {
        players {
            address
                name
        }
        }

Get all players with the first name Bob:

        query GetPlayers {
        players(where: {name: {_ilike: "Bob%"}}) {
            address
            name
        }
        }







