# DataAnalytics-Assessment

## Explanations

### Question 1

__Separate savings and investment information__
- First, i created a summary of each customer’s savings plans: how many they have and how much money they’ve deposited (converted from Kobo to Naira).
- Then, i did the same for investment plans.

__Only keep funded plans__
- I made sure to only count plans that actually have money deposited.

__Match customers with both__
- I joined the two summaries to find customers who have both savings and investment plans.

__Get customer details and total deposits__
- I brought in each customer’s name from the `users_customuser` table.
- Then, i added up their total deposits from both savings and investments.

__Sort the results__
- Finally, i sorted the customers by total amount deposited, starting with the highest.

### Question 2

__Count transactions per customer per month__
- For each customer, i grouped their transactions by month.
- I counted how many transactions they made in each of those months.

__Calculate the average monthly transactions per customer__
- For each customer, i took their monthly transaction counts and computed the average number of transactions per month.

__Categorize the customers__
- Based on each customer's average:
  - 10 or more -- High Frequency
  - 3 to 9 -- Medium Frequency
  - 2 or fewer -- Low Frequency

__Summarize the categories__
- I grouped the customers by these categories.
- For each group, i calculated:
  - How many customers are in it.
  - The average number of transactions per month for that group.

__Order the results__
- I sorted the output with:
  - High Frequency first,
  - then Medium,
  - then Low.


### Question 3

__Get the most recent inflow per account__
- I looked at all transactions and picked the latest inflow for each savings or investment plan.
- This helps to know when money last came into each account.

__Join this information with the plans__
- I took each plan and attached the last inflow date to it.
- Then, i calculated how many days have passed since that last inflow using `DATEDIFF`.
- I also checked if the plan is active, so i only included those that should still be in use.

__Filter inactive plans__
- Now i filtered for plans that:
  - Either never had a deposit
  - Or had their last deposit over 365 days ago
- This gives the list of inactive accounts based on inflow activity.

__Return Results__
- I sorted so that the longest-inactive accounts come first.


### Question 4

__Get the basic data:__
I started with the `users_customuser` table to get each customer’s ID, name, and signup date.

__Join transactions:__
I used a `LEFT JOIN` to bring in the transactions from the `savings_savingsaccount` table based on `owner_id`. This ensures that i still include users even if they have no transactions.

__Calculate tenure:__
I used the `TIMESTAMPDIFF` function to calculate how many months each customer has had an account (from signup date to today).

__Count transactions and average profit:__
For each user, i counted how many transactions they have and calculated the average profit per transaction. Profit is assumed to be 0.1% (0.001) of the transaction value.

__Estimate CLV:__
I applied the formula:

Estimated CLV = (transactions per month) × 12 months × average profit per transaction
This gives an annualized estimate of customer value. I used `NULLIF(tenure, 0)` to avoid dividing by zero.

__Sort the result:__
I listed customers from highest to lowest estimated CLV.



## Challenges
When i imported the database to MySQL Workbench, i was met with an error _"Error Code: 1046. No database selected"_, telling me that i did not select a default database to run my query or import my data into. Apparently, a database was not created in the assessment script.
To fix this issue in MySQL Workbench, i created a database called _cowrywise assessment_ inside the assessment database.
