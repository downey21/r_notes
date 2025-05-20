
# -*- coding: utf-8 -*-

rm(list = ls())

suppressPackageStartupMessages({
    library(ggplot2)
    library(ggsignif)
})

ggplot2::ggplot(mpg, ggplot2::aes(class, hwy)) +
    ggplot2::geom_boxplot() +
    ggsignif::geom_signif(
        comparisons = list(
            c("compact", "pickup"),
            c("subcompact", "suv"),
            c("compact", "midsize")
        ),
        map_signif_level = FALSE
    )

ggplot2::ggplot(mpg, ggplot2::aes(class, hwy)) +
    ggplot2::geom_boxplot() +
    ggsignif::geom_signif(
        comparisons = list(
            c("compact", "pickup"),
            c("subcompact", "suv"),
            c("compact", "midsize")
        ),
        map_signif_level = TRUE
    )

ggplot2::ggplot(mpg, ggplot2::aes(class, hwy)) +
    ggplot2::geom_boxplot() +
    ggsignif::geom_signif(
        comparisons = list(
            c("compact", "pickup"),
            c("subcompact", "suv"),
            c("compact", "midsize")
        ),
        map_signif_level = function(p) sprintf("p = %.2g", p)
    )

ggplot2::ggplot(mpg, ggplot2::aes(class, hwy)) +
    ggplot2::geom_boxplot() +
    ggsignif::geom_signif(
        annotations = c("First", "Second"),
        y_position = c(30, 40), xmin = c(4, 1), xmax = c(5, 3)
    )

dat <- data.frame(
    Group = c("S1", "S1", "S2", "S2"),
    Sub = c("A", "B", "A", "B"),
    Value = c(3, 5, 7, 8)
)

dat

ggplot2::ggplot(dat, ggplot2::aes(Group, Value)) +
    ggplot2::geom_bar(ggplot2::aes(fill = Sub), stat = "identity", position = "dodge", width = .5) +
    ggsignif::geom_signif(
        y_position = c(5.3, 8.3), xmin = c(0.8, 1.8), xmax = c(1.2, 2.2),
        annotation = c("**", "NS"), tip_length = 0
    ) +
    ggsignif::geom_signif(
        comparisons = list(c("S1", "S2")),
        y_position = 9.3, tip_length = 0, vjust = 0.2
    ) +
    ggplot2::scale_fill_manual(values = c("grey80", "grey20"))
