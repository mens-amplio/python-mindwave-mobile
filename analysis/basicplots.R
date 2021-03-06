
# Set root directory
setwd("~/src/python-mindwave-mobile/measurements/")

# Load packages. If not installed, run e.g.: install.packages("ggplot2")
require(data.table)
require(ggplot2)


# Load CSV's
breakfast_morning <- read.csv("datapoints_breakfast_morning.csv", header=TRUE)
night_sleeping <- read.csv("datapoints_night_sleeping.csv", header=TRUE)
watching_tv_at_night <- read.csv("datapoints_watching_tv_at_night.csv", header=TRUE)
watching_tv_afternoon <- read.csv("datapoints_watching_tv_afternoon_0605.csv", header=TRUE)
going_to_bed <- read.csv("datapoints_going_to_bed.csv", header=TRUE)
not_on_head <- read.csv("datapoints_not_on_head.csv", header=TRUE)
not_on_head2 <- read.csv("datapoints_not_on_head_0604.csv", header=TRUE)
working <- read.csv("datapoints_working.csv", header=TRUE)
working2 <- read.csv("datapoints_working_0605.csv", header=TRUE)
convo <- read.csv("datapoints_conversation.csv", header=TRUE)
phonecall <- read.csv("datapoints_phonecall.csv", header=TRUE)
nap <- read.csv("datapoints_short_nap.csv", header=TRUE)

# Combine into one data object "eeg" and "eeg.active" (w/o not_on_head) and
# define time_elapsed variable
breakfast_morning$mode <- "breakfast_morning"
breakfast_morning$time_elapsed <- breakfast_morning$time - 
  min(breakfast_morning$time)
night_sleeping$mode <- "night_sleeping"
night_sleeping$time_elapsed <- night_sleeping$time - 
  min(night_sleeping$time)
watching_tv_at_night$mode <- "watching_tv_at_night"
watching_tv_at_night$time_elapsed <- watching_tv_at_night$time - 
  min(watching_tv_at_night$time)
watching_tv_afternoon$mode <- "watching_tv_afternoon"
watching_tv_afternoon$time_elapsed <- watching_tv_afternoon$time - 
  min(watching_tv_afternoon$time)
going_to_bed$mode <- "going_to_bed"
going_to_bed$time_elapsed <- going_to_bed$time - 
  min(going_to_bed$time)
not_on_head$mode <- "not_on_head"
not_on_head$time_elapsed <- not_on_head$time - 
  min(not_on_head$time)
not_on_head2$mode <- "not_on_head2"
not_on_head2$time_elapsed <- not_on_head2$time - 
  min(not_on_head2$time)
working$mode <- "working"
working$time_elapsed <- working$time - 
  min(working$time)
working2$mode <- "working2"
working2$time_elapsed <- working2$time - 
  min(working2$time)
phonecall$mode <- "phonecall"
phonecall$time_elapsed <- phonecall$time - 
  min(phonecall$time)
convo$mode <- "convo"
convo$time_elapsed <- convo$time - 
  min(convo$time)
nap$mode <- "nap"
nap$time_elapsed <- nap$time - 
  min(nap$time)

eeg <- rbind(working, working2, night_sleeping, nap)
# eeg <- rbind(not_on_head, not_on_head2, watching_tv_afternoon,
#              watching_tv_at_night, breakfast_morning, night_sleeping,
#              going_to_bed, convo, working, working2, phonecall, convo, nap)
eeg <- data.table(eeg)
eeg.active <- eeg[(eeg$mode != "not_on_head") & (eeg$mode != "not_on_head2"), ]


# Exploratory plots
# Watch TV to be one with the universe meditating
ggplot(eeg.active, aes(x=meditation, fill=mode)) + geom_density(alpha=.3) + 
  ggtitle("Density Plots of Meditation for Each Mode")

# Work less
ggplot(eeg.active, aes(x=attention, fill=mode)) + geom_density(alpha=.3) +
  ggtitle("Density Plots of Attention for Each Mode")

# Doesn't appear to be much of a relationship between the attention and meditation.
# Sparse data at the extreme values.
ggplot(eeg.active, aes(x=attention, y=meditation, color=mode)) + geom_point(alpha=.3) + 
  geom_smooth(width=1.5)


# Now, with "time elapsed" there are clear fluctuations visible after smoothing
# for both attention and meditation
ggplot(eeg.active, aes(time_elapsed, attention, colour=mode)) +
  geom_smooth(aes(group=mode), method="loess", size=1.5, se=F, span=0.5) +
  geom_line(alpha=.3)

ggplot(eeg.active, aes(time_elapsed, meditation, colour=mode)) +
  geom_smooth(aes(group=mode), method="loess", size=1.5, se=F, span=0.5) +
  geom_line(alpha=.3)



# Cycling thru the 7 brain waves, but now for all 4 modes, there is this weird
# bimodality (on a log scale) for not_on_head for some of them, such as 
# beta_high, which is not what I would've expected
ggplot(eeg, aes(x=log(alpha_high), fill=mode)) + geom_density(alpha=.3)
ggplot(eeg, aes(x=log(alpha_low), fill=mode)) + geom_density(alpha=.3)
ggplot(eeg, aes(x=log(beta_high), fill=mode)) + geom_density(alpha=.3)
ggplot(eeg, aes(x=log(beta_low), fill=mode)) + geom_density(alpha=.3)
ggplot(eeg, aes(x=log(delta), fill=mode)) + geom_density(alpha=.3)
ggplot(eeg, aes(x=log(gamma_mid), fill=mode)) + geom_density(alpha=.3)
ggplot(eeg, aes(x=log(gamma_low), fill=mode)) + geom_density(alpha=.3)

# So let's look at it along time
ggplot(eeg, aes(time_elapsed, log(beta_high+1), colour=mode)) +
  geom_smooth(aes(group=mode), method="loess", size=1.5, se=F, span=0.5) +
  geom_line(alpha=.1) + geom_point(alpha=0.1) + coord_cartesian(ylim=c(7.5, 12.5))
