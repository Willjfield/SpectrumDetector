/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */

import processing.video.*;

Capture cam;
color c;
//The RGB values of the video mapped to the amount that each particle will be scaled
float r;
float g;
float b;

FloatList reds = new FloatList();
FloatList greens = new FloatList();
FloatList blues = new FloatList();

void setup() {
  r=0;
  g=0;
  b=0;
  size(640, 480);

  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, cameras[18]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    
    // Start capturing the images from the camera
    cam.start();
  }
}

void draw() {
  r=0;
  g=0;
  b=0;
  reds.clear();
  greens.clear();
  blues.clear();
  
  if (cam.available() == true) {
    cam.read();
  }
  for(int i=0;i<width;i++){
    for(int j=0; j<height;j++){
    c = cam.get(i, j);
    if(brightness(c)>20 && brightness(c)<240){
    reds.append(red(c));
    blues.append(blue(c));
    greens.append(green(c));
    }
    }
  }
  image(cam, 0, 0);
  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);
  for(int col=0;col<greens.size();col++){
    r+=reds.get(col);
    
    g+=greens.get(col);
    b+=blues.get(col);
  }
  r=r/reds.size();
  println("red "+r);
  
  g=g/greens.size();
  println("green "+g);
  
  b=b/blues.size();
  println("blues "+b);
  
  color squareColor = color(r,g,b);
  
  fill(squareColor);
  rect(0,0,50,50);
}
