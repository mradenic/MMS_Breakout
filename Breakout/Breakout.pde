import processing.sound.*;
String plocaImg = "bat1.gif", loptaImg = "ball1.gif", cigla1Img = "stone01.gif", cigla2Img = "stone02.gif", cigla3Img = "stone03.gif", cigla4Img = "stone05.gif",
                              cigla5Img = "stone16.gif", cigla6Img = "stone17.gif";

color pozadina = color(50, 50, 50);
static int gameSirina = 600, gameVisina = 400;
String porukaPitanja;
GameObject ploca, lopta, zidL, zidD, zidG;
int rezultat, zivoti, brojCigli;

// glazba
SoundFile file, zvuk_path;
String audioName = "pozadinska.wav";
String sudarName = "sudar.wav";
String krajName = "kraj.wav";
String pobjedaName = "pobjeda.wav";
String path_backg, path_sudar, path_kraj, path_pobjeda;

void setup() {
  size(600, 400);
  noStroke();
  //visina i šitina ekrana
  zidL = new GameObject(0,0,26,400);
  zidL.solid = true;
  
  zidD = new GameObject(600-26,0,32,400);
  zidD.solid = true;
  
  zidG = new GameObject(26,0,600-52,32);
  zidG.solid = true;
  
  //Želimo da se donja pločica nalazi otprilike u sredini
  ploca = new GameObject(300-24,400-32,plocaImg);
  ploca.solid = true;
  lopta = new GameObject(300-8, 200 - 8 , loptaImg);
  lopta.solid = true;
  
    //cik-cak cigle
  for(int a = 26; a <=  600 - 32; a +=32)
  {
    GameObject brick6 = new GameObject(a,36, cigla6Img);
    brick6.solid = true;
    //dodajemo oznaku da možemo kasnije provjeriti je li to što smo udarili cigla
    brick6.klasaOznaka = "brick";
    //dodajemo id kako bi razlikovali o kojoj se cigli radi za različito bodovanje
    brick6.idOznaka = "brick6";
    brojCigli++;
  }
      //šarene cigle
  for(int a = 26; a <=  600 - 32; a +=32)
  {
    GameObject brick5 = new GameObject(a,52, cigla5Img);
    brick5.solid = true;
    brick5.klasaOznaka = "brick";
    brick5.idOznaka = "brick5";
    brojCigli++;
  }
    //žute cigle
  for(int a = 26; a <=  600 - 32; a +=32)
  {
    GameObject brick4 = new GameObject(a,68, cigla4Img);
    brick4.solid = true;
    brick4.klasaOznaka = "brick";
    brick4.idOznaka = "brick4";
    brojCigli++;
  }
  
    //zelene cigle
  for(int a = 26; a <=  600 - 32; a +=32)
  {
    GameObject brick3 = new GameObject(a,84, cigla3Img);
    brick3.solid = true;
    brick3.klasaOznaka = "brick";
    brick3.idOznaka = "brick3";
    brojCigli++;
  }
  
  //plave cigle
  for(int a = 26; a <=  600 - 32; a +=32)
  {
    GameObject brick1 = new GameObject(a,100, cigla1Img);
    brick1.solid = true;
    brick1.klasaOznaka = "brick";
    brick1.idOznaka = "brick1";
    brojCigli++;
  }
  //crvene cigle
  for(int a = 26; a <= 600 -  32; a +=32)
  {
    GameObject brick2 = new GameObject(a,116, cigla2Img);
    brick2.solid = true;
    brick2.klasaOznaka = "brick";
    brick2.idOznaka = "brick2";
    brojCigli++;
  }
  
  rezultat = 0;
  zivoti = 3;
  
  //path_backg = sketchPath(audioName);
 // file = new SoundFile(this, path_backg);
 // file.loop(1, 0.25);
}

