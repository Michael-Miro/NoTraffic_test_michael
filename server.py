import psycopg2
from flask import Flask, request

app = Flask(__name__)

# Database configuration
db_host = 'localhost'
db_port = 5434
db_name = 'sample_database'
db_user = 'postgres'
db_password = 'notraffic'

# Establish database connection
conn = psycopg2.connect(
    host=db_host,
    port=db_port,
    dbname=db_name,
    user=db_user,
    password=db_password
)

# API endpoint to add a new row to a table
@app.route('/add', methods=['POST'])
def add_row():
    table_name = request.json['table_name']
    data = request.json['data']
    print(f"Inserting data into table {table_name}: {data}")
    with conn.cursor() as cur:
        placeholders = ','.join(['%s'] * len(data))
        query = f"INSERT INTO {table_name} VALUES ({placeholders})"
        cur.execute(query, data)
        conn.commit()
    return 'Row added successfully'


# API endpoint to delete an existing row in a table
@app.route('/delete', methods=['DELETE'])
def delete_row():
    table_name = request.json['table_name']
    id = request.json['id']
    with conn.cursor() as cur:
        query = f"DELETE FROM {table_name} WHERE id = %s"
        cur.execute(query, (id,))
        conn.commit()
    return 'Row deleted successfully'

# API endpoint to update an existing row in a table
@app.route('/update', methods=['PUT'])
def update_row():
    table_name = request.json['table_name']
    id = request.json['id']
    update_data = request.json['update_data']
    with conn.cursor() as cur:
        set_clause = ','.join([f"{key} = %s" for key in update_data.keys()])
        query = f"UPDATE {table_name} SET {set_clause} WHERE id = %s"
        cur.execute(query, list(update_data.values()) + [id])
        conn.commit()
    return 'Row updated successfully'

if __name__ == '__main__':
    app.run()
