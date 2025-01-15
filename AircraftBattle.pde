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

class GameManager {
    PFont ink_font;
    PImage background;
    // Icons
    PImage game_play, game_again, game_continue, game_over;
    PImage game_pause_nor, game_pause_pressed, game_resume_nor, game_resume_pressed;
    // Sprites
    PImage bullet1, bullet2;
    PImage enemy1, enemy1_down1, enemy1_down2, enemy1_down3, enemy1_down4;
    PImage hero1, hero2, hero_blowup_n1, hero_blowup_n2, hero_blowup_n3, hero_blowup_n4;

    Hero hero;
    Enemy[] enemies;
    GamePlayButten gamePlayButten;

    GameManager(){}

    void start(){
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
        hero = new Hero(width / 2, 700, hero1, hero2);
        enemies = new Enemy[4];
        for(int i = 0; i < enemies.length; i++){
            enemies[i] = new Enemy((i + 1) * (width / (enemies.length + 1)), 100, enemy1);
        }
        gamePlayButten = new GamePlayButten(width / 2, height / 2, game_play);
    }
    void update(){
        imageMode(CENTER);
        image(background, width / 2, height / 2);
        hero.display();
        for(int i = 0; i < enemies.length; i++){
            enemies[i].display();
        }
        gamePlayButten.display();
        showTitle();
    }
    void showTitle(){
        fill(0, 0, 0, 255);
        textFont(ink_font);
        textAlign(CENTER, CENTER);
        text("Aircraft Battle", width/2, height/2 - 100);
    }
}

class Hero{
    int x;
    int y;
    PImage hero;
    PImage hero1;
    PImage hero2;

    CTimer timer;

    Hero(int x, int y, PImage hero1, PImage hero2){
        this.x = x;
        this.y = y;
        this.timer = new CTimer(250);
        this.hero1 = hero1;
        this.hero2 = hero2;
        this.hero = hero1;
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
    PImage enemy1;
    Enemy(int x, int y, PImage enemy1){
        this.x = x;
        this.y = y;
        this.enemy1 = enemy1;
    }
    void display(){
        imageMode(CENTER);
        image(enemy1, x, y);
    }
}

class PauseResumeButten{
    int x;
    int y;
    PImage game_pause_nor;
    PauseResumeButten(int x, int y, PImage game_pause_nor){
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
    PImage game_play;
    GamePlayButten(int x, int y, PImage game_play){
        this.x = x;
        this.y = y;
        this.game_play = game_play;
    }
    void display(){
        imageMode(CENTER);
        image(game_play, x, y);
    }
}

GameManager gameManager = new GameManager();

void setup(){
    // same as the size of background image
    size(480, 852);
    gameManager.start();
}

void draw(){
    gameManager.update();
}