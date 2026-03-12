USE freelancer_marketplace;

-- Query 1: Retrieve available freelancers with a rate below 900
SELECT fl_id, bio, rate
FROM Freelancer
WHERE availability = 'Available'
AND rate < 900;

-- Query 2: Calculate total completed payment amount per client (total investment)
SELECT c.client_id, u.name, SUM(p.amount) AS total_investment
FROM Client c
JOIN User u ON c.user_id = u.user_id
JOIN Project pr ON pr.client_id = c.client_id
JOIN Proposal prop ON prop.project_id = pr.project_id
JOIN Contract con ON con.proposal_id = prop.proposal_id
JOIN Payment p ON p.contract_id = con.contract_id
WHERE p.payment_status = 'COMPLETED'
GROUP BY c.client_id, u.name;

-- Query 3: Full project overview showing client, freelancer, contract status, and payment status
SELECT u.name AS client_name,
       pr.description,
       f.fl_id,
       u2.name AS freelancer_name,
       con.status AS contract_status,
       p.payment_status
FROM Project pr
JOIN Client c ON pr.client_id = c.client_id
JOIN User u ON c.user_id = u.user_id
JOIN Proposal prop ON prop.project_id = pr.project_id
JOIN Freelancer f ON prop.fl_id = f.fl_id
JOIN User u2 ON f.user_id = u2.user_id
JOIN Contract con ON con.proposal_id = prop.proposal_id
LEFT JOIN Payment p ON p.contract_id = con.contract_id;

-- Query 4: Find users who have never submitted a proposal as a freelancer
SELECT user_id, name
FROM User
WHERE user_id NOT IN (
    SELECT u.user_id
    FROM User u
    JOIN Freelancer f ON u.user_id = f.user_id
    JOIN Proposal p ON p.fl_id = f.fl_id
);

-- Query 5: Search for projects whose description contains the keyword 'App'
SELECT project_id, description
FROM Project
WHERE description LIKE '%App%';

-- Query 6: List distinct skills used by freelancers who have active contracts
SELECT DISTINCT s.skill_name
FROM Skill s
JOIN Freelancer_Skill fs ON s.skill_id = fs.skill_id
JOIN Proposal p ON p.fl_id = fs.fl_id
JOIN Contract c ON c.proposal_id = p.proposal_id
WHERE c.status = 'ACTIVE';

-- Query 7: Identify clients who have posted more than one project
SELECT client_id, COUNT(project_id) AS total_projects
FROM Project
GROUP BY client_id
HAVING COUNT(project_id) > 1;

-- Query 8: Retrieve freelancer names and comments for reviews with a perfect rating of 5
SELECT u.name AS freelancer_name, r.comments
FROM Review r
JOIN Freelancer f ON r.fl_id = f.fl_id
JOIN User u ON f.user_id = u.user_id
WHERE r.rating = 5;

-- Query 9: Find clients who have at least one dispute filed against them
SELECT c.client_id, u.name
FROM Client c
JOIN User u ON c.user_id = u.user_id
WHERE EXISTS (
    SELECT 1
    FROM Dispute d
    WHERE d.client_id = c.client_id
);

-- Query 10: Retrieve the top 3 highest-budget projects
SELECT project_id, description, budget
FROM Project
ORDER BY budget DESC
LIMIT 3;

-- Query 11: Classify freelancers into pricing tiers based on their hourly rate
SELECT fl_id,
       rate,
       CASE
           WHEN rate >= 1200 THEN 'Premium'
           WHEN rate >= 800 THEN 'Standard'
           ELSE 'Basic'
       END AS tier
FROM Freelancer;

-- Query 12: Calculate the average review rating for each freelancer
SELECT f.fl_id, u.name, AVG(r.rating) AS avg_rating
FROM Freelancer f
JOIN User u ON f.user_id = u.user_id
JOIN Review r ON r.fl_id = f.fl_id
GROUP BY f.fl_id, u.name;

-- Query 13: Identify completed contracts that are missing a corresponding completed payment
SELECT c.contract_id
FROM Contract c
LEFT JOIN Payment p ON c.contract_id = p.contract_id
WHERE c.status = 'COMPLETED'
AND (p.payment_status IS NULL OR p.payment_status != 'COMPLETED');

-- Query 14: List all disputes along with the involved freelancer, client names and dispute status
SELECT d.dispute_id,
       u1.name AS freelancer,
       u2.name AS client,
       d.status
FROM Dispute d
JOIN Freelancer f ON d.fl_id = f.fl_id
JOIN User u1 ON f.user_id = u1.user_id
JOIN Client c ON d.client_id = c.client_id
JOIN User u2 ON c.user_id = u2.user_id;

-- Query 15: Find freelancers who have both an active contract and a perfect 5-star review
SELECT DISTINCT f.fl_id
FROM Freelancer f
JOIN Proposal p ON p.fl_id = f.fl_id
JOIN Contract c ON c.proposal_id = p.proposal_id
JOIN Review r ON r.fl_id = f.fl_id
WHERE c.status = 'ACTIVE'
AND r.rating = 5;

-- Query 16: Identify the top-earning freelancer based on total completed payments received
SELECT f.fl_id, u.name, SUM(p.amount) AS total_earned
FROM Freelancer f
JOIN User u ON f.user_id = u.user_id
JOIN Proposal pr ON pr.fl_id = f.fl_id
JOIN Contract c ON c.proposal_id = pr.proposal_id
JOIN Payment p ON p.contract_id = c.contract_id
WHERE p.payment_status = 'COMPLETED'
GROUP BY f.fl_id, u.name
ORDER BY total_earned DESC
LIMIT 1;

-- Query 17: Calculate total revenue generated per project from completed payments
SELECT pr.project_id,
       pr.description,
       SUM(p.amount) AS revenue
FROM Project pr
JOIN Proposal prop ON prop.project_id = pr.project_id
JOIN Contract c ON c.proposal_id = prop.proposal_id
JOIN Payment p ON p.contract_id = c.contract_id
WHERE p.payment_status = 'COMPLETED'
GROUP BY pr.project_id, pr.description;