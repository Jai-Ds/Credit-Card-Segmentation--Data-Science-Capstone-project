
#Load Libraries
x = c("ggplot2", "corrgram", "DMwR", "caret", "randomForest", "unbalanced", "C50", "dummies", "e1071", "Information",
      "MASS", "rpart", "gbm", "ROSE", 'sampling', 'DataCombine', 'inTrees')

#install.packages(x)
lapply(x, require, character.only = TRUE)
rm(x)
library("corrplot")

rm(list=ls())
setwd("C:/Users/Jayandran/Documents/Edwisor Questions")
getwd()
#Extracting the excel 
df_card=read.csv("credit-card-data.csv",header=TRUE)

##Missing Value Analysis
##Missing Values
##Credit limit-1, Minimum Payment-313
##Removing one NA row where credit limit =NA

r=as.list(is.na(df_card$CREDIT_LIMIT))
typeof(r)

#Finding index value of the NA(Credit Limit)
for(i in 1:length(r)){
  if(r[i]==TRUE){
    print(i)
  }
}
#index value=5204
#Removing the specific index
df_card=df_card[-c(5204),]

#Resetting row numbers after removing the values
rownames(df_card) <- seq(length=nrow(df_card))
-----------------------------------------------------------------------------------------------------
#Missing Value Analysis for Minimum Payment
#313 missing value in Minimum Payments
#Percentage is (313/8949)*100=34.95%
#optimal percent is 30. This cant be excluded as it is important var. Hence imputing the missing values.

df_card$MINIMUM_PAYMENTS[34]
# 196.3019

df_card$MINIMUM_PAYMENTS[34]=NA

#Mean Method
df_card$MINIMUM_PAYMENTS[34]=mean(df_card$MINIMUM_PAYMENTS,na.rm = TRUE)
df_card$MINIMUM_PAYMENTS[34]
#864.3823- Very large variance

#Median Method
df_card$MINIMUM_PAYMENTS[34]=NA
df_card$MINIMUM_PAYMENTS[34]=median(df_card$MINIMUM_PAYMENTS,na.rm = TRUE)
df_card$MINIMUM_PAYMENTS[34]
#312.5606

#KNN method
df_card$MINIMUM_PAYMENTS[34]=NA
custid=df_card$CUST_ID
df_card$CUST_ID=as.numeric(df_card$CUST_ID)
df_card=knnImputation(df_card,k=5)
df_card$CUST_ID=custid
df_card$MINIMUM_PAYMENTS[34]
#191.1233
#As 191.1233 is nearer to 196.3019 we consider KNN method to impute the values.
#------------------------------------------------------------------------------------------------------------------------------------------------
#Outlier Analysis

#Dervivng #Categorical Variable Card_use_type
df_card$Purchase_by_Type[df_card$ONEOFF_PURCHASES >0]="One-Off"
df_card$Purchase_by_Type[df_card$INSTALLMENTS_PURCHASES >0]="Installment"
df_card$Purchase_by_Type[df_card$ONEOFF_PURCHASES>0 & df_card$INSTALLMENTS_PURCHASES>0]="Both Purchases"
df_card[is.na(df_card)]="Cash Advance"

#Removing the observation which doesn't have any type of usage in credit card
df_card[which(df_card$CASH_ADVANCE==0 & df_card$ONEOFF_PURCHASES==0 & df_card$INSTALLMENTS_PURCHASES==0),]
df_card=df_card[-c(2222),]
rownames(df_card) <- seq(length=nrow(df_card))

df_card$Purchase_by_Type[df_card$ONEOFF_PURCHASES>0 & df_card$INSTALLMENTS_PURCHASES>0 & df_card$CASH_ADVANCE>0]="All Three"
names(df_card)[names(df_card) == "Purchase_by_Type"] <- "Card_use_type"

#Converting to appropriate classes
df_card$Card_use_type=as.factor(df_card$Card_use_type)
df_card$CASH_ADVANCE_TRX=as.numeric(df_card$CASH_ADVANCE_TRX)
df_card$PURCHASES_TRX=as.numeric(df_card$PURCHASES_TRX)
df_card$TENURE=as.numeric(df_card$TENURE)
df_card$CUST_ID=as.character(df_card$CUST_ID)

