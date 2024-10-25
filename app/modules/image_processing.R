decodeImage <- function(image_data){
  # Remove the data URL prefix
  bin_data <- sub("^data:image/png;base64,", "", image_data)
  # Decode base64 to binary
  decoded_image_data <- base64enc::base64decode(bin_data)
  return(decoded_image_data)
}

resetCapturedImage <- function() {
  if (file.exists("www/captured_image.png")) {
    file.remove("www/captured_image.png")
  }
  if (file.exists("www/captured_grey_image.png")) {
    file.remove("www/captured_grey_image.png")
  }
  return(TRUE)
}

writeToBinary <- function(image_filename) {
  file_path <- file.path("www", image_filename)
  writeBin(image_data, file_path)
  return(NULL)
}