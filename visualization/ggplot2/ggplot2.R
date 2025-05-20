
# -*- coding: utf-8 -*-

# ggplot2 3.5.2

rm(list = ls())

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})

utils::packageVersion("ggplot2")

# Generate some sample data, then compute mean and standard deviation
# in each group
df <- data.frame(
  gp = factor(rep(letters[1:3], each = 10)),
  y = rnorm(30)
)
df

# plot
ggplot2::ggplot(df, ggplot2::aes(x = gp, y = y)) +
    ggplot2::geom_point()

# In here we want to point mean for each gp

# split df by gp value
split(df, df$gp)

# calculate mean and standard deviation by group
lapply(
    split(df, df$gp),
    FUN = function(data) {
        data.frame(mean = mean(data$y), sd = sd(data$y), gp = unique(data$gp))
    }
)

# ds: not use dplyr
ds <- do.call(
    rbind,
    lapply(
        split(df, df$gp),
        FUN = function(d) {
            data.frame(mean = mean(d$y), sd = sd(d$y), gp = unique(d$gp))
        }
    )
)
ds

# dt: use dplyr (more efficient code)
dt <-
    df %>%
    dplyr::group_by(gp) %>%
    dplyr::summarise(mean = mean(y), sd = sd(y), gp = unique(gp))
dt

# plot
ggplot2::ggplot(df, ggplot2::aes(x = gp, y = y)) +
    ggplot2::geom_point() +
    ggplot2::geom_point(data = ds, ggplot2::aes(x = gp, y = mean), color = "red", size = 3)

# aes
ggplot2::ggplot() +
    ggplot2::geom_point(data = df, ggplot2::aes(x = gp, y = y)) +
    ggplot2::geom_point(data = ds, ggplot2::aes(x = gp, y = mean), color = "blue", size = 3) +
    ggplot2::geom_errorbar(
        data = ds,
        ggplot2::aes(gp, mean, ymin = mean - sd, ymax = mean + sd),
        color = "red",
        width = 0.4
    )

# object
base <-
    ggplot2::ggplot(mpg, ggplot2::aes(x = displ, y = hwy)) +
    ggplot2::geom_point()
# scatter plot
base
# scatter plot + loess plot
# span is smoothing parameter
base + ggplot2::geom_smooth(se = FALSE)

base + ggplot2::geom_smooth(se = TRUE, span = 0.3)

# x-axis, y-axis
# expand: margin
base + ggplot2::geom_smooth(se = TRUE, span = 0.3) +
    ggplot2::coord_cartesian(xlim = c(3, 5), ylim = c(20, 30), expand = TRUE)

base + ggplot2::geom_smooth(se = TRUE, span = 0.3) +
    ggplot2::coord_cartesian(xlim = c(3, 5), ylim = c(20, 30), expand = FALSE)

# instead loess, we can plot linear regression function
base + ggplot2::geom_smooth(method = "lm", se = FALSE)

# boxplot and jitter plot
ggplot2::ggplot(mpg, ggplot2::aes(x = class, y = hwy)) +
    ggplot2::geom_boxplot()

# color
ggplot2::ggplot(mpg, ggplot2::aes(x = class, y = hwy)) +
    ggplot2::geom_boxplot(fill = "grey", color = "red")

# instead of outliers, jitter plot
ggplot2::ggplot(mpg, ggplot2::aes(x = class, y = hwy)) +
    ggplot2::geom_boxplot(outlier.shape = NA, fill = "grey", color = "red") +
    ggplot2::geom_jitter(width = 0.2, height = 0.2, colour = "black")

# stratification by certain factor variable
ggplot2::ggplot(mpg, ggplot2::aes(x = class, y = hwy)) +
    ggplot2::geom_boxplot(aes(color = drv)) # drv: f = front-wheel drive, r = rear wheel drive, 4 = 4wd

# density plot
# adjust is smoothing parameter
ggplot2::ggplot(diamonds, ggplot2::aes(x = carat)) +
    ggplot2::geom_density()

ggplot2::ggplot(diamonds, ggplot2::aes(x = carat)) +
    ggplot2::geom_density(adjust = 1)

ggplot2::ggplot(diamonds, ggplot2::aes(x = carat)) +
    ggplot2::geom_density(adjust = 5)

ggplot2::ggplot(diamonds, ggplot2::aes(x = carat)) +
    ggplot2::geom_density(adjust = 0.5)

