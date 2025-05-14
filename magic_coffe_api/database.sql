-- Baristalar tablosu
CREATE TABLE baristas (
    barista_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    specialty VARCHAR(100),
    branch_id INT,
    image_url VARCHAR(255),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- Siparişler tablosu
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    branch_id INT,
    card_id INT,
    barista_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10,2),
    status VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
    FOREIGN KEY (card_id) REFERENCES credit_cards(card_id),
    FOREIGN KEY (barista_id) REFERENCES baristas(barista_id)
); 