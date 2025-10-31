# Task 8 - SQL Developer Internship (Elevate Labs)
### Topic: Creating Stored Procedures and Functions

---

## Overview
In this Task, i used Stored Procedures and Functions to create practical, reusable SQL logic using my Travel Agency Database and created loyalty_points table to achieve the tasks.
I created Stored Procedures and Functions with/using:
- Parameters
- conditional logic
- loop

### Stored Procedure:
- Created procedure called add_loyalty_points which is used to insert/update points for travelers.
- Create procedure with if-else condition for knowing the loyalty_status of travelers based on points categorized into Gold, Silver and Regular Membership.
- Created procedure with loop to countdown days till trip day arrives.

### Function:
- Created function get_reward_value to convert the points to monetory reward (1 point=10 rupee).
- Created function with if condition to categorize travelers as Luxury Traveler, Comfort Traveler and Budget Traveler based on their budget from travellers table.

---
## Learnings
- Creating stores procedures and functions.
- Stored Procedures are helpful because we can reuse the logic easily, helps in faster and better performance and also to automate tasks.
- Functions are useful because it ensures consistency and it makes sure the query is cleaner instead of repeating complex calculations.
- Using IN and OUT parameters.
- Using conditional logic and loops in stored procedures and functions.
- Got insight about how real world business systems like MakeMyTrip, RedBus etc would work.

---
## Tools Used
- **MySQL Workbench**  
