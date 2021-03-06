library(data.table)
library(ggplot2)
library(gganimate)
theme_set(theme_bw())

# Show a Justin Tucker game winning field goal animation. Shows the predicted probability and every frame
df <- fread("/Users/benjenkins/Desktop/NFLBDB22/fg19tucker.csv")
summary(df)

p <- ggplot(
  df,
  aes(frameId, FGProb)) +
  ylim(0.25, 0.5) +
  geom_line(color='red', size=4)  +
  labs(x = "Time of Play (Every 0.1 sec)", y = "Probability")  +
  theme(legend.position = "right")  + 
  geom_point() + transition_reveal(frameId) + geom_vline(xintercept = 10, linetype = 3) + 
  geom_vline(xintercept = 27, linetype = 3) + 
  #geom_label(x=48, y=.28, label="Pre-Snap Probability: 44.2%\nProbabilty at Attempt: 48.8%\nResult: Made\nFGOE: 0.53", 
             #color='black', size=6) +
  theme_bw(base_size = 16) + 
  geom_text(aes(x=6, label="\nBall Snap", y=.27), color = 'black', angle=90, size=6) + 
  geom_text(aes(x=23, label="\nFG Attempt", y=.27), color = 'black', angle=90, size=6) + 
  ggtitle('Field Goal Probability Throughout Play') +
  theme(plot.title = element_text(size = 20, face = "bold")) +
  theme(axis.title.x = element_text(size = 18)) +
  theme(axis.title.y = element_text(size = 18)) 

animate(p, fps = 10)
anim_save("tuckerfgpred.mp4")

