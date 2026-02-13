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
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Client (
    client_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    type ENUM('INDIVIDUAL','ORGANIZATION'),
    company VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Freelancer (
    fl_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    bio TEXT,
    rate DECIMAL(10,2),
    availability VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE
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
    FOREIGN KEY (fl_id) REFERENCES Freelancer(fl_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES Skill(skill_id) ON DELETE CASCADE
);

CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    description TEXT,
    budget DECIMAL(12,2) CHECK (budget > 0),
    project_type VARCHAR(50),
    status ENUM('OPEN','IN_PROGRESS','COMPLETED','CANCELLED'),
    created_at DATETIME,
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE CASCADE
);

CREATE TABLE Proposal (
    proposal_id INT PRIMARY KEY,
    fl_id INT NOT NULL,
    project_id INT NOT NULL,
    proposed_text TEXT,
    proposed_amount DECIMAL(12,2) CHECK (proposed_amount > 0),
    deadline DATE,
    status ENUM('SUBMITTED','ACCEPTED','REJECTED'),
    UNIQUE (fl_id, project_id),
    FOREIGN KEY (fl_id) REFERENCES Freelancer(fl_id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES Project(project_id) ON DELETE CASCADE
);

CREATE TABLE Contract (
    contract_id INT PRIMARY KEY,
    proposal_id INT NOT NULL,
    start_date DATE,
    end_date DATE,
    status ENUM('ACTIVE','COMPLETED','TERMINATED'),
    submitted_at DATETIME,
    FOREIGN KEY (proposal_id) REFERENCES Proposal(proposal_id) ON DELETE CASCADE
);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    contract_id INT NOT NULL,
    amount DECIMAL(12,2) CHECK (amount > 0),
    payment_method VARCHAR(50),
    payment_status ENUM('PENDING','COMPLETED','FAILED'),
    payment_date DATE,
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id) ON DELETE CASCADE
);

CREATE TABLE Review (
    review_id INT PRIMARY KEY,
    contract_id INT NOT NULL,
    fl_id INT,
    client_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id) ON DELETE CASCADE,
    FOREIGN KEY (fl_id) REFERENCES Freelancer(fl_id) ON DELETE SET NULL,
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE SET NULL
);

CREATE TABLE Dispute (
    dispute_id INT PRIMARY KEY,
    contract_id INT NOT NULL,
    fl_id INT,
    client_id INT,
    raised_date DATE,
    status ENUM('OPEN','RESOLVED'),
    resolved_at DATE,
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id) ON DELETE CASCADE,
    FOREIGN KEY (fl_id) REFERENCES Freelancer(fl_id) ON DELETE SET NULL,
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE SET NULL
);

CREATE INDEX idx_project_client ON Project(client_id);
CREATE INDEX idx_proposal_project ON Proposal(project_id);
CREATE INDEX idx_proposal_freelancer ON Proposal(fl_id);
CREATE INDEX idx_contract_proposal ON Contract(proposal_id);
CREATE INDEX idx_payment_contract ON Payment(contract_id);
CREATE INDEX idx_review_fl ON Review(fl_id);


