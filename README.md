# Freelancer Marketplace – Database Systems Project

## Project Overview
The **Freelancer Marketplace** is a database-driven platform designed to connect **clients** seeking professional services with **freelancers** offering verified skills. The system manages the complete project lifecycle — from project posting and proposal submission to contract execution, milestone tracking, payment processing, and mutual reviews.

This project focuses on **conceptual data modeling, relational schema design, SQL querying, transactions, triggers, and application-level database interaction**, simulating a real-world freelancing ecosystem relevant to the Indian startup market.

## Business Objective
With the rapid expansion of startups in India, organizations face challenges in identifying reliable freelancers, managing projects, and ensuring transparent payments. This platform addresses these challenges by:

- Enabling skill-based freelancer discovery
- Managing project execution through milestone-based contracts
- Ensuring secure and transparent payment processing
- Supporting mutual reviews and ratings
- Providing administrative oversight and analytics

---

## Stakeholders
- Freelancers  
- Clients  
- Administrators  
- Platform Owner / Investors  
- Payment Partners  
- Government / Regulatory Authorities  

---

## System Roles and Features

### Freelancer
- Account creation and authentication  
- Portfolio management (bio, hourly rate, experience, projects)  
- Skill addition and management  
- Browsing client-posted projects  
- Proposal submission and contract participation  
- Milestone status tracking  
- Payment receipt upon milestone approval  
- Earnings and payment history tracking  
- Client review submission  

### Client
- Account creation and profile management  
- Project posting with budget, deadline, and required skills  
- Freelancer profile browsing  
- Proposal review and management  
- Contract initiation and milestone definition  
- Payment release and spending history tracking  
- Freelancer review submission  

### Admin
- Secure privileged authentication  
- User and profile verification  
- Monitoring projects, proposals, contracts, and milestones  
- Dispute handling  
- Payment transaction oversight  
- Platform-level analytics and reporting  

---

## Technology Stack
- **Backend:** Python (Flask)  
- **Frontend:** React, JavaScript, HTML, CSS  
- **Database:** MySQL  
- **API Architecture:** RESTful APIs (Flask-RESTful)  
- **Database Connectivity:** PyMySQL / MySQL Connector  
- **Authentication:** JWT (JSON Web Tokens)  

---

## Project Scope Exclusions
The following functionalities are not implemented in this project:

- Real-time communication (video calls, voice calls, screen sharing)  
- Tax compliance automation (GST, TDS, invoicing)  
- Legal arbitration and enforcement mechanisms  
- Freelancer training, certification, or validation programs  
- Payroll and long-term employment management  
- AI-powered recommendations or proposal shortlisting  
- Integration with external productivity tools  
- Cross-border payments and currency exchange  
- Marketing, advertising, or sponsored listings  

---

## Repository Structure
```text
Freelancer-Marketplace-DBMS/
│
├── Task-1_Project-Scope/
│
├── Task-2_Conceptual-and-Relational-Model/
│
├── Task-3_Database-Schema-and-Data/
│
├── Task-4_SQL-Queries/
│
├── Task-5_Application-and-Triggers/
│
├── Task-6_Transactions-and-Concurrency/
│
├── UI/
│
└── README.md
