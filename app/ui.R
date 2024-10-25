ui <- fluidPage(
  waiter::useWaiter(),
  waiter::useAttendant(),
  tags$head(
    tags$script(src='tesseract.js@5/dist/tesseract.min.js'),
    tags$script(src='read_cam.js'),
    #tags$script(src='https://cdn.jsdelivr.net/npm/driver.js@1.0.1/dist/driver.js.iife.js'),
    #tags$link(href='https://cdn.jsdelivr.net/npm/driver.js@1.0.1/dist/driver.css', rel='stylesheet')
  ),
  shinyjs::useShinyjs(),
  cameraUI('cam_module')
)