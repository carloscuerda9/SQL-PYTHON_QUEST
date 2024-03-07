USE bicicletas;

-- Agrega un índice
CREATE INDEX idx_brands_brand_id ON brands(brand_id);
CREATE INDEX idx_categories_category_id ON categories(category_id);
CREATE INDEX idx_customers_customer_id ON customers(customer_id);
CREATE INDEX idx_orders_order_id ON orders(order_id);
CREATE INDEX idx_products_product_id ON products(product_id);
CREATE INDEX idx_staffs_store_id ON staffs(store_id);
CREATE INDEX idx_stocks_product_id ON stocks(product_id);
CREATE INDEX idx_stores_store_id ON stores(store_id);

-- Agrega la clave foránea a la tabla products
ALTER TABLE products
ADD CONSTRAINT fk_products_brands FOREIGN KEY (brand_id) REFERENCES brands(brand_id);

-- Products, Stocks y Order_Items
ALTER TABLE stocks
ADD CONSTRAINT fk_stocks_products FOREIGN KEY (product_id) REFERENCES products(product_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_products FOREIGN KEY (product_id) REFERENCES products(product_id);

-- Products y Categories
ALTER TABLE products
ADD CONSTRAINT fk_products_categories FOREIGN KEY (category_id) REFERENCES categories(category_id);

-- Order_Items y Orders
ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_orders FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- Orders y Customers
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

-- Staffs, Orders y Stores
ALTER TABLE staffs
ADD CONSTRAINT fk_staffs_stores FOREIGN KEY (store_id) REFERENCES stores(store_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_stores FOREIGN KEY (store_id) REFERENCES stores(store_id);

-- Numero de registros por cada tabla
SELECT 'brands' AS table_name, COUNT(*) AS record_count FROM brands
UNION
SELECT 'categories' AS table_name, COUNT(*) AS record_count FROM categories
UNION
SELECT 'customers' AS table_name, COUNT(*) AS record_count FROM customers
UNION
SELECT 'order_items' AS table_name, COUNT(*) AS record_count FROM order_items
UNION
SELECT 'orders' AS table_name, COUNT(*) AS record_count FROM orders
UNION
SELECT 'products' AS table_name, COUNT(*) AS record_count FROM products
UNION
SELECT 'staffs' AS table_name, COUNT(*) AS record_count FROM staffs
UNION
SELECT 'stocks' AS table_name, COUNT(*) AS record_count FROM stocks
UNION
SELECT 'stores' AS table_name, COUNT(*) AS record_count FROM stores;

-- Cantidad total productos por marca
SELECT brands.brand_id, brands.brand_name, 
COUNT(*) AS total_products
FROM brands
JOIN products ON brands.brand_id = products.brand_id
GROUP BY brands.brand_id, brands.brand_name;

-- Categorías con mas productos
SELECT c.category_id, c.category_name, COUNT(p.product_id) AS total_products
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_products DESC;

-- Promedio de productos por pedido 
SELECT AVG(order_item_count) AS average_products_per_order
FROM (
    SELECT orders.order_id, COUNT(order_items.product_id) AS order_item_count
    FROM orders
    LEFT JOIN order_items ON orders.order_id = order_items.order_id
    GROUP BY orders.order_id
) AS order_product_counts;

-- Ventas por marca
SELECT brands.brand_id, brands.brand_name, 
       SUM(order_items.quantity) AS total_sales
FROM brands
JOIN products ON brands.brand_id = products.brand_id
JOIN order_items ON products.product_id = order_items.product_id
GROUP BY brands.brand_id, brands.brand_name
ORDER BY total_sales DESC;

-- Productos más vendidos
SELECT products.product_id, products.product_name, 
       SUM(order_items.quantity) AS total_sales
FROM products
JOIN order_items ON products.product_id = order_items.product_id
GROUP BY products.product_id, products.product_name
ORDER BY total_sales DESC;

-- Clientes más frecuentes
SELECT customers.customer_id, customers.first_name, 
       COUNT(orders.order_id) AS total_orders
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.first_name
ORDER BY total_orders DESC;

-- Productos con bajo stock
SELECT products.product_id, products.product_name, stocks.quantity
FROM products
JOIN stocks ON products.product_id = stocks.product_id
WHERE stocks.quantity < 10;

-- Tiendas más activas por cantidad de pedidos
SELECT stores.store_id, stores.store_name, 
       COUNT(orders.order_id) AS total_orders
FROM stores
LEFT JOIN orders ON stores.store_id = orders.store_id
GROUP BY stores.store_id, stores.store_name
ORDER BY total_orders DESC;

-- Ingresos por categoría
SELECT categories.category_id, categories.category_name, 
       SUM(order_items.quantity * order_items.list_price) AS total_revenue
FROM categories
LEFT JOIN products ON categories.category_id = products.category_id
LEFT JOIN order_items ON products.product_id = order_items.product_id
GROUP BY categories.category_id, categories.category_name
ORDER BY total_revenue DESC;








