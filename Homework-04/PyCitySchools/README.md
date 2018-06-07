
# PyCity Schools Analysis

* The high school with the highest budget has the lowest percentage of students passing math and the second lowest overall passing percentage.

* All of the top performing schools are Charter schools with the bottom performing schools being District schools.

* Within each school, there is consistency in the math scores regardless of grade. 

* After reviewing this data, we need to collect further data points in order to determine why lower budget schools are outperforming higher budget schools.
---

### Note
* Instructions have been included for each segment. You do not have to follow them exactly, but they are included to help you think through the steps.


```python
# Dependencies and Setup
import pandas as pd
import numpy as np

# File to Load (Remember to Change These)
school_data_to_load = "Resources/schools_complete.csv"
student_data_to_load = "Resources/students_complete.csv"

# Read School and Student Data File and store into Pandas Data Frames
school_data = pd.read_csv(school_data_to_load)
student_data = pd.read_csv(student_data_to_load)

# Combine the data into a single dataset
school_data_complete = pd.merge(student_data, school_data, how="left", on=["school_name"])
school_data_complete.columns
```




    Index(['Student ID', 'name', 'gender', 'grade', 'school_name', 'reading_score',
           'math_score', 'School ID', 'type', 'size', 'budget'],
          dtype='object')



## District Summary

* Calculate the total number of schools

* Calculate the total number of students

* Calculate the total budget

* Calculate the average math score 

* Calculate the average reading score

* Calculate the overall passing rate (overall average score), i.e. (avg. math score + avg. reading score)/2

* Calculate the percentage of students with a passing math score (70 or greater)

* Calculate the percentage of students with a passing reading score (70 or greater)

* Create a dataframe to hold the above results

* Optional: give the displayed data cleaner formatting


```python
total_schools = len(school_data_complete["school_name"].unique())
total_students = len(school_data_complete["Student ID"])
total_budget = school_data_complete["budget"].unique().sum()
avg_math_score = school_data_complete["math_score"].mean()
avg_read_score = school_data_complete["reading_score"].mean()
pass_math_count = school_data_complete.loc[school_data_complete["math_score"] >= 70,["math_score"]].count()
pass_math = (pass_math_count["math_score"] / total_students) * 100
pass_read_count = school_data_complete.loc[school_data_complete["reading_score"] >= 70,["reading_score"]].count()
pass_read = (pass_read_count["reading_score"] / total_students) * 100
pass_overall = (pass_math + pass_read)/2

df_DistSummary = pd.DataFrame({"Total Schools":[total_schools],"Total Students":[total_students],"Total Budget":[total_budget], \
                                "Average Math Score":[avg_math_score], "Average Reading Score":[avg_read_score], \
                               "% Passing Math":[pass_math], "% Passing Reading":[pass_read], \
                               "% Overall Passing Rate":[pass_overall]})

df_DistSummary = df_DistSummary[["Total Schools","Total Students","Total Budget", \
                                "Average Math Score", "Average Reading Score", "% Passing Math", \
                                "% Passing Reading","% Overall Passing Rate"]]
df_DistSummary["Total Students"] = df_DistSummary["Total Students"].map("{0:,.0f}".format)
df_DistSummary["Total Budget"] = df_DistSummary["Total Budget"].map("${0:,.2f}".format)
df_DistSummary
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Schools</th>
      <th>Total Students</th>
      <th>Total Budget</th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>15</td>
      <td>39,170</td>
      <td>$24,649,428.00</td>
      <td>78.985371</td>
      <td>81.87784</td>
      <td>74.980853</td>
      <td>85.805463</td>
      <td>80.393158</td>
    </tr>
  </tbody>
</table>
</div>



## School Summary

* Create an overview table that summarizes key metrics about each school, including:
  * School Name
  * School Type
  * Total Students
  * Total School Budget
  * Per Student Budget
  * Average Math Score
  * Average Reading Score
  * % Passing Math
  * % Passing Reading
  * Overall Passing Rate (Average of the above two)
  
* Create a dataframe to hold the above results


```python
group_schools_df = school_data_complete.groupby(['school_name'])
school_total_students = group_schools_df['school_name'].count()
school_type = group_schools_df["type"].unique()
school_total_budget = group_schools_df["budget"].sum() / school_total_students
school_student_budget = school_total_budget / school_total_students
school_avg_math_score = group_schools_df["math_score"].mean()
school_avg_read_score = group_schools_df["reading_score"].mean()

