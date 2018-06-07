
import pandas as pd

file1 = "raw_data/employee_data1.csv"
file2 = "raw_data/employee_data2.csv"

df1 = pd.read_csv(file1,low_memory=False)
df2 = pd.read_csv(file2,low_memory=False)

df = df1.append(df2)

df[['Name','Last Name']] = df['Name'].str.split(' ',expand=True)
df.rename(columns={'Name': 'First Name'}, inplace=True)
df['SSN'] = "***-**-" + df.SSN.str[7:]
df['DOB'] = pd.to_datetime(df['DOB']).dt.strftime('%m/%d/%Y')

us_state_abbrev = {
    'Alabama': 'AL',
    'Alaska': 'AK',
    'Arizona': 'AZ',
    'Arkansas': 'AR',
    'California': 'CA',
    'Colorado': 'CO',
    'Connecticut': 'CT',
    'Delaware': 'DE',
    'Florida': 'FL',
    'Georgia': 'GA',
    'Hawaii': 'HI',
    'Idaho': 'ID',
    'Illinois': 'IL',
    'Indiana': 'IN',
    'Iowa': 'IA',
    'Kansas': 'KS',
    'Kentucky': 'KY',
    'Louisiana': 'LA',
    'Maine': 'ME',
    'Maryland': 'MD',
    'Massachusetts': 'MA',
    'Michigan': 'MI',
    'Minnesota': 'MN',
    'Mississippi': 'MS',
    'Missouri': 'MO',
    'Montana': 'MT',
    'Nebraska': 'NE',
    'Nevada': 'NV',
    'New Hampshire': 'NH',
    'New Jersey': 'NJ',
    'New Mexico': 'NM',
    'New York': 'NY',
    'North Carolina': 'NC',
    'North Dakota': 'ND',
    'Ohio': 'OH',
    'Oklahoma': 'OK',
    'Oregon': 'OR',
    'Pennsylvania': 'PA',
    'Rhode Island': 'RI',
    'South Carolina': 'SC',
    'South Dakota': 'SD',
    'Tennessee': 'TN',
    'Texas': 'TX',
    'Utah': 'UT',
    'Vermont': 'VT',
    'Virginia': 'VA',
    'Washington': 'WA',
    'West Virginia': 'WV',
    'Wisconsin': 'WI',
    'Wyoming': 'WY',
}

df["State"].replace(us_state_abbrev, inplace=True)

df = df[['Emp ID', 'First Name', 'Last Name', 'DOB', 'SSN', 'State']]

df.to_csv("employee_data_all.csv", index=False, header=True)