numeric_index=sapply(df_card,is.numeric)
numeric_data=df_card[,numeric_index]
cnames=colnames(numeric_data)
cnames
rm(i)
#Boxplot
for(i in 1:length(cnames))
  {
  assign(paste0("gn",i), ggplot(aes_string(y = (cnames[i]),), data = subset(df_card))+ 
           stat_boxplot(geom = "errorbar", width = 0.5) +
    geom_boxplot(outlier.colour="red", fill = "grey" ,outlier.shape=18,
               outlier.size=1, notch=FALSE) +
    theme(legend.position="bottom")+
    labs(y=cnames[i])+
    ggtitle(paste("Box plot of Card use type for",cnames[i])))
  }

#Plotting plots together
gridExtra::grid.arrange(gn1)
gridExtra::grid.arrange(gn3)
gridExtra::grid.arrange(gn6)
gridExtra::grid.arrange(gn13)
gridExtra::grid.arrange(gn14)
gridExtra::grid.arrange(gn15)
gridExtra::grid.arrange(gn16)

#Removing Outliers for balance variable as marketting strategy for high balance members is not much needed.
val=df_card$BALANCE[df_card$BALANCE %in% boxplot.stats(df_card$BALANCE)$out]
#Neglecting  entries
df_card=df_card[which(!df_card$BALANCE %in% val),]

#Removing Outliers for Payment variable
val=df_card$PAYMENTS[df_card$PAYMENTS %in% boxplot.stats(df_card$PAYMENTS)$out]
val
#Neglecting  entries
df_card=df_card[which(!df_card$PAYMENTS %in% val),]


#Removing Outliers for Credit Limit variable
val=df_card$CREDIT_LIMIT[df_card$CREDIT_LIMIT %in% boxplot.stats(df_card$CREDIT_LIMIT)$out]
val
#Neglecting  entries
df_card=df_card[which(!df_card$CREDIT_LIMIT %in% val),]


#-------------------------------------------------------------------------------------------------------------------------
#Deriving new KPI's. 
#Monthly Avg Purchase=(Purchase Amt)/n.o of months used for purchasing
#N.o of months used for purchasing=purchase freq*Tenure
df_card$Months_used_for_Purchase=round((df_card$PURCHASES_FREQUENCY)*(df_card$TENURE),digits = 2)
df_card$Monthly_Avg_Purchase=df_card$PURCHASES/df_card$Months_used_for_Purchase
df_card[is.na(df_card)]=0

#Monthly Cash Adv Amt=(Cash Adv Amt)/(n.o of months used for cash adv amt)
#N.o of months used for cash adv amt=cash adv amt freq*Tenure
df_card$Months_used_for_cash_adv=round((df_card$CASH_ADVANCE_FREQUENCY)*(df_card$TENURE),digits = 2)
df_card$Monthly_Avg_Cash_Adv_Amt=df_card$CASH_ADVANCE/df_card$Months_used_for_cash_adv
df_card[is.na(df_card)]=0


#No.of Transactions=Total amt/Average amt per transaction
#N.o_of_purchase_trans and n.o_of_cash_adv_trans
df_card$N.o_of_purchase_trans=round(df_card$PURCHASES/df_card$PURCHASES_TRX)
df_card[is.na(df_card)]=0

df_card$N.o_of_cash_adv_trans=round(df_card$CASH_ADVANCE/df_card$CASH_ADVANCE_TRX)
df_card[is.na(df_card)]=0

#Limit Usage:- Balance/Credit Limit
df_card$Limit_Usage=df_card$BALANCE/df_card$CREDIT_LIMIT

#Payment Ratio=Payment/Min Payment due
df_card$Payment_Ratio=df_card$PAYMENTS/df_card$MINIMUM_PAYMENTS

#-------------------------------------------------------------------------------------------------------------------------

#Correlation Analysis

#Correcting vriable types
str(df_card)

sum(is.na(df_card))

numeric_index=sapply(df_card,is.numeric)
numeric_index
corrgram(df_card[,numeric_index],order=F,upper.panel=panel.pie,text.panel=panel.txt,main="Correlation Plot")
#Analyzing the correlation diag. Neglecting few var and again checking

