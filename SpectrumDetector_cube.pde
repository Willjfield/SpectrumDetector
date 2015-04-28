/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */

import processing.video.*;
import peasy.*;

PeasyCam camera;

Capture cam;
color c;
//The RGB values of the video mapped to the amount that each particle will be scaled
float r;
float g;
float b;
float h;
float s;
float averageS;
float threshold;

float eff;

float depressionLevel;

float blueLevel, redLevel, greenLevel;

color squareColor;

FloatList reds = new FloatList();
FloatList greens = new FloatList();
FloatList blues = new FloatList();

FloatList hues = new FloatList();
FloatList sats = new FloatList();
FloatList brights = new FloatList();

boolean capture;

void setup() {
  threshold = 80;
  eff=0;
  r=0;
  g=0;
  b=0;
  h=0;
  s=0;
  capture = false;

  size(640, 480, P3D);
  camera = new PeasyCam(this, 100);
  camera.setMinimumDistance(50);
  camera.setMaximumDistance(500);
  background(0);
  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, cameras[7]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);

    // Start capturing the images from the camera
    cam.start();
  }
}

void draw() {
  
  //clear everything for fresh start
  r=0;
  g=0;
  b=0;
  h=0;
  s=0;
  reds.clear();
  greens.clear();
  blues.clear();
  hues.clear();
  sats.clear();
  brights.clear();
  strokeWeight(5);

  
  //read cam
  if (cam.available() == true) {
    cam.read();
  }
  if (keyPressed == true) {
    capture=true;
  }else{capture=false;}
  

  if (capture) {
    background(128);
    //fill array lists with all the rgb, hue and sat values
    for (int i=0; i<width; i++) {
      for (int j=0; j<height; j++) {
        c = cam.get(i, j);
        if (brightness(c)>20 && brightness(c)<200 && dist(i, j, width/2, height/2)>50 && saturation(c)>64) {
          fill(red(c),green(c),blue(c));
          stroke(red(c),green(c),blue(c));
          point(red(c),green(c),blue(c));
        }
      }
    }
    println(frameCount);
  }
  
  //display the camera image
  camera.beginHUD();
  image(cam, width-100, height-100,100,100);
  
  stroke(255);
  strokeWeight(.2);
  line(width-50, height-100,width-50,height);
  line(width-100, height-50,width,height-50);
  camera.endHUD();
}
