DROP DATABASE IF EXISTS freelancer_marketplace;
CREATE DATABASE freelancer_marketplace;
USE freelancer_marketplace;

-- Core user authentication and role management
CREATE TABLE User (
    user_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    role ENUM('ADMIN','CLIENT','FREELANCER') NOT NULL
);

CREATE TABLE Admin (
    admin_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Client (
    client_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    type ENUM('INDIVIDUAL','ORGANIZATION'),
    company VARCHAR(100), -- NULL for individual clients
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Freelancer (
    fl_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    bio TEXT,
    rate DECIMAL(10,2), -- Hourly or project rate
    availability VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Skills and freelancer expertise
CREATE TABLE Skill (
    skill_id INT PRIMARY KEY,
    skill_name VARCHAR(100),
    skill_type VARCHAR(100),
    description TEXT
);

CREATE TABLE Freelancer_Skill (
    fl_id INT,
    skill_id INT,
    PRIMARY KEY (fl_id, skill_id),
    FOREIGN KEY (fl_id) REFERENCES Freelancer(fl_id),
    FOREIGN KEY (skill_id) REFERENCES Skill(skill_id)
);

-- Project workflow: Project -> Proposal -> Contract -> Payment
CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    description TEXT,
    budget DECIMAL(12,2) CHECK (budget > 0),
    project_type VARCHAR(50),
    status VARCHAR(30),
    created_at DATETIME,
    FOREIGN KEY (client_id) REFERENCES Client(client_id)
);

CREATE TABLE Proposal (
    proposal_id INT PRIMARY KEY,
    fl_id INT NOT NULL,
    project_id INT NOT NULL,
    proposed_text TEXT,
    proposed_amount DECIMAL(12,2) CHECK (proposed_amount > 0),
    deadline DATE,
    status VARCHAR(30),
    FOREIGN KEY (fl_id) REFERENCES Freelancer(fl_id),
    FOREIGN KEY (project_id) REFERENCES Project(project_id)
);

CREATE TABLE Contract (
    contract_id INT PRIMARY KEY,
    proposal_id INT NOT NULL, -- Links to accepted proposal
    start_date DATE,
    end_date DATE,
    status VARCHAR(30),
    submitted_at DATETIME,
    FOREIGN KEY (proposal_id) REFERENCES Proposal(proposal_id)
);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    contract_id INT NOT NULL,
    amount DECIMAL(12,2) CHECK (amount > 0),
    payment_method VARCHAR(50),
    payment_status VARCHAR(30),
    payment_date DATE,
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id)
);

-- Feedback and dispute resolution
CREATE TABLE Review (
    review_id INT PRIMARY KEY,
    contract_id INT NOT NULL,
    fl_id INT, -- Who is being reviewed
    client_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id),
    FOREIGN KEY (fl_id) REFERENCES Freelancer(fl_id),
    FOREIGN KEY (client_id) REFERENCES Client(client_id)
);

CREATE TABLE Dispute (
    dispute_id INT PRIMARY KEY,
    contract_id INT NOT NULL,
    fl_id INT,
    client_id INT,
    raised_date DATE,
    status VARCHAR(30),
    resolved_at DATE,
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id),
    FOREIGN KEY (fl_id) REFERENCES Freelancer(fl_id),
    FOREIGN KEY (client_id) REFERENCES Client(client_id)
);

-- Performance optimization indexes
CREATE INDEX idx_project_client ON Project(client_id);
CREATE INDEX idx_proposal_project ON Proposal(project_id);
CREATE INDEX idx_proposal_freelancer ON Proposal(fl_id);
CREATE INDEX idx_contract_proposal ON Contract(proposal_id);
CREATE INDEX idx_payment_contract ON Payment(contract_id);

-- Sample data for testing
INSERT INTO User VALUES
(1,'Amit','amit@gmail.com','9999990001','pass','CLIENT'),
(2,'Rohit','rohit@gmail.com','9999990002','pass','FREELANCER'),
(3,'Neha','neha@gmail.com','9999990003','pass','FREELANCER'),
(4,'Admin1','admin@gmail.com','9999990004','pass','ADMIN');

INSERT INTO Client VALUES
(1,1,'INDIVIDUAL',NULL);

INSERT INTO Freelancer VALUES
(1,2,'Backend Developer',800,'Available'),
(2,3,'UI/UX Designer',700,'Available');

INSERT INTO Admin VALUES
(1,4,TRUE);

INSERT INTO Skill VALUES
(1,'Java','Programming','Backend development'),
(2,'UI/UX','Design','User interface design'),
(3,'MySQL','Database','Database management');

INSERT INTO Freelancer_Skill VALUES
(1,1),
(1,3),
(2,2);

INSERT INTO Project VALUES
(1,1,'E-commerce Web Application',50000,'Web','OPEN',NOW());

INSERT INTO Proposal VALUES
(1,1,1,'I can deliver backend efficiently',45000,'2025-03-01','SUBMITTED'),
(2,2,1,'I will design UI screens',30000,'2025-03-05','SUBMITTED');

INSERT INTO Contract VALUES
(1,1,'2025-03-02','2025-04-02','ACTIVE',NOW());

INSERT INTO Payment VALUES
(1,1,45000,'UPI','COMPLETED','2025-04-05');

INSERT INTO Review VALUES
(1,1,1,1,5,'Great client, clear requirements');

INSERT INTO Dispute VALUES
(1,1,1,1,'2025-03-15','RESOLVED','2025-03-18');

SELECT * FROM User;
SELECT * FROM Project;
SELECT * FROM Proposal;
SELECT * FROM Contract;
SELECT * FROM Payment;