INSERT INTO User VALUES
(1,'Amit','amit@gmail.com','9999990001','pass','CLIENT'),
(2,'Rohit','rohit@gmail.com','9999990002','pass','FREELANCER'),
(3,'Neha','neha@gmail.com','9999990003','pass','FREELANCER'),
(4,'Admin1','admin@gmail.com','9999990004','pass','ADMIN'),
(5,'Rahul Sharma','rahul@gmail.com','9999990005','rahul@123','CLIENT'),
(6,'Priya Verma','priya@gmail.com','9999990006','priya@123','CLIENT'),
(7,'Karan Mehta','karan@gmail.com','9999990007','karan@123','CLIENT'),
(8,'Sneha Iyer','sneha@gmail.com','9999990008','sneha@123','CLIENT'),
(9,'Arjun Kapoor','arjun@gmail.com','9999990009','arjun@123','FREELANCER'),
(10,'Meera Nair','meera@gmail.com','9999990010','meera@123','FREELANCER'),
(11,'Kabir Khan','kabir@gmail.com','9999990011','kabir@123','FREELANCER'),
(12,'Ananya Das','ananya@gmail.com','9999990012','ananya@123','FREELANCER'),
(13,'Vikram Singh','vikram@gmail.com','9999990013','vikram@123','ADMIN'),
(14,'Pooja Gupta','pooja@gmail.com','9999990014','pooja@123','CLIENT'),
(15,'Rohan Patel','rohan@gmail.com','9999990015','rohan@123','FREELANCER'),
(16,'Neeraj Joshi','neeraj@gmail.com','9999990016','neeraj@123','CLIENT'),
(17,'Saurabh Mishra','saurabh@gmail.com','9999990017','saurabh@17','CLIENT'),
(18,'Ayesha Khan','ayesha@gmail.com','9999990018','ayesha@18','CLIENT'),
(19,'Manish Agarwal','manish@gmail.com','9999990019','manish@19','CLIENT'),
(20,'Nitin Malhotra','nitin@gmail.com','9999990020','nitin@20','CLIENT'),
(21,'Shubham Jain','shubham@gmail.com','9999990021','shubham@21','FREELANCER'),
(22,'Ritika Sen','ritika@gmail.com','9999990022','ritika@22','FREELANCER'),
(23,'Aditya Rao','aditya@gmail.com','9999990023','aditya@23','FREELANCER'),
(24,'Simran Kaur','simran@gmail.com','9999990024','simran@24','FREELANCER'),
(25,'Varun Bansal','varun@gmail.com','9999990025','varun@25','FREELANCER'),
(26,'Admin Rohit','admin_rohit@gmail.com','9999990026','admin@26','ADMIN'),
(27,'Kriti Malhotra','kriti@gmail.com','9999990027','kriti@27','CLIENT'),
(28,'Abhishek Yadav','abhishek@gmail.com','9999990028','abhishek@28','CLIENT'),
(29,'Ramesh Kulkarni','ramesh@gmail.com','9999990029','ramesh@29','CLIENT'),
(30,'Siddharth Bose','siddharth@gmail.com','9999990030','sid@30','FREELANCER'),
(31,'Neelam Chawla','neelam@gmail.com','9999990031','neelam@31','FREELANCER'),
(32,'Harsh Vardhan','harsh@gmail.com','9999990032','harsh@32','FREELANCER'),
(33,'Tanvi Kulkarni','tanvi@gmail.com','9999990033','tanvi@33','FREELANCER'),
(34,'Admin Kavya','admin_kavya@gmail.com','9999990034','admin@34','ADMIN'),
(35,'Ishaan Arora','ishaan@gmail.com','9999990035','ishaan@35','CLIENT'),
(36,'Payal Deshpande','payal@gmail.com','9999990036','payal@36','CLIENT'),
(37,'Aman Tiwari','aman@gmail.com','9999990037','aman@37','CLIENT'),
(38,'Rohini Pillai','rohini@gmail.com','9999990038','rohini@38','FREELANCER'),
(39,'Kunal Saxena','kunal@gmail.com','9999990039','kunal@39','FREELANCER'),
(40,'Pankaj Sethi','pankaj@gmail.com','9999990040','pankaj@40','FREELANCER');

INSERT INTO Client VALUES
(1,1,'INDIVIDUAL',NULL),
(2,5,'INDIVIDUAL',NULL),
(3,6,'INDIVIDUAL',NULL),
(4,7,'INDIVIDUAL',NULL),
(5,8,'ORGANIZATION','TechSoft Pvt Ltd'),
(6,14,'INDIVIDUAL',NULL),
(7,16,'ORGANIZATION','DesignCorp'),
(8,17,'INDIVIDUAL',NULL),
(9,18,'INDIVIDUAL',NULL),
(10,19,'ORGANIZATION','FinEdge Pvt Ltd'),
(11,20,'INDIVIDUAL',NULL),
(12,27,'INDIVIDUAL',NULL),
(13,28,'ORGANIZATION','EduSmart'),
(14,29,'INDIVIDUAL',NULL),
(15,35,'INDIVIDUAL',NULL),
(16,36,'ORGANIZATION','HealthPlus'),
(17,37,'INDIVIDUAL',NULL);


