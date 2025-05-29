-- Table: Venue
CREATE TABLE Venue (
    venue_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(150),
    city VARCHAR(50),
    country VARCHAR(50),
    whatsapp VARCHAR(20),
    instagram_user VARCHAR(100),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    venue_type VARCHAR(50)
);

-- Table: Event
CREATE TABLE Event (
    event_id INT PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    description TEXT,
    datetime DATETIME NOT NULL,
    cost DECIMAL(10,2),
    venue_id INT NOT NULL,
    capacity INT,
    is_recurring BOOLEAN,
    category VARCHAR(50),
    ticket_link TEXT,
    is_featured BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (venue_id) REFERENCES Venue(venue_id)
);

-- Table: User
CREATE TABLE User (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL
);

-- Table: Favorite (users saving favorite events)
CREATE TABLE Favorite (
    user_id INT,
    event_id INT,
    PRIMARY KEY (user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
);