void draw() {
  background(pozadina);
  noStroke();
  if(lopta.brzina > 0 )
    dodajGravitaciju(lopta);

  azurirajObjekte();
  nacrtajObjekte();
  if(lopta.y > gameVisina)
  {
    lopta.x = 300 - 8;
    lopta.y = 200 - 8;
    lopta.brzina = 0;
    zivoti -= 1;
    if(zivoti <= 0)
    {
 //<>//
       porukaPitanja = "Nova igra?";
       pitaPitanje = true;
       path_kraj = sketchPath(krajName);
       zvuk_path = new SoundFile(this, path_kraj);
       zvuk_path.play();
    }   
  }

  stroke(0);
  fill(0);
  text("Rezultat: " + rezultat + "  Životi: " + zivoti, 16, 15);
  if (pitaPitanje == true) {
    ispisiPitanje();
  }
  izbrisiObjekte(); 
  println("Running");
}

void keyPressed() {

    if(key == CODED)
    {
      //kada se pritisne tipka, ploca se pocne kretati u lijevo/desno "brzinom" 3
      if(keyCode == LEFT)
        ploca.pomak(3,180);

      else if(keyCode == RIGHT)
        ploca.pomak(3, 0);
    }
    
    if(key == ' ')
      if(lopta.brzina == 0)
         lopta.pomak(3, random(0,360));
}

void keyReleased(){
    if(key == CODED)
    {
      //kada se pusti tipka, ploca zaustavi
      if(keyCode == LEFT)
        ploca.pomak(0,180);
      
      else if(keyCode == RIGHT)
        ploca.pomak(0,0);
    }
}

void mousePressed() {
  int odgovor = provjeriOdgovor();
  if(odgovor == DA) 
    restartGame();
 
  else if(odgovor == NE)
  {
    println("IGRA GOTOVA");
    endGame();
  }
}


//ukoliko random loptici dodijeli smjer lijevo/desno ova funkcija pazi da loptica padne
void dodajGravitaciju(GameObject objektUPokretu){
  
    float gravitacija = 0.001;
    float newx = objektUPokretu.x + cos(radians(objektUPokretu.smjer)) * objektUPokretu.brzina;
    float newy = objektUPokretu.y - sin(radians(objektUPokretu.smjer)) * objektUPokretu.brzina + gravitacija;
    objektUPokretu.smjer = prilagodiSmjer(degrees(atan2( -newy + objektUPokretu.y, newx - objektUPokretu.x )));
    objektUPokretu.brzina = sqrt(pow( newy - objektUPokretu.y, 2) + pow( newx - objektUPokretu.x, 2));
}


static int poljeSize = 200;
static GameObject[] objekti = new GameObject[poljeSize]; //polje koje sadrzi sve objekte unutar igrice
static int poljeIndex = 0; //index zadnjeg objekta 
static int objektId = 100000;
static boolean pitaPitanje = false, odgovor = false;
static int pitanjeX=gameSirina/2-80, pitanjeY=gameVisina/2-40, pitanjeSirina=160, pitanjeVisina=40;
final static int NEMA_ODGOVORA = 0;
final static int DA = 1;
final static int NE = 2;

int provjeriOdgovor() { //provjerava je li korisnik pritisnuo Da ili Ne
  if (mouseX >= pitanjeX && mouseX <= pitanjeX+pitanjeSirina/2 && mouseY >= pitanjeY+pitanjeVisina/2 && mouseY <= pitanjeY+pitanjeVisina && pitaPitanje == true) {
    loop();
    pitaPitanje = false;
    odgovor = true;
    return DA;
  }
  if (mouseX >= pitanjeX+pitanjeSirina/2 && mouseX <= pitanjeX+pitanjeSirina && mouseY >= pitanjeY+pitanjeVisina/2 && mouseY <= pitanjeY+pitanjeVisina && pitaPitanje == true) {
    loop();
    pitaPitanje = false;
    odgovor = false;
    return NE;
  }
  return NEMA_ODGOVORA;
}

int provjeriUdar(GameObject test) { //Provjerava udara li objekt neki drugi objekti vraca njegov index
  if (getIndex(test) == -1) {
    return -1;
  }
  for (int a = 0; a < poljeIndex; a++) {
    if (test != objekti[a]) {
      if (objekti[a].solid) {
        if (test.x <= objekti[a].x + objekti[a].ikonaSirina && objekti[a].x <= test.x + test.ikonaSirina
                      && test.y <= objekti[a].y + objekti[a].ikonaVisina && objekti[a].y <= test.y + test.ikonaVisina) {                        
          return a;
          }
        }
    }
  }
  return -1;
}

