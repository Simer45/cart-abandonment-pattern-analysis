# Cart Abandonment Pattern Analysis

## Business Question

Where, between adding an item to cart and completing checkout, are customers dropping off — and what should the product team fix first?

Scope note: the dataset used (Retailrocket) has no session identifier, so abandonment here is measured at the **visitor level** across the full ~4.5-month window, not at the individual-session level. A visitor is counted as a cart-adder if they have at least one `addtocart` event; they are counted as "abandoned" if none of their events is a `transaction`.

## Dataset

| | |
|---|---|
| Source | [Retailrocket Recommender System Dataset](https://www.kaggle.com/datasets/retailrocket/ecommerce-dataset) (Kaggle) |
| Raw size | 89.8 MB, 2,756,101 events |
| Date range | ~4.5 months of anonymized e-commerce clickstream data |
| Events used | `addtocart`, `transaction` (view events excluded — not relevant to the funnel) |
| Fields used | `timestamp`, `visitorid`, `event`, `itemid`, `transactionid` |

**Note on dataset choice:** this project originally used the REES46 "eCommerce behavior data" dataset (8.38 GB, 67.5M rows). After cleaning and loading it into MySQL, the session-level funnel query repeatedly timed out on this machine even after query optimization (indexing, increased timeout, increased memory for temp tables). Rather than continue tuning for a dataset this hardware couldn't handle at scale, the project switched to Retailrocket — a smaller, real, properly-sourced dataset covering the same type of behavior. The trade-off is explicit: Retailrocket has no session ID, so this analysis reports visitor-level abandonment instead of session-level abandonment.

## Tools and Methodology

1. **Python (pandas)** — loaded and profiled the raw CSV, removed duplicate events and rows with missing required fields, filtered down to `addtocart`/`transaction` events only, and converted the Unix millisecond timestamp to a readable datetime. Exported the cleaned data to `funnel_events_clean.csv`.
2. **MySQL** — bulk-loaded the cleaned CSV into a `cart_abandonment_db` database (`funnel_events` table). Built a `visitor_summary` table (visitor-level flags: `has_cart`, `has_purchase`, `visitor_status`) and an hour-of-day breakdown query, both exported as CSVs for Power BI.
3. **Power BI** — imported both exported tables, related them on `visitorid`, and built a dashboard with KPI cards, a visitor-outcome donut chart, and an hour-of-day clustered column chart.

## Key Findings

**Overall abandonment**

- 37,722 visitors added at least one item to cart during the window.
- Of those, 27,146 (**72.0%**) never completed a purchase — the headline cart abandonment rate.
- 10,576 (28.0%) added to cart and went on to purchase.
- A further 1,143 visitors purchased without any recorded add-to-cart event (likely a prior-session cart, or a direct buy-now path not captured by this event type). Including this group in the total visitor base (38,865) gives the outcome split shown in the dashboard's donut chart: 69.85% abandoned / 27.21% added-to-cart-and-purchased / 2.94% purchased-with-no-cart-event. The 72.0% figure is the more precise "cart abandonment rate" since it's scoped only to visitors who actually had a cart; the donut's 69.85% is a visitor-outcome mix across all visitors. Both are shown on the dashboard, with the KPI card carrying the headline number.

**Abandonment by hour of day**

Abandoned-cart volume is not flat across the day — it follows a clear bimodal pattern:

- **Lowest activity:** 08:00–11:00, bottoming out at 10:00 (233 abandoned carts, the single lowest hour). This window also has the lowest conversion rate of the day (roughly 23–26%, versus ~40% during peak hours) — the few carts added here are also the least likely to convert.
- **Elevated overnight:** 00:00–05:00 stays unexpectedly high (2,077–2,288 abandoned carts/hour) before dropping off sharply after 06:00.
- **Afternoon/evening climb:** volume rises steadily from 14:00 onward.
- **Peak abandonment:** 20:00 (8–9 PM), with 3,080 abandoned carts — the single highest hour in the dataset. 19:00, 21:00, and 22:00 are also high (2,698–2,823).

**Recommendation for the product team:** prioritize checkout-flow fixes for the 18:00–23:00 window first — it carries both the highest raw volume of abandoned carts and sustained high traffic across six consecutive hours, so a fix here affects the most customers. The 08:00–11:00 trough is lower priority by volume, but its unusually low conversion rate is worth a separate look, since it suggests something beyond simple traffic volume is discouraging purchases in that window.

*Caveat: the dataset does not document which timezone its timestamps are in. The pattern above is real within the data as recorded, but "hour of day" may not map directly to each visitor's local time if traffic is drawn from multiple regions — treat the peak/trough windows as relative patterns in the data rather than confirmed local-time behavior.*

## Limitations

- **No session ID:** abandonment is measured per visitor across the entire ~4.5-month window, not per shopping session. A visitor who abandoned a cart in month 1 and purchased something unrelated in month 3 would be counted as "converted," not "abandoned." This is a real difference from a session-scoped funnel analysis.
- **No device-type data:** the dataset does not record device (desktop/mobile/tablet), so this dimension — originally part of the planned analysis — could not be included.
- **No product-category data:** category information exists only in a separate large property file not joined into this analysis; it was explicitly dropped to keep the project scoped and performant. Abandonment by category is not covered here.
- **Timezone of timestamps is undocumented** (see caveat above).
- **"ROI" was not computed:** this dataset has no campaign cost or marketing-response data, so no return-on-investment figure is included. The analysis instead quantifies abandonment volume and timing, which is what the data can actually support.

## Files in This Project

| File | Purpose |
|---|---|
| `Data/events.csv` | Raw Retailrocket dataset |
| `Cart_Abandonment_Retailrocket.ipynb` | Python cleaning notebook |
| `Exports/funnel_events_clean.csv` | Cleaned event-level data (output of notebook, loaded into MySQL) |
| `Exports/visitor_summary.csv` | Visitor-level summary table (output of MySQL, loaded into Power BI) |
| `Cart_Abandonment_Analysis.sql` | SQL queries used for the funnel and hour-of-day analysis |
| `Cart_Abandonment_Dashboard.pbix` | Final Power BI dashboard |
| `README.md` | This file |
