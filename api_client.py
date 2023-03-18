import requests
import json

# Define the base URL of the API endpoint
base_url = "http://localhost:5000"

# Prompt the user for the action they want to perform
action = input("Which action do you want to perform? (add/delete/update): ")
json_path = "json_files/"
# If the user selected "add" or "update", load the data for the new or updated row from a JSON file
if action == "add":
    with open(f'{json_path}add.json', 'r') as f:
        data = json.load(f)
    url = f"{base_url}/add"
    response = requests.post(url, json=data)
    if response.status_code == 200:
        print("New row added successfully.")
    else:
        print(f"Failed to add new row. Error message: {response.text}")

# If the user selected "update", send a PUT request to update an existing row
elif action == "update":
    with open(f'{json_path}update.json', 'r') as f:
        data = json.load(f)
    url = f"{base_url}/update"
    response = requests.put(url, json=data)
    if response.status_code == 200:
        print("Row updated successfully.")
    else:
        print(f"Failed to update row. Error message: {response.text}")

# If the user selected "delete", send a DELETE request to delete an existing row
elif action == "delete":
    with open(f'{json_path}delete.json', 'r') as f:
        data = json.load(f)
    url = f"{base_url}/delete"
    response = requests.delete(url, json=data)
    if response.status_code == 200:
        print("Row deleted successfully.")
    else:
        print(f"Failed to delete row. Error message: {response.text}")

# If the user entered an invalid action, print an error message
else:
    print(f"Invalid action: {action}. Please enter add, delete, or update.")
