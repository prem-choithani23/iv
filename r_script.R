# ============================================================
#  INFO VIS — Experiment 8 | R Visualization Helper Script
#  Name: Prem Choithani | UID: 2023300032
#  Topic: Introduction to R and Basic Visualization
# ============================================================


# ── SETUP ────────────────────────────────────────────────────
# Install packages if not already installed (run once)
# install.packages("ggplot2")

library(ggplot2)


# ============================================================
#  READING A CSV FILE
# ============================================================

# Syntax 1: Basic — file is in the same folder as your R script
df <- read.csv("Sample - Superstore.csv")

# Syntax 2: Full path (Windows — use forward slashes)
df <- read.csv("C:/Users/YourName/Downloads/Sample - Superstore.csv")

# Syntax 3: Full path (Mac/Linux)
df <- read.csv("/Users/YourName/Downloads/Sample - Superstore.csv")

# Syntax 4: With options (useful for tricky CSVs)
df <- read.csv("Sample - Superstore.csv",
               header           = TRUE,   # TRUE = first row is column names
               sep              = ",",    # separator: "," or ";" or "\t"
               stringsAsFactors = FALSE)  # keeps text columns as plain text

# ── After loading — always inspect first ─────────────────────
head(df)        # first 6 rows
tail(df)        # last 6 rows
str(df)         # column names + data types
summary(df)     # min, max, mean etc. for each column
colnames(df)    # just the column names
nrow(df)        # number of rows
ncol(df)        # number of columns


# ============================================================
#  PART A — BASE R VISUALIZATIONS using mtcars dataset
# ============================================================
# mtcars is built-in — no loading needed
# Access any column with:  dataframe$ColumnName


# ── A1. SCATTER PLOT — Weight vs Mileage ─────────────────────
# Use when: exploring correlation between two continuous variables

plot(mtcars$wt, mtcars$mpg,       # x = weight, y = mileage
     main = "Weight vs Mileage",
     xlab = "Weight",
     ylab = "Mileage",
     col  = "blue",
     pch  = 19)                   # pch=19 → solid circle marker

# Same using df (Superstore):
# plot(df$Sales, df$Profit,
#      main = "Sales vs Profit",
#      xlab = "Sales", ylab = "Profit",
#      col  = "blue", pch = 19)


# ── A2. LINE PLOT ────────────────────────────────────────────
# Use when: visualizing trends or continuous relationships

x <- c(1, 2, 3, 4, 5)
y <- c(2, 4, 6, 8, 10)

plot(x, y,
     type = "l",    # "l"=line | "p"=points | "b"=both
     col  = "red",
     main = "Line Plot")


# ── A3. BAR PLOT ─────────────────────────────────────────────
# Use when: comparing counts or values across categories

counts <- c(12, 18, 25, 10)

barplot(counts,
        names.arg = c("A", "B", "C", "D"),  # category labels
        col  = "green",
        main = "Bar Plot")

# Using df — total Sales per Category:
# category_sales <- tapply(df$Sales, df$Category, sum)  # aggregate
# barplot(category_sales,
#         col  = "steelblue",
#         main = "Sales by Category",
#         xlab = "Category", ylab = "Total Sales")


# ── A4. HISTOGRAM — Mileage Distribution ─────────────────────
# Use when: understanding distribution of a single numeric variable

hist(mtcars$mpg,
     col  = "orange",
     main = "Mileage Distribution")

# Using df:
# hist(df$Sales,
#      col  = "orange",
#      main = "Sales Distribution",
#      xlab = "Sales")


# ── A5. BOXPLOT — Single Variable ────────────────────────────
# Use when: checking median, spread (IQR), and outliers

boxplot(mtcars$mpg,
        col  = "pink",
        main = "Mileage Boxplot")

# Using df:
# boxplot(df$Profit,
#         col  = "pink",
#         main = "Profit Boxplot")


# ── A6. GROUPED BOXPLOT — Mileage by Cylinders ───────────────
# Use when: comparing distributions of a variable across groups
# Formula: numeric_column ~ grouping_column

boxplot(mpg ~ cyl,
        data = mtcars,
        col  = "yellow",
        main = "Mileage by Cylinders")

# Using df:
# boxplot(Profit ~ Category,
#         data = df,
#         col  = "yellow",
#         main = "Profit by Category")


# ============================================================
#  PART B — ggplot2 VISUALIZATIONS using df (Superstore)
# ============================================================
#
#  ggplot2 structure:
#    ggplot(df, aes(x = ColName, y = ColName, color = ColName)) +
#    geom_CHARTTYPE() +
#    ggtitle("Title")
#
#  IMPORTANT: Inside ggplot/aes(), write column names directly
#             Do NOT use df$Column — just Column
#


# ── B1. BAR PLOT — Sales by Category ─────────────────────────
# Use when: comparing total values across categories
# stat="identity" → use actual y values as bar height (not count)

ggplot(df, aes(x = Category, y = Sales)) +
  geom_bar(stat = "identity") +
  ggtitle("Sales by Category")


# ── B2. HISTOGRAM — Sales Distribution ───────────────────────
# Use when: analyzing spread/distribution of a numeric variable
# binwidth = width of each bin (adjust for more or less detail)

ggplot(df, aes(x = Sales)) +
  geom_histogram(binwidth = 100) +
  ggtitle("Sales Distribution")


# ── B3. SCATTER PLOT — Sales vs Profit ───────────────────────
# Use when: exploring relationship between two numeric variables

ggplot(df, aes(x = Sales, y = Profit)) +
  geom_point() +
  ggtitle("Sales vs Profit")


# ── B4. BOXPLOT — Profit by Category ─────────────────────────
# Use when: comparing distributions across category groups

ggplot(df, aes(x = Category, y = Profit)) +
  geom_boxplot() +
  ggtitle("Profit by Category")


# ── B5. COUNT PLOT — Region ──────────────────────────────────
# Use when: counting records per category (no y needed)
# geom_bar() with no y → auto-counts using stat="count"

ggplot(df, aes(x = Region)) +
  geom_bar() +
  ggtitle("Order Count by Region")


# ── B6. COLORED SCATTER — Sales vs Profit by Category ────────
# Use when: scatter + distinguish groups by color
# color = column → auto-assigns colors + generates legend

ggplot(df, aes(x = Sales, y = Profit, color = Category)) +
  geom_point() +
  ggtitle("Sales vs Profit by Category")


# ============================================================
#  QUICK REFERENCE
# ============================================================
#
#  READING CSV
#  df <- read.csv("filename.csv")                  # basic
#  df <- read.csv("path/file.csv", header=TRUE)    # with options
#
#  ACCESSING COLUMNS
#  df$ColumnName                    → base R
#  aes(x = ColumnName)             → inside ggplot (no df$ needed)
#
#  AGGREGATING (useful for barplot in base R)
#  tapply(df$Sales, df$Category, sum)   → sum of Sales per Category
#  tapply(df$Sales, df$Category, mean)  → mean of Sales per Category
#
#  CHART FUNCTION REFERENCE
#  plot()            Scatter / Line    Correlation, trends
#  barplot()         Bar Chart         Category comparison
#  hist()            Histogram         Distribution of 1 var
#  boxplot()         Box Plot          Spread & outliers
#  geom_bar()        Bar / Count       Category freq/totals
#  geom_histogram()  Histogram         Distribution (ggplot)
#  geom_point()      Scatter Plot      Correlation (ggplot)
#  geom_boxplot()    Box Plot          Group comparison
#
# ============================================================
