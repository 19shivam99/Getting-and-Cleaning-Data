library(data.table)
library(dplyr)
library(tidyr)
#importing the datset
X_train=fread("./UCI HAR Dataset/train/X_train.txt")
Y_train=fread("./UCI HAR Dataset/train/Y_train.txt")
subject_train=fread("./UCI HAR Dataset/train/subject_train.txt")
X_test=fread("./UCI HAR Dataset/test/X_test.txt")
Y_test=fread("./UCI HAR Dataset/test/Y_test.txt")
subject_test=fread("./UCI HAR Dataset/test/subject_test.txt")
features=fread("./UCI HAR Dataset/features.txt")
activity_labels=fread("./UCI HAR Dataset/activity_labels.txt")

#assigning names to columns
v=as.vector(features)
v=v$V2
class(v)
names(X_train)=v
names(X_test)=v
names(Y_train)="activity_Id"
names(Y_test)="activity_Id"
names(subject_train)="subject_Id"
names(subject_test)="subject_Id"
names(activity_labels)=c("activity_Id","activity")

#creating Dataset with train and test
bind_train=bind_cols(Y_train,subject_train,X_train)
train=merge(activity_labels,bind_train,by="activity_Id")
bind_test=bind_cols(Y_test,subject_test,X_test)
test=merge(activity_labels,bind_test,by="activity_Id")
df=bind_rows(train,test)
df

#Taking out mean,std,activit_Id and subject_Id column
meancol=names(df)[grepl("mean",names(df))]
stdcol=names(df)[grepl("std",names(df))]
meanstd=select(df,activity_Id,subject_Id,meancol,stdcol)

#assigning descriptive lables to data
desmeanstd=select(df,activity_Id,activity,subject_Id,meancol,stdcol)
names(desmeanstd)

#the average of each variable for each activity and each subject
secTidySet=aggregate(. ~subject_Id + activity_Id + activity,desmeanstd, mean)
secTidySet=secTidySet[order(secTidySet$subject_Id, secTidySet$activity_Id),]
secTidySet
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