INSERT INTO Freelancer VALUES
(1,2,'Backend Developer',800,'Available'),
(2,3,'UI/UX Designer',700,'Available'),
(3,9,'Full Stack Developer',900,'Available'),
(4,10,'Mobile App Developer',850,'Available'),
(5,11,'Data Analyst',750,'Busy'),
(6,12,'Graphic Designer',650,'Available'),
(7,15,'DevOps Engineer',950,'Available'),
(8,21,'Frontend Developer',700,'Available'),
(9,22,'Content Writer',600,'Available'),
(10,23,'AI Engineer',1200,'Busy'),
(11,24,'QA Tester',650,'Available'),
(12,25,'Blockchain Developer',1500,'Available'),
(13,30,'Android Developer',800,'Available'),
(14,31,'Business Analyst',900,'Busy'),
(15,32,'Cybersecurity Specialist',1400,'Available'),
(16,33,'UX Researcher',750,'Available'),
(17,38,'Video Editor',650,'Available'),
(18,39,'SEO Specialist',700,'Available'),
(19,40,'Game Developer',1100,'Busy');



INSERT INTO Admin VALUES
(1,4,TRUE),
(2,13,TRUE),
(3,26,TRUE),
(4,34,TRUE);



INSERT INTO Skill VALUES
(1,'Java','Programming','Backend development'),
(2,'UI/UX','Design','User interface design'),
(3,'MySQL','Database','Database management'),
(4,'Python','Programming','Backend scripting'),
(5,'React','Frontend','Web interface'),
(6,'Flutter','Mobile','Cross-platform apps'),
(7,'Photoshop','Design','Graphic editing'),
(8,'SEO','Marketing','Search optimization'),
(9,'Content Writing','Writing','Blogs and articles'),
(10,'Blockchain','Technology','Smart contracts'),
(11,'Cybersecurity','Security','System protection'),
(12,'Video Editing','Media','Post production'),
(13,'Android','Mobile','Native apps'),
(14,'Game Development','Gaming','Unity & Unreal');



INSERT INTO Freelancer_Skill VALUES
(1,1),
(1,3),
(2,2),
(3,1),
(3,5),
(4,6),
(5,3),
(6,7),
(7,4),
(8,5),
(9,9),
(10,4),
(11,3),
(12,10),
(13,13),
(14,3),
(15,11),
(16,7),
(17,12),
(18,8),
(19,14);



INSERT INTO Project VALUES
(1,1,'E-commerce Web Application',50000,'Web','OPEN',NOW()),
(2,2,'Portfolio Website Development',20000,'Web','OPEN',NOW()),
(3,3,'Mobile Shopping App',60000,'Mobile','OPEN',NOW()),
(4,4,'Company Logo Design',8000,'Design','OPEN',NOW()),
(5,5,'Analytics Dashboard',40000,'Data','OPEN',NOW()),
(6,8,'Corporate Website Revamp',30000,'Web','OPEN',NOW()),
(7,9,'SEO Optimization Campaign',15000,'Marketing','OPEN',NOW()),
(8,10,'Blockchain Payment System',120000,'Technology','OPEN',NOW()),
(9,11,'Mobile App Testing',20000,'Testing','OPEN',NOW()),
(10,12,'Content Writing for Blog',10000,'Writing','OPEN',NOW()),
(11,13,'Online Learning Platform',90000,'Web','OPEN',NOW()),
(12,14,'Cybersecurity Audit',60000,'Security','OPEN',NOW()),
(13,15,'Healthcare Portal',85000,'Web','OPEN',NOW()),
(14,16,'Fitness Mobile App',70000,'Mobile','OPEN',NOW()),
(15,17,'Game Level Design',50000,'Gaming','OPEN',NOW());



