## Code accompanying Kuppens et al. 2015. 
## Collaborative commentary: Do more gender-equal countries win more Olympic medals?
## Some of the code below based on http://www.stanford.edu/~stephsus/R-randomforest-guide.pdf
## Code written by Thomas V. Pollet, contact me if you have any queries.
## Install these packages below first(!) -- Analyses ran in R 3.1.3 / 6. Jul. 2015. 
## For information on random forests (cforest) implemented here, ??party and references herein.


install.packages("foreign","party","ggplot2")
require(foreign)
require(party)
require(ggplot2)
# set your working directory.
setwd("~/Documents/Rstudio/medals") # change.

#Load medal data. Change location.
DatamedalsM<-read.spss("~/Documents/Rstudio/medals/olympicmedals121-Reduced-men.sav", to.data.frame=TRUE)
DatamedalsF<-read.spss("~/Documents/Rstudio/medals/olympicmedals121-Reduced-women.sav", to.data.frame=TRUE)
# attach the data
attach(DatamedalsM) 
attach(DatamedalsF)
# Ordinal RF. Run this to get an ordinal RF.
DatamedalsM$TotMedMen1214<- as.ordered(DatamedalsM$TotMedMen1214)
DatamedalsF$TotMedWom1214<- as.ordered(DatamedalsF$TotMedWom1214)
# Pick the Dataset
Dataset1<-DatamedalsM # change this for female results
# Dataset1<-DatamedalsF

# Recursive partitioning via Party.
set.seed (123)
partytree<-ctree(TotMedMen1214~. ,data=Dataset1)
plot(partytree)
set.seed (234)
partytree2<-ctree(TotMedMen1214~. ,data=Dataset1)
plot(partytree2)
# Random Forests
set.seed (666)
data.controls <- cforest_unbiased(ntree=10000, mtry=9, trace=TRUE)
mycforest<- cforest(TotMedMen1214 ~ ., data = Dataset1, 
                    control = data.controls)

myvarimp<-varimp(mycforest)
as.data.frame(myvarimp)
write.csv(myvarimp, file= 'myvarimp1.csv')
dev.off()
postscript("dotplot1.eps",  horizontal = FALSE, onefile = FALSE, paper = "special", height = 10, width = 10)
dotplot(sort(myvarimp), xlab="Variable Importance (predictors to right of dashed vertical line are significant)", panel=function(x,y) {panel.dotplot(x, y, col='darkblue', pch=16, cex=1.1) 
                                                                                                                                       panel.abline(v=abs(min(myvarimp)), col='red', lty='longdash', lwd=2)})
dev.off()
y_hat<-predict(mycforest) # save predicted values
as.vector(y_hat)
Dataset2<-cbind(Dataset1,y_hat)
colnames(Dataset2)[28] <- "y_hat" # add y_hat
fitrandom1<-cor.test(Dataset2$TotMedMen1214, Dataset2$y_hat, method="pearson") # fit
fitrandom1
fitrandom2<-cor.test(Dataset2$TotMedMen1214, Dataset2$y_hat, method="spearman") # fit ordinal
fitrandom2
fits<-cbind(fitrandom1$estimate,fitrandom2$estimate)
write.csv(fits, file='fits.csv')
write.csv(Dataset2, file='Dataset_with_predictions1.csv')
# plot
ggplot(Dataset2, aes(x=TotMedMen1214, y=y_hat)) +
  geom_point(shape=1) + geom_smooth(method=lm)
dev.copy(pdf, 'run1_fit.pdf')
dev.off()
# Rerun with different seed
set.seed (777)
data.controls2 <- cforest_unbiased(ntree=10000, mtry=9, trace=TRUE)
mycforest2<- cforest(TotMedMen1214 ~ ., data = Dataset1, 
                     control = data.controls2)

myvarimp2<-varimp(mycforest2)
as.data.frame(myvarimp2)
write.csv(myvarimp2, file= 'myvarimp2.csv')
dev.off()
postscript("dotplot2.eps",  horizontal = FALSE, onefile = FALSE, paper = "special", height = 10, width = 10)
dotplot(sort(myvarimp2), xlab="Variable Importance (predictors to right of dashed vertical line are significant)", panel=function(x,y) {panel.dotplot(x, y, col='darkblue', pch=16, cex=1.1) 
                                                                                                                                        panel.abline(v=abs(min(myvarimp2)), col='red', lty='longdash', lwd=2)})
dev.off()
y_hat2<-predict(mycforest2) # save predicted values
as.vector(y_hat2)
Dataset3<-cbind(Dataset1,y_hat2)
colnames(Dataset3)[28] <- "y_hat2"
fitrandom3<-cor.test(Dataset3$TotMedMen1214, Dataset3$y_hat2, method="pearson") # fit
fitrandom3
fitrandom4<-cor.test(Dataset3$TotMedMen1214, Dataset3$y_hat2, method="spearman") # fit ordinal
fitrandom4
fits2<-cbind(fitrandom3$estimate,fitrandom4$estimate)
write.csv(fits2, file='fits2.csv')
write.csv(Dataset3, file='Dataset_with_predictions2.csv')
#Plot
ggplot(Dataset3, aes(x=TotMedMen1214, y=y_hat2)) +
  geom_point(shape=1) + geom_smooth(method=lm)