schools_math70_df = school_data_complete.loc[school_data_complete['math_score'] >= 70]
group_schools_math70_df = schools_math70_df.groupby(['school_name'])
schools_pass_math = (group_schools_math70_df['school_name'].count() / school_total_students) * 100

schools_read70_df = school_data_complete.loc[school_data_complete['reading_score'] >= 70]
group_schools_read70_df = schools_read70_df.groupby(['school_name'])
schools_pass_read = (group_schools_read70_df['school_name'].count() / school_total_students) * 100
school_pass_overall = (schools_pass_math + schools_pass_read)/2


school_summary_df = pd.DataFrame({"School Type":school_type, \
                                 "Total Students":school_total_students, \
                                 "Total School Budget":school_total_budget, \
                                 "Per Student Budget":school_student_budget, \
                                 "Average Math Score":school_avg_math_score, \
                                 "Average Reading Score":school_avg_read_score, \
                                 "% Passing Math":schools_pass_math, \
                                  "% Passing Reading":schools_pass_read, \
                                  "% Overall Passing Rate":school_pass_overall
                                 })

school_summary_df = school_summary_df[["School Type","Total Students","Total School Budget", \
                                "Per Student Budget", "Average Math Score", "Average Reading Score", \
                                "% Passing Math", "% Passing Reading","% Overall Passing Rate"]]

school_summary_df["Total School Budget"] = school_summary_df["Total School Budget"].map("${0:,.2f}".format)
school_summary_df["Per Student Budget"] = school_summary_df["Per Student Budget"].map("${0:,.2f}".format)
school_summary_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School Type</th>
      <th>Total Students</th>
      <th>Total School Budget</th>
      <th>Per Student Budget</th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
    <tr>
      <th>school_name</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Bailey High School</th>
      <td>[District]</td>
      <td>4976</td>
      <td>$3,124,928.00</td>
      <td>$628.00</td>
      <td>77.048432</td>
      <td>81.033963</td>
      <td>66.680064</td>
      <td>81.933280</td>
      <td>74.306672</td>
    </tr>
    <tr>
      <th>Cabrera High School</th>
      <td>[Charter]</td>
      <td>1858</td>
      <td>$1,081,356.00</td>
      <td>$582.00</td>
      <td>83.061895</td>
      <td>83.975780</td>
      <td>94.133477</td>
      <td>97.039828</td>
      <td>95.586652</td>
    </tr>
    <tr>
      <th>Figueroa High School</th>
      <td>[District]</td>
      <td>2949</td>
      <td>$1,884,411.00</td>
      <td>$639.00</td>
      <td>76.711767</td>
      <td>81.158020</td>
      <td>65.988471</td>
      <td>80.739234</td>
      <td>73.363852</td>
    </tr>
    <tr>
      <th>Ford High School</th>
      <td>[District]</td>
      <td>2739</td>
      <td>$1,763,916.00</td>
      <td>$644.00</td>
      <td>77.102592</td>
      <td>80.746258</td>
      <td>68.309602</td>
      <td>79.299014</td>
      <td>73.804308</td>
    </tr>
    <tr>
      <th>Griffin High School</th>
      <td>[Charter]</td>
      <td>1468</td>
      <td>$917,500.00</td>
      <td>$625.00</td>
      <td>83.351499</td>
      <td>83.816757</td>
      <td>93.392371</td>
      <td>97.138965</td>
      <td>95.265668</td>
    </tr>
    <tr>
      <th>Hernandez High School</th>
      <td>[District]</td>
      <td>4635</td>
      <td>$3,022,020.00</td>
      <td>$652.00</td>
      <td>77.289752</td>
      <td>80.934412</td>
      <td>66.752967</td>
      <td>80.862999</td>
      <td>73.807983</td>
    </tr>
    <tr>
      <th>Holden High School</th>
      <td>[Charter]</td>
      <td>427</td>
      <td>$248,087.00</td>
      <td>$581.00</td>
      <td>83.803279</td>
      <td>83.814988</td>
      <td>92.505855</td>
      <td>96.252927</td>
      <td>94.379391</td>
    </tr>
    <tr>
      <th>Huang High School</th>
      <td>[District]</td>
      <td>2917</td>
      <td>$1,910,635.00</td>
      <td>$655.00</td>
      <td>76.629414</td>
      <td>81.182722</td>
      <td>65.683922</td>
      <td>81.316421</td>
      <td>73.500171</td>
    </tr>
    <tr>
      <th>Johnson High School</th>
      <td>[District]</td>
      <td>4761</td>
      <td>$3,094,650.00</td>
      <td>$650.00</td>
      <td>77.072464</td>
      <td>80.966394</td>
      <td>66.057551</td>
      <td>81.222432</td>
      <td>73.639992</td>
    </tr>
    <tr>
      <th>Pena High School</th>
      <td>[Charter]</td>
      <td>962</td>
      <td>$585,858.00</td>
      <td>$609.00</td>
      <td>83.839917</td>
      <td>84.044699</td>
      <td>94.594595</td>
      <td>95.945946</td>
      <td>95.270270</td>
    </tr>
    <tr>
      <th>Rodriguez High School</th>
      <td>[District]</td>
      <td>3999</td>
      <td>$2,547,363.00</td>
      <td>$637.00</td>
      <td>76.842711</td>
      <td>80.744686</td>
      <td>66.366592</td>
      <td>80.220055</td>
      <td>73.293323</td>
    </tr>
    <tr>
      <th>Shelton High School</th>
      <td>[Charter]</td>
      <td>1761</td>
      <td>$1,056,600.00</td>
      <td>$600.00</td>
      <td>83.359455</td>
      <td>83.725724</td>
      <td>93.867121</td>
      <td>95.854628</td>
      <td>94.860875</td>
    </tr>
    <tr>
      <th>Thomas High School</th>
      <td>[Charter]</td>
      <td>1635</td>
      <td>$1,043,130.00</td>
      <td>$638.00</td>
      <td>83.418349</td>
      <td>83.848930</td>
      <td>93.272171</td>
      <td>97.308869</td>
      <td>95.290520</td>
    </tr>
    <tr>
      <th>Wilson High School</th>
      <td>[Charter]</td>
      <td>2283</td>
      <td>$1,319,574.00</td>
      <td>$578.00</td>
      <td>83.274201</td>
      <td>83.989488</td>
      <td>93.867718</td>
      <td>96.539641</td>
      <td>95.203679</td>
    </tr>
    <tr>
      <th>Wright High School</th>
      <td>[Charter]</td>
      <td>1800</td>
      <td>$1,049,400.00</td>
      <td>$583.00</td>
      <td>83.682222</td>
      <td>83.955000</td>
      <td>93.333333</td>
      <td>96.611111</td>
      <td>94.972222</td>
    </tr>
  </tbody>
