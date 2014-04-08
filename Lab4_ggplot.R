require(ggplot2)
data(diamonds)
head(diamonds)

#ggplot only works for data frames
#aes stands for aesthetics. for histogram there's only x
#ggplot is done by adding graphs on top of each other 
ggplot(diamonds, aes(x=price))+ geom_histogram()
ggplot(diamonds, aes(x=price))+ geom_density(color="grey", fill="grey")

ggplot(diamonds,aes(x=carat, y=price)) + geom_point()

g <- ggplot(diamonds, aes(x=carat, y=price))
g+ geom_point()
g+ geom_point(aes(color=cut))

#"small multiples" 
# "~" means break it up
g+ geom_point(aes(color=cut)) + facet_wrap(~clarity)
ggplot(diamonds, aes(x=carat, y=price)) + geom_point(aes(color=cut)) + facet_wrap(~clarity)
#thnk you hadley wickham 
#variable left of ~ is going down the grid, right of ~ is going accross the grid
g+ geom_point(aes(color=cut)) +facet_grid(color ~ clarity)

require(ggthemes)
g2 <- g+ geom_point(aes(color=cut))
g2 + theme_economist() + scale_color_economist()
g2 + theme_wsj()
g2 + theme_excel()
g2 + theme_tufte()

head(economics)
ggplot(economics, aes(x=date, y=pce)) + geom_line()
require(lubridate)
economics$Year <- year(economics$date)
economics$Month <- month(economics$date)
econ2000 <- economics[economics$Year >=2000, ]
ggplot(econ2000, aes(x=month, y=pce, color=Year)) + geom_line(aes(group=Year))
ggplot(econ2000, aes(x=month, y=pce, color=factor(Year))) + geom_line()

#who invented linear regression? Gulton 
require(UsingR)
head(father.son)
ggplot(father.son, aes(x=fheight, y=sheight)) + geom_point() + geom_smooth(method="lm")

heightMod <- lm(sheight ~ fheight, data=father.son)
#input is predictor, output is response, do NOT way independent and dependent variable
heightMod
summary(heightMod)
#what is this program called "mark down" its a lot like latec 

data("tips", package="reshape2")
ggplot(tips, aes(x=total_bill, y=tip, color=day, shape=sex)) + geom_point()
mod1 <- lm(tip ~ total_bill + sex + day, data=tips)
summary(mod1)
head(model.matrix(tip ~ total_bill + sex + day, data=tips))

#memorize how to calculate beta in regression 
require(coefplot)
coefplot(mod1)
head(tips)
mod2 <- lm (tip ~ total_bill + time + size, data=tips)
mod3 <- lm (tip~ total_bill + day +size + time , data=tips)
coef(mod2)
coef(mod3)
multiplot(mod1, mod2, mod3)

#cross validation
#k-fold cross validation? 
require(boot)
tip1 <- glm(tip ~ total_bill + sex + day, data=tips, family=gaussian(link="identity"))
tip2 <- glm(tip ~ total_bill + sex + day + time + size, data=tips, family=gaussian(link="identity"))

tipCV1 <- cv.glm(data=tips, glmfit=tip1, K=5)
tipCV2 <- cv.glm(data=tips, glmfit=tip2, K=5)

tipCV1$delta

age_action <- glm(age ~ total_action, data=Q2, family=gaussian(link="identity"))
age_actionCV1 <- cv.glm(data=Q2, glmfit=age_action, K=5)


