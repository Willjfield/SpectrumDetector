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
float s;

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

void setup() {
  r=0;
  g=0;
  b=0;
  h=0;
  s=0;
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
    cam = new Capture(this, cameras[8]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    
    // Start capturing the images from the camera
    cam.start();
  }
}

void draw() {
  background(0);
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
  
  //read cam
  if (cam.available() == true) {
    cam.read();
  }
  //fill array lists with all the rgb, hue and sat values
  for(int i=0;i<width;i++){
    for(int j=0; j<height;j++){
    c = cam.get(i, j);
    if(brightness(c)>10 && brightness(c)<200){
    reds.append(red(c));
    blues.append(blue(c));
    greens.append(green(c));
    hues.append(hue(c));
    sats.append(saturation(c));
    brights.append(brightness(c));
    }
    }
  }
  
  //add together all the rgb and hues
  for(int col=0;col<greens.size();col++){
    
    r+=reds.get(col);
    g+=greens.get(col);
    b+=blues.get(col);
    
    h+=hues.get(col);
    s+=sats.get(col)*(brights.get(col)/255);
  }
  
  //average rgb and h
  r=r/reds.size();
  //println("red "+r);
  
  g=g/greens.size();
  //println("green "+g);
  
  b=b/blues.size();
  //println("blues "+b);
  
  h=h/hues.size();
  s=s/sats.size();
  
  //sort the colors by hue
  hues.sort();
  sats.sort();
  
  //draw the spectrum
  colorMode(HSB,255);
  strokeWeight(2);
  for(int i=0;i<sats.size();i++){
    if(sats.get(i)>128){
    stroke(hues.get(i),sats.get(i),brights.get(i));
    float x = map(i,0,sats.size(),0,width);
    line(x,0,x,height);
    }
  }
  
  //draw average hue
  colorMode(HSB,255);
  squareColor = color(h,255,128);
  text("The color of your light is approximately: ", 10,10);
  fill(squareColor);
  rect(20,20,50,50);
  colorMode(RGB,255);
  
  //find relative levels of colors
  blueLevel = b/((r+g)/2);
  redLevel = r/((b+g)/2);
  greenLevel = g/((b+r)/2);
  
  fill(255);
  //how depressed will this make you?
  depressionLevel = -100*(blueLevel-1);
  //draw how depressed you'll be
  if(depressionLevel>0){depressionLevel=0;}
  rect(20,height-20,50,depressionLevel);
  text("Depression Level", 20, height);
  
  //efficiency is the source?
  eff = s;
  if(eff<60){
    println("not energy efficient "+s);
  }else{
  println("energy efficient "+s);
  }
  
  rect(150,height-20,50,eff*-2);
  text("Efficiency Level", 150, height);
  
  //display the camera image
  image(cam, width-100, height-100,100,100);

}
