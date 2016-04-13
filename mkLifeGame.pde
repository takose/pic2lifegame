import gifAnimation.*;
GifMaker gifMaker;

//make csv
String imgName="icon.jpg";
PImage img;
PImage gray_img;

//lifegame
int [][] cell;
int [][] temp;
int cellWidth=5;
int cellHeight=5;
int numCellX, numCellY;
int threshold=100;
color backClr=#888888;
color strokeClr=255;

int setColor(int posx, int posy) {
  int clr=0;
  //cell内のピクセルデータ全てを平均するならこっちを使う
  /*
  for (int k=0; k<cellHeight; k++) {
    for (int l=0; l<cellWidth; l++) {
      //      int pos = posx + posy*width;
      if (posx+l<img.width && posy+k<img.height) {
        color grayColor = gray_img.pixels[(posy+k)*(width)+posx+l];
        clr+=red(grayColor);
        println(posy+k, ":", posx+l);
      }
    }
  }
  return clr/(cellHeight*cellWidth);
  */
  color grayColor = gray_img.pixels[posy*(width)+posx];
  clr=(int)red(grayColor);
  return clr;
}
PImage makeGrayImg(PImage img) {
  gray_img = createImage( img.width, img.height, RGB );
  img.loadPixels();
  for ( int y = 0; y < img.height; y++) {
    for ( int x = 0; x < img.width; x++) {
      int pos = x + y*img.width;
      color c = img.pixels[pos];
      float r = red( c );
      float g = green( c );
      float b = blue( c );
      float gray = 0.3 * r + 0.59 * g + 0.11 * b;
      gray_img.pixels[pos] = color(gray);
    }
  }
  return gray_img;
}
void mkcsv(PImage img) {
  String [] lines = new String[numCellY];
  for (int i=0; i<numCellY; i++) {
    String [] data = new String[numCellX];
    for (int j=0; j<numCellX; j++) {
      println(setColor(i*cellWidth, j*cellHeight));
      if (setColor(j*cellWidth, i*cellHeight)>threshold) {
        cell[i+1][j+1]=0;
        data[j]="0";
      } else {
        cell[i+1][j+1]=1;
        data[j]="1";
      }
    }
    lines[i]=join(data, ',');
  }
  saveStrings("data.csv", lines);
}
void setup() {
  img=loadImage(imgName);
  size(img.width, img.height);
  numCellX = width/cellWidth;
  numCellY = height/cellHeight;
  cell = new int [numCellY+2][numCellX+2];
  temp = new int [numCellY+2][numCellX+2];
  for (int i=0; i<numCellY+2; i++) {
    for (int j=0; j<numCellX+2; j++) {
      cell[i][j]=0;
    }
  }
  gray_img=makeGrayImg(img);
  mkcsv(gray_img);
//  frameRate(3);
  stroke(strokeClr);
  noStroke();
  gifMaker = new GifMaker(this, "lifegamecolor.gif");
  gifMaker.setDelay(10);
}

void draw() {
  background(backClr);
  update();
  for ( int x=1; x<numCellX+1; x++ ) {
    for ( int y=1; y<numCellY+1; y++ ) {
      if (frameCount>1) {
        cell[y][x]=temp[y][x];
      }
      if (cell[y][x]==1) {
        fill(img.get(x*cellWidth,y*cellHeight));
        rect((x-1)*cellWidth, (y-1)*cellHeight, cellWidth, cellHeight);
      } else {
        fill(backClr);
        rect((x-1)*cellWidth, (y-1)*cellHeight, cellWidth, cellHeight);
      }
    }
  }
  gifMaker.addFrame();
  if (frameCount >= 200) {
    gifMaker.finish();
    exit();
  }
}
void update() {
  for (int i=1; i<numCellY+1; i++) {
    for (int j=1; j<numCellX+1; j++) {
      int cnt=0;
      if (cell[i-1][j-1]==1) {
        cnt++;
      }
      if (cell[i-1][j]==1) {
        cnt++;
      }
      if (cell[i-1][j+1]==1) {
        cnt++;
      }
      if (cell[i][j-1]==1) {
        cnt++;
      }
      if (cell[i][j+1]==1) {
        cnt++;
      }
      if (cell[i+1][j-1]==1) {
        cnt++;
      }
      if (cell[i+1][j]==1) {
        cnt++;
      }
      if (cell[i+1][j+1]==1) {
        cnt++;
      }
      if (cnt==3) {
        temp[i][j]=1;
        //ホントは1,3
      } else if (cnt<=1||cnt>4) {
        temp[i][j]=0;
      }
    }
  }
}