df_card_corr=subset(df_card[,numeric_index],select=-c(N.o_of_purchase_trans,N.o_of_cash_adv_trans,ONEOFF_PURCHASES,INSTALLMENTS_PURCHASES,CREDIT_LIMIT,TENURE,Months_used_for_Purchase,Months_used_for_cash_adv))

#Analyzing again
corrgram(df_card_corr,order=F,upper.panel=panel.pie,text.panel=panel.txt,main="Correlation Plot")

df_card_corr=subset(df_card_corr,select=-c(CASH_ADVANCE_TRX,PURCHASES_TRX,PURCHASES,CASH_ADVANCE,PAYMENTS,MINIMUM_PAYMENTS))

#Analyzing again
corrgram(df_card_corr,order=F,upper.panel=panel.pie,text.panel=panel.txt,main="Correlation Plot")

df_card_corr=subset(df_card_corr,select=-c(ONEOFF_PURCHASES_FREQUENCY,PURCHASES_INSTALLMENTS_FREQUENCY))

#Analyzing again
corrgram(df_card_corr,order=F,upper.panel=panel.pie,text.panel=panel.txt,main="Correlation Plot")

library("usdm")
vif(df_card_corr)
vifcor(df_card_corr,th=0.8)
#No variable from the 9 input variables has collinearity problem. 

library("NbClust")
#Cluster Analysis
df_new=data.frame(scale(df_card_corr))

#Extract number of clusters to build
NBclust_res=NbClust(df_new,min.nc=2,max.nc = 9,method = "kmeans" )
#* According to the majority rule, the best number of clusters is  3 

#Bar Plot to analyze optimum cluster
barplot(table(NBclust_res$Best.n[1,]), xlab="N.o of cluster",ylab="N.o of criteria", main="N.o of Clusters chosen by many criteria")

#K-Mean Clustering
kmeans_model=kmeans(df_new,3,nstart=23)
kmeans_model
#K-means clustering with 3 clusters of sizes 3139, 1396, 3718
typeof(kmeans_model$cluster)
#integer
df_cluster=data.frame(kmeans_model$cluster)
View(df_cluster)
rownames(df_cluster) <- seq(length=nrow(df_card))

#Appending the category to the data frame
df_card=cbind(df_card,df_cluster)
rownames(df_card) <- seq(length=nrow(df_cluster))

length(unique(df_card$kmeans_model.cluster))
---------------------------------------------------------------------------------------------------------------------------
#Visualizations

library("ggplot2")
library("scales")
library("psych")
library("gplots")

df_card$kmeans_model.cluster=as.factor(df_card$kmeans_model.cluster)

#Bar-Plots-Cluster and its counts
ggplot(df_card, aes(x = df_card$kmeans_model.cluster, fill=df_card$Card_use_type)) +
  geom_bar(stat="count",aes(fill = df_card$Card_use_type)) +theme_bw() +
  theme(text=element_text(size=25))+
  xlab("Cluster") + ylab('Count') + scale_y_continuous(breaks=pretty_breaks(n=10)) +
  ggtitle("Cluster category count") +  theme(text=element_text(size=15))+
  scale_fill_discrete(name="Card_Use_Type")

#Cluster 1-1217, Cluster2-3292, Cluster3-2670
#From the above graph the following is inferred
# 1- Cluster 3 have minimal number of All three tye of purchase compared to other two
# 2- Cluster 1 have minimal number of All three tye of purchase and Cash advance transactions compared to other two.

#Bar-Plot- Cluster and Monthly Average purchase
ggplot(df_card, aes(x = df_card$kmeans_model.cluster,y=df_card$Monthly_Avg_Purchase, fill=df_card$Card_use_type)) +
  geom_bar(stat="identity") +theme_bw() +
  theme(text=element_text(size=25))+
  xlab("Cluster") + ylab("Monthly_avg_purchase") + scale_y_continuous(breaks=pretty_breaks(n=10)) +
  ggtitle("Cluster category- Monthly avg purchase") +  theme(text=element_text(size=15))+
  scale_fill_discrete(name="Cluster")

