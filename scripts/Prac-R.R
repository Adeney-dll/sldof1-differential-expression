library(tidyverse)
ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) + geom_point()
ggsave("figures/test.png")
