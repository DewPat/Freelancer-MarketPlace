DROP DATABASE IF EXISTS freelancer_marketplace;
CREATE DATABASE freelancer_marketplace;
USE freelancer_marketplace;

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
    company VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Freelancer (
    fl_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    bio TEXT,
    rate DECIMAL(10,2),
    availability VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

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
    proposal_id INT NOT NULL,
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

CREATE TABLE Review (
    review_id INT PRIMARY KEY,
    contract_id INT NOT NULL,
    fl_id INT,
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

CREATE INDEX idx_project_client ON Project(client_id);
CREATE INDEX idx_proposal_project ON Proposal(project_id);
CREATE INDEX idx_proposal_freelancer ON Proposal(fl_id);
CREATE INDEX idx_contract_proposal ON Contract(proposal_id);
CREATE INDEX idx_payment_contract ON Payment(contract_id);

INSERT INTO User VALUES
(1,'Amit Patel','amit.patel@gmail.com','9000000001','amit@123','CLIENT'),
(2,'Riya Sharma','riya.sharma@gmail.com','9000000002','riya@234','CLIENT'),
(3,'Karan Mehta','karan.mehta@gmail.com','9000000003','karan@345','CLIENT'),
(4,'Sneha Iyer','sneha.iyer@gmail.com','9000000004','sneha@456','CLIENT'),
(5,'Rahul Verma','rahul.verma@gmail.com','9000000005','rahul@567','CLIENT'),
(6,'Ananya Gupta','ananya.gupta@gmail.com','9000000006','ananya@678','CLIENT'),
(7,'Vikram Singh','vikram.singh@gmail.com','9000000007','vikram@789','CLIENT'),
(8,'Pooja Nair','pooja.nair@gmail.com','9000000008','pooja@890','CLIENT'),
(9,'Arjun Malhotra','arjun.m@gmail.com','9000000009','arjun@901','CLIENT'),
(10,'Neha Kapoor','neha.k@gmail.com','9000000010','neha@012','CLIENT'),
(11,'Rohit Kulkarni','rohit.k@gmail.com','9000000011','rohit@111','FREELANCER'),
(12,'Sahil Jain','sahil.j@gmail.com','9000000012','sahil@222','FREELANCER'),
(13,'Nisha Desai','nisha.d@gmail.com','9000000013','nisha@333','FREELANCER'),
(14,'Akash Choudhary','akash.c@gmail.com','9000000014','akash@444','FREELANCER'),
(15,'Priya Banerjee','priya.b@gmail.com','9000000015','priya@555','FREELANCER'),
(16,'Aditya Rao','aditya.r@gmail.com','9000000016','aditya@666','FREELANCER'),
(17,'Mehul Shah','mehul.s@gmail.com','9000000017','mehul@777','FREELANCER'),
(18,'Kavita Joshi','kavita.j@gmail.com','9000000018','kavita@888','FREELANCER'),
(19,'Suresh Yadav','suresh.y@gmail.com','9000000019','suresh@999','FREELANCER'),
(20,'Tanvi Kulkarni','tanvi.k@gmail.com','9000000020','tanvi@000','FREELANCER'),
(21,'Neeraj Mishra','neeraj.admin@gmail.com','9000000021','admin@pass','ADMIN'),
(22,'Ayush Mishra','ayush.admin@gmail.com','9000000022','admin@pass','ADMIN');

INSERT INTO Client VALUES
(1,1,'INDIVIDUAL',NULL),
(2,2,'INDIVIDUAL',NULL),
(3,3,'ORGANIZATION','Mehta Solutions'),
(4,4,'INDIVIDUAL',NULL),
(5,5,'ORGANIZATION','Verma Tech'),
(6,6,'INDIVIDUAL',NULL),
(7,7,'INDIVIDUAL',NULL),
(8,8,'ORGANIZATION','Nair Designs'),
(9,9,'INDIVIDUAL',NULL),
(10,10,'INDIVIDUAL',NULL);

INSERT INTO Freelancer VALUES
(1,11,'Java Backend Developer',900,'Available'),
(2,12,'React Frontend Developer',850,'Available'),
(3,13,'UI/UX Designer',700,'Available'),
(4,14,'Database Engineer',950,'Busy'),
(5,15,'Python Developer',800,'Available'),
(6,16,'Full Stack Developer',880,'Available'),
(7,17,'Machine Learning Engineer',1000,'Busy'),
(8,18,'DevOps Engineer',920,'Available'),
(9,19,'Android App Developer',780,'Available'),
(10,20,'QA and Automation Engineer',650,'Available');

INSERT INTO Admin VALUES
(1,21,TRUE),
(2,22,TRUE);

INSERT INTO Skill VALUES
(1,'Java','Programming','Backend'),
(2,'React','Frontend','UI Development'),
(3,'Python','Programming','Scripting'),
(4,'MySQL','Database','Relational DB'),
(5,'UI/UX','Design','User Experience');

INSERT INTO Freelancer_Skill VALUES
(1,1),(1,4),(2,2),(3,5),(4,4),(5,3),(6,2),(7,3),(8,4),(9,1),(10,5);

INSERT INTO Project VALUES
(1,1,'Web Application Development',50000,'Web','OPEN',NOW()),
(2,2,'Mobile UI Design',30000,'Mobile','OPEN',NOW()),
(3,3,'Database Optimization',25000,'Database','OPEN',NOW()),
(4,4,'Backend API Development',40000,'Web','OPEN',NOW()),
(5,5,'Automated Testing Suite',20000,'QA','OPEN',NOW()),
(6,6,'Machine Learning Model',70000,'AI','OPEN',NOW()),
(7,7,'Cloud Infrastructure Setup',45000,'DevOps','OPEN',NOW()),
(8,8,'Android Application',60000,'Mobile','OPEN',NOW()),
(9,9,'Dashboard UI Design',35000,'Web','OPEN',NOW()),
(10,10,'Automation Scripts',30000,'Scripting','OPEN',NOW());

INSERT INTO Proposal VALUES
(1,1,1,'Experienced backend developer',48000,'2025-03-01','SUBMITTED'),
(2,2,2,'Modern React UI',28000,'2025-03-02','SUBMITTED'),
(3,4,3,'Database tuning expert',23000,'2025-03-03','SUBMITTED'),
(4,5,4,'Scalable API development',38000,'2025-03-04','SUBMITTED'),
(5,10,5,'QA automation setup',19000,'2025-03-05','SUBMITTED'),
(6,7,6,'ML pipeline creation',65000,'2025-03-06','SUBMITTED'),
(7,8,7,'AWS infrastructure',42000,'2025-03-07','SUBMITTED'),
(8,9,8,'Android development',58000,'2025-03-08','SUBMITTED');

INSERT INTO Contract VALUES
(1,1,'2025-03-10','2025-04-10','ACTIVE',NOW()),
(2,2,'2025-03-11','2025-04-01','ACTIVE',NOW()),
(3,3,'2025-03-12','2025-04-05','ACTIVE',NOW());

INSERT INTO Payment VALUES
(1,1,48000,'UPI','COMPLETED','2025-04-11'),
(2,2,28000,'CARD','COMPLETED','2025-04-02'),
(3,3,23000,'NETBANKING','COMPLETED','2025-04-06');

SELECT COUNT(*) FROM User;
SELECT COUNT(*) FROM Client;
SELECT COUNT(*) FROM Freelancer;
SELECT COUNT(*) FROM Admin;