dev.copy(pdf, 'run2_fit.pdf')
dev.off()

#Now female medals. Note that this will override the male data! (move the files to a folder!)
# Recursive partitioning via Party.
set.seed (123)
partytree<-ctree(TotMedWom1214~. ,data=Dataset1)
plot(partytree)
set.seed (234)
partytree2<-ctree(TotMedWom1214~. ,data=Dataset1)
plot(partytree2)
# Random Forests
set.seed (666)
data.controls <- cforest_unbiased(ntree=10000, mtry=9, trace=TRUE)
mycforest<- cforest(TotMedWom1214 ~ ., data = Dataset1, 
                    control = data.controls)

myvarimp<-varimp(mycforest)
as.data.frame(myvarimp)
write.csv(myvarimp, file= 'myvarimp1.csv')
dev.off()
postscript("dotplot1.eps",  horizontal = FALSE, onefile = FALSE, paper = "special", height = 10, width = 10)
dotplot(sort(myvarimp), xlab="Variable Importance (predictors to right of dashed vertical line are significant)", panel=function(x,y) {panel.dotplot(x, y, col='darkblue', pch=16, cex=1.1) 
                                                                                                                                       panel.abline(v=abs(min(myvarimp)), col='red', lty='longdash', lwd=2)})
dev.off()
y_hat<-predict(mycforest) # save predicted values
as.vector(y_hat)
Dataset2<-cbind(Dataset1,y_hat)
colnames(Dataset2)[28] <- "y_hat" # add y_hat
fitrandom1<-cor.test(Dataset2$TotWom1214, Dataset2$y_hat, method="pearson") # fit
fitrandom1
fitrandom2<-cor.test(Dataset2$TotMedWom1214, Dataset2$y_hat, method="spearman") # fit ordinal
fitrandom2
fits<-cbind(fitrandom1$estimate,fitrandom2$estimate)
write.csv(fits, file='fits.csv')
write.csv(Dataset2, file='Dataset_with_predictions1.csv')
# plot
ggplot(Dataset2, aes(x=TotMedWom1214, y=y_hat)) +
  geom_point(shape=1) + geom_smooth(method=lm)
dev.copy(pdf, 'run1_fit.pdf')
dev.off()
# Rerun with different seed
set.seed (777)
data.controls2 <- cforest_unbiased(ntree=10000, mtry=9, trace=TRUE)
mycforest2<- cforest(TotMedWom1214 ~ ., data = Dataset1, 
                     control = data.controls2)

myvarimp2<-varimp(mycforest2)
as.data.frame(myvarimp2)
write.csv(myvarimp2, file= 'myvarimp2.csv')
dev.off()
postscript("dotplot2.eps",  horizontal = FALSE, onefile = FALSE, paper = "special", height = 10, width = 10)
dotplot(sort(myvarimp2), xlab="Variable Importance (predictors to right of dashed vertical line are significant)", panel=function(x,y) {panel.dotplot(x, y, col='darkblue', pch=16, cex=1.1) 
                                                                                                                                        panel.abline(v=abs(min(myvarimp2)), col='red', lty='longdash', lwd=2)})
dev.off()
y_hat2<-predict(mycforest2) # save predicted values
as.vector(y_hat2)
Dataset3<-cbind(Dataset1,y_hat2)
colnames(Dataset3)[28] <- "y_hat2"
fitrandom3<-cor.test(Dataset3$TotWom1214, Dataset3$y_hat2, method="pearson") # fit
fitrandom3
fitrandom4<-cor.test(Dataset3$TotMedWom1214, Dataset3$y_hat2, method="spearman") # fit ordinal
fitrandom4
fits2<-cbind(fitrandom3$estimate,fitrandom4$estimate)
write.csv(fits2, file='fits2.csv')
write.csv(Dataset3, file='Dataset_with_predictions2.csv')
#Plot
ggplot(Dataset3, aes(x=TotMedWom1214, y=y_hat2)) +
  geom_point(shape=1) + geom_smooth(method=lm)
dev.copy(pdf, 'run2_fit.pdf')
dev.off()

## Via the above approach we relied on machine learning to investigate which predictors in our set
## optimally predict numbers of medal won. The above approach is relatively assumption free
## it accounts for non-independence, non-linearity, potential interaction effects and 
## aims to maximize prediction. It performs well for 'small n large p' problems. 
## The overall tentative conclusion is that when we consider the full set of predictors
## variables relating to gender equality have relative limited predictive ability, whereas
## variables pertaining to GDP and/or geography do allow for prediction. This corroborates the
## conclusions of the multilevel models reported in text.
## For further details please view the 'party' vignette and references therein.