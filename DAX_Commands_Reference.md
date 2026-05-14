# DAX Commands Reference — Power BI
> Dataset assumed: **Superstore** (Tables: `Sales`, `Products`, `Customers`, `Calendar`)

---

## Table of Contents
1. [Aggregation Functions](#1-aggregation-functions)
2. [CALCULATE & FILTER](#2-calculate--filter)
3. [Iterator (X) Functions](#3-iterator-x-functions)
4. [Time Intelligence Functions](#4-time-intelligence-functions)
5. [Logical Functions](#5-logical-functions)
6. [Text Functions](#6-text-functions)
7. [Date & Time Functions](#7-date--time-functions)
8. [Table Functions](#8-table-functions)
9. [Relationship Functions](#9-relationship-functions)
10. [Ranking & Statistical Functions](#10-ranking--statistical-functions)
11. [Information Functions](#11-information-functions)
12. [Math Functions](#12-math-functions)

---

## 1. Aggregation Functions

| Function | Purpose |
|---|---|
| `SUM` | Sum of a column |
| `AVERAGE` | Mean of a column |
| `COUNT` | Count of numeric rows |
| `COUNTA` | Count of non-blank rows |
| `DISTINCTCOUNT` | Count of unique values |
| `MAX` | Maximum value |
| `MIN` | Minimum value |

---

### SUM
**Use when:** Adding up all values in a numeric column.
```dax
Total Sales = SUM(Sales[Sales])
```

---

### AVERAGE
**Use when:** Finding the mean value of a numeric column.
```dax
Avg Sales = AVERAGE(Sales[Sales])
```

---

### COUNT
**Use when:** Counting rows that contain numeric values.
```dax
Sales Row Count = COUNT(Sales[Sales])
```

---

### COUNTA
**Use when:** Counting all non-blank rows (works on text too).
```dax
Total Records = COUNTA(Sales[OrderID])
```

---

### DISTINCTCOUNT
**Use when:** Counting unique values — avoids double-counting.
```dax
Total Orders = DISTINCTCOUNT(Sales[OrderID])
```

---

### MAX
**Use when:** Finding the highest value in a column.
```dax
Highest Sale = MAX(Sales[Sales])
```

---

### MIN
**Use when:** Finding the lowest value in a column.
```dax
Lowest Sale = MIN(Sales[Sales])
```

---

### DIVIDE
**Use when:** Safe division — returns BLANK instead of error when denominator is 0.
```dax
Profit Margin % =
DIVIDE(
    SUM(Sales[Profit]),
    SUM(Sales[Sales])
) * 100
```

---

## 2. CALCULATE & FILTER

| Function | Purpose |
|---|---|
| `CALCULATE` | Evaluate expression in a modified filter context |
| `FILTER` | Return a table satisfying a row-level condition |
| `ALL` | Remove all filters from a table or column |
| `ALLEXCEPT` | Remove all filters except specified columns |
| `ALLSELECTED` | Remove filters except those from slicers |
| `KEEPFILTERS` | Add filter without overriding existing ones |

---

### CALCULATE
**Use when:** Changing or overriding the current filter context.
```dax
Tech Sales =
CALCULATE(
    SUM(Sales[Sales]),
    Products[Category] = "Technology"
)
```

---

### CALCULATE with multiple filters
**Use when:** Applying more than one filter condition at once.
```dax
West Tech Sales =
CALCULATE(
    SUM(Sales[Sales]),
    Products[Category] = "Technology",
    Customers[Region] = "West"
)
```

---

### FILTER
**Use when:** You need a row-level condition (comparing row values, not just column filters).
```dax
High Value Sales =
CALCULATE(
    SUM(Sales[Sales]),
    FILTER(
        Sales,
        Sales[Sales] > 1000
    )
)
```

---

### ALL
**Use when:** Removing all filters to get a grand total — used in % of total patterns.
```dax
Sales % of Total =
DIVIDE(
    SUM(Sales[Sales]),
    CALCULATE(
        SUM(Sales[Sales]),
        ALL(Sales)
    )
) * 100
```

---

### ALL on a single column
**Use when:** Removing filter from only one column while keeping others.
```dax
Sales % of Category =
DIVIDE(
    SUM(Sales[Sales]),
    CALCULATE(
        SUM(Sales[Sales]),
        ALL(Products[SubCategory])
    )
) * 100
```

---

### ALLEXCEPT
**Use when:** Removing all filters from a table except certain columns.
```dax
Category Total Sales =
CALCULATE(
    SUM(Sales[Sales]),
    ALLEXCEPT(Products, Products[Category])
)
```

---

### ALLSELECTED
**Use when:** Ignoring row/column context but respecting slicer selections.
```dax
Sales % of Slicer Total =
DIVIDE(
    SUM(Sales[Sales]),
    CALCULATE(
        SUM(Sales[Sales]),
        ALLSELECTED(Products[Category])
    )
) * 100
```

---

### KEEPFILTERS
**Use when:** Adding a filter without replacing an existing one (intersection, not override).
```dax
Filtered Tech Sales =
CALCULATE(
    SUM(Sales[Sales]),
    KEEPFILTERS(Products[Category] = "Technology")
)
```

---

## 3. Iterator (X) Functions

| Function | Purpose |
|---|---|
| `SUMX` | Sum of a row-by-row expression |
| `AVERAGEX` | Average of a row-by-row expression |
| `COUNTX` | Count rows where expression is non-blank |
| `MAXX` | Maximum of a row-by-row expression |
| `MINX` | Minimum of a row-by-row expression |
| `RANKX` | Rank based on a row-by-row expression |

> **Key rule:** Use X functions when your expression needs **row-level calculations** that can't be done with a simple column reference.

---

### SUMX
**Use when:** You need to multiply (or calculate) per row, then sum the results.
```dax
Revenue After Discount =
SUMX(
    Sales,
    Sales[Sales] * (1 - Sales[Discount])
)
```

---

### AVERAGEX
**Use when:** Averaging a calculated expression across rows of a table.
```dax
Avg Profit per Product =
AVERAGEX(
    Products,
    CALCULATE(SUM(Sales[Profit]))
)
```

---

### COUNTX
**Use when:** Counting only rows where a calculated expression is non-blank.
```dax
Orders With Discount =
COUNTX(
    FILTER(Sales, Sales[Discount] > 0),
    Sales[OrderID]
)
```

---

### MAXX
**Use when:** Finding the maximum of a per-row calculation.
```dax
Max Order Value =
MAXX(
    VALUES(Sales[OrderID]),
    CALCULATE(SUM(Sales[Sales]))
)
```

---

### MINX
**Use when:** Finding the minimum of a per-row calculation.
```dax
Min Order Value =
MINX(
    VALUES(Sales[OrderID]),
    CALCULATE(SUM(Sales[Sales]))
)
```

---

## 4. Time Intelligence Functions

> **Requirement:** All time intelligence functions need a **Calendar table** marked as a *Date Table* in Power BI, connected to your fact table via a date column.

| Function | Purpose |
|---|---|
| `TOTALYTD` | Year-to-date cumulative total |
| `TOTALMTD` | Month-to-date cumulative total |
| `TOTALQTD` | Quarter-to-date cumulative total |
| `SAMEPERIODLASTYEAR` | Same period one year ago |
| `DATEADD` | Shift dates by N intervals |
| `DATESBETWEEN` | Dates within a specified range |
| `DATESINPERIOD` | Dates within a rolling window |
| `PREVIOUSMONTH` | All dates in the previous month |
| `PREVIOUSYEAR` | All dates in the previous year |
| `NEXTMONTH` | All dates in the next month |
| `FIRSTDATE` | First date in current context |
| `LASTDATE` | Last date in current context |
| `STARTOFYEAR` | First date of the year |
| `ENDOFYEAR` | Last date of the year |

---

### TOTALYTD
**Use when:** Showing cumulative sales from January 1 to the current date.
```dax
Sales YTD =
TOTALYTD(
    SUM(Sales[Sales]),
    Calendar[Date]
)
```

---

### TOTALMTD
**Use when:** Showing cumulative sales from the 1st of the current month.
```dax
Sales MTD =
TOTALMTD(
    SUM(Sales[Sales]),
    Calendar[Date]
)
```

---

### TOTALQTD
**Use when:** Showing cumulative sales from the start of the current quarter.
```dax
Sales QTD =
TOTALQTD(
    SUM(Sales[Sales]),
    Calendar[Date]
)
```

---

### SAMEPERIODLASTYEAR
**Use when:** Comparing current period to the exact same period last year.
```dax
Sales PY =
CALCULATE(
    SUM(Sales[Sales]),
    SAMEPERIODLASTYEAR(Calendar[Date])
)
```

---

### YoY Growth %
**Use when:** Calculating year-over-year percentage change.
```dax
YoY Growth % =
DIVIDE(
    SUM(Sales[Sales]) - [Sales PY],
    [Sales PY]
) * 100
```

---

### DATEADD
**Use when:** Shifting the date context by any number of days, months, quarters, or years.
```dax
Sales Last Month =
CALCULATE(
    SUM(Sales[Sales]),
    DATEADD(Calendar[Date], -1, MONTH)
)

Sales Last Quarter =
CALCULATE(
    SUM(Sales[Sales]),
    DATEADD(Calendar[Date], -1, QUARTER)
)

Sales Last Year =
CALCULATE(
    SUM(Sales[Sales]),
    DATEADD(Calendar[Date], -1, YEAR)
)
```

---

### DATESINPERIOD
**Use when:** Creating a rolling window (last N days/months/years).
```dax
Sales Last 3 Months =
CALCULATE(
    SUM(Sales[Sales]),
    DATESINPERIOD(
        Calendar[Date],
        LASTDATE(Calendar[Date]),
        -3,
        MONTH
    )
)
```

---

### DATESBETWEEN
**Use when:** Filtering to a specific fixed date range.
```dax
Sales Q1 2024 =
CALCULATE(
    SUM(Sales[Sales]),
    DATESBETWEEN(
        Calendar[Date],
        DATE(2024, 1, 1),
        DATE(2024, 3, 31)
    )
)
```

---

### PREVIOUSMONTH
**Use when:** Showing the complete previous month's total.
```dax
Sales Previous Month =
CALCULATE(
    SUM(Sales[Sales]),
    PREVIOUSMONTH(Calendar[Date])
)
```

---

### PREVIOUSYEAR
**Use when:** Showing the complete previous year's total.
```dax
Sales Previous Year =
CALCULATE(
    SUM(Sales[Sales]),
    PREVIOUSYEAR(Calendar[Date])
)
```

---

### Running Total
**Use when:** Showing a cumulative sum that keeps growing across time.
```dax
Running Total Sales =
CALCULATE(
    SUM(Sales[Sales]),
    FILTER(
        ALL(Calendar[Date]),
        Calendar[Date] <= MAX(Calendar[Date])
    )
)
```

---

## 5. Logical Functions

| Function | Purpose |
|---|---|
| `IF` | Return different values based on a condition |
| `SWITCH` | Multiple condition branching (cleaner than nested IFs) |
| `AND` | Both conditions must be true |
| `OR` | At least one condition must be true |
| `NOT` | Reverses a logical value |
| `IFERROR` | Return fallback value if expression errors |
| `ISBLANK` | Check if a value is blank/null |

---

### IF
**Use when:** Branching logic with one condition.
```dax
Profit Status =
IF(
    SUM(Sales[Profit]) > 0,
    "Profitable",
    "Loss"
)
```

---

### Nested IF
**Use when:** Multiple conditions checked in sequence.
```dax
Performance Grade =
IF(SUM(Sales[Sales]) >= 100000, "Excellent",
    IF(SUM(Sales[Sales]) >= 50000, "Good",
        IF(SUM(Sales[Sales]) >= 10000, "Average",
            "Poor"
        )
    )
)
```

---

### SWITCH(TRUE())
**Use when:** Multiple conditions — much cleaner than nested IFs.
```dax
Sales Tier =
SWITCH(
    TRUE(),
    SUM(Sales[Sales]) >= 100000, "Platinum",
    SUM(Sales[Sales]) >= 50000,  "Gold",
    SUM(Sales[Sales]) >= 10000,  "Silver",
    "Bronze"
)
```

---

### SWITCH on a value
**Use when:** Matching a column to specific values (like SQL CASE WHEN col = value).
```dax
Region Label =
SWITCH(
    Customers[Region],
    "West",  "Western Zone",
    "East",  "Eastern Zone",
    "North", "Northern Zone",
    "South", "Southern Zone",
    "Unknown"
)
```

---

### AND / OR
**Use when:** Combining multiple conditions in IF or FILTER.
```dax
West Tech Sales =
CALCULATE(
    SUM(Sales[Sales]),
    FILTER(
        Sales,
        AND(
            Customers[Region] = "West",
            Products[Category] = "Technology"
        )
    )
)
```

---

### IFERROR
**Use when:** Handling potential errors gracefully.
```dax
Safe Margin =
IFERROR(
    DIVIDE(SUM(Sales[Profit]), SUM(Sales[Sales])),
    0
)
```

---

### ISBLANK
**Use when:** Checking for null/empty values before using them.
```dax
Discount Flag =
IF(
    ISBLANK(Sales[Discount]) || Sales[Discount] = 0,
    "No Discount",
    "Discounted"
)
```

---

## 6. Text Functions

| Function | Purpose |
|---|---|
| `CONCATENATE` | Join two text strings |
| `CONCATENATEX` | Join text values across rows of a table |
| `LEFT` | Extract N characters from left |
| `RIGHT` | Extract N characters from right |
| `MID` | Extract characters from middle |
| `LEN` | Length of a string |
| `UPPER` | Convert to uppercase |
| `LOWER` | Convert to lowercase |
| `TRIM` | Remove leading/trailing spaces |
| `SUBSTITUTE` | Replace text within a string |
| `FORMAT` | Format numbers/dates as text |
| `VALUE` | Convert text to number |
| `FIXED` | Round and format as text |

---

### CONCATENATE
**Use when:** Joining two text values into one.
```dax
Full Name =
CONCATENATE(
    Customers[CustomerName],
    CONCATENATE(" — ", Customers[Region])
)
```

---

### CONCATENATEX
**Use when:** Joining values from multiple rows into one string.
```dax
Product List =
CONCATENATEX(
    Products,
    Products[ProductName],
    ", "
)
```

---

### LEFT / RIGHT / MID
**Use when:** Extracting a portion of a text string.
```dax
Order Prefix = LEFT(Sales[OrderID], 3)

Order Suffix = RIGHT(Sales[OrderID], 4)

Order Middle = MID(Sales[OrderID], 3, 4)
```

---

### FORMAT
**Use when:** Converting numbers or dates into formatted text for display.
```dax
Sales Formatted    = FORMAT(SUM(Sales[Sales]), "$#,##0.00")
Date Formatted     = FORMAT(TODAY(), "DD MMM YYYY")
Percent Formatted  = FORMAT([Profit Margin %], "0.00%")
```

---

### SUBSTITUTE
**Use when:** Replacing specific text within a string.
```dax
Clean Product Name =
SUBSTITUTE(Products[ProductName], "  ", " ")
```

---

### UPPER / LOWER / TRIM
**Use when:** Normalizing text for consistent comparisons.
```dax
Upper Region  = UPPER(Customers[Region])
Lower Segment = LOWER(Customers[Segment])
Clean Name    = TRIM(Customers[CustomerName])
```

---

## 7. Date & Time Functions

| Function | Purpose |
|---|---|
| `TODAY` | Current date |
| `NOW` | Current date and time |
| `DATE` | Create a date from year, month, day |
| `YEAR` | Extract year from a date |
| `MONTH` | Extract month number |
| `DAY` | Extract day number |
| `WEEKDAY` | Day of the week (1=Sunday) |
| `WEEKNUM` | Week number of the year |
| `EOMONTH` | Last day of a month offset |
| `DATEDIFF` | Difference between two dates |
| `CALENDAR` | Generate a date table |
| `CALENDARAUTO` | Auto-generate date table from model |

---

### TODAY / NOW
**Use when:** Getting the current date for dynamic calculations.
```dax
Days Since Last Order =
DATEDIFF(MAX(Sales[OrderDate]), TODAY(), DAY)
```

---

### DATE
**Use when:** Constructing a specific date from parts.
```dax
Start of 2024 = DATE(2024, 1, 1)
```

---

### YEAR / MONTH / DAY
**Use when:** Extracting parts of a date (useful in calculated columns).
```dax
Order Year  = YEAR(Sales[OrderDate])
Order Month = MONTH(Sales[OrderDate])
Order Day   = DAY(Sales[OrderDate])
```

---

### DATEDIFF
**Use when:** Calculating the number of days/months/years between two dates.
```dax
Days to Ship =
DATEDIFF(
    Sales[OrderDate],
    Sales[ShipDate],
    DAY
)
```

---

### EOMONTH
**Use when:** Finding the last day of a month (current or offset).
```dax
End of Current Month = EOMONTH(TODAY(), 0)
End of Next Month    = EOMONTH(TODAY(), 1)
End of Last Month    = EOMONTH(TODAY(), -1)
```

---

### CALENDAR
**Use when:** Creating a date dimension table manually.
```dax
Calendar =
CALENDAR(
    DATE(2020, 1, 1),
    DATE(2024, 12, 31)
)
```

---

### CALENDARAUTO
**Use when:** Auto-generating a date table based on all dates in the model.
```dax
Calendar = CALENDARAUTO()
```

---

## 8. Table Functions

| Function | Purpose |
|---|---|
| `VALUES` | Unique values of a column as a table |
| `DISTINCT` | Distinct values (like VALUES but excludes blank) |
| `ALL` | All rows ignoring filters |
| `FILTER` | Subset of a table matching a condition |
| `SUMMARIZE` | Group-by aggregation table |
| `ADDCOLUMNS` | Add calculated columns to a table |
| `SELECTCOLUMNS` | Pick specific columns from a table |
| `CROSSJOIN` | Cartesian product of two tables |
| `UNION` | Stack two tables vertically |
| `INTERSECT` | Rows common to two tables |
| `EXCEPT` | Rows in first table not in second |
| `TOPN` | Top N rows by an expression |
| `GENERATE` | Row expansion |

---

### VALUES
**Use when:** Getting a list of unique values from a column (used inside iterators).
```dax
Unique Categories = VALUES(Products[Category])
```

---

### SUMMARIZE
**Use when:** Creating a grouped summary table (like GROUP BY in SQL).
```dax
Category Summary =
SUMMARIZE(
    Sales,
    Products[Category],
    "Total Sales",   SUM(Sales[Sales]),
    "Total Profit",  SUM(Sales[Profit])
)
```

---

### ADDCOLUMNS
**Use when:** Adding calculated columns to an existing table expression.
```dax
Enriched Categories =
ADDCOLUMNS(
    VALUES(Products[Category]),
    "Total Sales",  CALCULATE(SUM(Sales[Sales])),
    "Total Profit", CALCULATE(SUM(Sales[Profit]))
)
```

---

### SELECTCOLUMNS
**Use when:** Creating a new table with only specific columns (and optionally renaming them).
```dax
Order Summary =
SELECTCOLUMNS(
    Sales,
    "Order ID",   Sales[OrderID],
    "Sale Amount", Sales[Sales],
    "Profit",      Sales[Profit]
)
```

---

### TOPN
**Use when:** Getting the top N rows ranked by an expression.
```dax
Top 5 Customer Sales =
CALCULATE(
    SUM(Sales[Sales]),
    TOPN(
        5,
        ALL(Customers[CustomerName]),
        CALCULATE(SUM(Sales[Sales])),
        DESC
    )
)
```

---

### UNION
**Use when:** Combining two tables with the same columns vertically.
```dax
All Names =
UNION(
    VALUES(Customers[CustomerName]),
    VALUES(Customers[Region])
)
```

---

## 9. Relationship Functions

| Function | Purpose |
|---|---|
| `RELATED` | Fetch a value from the one-side of a relationship |
| `RELATEDTABLE` | Fetch a table from the many-side |
| `USERELATIONSHIP` | Activate an inactive relationship |
| `CROSSFILTER` | Change filter direction of a relationship |

---

### RELATED
**Use when:** Pulling a value from a related table into a calculated column (many → one).
```dax
Category =
RELATED(Products[Category])
```
> Add this as a **calculated column** in the `Sales` table.

---

### RELATEDTABLE
**Use when:** Counting or aggregating rows from a related table (one → many).
```dax
Orders per Customer =
COUNTROWS(
    RELATEDTABLE(Sales)
)
```
> Add this as a **calculated column** in the `Customers` table.

---

### USERELATIONSHIP
**Use when:** You have multiple date columns and need to activate a specific (inactive) relationship.
```dax
Sales by Ship Date =
CALCULATE(
    SUM(Sales[Sales]),
    USERELATIONSHIP(Sales[ShipDate], Calendar[Date])
)
```

---

### CROSSFILTER
**Use when:** Temporarily changing filter direction (Single ↔ Both) inside a CALCULATE.
```dax
Customers with Sales =
CALCULATE(
    DISTINCTCOUNT(Customers[CustomerID]),
    CROSSFILTER(Sales[CustomerID], Customers[CustomerID], BOTH)
)
```

---

## 10. Ranking & Statistical Functions

| Function | Purpose |
|---|---|
| `RANKX` | Rank rows based on an expression |
| `PERCENTILE.INC` | Value at a given percentile |
| `STDEV.P` | Population standard deviation |
| `STDEV.S` | Sample standard deviation |
| `VAR.P` | Population variance |
| `VAR.S` | Sample variance |
| `MEDIAN` | Median of a column |
| `GEOMEAN` | Geometric mean |

---

### RANKX
**Use when:** Ranking products, customers, or regions by a metric.
```dax
Product Sales Rank =
RANKX(
    ALL(Products[ProductName]),
    CALCULATE(SUM(Sales[Sales])),
    ,
    DESC,
    Dense
)
```

> `DESC` = highest value = rank 1. `Dense` = no gaps when tied (1,2,2,3 not 1,2,2,4).

---

### RANKX — within group
**Use when:** Ranking within a category (e.g. rank products within their category).
```dax
Rank Within Category =
RANKX(
    ALLEXCEPT(Products, Products[Category]),
    CALCULATE(SUM(Sales[Sales])),
    ,
    DESC,
    Dense
)
```

---

### MEDIAN
**Use when:** Finding the middle value (more robust than AVERAGE for skewed data).
```dax
Median Sales = MEDIAN(Sales[Sales])
```

---

### PERCENTILE.INC
**Use when:** Finding the value at a specific percentile (e.g. top 25%).
```dax
Sales 90th Percentile =
PERCENTILE.INC(Sales[Sales], 0.9)
```

---

### STDEV.P
**Use when:** Measuring spread/variability of a dataset.
```dax
Sales Std Dev = STDEV.P(Sales[Sales])
```

---

## 11. Information Functions

| Function | Purpose |
|---|---|
| `ISBLANK` | True if value is blank |
| `ISNUMBER` | True if value is a number |
| `ISTEXT` | True if value is text |
| `ISERROR` | True if value is an error |
| `HASONEVALUE` | True if column has exactly one value in context |
| `SELECTEDVALUE` | Returns the single selected value (or alternate) |
| `COUNTBLANK` | Count blank cells in a column |
| `CONTAINS` | True if a table contains specified values |

---

### HASONEVALUE
**Use when:** Displaying a label only when a single item is selected in a slicer.
```dax
Selected Category =
IF(
    HASONEVALUE(Products[Category]),
    VALUES(Products[Category]),
    "Multiple Selected"
)
```

---

### SELECTEDVALUE
**Use when:** Getting the currently selected slicer value with a fallback default.
```dax
Selected Region =
SELECTEDVALUE(
    Customers[Region],
    "All Regions"
)
```

---

### COUNTBLANK
**Use when:** Counting how many rows have missing values.
```dax
Missing Discounts =
COUNTBLANK(Sales[Discount])
```

---

### CONTAINS
**Use when:** Checking if a table contains a specific combination of values.
```dax
Has Tech Orders =
CONTAINS(
    Sales,
    Products[Category], "Technology"
)
```

---

## 12. Math Functions

| Function | Purpose |
|---|---|
| `ROUND` | Round to N decimal places |
| `ROUNDUP` | Always round up |
| `ROUNDDOWN` | Always round down |
| `INT` | Floor to nearest integer |
| `ABS` | Absolute value |
| `POWER` | Raise to a power |
| `SQRT` | Square root |
| `MOD` | Remainder of division |
| `CEILING` | Round up to nearest multiple |
| `FLOOR` | Round down to nearest multiple |

---

### ROUND / ROUNDUP / ROUNDDOWN
**Use when:** Controlling decimal precision in displayed numbers.
```dax
Rounded Sales   = ROUND(SUM(Sales[Sales]), 2)
Ceiling Sales   = ROUNDUP(SUM(Sales[Sales]), 0)
Floor Sales     = ROUNDDOWN(SUM(Sales[Sales]), 0)
```

---

### ABS
**Use when:** Ensuring a value is always positive (e.g. for loss calculations).
```dax
Absolute Profit = ABS(SUM(Sales[Profit]))
```

---

### POWER / SQRT
**Use when:** Exponential or root calculations.
```dax
Sales Squared = POWER(SUM(Sales[Sales]), 2)
Sales Sqrt    = SQRT(SUM(Sales[Sales]))
```

---

### MOD
**Use when:** Finding remainders — e.g. even/odd row banding.
```dax
Row Band =
IF(MOD(Sales[RowNumber], 2) = 0, "Even", "Odd")
```

---

## Quick Reference Cheat Sheet

```
AGGREGATION          CALCULATE & FILTER       TIME INTELLIGENCE
SUM()                CALCULATE()              TOTALYTD()
AVERAGE()            FILTER()                 TOTALMTD()
COUNT()              ALL()                    TOTALQTD()
COUNTA()             ALLEXCEPT()              SAMEPERIODLASTYEAR()
DISTINCTCOUNT()      ALLSELECTED()            DATEADD()
MAX() / MIN()        KEEPFILTERS()            DATESINPERIOD()
DIVIDE()                                      DATESBETWEEN()
                                              PREVIOUSMONTH/YEAR()
ITERATORS            LOGICAL
SUMX()               IF()                     RELATIONSHIP
AVERAGEX()           SWITCH(TRUE())           RELATED()
COUNTX()             AND() / OR()             RELATEDTABLE()
MAXX() / MINX()      IFERROR()                USERELATIONSHIP()
RANKX()              ISBLANK()                CROSSFILTER()

TEXT                 TABLE
CONCATENATE()        VALUES()                 INFO
CONCATENATEX()       SUMMARIZE()              HASONEVALUE()
FORMAT()             ADDCOLUMNS()             SELECTEDVALUE()
LEFT/RIGHT/MID()     SELECTCOLUMNS()          COUNTBLANK()
SUBSTITUTE()         TOPN()                   CONTAINS()
UPPER/LOWER/TRIM()   FILTER()
```

---

> **Note:** DAX measures respond to the current **filter context** — slicers, rows, columns, and CALCULATE all affect what a measure returns. Always test measures across different visual configurations.