</table>
</div>



## Top Performing Schools (By Passing Rate)

* Sort and display the top five schools in overall passing rate


```python
top_school_summary_df = school_summary_df.sort_values("% Overall Passing Rate", ascending=False)
top_school_summary_df.head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>% Overall Passing Rate</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>Per Student Budget</th>
      <th>School Type</th>
      <th>Total School Budget</th>
      <th>Total Students</th>
    </tr>
    <tr>
      <th>school_name</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Cabrera High School</th>
      <td>95.586652</td>
      <td>94.133477</td>
      <td>97.039828</td>
      <td>83.061895</td>
      <td>83.975780</td>
      <td>$582.00</td>
      <td>[Charter]</td>
      <td>$1,081,356.00</td>
      <td>1858</td>
    </tr>
    <tr>
      <th>Thomas High School</th>
      <td>95.290520</td>
      <td>93.272171</td>
      <td>97.308869</td>
      <td>83.418349</td>
      <td>83.848930</td>
      <td>$638.00</td>
      <td>[Charter]</td>
      <td>$1,043,130.00</td>
      <td>1635</td>
    </tr>
    <tr>
      <th>Pena High School</th>
      <td>95.270270</td>
      <td>94.594595</td>
      <td>95.945946</td>
      <td>83.839917</td>
      <td>84.044699</td>
      <td>$609.00</td>
      <td>[Charter]</td>
      <td>$585,858.00</td>
      <td>962</td>
    </tr>
    <tr>
      <th>Griffin High School</th>
      <td>95.265668</td>
      <td>93.392371</td>
      <td>97.138965</td>
      <td>83.351499</td>
      <td>83.816757</td>
      <td>$625.00</td>
      <td>[Charter]</td>
      <td>$917,500.00</td>
      <td>1468</td>
    </tr>
    <tr>
      <th>Wilson High School</th>
      <td>95.203679</td>
      <td>93.867718</td>
      <td>96.539641</td>
      <td>83.274201</td>
      <td>83.989488</td>
      <td>$578.00</td>
      <td>[Charter]</td>
      <td>$1,319,574.00</td>
      <td>2283</td>
    </tr>
  </tbody>
</table>
</div>



## Bottom Performing Schools (By Passing Rate)

* Sort and display the five worst-performing schools


```python
bottom_school_summary_df = school_summary_df.sort_values("% Overall Passing Rate", ascending=True)
bottom_school_summary_df.head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>% Overall Passing Rate</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>Per Student Budget</th>
      <th>School Type</th>
      <th>Total School Budget</th>
      <th>Total Students</th>
    </tr>
    <tr>
      <th>school_name</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Rodriguez High School</th>
      <td>73.293323</td>
      <td>66.366592</td>
      <td>80.220055</td>
      <td>76.842711</td>
      <td>80.744686</td>
      <td>$637.00</td>
      <td>[District]</td>
      <td>$2,547,363.00</td>
      <td>3999</td>
    </tr>
    <tr>
      <th>Figueroa High School</th>
      <td>73.363852</td>
      <td>65.988471</td>
      <td>80.739234</td>
      <td>76.711767</td>
      <td>81.158020</td>
      <td>$639.00</td>
      <td>[District]</td>
      <td>$1,884,411.00</td>
      <td>2949</td>
    </tr>
    <tr>
      <th>Huang High School</th>
      <td>73.500171</td>
      <td>65.683922</td>
      <td>81.316421</td>
      <td>76.629414</td>
      <td>81.182722</td>
      <td>$655.00</td>
      <td>[District]</td>
      <td>$1,910,635.00</td>
      <td>2917</td>
    </tr>
    <tr>
      <th>Johnson High School</th>
      <td>73.639992</td>
      <td>66.057551</td>
      <td>81.222432</td>
      <td>77.072464</td>
      <td>80.966394</td>
      <td>$650.00</td>
      <td>[District]</td>
      <td>$3,094,650.00</td>
      <td>4761</td>
    </tr>
    <tr>
      <th>Ford High School</th>
      <td>73.804308</td>
      <td>68.309602</td>
      <td>79.299014</td>
      <td>77.102592</td>
      <td>80.746258</td>
      <td>$644.00</td>
      <td>[District]</td>
      <td>$1,763,916.00</td>
      <td>2739</td>
    </tr>
  </tbody>
