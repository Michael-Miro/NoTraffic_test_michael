-- drop foreign key constraints
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'fk_orders_reference_customer' AND table_name = 'orders'
    )
    THEN
        ALTER TABLE "orders"
        DROP CONSTRAINT fk_orders_reference_customer;
    END IF;
    
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'fk_ordersite_reference_orders' AND table_name = 'ordersitem'
    )
    THEN
        ALTER TABLE ordersitem
        DROP CONSTRAINT fk_ordersite_reference_orders;
    END IF;
    
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'fk_ordersite_reference_product' AND table_name = 'ordersitem'
    )
    THEN
        ALTER TABLE ordersitem
        DROP CONSTRAINT fk_ordersite_reference_product;
    END IF;
    
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'fk_product_reference_supplier' AND table_name = 'product'
    )
    THEN
        ALTER TABLE product
        DROP CONSTRAINT fk_product_reference_supplier;
    END IF;
END $$;

-- drop indexes and tables
DROP INDEX IF EXISTS idx_customer_name;
DROP TABLE IF EXISTS customer CASCADE;
DROP INDEX IF EXISTS idx_orders_orders_date;
DROP INDEX IF EXISTS idx_orders_customer_id;
DROP TABLE IF EXISTS "orders" CASCADE;
DROP INDEX IF EXISTS idx_ordersitem_product_id;
DROP INDEX IF EXISTS idx_ordersitem_orders_id;
DROP TABLE IF EXISTS ordersitem CASCADE;
DROP INDEX IF EXISTS idx_product_name;
DROP INDEX IF EXISTS idx_product_supplier_id;
DROP TABLE IF EXISTS product CASCADE;
DROP INDEX IF EXISTS idx_supplier_country;
DROP INDEX IF EXISTS idx_supplier_name;
DROP TABLE IF EXISTS supplier CASCADE;

-- Table: Customer
CREATE TABLE Customer (
   Id                   SERIAL PRIMARY KEY,
   FirstName            VARCHAR(40) NOT NULL,
   LastName             VARCHAR(40) NOT NULL,
   City                 VARCHAR(40),
   Country              VARCHAR(40),
   Phone                VARCHAR(20)
);

-- Index: IndexCustomerName
CREATE INDEX IndexCustomerName ON Customer (LastName ASC, FirstName ASC);

-- Table: "orders"
CREATE TABLE "orders" (
   Id                   SERIAL PRIMARY KEY,
   ordersDate            TIMESTAMP NOT NULL DEFAULT NOW(),
   ordersNumber          VARCHAR(10),
   CustomerId           INTEGER NOT NULL,
   TotalAmount          DECIMAL(12,2) DEFAULT 0
);

-- Index: IndexordersCustomerId
CREATE INDEX IndexordersCustomerId ON "orders" (CustomerId ASC);

-- Index: IndexordersDate
CREATE INDEX IndexordersDate ON "orders" (ordersDate ASC);

-- Table: ordersItem
CREATE TABLE ordersItem (
   Id                   SERIAL PRIMARY KEY,
   ordersId              INTEGER NOT NULL,
   ProductId            INTEGER NOT NULL,
   UnitPrice            DECIMAL(12,2) NOT NULL DEFAULT 0,
   Quantity             INTEGER NOT NULL DEFAULT 1
);

-- Index: IndexordersItemordersId
CREATE INDEX IndexordersItemordersId ON ordersItem (ordersId ASC);

-- Index: IndexordersItemProductId
CREATE INDEX IndexordersItemProductId ON ordersItem (ProductId ASC);

-- Table: Product
CREATE TABLE Product (
   Id                   SERIAL PRIMARY KEY,
   ProductName          VARCHAR(50) NOT NULL,
   SupplierId           INTEGER NOT NULL,
   UnitPrice            DECIMAL(12,2) DEFAULT 0,
   Package              VARCHAR(30),
   IsDiscontinued       INTEGER NOT NULL DEFAULT 0 CHECK (IsDiscontinued IN (0, 1))
);

-- Index: IndexProductSupplierId
CREATE INDEX IndexProductSupplierId ON Product (SupplierId ASC);

-- Index: IndexProductName
CREATE INDEX IndexProductName ON Product (ProductName ASC);

-- Table: Supplier
CREATE TABLE Supplier (
   Id                   SERIAL PRIMARY KEY,
   CompanyName          VARCHAR(40) NOT NULL,
   ContactName          VARCHAR(50),
   ContactTitle         VARCHAR(40),
   City                 VARCHAR(40),
   Country              VARCHAR(40),
   Phone                VARCHAR(30),
   Fax                  VARCHAR(30)
);

-- Index: IndexSupplierName
CREATE INDEX IndexSupplierName ON Supplier (CompanyName ASC);

-- Index: IndexSupplierCountry
CREATE INDEX IndexSupplierCountry ON Supplier (Country ASC);

-- Foreign Key constraints
ALTER TABLE "orders" ADD CONSTRAINT FK_orders_REFERENCE_CUSTOMER FOREIGN KEY (CustomerId) REFERENCES Customer(Id);
ALTER TABLE ordersItem ADD CONSTRAINT FK_ordersITE_REFERENCE_orders FOREIGN KEY (ordersId) REFERENCES "orders"(Id);
ALTER TABLE ordersItem ADD CONSTRAINT FK_ordersITE_REFERENCE_PRODUCT FOREIGN KEY (ProductId) REFERENCES Product(Id);
ALTER TABLE Product ADD CONSTRAINT FK_PRODUCT_REFERENCE_SUPPLIER FOREIGN KEY (SupplierId) REFERENCES Supplier(Id);

