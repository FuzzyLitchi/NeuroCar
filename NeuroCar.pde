Agent agent = new Agent();

void setup() {
    size(600, 400);

    
}

void draw() {
    background(255);
    float dt = 1.0/60;

    agent.update(dt);

    // Draw
    pushMatrix();
    scale(0.5, 0.5);
    agent.draw();
    popMatrix();
}
