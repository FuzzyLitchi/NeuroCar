import java.util.Collections;
import java.util.Arrays;

Agent[] agents = new Agent[100];
Map map;

void setup() {
    size(1000, 800);
    map = new Map("yeet.png", 1000, 800);

    for (int i = 0; i < 100; i++) {
        agents[i] = new Agent();
    }
}

// 60 second timer
float interval = 10.0;
float timer = interval;

void draw() {
    float dt = 1.0/60;

    // If we're out of time for this generation
    if (timer < 0) {
        // Sort
        Arrays.sort(agents, Collections.reverseOrder());
        
        // Kill bottom 50 and repopulate
        for (int i = 0; i < 50; ++i) {
            agents[i+50] = agents[i].makeChild();
            // reset parents
            agents[i].reset();
        }

        // Reset timer
        timer = interval;
    }

    timer -= dt;

    for (Agent agent : agents) {
        agent.update(dt, map);
    }

    // Draw
    background(255);
    map.draw();
    pushMatrix();
    scale(0.5, 0.5);
    for (Agent agent : agents) {
        agent.draw();
    }
    popMatrix();
}
