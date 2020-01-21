class Car {
    // Internal values
    // Linear values
    PVector position;
    PVector velocity = new PVector(0,0);
    PVector forces = new PVector(0,0); // For each time interval that we compute, we will sum all the forces into this vector
    float mass = 100.0;

    // Angular values
    float angle;
    float angularVelocity = 0.0;
    float torques = 0.0; // Sum of all torques applied to car within a time interval
    float inertia = 28333.0;

    // Size
    float width = 30.0;
    float length = 50.0;

    Car(PVector position, float angle) {
        this.position = position;
        this.angle = angle;
    }

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

    PVector pointVelocity(PVector worldOffset) {
        PVector tangent = new PVector(-worldOffset.y, worldOffset.x);
        tangent.mult(angularVelocity);
        tangent.add(velocity);
        return tangent;
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
    // Used for calculations, direction can be set with setAngle()
    PVector forward = new PVector(0,0);
    PVector side = new PVector(0,0);

    float torques = 0.0; // summed N*m
    float speed = 0.0; // radians per second
    float inertia = 1.5;
    float radius = 0.5;

    // Relative attached position
    PVector position;

    Wheel(PVector position) {
        this.position = position;
        setAngle(0.0);
    }

    void setAngle(float angle) {
        forward.set(1,0);
        forward.rotate(angle);

        side.set(0, 1);
        side.rotate(angle);
    }

    PVector calculateForce(PVector groundSpeed, float normalForce, float dt) {
        // calculate speed of tire patch at ground
        PVector patchSpeed = PVector.mult(forward, -speed * radius);

        // get velocity difference between ground and patch
        PVector velDifference = PVector.add(groundSpeed, patchSpeed);
        println(groundSpeed.mag(), velDifference.mag());

        // The frition force has the magnitued of the normal force * friction coeffiction
        float frictionCoefficient;
        if (velDifference.mag() < 1) {
            frictionCoefficient = 1.0;
        } else {
            frictionCoefficient = 0.7;
        }

        // calculate friction force
        velDifference.setMag(normalForce * frictionCoefficient);
        PVector frictionForce = velDifference; 

        // project friction force difference onto forward and side vector
        PVector forwardForce = PVector.mult(forward, forward.dot(frictionForce)/forward.mag());
        PVector sideForce    = PVector.mult(side,    side.dot(frictionForce)/side.mag());

        // Calculate 
        PVector responseForce = PVector.mult(sideForce, -1);
        responseForce.add(PVector.mult(forwardForce, -0.5)); // change to -0.5

        //calculate torque on wheel
        torques = forwardForce.dot(forward) * 0.5 * radius;

        //integrate total torque into wheel
        speed += torques / inertia * dt;

        //clear our transmission torque accumulator
        torques = 0;

        //return force acting on body
        return responseForce;
    }
}