import gifAnimation.*;
GifMaker gifMaker;

//make csv
PImage img;
PImage gray_img;
int cellWidth=5;
int cellHeight=5;
int numCellX, numCellY;

//lifegame
int [][] cell;
int [][] temp;

int setColor(int posx, int posy) {
  int clr=0;
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
      if (setColor(j*cellWidth, i*cellHeight)>128) {
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
/*
//CaptureToPNG(ファイル, ファイル名に付与する数字, 数字桁数 ,ドットを含む拡張子);
void CaptureToPNG(String fileURL, int num, int digits, String fileType) {  

  //指定した桁数に満たない数字の右側に0を追加
  String numString = nf(num, digits); 

  // フレーム枚にpngへキャプチャ
  String pngName = fileURL + numString + fileType; 
  save(pngName);
}
*/
void setup() {
  img=loadImage("G.png");
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
  frameRate(3);
  gifMaker = new GifMaker(this, "lifegame.gif"); // 'box.gif'という名前でGIFアニメを作成
  gifMaker.setDelay(100); // アニメーションの間隔を20ms(=50fps)に設定
}

void draw() {
  background( 0 );
  stroke( 0 );
  update();
  for ( int x=1; x<numCellX+1; x++ ) {
    for ( int y=1; y<numCellY+1; y++ ) {
      // ↓ここからライフゲームの描画に関する処理を書く
      if (frameCount>1) {
        cell[y][x]=temp[y][x];//
      }
      if (cell[y][x]==1) {
        fill(#00ff00);
        rect(x*cellWidth, y*cellHeight, cellWidth, cellHeight);
      } else {
        fill(#000000);
        rect(x*cellWidth, y*cellHeight, cellWidth, cellHeight);
      }
    }
  }
  gifMaker.addFrame(); // 現在の画面をアニメーションのコマとして追加

  if (frameCount >= 100) { // 100コマアニメーションした時
    gifMaker.finish(); // GIFアニメの作成を終了
    exit();
  }
  /*
  //1フレームごとにpngでキャプチャ
  CaptureToPNG("./capture/frame_", i, 3, ".png"); 
  i++;
  */
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
      } else if (cnt<=1||cnt>3) {
        temp[i][j]=0;
      }
    }
  }
}