</table>
</div>



## Math Scores by Grade

* Create a table that lists the average Reading Score for students of each grade level (9th, 10th, 11th, 12th) at each school.

  * Create a pandas series for each grade. Hint: use a conditional statement.
  
  * Group each series by school
  
  * Combine the series into a dataframe
  
  * Optional: give the displayed data cleaner formatting


```python
math_grade_9th_df = school_data_complete.loc[school_data_complete['grade'] == '9th']
group_math_grade_9th_df = math_grade_9th_df.groupby(['school_name'])
math_grade_9th = group_math_grade_9th_df['math_score'].mean()
math_grade_10th_df = school_data_complete.loc[school_data_complete['grade'] == '10th']
group_math_grade_10th_df = math_grade_10th_df.groupby(['school_name'])
math_grade_10th = group_math_grade_10th_df['math_score'].mean()
math_grade_11th_df = school_data_complete.loc[school_data_complete['grade'] == '11th']
group_math_grade_11th_df = math_grade_11th_df.groupby(['school_name'])
math_grade_11th = group_math_grade_11th_df['math_score'].mean()
math_grade_12th_df = school_data_complete.loc[school_data_complete['grade'] == '12th']
group_math_grade_12th_df = math_grade_12th_df.groupby(['school_name'])
math_grade_12th = group_math_grade_12th_df['math_score'].mean()

math_scores_by_grade_df = pd.DataFrame({"9th":math_grade_9th, \
                                 "10th":math_grade_10th, \
                                 "11th":math_grade_11th, \
                                 "12th":math_grade_12th, \
                                 })

math_scores_by_grade_df = math_scores_by_grade_df[['9th','10th','11th','12th']]

math_scores_by_grade_df["9th"] = math_scores_by_grade_df["9th"].map("{0:.2f}%".format)
math_scores_by_grade_df["10th"] = math_scores_by_grade_df["10th"].map("{0:.2f}%".format)
math_scores_by_grade_df["11th"] = math_scores_by_grade_df["11th"].map("{0:.2f}%".format)
math_scores_by_grade_df["12th"] = math_scores_by_grade_df["12th"].map("{0:.2f}%".format)

math_scores_by_grade_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>9th</th>
      <th>10th</th>
      <th>11th</th>
      <th>12th</th>
    </tr>
    <tr>
      <th>school_name</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Bailey High School</th>
      <td>77.08%</td>
      <td>77.00%</td>
      <td>77.52%</td>
      <td>76.49%</td>
    </tr>
    <tr>
      <th>Cabrera High School</th>
      <td>83.09%</td>
      <td>83.15%</td>
      <td>82.77%</td>
      <td>83.28%</td>
    </tr>
    <tr>
      <th>Figueroa High School</th>
      <td>76.40%</td>
      <td>76.54%</td>
      <td>76.88%</td>
      <td>77.15%</td>
    </tr>
    <tr>
      <th>Ford High School</th>
      <td>77.36%</td>
      <td>77.67%</td>
      <td>76.92%</td>
      <td>76.18%</td>
    </tr>
    <tr>
      <th>Griffin High School</th>
      <td>82.04%</td>
      <td>84.23%</td>
      <td>83.84%</td>
      <td>83.36%</td>
    </tr>
    <tr>
      <th>Hernandez High School</th>
      <td>77.44%</td>
      <td>77.34%</td>
      <td>77.14%</td>
      <td>77.19%</td>
    </tr>
    <tr>
      <th>Holden High School</th>
      <td>83.79%</td>
      <td>83.43%</td>
      <td>85.00%</td>
      <td>82.86%</td>
    </tr>
    <tr>
      <th>Huang High School</th>
      <td>77.03%</td>
      <td>75.91%</td>
      <td>76.45%</td>
      <td>77.23%</td>
    </tr>
    <tr>
      <th>Johnson High School</th>
      <td>77.19%</td>
      <td>76.69%</td>
      <td>77.49%</td>
      <td>76.86%</td>
    </tr>
    <tr>
      <th>Pena High School</th>
      <td>83.63%</td>
      <td>83.37%</td>
      <td>84.33%</td>
      <td>84.12%</td>
    </tr>
    <tr>
      <th>Rodriguez High School</th>
      <td>76.86%</td>
      <td>76.61%</td>
      <td>76.40%</td>
      <td>77.69%</td>
    </tr>
    <tr>
      <th>Shelton High School</th>
      <td>83.42%</td>
      <td>82.92%</td>
      <td>83.38%</td>
      <td>83.78%</td>
    </tr>
    <tr>
      <th>Thomas High School</th>
      <td>83.59%</td>
      <td>83.09%</td>
      <td>83.50%</td>
      <td>83.50%</td>
    </tr>
    <tr>
      <th>Wilson High School</th>
      <td>83.09%</td>
      <td>83.72%</td>
      <td>83.20%</td>
      <td>83.04%</td>
    </tr>
    <tr>
      <th>Wright High School</th>
      <td>83.26%</td>
      <td>84.01%</td>
      <td>83.84%</td>
      <td>83.64%</td>
    </tr>
  </tbody>
</table>
</div>



## Reading Score by Grade 

* Perform the same operations as above for reading scores


```python
read_grade_9th_df = school_data_complete.loc[school_data_complete['grade'] == '9th']
group_read_grade_9th_df = read_grade_9th_df.groupby(['school_name'])
read_grade_9th = group_read_grade_9th_df['reading_score'].mean()
read_grade_10th_df = school_data_complete.loc[school_data_complete['grade'] == '10th']
group_read_grade_10th_df = read_grade_10th_df.groupby(['school_name'])
read_grade_10th = group_read_grade_10th_df['reading_score'].mean()
read_grade_11th_df = school_data_complete.loc[school_data_complete['grade'] == '11th']
group_read_grade_11th_df = read_grade_11th_df.groupby(['school_name'])
read_grade_11th = group_read_grade_11th_df['reading_score'].mean()
read_grade_12th_df = school_data_complete.loc[school_data_complete['grade'] == '12th']
group_read_grade_12th_df = read_grade_12th_df.groupby(['school_name'])
read_grade_12th = group_read_grade_12th_df['reading_score'].mean()

