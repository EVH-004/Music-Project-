//Libraries
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//Classes
Minim minim;
AudioPlayer ap;
AudioBuffer ab;
FFT bfft; 

//Basic Variables
int frameSize = 512;

void setup()
{
  fullScreen(P3D);
  
  //Universal Setup
  minim = new Minim(this);
  ap = minim.loadFile("Fnaf.mp3", frameSize);
  ap.cue(0);
  ap.play();
  ab = ap.left;
  bfft = new FFT(ap.bufferSize(), ap.sampleRate());
  
  //SETUP
  walls = new Wall[nbWalls];
  for (int i = 0; i < nbWalls; i+=4) 
  {
    walls[i] = new Wall(0, height/2, 10, height); 
  }
  for (int i = 1; i < nbWalls; i+=4) 
  {
    walls[i] = new Wall(width, height/2, 10, height); 
  }
  for (int i = 2; i < nbWalls; i+=4)
 {
    walls[i] = new Wall(width/2, height, width, 10); 
  }
  for (int i = 3; i < nbWalls; i+=4) 
  {
    walls[i] = new Wall(width/2, 0, width, 10); 
  }
  
}
// end of Erins Code

void draw()
{
  background(0);
  colorMode(RGB);
  FnafVis();
}


float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.20;   // 20%

float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

float scoreDecreaseRate = 25;

int nbWalls = 500;
Wall[] walls;

void FnafVis()
{
  bfft.forward(ap.mix);
  camera(width/2, height/2, 500, width/2, height/2, -500, 0, 1, 0);
 
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;
  

  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;
 
 
  for(int i = 0; i < bfft.specSize()*specLow; i++)
  {
    scoreLow += bfft.getBand(i);
  }
  
  for(int i = (int)(bfft.specSize()*specLow); i < bfft.specSize()*specMid; i++)
  {
    scoreMid += bfft.getBand(i);
  }
  
  for(int i = (int)(bfft.specSize()*specMid); i < bfft.specSize()*specHi; i++)
  {
    scoreHi += bfft.getBand(i);
  }
  
 
  if (oldScoreLow > scoreLow) 
  {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }
  
  if (oldScoreMid > scoreMid) 
  {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }
  
  if (oldScoreHi > scoreHi) 
  {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }
  
  //end of matthews code
