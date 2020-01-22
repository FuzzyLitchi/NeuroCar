Agent[] agents = new Agent[100];

void setup() {
    size(1000, 800);

    for (int i = 0; i < 100; i++) {
        agents[i] = new Agent();
    }
}

void draw() {
    background(255);
    float dt = 1.0/60;

    for (Agent agent : agents) {
        agent.update(dt);
    }

    // Draw
    pushMatrix();
    scale(0.5, 0.5);
    for (Agent agent : agents) {
        agent.draw();
    }
    popMatrix();
}
