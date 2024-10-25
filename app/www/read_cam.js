Shiny.addCustomMessageHandler('start_camera', function(message) {
      let video = document.getElementById(message.video_element);
      if (navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({ video: true })
          .then(function(stream) {
            video.srcObject = stream;
          })
          .catch(function(err) {
            console.log('Something went wrong: ' + err);
          });
      }
});
    
Shiny.addCustomMessageHandler('captureImage', function(message) {
      var canvas = document.getElementById(message.canvas_element);
      var video = document.getElementById(message.video_element);
      var context = canvas.getContext('2d');
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;
      context.drawImage(video, 0, 0, canvas.width, canvas.height);
      var dataURL = canvas.toDataURL('image/png');
      Shiny.setInputValue(message.ns + 'imageData', dataURL);
      console.log('Image captured');
});

Shiny.addCustomMessageHandler('extractText', function(message){
  (async () => {
    const worker = await Tesseract.createWorker('eng');
    let ret = await worker.recognize('captured_grey_image.png');
    Shiny.setInputValue(message.ns + 'textData', ret.data.text);
    ret = null;
    console.log("Extraction completed.")
    await worker.terminate();
  })();
});

Shiny.addCustomMessageHandler('extractGreyImage', function(message){
  (async () => {
    const worker = await Tesseract.createWorker('eng');
    let ret = await worker.recognize('captured_image.png', {rotateAuto: true}, {imageGrey: true});
    Shiny.setInputValue(message.ns + 'greyImageData', ret.data.imageGrey);
    ret = null;
    console.log("Extraction completed.")
    await worker.terminate();
  })();
})

Shiny.addCustomMessageHandler('extractBinaryImage', function(message){
  (async () => {
    const worker = await Tesseract.createWorker('eng');
    let ret = await worker.recognize('captured_grey_image.png', {rotateAuto: true}, {imageBinary: true});
    Shiny.setInputValue(message.ns + 'binaryImageData', ret.data.imageBinary);
    await worker.terminate();
  })();
})