#Cluster 1 has zero-low monthly_average_purchase compared to other two
#Cluster 2 has zero-nominal monthly average_purchase compared to other two.
#cluster 3 has zero-high monthly average purchase compared to other two.


#Bar-Plot- Cluster and Purchase freq
ggplot(df_card, aes(x = df_card$kmeans_model.cluster,y=df_card$PURCHASES_FREQUENCY, fill=df_card$Card_use_type)) +
  geom_bar(stat="identity") +theme_bw() +
  theme(text=element_text(size=25))+
  xlab("Cluster") + ylab("Purchase_freq") + scale_y_continuous(breaks=pretty_breaks(n=10)) +
  ggtitle("Cluster category- Purchase_freq") +  theme(text=element_text(size=15))+
  scale_fill_discrete(name="Cluster")

#Cluster 1 has purchase freq from zero- low as compared to other two clusters.
#Cluster 2 has purchase freq from zero- medium as compared to other two clusters.
#Cluster 3 has purchase freq from zero- high as compared to other two clusters.


#Scatter-Plot- Monthly Avg purchase and Purchase freq- To infer based on purchase type and not by cluster
ggplot(df_card, aes_string(x = df_card$Monthly_Avg_Purchase, y = df_card$PURCHASES_FREQUENCY)) + 
  geom_point(aes_string(colour = df_card$Card_use_type, shape = df_card$kmeans_model.cluster),size = 4) +
  theme_bw()+ ylab("Purchase freq") + xlab("Monthly Avg Purchase") + ggtitle("Scatter plot Analysis-") + 
  theme(text=element_text(size=25)) +
  scale_x_continuous(breaks=pretty_breaks(n=10)) +
  scale_y_continuous(breaks=pretty_breaks(n=10)) +
  scale_colour_discrete(name="Card Use Type")+
  scale_shape_discrete(name="Cluster")

#Installment purchase is less on monthly purchase(almost <250) but purchase freq is evenly distributed.
#The persons having all three purchases has high purchase frequency but less monthly_avg_amt purchase(<500) 
#The persons having both purchase type has high purchase frequency(>0.5) and nominal monthly_avg_purchase 
#The persons having one-off purchase type has less frequency and more monthly average 

#Cluster Classification

#Scatter-Plot-Monthly avg purchase and purchase freq
ggplot(df_card, aes_string(x = df_card$Monthly_Avg_Purchase, y = df_card$PURCHASES_FREQUENCY)) + 
  geom_point(aes_string(colour = df_card$kmeans_model.cluster),size = 4) +
  theme_bw()+ ylab("Purchase freq") + xlab("Monthly Avg Purchase") + ggtitle("Scatter plot Analysis-Monthly avg purchase and purchase freq") + 
  theme(text=element_text(size=25)) +
  scale_x_continuous(breaks=pretty_breaks(n=10)) +
  scale_y_continuous(breaks=pretty_breaks(n=10)) +
  scale_colour_discrete(name="Cluster")

#Cluster 1- has low purchase frequency
#Cluster 2- has equal spread of purchase frequency as well  monthly_average
#Cluster 3- has almost higher purchase frequency >0.4, also has a little lower monthly average purchase

#Cluster Classification

#Scatter-Plot-Monthly avg cash adv and cash adv freq
ggplot(df_card, aes_string(x = df_card$Monthly_Avg_Cash_Adv_Amt, y = df_card$CASH_ADVANCE_FREQUENCY)) + 
  geom_point(aes_string(colour = df_card$kmeans_model.cluster),size = 4) +
  theme_bw()+ ylab("Cash Advance freq") + xlab("Monthly Avg Cash Advance") + ggtitle("Scatter plot Analysis-Monthly avg cash adv and cash adv freq") + 
  theme(text=element_text(size=25)) +
  scale_x_continuous(breaks=pretty_breaks(n=10)) +
  scale_y_continuous(breaks=pretty_breaks(n=10)) +
  scale_colour_discrete(name="Cluster")

#Cluster 1 and Cluster 3 has low Cash_advance_frequency.
#Cluster 1 has 0-decent monthly cash adv average
#Cluster 2 has good purchase frequency as well as good monthly average cash adv.

