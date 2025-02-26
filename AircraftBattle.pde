import processing.sound.*; // 需要安装sound库
// Sounds
SoundFile main_music;
SoundFile shoot_sound;
SoundFile explosion_sound;
SoundFile game_over_sound;
SoundFile airplane_sound;

int HERO_SPEED = 5;
int ENEMY_SPEED = 3;
int BULLET_SPEED = 8;

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
    ArrayList<Bullet> bullets = new ArrayList<Bullet>();

    boolean isGameStarted = false;
    boolean isGameOver = false;
    int localFrameCount = 0;

    GameManager() {}

    void start() {
        ink_font = createFont("Ink Free", 48);
        // Load Images
        background = loadImage("Images/background.png");
        game_play = loadImage("Images/game_play.png");
        game_again = loadImage("Images/game_again.png");
        game_continue = loadImage("Images/game_continue.png");
        game_over = loadImage("Images/game_over.png");
        game_pause_nor = loadImage("Images/game_pause_nor.png");
        game_pause_pressed = loadImage("Images/game_pause_pressed.png");
        game_resume_nor = loadImage("Images/game_resume_nor.png");
        game_resume_pressed = loadImage("Images/game_resume_pressed.png");
        bullet1 = loadImage("Sprites/bullet/fly/bullet1.png");
        bullet2 = loadImage("Sprites/bullet/fly/bullet2.png");
        enemy1 = loadImage("Sprites/enemy1/fly/enemy1.png");
        enemy1_down1 = loadImage("Sprites/enemy1/down/enemy1_down1.png");
        enemy1_down2 = loadImage("Sprites/enemy1/down/enemy1_down2.png");
        enemy1_down3 = loadImage("Sprites/enemy1/down/enemy1_down3.png");
        enemy1_down4 = loadImage("Sprites/enemy1/down/enemy1_down4.png");
        hero1 = loadImage("Sprites/hero/fly/hero1.png");
        hero2 = loadImage("Sprites/hero/fly/hero2.png");
        hero_blowup_n1 = loadImage("Sprites/hero/down/hero_blowup_n1.png");
        hero_blowup_n2 = loadImage("Sprites/hero/down/hero_blowup_n2.png");
        hero_blowup_n3 = loadImage("Sprites/hero/down/hero_blowup_n3.png");
        hero_blowup_n4 = loadImage("Sprites/hero/down/hero_blowup_n4.png");


        // Initialize Hero
        hero = new Hero(width / 2, 700, hero1, hero2, bullet1, bullet2);
    }
    void update() {
        if (!isGameStarted) {
            showStartScreen();
            return;
        }

        if (isGameOver) {
            showGameOver();
            return;
        }
        
        localFrameCount++;
        imageMode(CENTER);
        imageMode(CENTER);
        image(background, width / 2, height / 2);

        hero.update();
        for (int i = enemies.size() - 1; i >= 0; i--) {
            Enemy enemy = enemies.get(i);
            enemy.update();
            if (enemy.isDestroyed()) {
                enemies.remove(i);
            }
        }

        for (int i = bullets.size() - 1; i >= 0; i--) {
            Bullet bullet = bullets.get(i);
            bullet.update();
            checkBulletCollision(bullet);
        }

        spawnNewEnemies();
        showScore();
    }

    void checkBulletCollision(Bullet bullet) {
        for (Enemy enemy : enemies) {
            if (!enemy.isDestroyed() && dist(bullet.x, bullet.y, enemy.x, enemy.y) < 30) {
                enemy.destroy();
                bullets.remove(bullet);
                explosion_sound.play();
                break;
            }
        }
    }

    void spawnNewEnemies() {
        // Decrease the spawn interval over time, but cap it at a minimum value
        int spawnInterval = max(20, 60 - localFrameCount / 100);
        if (localFrameCount % spawnInterval == 0) {
            enemies.add(new Enemy(int(random(50, width - 50)), 0, enemy1, enemy1_down1, enemy1_down2, enemy1_down3, enemy1_down4));
        }
    }

    void showStartScreen() {
        imageMode(CENTER);
        image(background, width / 2, height / 2);
        fill(0);
        textFont(ink_font);
        textAlign(CENTER, CENTER);
        text("Aircraft Battle", width / 2, height / 2 - 100);
        image(game_play, width / 2, height / 2);
        if (mousePressed && dist(mouseY, 0, height / 2, 0) < game_play.height / 2) {
            isGameStarted = true;
            hero.setState("play"); // Hero进入战斗状态
            main_music.stop();
            airplane_sound.play();
        }
    }

    void showGameOver() {
        imageMode(CENTER);
        image(game_again, width / 2, height / 2);
        image(game_over, width / 2, height / 2 + 100);
        fill(0);
        textFont(ink_font);
        if (mousePressed && dist(mouseY, 0, height / 2, 0) < game_again.height / 2) {
            isGameStarted = true;
            hero.setState("play");
            isGameOver = false;
            enemies.clear();
            hero.score = 0;
            hero.x = width / 2;
            hero.y = 700;
            bullets.clear();
            localFrameCount = 0;
            bullets.clear();
            airplane_sound.play();
            main_music.stop();
        }
        if (mousePressed && dist(mouseY, 0, height / 2 + 100, 0) < game_over.height / 2) {
            exit();
        }
    }

    void showScore() {
        fill(0);
        textFont(ink_font);
        textAlign(LEFT, TOP);
        text("Score: " + hero.score, 20, 20);
    }
}

