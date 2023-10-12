CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table to manage brewery employees
CREATE TABLE users (
    user_id UUID DEFAULT uuid_generate_v4(),
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (user_id)
);

-- Brewery table to store brewery information
CREATE TABLE brewery (
    brewery_id UUID DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (brewery_id)
);

-- Beer table to store information about different types of beer
CREATE TABLE beer (
    beer_id UUID DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    style VARCHAR(255),
    brewery_id UUID REFERENCES brewery(brewery_id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (beer_id)
);

-- Customers table to manage customer information
CREATE TABLE customers (
    customer_id UUID DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (customer_id)
);

-- Suppliers table to manage supplier information
CREATE TABLE suppliers (
    supplier_id UUID DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (supplier_id)
);

-- Orders table to track customer orders
CREATE TABLE orders (
    order_id UUID DEFAULT uuid_generate_v4(),
    customer_name VARCHAR(255) NOT NULL,
    order_date DATE,
    beer_id UUID REFERENCES beer(beer_id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (order_id)
);

-- Inventory table to manage brewery inventory
CREATE TABLE inventory (
    inventory_id UUID DEFAULT uuid_generate_v4(),
    beer_id UUID REFERENCES beer(beer_id),
    quantity INT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (inventory_id)
);

-- Transactions table to track financial transactions
CREATE TABLE transactions (
    transaction_id UUID DEFAULT uuid_generate_v4(),
    transaction_date DATE,
    description TEXT,
    amount DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (transaction_id)
);

-- Employee roles table to manage roles within the brewery
CREATE TABLE employee_roles (
    role_id UUID DEFAULT uuid_generate_v4(),
    role_name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (role_id)
);

-- Employee details table to store additional employee information
CREATE TABLE employee_details (
    employee_id UUID DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(user_id),
    role_id UUID REFERENCES employee_roles(role_id),
    hire_date DATE,
    salary DECIMAL(12, 2),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (employee_id)
);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updating updated_at on table updates
CREATE TRIGGER users_updated_trigger
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER brewery_updated_trigger
BEFORE UPDATE ON brewery
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER beer_updated_trigger
BEFORE UPDATE ON beer
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER customers_updated_trigger
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER suppliers_updated_trigger
BEFORE UPDATE ON suppliers
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER orders_updated_trigger
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER inventory_updated_trigger
BEFORE UPDATE ON inventory
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER transactions_updated_trigger
BEFORE UPDATE ON transactions
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER employee_roles_updated_trigger
BEFORE UPDATE ON employee_roles
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER employee_details_updated_trigger
BEFORE UPDATE ON employee_details
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
