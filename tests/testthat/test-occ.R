# context("Occurrence data is correctly retrieved")

# test_that("occ works for each data source", {
#   skip_on_cran()
  
#   vcr::use_cassette("occ_gbif", {
#     x1 <- occ(query = "Accipiter striatus", from = "gbif", limit = 3)
#   }, serialize_with = "json")

#   vcr::use_cassette("occ_inat", {
#     x3 <- occ(query = "Danaus plexippus", from = "inat", limit = 3)
#   }, serialize_with = "json")

#   vcr::use_cassette("occ_obis", {
#     x9 <- occ(query = "Mola mola", from = "obis", limit = 3)
#   }, serialize_with = "json")

#   vcr::use_cassette("occ_ala", {
#     x10 <- occ(query = "Macropus", from = "ala", limit = 3)
#   }, serialize_with = "json")

#   vcr::use_cassette("occ_vertnet", {
#     x8 <- suppressWarnings(occ(query = "Accipiter striatus", from = "vertnet", limit = 3))
#   })

#   # Make sure they are all occdats
#   expect_is(x3, "occdat")
#   expect_is(x4, "occdat")
#   expect_is(x8, "occdat")
#   expect_is(x9, "occdat")
#   expect_is(x10, "occdat")

#   # Testing x1
#   expect_is(x1, "occdat")
#   expect_is(x1$gbif, "occdatind")
#   expect_is(x1$gbif$data[[1]], "data.frame")
#   temp_df <- x1$gbif$data[[1]]
#   expect_equal(unique(temp_df$prov), "gbif")

#   # Testing x3
#   expect_is(x3, "occdat")
#   expect_is(x3$inat, "occdatind")
#   expect_is(x3$inat$data[[1]], "data.frame")
#   temp_df3 <- x3$inat$data[[1]]
#   expect_equal(unique(temp_df3$prov), "inat")
  
#   # Testing x8
#   expect_is(x8$vertnet, "occdatind")
#   expect_is(x8$vertnet$data[[1]], "data.frame")
#   expect_equal(unique(x8$vertnet$data[[1]]$prov), "vertnet")

#   # Testing x9
#   expect_is(x9, "occdat")
#   expect_is(x9$obis, "occdatind")
#   expect_is(x9$obis$data[[1]], "data.frame")
#   temp_df9 <- x9$obis$data[[1]]
#   expect_equal(unique(temp_df9$prov), "obis")

#   # Testing x10
#   expect_is(x10, "occdat")
#   expect_is(x10$ala, "occdatind")
#   expect_is(x10$ala$data[[1]], "data.frame")
#   temp_df10 <- x10$ala$data[[1]]
#   expect_equal(unique(temp_df10$prov), "ala")
# })

# test_that("occ works for each data source", {
#   skip_on_cran()
#   skip_if_idigbio_down()

#   x7 <- occ(query = "Spinus tristis", from = "idigbio", limit = 3)
#   expect_is(x7, "occdat")
#   expect_is(x7$idigbio, "occdatind")
#   expect_is(x7$idigbio$data[[1]], "data.frame")
#   temp_df7 <- x7$idigbio$data[[1]]
#   expect_equal(unique(temp_df7$prov), "idigbio")
# })


# test_that("occ works when only opts passed", {
#   vcr::use_cassette("occ_opts_used", {
#     dsets <- c("7b5d6a48-f762-11e1-a439-00145eb45e9a",
#       "50c9509d-22c7-4a22-a47d-8c48425ef4a7")
#     aa <- occ(limit = 20, from = "gbif", gbifopts = list(datasetKey = dsets))
#   }, preserve_exact_body_bytes = TRUE)

#   expect_is(aa, "occdat")
  
#   expect_is(aa$gbif, "occdatind")
  
#   expect_named(aa$gbif$data, "custom_query")
  
#   expect_equal(sort(unique(aa$gbif$data$custom_query$datasetKey)), 
#     sort(dsets))

#   skip_on_cran()
#   skip_if_idigbio_down()
#   bb <- occ(limit = 20, from = "idigbio",
#     idigbioopts = list(rq = list(class = "arachnida")))
#   expect_is(bb, "occdat")
#   expect_is(bb$idigbio, "occdatind")
#   expect_named(bb$idigbio$data, "custom_query")
#   expect_equal(unique(bb$idigbio$data$custom_query$class), "arachnida")
# })

# test_that("occ works when opts passed result in no results", {
#   vcr::use_cassette("occ_opts_used_no_results", {
#     aa <- occ(
#       query = "Accipiter striatus",
#       gbifopts = list(datasetKey = c("f934f8e2-32ca-46a7-b2f8-b032a4740454",
#                                    "6ce7290f-47f6-4046-8356-371f5b6749df")),
#       limit = 20
#     )
#   })
#   expect_is(aa, "occdat")
#   expect_is(aa$gbif, "occdatind")
#   expect_named(aa$gbif$data, "Accipiter_striatus")
#   expect_equal(NROW(aa$gbif$data[[1]]), 0)
# })

# test_that("occ fails well", {
#   skip_on_cran()
  
#   # expect class character
#   expect_error(occ(mtcars, from = "gbif", limit = 3), 
#                "query must be")
#   expect_error(occ(list(4, 5), from = "gbif", limit = 3), 
#                "query must be")
#   expect_error(occ(45454545, from = "gbif", limit = 3), 
#                "query must be")
  
#   # expect range of from values
#   expect_error(occ("Helianthus", from = 'tree'), 
#                "'arg' should be one of")
  
#   # expect integer limit, start and page values
#   expect_error(occ("Helianthus", from = "gbif", limit = "ASdfadsf"), 
#                "limit must be")
#   expect_error(occ("Helianthus", from = "gbif", start = "ASdfadsf"), 
#                "start must be")
#   expect_error(occ("Helianthus", from = "gbif", page = "ASdfadsf"), 
#                "page must be")
  
#   # expect boolean has_coords value
#   expect_error(occ("Helianthus", from = "gbif", has_coords = 'asfasf'), 
#                "has_coords must be")
#   expect_error(occ("Helianthus", from = "gbif", has_coords = 5), 
#                "has_coords must be")
#   expect_error(occ("Helianthus", from = "gbif", has_coords = mtcars), 
#                "has_coords must be")

#   # inat doesn't allow more than 10K
#   vcr::use_cassette("occ_inat_no_more_than_10K", {
#     expect_warning(
#       occ(query="Helianthus", from = "inat",
#         inatopts=list(maxresults = 200, page = 51)),
#       "Result window is too large"
#     )
#   })
# })
