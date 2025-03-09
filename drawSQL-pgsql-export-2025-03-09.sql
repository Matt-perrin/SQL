CREATE TABLE "Customers"(
    "Customer_ID" INTEGER NOT NULL,
    "First_name" VARCHAR(255) NOT NULL,
    "Last_name" VARCHAR(255) NOT NULL,
    "Email" VARCHAR(255) NOT NULL,
    "Phone_number" INTEGER NOT NULL
);
ALTER TABLE
    "Customers" ADD PRIMARY KEY("Customer_ID");
CREATE TABLE "Orders"(
    "Order_ID" BIGINT NOT NULL,
    "Customer_ID" BIGINT NOT NULL,
    "Order_date" BIGINT NOT NULL,
    "Total_amount" BIGINT NOT NULL,
    "Order_status" BIGINT NOT NULL
);
ALTER TABLE
    "Orders" ADD PRIMARY KEY("Order_ID");
CREATE TABLE "Products"(
    "Product_ID" INTEGER NOT NULL,
    "Product_name" VARCHAR(255) NOT NULL,
    "Category" VARCHAR(255) NOT NULL,
    "Price" INTEGER NOT NULL,
    "Stock_quantity" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "Products" ADD PRIMARY KEY("Product_ID");
CREATE TABLE "Order_Details"(
    "Order_detail_ID" INTEGER NOT NULL,
    "Order_ID" INTEGER NOT NULL,
    "Product_ID" INTEGER NOT NULL,
    "Quantity" INTEGER NOT NULL,
    "Quantity" INTEGER NOT NULL
);
ALTER TABLE
    "Order_Details" ADD PRIMARY KEY("Order_detail_ID");
CREATE TABLE "Customer_addresses"(
    "Address_ID" INTEGER NOT NULL,
    "Customer_ID" INTEGER NOT NULL,
    "Street_address" VARCHAR(255) NOT NULL,
    "City" VARCHAR(255) NOT NULL,
    "State" VARCHAR(255) NOT NULL,
    "Zip_code" INTEGER NOT NULL
);
ALTER TABLE
    "Customer_addresses" ADD PRIMARY KEY("Address_ID");
ALTER TABLE
    "Orders" ADD CONSTRAINT "orders_customer_id_foreign" FOREIGN KEY("Customer_ID") REFERENCES "Customers"("Customer_ID");
ALTER TABLE
    "Order_Details" ADD CONSTRAINT "order_details_product_id_foreign" FOREIGN KEY("Product_ID") REFERENCES "Products"("Product_ID");
ALTER TABLE
    "Customer_addresses" ADD CONSTRAINT "customer_addresses_customer_id_foreign" FOREIGN KEY("Customer_ID") REFERENCES "Customers"("Customer_ID");
ALTER TABLE
    "Order_Details" ADD CONSTRAINT "order_details_order_id_foreign" FOREIGN KEY("Order_ID") REFERENCES "Orders"("Order_ID");