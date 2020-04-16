# Credit-Card-Segmentation--Data-Science-Capstone-project
Requirement is to develop a customer segmentation to define marketing strategy. The dataset summarizes the usage behaviour  of about 9000 active credit card holders during the last 6 month. The file is at a customer level with 18 behavioral variables.

Files:-

credit-card-data => Raw data that contains cust info.

Project_python1 => Python code in Jupyter notebook.

Project_R_1 => R code

Project Report => Detailed project repot with visualizations and behavioral patterns.

Credit-Card Segmentation Project DF_Python => Cluster formed with python code

Credit-Card Segmentation Project DF_R => Cluster formed with R code

The data contains 9000 observations and 18 variables. The following are the variables. 'CUST_ID', 'BALANCE', 'BALANCE_FREQUENCY', 'PURCHASES','ONEOFF_PURCHASES', 'INSTALLMENTS_PURCHASES', 'CASH_ADVANCE', 'PURCHASES_FREQUENCY', 'ONEOFF_PURCHASES_FREQUENCY','PURCHASES_INSTALLMENTS_FREQUENCY', 'CASH_ADVANCE_FREQUENCY','CASH_ADVANCE_TRX', 'PURCHASES_TRX', 'CREDIT_LIMIT', 'PAYMENTS','MINIMUM_PAYMENTS', 'PRC_FULL_PAYMENT', 'TENURE' 

Based on the cluster analysis the following were the characteristic features and marketing strategy derived from deep diving into the data.

Please refer the Project report.doc file for more info on deriving the characteristic features of the clusters.

Characteristics Analysis

Characteristics of Cluster 1(Good Payers, Hesitant user): -
1.	Not a frequent credit card user type.
2.	Most of the customers under cluster 1 use cash advance transaction and that too in lower frequency.
3.	Users have very low credit limit and high payment ratio(Willingness to pay).
4.	Limit usage is low and percentage for full payment is also low.
Marketing Strategy Ideas for Cluster 1: -
1.	A must to do step is to extend their credit limits.
2.	As many in Cluster 1 are cash advance type users, transaction and other minor charges while withdrawing can be reduced to increase frequency.
3.	Can provide low interest rates and money back offers for purchase types to encourage them to buy it more.
4.	Can provide a wifi card to encourage them to purchase more items at faster rates.

Characteristics of Cluster 2(Good payers and Good users): -
1.	Good cash advance transaction users.
2.	Decent purchase type users.
3.	Good payment ratio and good credit usage.
4.	Percentage of full payment is little low which implies that many wishes to keep a fair amount of balance in a continuous manner.
5.	Amount spent on one-off and installment purchases low but frequency is high.
Marketing Strategy Ideas for Cluster 2: -
1.	As they are good users and payers, reward points can be offered at high rates to them. So that they can use it to their advantages.
2.	Late fees and other minor charges can be eliminated to encourage them to use it at constant rate.
3.	Can provide internationally accepted cards.

Characteristics of Cluster 3(Mediocre users with some defaulters): -
1.	Good purchase type users. Both installment and one-off purchases.
2.	Poor cash advance users.
3.	Some customers have high payment ratio and low credit limit which makes them to be considered as defaulters in repaying.
4.	Credit limit spread is from low to high but the limit usage is low.
Marketing Strategy Ideas for Cluster 3: -
1.	The following strategy can be applied to the members apart from defaulters (Cust_ids with low credit limit and high payment ratio).
2.	Offering reduced interest rates and charges to expensive products can boost their limit usages to higher extent.
3.	Can advertise regarding the advantages of using cash advance transaction which could make them to use it.

Data Analysis: -
1.	Missing Value Analysis

The following were the missing num of data from the variable. 

MINIMUM_PAYMENTS	313

The missing values were then imputed using KNN imputation method. 
Note:- Mean, Median, KNN imputation methods were tested by picking random observation and then the best impute method(KNN) was devised.


2.	Feature Engineering: -

There were three variables 'ONEOFF_PURCHASES', 'INSTALLMENTS_PURCHASES', 'CASH_ADVANCE' which gave the amount used on each type of transactions. Based on this new variable 

‘Card_use_type’ derived, which tells what type of transaction that the customer has u’sed. (For ex:- if ONEOFF_PURCHASES' > 0 -- Card_use_type’==’One off’. If all type of transactions are used then ‘ALL type’. 

Monthly Avg Purchase= (Purchase Amt)/n.o of months used for purchasing

N.o of months used for purchasing=purchase freq*Tenure

Monthly Cash Adv Amt=(Cash Adv Amt)/(n.o of months used for cash adv amt)

N.o of months used for cash adv amt=cash adv amt freq*Tenure

Limit Usage:- Balance/Credit Limit

Payment Ratio=Payment/Min Payment due

3.	Outlier Analysis

Box plot was visualized and the outliers for the following variables 'BALANCE','CREDIT_LIMIT','PAYMENTS' were dropped.

4.	Correlation Analysis

Heatmap was drawn between the numerical variables and based on the outcomes the following variables 'BALANCE','BALANCE_FREQUENCY','PURCHASES_FREQUENCY','CASH_ADVANCE_FREQUENCY','PRC_FULL_PAYMENT','Monthly_Avg_Purchase','Monthly_avg_cash_adv_amt', 'Limit_Usage','Payment_Ratio' was dropped.

5.	Normalization

The numerical data was normalized using standardization technique.

6.	Model Development

 
Elbow method was visualized to extract the errors and the optimum number of clusters. From the graph the optimum num taken was 3.

Kmeans clustering was devised and the observations were classified into three clusters.

1    3340


2    2701

0    1239

Please refer the Project report.doc file for more info on deriving the characteristic features of the clusters.