abstract class ImageAgent {
    int x, y;
    PImage image;
    String state = "idle";

    ImageAgent(int x, int y, PImage image) {
        this.x = x;
        this.y = y;
        this.image = image;
    }

    void display() {
        imageMode(CENTER);
        image(image, x, y);
    }

    void setState(String state) {
        this.state = state;
    }
}

class Hero extends ImageAgent {
    PImage hero1;
    PImage hero2;
    PImage bullet1;
    PImage bullet2;
    CTimer flyTimer;
    int score = 0;

    Hero(int x, int y, PImage hero1, PImage hero2, PImage bullet1, PImage bullet2) {
        super(x, y, hero1);
        this.flyTimer = new CTimer(250);
        this.hero1 = hero1;
        this.hero2 = hero2;
        this.bullet1 = bullet1;
        this.bullet2 = bullet2;
    }

    void update() {
        if (state == "idle") {
            if (flyTimer.isFinished()) {
                image = (image == hero1) ? hero2 : hero1;
                flyTimer.start();
            }
        } else if (state == "play") {
            // Move to the mouse
            int dx = mouseX - x;
            int dy = mouseY - y;
            float d = sqrt(dx * dx + dy * dy);
            if (d > HERO_SPEED) {
                x += HERO_SPEED * dx / d;
                y += HERO_SPEED * dy / d;
            } else {
                x = mouseX;
                y = mouseY;
            }

            // Flame animation
            if (flyTimer.isFinished()) {
                image = (image == hero1) ? hero2 : hero1;
                flyTimer.start();
            }

            // Shoot
            if (mousePressed) {
                if (frameCount % 10 == 0) { // Shoot every 10 frames
                    gameManager.bullets.add(new Bullet(x, y, bullet1));
                    shoot_sound.play();
                }
            }
        }
        display();
    }
}

class Enemy extends ImageAgent {
    PImage enemy1;
    PImage[] explosionFrames;
    CTimer explosionTimer;
    int currentFrame = 0;
    boolean destroyed = false;

    Enemy(int x, int y, PImage enemy1, PImage enemy1_down1, PImage enemy1_down2, PImage enemy1_down3, PImage enemy1_down4) {
        super(x, y, enemy1);
        this.enemy1 = enemy1;
        this.explosionFrames = new PImage[]{enemy1_down1, enemy1_down2, enemy1_down3, enemy1_down4};
        this.explosionTimer = new CTimer(100);
    }

    void update() {
        if (!destroyed) {
            y += ENEMY_SPEED;
            if (y > height) {
                gameManager.isGameOver = true;
                game_over_sound.play();
                airplane_sound.stop();
            }
        } else {
            if (explosionTimer.isFinished()) {
                currentFrame++;
                if (currentFrame < explosionFrames.length) {
                    image = explosionFrames[currentFrame];
                    explosionTimer.start();
                }
            }
        }
        display();
    }

    void destroy() {
        destroyed = true;
        image = explosionFrames[0];
        explosionTimer.start();
        gameManager.hero.score += 10;
    }

    boolean isDestroyed() {
        return destroyed && currentFrame >= explosionFrames.length;
    }
}

class Bullet extends ImageAgent {
    Bullet(int x, int y, PImage image) {
        super(x, y, image);
    }

    void update() {
        y -= BULLET_SPEED;
        if (y < -10) {
            gameManager.bullets.remove(this);
        }
        display();
    }

    boolean isOutOfBounds() {
        return y < -10;
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
        int passedTime = millis() - savedTime;
        return passedTime > totalTime;
    }
}

GameManager gameManager = new GameManager();

void setup() {
    size(480, 852);
    gameManager.start();
    // Load Sounds
    main_music = new SoundFile(this, "Sounds/main.mp3");
    shoot_sound = new SoundFile(this, "Sounds/shoot.mp3");
    explosion_sound = new SoundFile(this, "Sounds/boom.mp3");
    game_over_sound = new SoundFile(this, "Sounds/game_over.mp3");
    airplane_sound = new SoundFile(this, "Sounds/airplane.mp3");
    main_music.play();
}

void draw() {
    gameManager.update();
}