
# ** Server Database Setup** 

*docker_script.sh*

This is a bash script that sets up a PostgreSQL server using Docker, creates a new database, and imports a sample data model and data files into the database. The script will map port 5434 on the host machine to port 5432 in the container.

*Requirements*

To use this script, you must have Docker installed on your machine.

*Usage*

1. Clone this repository to your local machine.
2. Open a terminal window and navigate to the directory containing the script.
3. Run the script using the following command: ./docker_script.sh 
(use chmod +x docker_script.sh if needed)

The script will create a PostgreSQL server using Docker and import the sample data model and data files into a new database called sample_database.
If the setup is successful, you should see the message Database created and populated successfully in the terminal.

*Troubleshooting*

If you encounter any errors while running the script, make sure that:

* Docker is installed and running on your machine.
* The port number you specified in the script is not already in use by another application.
* The sample data model and data files are located in the same directory as the script.
* The database is not already created.

Note : provided data base was altered using SQLines for PostgreSQL compatibility 

# ** Server**

This is a Python Flask server that provides APIs to interact with a PostgreSQL database.

**Requirements**

To use this server, you must have the following installed on your machine:

1. Python 3
2. psycopg2 module
3. Flask module
4. PostgreSQL

**Installation and Setup**
1. Clone this repository to your local machine.
2. Open a terminal window and navigate to the directory containing the server.py file.
3. Install the required modules using the following command:
pip install -r requirements.txt
4. Run the server using the following command:
```
python3 server.py
```

**Usage**

The server provides the following APIs:

Add a new row to a table
```
POST /add
{
    "table_name": "table_name",
    "data": ["value1", "value2", "value3"]
}
```

Delete an existing row from a table
```
DELETE /delete
{
    "table_name": "table_name",
    "id": 1
}
```
Update an existing row in a table
PUT /update
```
{
    "table_name": "table_name",
    "id": 1,
    "update_data": {
        "column1": "value1",
        "column2": "value2"
    }
}
```
**Troubleshooting**

If you encounter any errors while using the server, make sure that:

PostgreSQL is installed and running on your machine.
The database details in the server.py file are correct.
The APIs are called with the correct parameters and in the correct format.

# **API Client Readme**
This is an API client that allows users to add, update, or delete rows from a database using the API endpoints provided by the server.

*Requirements*
1. Python 3.x installed on your machine
2. requests library installed on your machine. You can install it using the following command:
pip install requests
3. Open a terminal window and navigate to the directory containing the script.
4. Modify the JSON files located in the json_files folder to match your data requirements.
Run the script using the following command:
python3 api_client.py
5. Follow the prompt and select the action you want to perform (add/delete/update).
If the operation is successful, you should see a success message in the terminal. If the operation fails, you will see an error message with details about the failure.

Note: Make sure the server is running and that the base URL of the API endpoint is correct before running the script.