read_scores_by_grade_df = pd.DataFrame({"9th":read_grade_9th, \
                                 "10th":read_grade_10th, \
                                 "11th":read_grade_11th, \
                                 "12th":read_grade_12th, \
                                 })

read_scores_by_grade_df = read_scores_by_grade_df[['9th','10th','11th','12th']]

read_scores_by_grade_df["9th"] = read_scores_by_grade_df["9th"].map("{0:.2f}%".format)
read_scores_by_grade_df["10th"] = read_scores_by_grade_df["10th"].map("{0:.2f}%".format)
read_scores_by_grade_df["11th"] = read_scores_by_grade_df["11th"].map("{0:.2f}%".format)
read_scores_by_grade_df["12th"] = read_scores_by_grade_df["12th"].map("{0:.2f}%".format)

read_scores_by_grade_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>9th</th>
      <th>10th</th>
      <th>11th</th>
      <th>12th</th>
    </tr>
    <tr>
      <th>school_name</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Bailey High School</th>
      <td>81.30%</td>
      <td>80.91%</td>
      <td>80.95%</td>
      <td>80.91%</td>
    </tr>
    <tr>
      <th>Cabrera High School</th>
      <td>83.68%</td>
      <td>84.25%</td>
      <td>83.79%</td>
      <td>84.29%</td>
    </tr>
    <tr>
      <th>Figueroa High School</th>
      <td>81.20%</td>
      <td>81.41%</td>
      <td>80.64%</td>
      <td>81.38%</td>
    </tr>
    <tr>
      <th>Ford High School</th>
      <td>80.63%</td>
      <td>81.26%</td>
      <td>80.40%</td>
      <td>80.66%</td>
    </tr>
    <tr>
      <th>Griffin High School</th>
      <td>83.37%</td>
      <td>83.71%</td>
      <td>84.29%</td>
      <td>84.01%</td>
    </tr>
    <tr>
      <th>Hernandez High School</th>
      <td>80.87%</td>
      <td>80.66%</td>
      <td>81.40%</td>
      <td>80.86%</td>
    </tr>
    <tr>
      <th>Holden High School</th>
      <td>83.68%</td>
      <td>83.32%</td>
      <td>83.82%</td>
      <td>84.70%</td>
    </tr>
    <tr>
      <th>Huang High School</th>
      <td>81.29%</td>
      <td>81.51%</td>
      <td>81.42%</td>
      <td>80.31%</td>
    </tr>
    <tr>
      <th>Johnson High School</th>
      <td>81.26%</td>
      <td>80.77%</td>
      <td>80.62%</td>
      <td>81.23%</td>
    </tr>
    <tr>
      <th>Pena High School</th>
      <td>83.81%</td>
      <td>83.61%</td>
      <td>84.34%</td>
      <td>84.59%</td>
    </tr>
    <tr>
      <th>Rodriguez High School</th>
      <td>80.99%</td>
      <td>80.63%</td>
      <td>80.86%</td>
      <td>80.38%</td>
    </tr>
    <tr>
      <th>Shelton High School</th>
      <td>84.12%</td>
      <td>83.44%</td>
      <td>84.37%</td>
      <td>82.78%</td>
    </tr>
    <tr>
      <th>Thomas High School</th>
      <td>83.73%</td>
      <td>84.25%</td>
      <td>83.59%</td>
      <td>83.83%</td>
    </tr>
    <tr>
      <th>Wilson High School</th>
      <td>83.94%</td>
      <td>84.02%</td>
      <td>83.76%</td>
      <td>84.32%</td>
    </tr>
    <tr>
      <th>Wright High School</th>
      <td>83.83%</td>
      <td>83.81%</td>
      <td>84.16%</td>
      <td>84.07%</td>
    </tr>
  </tbody>
