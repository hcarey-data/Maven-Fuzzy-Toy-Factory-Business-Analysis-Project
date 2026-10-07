# Maven Fuzzy Toy Factory Business Analysis Project

## Project Overview
The stakeholders of Maven Fuzzy Factory, a fictional online retail platform that sells teddy bear toys, has approached with a business problem. 
They want to know how they can optimize or what can be improved with the market to purchase funnel in regards to website pageviews, sessions, etc. 
These will in turn lead to increased sales. AI was used to review the dataset and find problems in the data and possible improvements to help develop 
a business problem. 

## Business Problem
Find the three largest sources of revenue loss across the market to purchase funnel. Also, find how much revenue that loss amounts to and what 
it is as a percentage of potential revenue. Finally, find possible improvements and choose the improvement that would produce the greatest impact.

## Dataset 
This dataset includes data from the toy factory database. These tables include:

1. orders 
2. order_items
3. products
4. website_sessions
5. website_pageviews
6. order_item_refunds 

These tables together give a picture of the online activity, website views, sales, and refunds for the company. The link to the original dataset can be found 
here: (https://mavenanalytics.io/data-playground/toy-store-e-commerce-database?utm_source=chatgpt.com) (Maven Analytics, 2026)

## Tools and Technology

### Tools used:

1. ChatGPT
2. Perplexity AI
3. MySQL
4. Excel

These tables were first imported into MySQL Workbench for cleaning and general EDA. Advanced analysis was then performed on the cleaned tables. Visualizations were then 
created in Excel.

## Data Preparation & Cleaning

The data was prepared and cleaned in MySQL. Empty MySQL tables were created first, and then the data was read into them. Datatypes were then inspected, nulls and blanks removed, and duplicates (if any) were removed as well. General KPIs like total orders, total revenue, and earliest and latest date records were calculated in the EDA phase. New tables with the cleaned columns were created having the "cleaned" ending in the name.

## SQL Analysis 

The Advanced SQL analysis continued in MySQL. I first join the cleaned versions of the pageviews, sessions, and orders tables and see which activity DID NOT result in a purchase. Since the people who initiated these website sessions and product views did not purchase anything, it is helpful to understand which products and sessions were the most popular and thus determine revenue loss. A new table is created with this information and many queries onward result from this centralized table. 

## Key Findings

FINDING 1: If the average order value is $81.29, 2014 had 113799 total sessions and 2015 had just 33192 total sessions that included "/products" viewing, that equates to an approximate $6,552,543.03 loss of potential revenue between 2014 and 2015 if each of those customer sessions resulted in a purchase.

FINDING 2: If the average order value is $81.29,  included "/cart" viewing, that equates to an approximate $1,784,396.79
 loss of potential revenue between 2014 and 2015 if each of those customer sessions resulted in a purchase.

FINDING 3: Since there was a massive drop of about 71.33% in 2014 to 2015 across all sessions that include different URL viewings, the percentage drops across the market-to-purchase
funnel in those years is most likely due to less customer engagement with the website overall. 

FINDING 4: The original Mr. fuzzy is by far the most popular viewed product.

FINDING 5: The original Mr. fuzzy is by far the most refunded product.

## Recommendations (find possible improvements and choose the improvement that would produce the greatest impact):

1. Sell more of the original Mr. fuzzy. There were 29618 total views of the original mr fuzzy product URL page that contributed to $1934516.68 in revenue, that is about $65 dollars per view. In order to increase customer engagement, I would recommend increasing this products views to at least 40000. This should increase the revenue garnered to $2600000 for a 34% increase in sales.

2. Could the website interface be too complicated, bland, or unattractive? Is it hard to navigate? A/B testing with a new version of the URL could be done to test this. This could 
help especially with the Mr. Fuzzy webpage views and increase probability of the product's purchase. 

3. In terms of order refunds, the original Mr. fuzzy is by far the most refunded with a total of $61837.63 in refunds. It would also be beneficial to the company if
surveys were taken as to why that specific product was refunded so much, and what customers think should be done to improve the product. 

4. The year 2014, with $1,583,913.77 in sales, was the best year for online sales. It also has the highest session and pageview amounts as well (233,422 and 597,556 respectively). If these amounts can be set as a benchmark or milestone view count, it can be helpful for the business to attain around the same amount of revenue.


## Citations 
Maven Analytics (2026) Toy Store E-Commerce Database. Retrieved from: https://mavenanalytics.io/data-playground/toy-store-e-commerce-database?utm_source=chatgpt.com
