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
float h;

float eff;

float depressionLevel;

float blueLevel, redLevel, greenLevel;

color squareColor;

FloatList reds = new FloatList();
FloatList greens = new FloatList();
FloatList blues = new FloatList();
FloatList hues = new FloatList();

void setup() {
  r=0;
  g=0;
  b=0;
  h=0;
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
    cam = new Capture(this, cameras[0]);
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
  h=0;
  reds.clear();
  greens.clear();
  blues.clear();
  hues.clear();
  
  if (cam.available() == true) {
    cam.read();
  }
  for(int i=0;i<width;i++){
    for(int j=0; j<height;j++){
    c = cam.get(i, j);
    if(brightness(c)>5 && brightness(c)<200){
    reds.append(red(c));
    blues.append(blue(c));
    greens.append(green(c));
    hues.append(hue(c)); 
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
    
    h+=hues.get(col);
  }
  r=r/reds.size();
  //println("red "+r);
  
  g=g/greens.size();
  //println("green "+g);
  
  b=b/blues.size();
  //println("blues "+b);
  
  h=h/hues.size();
  println("hue "+h);
  colorMode(HSB,255);
  squareColor = color(h,255,128);
  fill(255);
  text("The color of your light is approximately: ", 10,10);
  fill(squareColor);
  rect(20,20,50,50);
  colorMode(RGB,255);
  
  blueLevel = b/((r+g)/2);
  redLevel = r/((b+g)/2);
  greenLevel = g/((b+r)/2);
  
  fill(255);
  
  depressionLevel = -100*(blueLevel-1);
  
  if(depressionLevel>0){depressionLevel=0;}
  
  rect(20,height-20,50,depressionLevel);
  text("Depression Level", 20, height);
  
  eff = abs(3-blueLevel-redLevel-greenLevel);
  if(eff<.2){
    //println("not energy efficient");
  }else{
  //println("energy efficient");
  }
  rect(80,height-20,50,eff*-150);
  text("Efficiency Level", 80, height);
}
