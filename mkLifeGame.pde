PImage img;
PImage gray_img;
int cellWidth=5;
int cellHeight=5;

int setColor(int posx, int posy) {
  int clr=0;
  for (int k=0; k<cellHeight; k++) {
    for (int l=0; l<cellWidth; l++) {
//      int pos = posx + posy*width;
      if(posx+l<img.width && posy+k<img.height){
      color grayColor = gray_img.pixels[(posy+k)*(width)+posx+l];
      clr+=red(grayColor);
      println(posy+k,":",posx+l);
      }
    }
  }
  return clr/(cellHeight*cellWidth);
}
PImage makeGrayImg(PImage img){
  gray_img = createImage( img.width, img.height, RGB );
  img.loadPixels();
  for ( int y = 0; y < img.height; y++){
    for ( int x = 0; x < img.width; x++){
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
void mkcsv(PImage img){
  String [] lines = new String[img.height/cellHeight];
  for (int i=0; i<img.height/cellHeight; i++) {
    String [] data = new String[img.width/cellWidth];
    for (int j=0; j<img.width/cellWidth; j++) {
      println(setColor(i*cellWidth,j*cellHeight));
      if(setColor(j*cellWidth,i*cellHeight)>128){
        data[j]="0";
      }else{
        data[j]="1";
      }
    }
    lines[i]=join(data, ',');
  }
  saveStrings("data.csv", lines);
}

void setup() {
  img=loadImage("G.png");
  size(img.width, img.height);
  stroke(90);
  gray_img=makeGrayImg(img);
  mkcsv(gray_img);
}

void draw() {
  
  
}