ggplot2::ggplot(diamonds, ggplot2::aes(depth, color = cut)) +
    ggplot2::geom_density() +
    ggplot2::xlim(55, 70)

ggplot2::ggplot(diamonds, ggplot2::aes(depth, color = cut, fill = cut)) +
    ggplot2::geom_density() +
    ggplot2::xlim(55, 70)

ggplot2::ggplot(diamonds, ggplot2::aes(depth, color = cut, fill = cut)) +
    ggplot2::geom_density(alpha = 0.2) +
    ggplot2::xlim(55, 70)

# text(label), annotate
df <- data.frame(
    x = c(1, 1, 2, 2, 1.5),
    y = c(1, 2, 1, 2, 1.5),
    text = c("bottom-left", "bottom-right", "top-left", "top-right", "center")
)
df

ggplot2::ggplot(df, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point(color = "red") +
    ggplot2::geom_text(ggplot2::aes(label = text))

# vjust, hjust: 0~1 
ggplot2::ggplot(df, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point(color = "red") +
    ggplot2::geom_text(ggplot2::aes(label = text), vjust = 1, hjust = 0.5)

ggplot2::ggplot(df, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point(color = "red") +
    ggplot2::geom_text(ggplot2::aes(label = text), vjust = 1, hjust = 0.5) +
    ggplot2::annotate("text", x = 3, y = 1.5, label = "Some text",  vjust = 1, hjust = 1)

# rug plot
ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
    ggplot2::geom_point()

ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
    ggplot2::geom_point() +
    ggplot2::geom_rug()

ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
    ggplot2::geom_point() +
    ggplot2::geom_rug(sides = "b")

# vline, hline, abline
ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
    ggplot2::geom_point()

ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
    ggplot2::geom_point() +
    ggplot2::geom_vline(xintercept = 5)

ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
    ggplot2::geom_point() +
    ggplot2::geom_hline(yintercept = 20)

coefficient_vector <-
    coef(stats::lm(mpg ~ wt, data = mtcars))
ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
    ggplot2::geom_point() +
    ggplot2::geom_abline(intercept = coefficient_vector[1], slope = coefficient_vector[2])

# same
ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
    ggplot2::geom_point() +
    ggplot2::geom_smooth(method = "lm", se = FALSE)

# facet_grid
ggplot2::ggplot(mpg, ggplot2::aes(x = displ, y = cty)) +
    ggplot2::geom_point() +
    ggplot2::facet_grid(rows = vars(drv))

# colour may be good choice
ggplot2::ggplot(mpg, ggplot2::aes(x = displ, y = cty, color = factor(drv))) +
    ggplot2::geom_point() +
    ggplot2::facet_grid(rows = vars(drv))

ggplot2::ggplot(mpg, ggplot2::aes(x = displ, y = cty)) +
    ggplot2::geom_point() +
    ggplot2::facet_grid(cols = vars(cyl))

ggplot2::ggplot(mpg, ggplot2::aes(x = displ, y = cty)) +
    ggplot2::geom_point() +
    ggplot2::facet_grid(rows = vars(drv), cols = vars(cyl))

# fixed y-axis range
ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg, y = wt, color = factor(cyl))) +
    ggplot2::geom_point() +
    ggplot2::facet_grid(rows = vars(cyl), scales = "fixed")

# flexible y-axis range
ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg, y = wt, color = factor(cyl))) +
    ggplot2::geom_point() +
    ggplot2::facet_grid(rows = vars(cyl), scales = "free")

# free_x, free_y
ggplot2::ggplot(mpg, ggplot2::aes(x = displ, y = cty, color = factor(cyl))) +
    ggplot2::geom_point() +
    ggplot2::facet_grid(rows = vars(drv), cols = vars(cyl), scales = "free_y")

# label
ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg, y = wt, color = factor(cyl))) +
    ggplot2::geom_point() +
    ggplot2::facet_grid(
        rows = vars(cyl),
        scales = "fixed",
        labeller = ggplot2::labeller(cyl = label_both)
    )

# same
ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg, y = wt, color = factor(cyl))) +
    ggplot2::geom_point() +
    ggplot2::facet_grid(
        rows = vars(cyl),
        scales = "fixed",
        labeller = label_both
    )

ggplot2::ggplot(mpg, ggplot2::aes(x = displ, y = cty, color = factor(cyl))) +
    ggplot2::geom_point() +
    ggplot2::facet_grid(
        rows = vars(drv),
        cols = vars(cyl),
        scales = "free_y",
        labeller = ggplot2::labeller(cyl = label_both, drv = label_value)
    )

