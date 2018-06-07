import pandas as pd

file1 = "raw_data/budget_data_1.csv"
file2 = "raw_data/budget_data_2.csv"

df1 = pd.read_csv(file1,low_memory=False)

df1_array = df1["Date"].unique()
df1_minpos = df1["Revenue"].idxmin()
df1_maxpos = df1['Revenue'].idxmax()
df1_totalrev = df1["Revenue"].sum()
df1_avgrev = df1["Revenue"].mean()

minDate = df1.iloc[df1_minpos][0]
minRevenue = df1.iloc[df1_minpos][1]
maxDate = df1.iloc[df1_maxpos][0]
maxRevenue = df1.iloc[df1_maxpos][1]


print("Financial Analysis")
print("-----------------------------")
print("Total Months: " + str(len(df1_array)))
print("Total Revenue: ${0:,.0f}".format(df1_totalrev))
print("Average Revenue Change: ${0:,.0f}".format(df1_avgrev))
print("Greatest Increase in Revenue: " + maxDate + " (${0:,.0f}".format(maxRevenue) + ")")
print("Greatest Decrease in Revenue: " + minDate + " (${0:,.0f}".format(minRevenue) + ")")
