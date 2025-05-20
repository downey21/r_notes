
# -*- coding: utf-8 -*-

rm(list = ls())

suppressPackageStartupMessages({
    library(dplyr)
    library(forcats)
    library(ggplot2)
    library(gapminder) # gapminder::gapminder dataset
})

data <-
    gapminder::gapminder %>%
    dplyr::filter(year == "2007") %>%
    dplyr::select(-year)

# Most basic bubble plot
ggplot2::ggplot(data, ggplot2::aes(x = gdpPercap, y = lifeExp, size = pop)) +
    ggplot2::geom_point(alpha = 0.7)

# Most basic bubble plot
data %>%
    dplyr::arrange(dplyr::desc(pop)) %>%
    dplyr::mutate(country = factor(country, country)) %>%
    ggplot2::ggplot(ggplot2::aes(x = gdpPercap, y = lifeExp, size = pop)) +
    ggplot2::geom_point(alpha = 0.5) +
    ggplot2::scale_size(range = c(0.1, 24), name = "Population (M)")

data %>%
    dplyr::arrange(dplyr::desc(pop)) %>%
    dplyr::mutate(country = factor(country, country)) %>%
    ggplot2::ggplot(ggplot2::aes(x = gdpPercap, y = lifeExp, size = pop)) +
    ggplot2::geom_point(alpha = 0.5) +
    ggplot2::scale_radius(range = c(1, 24), name = "Population (M)")

# Most basic bubble plot
data %>%
    dplyr::arrange(dplyr::desc(pop)) %>%
    dplyr::mutate(country = factor(country, country)) %>%
    ggplot2::ggplot(ggplot2::aes(x = gdpPercap, y = lifeExp, size = pop, color = continent)) +
    ggplot2::geom_point(alpha = 0.5) +
    ggplot2::scale_size(range = c(0.1, 24), name = "Population (M)")

# https://stackoverflow.com/questions/67746044/r-heatmap-with-circles

set.seed(123)

d <- data.frame(
    x = rep(paste("Team", LETTERS[1:8]), 4),
    y = rep(paste("Task", 1:4), each = 8),
    value = runif(32)
)

ggplot2::ggplot(d, ggplot2::aes(x, forcats::fct_rev(y), fill = value, size = value)) +
    ggplot2::geom_point(shape = 21, stroke = 0) +
    ggplot2::geom_hline(yintercept = seq(1.5, 3.5, 1), linewidth = 0.2, lty = 2) +
    ggplot2::scale_x_discrete(position = "top") +
    ggplot2::scale_radius(range = c(1, 30)) +
    ggplot2::scale_fill_gradient(low = "orange", high = "blue", breaks = c(0, .5, 1), labels = c("Great", "OK", "Bad"), limits = c(0, 1)) +
    ggplot2::theme(
        legend.position = "bottom", 
        panel.grid.major = element_blank(),
        legend.text = element_text(size = 8),
        legend.title = element_text(size = 8)
    ) +
    ggplot2::guides(
        size = ggplot2::guide_legend(
            override.aes = list(fill = NA, color = "black", stroke = .25), 
            label.position = "bottom",
            title.position = "right", 
            order = 1
        ),
        fill = ggplot2::guide_colorbar(ticks.colour = NA, title.position = "top", order = 2)
    ) +
    ggplot2::labs(size = "Area = Time Spent", fill = "Score:", x = NULL, y = NULL)

# plot <-
#     ggplot2::ggplot(data_for_bubble_plot, aes(Category, forcats::fct_rev(factor(Module, levels = module_information_for_plot$Module)), fill = logpvalue, size = Count)) +
#     geom_point(shape = 21, stroke = 0) +
#     annotate(
#         "text",
#         y = data_for_annotate$Module,
#         x = data_for_annotate$Category,
#         label = data_for_annotate$Count,
#         vjust = 2.8,
#         size = 3
#     ) +
#     geom_hline(yintercept = seq(1.5, length(module_information_for_plot$Module) - 0.5, 1), size = 0.2, lty = 2) +
#     scale_x_discrete(position = "top") +
#     scale_radius(
#         name = "Number of Genes",
#         range = c(5, 10.5)
#     ) +
#     theme(
#         legend.position = "bottom", 
#         panel.grid.major = element_blank(),
#         legend.text = element_text(size = 10),
#         legend.title = element_text(size = 10)
#     ) +
#     guides(
#         size = guide_legend(
#             override.aes = list(
#                 fill = NA, color = "black", stroke = 0.5
#             ), 
#             label.position = "bottom",
#             title.position = "left",
#             order = 1,
#             nrow = 1
#         )
#     ) +
#     viridis::scale_fill_viridis(
#         name = latex2exp::TeX(r'($-\log_{10}$P-value)'),
#         option = "D"
#     ) +
#     labs(x = NULL, y = NULL) +
#     theme(axis.text.x = element_text(angle = 60, vjust = 0, hjust=0))
