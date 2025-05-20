
# -*- coding: utf-8 -*-

rm(list = ls())

suppressPackageStartupMessages({
    library(umap)
    library(dplyr)
    library(ggplot2)
})

ggplot2::theme_set(theme_classic())
ggplot2::theme_update(
    axis.title = element_text(size = 18),
    plot.title = element_text(size = 19, hjust = 0.5),
    legend.text = element_text(size = 17),
    legend.title = element_text(size = 18),
    axis.line.y = element_blank(),
    axis.line.x = element_blank(),
    panel.background = element_rect(color = "black", linewidth = 1),
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12)
)

iris_numeric <-
    iris %>%
    dplyr::select(!Species)

iris_label <-
    iris %>%
    dplyr::pull(Species)

result_umap <-
    umap::umap(
        iris_numeric,
        random_state = 123
    )

result_umap$layout %>%
    as.data.frame() %>% 
    stats::setNames(c("V1", "V2")) %>%
    dplyr::mutate(Label = iris_label) %>% 
    ggplot2::ggplot(., aes(x = V1, y = V2)) +
    geom_point(aes(color = Label))

# Once we have a umap object describing a projection of a dataset into a low-dimensional layout,
# we can project other data onto the same manifold.
predict(result_umap, iris_numeric) 

predict(result_umap, iris_numeric) %>%
    as.data.frame() %>% 
    stats::setNames(c("V1", "V2")) %>%
    dplyr::mutate(Label = iris_label) %>% 
    ggplot2::ggplot(., aes(x = V1, y = V2)) +
    geom_point(aes(color = Label))
