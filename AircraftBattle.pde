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
    ArrayList<Enemy> enemies = new ArrayList<Enemy>();
    // ArrayList<Bullet> bullets = new ArrayList<Bullet>();
    PauseResumeButten pauseResumeButten;
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
        for(int i = 0; i < 4; i++){
            enemies.add(new Enemy((i + 1) * (width / 5), 100, enemy1, enemy1_down1, enemy1_down2, enemy1_down3, enemy1_down4));
        }
        gamePlayButten = new GamePlayButten(width / 2, height / 2, game_play);
    }
    void update(){
        imageMode(CENTER);
        image(background, width / 2, height / 2);
        hero.update();
        for (Enemy enemy : enemies) {
            enemy.update();
        }
        gamePlayButten.update();
        showTitle();
    }
    void showTitle(){
        fill(0, 0, 0, 255);
        textFont(ink_font);
        textAlign(CENTER, CENTER);
        text("Aircraft Battle", width/2, height/2 - 100);
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

abstract class ImageAgent{
    int x, y;
    PImage image;
    ImageAgent(int x, int y, PImage image){
        this.x = x;
        this.y = y;
        this.image = image;
    }
    void display(){
        imageMode(CENTER);
        image(image, x, y);
    }
}

class Hero extends ImageAgent{
    PImage hero1;
    PImage hero2;

    CTimer timer;

    Hero(int x, int y, PImage hero1, PImage hero2){
        super(x, y, hero1);
        this.timer = new CTimer(250);
        this.hero1 = hero1;
        this.hero2 = hero2;
    }
    void update(){
        if ( timer.isFinished() ) {
            image = image == hero1 ? hero2 : hero1;
            timer.start();
        }
        display();
    }
}

class Enemy extends ImageAgent{
    PImage enemy1;
    PImage enemy1_down1;
    PImage enemy1_down2;
    PImage enemy1_down3;
    PImage enemy1_down4;

    Enemy(int x, int y, PImage enemy1, PImage enemy1_down1, PImage enemy1_down2, PImage enemy1_down3, PImage enemy1_down4){
        super(x, y, enemy1);
        this.enemy1 = enemy1;
        this.enemy1_down1 = enemy1_down1;
        this.enemy1_down2 = enemy1_down2;
        this.enemy1_down3 = enemy1_down3;
        this.enemy1_down4 = enemy1_down4;  
    }
    void update(){
        display();
    }
}

class PauseResumeButten extends ImageAgent{
    PauseResumeButten(int x, int y, PImage game_pause_nor){
        super(x, y, game_pause_nor);
    }
    void update(){
        display();
    }
}

class GamePlayButten extends ImageAgent{
    GamePlayButten(int x, int y, PImage game_play){
        super(x, y, game_play);
    }
    void update(){
        display();
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