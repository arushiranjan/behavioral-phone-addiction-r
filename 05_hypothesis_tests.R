# (a) Screen time vs Addiction
res1 <- t.test(screen_time_hrs_day ~ addicted, data=df, alternative="greater")
if(res1$p.value < 0.05) "Addicted users have significantly higher screen time." else "No significant difference in screen time."

# (b) OS vs Addiction
res2 <- chisq.test(table(df$os, df$addicted))
if(res2$p.value < 0.05) "OS influences addiction." else "OS does not influence addiction."

# (c) Gender vs Addiction
res3 <- chisq.test(table(df$gender, df$addicted))
if(res3$p.value < 0.05) "Gender influences addiction." else "Gender does not influence addiction."
