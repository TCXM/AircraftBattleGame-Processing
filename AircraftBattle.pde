PFont ink_font;

// Background
PImage background;

// Icons
PImage game_play;
PImage game_again;
PImage game_continue;
PImage game_over;
PImage game_pause_nor;
PImage game_pause_pressed;
PImage game_resume_nor;
PImage game_resume_pressed;

// Sprites
PImage bullet1;
PImage bullet2;
PImage enemy1;
PImage enemy1_down1;
PImage enemy1_down2;
PImage enemy1_down3;
PImage enemy1_down4;
PImage hero1;
PImage hero2;
PImage hero_blowup_n1;
PImage hero_blowup_n2;
PImage hero_blowup_n3;
PImage hero_blowup_n4;

void showTitle(){
    fill(0, 0, 0, 255);
    textFont(ink_font);
    textAlign(CENTER, CENTER);
    text("Aircraft Battle", width/2, height/2 - 100);
}

class Hero{
    int x;
    int y;
    PImage hero;

    CTimer timer;

    Hero(int x, int y){
        this.x = x;
        this.y = y;
        this.timer = new CTimer(250);
        hero = hero1;
    }
    void display(){
        if ( timer.isFinished() ) {
            hero = hero == hero1 ? hero2 : hero1;
            timer.start();
        }
        imageMode(CENTER);
        image(hero, x, y);
    }
}

class Enemy{
    int x;
    int y;
    Enemy(int x, int y){
        this.x = x;
        this.y = y;
    }
    void display(){
        imageMode(CENTER);
        image(enemy1, x, y);
    }
}

class PauseResumeButten{
    int x;
    int y;
    PauseResumeButten(int x, int y){
        this.x = x;
        this.y = y;
    }
    void display(){
        imageMode(CENTER);
        image(game_pause_nor, x, y);
    }
}

class GamePlayButten{
    int x;
    int y;
    GamePlayButten(int x, int y){
        this.x = x;
        this.y = y;
    }
    void display(){
        imageMode(CENTER);
        image(game_play, x, y);
    }
}

class CTimer {
    int savedTime; 
    int totalTime; 
    CTimer(int tempTotalTime) {
        totalTime = tempTotalTime;
    }

    void start() {
        savedTime = millis(); 
    }
    boolean isFinished() { 
        int passedTime = millis()- savedTime;
        if (passedTime > totalTime) {
            return true;
        } else {
            return false;
        }
    }
}

Hero hero;
Enemy[] enemies;
GamePlayButten gamePlayButten;

void setup(){
    // same as the size of background image
    size(480, 852);
    ink_font = createFont("Ink Free", 48);
    // Load Images
    background = loadImage("Images\\background.png");
    game_play = loadImage("Images\\game_play.png");
    game_again = loadImage("Images\\game_again.png");
    game_continue = loadImage("Images\\game_continue.png");
    game_over = loadImage("Images\\game_over.png");
    game_pause_nor = loadImage("Images\\game_pause_nor.png");
    game_pause_pressed = loadImage("Images\\game_pause_pressed.png");
    game_resume_nor = loadImage("Images\\game_resume_nor.png");
    game_resume_pressed = loadImage("Images\\game_resume_pressed.png");
    bullet1 = loadImage("Sprites\\bullet\\fly\\bullet1.png");
    bullet2 = loadImage("Sprites\\bullet\\fly\\bullet2.png");
    enemy1 = loadImage("Sprites\\enemy1\\fly\\enemy1.png");
    enemy1_down1 = loadImage("Sprites\\enemy1\\down\\enemy1_down1.png");
    enemy1_down2 = loadImage("Sprites\\enemy1\\down\\enemy1_down2.png");
    enemy1_down3 = loadImage("Sprites\\enemy1\\down\\enemy1_down3.png");
    enemy1_down4 = loadImage("Sprites\\enemy1\\down\\enemy1_down4.png");
    hero1 = loadImage("Sprites\\hero\\fly\\hero1.png");
    hero2 = loadImage("Sprites\\hero\\fly\\hero2.png");
    hero_blowup_n1 = loadImage("Sprites\\hero\\down\\hero_blowup_n1.png");
    hero_blowup_n2 = loadImage("Sprites\\hero\\down\\hero_blowup_n2.png");
    hero_blowup_n3 = loadImage("Sprites\\hero\\down\\hero_blowup_n3.png");
    hero_blowup_n4 = loadImage("Sprites\\hero\\down\\hero_blowup_n4.png");

    // Initialize Hero
    hero = new Hero(width / 2, 700);
    enemies = new Enemy[4];
    for(int i = 0; i < enemies.length; i++){
        enemies[i] = new Enemy((i + 1) * (width / (enemies.length + 1)), 100);
    }
    gamePlayButten = new GamePlayButten(width / 2, height / 2);
}

void draw(){
    imageMode(CENTER);
    image(background, width / 2, height / 2);
    hero.display();
    for(int i = 0; i < enemies.length; i++){
        enemies[i].display();
    }
    gamePlayButten.display();
    showTitle();
}