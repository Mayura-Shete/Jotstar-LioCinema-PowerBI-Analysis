# KPI Measures – DAX

This document contains the key KPI measures used in the **Jotstar & LioCinema Power BI Analysis**.

The measures are used across the dashboard to analyze users, subscriptions, content, engagement, and subscription movement.

---

## KPI Summary

| KPI | Description |
|---|---|
| Total Content Items | Total number of unique content items |
| Total Users | Total number of unique users |
| Paid Users | Users subscribed to Basic, Premium, or VIP plans |
| Free Users | Users who are not on a paid subscription plan |
| Active Users | Users with a blank last active date, based on the project definition |
| Inactive Users | Total users minus active users |
| Active Rate | Percentage of users classified as active |
| Inactive Rate | Percentage of users classified as inactive |
| Total Watch Time | Total watch time across users |
| Avg Watch Time per User | Average watch time per user |
| Upgraded Users | Users who moved to a higher subscription plan |
| Downgraded Users | Users who moved to a lower subscription plan |
| Upgrade/Downgrade Rate | Net upgrade/downgrade rate based on upgraded minus downgraded users |

---

# 1. Total Content Items

### Description
Counts the number of unique, non-blank content IDs.

### DAX

```DAX
Total Content items =
DISTINCTCOUNTNOBLANK(dim_merger[content_id])
```

---

# 2. Total Users

### Description
Counts the number of unique, non-blank users.

### DAX

```DAX
Total Users =
DISTINCTCOUNTNOBLANK(fact_merger[user_id])
```

---

# 3. Paid Users

### Description
Counts users whose subscription plan is **Basic, Premium, or VIP**.

### DAX

```DAX
Paid Users =
CALCULATE(
    [Total Users],
    fact_merger[subscription_plan] IN {"Basic","VIP","Premium"}
)
```

---

# 4. Free Users

### Description
Calculates free users by subtracting paid users from total users.

### DAX

```DAX
Free Users =
[Total Users] - [Paid Users]
```

---

# 5. Active Users

### Description
Counts users whose `last_active_date` is blank, based on the project's active-user definition.

### DAX

```DAX
Active Users =
CALCULATE(
    [Total Users],
    fact_merger[last_active_date] = BLANK()
)
```

---

# 6. Inactive Users

### Description
Calculates inactive users by subtracting active users from total users.

### DAX

```DAX
Inactive Users =
[Total Users] - [Active Users]
```

---

# 7. Active Rate

### Description
Calculates the percentage of total users classified as active.

### DAX

```DAX
Active Rate =
DIVIDE(
    [Active Users],
    [Total Users],
    0
)
```

---

# 8. Inactive Rate

### Description
Calculates the percentage of total users classified as inactive.

### DAX

```DAX
Inactive Rate =
DIVIDE(
    [Inactive Users],
    [Total Users],
    0
)
```

---

# 9. Total Watch Time

### Description
Calculates the total watch time across all users in minutes.

### DAX

```DAX
Total Watch Time =
SUM(fact_merger[total_watch_time_mins])
```

---

# 10. Avg Watch Time per User

### Description
Calculates the average watch time per user by dividing total watch time by total users.

### DAX

```DAX
Avg Watch Time per User =
DIVIDE(
    [Total Watch Time],
    [Total Users]
)
```

---

# 11. Upgraded Users

### Description
Counts users who moved from a lower subscription tier to a higher subscription tier.

Upgrade paths considered:

- Free → Basic
- Free → Premium
- Free → VIP
- Basic → Premium
- Basic → VIP
- Premium → VIP

### DAX

```DAX
Upgraded users =
CALCULATE(
    [Total Users],
    (fact_merger[subscription_plan] = "Free"
        && fact_merger[new_subscription_plan] IN {"Basic","Premium","VIP"})
    ||
    (fact_merger[subscription_plan] = "Basic"
        && fact_merger[new_subscription_plan] IN {"Premium","VIP"})
    ||
    (fact_merger[subscription_plan] = "Premium"
        && fact_merger[new_subscription_plan] = "VIP")
)
```

---

# 12. Downgraded Users

### Description
Counts users who moved from a higher subscription tier to a lower subscription tier.

Downgrade paths considered:

- Basic → Free
- Premium → Basic
- Premium → Free
- VIP → Premium
- VIP → Basic
- VIP → Free

### DAX

```DAX
Downgraded users =
CALCULATE(
    [Total Users],
    (fact_merger[subscription_plan] = "Basic"
        && fact_merger[new_subscription_plan] = "Free")
    ||
    (fact_merger[subscription_plan] = "Premium"
        && fact_merger[new_subscription_plan] IN {"Basic","Free"})
    ||
    (fact_merger[subscription_plan] = "VIP"
        && fact_merger[new_subscription_plan] IN {"Premium","Basic","Free"})
)
```

---

# 13. Upgrade/Downgrade Rate (%)

### Description
Calculates the net upgrade/downgrade rate by subtracting downgraded users from upgraded users and dividing the result by total users.

### DAX

```DAX
Upgrade/Downgrade Rate(%) =
DIVIDE(
    [Upgraded users] - [Downgraded users],
    [Total Users],
    0
)
```

---

# KPI Categories

The measures can be grouped into the following categories:

### User KPIs
- Total Users
- Active Users
- Inactive Users
- Active Rate
- Inactive Rate

### Subscription KPIs
- Paid Users
- Free Users
- Upgraded Users
- Downgraded Users
- Upgrade/Downgrade Rate (%)

### Content KPIs
- Total Content Items

### Consumption KPIs
- Total Watch Time
- Avg Watch Time per User

---

## Notes

- All measures are created using DAX in Power BI.
- Measures use the `dim_merger` and `fact_merger` tables from the project data model.
- KPI values dynamically respond to the filters and slicers applied in the Power BI report.
- Subscription movement measures use the `subscription_plan` and `new_subscription_plan` fields to determine upgrades and downgrades.

---