# same
ggplot2::ggplot(mpg, ggplot2::aes(x = displ, y = cty, colour = factor(cyl))) +
    ggplot2::geom_point() +
    ggplot2::facet_grid(
        rows = vars(drv),
        cols = vars(cyl),
        scales = "free_y",
        labeller = ggplot2::labeller(.col = label_both, .row = label_value)
    )

# You can supply functions operating on strings:
ggplot2::ggplot(msleep, ggplot2::aes(x = sleep_total, y = awake)) +
    ggplot2::geom_point() +
    ggplot2::facet_grid(
        rows = vars(vore),
        cols = vars(conservation)
    )

capitalize <- function(string) {
    substr(string, 1, 1) <- toupper(substr(string, 1, 1))
    string
}
ggplot2::ggplot(msleep, ggplot2::aes(x = sleep_total, y = awake)) +
    ggplot2::geom_point() +
    ggplot2::facet_grid(
        rows = vars(vore),
        cols = vars(conservation),
        labeller = ggplot2::labeller(.default = label_value, vore = capitalize)
    )

# label_wrap_gen()

# facet_wrap
ggplot2::ggplot(mpg, ggplot2::aes(x = displ, y = cty)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(vars(drv))

ggplot2::ggplot(mpg, ggplot2::aes(x = displ, y = cty)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(vars(drv), ncol = 2)

# title
ggplot2::ggplot(mpg, ggplot2::aes(x = displ, y = cty)) +
    ggplot2::geom_point() +
    ggplot2::xlab("xxxxx") +
    ggplot2::ylab("yyyyy") +
    ggplot2::ggtitle("ttttt")

# Examples
mpg %>%
    ggplot2::ggplot(., ggplot2::aes(x = displ, y = hwy)) +
    ggplot2::geom_point()

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = displ, y = hwy)) +
    ggplot2::geom_point(color = "red")

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = displ, y = hwy, color = class)) +
    ggplot2::geom_point()

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = displ, y = hwy)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~ class)

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = displ, y = hwy)) +
    ggplot2::geom_point() +
    ggplot2::geom_smooth()

mpg %>% 
    ggplot(., aes(x = displ, y = hwy)) +
    geom_point() +
    geom_smooth(method = "lm")

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = class, y = hwy)) +
    ggplot2::geom_boxplot()

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = class, y = hwy)) +
    ggplot2::geom_violin()

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = class, y = hwy)) +
    ggplot2::geom_jitter()

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = class, y = hwy)) +
    ggplot2::geom_boxplot() +
    ggplot2::geom_jitter()

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = hwy)) +
    ggplot2::geom_histogram(binwidth = 2)

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = hwy)) +
    ggplot2::geom_freqpoly(binwidth = 1)

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = hwy, colour = class)) +
    ggplot2::geom_freqpoly(binwidth = 1)

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = hwy, fill = class)) +
    ggplot2::geom_histogram(binwidth = 1) +
    ggplot2::facet_wrap(~ class)

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = manufacturer)) +
    ggplot2::geom_bar()

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = hwy)) +
    ggplot2::geom_histogram(binwidth = 2) +
    ggplot2::coord_cartesian(xlim = c(20, 30))

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = hwy)) +
    ggplot2::geom_histogram(binwidth = 2) +
    ggplot2::xlab("xlabel") +
    ggplot2::ylab("ylabel") +
    ggplot2::ggtitle("title") +
    ggplot2::coord_cartesian(xlim = c(20, 30))

mpg %>% 
    ggplot2::ggplot(., ggplot2::aes(x = hwy)) +
    ggplot2::geom_histogram(binwidth = 2) +
    ggplot2::xlab(NULL) +
    ggplot2::ylab(NULL)

ToothGrowth$dose <- as.factor(ToothGrowth$dose)
head(ToothGrowth)
p <- ggplot2::ggplot(ToothGrowth, ggplot2::aes(x=dose, y=len)) + ggplot2::geom_point()
p + ggplot2::coord_cartesian(ylim = c(0, 40)) +
    ggplot2::theme_bw()
p + ggplot2::scale_y_continuous(breaks=c(1, 2, 4, 8, 16, 40)) +
    ggplot2::coord_cartesian(ylim = c(0, 40)) +
    ggplot2::theme_bw()
p + ggplot2::scale_y_continuous(breaks=NULL) +
    ggplot2::coord_cartesian(ylim = c(0, 40)) +
    ggplot2::theme_bw()