</table>
</div>



## Scores by School Spending

* Create a table that breaks down school performances based on average Spending Ranges (Per Student). Use 4 reasonable bins to group school spending. Include in the table each of the following:
  * Average Math Score
  * Average Reading Score
  * % Passing Math
  * % Passing Reading
  * Overall Passing Rate (Average of the above two)


```python
# Sample bins. Feel free to create your own bins.
spending_bins = [0, 585, 615, 645, 675]
group_names = ["<$585", "$585-615", "$615-645", "$645-675"]
```


```python
group_schools_df2 = school_data_complete.groupby(['school_name'])
school_total_students2 = group_schools_df2['school_name'].count()
school_type2 = group_schools_df2["type"].unique()
school_total_budget2 = group_schools_df2["budget"].sum() / school_total_students2
school_student_budget2 = school_total_budget2 / school_total_students2
school_avg_math_score2 = group_schools_df2["math_score"].mean()
school_avg_read_score2 = group_schools_df2["reading_score"].mean()

schools_math70_df2 = school_data_complete.loc[school_data_complete['math_score'] >= 70]
group_schools_math70_df2 = schools_math70_df2.groupby(['school_name'])
schools_pass_math2 = (group_schools_math70_df2['school_name'].count() / school_total_students2) * 100

schools_read70_df2 = school_data_complete.loc[school_data_complete['reading_score'] >= 70]
group_schools_read70_df2 = schools_read70_df2.groupby(['school_name'])
schools_pass_read2 = (group_schools_read70_df2['school_name'].count() / school_total_students2) * 100
school_pass_overall2 = (schools_pass_math2 + schools_pass_read2)/2


school_summary_df2 = pd.DataFrame({"Per Student Budget":school_student_budget2, \
                                   "Average Math Score":school_avg_math_score2, \
                                 "Average Reading Score":school_avg_read_score2, \
                                 "% Passing Math":schools_pass_math2, \
                                  "% Passing Reading":schools_pass_read2, \
                                  "% Overall Passing Rate":school_pass_overall2
                                 })

school_summary_df2 = school_summary_df2[["Per Student Budget", "Average Math Score", "Average Reading Score", \
                                "% Passing Math", "% Passing Reading","% Overall Passing Rate"]]


school_summary_df2["Spending Ranges (Per Student)"] = pd.cut(school_summary_df2["Per Student Budget"], spending_bins, labels=group_names)
school_summary_df3 = school_summary_df2.groupby("Spending Ranges (Per Student)")
school_summary_df3 = school_summary_df3[["Average Math Score", "Average Reading Score", \
                                "% Passing Math", "% Passing Reading","% Overall Passing Rate"]]
school_summary_df3.max()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
    <tr>
      <th>Spending Ranges (Per Student)</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>&lt;$585</th>
      <td>83.803279</td>
      <td>83.989488</td>
      <td>94.133477</td>
      <td>97.039828</td>
      <td>95.586652</td>
    </tr>
    <tr>
      <th>$585-615</th>
      <td>83.839917</td>
      <td>84.044699</td>
      <td>94.594595</td>
      <td>95.945946</td>
      <td>95.270270</td>
    </tr>
    <tr>
      <th>$615-645</th>
      <td>83.418349</td>
      <td>83.848930</td>
      <td>93.392371</td>
      <td>97.308869</td>
      <td>95.290520</td>
    </tr>
    <tr>
      <th>$645-675</th>
      <td>77.289752</td>
      <td>81.182722</td>
      <td>66.752967</td>
      <td>81.316421</td>
      <td>73.807983</td>
    </tr>
  </tbody>
</table>
</div>



## Scores by School Size

* Perform the same operations as above, based on school size.


```python
# Sample bins. Feel free to create your own bins.
size_bins = [0, 1000, 2000, 5000]
group_names = ["Small (<1000)", "Medium (1000-2000)", "Large (2000-5000)"]
```


```python
group_schools_df3 = school_data_complete.groupby(['school_name'])
school_total_students3 = group_schools_df3['school_name'].count()
school_type3 = group_schools_df3["type"].unique()
#school_total_size3 = group_schools_df3["size"].count() / school_total_students3
school_student_size3 = group_schools_df3["size"].count()
school_avg_math_score3 = group_schools_df3["math_score"].mean()
school_avg_read_score3 = group_schools_df3["reading_score"].mean()