void ispisiPitanje() {
  stroke(0);
  fill(255);
  rect(pitanjeX - 2, pitanjeY - 2, pitanjeSirina + 4, pitanjeVisina + 4);
  rect(pitanjeX, pitanjeY, pitanjeSirina, pitanjeVisina);
  rect(pitanjeX, pitanjeY + pitanjeVisina / 2, pitanjeSirina / 2, pitanjeVisina / 2);
  rect(pitanjeX + pitanjeSirina / 2, pitanjeY + pitanjeVisina / 2, pitanjeSirina / 2, pitanjeVisina / 2);
  stroke(255);
  fill(0);
  text(porukaPitanja, pitanjeX + 4, pitanjeY + pitanjeVisina - 25);
  text("DA", pitanjeX + 4, pitanjeY + pitanjeVisina - 2);
  text("NE", pitanjeX + pitanjeSirina / 2 + 4, pitanjeY + pitanjeVisina - 2);
  noLoop();
}

void nacrtajObjekte() { 
  for (int a = 0; a < poljeIndex; a++) {
     objekti[a].nacrtaj();
  }
}

void endGame() {
  noLoop();  
  exit();
}

int getIndex(GameObject test) {
  for (int a = 0; a < poljeIndex; a++) {
    if (test == objekti[a]) {
      return a;
    }
  }
  return -1;
}

//funckoja koja pazi da vrijednos smjera nije >360 ili <0
float prilagodiSmjer(float smjer){

  if(smjer > 360)
    smjer = smjer % 360;
    
  while(smjer < 0)
    smjer += 360;
    
  return smjer;  
}

void restartGame() {
  for (int a = 0; a < poljeIndex; a++) {
    objekti[a].unisti();
  }
  izbrisiObjekte();
  setup();
}

void azurirajObjekte() { 
  for (int a = 0; a < poljeIndex; a++) {
     objekti[a].x += cos(radians(objekti[a].smjer)) * objekti[a].brzina;
     objekti[a].y -= sin(radians(objekti[a].smjer)) * objekti[a].brzina;
     int indexSudara = provjeriUdar(objekti[a]);
     if (indexSudara != -1) {
       if(objekti[indexSudara].solid == true && objekti[a] == lopta)
       {
         path_sudar = sketchPath(sudarName);
         zvuk_path = new SoundFile(this, path_sudar);
         if(!zvuk_path.isPlaying())
           zvuk_path.play(1.25);
         objekti[a].x -= cos(radians(objekti[a].smjer)) * objekti[a].brzina;
         objekti[a].y += sin(radians(objekti[a].smjer)) * objekti[a].brzina;
         lopta.kretanjeSudar(lopta.smjer);
         lopta.odbijanje();
         if(objekti[indexSudara].klasaOznaka == "brick")
         {
           if(objekti[indexSudara].idOznaka == "brick6")
             rezultat += 6;
           if(objekti[indexSudara].idOznaka == "brick5")
             rezultat += 5;
           if(objekti[indexSudara].idOznaka == "brick4")
             rezultat += 4;
           if(objekti[indexSudara].idOznaka == "brick3")
             rezultat += 3;
           if(objekti[indexSudara].idOznaka == "brick1")
             rezultat += 2;
           if(objekti[indexSudara].idOznaka == "brick2")
             rezultat += 1;
           objekti[indexSudara].unisti();
           brojCigli--;
           if(brojCigli == 0)
             {
               lopta.x = 300 - 8;
               lopta.y = 250 - 8;
               lopta.brzina = 0;
               porukaPitanja = "Pobijedili ste! Igrati opet?";
               pitaPitanje = true;
               ispisiPitanje();
               path_pobjeda = sketchPath(pobjedaName);
               zvuk_path = new SoundFile(this, path_pobjeda);
               zvuk_path.play(1.1);
             }          
         }
       }

          else  if(objekti[indexSudara].solid == true) {
             objekti[a].x -= cos(radians(objekti[a].smjer)) * objekti[a].brzina;
             objekti[a].y += sin(radians(objekti[a].smjer)) * objekti[a].brzina;
             objekti[a].brzina = 0;
           }
     }
  }
}

