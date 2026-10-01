# 🛒 Cart Abandonment Pattern Analysis

**One-line summary:** A look at 38,865 online shoppers to find out exactly when during the day they abandon their carts the most — so a product team knows when to focus on fixing the checkout experience.

## Overview

This project looks at real online shopping data to answer a simple question: when do people add something to their cart and then leave without buying it? Using Python, SQL (MySQL), and Power BI, the raw shopping data was cleaned, analyzed, and turned into an easy-to-read dashboard that shows exactly when cart abandonment happens the most.

## Problem Statement

**The question this project answers:** Between adding something to a cart and finishing checkout, when do customers drop off the most — and what should the product team fix first?

A quick note on scope: this dataset doesn't track individual shopping "sessions" (a single visit to the site) — only each shopper's activity across the whole ~4.5-month period the data covers. So "abandoned" here means: this shopper added something to their cart at some point, but never completed a purchase at any point during that period.

The original plan was also to look at which device people used (phone, laptop, etc.) and which product category they were shopping in, but neither piece of information was available in this dataset. So the analysis instead focuses on time of day — see the Limitations section below for more on this.

## Dataset

| | |
|---|---|
| Source | [Retailrocket dataset on Kaggle](https://www.kaggle.com/datasets/retailrocket/ecommerce-dataset) — a real, publicly available e-commerce dataset |
| Size | 89.8 MB, about 2.76 million recorded shopping actions |
| Time period | About 4.5 months of anonymized shopping activity |
| What was used | Only two types of actions: adding an item to cart, and completing a purchase |

## Tools & Technologies

- **Python** — cleaned and prepared the raw data
- **MySQL** — organized the data and ran the calculations
- **Power BI** — built the final dashboard
- **Jupyter Notebook** — where the Python work was done

## Methods

1. **Python:** Opened the raw data, removed duplicate entries and incomplete rows, kept only the "added to cart" and "purchased" actions, and converted the raw timestamps into readable dates and times.
2. **MySQL:** Loaded the cleaned data into a database, then worked out — for every shopper — whether they added something to cart, whether they bought something, and what hour of the day their activity happened.
3. **Power BI:** Brought all of that together into a dashboard with summary numbers, a chart showing what happened to each shopper, and a chart showing abandonment by hour of day.

## Key Insights

**Overall abandonment**

- 37,722 shoppers added at least one item to their cart.
- Of those, 27,146 (72%) never completed a purchase — this is the headline abandonment rate.
- 10,576 (28%) added to cart and did go on to buy.
- A separate group of 1,143 shoppers bought something without ever adding it to a cart first (likely a quick "buy now," or a cart added during an earlier visit this dataset didn't capture).

**Abandonment by time of day**

Cart abandonment isn't the same throughout the day — it changes a lot depending on the hour:

- **Quietest hours:** 8 AM–11 AM, with the lowest point at 10 AM (only 233 abandoned carts). This is also when the fewest shoppers who do add to cart actually go on to buy (about 23–26%, compared to about 40% during busy hours).
- **Surprisingly busy overnight:** midnight–5 AM sees high abandonment too (2,000+ carts an hour), before dropping off sharply after 6 AM.
- **A steady climb through the afternoon and evening.**
- **Busiest hour:** 8–9 PM, with 3,080 abandoned carts — the single highest hour recorded. The hours around it (7 PM, 9 PM, 10 PM) are also very busy.

A quick note on this finding: the dataset doesn't say what time zone these hours are recorded in. So while the pattern above is real in the data, it isn't fully certain it lines up with each shopper's actual local time of day — especially if shoppers are spread across different countries or regions.

## Dashboard

The Power BI dashboard includes:

- Four summary cards: total shoppers who added to cart, total who abandoned, total who converted (bought), and the overall abandonment rate
- A donut chart showing what happened to each shopper (bought, abandoned, or bought without a cart)
- A bar chart showing abandoned vs. completed carts for every hour of the day

## How to Run This Project

1. Download the dataset (`events.csv`) from the [Kaggle page](https://www.kaggle.com/datasets/retailrocket/ecommerce-dataset) and place it in a `Data` folder.
2. Open `Cart_Abandonment_Retailrocket.ipynb` in Jupyter Notebook and run it from top to bottom. This cleans the data and saves it into the `Exports` folder.
3. Create a MySQL database and run the queries in `Cart_Abandonment_Analysis.sql` to build the summary tables.
4. Open `Cart_Abandonment_Dashboard.pbix` in Power BI Desktop to see the finished dashboard.

## Results & Conclusion

Overall, 72% of shoppers who add something to their cart never buy it — and this isn't spread evenly through the day. The busiest window, 6 PM to 11 PM, should be the first place a product team looks: it has the most abandoned carts and stays busy for six hours straight, so fixing problems here would help the largest number of shoppers. The quiet morning window (8–11 AM) has fewer abandoned carts overall, but it's worth a second look too, since shoppers there are also less likely to buy — something other than traffic volume may be going on during those hours.

## Limitations

- **No "session" tracking:** this dataset tracks each shopper over the whole 4.5-month period, not per individual visit. So someone who abandoned a cart in month one and bought something unrelated in month three still counts as "converted," not "abandoned."
- **No device information:** there's no way to tell if someone was shopping on a phone, laptop, or tablet.
- **No product category information:** that data exists in a separate file that wasn't included, to keep this project manageable.
- **Time zone is unknown** for the hour-of-day data (see note above).
- **No return-on-investment (ROI) numbers:** this dataset doesn't include marketing costs or campaign data, so this project focuses on where and when abandonment happens, not on dollar-for-dollar campaign returns.

## Author & Contact

**Simerpreet Kaur**
Data Analyst
📧 Email: ksimerpreet3@gmail.com
🔗 [LinkedIn](https://www.linkedin.com/in/simer-preet-kaur/)
🔗 [GitHub](https://github.com/Simer45)
