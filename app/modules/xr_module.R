xrUI <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(id = "webxr-container", 
             tags$canvas(id = "webxr-canvas", style = "width: 100%; height: 500px;"),
             tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"),
             #tags$script(src = "https://cdn.jsdelivr.net/npm/@webxr/polyfill@latest/build/webxr-polyfill.min.js"),
             tags$script(src = "https://unpkg.com/webxr-polyfill@latest/build/webxr-polyfill.min.js"),
             
             # WebXR and Three.js script for AR
             tags$script(HTML("
               var scene = new THREE.Scene();
               var camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000);
               var renderer = new THREE.WebGLRenderer({canvas: document.getElementById('webxr-canvas'), alpha: true});
               renderer.setSize(window.innerWidth, 500);
               renderer.xr.enabled = true;
               
              const polyfill = new WebXRPolyfill(); // Polyfill ensures WebXR works on non-compatible devices
              
              // Ensure the browser supports WebXR
               if (navigator.xr) {
                 // Check if 'immersive-ar' sessions are supported
                 navigator.xr.isSessionSupported('immersive-ar').then((supported) => {
                   if (supported) {
                     console.log('AR is supported! Proceeding...');
                     // Request inline session first (required by polyfill)
                     navigator.xr.requestSession('inline').then(() => {
                       
                       // Now request the AR immersive session
                       navigator.xr.requestSession('immersive-ar', { requiredFeatures: ['hit-test'] })
                         .then((session) => {
                           // Initialize scene with Three.js
                           var scene = new THREE.Scene();
                           var camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
                           var renderer = new THREE.WebGLRenderer({ canvas: document.getElementById('webxr-canvas'), alpha: true });
                           renderer.setSize(window.innerWidth, 500);
                           renderer.xr.enabled = true;
                           renderer.xr.setSession(session);

                           var geometry = new THREE.BoxGeometry(0.1, 0.1, 0.1);
                           var material = new THREE.MeshBasicMaterial({ color: 0x00ff00 });
                           var cube = new THREE.Mesh(geometry, material);
                           scene.add(cube);

                           camera.position.z = 1;

                           var animate = function () {
                             renderer.setAnimationLoop(function () {
                               cube.rotation.x += 0.01;
                               cube.rotation.y += 0.01;
                               renderer.render(scene, camera);
                             });
                           };
                           animate();
                         })
                         .catch(err => {
                           console.error('Failed to start WebXR AR session: ', err);
                         });
                     });
                   } else {
                     console.log('AR is not supported on this device.');
                     alert('Your device or browser does not support AR.');
                   }
                 });
               } else {
                 console.log('WebXR is not available.');
                 alert('Your browser does not support WebXR.');
               }
             "))
    )
  )
}

xrServer <- function(id) {
  moduleServer(id, function(input,output,session){
    
  })
}