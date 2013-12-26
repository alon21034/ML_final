# final project 

library(e1071)
#library(SparseM)

args <- commandArgs(TRUE)
#data <- read.matrix.csr("ml2013final_train.dat", fac=TRUE, ncol=TRUE)
train.dat <- read.matrix.csr(args[1], fac=TRUE, ncol=TRUE)
test.dat <- read.matrix.csr(args[2], fac=TRUE, ncol=TRUE)
#train.dat <- read.matrix.csr("3f_train.dat", fac=TRUE, ncol=TRUE)

#d1000 <- data[sample(data$x@dimension[1], 1000)]
#t1000 <- data[sample(data$x@dimension[1], 1000)]
#dx <- data$x[1:5000]
#dy <- data$y[1:5000]
#tx <- data$x[5001:6000]
#ty <- data$y[5001:6000]

dx <- train.dat$x
dy <- train.dat$y
tx <- test.dat$x
ty <- test.dat$y

#model 	<- svm(dx, dy, gamma=0.01, cost=10)
for(i in -2){
	model 	<- svm(dx, dy, kernel="linear", cost=10^i)
#	predict	<- predict(model, dx)
	pred <- predict(model, tx)
#	cat(predict2)	
#	Ein	<- sum(predict != dy)/length(dy)
#	Eout <- sum(predict2 != ty)/length(ty)
#	cat("cost = ", 10^i, "\n")
#	cat("Ein = ", Ein, "\n")
#	cat("Eout = ", Eout, "\n\n")
}
level <- c(1, 10, 11, 12, 2, 3, 4, 5, 6, 7, 8, 9)
for(i in 1:length(pred)){
	cat(level[pred[i]], "\n")
}

#for(i in 1:length(pred)){
#	cat(predict2[i],"\n")
#}
#obj <- tune(svm, train.x=dx, train.y=dy, validation.x=tx, validation.y=ty, ranges = list(gamma = 10^(-3:3), cost = 10^(-3:3)))
#summary(obj)
#plot(obj)

