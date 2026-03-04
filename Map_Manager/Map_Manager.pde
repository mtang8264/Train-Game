float windowWidth = 1440;
float windowHeight = 810;

color backgroundColor = color(25, 25, 25);

float mapSpaceWidth = windowWidth - 100;
float mapSpaceHeight = windowHeight - 100;
color mapSpaceColor = color(75,75,75);

int squareStrokeWidth = 1;

String loadedFile = "";

String[][] mapData = {{}};

color blockColorNone = color(25,25,25);
color blockColorBasic = color(25,180,25);
color blockColorSandy = color(165, 150, 25);

void setup() {
  size(1440, 810);
  //selectInput("Select map file.", "fileSelected");
  loadedFile = "C:\\Users\\mtang\\Documents\\train-game\\train-game\\Maps\\TestMap1.csv";
  parseCSVToMap();
  
  int w = getMapWidth();
  int h = getMapHeight();
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      print(mapData[x][y] + " ");
    }
    println();
  }
}

void draw() {
  background(backgroundColor);
  drawLoadedFileText();
  drawMapSpace();
  drawMap();
}

void keyPressed() {
  if (key == 'o') {
    selectInput("Select map file.", "fileSelected");
  }
}

void mouseClicked() {
  float squareSize = getMaxSquareSize();
  int mapWidth = getMapWidth();
  int mapHeight = getMapHeight();
  float fullWidth = mapWidth * squareSize;
  float fullHeight = mapHeight * squareSize;
  
  float leftBound = (windowWidth / 2) - (fullWidth/2);
  float upBound = (windowHeight/2) - (fullHeight/2);
  
  if (mouseX < leftBound || mouseY < upBound) { return; }
  
  int blockX = (int)((mouseX - leftBound) / squareSize);
  int blockY = (int)((mouseY - upBound) / squareSize);
  
  if (blockX < 0 || blockY < 0 || blockX >= getMapWidth() || blockY >= getMapHeight()) {return;}
  
  println(blockX + ", " + blockY);
  
  changeBlockTileToNext(blockX, blockY);
}

void fileSelected(File selection) {
  // If no file was selected just return.
  if (selection == null) {
    println("No file was selected.");
    return;
  }
  // Record the loaded file.
  loadedFile = selection.getAbsolutePath();
  // Make sure the file is a .csv file.
  if (!loadedFile.substring(loadedFile.length() - 4).equals(".csv")) {
    println("Selected file, " + loadedFile + ", is not a .csv file.");
    loadedFile = "";
    return;
  }
  // Parse file.
  parseCSVToMap();
}

void parseCSVToMap() {
  String[] strings = loadStrings(loadedFile);
  
  String[] line = strings[0].split(",");
  int mapHeight = int(line[0]);
  int mapWidth = int(line[1]);
  
  mapData = new String[mapHeight][mapWidth];
  
  for (int y = 0; y < strings.length - 1; y ++) {
    line = strings[y+1].split(",");
    for (int x = 0; x < line.length; x ++) {
      mapData[x][y] = line[x];
      
      if (mapData[x][y].length() == 1) {
        mapData[x][y] = mapData[x][y] + "e";
      }
    }
  }
}

int getMapWidth() {
  return mapData.length;
}

int getMapHeight() {
  return mapData[1].length;
}

float getMaxSquareSize() {
  float widthIdeal = mapSpaceWidth / getMapWidth();
  float heightIdeal = mapSpaceHeight / getMapHeight();
  return min(widthIdeal, heightIdeal);
}

String getBlock(int x, int y) {
  return mapData[x][y];
}

String getBlockType(int x, int y) {
  return mapData[x][y].substring(0,1);
}

String getBlockTile(int x, int y) {
  return mapData[x][y].substring(1,2);
}

void changeBlockTileToNext(int x, int y) {
  if (getBlockType(x,y).equals("n")) { return; }
  String curr = getBlockTile(x,y);
  String chan = getBlockType(x,y);
  
  if (curr.equals("e")) {
    chan = chan + "t";
  }
  else if (curr.equals("t")) {
    chan = chan + "r";
  }
  else if (curr.equals("r")) {
    chan = chan + "c";
  }
  else {
    chan = chan + "e";
  }
  
  mapData[x][y] = chan;
}

// Draw functions.
void drawLoadedFileText() {
  fill(color(255,255,255));
  textAlign(LEFT, TOP);
  textSize(24);
  text(loadedFile, 5, 5);
}

void drawMapSpace() {
  float l = (windowWidth / 2.0) - (mapSpaceWidth / 2.0);
  float u = (windowHeight / 2.0) - (mapSpaceHeight / 2.0);
  fill(mapSpaceColor);
  rect(l, u, mapSpaceWidth, mapSpaceHeight);
}

void drawMap() {
  // Draw a grid
  float squareSize = getMaxSquareSize();
  int mapWidth = getMapWidth();
  int mapHeight = getMapHeight();
  float fullWidth = mapWidth * squareSize;
  float fullHeight = mapHeight * squareSize;
  
  float leftBound = (windowWidth / 2) - (fullWidth/2);
  float upBound = (windowHeight/2) - (fullHeight/2);
  
  strokeWeight(squareStrokeWidth);
  for (int x = 0; x < mapWidth; x ++) {
    for (int y = 0; y < mapHeight; y ++) {
      // Determine the color of the square.   
      setSquareColor(x,y);
      
      float l = leftBound + (x * squareSize) + squareStrokeWidth;
      float u = upBound + (y * squareSize) + squareStrokeWidth;
      float s = squareSize;
      square(l,u,s);
      
      // Draw the tile type
      String blockTile = getBlockTile(x,y);
      if (!blockTile.equals("e")) {
        float tx = l + (squareSize/2);
        float ty = u + (squareSize/2);
        drawBlockTile(blockTile, tx, ty);
      }
    }
  }
}

void setSquareColor(int x, int y) {
  String data = getBlockType(x, y);
  
  if (data.equals("b")) {
    fill(blockColorBasic);
  } else if (data.equals("s")) {
    fill(blockColorSandy);
  } else {
    fill (blockColorNone);
  }
}

void drawBlockTile(String tile, float x, float y) {
  fill(color(255,255,255));
  textAlign(CENTER, CENTER);
  text(tile, x, y);
}
