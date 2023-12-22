# Necessary module import
!pip install mysql-connector-python
import mysql.connector as connector

# Establishing connection to the database
connection = connector.connect(user="dvilla", password="little_lemon@123!", db="littlelemondb")
cursor = connection.cursor()

# Query to show all tables in the database
show_tables_query = "SHOW tables"
cursor.execute(show_tables_query)
results = cursor.fetchall()

# Printing the tables in the database
for row in results:
    print(row)

# Query to select specific data from customers and orders
query_stmt = """
SELECT Customers.FullName, Customers.ContactNumber, Orders.TotalCost AS `BillAmount`
FROM Customers
JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.TotalCost > 60;
"""
cursor.execute(query_stmt)
results = cursor.fetchall()

# Printing the results
print(cursor.column_names)
for row in results:
    print(row)

# Closing the cursor and the connection
cursor.close()
connection.close()