INSERT INTO Proposal VALUES
(1,1,1,'I can deliver backend efficiently',45000,'2025-03-01','SUBMITTED'),
(2,2,1,'I will design UI screens',30000,'2025-03-05','SUBMITTED'),
(3,3,2,'I will build responsive website',18000,'2025-03-10','SUBMITTED'),
(4,4,3,'Experienced in Flutter apps',55000,'2025-03-15','SUBMITTED'),
(5,6,4,'Creative logo concepts',7000,'2025-03-08','SUBMITTED'),
(6,5,5,'Dashboard with insights',38000,'2025-03-20','SUBMITTED'),
(7,8,6,'Experienced frontend developer',28000,'2025-03-12','SUBMITTED'),
(8,18,7,'SEO strategy with results',14000,'2025-03-14','SUBMITTED'),
(9,12,8,'Blockchain payment expert',110000,'2025-03-25','SUBMITTED'),
(10,11,9,'Manual & automation testing',18000,'2025-03-16','SUBMITTED'),
(11,9,10,'High quality blog articles',9000,'2025-03-10','SUBMITTED'),
(12,10,11,'AI-driven learning platform',85000,'2025-04-01','SUBMITTED'),
(13,15,12,'Complete security audit',58000,'2025-03-28','SUBMITTED'),
(14,3,13,'Healthcare backend system',80000,'2025-04-05','SUBMITTED'),
(15,4,14,'Flutter based fitness app',65000,'2025-03-30','SUBMITTED'),
(16,19,15,'Unity-based level design',48000,'2025-04-10','SUBMITTED');



INSERT INTO Contract VALUES
(1,1,'2025-03-02','2025-04-02','ACTIVE',NOW()),
(2,3,'2025-03-12','2025-04-05','ACTIVE',NOW()),
(3,5,'2025-03-09','2025-03-25','COMPLETED',NOW()),
(4,7,'2025-03-15','2025-04-10','ACTIVE',NOW()),
(5,8,'2025-03-16','2025-03-30','COMPLETED',NOW()),
(6,10,'2025-03-17','2025-03-28','COMPLETED',NOW()),
(7,11,'2025-03-11','2025-03-20','ACTIVE',NOW()),
(8,13,'2025-03-29','2025-04-25','ACTIVE',NOW());


INSERT INTO Payment VALUES
(1,1,45000,'UPI','COMPLETED','2025-04-05'),
(2,2,18000,'CARD','COMPLETED','2025-04-06'),
(3,3,7000,'UPI','COMPLETED','2025-03-26'),
(4,4,28000,'UPI','COMPLETED','2025-04-11'),
(5,5,14000,'CARD','COMPLETED','2025-03-31'),
(6,6,18000,'UPI','COMPLETED','2025-03-29'),
(7,7,9000,'UPI','PENDING',NULL);


INSERT INTO Review VALUES
(1,1,1,1,5,'Great client, clear requirements'),
(2,2,3,2,4,'Good communication and timely work'),
(3,3,6,4,5,'Excellent creativity and fast delivery'),
(4,5,18,9,5,'Outstanding SEO results'),
(5,6,11,11,4,'Testing done thoroughly'),
(6,3,6,4,5,'Highly creative designer'),
(7,4,8,8,4,'Professional and responsive');



INSERT INTO Dispute VALUES
(1,1,1,1,'2025-03-15','RESOLVED','2025-03-18'),
(2,2,3,2,'2025-03-18','OPEN',NULL),
(3,7,9,10,'2025-03-22','OPEN',NULL),
(4,8,15,12,'2025-04-02','RESOLVED','2025-04-06');

SELECT * FROM User;
SELECT * FROM Client;
SELECT * FROM Freelancer;
SELECT * FROM Admin;
SELECT * FROM Project;
SELECT * FROM Proposal;
SELECT * FROM Contract;
SELECT * FROM Payment;
SELECT * FROM Review;
SELECT * FROM Dispute;