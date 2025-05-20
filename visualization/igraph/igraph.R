
# -*- coding: utf-8 -*-

rm(list = ls())

library(igraph)

# empty graph
g <- igraph::make_empty_graph()
g

# Undirected graph 10 nodes, 1-2, 1-5 undirected edges
g <- igraph::make_graph(
    edges = c(1, 2, 1, 5), n = 10, directed = FALSE
)
g

g <- igraph::make_graph(~ 1--2, 1--5, 3, 4, 5, 6, 7, 8, 9, 10)
g

summary(g)

# plot
g <- igraph::make_graph("Zachary")
g

igraph::plot.igraph(g)

# add / delete
g

g <- igraph::add_vertices(g, 3)
g

g <- igraph::add_edges(g, edges = c(1, 35, 1, 36, 34, 37))
g

g <- g + igraph::edges(c(1, 35, 1, 36, 34, 37))
g

g <-
    g %>%
    igraph::add_edges(edges = c(1, 34)) %>%
    igraph::add_vertices(3) %>%
    igraph::add_edges(edges = c(38, 39, 39, 40, 40, 38, 40, 37))
g

edge_id_to_delete <- igraph::get_edge_ids(g, c(1, 34))
edge_id_to_delete

g <- delete_edges(g, edge_id_to_delete)
g

g <-
    igraph::make_ring(10) %>%
    igraph::delete_edges("10|1")

igraph::plot.igraph(g)

g <- igraph::make_ring(5)
g <- igraph::delete_edges(g, igraph::get.edge.ids(g, c(1, 5, 4, 5)))
igraph::plot.igraph(g)

# node / edge attribute
g <- 
    igraph::make_graph(
        ~ Alice - Boris:Himari:Moshe,
        Himari - Alice:Nang:Moshe:Samira,
        Ibrahim - Nang:Moshe, Nang - Samira
    )
igraph::plot.igraph(g)
g
summary(g)

V(g)$name
V(g)$age <- c(25, 31, 18, 23, 47, 22, 50)
V(g)$gender <- c("f", "m", "f", "m", "m", "f", "m")
E(g)$is_formal <- c(FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE)
summary(g)

igraph::vertex.attributes(g)
igraph::vertex.attributes(g, "Alice")

igraph::vertex_attr(g)
igraph::vertex_attr(g, "age")

igraph::edge_attr(g)
igraph::edge_attr(g, "is_formal")

V(g)[age < 30]$name

E(g)[.from(2)]
E(g)[.from("Boris")]
E(g)[.to(2)]
E(g)[.to("Boris")]
igraph::as_adj_edge_list(g)$Boris
igraph::get.adjlist(g)$Boris
igraph::as_edgelist(g) # undirected 일 경우 한쪽만 나옴
igraph::as_data_frame(g) # undirected 일 경우 한쪽만 나옴

E(g)[3:5 %--% 5:6]

g <- igraph::delete_vertex_attr(g, "gender")
V(g)$gender

g <- igraph::delete_edge_attr(g, "is_formal")
E(g)$is_formal

g <- igraph::make_graph(
    ~ Alice - Boris:Himari:Moshe,
    Himari - Alice:Nang:Moshe:Samira,
    Ibrahim - Nang:Moshe, Nang - Samira
    ) %>%
    igraph::set_vertex_attr("age", value = c(25, 31, 18, 23, 47, 22, 50)) %>%
    igraph::set_vertex_attr("gender", value = c("f", "m", "f", "m", "m", "f", "m")) %>%
    igraph::set_edge_attr("is_formal", value = c(FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE))
summary(g)

# plot
layout <- igraph::layout_nicely(g)

igraph::plot.igraph(g,
    layout = layout,
    vertex.label.dist = 3.5,
    vertex.size = 20,
    vertex.color = ifelse(V(g)$gender == "m", "yellow", "red"),
    edge.width = ifelse(E(g)$is_formal, 5, 1)
    )

# edges
E(g)
E(g)[1:2]
E(g)[c(1, 4)]

# graph attribute
g$date <- c("2022-02-11")
igraph::graph_attr(g, "date")

# find index
match(c("Ibrahim"), V(g)$name)

igraph::get.edge.ids(g, c("Alice", "Himari"))

# degree
igraph::degree(g)
igraph::degree(g, c(1, 3))
igraph::degree(g, c("Alice", "Himari"))

# size
igraph::vcount(g)
igraph::gsize(g)

# adjacency matrix - graph
as.matrix(g, "adjacency")
igraph::as_adjacency_matrix(g)

g1 <- 
    sample(
        x = 0:1, size = 100, replace = TRUE,
        prob = c(0.9, 0.1)
    ) %>%
    matrix(ncol = 10) %>%
    igraph::graph_from_adjacency_matrix(
        mode = "directed",
        weighted = NULL
    )
igraph::plot.igraph(g1)

g2 <-
    sample(
        x = 0:5, size = 100, replace = TRUE,
        prob = c(0.9, 0.02, 0.02, 0.02, 0.02, 0.02)
    ) %>%
    matrix(ncol = 10) %>%
    igraph::graph_from_adjacency_matrix(
        mode = "directed",
        weighted = TRUE
    )
E(g2)$weight
igraph::plot.igraph(g2)

# edge list - graph
# igraph::read_graph(file, format = c("edgelist"))
# igraph::write_graph(graph, file, format = c("edgelist"))

igraph::as_edgelist(g)
igraph::get.data.frame(g)

igraph::get.adjedgelist(g)
igraph::get.adjlist(g)
