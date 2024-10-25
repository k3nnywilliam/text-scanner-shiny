img_width <- "600px"
img_height <- "400px"

cameraUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(1),
      column(5,
             tags$video(id = ns("videoElement"), autoplay = TRUE, width = img_width, height = img_height),
             tags$canvas(id = ns("canvas"), style = "display: none;"),
             #,style = "transform: scaleX(-1);") #Use this if you want to flip the camera 
             ),
      column(5,
             uiOutput(ns("imageOutput")),
             textOutput(ns("text-output"))
             #,style = "transform: scaleX(-1);") #Use this if you want to flip the camera 
      ),
      column(1)
    ),
    fluidRow(
      column(1),
      column(10,
             actionButton(ns("start_camera"), "Start Camera"),
             actionButton(ns("capture_image"), "Capture"),
             #actionButton(ns("extract_binary"), "Get Binary Image"),
             #actionButton(ns("extract_text"), "Extract Text"),
             #uiOutput(ns("binImageOutput")),
             ),
      column(1)
    )
  )
}

cameraServer <- function(id) {
  moduleServer(id, function(input,output,session){
    ns <- session$ns
    # Remove existing captured images
    reset <- resetCapturedImage()
    att <- Attendant$new("progress-bar")
    
    observeEvent(input$start_camera,{
      # Send message to start the camera
      video_element <- session$ns("videoElement")
      session$sendCustomMessage(type = "start_camera", message = list("video_element" = video_element))
    })
    
    observeEvent(input$capture_image,{
      video_element <- session$ns("videoElement")
      canvas_element <- session$ns("canvas")
      session$sendCustomMessage("captureImage", message =list("video_element" = video_element, 
                                  "canvas_element" = canvas_element, 
                                  "ns" = ns("")))
    })
    
    observe({
      print('Saving...')
      
      showModal(
        modalDialog(
          title = tagList(
            attendantBar("progress-bar",animated = TRUE, striped = TRUE)
          ),
          easyClose = FALSE,
          footer = NULL
        )
      )
      
      # Extract the base64 data and convert to binary
      image_data <- input$imageData
      image_data <- decodeImage(image_data)
      # Save the image to the www folder
      file_path <- file.path("www", "captured_image.png")
      writeBin(image_data, file_path)
      print("Extracting grey image...")
      session$sendCustomMessage("extractGreyImage", message=list("ns" = ns("")))
      att$set(100, text="Processing...")
      Sys.sleep(1)
      print("Extracting the text...")
      session$sendCustomMessage("extractText", message=list("ns" = ns("")))
      removeModal()
    }) |> bindEvent(input$imageData)
    
    observe({
      # Decode grey images
      grey_image_data <- input$greyImageData
      decoded_grey_image_data <- decodeImage(grey_image_data)
      grey_file_path <- file.path("www", "captured_grey_image.png")
      writeBin(decoded_grey_image_data, grey_file_path)
    }) |> bindEvent(input$'greyImageData')
    
    observe({
      print('Extracting text...')
      session$sendCustomMessage("extractText", message=list("ns" = ns("")))
    }) |> bindEvent(input$'extract_text')
    
    output$"text-output" <- renderText({
      as.character(gsub("\n", " ", input$textData))
    }) |> bindEvent(input$textData)
    
    observe({
      print('Extracting binary image...')
      session$sendCustomMessage("extractBinaryImage", message=list("ns" = ns("")))
    }) |> bindEvent(input$"extract_binary")
    
    output$binImageOutput <- renderUI({
      tags$img(src = input$binaryImageData, width = img_width, height = img_height)
    }) |> bindEvent(input$binaryImageData)
    
    output$imageOutput <- renderUI({
      tags$img(src = input$imageData, width = img_width, height = img_height)
    }) |> bindEvent(input$imageData)
    
  })
}