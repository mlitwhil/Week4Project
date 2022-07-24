if(!file.exists("./data")){dir.create("./data")}
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile = "./data/UCI HAR.zip, method = curl")
if(!file.exists("UCI HAR Dataset")){
  unzip("./data")
}

title<- read.table("UCI HAR Dataset/activity_labels.txt")
features<-read.table("UCI HAR Dataset/features.txt")

## finding mean and standard deviation
wantedFeatures<-grep("*mean*|*std*")
wantedFeatures.names<-features[wantedFeatures,2]
wantedFeatures.names=gsub("-mean","Mean",wantedFeatures.names)
wantedFeatures.names=gsub("-std","STD",wantedFeatures.names)
wantedFeatures.names<-gsub("[-()","",wantedFeatures.names)

## training data
xtrain<-read.table("UCI HAR Dataset/train/X_train.txt")[wantedFeatures]
ytrain<-read.table("UCI HAR Dataset/train/y_train.txt")
subjecttrain<-read.table("UCI HAR Dataset/train/subject_train.txt")
train<-cbind(xtrain,ytrain,subjecttrain)

##testing data
xtest<-read.table("UCI HAR Dataset/test/X_test.txt")[wantedFeatures]
ytest<-read.table("UCI HAR Dataset/test/y_test.txt")
subjecttest<-read.table("UCI HAR Dataset/test/subject_test.txt")
test<-cbind(xtest,ytest,subjecttest)

## combining training and testing data
Data<-rbind(train,test)
colnames(Data)<-c("subject" , "activity" , "wantedFeatures.names")

Data$activity<-factor(Data$activity,levels=activityLabels[,1],label=activityLabels[,2])
Data$subject<-as.factor(Data$subject)

melted.Data<-melt(Data, id=c("subject","activity"))
mean.Data<-dcast(melted.Data,subject+activity-variable, mean)

write.table(mean.Data, "tidy.txt",row.names=FALSE,quote=FALSE)