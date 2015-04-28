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
  
  size(640, 480);
 background(0);
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
  
  //read cam
  if (cam.available() == true) {
    cam.read();
  }
   if (keyPressed == true) {capture=true;}
  if(capture){
  //fill array lists with all the rgb, hue and sat values
  for(int i=0;i<width;i++){
    for(int j=0; j<height;j++){
    c = cam.get(i, j);
    if(brightness(c)>2 && brightness(c)<200 && dist(i,j,width/2,height/2)>50 && saturation(c)>64){
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
  
  //efficiency is the source?
  averageS=s/sats.size();
  //println(sats.size());
  //println(averageS);

  
  background(0);
  //sort the colors by hue
  hues.sort();
  sats.sort();
  
  //draw the spectrum
  colorMode(HSB,255);
  strokeWeight(5);
  for(int i=0;i<sats.size();i++){
    if(sats.get(i)>32){
    stroke(hues.get(i),sats.get(i),brights.get(i)+128);
    float x = map(i,0,sats.size(),0,width);
    line(x,100,x,height);
    noStroke();
    }
  }
  //draw average hue
  colorMode(HSB,255);
  squareColor = color(h,255,128);
  text("The color of your light is approximately: ", 10,10);
  fill(squareColor);
  rect(20,20,50,50);
  colorMode(RGB,255);
  
  capture = false;
  }
  
 
  
  //find relative levels of colors
  blueLevel = b/((r+g)/2);
  redLevel = r/((b+g)/2);
  greenLevel = g/((b+r)/2);
  
  fill(255);
  //how depressed will this make you?
  //depressionLevel = -1000*(1/(1-blueLevel));
  depressionLevel = (blueLevel-1)*100;
  //draw how depressed you'll be
  if(depressionLevel<0){depressionLevel=0;}
  rect(20,height-20,50,-depressionLevel);
  text("Depression Level", 20, height);
  
  
  
  
  //display the camera image
  image(cam, width-100, height-100,100,100);
  
  stroke(255);
  strokeWeight(.2);
  line(width-50, height-100,width-50,height);
  line(width-100, height-50,width,height-50);

   colorMode(HSB, 255);
   strokeWeight(2);
  for(int i=0; i<sats.size();i++){
    if(abs((sats.get(i)*brights.get(i)/255)-averageS)>threshold){
      //println("peak at "+ hues.get(i));
      eff+=abs(sats.get(i)-averageS);
      //println("peak strength " + eff);
      stroke(hues.get(i),255,128);
      line(map(hues.get(i),0,255,0,width),50,map(hues.get(i),0,255,0,width),100);
    }
  }
  noStroke();
  rect(150,height-20,50,-100*eff/sats.size());
  text("Efficiency Level", 150, height);
  stroke(255);
  println(eff/sats.size());
  println(depressionLevel);
  eff=0;
}
