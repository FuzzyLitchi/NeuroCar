Agent[] agents = new Agent[100];

void setup() {
    size(1000, 800);

    agents[0] = new Agent();
    for (int i = 1; i < 100; i++) {
        agents[i] = agents[0].makeChild();
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
