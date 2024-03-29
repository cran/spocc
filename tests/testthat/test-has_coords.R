context("Limit to records with coordinates via has_coords")

skip_on_cran()

test_that("has_coords works as expected", {
  vcr::use_cassette("has_coords_gbif", {
    hc_1 <- occ(query = 'Accipiter', from = 'gbif', limit = 5, 
      has_coords = TRUE)
    hc_2 <- occ(query = 'Accipiter striatus', from = 'gbif', limit = 5, 
      has_coords = FALSE)
  })

  expect_is(hc_1, "occdat")
  expect_is(hc_2, "occdat")

  expect_true(hc_1$gbif$meta$opts$hasCoordinate)
  expect_false(hc_2$gbif$meta$opts$hasCoordinate)

  expect_lt(hc_2$gbif$meta$found, hc_1$gbif$meta$found)
})

test_that("has_coords works with all data sources as planned", {
  skip_on_cran()
  skip_on_travis()

  vcr::use_cassette("has_coords_other_data_sources", {
    dd <- occ('Accipiter striatus', from = 'inat', limit = 5,
      has_coords = TRUE)
    gg <- occ('Accipiter striatus', from = 'ebird', limit = 5,
      has_coords = TRUE)
  }, preserve_exact_body_bytes = TRUE)


  expect_is(dd, "occdat")
  expect_is(gg, "occdat")

  expect_false(anyNA(dd$inat$data[[1]]$longitude))
  expect_false(anyNA(dd$inat$data[[1]]$latitude))

  expect_true(dd$inat$meta$opts$geo)
  
  ee <- occ('Accipiter striatus', from = 'idigbio', limit = 5, has_coords = TRUE)
  expect_is(ee, "occdat")
  expect_false(anyNA(ee$idigbio$data[[1]]$longitude))
  expect_false(anyNA(ee$idigbio$data[[1]]$latitude))
  expect_equal(ee$idigbio$meta$opts$rq$geopoint$type, "exists")
})
