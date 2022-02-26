import psycopg2
import os

conn = psycopg2.connect("postgresql://shop_member:tasty@localhost/food_shop")
cur = conn.cursor()

customer_file = open('/workspace/postgres/prj_data/customers.csv')
food_file = open('/workspace/postgres/prj_data/food.csv')
food_suppliers_file = open('/workspace/postgres/prj_data/food_suppliers.csv')
orders_file = open('/workspace/postgres/prj_data/orders.csv')

truncate_statement = 'TRUNCATE TABLE orders CASCADE;\
                        TRUNCATE TABLE food CASCADE;\
                        TRUNCATE TABLE food_suppliers CASCADE;\
                        TRUNCATE TABLE customers CASCADE;'
cur.execute(truncate_statement)

# Inserting data from csv into customers
sql = "COPY customers FROM stdin CSV header;"
cur.copy_expert(sql, customer_file)
sql = "COPY food_suppliers FROM stdin CSV header;"
cur.copy_expert(sql, food_suppliers_file)
sql = "COPY food FROM stdin CSV header;"
cur.copy_expert(sql, food_file)
sql = "COPY orders FROM stdin CSV header;"
cur.copy_expert(sql, orders_file)  

print("Please enter a Customer ID from 0-6")

customer_id = int(input())
cur.execute("""
    select order_id,CustomerName,f.name as food,quantity,street_address,city,state,zip,phone 
    from (SELECT order_id,food_id, c.customer_id,quantity,c.name as CustomerName,street_address,city,state,zip,phone 
    FROM orders o 
    inner join customers c on o.customer_id = c.customer_id ) as t  
    inner join food f on t.food_id = f.food_id 
    where customer_id in (%s);
""", (customer_id,));

for row in cur:
    print("Deliver {} {} to {} at {} {} {} {}".format(row[3], row[2],row[1],row[4],row[5],row[6],row[7]))
    
cur.close()
conn.close()
