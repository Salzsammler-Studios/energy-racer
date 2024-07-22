  /**************************************************
  *
  *  Energy Race
  *  @author Jochen Koubek
  *  @version 0.7
  *
  **************************************************/

  import procontroll.*;
  import java.io.*;
  import processing.serial.*;
  import ddf.minim.*;
  

  /**************************************************
  ***************************************************
  *  Deklaration der globalen Variablen
  *  und Initialisierung der Konstanten
  ***************************************************
  **************************************************/

  /***************************************************
  *  Spiel
  ***************************************************/
  
  boolean debug = true; //Zusätzliche Informationen anzeigen?
  boolean connected = true; //Controller ist angeschlossen?
  boolean dualpad = false; //Dualpad angeschlossen?
  boolean soundOn = true;
  int gameState;
  boolean message;
  String screenText;
  String winnerText;

  /***************************************************
  *  I/O
  ***************************************************/
  ControllIO controll;
  ControllDevice device;
  ControllStick bioStick, oilStick;
  
  Serial arduinoSerial;
  int inByte, outByte;

  Minim minim;
  AudioPlayer atmoReady, atmoGame;
  AudioSnippet conflictSound, gameOverSound;
  AudioSnippet oilMove, oilEnter, oilFill, oilFull, oilCharge, oilQuitSound;
  AudioSnippet bioMove, bioEnter, bioFill, bioFull, bioQuitSound;
  boolean atmoReadyOn, atmoGameOn, atmoOn;
  
  /***************************************************
  *  Welt-Energievorräte
  ***************************************************/
  PFont font, messageFont;
  PImage worldImg, worldBck;
  PImage barrelPoints;
  int reservoirs = 7;
  float[] bioQuant = new float[reservoirs];
  float[] oilQuant = new float[reservoirs];
  float[] bioQuantOld = new float[reservoirs];
  float[] oilQuantOld = new float[reservoirs];
  int[] rectX = {310,200,660,530,830,845,502};
  int[] rectY = {390,200,190,320,450,250,230};
  int[] rectWidth = {10,20,50,20,30,30,50};
  int[] rectHeight = {100,100,100,100,20,45,17};
  
  int sources = 2;
  int[] oilSourceX = {130,900};
  int[] oilSourceY = {440,290};
  
  int scoreMax;
  boolean konflikt;
  boolean gameStart;

  /***************************************************
  *  Öl
  ***************************************************/  
  PImage oilGlobalImg, oilQuitImg;
  PImage oilSource;
  PImage oilBarrel;
  int oilHandPressure;
  float oilMoveVelocity, oilFillVelocity, oilFocusVelocity;
  int oilX, oilY, oilXBase, oilYBase;  
  int oilGlobalX, oilGlobalY, oilGlobalWidth, oilGlobalHeight;
  int oilGlobalMax, oilGlobalQuant;
  int oilFocus;
  int oilFillStart;
  color oilColor;
  int oilScore;
  int oilBarrels;
  int oilAuraMax;
  float oilAura;
  int oilAddQuant;
  float temperatureGlobal;
  float oilAddTemperature;
  float oilHandTemperature, oilHandTemperature_old, oilAddHandTemperature;
  int oilHandPressureThreshold;
  boolean oilQuit;

  /***************************************************
  *  Bio
  ***************************************************/
  PImage bioGlobalImg, bioQuitImg;
  PImage bioBarrel;
  int bioVelocity;
  float bioMoveVelocity, bioFillVelocity, bioFocusVelocity;
  int bioGlobalX,bioGlobalY,bioGlobalWidth,bioGlobalHeight;  
  int bioX, bioY, bioXBase, bioYBase;
  int bioFocus;
  color bioColor;
  color bioColorDark;
  int bioScore;
  int bioBarrels;
  int bioAuraMax;
  float bioAura;
  boolean bioQuit;

  
  /**************************************************
  ***************************************************
  *  Initialisierung der globalen Variablen
  ***************************************************
  **************************************************/
  void setup(){
    size(1024,768);
    frameRate(20);
    smooth();
  
    font = loadFont("SansSerif-18.vlw");
    messageFont = loadFont("ArcadeRounded-144.vlw");
    message = false;
    
    textFont(font);
    worldImg = loadImage("world.png");
    worldBck = loadImage("worldBackground.jpg");
  
    if (connected){
       controll = ControllIO.getInstance(this);
       if (dualpad) {
         device = controll.getDevice("Dual Analog Pad");
       }
       else {
         device = controll.getDevice("Thrustmaster dual analog 3.2");
       }
    }
   
    if (debug) println("Gamepad: " + device);

    arduinoSerial = new Serial(this,Serial.list()[0], 1200);
  
    if (soundOn) {
      minim = new Minim(this);
      atmoReady = minim.loadFile("AnOrangePlanet-Orchestra.mp3", 2048);
      atmoReady.rewind();
      atmoGame = minim.loadFile("AnOrangePlanet(loop).mp3", 2048);
      atmoGame.rewind();
      gameOverSound = minim.loadSnippet("zischdown.wav");
      gameOverSound.rewind();
      atmoGame.mute();
      atmoGameOn = false;
      atmoGame.loop();
      atmoReady.loop();
      atmoReadyOn = true;   
      atmoOn = true;   
    }
  
    scoreMax = 0;
    for (int i=0;i<reservoirs;i++){
      bioQuant[i] = 0;
      oilQuant[i] = 0;
      scoreMax += rectWidth[i]*rectHeight[i];
    }
  
    if (connected){
        oilStick = device.getStick(0);
        oilStick.setTolerance(0.5f);    
    }
    oilColor = color(10,10,0);
    oilMoveVelocity = 6;
    
    oilFillVelocity = 3;
    oilFocus = -1; 
    oilFillStart = -1;   
    oilScore = 0;
    oilBarrels = 0;
    oilAuraMax = 3;
    oilGlobalMax = 15000;
    oilGlobalQuant = oilGlobalMax;
    oilGlobalWidth = 136;
    oilGlobalHeight = 100;
    oilGlobalImg = loadImage("oilGlobal.png");
    oilQuitImg = loadImage("oilQuit.png");
    oilSource = loadImage("oilSource.png");
    oilBarrel = loadImage("point.png");
    if (soundOn) {
      oilEnter = minim.loadSnippet("Klick 17.wav");
      oilFull = minim.loadSnippet("Pling 2.wav");
      oilCharge = minim.loadSnippet("Gears.wav");
      oilQuitSound = minim.loadSnippet("Power down 01.wav");
    }
    
    oilGlobalX = width/2-oilGlobalWidth/2;
    oilGlobalY = 14;
    oilXBase = oilGlobalX + oilGlobalWidth/2;
    oilX = width/2-18;
    oilYBase = oilGlobalY + oilGlobalHeight/2;
    oilY = 135;
    oilAddQuant = 150;
    oilAddTemperature = 0.01;    
    oilAddHandTemperature = 1.0; 
    oilHandPressureThreshold = 4;
    oilHandTemperature = 0.0; //zum Arduino
    oilHandTemperature_old = 0.0; //zum Vergleich
    oilQuit = false;
 
    temperatureGlobal = 14.7; //http://data.giss.nasa.gov/gistemp/tabledata/GLB.Ts.txt
    if (connected) {
        bioStick = device.getStick(1);
        bioStick.setTolerance(0.5f);  
    }
    bioColor = color(100,255,100);   
    bioColorDark = color(0,100,0);
    bioFillVelocity = 1;
    bioMoveVelocity = 5;
    bioFocus = -1;  
    bioScore = 0;
    bioBarrels = 0;
    bioAuraMax = 7; 
    bioGlobalWidth = 64;
    bioGlobalHeight = 64;
    bioGlobalImg = loadImage("bioGlobal.png");
    bioQuitImg = loadImage("bioQuit.png");
    bioBarrel = loadImage("point.png");
    if (soundOn) {
      bioEnter = minim.loadSnippet("Klick 22.wav");
      bioFull = minim.loadSnippet("Pling 1.wav");
      bioQuitSound = minim.loadSnippet("Power down 02.wav");
    }

    bioGlobalX = width/2-bioGlobalWidth/2;
    bioGlobalY = height-100;
    bioXBase = bioGlobalX + bioGlobalWidth/2;
    bioX = width/2-18;
    bioYBase = bioGlobalY+bioGlobalHeight/2;
    bioY = 633;
    bioQuit = false;

    gameState = 0;
    gameStart = false;
    arduinoSerial.clear();
  }
  
  /**************************************************
  ***************************************************
  *  Game-Loop
  ***************************************************
  **************************************************/
  void draw(){
 
  /**************************************************
  *  Sensoren und Aktoren
  **************************************************/
    if (frameCount < 10) {
      arduinoSerial.clear();
    }

    if (arduinoSerial.available() > 0){
      inByte = (int)arduinoSerial.read();
      arduinoSerial.clear(); 
  
      bioVelocity = inByte & 0x0F;
      oilHandPressure = (inByte >> 4) & 0x0F;
      
      if (debug){
        text("Fahrrad: " + bioVelocity, width-200,10);
        text("Handdruck : " + oilHandPressure, width-200,60);
      }
    }
    
    bioFillVelocity = round(bioVelocity / 4); //Proportional zur Geschwindigkeit der Fahrrads;
    bioMoveVelocity = round(bioVelocity/1.2); //Proportional zur Geschwindigkeit der Fahrrads;
    if (connected) bioStick.setMultiplier(bioMoveVelocity);
    
    float factor = ((float)oilGlobalQuant)/oilGlobalMax;
    oilFillVelocity = (int)(1+5*factor); //Proportional zum Ölstand
    oilMoveVelocity = (int)(1+7*factor); //Proportional zum Ölstand
    if (connected) oilStick.setMultiplier(oilMoveVelocity);

    if (oilQuit){
      oilHandTemperature = 0;
    }
      
    if (oilHandTemperature != oilHandTemperature_old) {
      int charTemp = int(oilHandTemperature);
      char c = char(charTemp);
      arduinoSerial.write(c);
      oilHandTemperature_old = oilHandTemperature;
    }  
    

  /**************************************************
  *  Gamepad
  **************************************************/

    if (connected && gameState >= 3){
        if(dualpad) {
          bioX = (int)constrain(bioX-bioStick.getX(),0,width);
          bioY = (int)constrain(bioY+bioStick.getY(),128,height-129);
          
          oilX = (int)constrain(oilX-oilStick.getX(),0,width);
          oilY = (int)constrain(oilY+oilStick.getY(),128,height-129);       
       }
       else { //Thrusmaster
          bioX = (int)constrain(bioX-bioStick.getX(),0,width);
          bioY = (int)constrain(bioY+bioStick.getY(),128,height-129);
          
          oilX = (int)constrain(oilX+oilStick.getX(),0,width);
          oilY = (int)constrain(oilY+oilStick.getY(),128,height-129);   
        }
    }

  /**************************************************
  *  Zeichne die Hintergrundbilder
  **************************************************/
    background(255);
    image(worldBck,0,0);
    
    fill(255);
    textFont(font,9);
    textAlign(LEFT);
    text("© 2010 Universität Bayreuth\n Angewandte Medienwissenschaft: Digitale Medien", 20,730);
    textFont(font);
    
    tint(255,255-oilHandTemperature,255-oilHandTemperature,121);
    image(worldImg,0,128);
    blend(worldImg,0,0,1024,511,0,128,1024,511,MULTIPLY);
    
    fill(255,121);
    noStroke();
    rect(0,14,580,100); //Kontrollfeld Öl
    rect(444,653,580,100); // Kontrollfeld Bio
 
    tint(bioColor);
    if (!bioQuit) {
      image(bioGlobalImg,bioGlobalX,bioGlobalY);      
    }
    else {
      image(bioQuitImg,bioGlobalX,bioGlobalY);      
    }

    if(oilGlobalQuant > 0) {
      tint(255,100,50); //rot-gelb
      if (!oilQuit) {
        image(oilGlobalImg,oilGlobalX+oilGlobalWidth/2-32,oilGlobalY+oilGlobalHeight/2-32);
      }
      else {
        image(oilQuitImg,oilGlobalX+oilGlobalWidth/2-32,oilGlobalY+oilGlobalHeight/2-32);
      }
    }

   tint(255,255);
    
 
  /**************************************************
  *  Bestimme den Focus
  **************************************************/
    if (!oilQuit){
      int oilFocusOld = oilFocus;
      int oilTestFocus = findFocus(oilX,oilY);
      if (oilTestFocus >= 0){
        oilFocus = oilTestFocus;  
        if (oilFocus != oilFocusOld && soundOn){
          oilEnter.rewind();
          oilEnter.play();
        }
      }
    }
    else {
      oilFocus = -1;
    }
    
    for (int i=0; i<sources; i++){
      if (dist(oilX,oilY,oilSourceX[i]+20,oilSourceY[i]+30)<20){    
        fillGlobalOil(i);
        if (soundOn) {
          if(!oilCharge.isPlaying() && oilGlobalQuant<oilGlobalMax){  
            oilCharge.rewind();
            oilCharge.play();
            oilFillStart = i;
          }
          if(oilCharge.isPlaying() && oilGlobalQuant>=oilGlobalMax){
            oilCharge.pause();
          }          
        }
      }
      else{
        if(soundOn){
          if (oilCharge.isPlaying() && i==oilFillStart){
            oilCharge.pause();
          }
        }
      }
    }

    if (!bioQuit){
      int bioFocusOld = bioFocus;
      int bioTestFocus = findFocus(bioX,bioY);
      if (bioTestFocus >= 0){
        bioFocus = bioTestFocus;  
        if (bioFocus != bioFocusOld && soundOn){
          bioEnter.rewind();
          bioEnter.play();
        }
      }
    }
    else {
      bioFocus = -1;
    }
    
    
    
  /**************************************************
  *  Umrahme die Reservoire, die  
  *  den Focus haben.
  **************************************************/
    strokeWeight(1);
    fill(0);
    textAlign(LEFT);

    bioAura = sin((frameCount%40)*TWO_PI/40)*bioAuraMax;
    oilAura = sin((frameCount%30)*TWO_PI/30)*oilAuraMax;
      
    if (bioFocus >= 0){
      stroke(bioColor);
      fill(bioColor,70);
      rect(rectX[bioFocus]-4-bioAuraMax-bioAura,rectY[bioFocus]-4-bioAuraMax-bioAura,rectWidth[bioFocus]-1+2*(4+bioAuraMax+bioAura),rectHeight[bioFocus]-1+2*(4+bioAuraMax+bioAura));
  
      strokeWeight(1);
      fill(bioColor,50);
      int x1 = bioGlobalX+bioGlobalWidth/2 - 3;
      int y1 = bioGlobalY-15;
      int x2 = rectX[bioFocus]+rectWidth[bioFocus]/2 - 3;
      int y2 = rectY[bioFocus]+rectHeight[bioFocus];
      int x3 = rectX[bioFocus]+rectWidth[bioFocus]/2 + 3;
      int y3 = rectY[bioFocus]+rectHeight[bioFocus];
      int x4 = bioGlobalX+bioGlobalWidth/2 + 3;
      int y4 = bioGlobalY-15;
      quad(x1,y1,x2,y2,x3,y3,x4,y4);  
    }
  
    if (oilFocus >= 0){
      stroke(oilColor);
      fill(oilColor,30);
      rect(rectX[oilFocus]-4-oilAuraMax-oilAura,rectY[oilFocus]-3-oilAuraMax-oilAura,rectWidth[oilFocus]-1+2*(4+oilAuraMax+oilAura),rectHeight[oilFocus]-1+2*(4+oilAuraMax+oilAura));
      
      if (oilGlobalQuant > 0){
        fill(oilColor,50);
      }
      else{
        noFill();
      }
      strokeWeight(1);
      int x1 = oilGlobalX+oilGlobalWidth/2 - 3;
      int y1 = oilGlobalY+oilGlobalHeight;
      int x2 = rectX[oilFocus]+rectWidth[oilFocus]/2 - 3;
      int y2 = rectY[oilFocus];
      int x3 = rectX[oilFocus]+rectWidth[oilFocus]/2 + 3;
      int y3 = rectY[oilFocus];
      int x4 = oilGlobalX+oilGlobalWidth/2 + 3;
      int y4 = oilGlobalY+oilGlobalHeight;
      quad(x1,y1,x2,y2,x3,y3,x4,y4);
    }
  
  /**************************************************
  *  Berechnen der Mengenverhältnisse für
  *  Bioenergie und Öl 
  **************************************************/
  
  // Wie schnell aufgefüllt wird, hängt von der Füllgeschwindigkeit und der Breite des Reservoirs ab
    if (bioFocus >= 0){
      bioFocusVelocity = bioFillVelocity / (rectWidth[bioFocus]/10);
    }
  
    if (oilFocus >= 0){
      if (oilGlobalQuant > 0) {
        oilFocusVelocity = oilFillVelocity / (rectWidth[oilFocus]/10);
      }
      else {
        oilFocusVelocity = 0;
      }
    }
  
  //Ändert sich etwas in dieser Runde?
    for (int i=0;i<reservoirs;i++){
      bioQuantOld[i] = bioQuant[i];
      oilQuantOld[i] = oilQuant[i];
    }
             
     // Gibt es Streit (und genügend Öl)?
     konflikt = (bioFocus == oilFocus && oilGlobalQuant>0) ? true : false;
  
    // Ja: Bio und Öl streiten um das selbe Reservoir
       if(konflikt && bioFocus >= 0 && oilFocus >= 0){
        if (bioQuant[bioFocus] < rectHeight[bioFocus]*rectWidth[bioFocus]-oilQuant[bioFocus]){
          bioQuant[bioFocus] += bioFocusVelocity*rectWidth[bioFocus];
        }
    
        if (oilQuant[oilFocus] < rectHeight[oilFocus]*rectWidth[oilFocus]-bioQuant[oilFocus]){
          oilQuant[oilFocus] += oilFocusVelocity*rectWidth[oilFocus];
          oilGlobalQuant -= oilFocusVelocity*rectWidth[oilFocus];
        }
              }
          
    // Nein: Bio und Öl befüllen unterschiedliche Reservoirs
      else {        

        if (bioFocus >= 0){
         if(bioQuant[bioFocus] < rectHeight[bioFocus]*rectWidth[bioFocus]){
           if(bioQuant[bioFocus]+bioFocusVelocity*rectWidth[bioFocus] < rectHeight[bioFocus]*rectWidth[bioFocus]) {
              bioQuant[bioFocus] += bioFocusVelocity*rectWidth[bioFocus];
              oilQuant[bioFocus] = min(oilQuant[bioFocus],rectHeight[bioFocus]*rectWidth[bioFocus]-bioQuant[bioFocus]);
           }
           else {
             float bioDiff = rectHeight[bioFocus]*rectWidth[bioFocus] - bioQuant[bioFocus];
             bioQuant[bioFocus] += bioDiff;
             oilQuant[bioFocus] = max(oilQuant[bioFocus]-bioDiff, 0);         
           }
         }
         if (bioQuant[bioFocus] == rectHeight[bioFocus]*rectWidth[bioFocus] && bioQuant[bioFocus] > bioQuantOld[bioFocus]){
            bioBarrels = bioBarrels + 2;
            if (soundOn){
              bioFull.rewind();
              bioFull.play();
            }
          }
        }
        
       if (oilFocus >= 0){
         if(oilQuant[oilFocus] < rectHeight[oilFocus]*rectWidth[oilFocus]){
           if(oilQuant[oilFocus]+oilFocusVelocity*rectWidth[oilFocus] < rectHeight[oilFocus]*rectWidth[oilFocus]) {
             oilGlobalQuant -= oilFocusVelocity*rectWidth[oilFocus];
             oilQuant[oilFocus] += oilFocusVelocity*rectWidth[oilFocus];
             bioQuant[oilFocus] = min(bioQuant[oilFocus],rectHeight[oilFocus]*rectWidth[oilFocus]-oilQuant[oilFocus]);
           }
           else {
             float oilDiff = rectHeight[oilFocus]*rectWidth[oilFocus] - oilQuant[oilFocus];
             oilGlobalQuant -= oilDiff;
             oilQuant[oilFocus] += oilDiff;
             bioQuant[oilFocus] = max(bioQuant[oilFocus]-oilDiff, 0);
           }
         }
         if (oilQuant[oilFocus] == rectHeight[oilFocus]*rectWidth[oilFocus] && oilQuant[oilFocus] > oilQuantOld[oilFocus]){
            oilBarrels++;
            if (soundOn){
              oilFull.rewind();
              oilFull.play();
            }
         }
        }
     }
         
    if (oilGlobalQuant < 0) oilGlobalQuant = 0;
    
        
  /**************************************************
  *  Zeichne alle Vorräte
  **************************************************/
    noStroke();
    textAlign(LEFT);
  
    for (int i=0;i<reservoirs;i++){
      fill(bioColor);
      rect (rectX[i], rectY[i]+rectHeight[i]-bioQuant[i]/rectWidth[i],rectWidth[i],bioQuant[i]/rectWidth[i]);
      fill(bioColorDark);
      if(debug) text (int(bioQuant[i]),rectX[i]+rectWidth[i]+10,rectY[i]+rectHeight[i]+5);
  
      fill(oilColor);
      rect (rectX[i], rectY[i],rectWidth[i],oilQuant[i]/rectWidth[i]);
      if(debug) text (int(oilQuant[i]),rectX[i]+rectWidth[i]+10,rectY[i]+4);
    }
    
    for (int i=0;i<sources;i++){
      image(oilSource,oilSourceX[i],oilSourceY[i]);
    }
  
  /**************************************************
  *  Zeichne die Rahmen aller Reservoirs
  **************************************************/
    stroke(0);
    strokeWeight(2);
    for (int i=0;i<reservoirs;i++){
      noFill();
      rect(rectX[i]-1,rectY[i]-1, rectWidth[i]+1,rectHeight[i]+1);
      fill(32);
      textAlign(CENTER);
      if (debug) text(rectWidth[i]*rectHeight[i], rectX[i]+rectWidth[i]/2,rectY[i]+rectHeight[i]+25);
    }
  
  /**************************************************
  *  Zeichne die Spieler
  **************************************************/ 
    if (!oilQuit){
      stroke(oilColor);
      fill(oilColor,50);
      ellipse(oilX,oilY,10+oilAura,10+oilAura);
    }
    
    if (!bioQuit){
      stroke(bioColorDark);
      fill(bioColor,70);
      ellipse(bioX,bioY,10+bioAura,10+bioAura);
    }

  /**************************************************
  *  Zeichne den globalen Ölvorrat und 
  *  die Temperaturen
  **************************************************/
    noStroke();
    fill(oilColor,50);    
    rect(oilGlobalX, oilGlobalY+oilGlobalHeight-oilGlobalHeight*oilGlobalQuant/oilGlobalMax,oilGlobalWidth,oilGlobalHeight*oilGlobalQuant/oilGlobalMax);
    
    fill(255);
    textAlign(LEFT);
    String ausgabe = "Welttemperatur: " + nf(temperatureGlobal,2,2);
    text(ausgabe,700,70);
    
    if (oilGlobalQuant < oilGlobalHeight*oilGlobalWidth/2){
      fill(255,0,0);
      textAlign(RIGHT);
      text("Refill!",oilGlobalX-30+14,oilGlobalY+75+18);
      noFill();
      stroke(255,0,0);
      strokeWeight(3);
      for (int i=0;i<sources;i++){
        ellipseMode(CORNER);
        ellipse(oilSourceX[i]-15,oilSourceY[i]-10,70,70);
      }
    }
  
  /**************************************************
  *  Zeichne den aktuellen Punktestand
  **************************************************/
    bioScore = 0;
    oilScore = 0;
    int globalScore = 0;
 
//    bioBarrels = 127;
//    oilBarrels = 16;
//    
    for (int i=0;i<reservoirs;i++){
      bioScore += bioQuant[i];
      oilScore += oilQuant[i];
      globalScore += rectWidth[i]*rectHeight[i];
    }
    
    if (bioScore == globalScore || oilScore == globalScore){
      oilQuit = true;
      bioQuit = true;
    }
    
    tint(bioColorDark);
    for (int i=0; i<floor(bioBarrels/10); i++){
      image(bioBarrel, bioGlobalX+bioGlobalWidth+20+20*i, bioGlobalY+5);
    }

    tint(bioColorDark,90);
    for (int i=0; i<bioBarrels%10; i++){
      image(bioBarrel, bioGlobalX+bioGlobalWidth+20+20*i, bioGlobalY+25);
    }

    fill(bioColorDark);
    textAlign(LEFT);
    text(bioScore,bioGlobalX+bioGlobalWidth+20+2,bioGlobalY+bioGlobalHeight/2+30);
  
    tint(oilColor);
    for (int i=0; i<floor(oilBarrels/10); i++){
      image(oilBarrel, oilGlobalX-30-20*i, oilGlobalY+15);
    }

    tint(oilColor,90);
    for (int i=0; i<oilBarrels%10; i++){
      image(oilBarrel, oilGlobalX-30-20*i, oilGlobalY+35);
    }
  
    fill(oilColor);
    textAlign(RIGHT);
    text(oilScore,oilGlobalX-30+14,oilGlobalY+55+18);
 
    tint(255,255);
    
  /**************************************************
  *  Zeichne den Händedruck, die Geschwindigkeit 
  *  und die Handtemperatur
  **************************************************/
    
    int mapVelocity = (int)map(bioVelocity,0,15,0,580);    
    int mapTemperature = (int)map(oilHandTemperature,0,255,0,100);
  
    fill(bioColorDark,128); 
    noStroke();
    rect(444,653,mapVelocity,12);

    fill(255,100,100,128);
    noStroke();
    rect(oilGlobalX-10,114-mapTemperature,10,mapTemperature);
    
  /**************************************************
  *  Im Debug-Modus werden zusätzliche 
  *  Informationen ausgegeben
  **************************************************/
    if (debug){
      fill(oilColor);
      textAlign(LEFT);
      textSize(10);
      text(" DEBUG-MODE\n d: debug ON/OFF\n 1-3: Zustand 1-3\n +/-: BioVel up/down\n b: bioVel = 0\n h: Hand drückt\n s: Sound On/Off\n n: neues Spiel\n q: quit",width-200,15);

      textSize(18);
      text(oilGlobalQuant,oilGlobalX+oilGlobalWidth+10,oilGlobalY+oilGlobalHeight-oilGlobalQuant/oilGlobalWidth+10);
      
      text("Geschwindigkeit: "+bioVelocity, width*3/4+50,height-20); 
      textAlign(LEFT);
      fill(0);
      text("Handtemperatur: " + oilHandTemperature,10,60);
         
      if(connected){
        fill(255);
        text("BioStick: " + bioStick.getX() + " :: " + bioStick.getY(), 10,height-100);
        text("OilStick: " + oilStick.getX() + " :: " + oilStick.getY(), 10,height-75);
      }
    }

  /**************************************************
    Spielzustand
    0: Spiel startet neu.
    1: Bio bereit, d.h. Tempo zum ersten Mal > 0  
    2: Öl bereit, d.h. Hand zum ersten Mal aufgelegt
    3: Spiel läuft
    6: Game Over
  **************************************************/  

     if (gameState < 3) {
       if (bioVelocity > 0){
         gameState = gameState | (1 << 0); //Setze Bit 0
       }
       else {
         gameState = gameState & 254; //lösche Bit 0
       }
       if (oilHandPressure > oilHandPressureThreshold){
         gameState = gameState | (1 << 1); //Setze Bit 1   
       }
       else {
         gameState = gameState & 253; //lösche Bit 1
       }
     }

    if (bioQuit && oilQuit){
       gameState = 6;
     }    
   
    switch (gameState){
  
    case 0:
      screenText = "Get Ready!";
      fill(255,200);
      stroke(255);
      strokeWeight(3);
      rect(-10,309,1037,150);
      textAlign(CENTER);
      textFont(messageFont,100);
      fill(0);
      text("Get Ready!",width/2,height/2+40);
   
      break;

    case 1:
      fill(255,200);
      stroke(255);
      strokeWeight(3);
      rect(-10,522,1037,100);
      textAlign(CENTER);
      textFont(messageFont,60);
      fill(0);
      text("Player Bio Ready!",width/2,597);
      break;

    case 2:
      fill(255,200);
      stroke(255);
      strokeWeight(3);
      rect(-10,140,1037,100);
      textAlign(CENTER);
      textFont(messageFont,60);
      fill(0);
      text("Player Oil Ready!",width/2,215);
      break;

      
    case 3:
      screenText = "Game Running";
      if (!gameStart){
        if (soundOn) {
          if(atmoReady.isPlaying()) {
             if (atmoOn) atmoGame.unmute();
             atmoGameOn = true;
             atmoReady.mute();
             atmoReadyOn = false;
          }
        }
        gameStart = true;
      }
      if (bioVelocity == 0){
         bioQuit = true;
         bioQuitSound.play();
      }
      if (oilHandPressure < oilHandPressureThreshold){
        oilQuit = true;
        oilQuitSound.play();     
      }
      break;
    
    case 6:
      if (soundOn) {
        atmoGame.pause();
        gameOverSound.play();
      }
      fill(255,200);
      int screenY = 150;
      
      stroke(255);
      strokeWeight(3);
      rect(-10,screenY,1037,468);
      textAlign(CENTER);
      textFont(messageFont,100);
      fill(0);
      text("GAME OVER",width/2,screenY+120);
      textFont(messageFont,12);

      int bigBarrelMultiplier = 10000;
      int barrelMultiplier = 1000;     

      textAlign(LEFT);
      fill(bioColorDark);
      text("Player Bio",71,screenY+180); // 353

      int bigBio = floor(bioBarrels/10);
      
      tint(bioColorDark);
      image(bioBarrel,70,screenY+198); //381
      textAlign(LEFT);      
      text("x "+bigBio+":",107,screenY+211); //394
      textAlign(RIGHT);
      text(bigBio*bigBarrelMultiplier+" Units", 319, screenY+211);
      
      tint(bioColorDark,90);                
      image(bioBarrel,70,screenY+219); //402
      textAlign(LEFT);
      text("x "+bioBarrels%10+":",107,screenY+234); //417
      textAlign(RIGHT);
      text((bioBarrels%10)*barrelMultiplier+" Units", 319, screenY+234); 
      
      text(bioScore + " Units",319,screenY+254); //437
      
      int bioGT = bigBio*bigBarrelMultiplier+(bioBarrels%10)*barrelMultiplier+bioScore;
      text (bioGT + " Units",319,screenY+297); //480
      
      
      textAlign(LEFT);
      fill(oilColor);
      text("Player Oil",560,screenY+180);

      int bigOil = floor(oilBarrels/10);
      tint(oilColor);
      image(oilBarrel,560,screenY+198);
      textAlign(LEFT);      
      text("x "+bigOil+":",597,screenY+211);
      textAlign(RIGHT);
      text(bigOil*bigBarrelMultiplier+" Units", 810, screenY+211);
      
      tint(oilColor,90);                
      image(oilBarrel,560,screenY+219);
      textAlign(LEFT);
      text("x "+oilBarrels%10+":",597,screenY+234);
      textAlign(RIGHT);
      text((oilBarrels%10)*barrelMultiplier+" Units", 810, screenY+234); 
      
      text(oilScore + " Units",810,screenY+254);
      int oilGT = bigOil*bigBarrelMultiplier+(oilBarrels%10)*barrelMultiplier+oilScore;
      text (oilGT + " Units",810,screenY+297);
      
      if (bioGT > oilGT){
        winnerText = "Player Bio Wins!";
      }
      
      if (oilGT > bioGT){
        winnerText = "Player Oil Wins!";      
      }
      
      if (oilGT == bioGT){
         winnerText = "Draw!";      
      }
      
      textAlign(CENTER);
      textFont(messageFont,60);
      fill(0);
      text(winnerText,width/2,580);
      textFont(messageFont,12);

      
      tint(255,255);
      
      break;
    }

  }
  
  /**************************************************
  *  Gibt die Nummer des Reservoirs zurück, das
  *  die Koordinaten x uns y enthält.
  *  @param x  X-Koordinate, die zu untersuchen ist
  *  @param y  Y-Koordinate, die zu untersuchen ist
  *  @return focus
  **************************************************/
  int findFocus(int x, int y){
    int focus = -1;
    for (int i=0; i<reservoirs; i++){
      if (x>rectX[i] && x < rectX[i] + rectWidth[i]){
        if (y>rectY[i] && y < rectY[i] + rectHeight[i]){
          focus = i;
          break;
        }
      }
    }
    return focus;
  }
  

  /**************************************************
  *  Nachtanken
  **************************************************/  
  
  void fillGlobalOil(int source){
      if (oilGlobalQuant < oilGlobalMax){
        stroke(oilColor);
        fill(oilColor);
        int x1 = oilGlobalX+oilGlobalWidth/2 - 3;
        int y1 = oilGlobalY+oilGlobalHeight;
        int x2 = oilSourceX[source] + 20;
        int y2 = oilSourceY[source];
        int x3 = oilSourceX[source] + 23;
        int y3 = oilSourceY[source];
        int x4 = oilGlobalX+oilGlobalWidth/2 + 3;
        int y4 = oilGlobalY+oilGlobalHeight;
        quad(x1,y1,x2,y2,x3,y3,x4,y4);
        
        oilGlobalQuant = min(oilGlobalMax, oilGlobalQuant + oilAddQuant);
        temperatureGlobal += oilAddTemperature;
        oilHandTemperature += oilAddHandTemperature;
        oilHandTemperature = min(oilHandTemperature, 255);
      }
  }


 /**************************************************
  *  Tastaturabfrage
  **************************************************/  

  void keyPressed(){
    if (debug) {
      if (key == 'b') bioVelocity = 0;
      if (key == 'h') {
        if (oilHandPressure == 0) oilHandPressure = 10;
        else oilHandPressure = 0;
      }
      if (key == '+') bioVelocity = min(15,++bioVelocity);
      if (key == '-') bioVelocity = max(0,--bioVelocity);
      if(key == '1') gameState = 1;
      if(key == '2') gameState = 2;
      if(key == '3') gameState = 3;
    }
    
    if (key == 'd'){
      if(debug){
        debug = false;
      }
      else{
        debug = true;
      }
    }

    if (key == 's'){
      atmoOn = !atmoOn;
      if(atmoOn){
        if (atmoReadyOn) atmoReady.unmute();
        if (atmoGameOn) atmoGame.unmute();        
      }
      else{
        atmoReady.mute();
        atmoGame.mute();
      }
    }
      
    if(key == 'q') exit();
    if(key == 'n') {
      arduinoSerial.stop();
      gameState = 1;
      setup();
    }
    
  }
  
  void stop(){
    if (soundOn) {
      oilEnter.close();
      oilFull.close();
      oilCharge.close();
      oilQuitSound.close();

      bioEnter.close();
      bioFull.close();
      bioQuitSound.close();
      
      atmoReady.close();
      atmoGame.close();
      gameOverSound.close();
      
      arduinoSerial.stop();
      minim.stop();
      super.stop();
    }
  }