#Scatter-Plot- Monthly avg cash adv amt and cash adv freq along with use type
ggplot(df_card, aes_string(x = df_card$Monthly_Avg_Cash_Adv_Amt, y = df_card$CASH_ADVANCE_FREQUENCY)) + 
  geom_point(aes_string(colour = df_card$Card_use_type, shape = df_card$kmeans_model.cluster),size = 4) +
  theme_bw()+ ylab("Cash adv freq freq") + xlab("Monthly Avg cash adv amt") + ggtitle("Scatter plot Analysis-Monthly avg cash adv amt and cash adv freq Monthly avg cash adv amt and cash adv freq along with use type") + 
  theme(text=element_text(size=25)) +
  scale_x_continuous(breaks=pretty_breaks(n=10)) +
  scale_y_continuous(breaks=pretty_breaks(n=10)) +
  scale_colour_discrete(name="Card Use Type")+
  scale_shape_discrete(name="Cluster")

#Contrasting to Purchase freq nference, All three purchase freq has almost low cash adv freq and low cash adv amt.
#Cash adv use type is spread equally around along with cash adv freq and monthly avg cash adv amt.
#Higher the amt goes lower the cash adv freq occurs.

#Bar-Plot- Cluster and cash adv freq
ggplot(df_card, aes(x = df_card$kmeans_model.cluster,y=df_card$CASH_ADVANCE_FREQUENCY, fill=df_card$Card_use_type)) +
  geom_bar(stat="identity") +theme_bw() +
  theme(text=element_text(size=25))+
  xlab("Cluster") + ylab("Cash_adv_freq") + scale_y_continuous(breaks=pretty_breaks(n=10)) +
  ggtitle("Bar-Plot- Cluster and cash adv freq") +  theme(text=element_text(size=15))+
  scale_fill_discrete(name="Cluster")

#Most of the good Cash adv users belong to Cluster2.
#Cluster 1 users use Cash adv amt but at very low frequency
#Cluster 3 don't use cash adv amt.

------------------------------------------------------------------------------------------------------------------

#general trend- higher Payment ratio always has low credit limit which makes them less potentional customers for marketting strategy.
#hence Plotting Payment ratios whitin a range as it helps to visualize the graphs easily

df_payment_ratio=df_card[which(df_card$Payment_Ratio < 30),]
df_payment_ratio
  
#Scatter-Plot- Paymnet Ratio and Credit Limit
ggplot(df_payment_ratio, aes_string(x = df_payment_ratio$Payment_Ratio, y = df_payment_ratio$CREDIT_LIMIT)) + 
  geom_point(aes_string(colour =df_payment_ratio$kmeans_model.cluster),size = 4) +
  theme_bw()+ ylab("Credit Limit") + xlab("Payment ratio") + ggtitle("Scatter plot Analysis-Paymnet Ratio and Credit Limit") + 
  theme(text=element_text(size=25)) +
  scale_x_continuous(breaks=pretty_breaks(n=10)) +
  scale_y_continuous(breaks=pretty_breaks(n=10)) +
  scale_colour_discrete(name="Card Use Type")+
  scale_shape_discrete(name="Cluster")

#Cluster2 has definelty low payment ratio but the credit limit is equally spread which makes half of them consider as potential buyers(Credit Limit more than mean)
#Cluster 1 has low credit limit but payment ratio is equally distributed.
#Cluster 3 has equal spread of credit limit as well as payment ratio.

#Scatter-Plot-Balance and credit limit (This plot is waste as it simplifies the limit usage)
ggplot(df_card, aes_string(x = df_card$BALANCE, y = df_card$CREDIT_LIMIT)) + 
  geom_point(aes_string(colour = df_card$kmeans_model.cluster),size = 4) +
  theme_bw()+ ylab("Credit Limit") + xlab("Balance") + ggtitle("Scatter plot Analysis-Balance and Credit limit") + 
  theme(text=element_text(size=25)) +
  scale_x_continuous(breaks=pretty_breaks(n=10)) +
  scale_y_continuous(breaks=pretty_breaks(n=10)) +
  scale_colour_discrete(name="Card Use Type")+
  scale_shape_discrete(name="Cluster")

