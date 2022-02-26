CREATE DATABASE food_shop;
CREATE USER shop_member WITH PASSWORD 'tasty';
GRANT ALL PRIVILEGES ON DATABASE food_shop to shop_member;
\c food_shop

CREATE TABLE food_suppliers (
  supplier_id INTEGER NOT NULL,
  name            VARCHAR(128) NOT NULL,
  street_address  VARCHAR(256) NOT NULL,
  city            VARCHAR(64) NOT NULL,
  state           VARCHAR(32) NOT NULL,
  zip             VARCHAR(16) NOT NULL,
  phone           VARCHAR(16) NOT NULL,
  PRIMARY KEY     ( supplier_id )
);

CREATE TABLE customers (
  customer_id     INTEGER NOT NULL,
  name            VARCHAR(128) NOT NULL,
  street_address  VARCHAR(256) NOT NULL,
  city            VARCHAR(64) NOT NULL,
  state           VARCHAR(32) NOT NULL,
  zip             VARCHAR(16) NOT NULL,
  phone           VARCHAR(16) NOT NULL,
  PRIMARY KEY     ( customer_id )
);

CREATE TABLE food (
  food_id         INTEGER NOT NULL,
  name            VARCHAR(128) NOT NULL,
  description     TEXT NOT NULL,
  supplier_id INTEGER NOT NULL,
  PRIMARY KEY ( food_id ),
  CONSTRAINT fk_supplier FOREIGN KEY (supplier_id) REFERENCES food_suppliers(supplier_id)
);

CREATE TABLE orders (
  order_id        INTEGER NOT NULL,
  food_id         INTEGER NOT NULL,
  customer_id     INTEGER NOT NULL,
  quantity        INTEGER NOT NULL,
  PRIMARY KEY ( order_id, customer_id, food_id ),
  CONSTRAINT fk_food FOREIGN KEY (food_id) REFERENCES food(food_id), 
  CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

GRANT ALL PRIVILEGES ON food_suppliers, customers, food, orders TO shop_member;