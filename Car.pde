class Car {
    // Internal values
    // Linear values
    PVector position;
    PVector velocity = new PVector(0,0);
    PVector forces = new PVector(0,0); // For each time interval that we compute, we will sum all the forces into this vector
    float mass = 10.0;

    // Angular values
    float angle;
    float angularVelocity = 0.0;
    float torques = 0.0; // Sum of all torques applied to car within a time interval
    float inertia = 100.0;

    // Size
    float width = 30.0;
    float length = 50.0;

    void addForce(PVector force, PVector offset) {
        forces.add(force);
        
        float cross = offset.x*force.y - offset.y*force.x;
        torques += cross;
    }

    PVector relativeToWord(PVector relative) {
        PVector world = relative.copy();
        world.rotate(angle);
        //world.add(position);
        return world;
    }

    // Player/agent controlled values
    float acceleration; // pixels per second²
    float drotation; // radians per second

    Car(PVector position, float angle) {
        this.position = position;
        this.angle = angle;
    }

    void update(float dt) { // dt is delta time, aka time since last frame
        // Compute forces
        addForce(new PVector(0, 1), new PVector(0, 0));

        // Integrate physics
        // Linear
        PVector acceleration = PVector.div(forces, mass);
        velocity.add(PVector.mult(acceleration, dt));
        position.add(PVector.mult(velocity, dt));
        forces.set(0,0); // Clear forces

        // Angular
        float angAcc = torques / inertia;
        angularVelocity += angAcc * dt;
        angle += angularVelocity * dt;
        torques = 0; // Clear torques
    }

    void draw() {
        pushMatrix();
        translate(position.x, position.y);
        rotate(angle);

        rect(-length/2, -width/2, length, width);

        popMatrix();
    }
}

class Wheel {

}