#-Cluster 2 trend:- Cluster 2 has balance and credit limit directly propotional i.e low credit limit-low balance, high credit limit- high balance
#which makes cluster 2 as evidently highly potentional customers. The reason for low payment ratio with low credit limit in previous graph is due to minimal credit limit and balance.

# Cluster 1 has low balance and are highly concentrated among low credit limit. which tells us that they are good customers but weren't provided with much facility to imrove their credit limit.

#Cluster 3 has always low balance. Low balance-Low credit mit. Low balance-High credit limit


#Scatter-Plot-Prc Full paymnet and Limit usage
ggplot(df_card, aes_string(y = df_card$PRC_FULL_PAYMENT, x = df_card$Limit_Usage)) + 
  geom_point(aes_string(colour = df_card$kmeans_model.cluster),size = 4) +
  theme_bw()+ xlab("Limit Usage") + ylab("Prc full payment") + ggtitle("Scatter plot Analysis- Full paymnet and Limit usage") + 
  theme(text=element_text(size=25)) +
  scale_x_continuous(breaks=pretty_breaks(n=10)) +
  scale_y_continuous(breaks=pretty_breaks(n=10)) +
  scale_colour_discrete(name="Card Use Type")+
  scale_shape_discrete(name="Cluster")
  
#Cluster 1 has very low limit usage but pr full payment is somewhat distributed.
#Cluster 2 has quite high limit usage compared to two but very low prc full paymnet
#Cluster 3 has low limit usage but prc full payment is distributed.

#Scatter-Plot-Balance and Balance frequency 
ggplot(df_card, aes_string(x = df_card$BALANCE, y = df_card$BALANCE_FREQUENCY)) + 
  geom_point(aes_string(colour = df_card$kmeans_model.cluster),size = 4) +
  theme_bw()+ xlab("Balance") + ylab("Balance Frequency") + ggtitle("Scatter plot Analysis-Balance and Balance frequency ") + 
  theme(text=element_text(size=25)) +
  scale_x_continuous(breaks=pretty_breaks(n=10)) +
  scale_y_continuous(breaks=pretty_breaks(n=10)) +
  scale_colour_discrete(name="Cluster")

#Cluster 1 has low balance frequeny and low bakance
#Cluster 2 has high balance and high balance frequncy
#Cluster 3 has low balance high balance frequency

#Scatter-Plot-One off purchase and one off purchase freq
ggplot(df_card, aes_string(x = df_card$ONEOFF_PURCHASES, y = df_card$ONEOFF_PURCHASES_FREQUENCY)) + 
  geom_point(aes_string(colour = df_card$kmeans_model.cluster),size = 4) +
  theme_bw()+ xlab("One off purchases") + ylab("One off purchase Frequency") + ggtitle("Scatter plot Analysis--One off purchase and one off purchase freq") + 
  theme(text=element_text(size=25)) +
  scale_x_continuous(breaks=pretty_breaks(n=10)) +
  scale_y_continuous(breaks=pretty_breaks(n=10)) +
  scale_colour_discrete(name="Cluster")

#Cluster 1- has low one off purchases and low freq
#Cluster 2- has low one off ourchases and freq evenly distributed
#Cluster 3- has high one off purchases and hig freq

#Scatter-Plot-Installment purchase and Inst purchase freq
ggplot(df_card, aes_string(x = df_card$INSTALLMENTS_PURCHASES, y = df_card$PURCHASES_INSTALLMENTS_FREQUENCY)) + 
  geom_point(aes_string(colour = df_card$kmeans_model.cluster),size = 4) +
  theme_bw()+ xlab("Installment purchases") + ylab("Installment purchase Frequency") + ggtitle("Scatter plot Analysis-Installment purchase and Inst purchase freq") + 
  theme(text=element_text(size=25)) +
  scale_x_continuous(breaks=pretty_breaks(n=10)) +
  scale_y_continuous(breaks=pretty_breaks(n=10)) +
  scale_colour_discrete(name="Cluster")

#Cluster 1- has low Inst purchases and low freq
#Cluster 2- has low Inst purchases and freq evenly distributed
#Cluster 3-  has high Inst purchases and hig freq

write.csv(df_card,"Credit-Card Segmentation Project DF.csv",row.names = F)