void izbrisiObjekte() { 
  for (int a = 0; a < poljeIndex; a++) {
    if (objekti[a].zaUnistavanje == true) {
      for (int b = a; b < poljeIndex - 1; b++) {
        objekti[b] = objekti[b + 1];  
      }
      objekti[poljeIndex] = null;
      poljeIndex--;
      a--;
    }
  }
}

class GameObject {
  float x, y;  
  float brzina, smjer; 
  int ikonaSirina = 16; 
  int ikonaVisina = 16; 

  PImage ikona = null; //ikonakoja se iscrtava
  color objektBoja = color(255, 255, 255); //boja za zidove
  int id; 
  String klasaOznaka = "", idOznaka = "";
  boolean solid = false; //ako je objekt solid od njega se loptica odbija
  boolean zaUnistavanje = false; //Objekt treba obrisati
 
  GameObject() { 
    if (poljeIndex >= poljeSize) { //ako polje nije dovoljno veliko
      poljeSize *= 2;
      GameObject[] vecePolje = new GameObject[poljeSize];
      for (int a = 0; a < poljeIndex; a++) {
         vecePolje[a] = objekti[a];
      }
      objekti = vecePolje;
    }
    objekti[poljeIndex++] = this;
    id = objektId++;
  }
 
  GameObject(float nx, float ny) { 
    this();
    x = nx;
    y = ny;
  }
 
  GameObject(float nx, float ny, String ikonaLokacija) { 
    this();
    x = nx;
    y = ny;
    postaviIkonu(ikonaLokacija);
  }
 
  GameObject(float nx, float ny, int sW, int sH) {
    this(nx, ny);
    ikonaSirina = sW;
    ikonaVisina = sH;
  }


  GameObject(float nx, float ny, int sW, int sH, color c) {
    this(nx, ny, sW, sH);
    objektBoja = c;
  }
  
  void odbijanje(){
    x += 1;
    int indexSudara = provjeriUdar(this);
    if(indexSudara != -1)
    {
      x -= 1;
      smjer = prilagodiSmjer(180 - smjer);
    }
    else
    {
      x -=2;
      indexSudara = provjeriUdar(this);
      if(indexSudara != -1)
      {
        x +=1;
        smjer = prilagodiSmjer(180 - smjer);
      }
      else{
        x += 1;
        y -= 1;
        indexSudara = provjeriUdar(this);
        if(indexSudara != -1)
        {
          y += 1;
          smjer = prilagodiSmjer(360 - smjer);
        }
        else{
          y += 2;
          indexSudara = provjeriUdar(this);
          if(indexSudara != -1)
          {
            y -= 1;
            smjer = prilagodiSmjer(360 - smjer);
          }
          else{
            y -= 1;
          }
        }
      }
    }
  }
 
  void unisti() { 
    zaUnistavanje = true;
  }
  
  void nacrtaj() { 
    if (ikona == null) {
      fill(objektBoja);
      rect(x, y, ikonaSirina, ikonaVisina);
    }
    else
      image(ikona, x, y);    
  }
 
  void pomak(float newbrzina, float newsmjer) { //postavlja brzinu i smjer objekta
    this.brzina = newbrzina;
    this.smjer = newsmjer;
  }
  
  void kretanjeSudar(float smjer){//kretanje nakon sudara
    float normalx = cos(radians(smjer));
    float normaly = -sin(radians(smjer));
    for(int a = 0; a<1000; a++)
    {
      x += normalx;
      y += normaly;
      int indexSudara = provjeriUdar(this);
      if(indexSudara != -1)
      {
        x -= normalx;
        y -=normaly;
        //a = 1000;
        break;
      }
    }
  }
 
  void postaviIkonu(String ikonaLokacija) { //ucitavanje ikone
    ikona = loadImage(ikonaLokacija);
    if (ikona != null) {
      ikonaSirina = ikona.width;
      ikonaVisina = ikona.height;
    }
  }
}