schools_math70_df3 = school_data_complete.loc[school_data_complete['math_score'] >= 70]
group_schools_math70_df3 = schools_math70_df3.groupby(['school_name'])
schools_pass_math3 = (group_schools_math70_df3['school_name'].count() / school_total_students3) * 100

schools_read70_df3 = school_data_complete.loc[school_data_complete['reading_score'] >= 70]
group_schools_read70_df3 = schools_read70_df3.groupby(['school_name'])
schools_pass_read3 = (group_schools_read70_df3['school_name'].count() / school_total_students3) * 100
school_pass_overall3 = (schools_pass_math3 + schools_pass_read3)/2


school_summary_df3 = pd.DataFrame({"Size":school_student_size3, \
                                   "Average Math Score":school_avg_math_score3, \
                                 "Average Reading Score":school_avg_read_score3, \
                                 "% Passing Math":schools_pass_math3, \
                                  "% Passing Reading":schools_pass_read3, \
                                  "% Overall Passing Rate":school_pass_overall3
                                 })

school_summary_df3 = school_summary_df3[["Size", "Average Math Score", "Average Reading Score", \
                                "% Passing Math", "% Passing Reading","% Overall Passing Rate"]]


school_summary_df3["School Size"] = pd.cut(school_summary_df3["Size"], size_bins, labels=group_names)
school_summary_df4 = school_summary_df3.groupby("School Size")
school_summary_df4 = school_summary_df4[["Average Math Score", "Average Reading Score", \
                                "% Passing Math", "% Passing Reading","% Overall Passing Rate"]]
school_summary_df4.max()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
    <tr>
      <th>School Size</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Small (&lt;1000)</th>
      <td>83.839917</td>
      <td>84.044699</td>
      <td>94.594595</td>
      <td>96.252927</td>
      <td>95.270270</td>
    </tr>
    <tr>
      <th>Medium (1000-2000)</th>
      <td>83.682222</td>
      <td>83.975780</td>
      <td>94.133477</td>
      <td>97.308869</td>
      <td>95.586652</td>
    </tr>
    <tr>
      <th>Large (2000-5000)</th>
      <td>83.274201</td>
      <td>83.989488</td>
      <td>93.867718</td>
      <td>96.539641</td>
      <td>95.203679</td>
    </tr>
  </tbody>
</table>
</div>



## Scores by School Type

* Perform the same operations as above, based on school type.


```python
group_schools_df1 = school_data_complete.groupby(['type'])
school_total_students1 = group_schools_df1['type'].count()
school_avg_math_score1 = group_schools_df1["math_score"].mean()
school_avg_read_score1 = group_schools_df1["reading_score"].mean()

schools_math70_df1 = school_data_complete.loc[school_data_complete['math_score'] >= 70]
group_schools_math70_df1 = schools_math70_df1.groupby(['type'])
schools_pass_math1 = (group_schools_math70_df1['type'].count() / school_total_students1) * 100

schools_read70_df1 = school_data_complete.loc[school_data_complete['reading_score'] >= 70]
group_schools_read70_df1 = schools_read70_df1.groupby(['type'])
schools_pass_read1 = (group_schools_read70_df1['type'].count() / school_total_students1) * 100
school_pass_overall1 = (schools_pass_math1 + schools_pass_read1)/2


school_summary_df1 = pd.DataFrame({"Average Math Score":school_avg_math_score1, \
                                 "Average Reading Score":school_avg_read_score1, \
                                 "% Passing Math":schools_pass_math1, \
                                  "% Passing Reading":schools_pass_read1, \
                                  "% Overall Passing Rate":school_pass_overall1
                                 })

school_summary_df1 = school_summary_df1[["Average Math Score", "Average Reading Score", \
                                "% Passing Math", "% Passing Reading","% Overall Passing Rate"]]

school_summary_df1

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
    <tr>
      <th>type</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Charter</th>
      <td>83.406183</td>
      <td>83.902821</td>
      <td>93.701821</td>
      <td>96.645891</td>
      <td>95.173856</td>
    </tr>
    <tr>
      <th>District</th>
      <td>76.987026</td>
      <td>80.962485</td>
      <td>66.518387</td>
      <td>80.905249</td>
      <td>73.711818</td>
    </tr>
  </tbody>
</table>
</div>


