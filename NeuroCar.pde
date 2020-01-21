Car car;
Wheel wheels[] = new Wheel[4];

void setup() {
    size(600, 400);

    car = new Car(new PVector(100, 100), 0.0);
    car.velocity.set(0.0, 15);
    // car.velocity.rotate(0.2);
    // car.angle = 0.2;

    wheels[0] = new Wheel(new PVector(25,15));
    wheels[1] = new Wheel(new PVector(25,-15));
    wheels[2] = new Wheel(new PVector(-25,15));
    wheels[3] = new Wheel(new PVector(-25,-15));
}

void draw() {
    background(255);
    float dt = 1.0/60;

    for (Wheel wheel : wheels) {
        wheel.setAngle(car.angle);
        PVector force = wheel.calculateForce(car.velocity, car.mass*9.82/4, dt);
        
        PVector offset = car.relativeToWord(wheel.position);
        car.addForce(force, offset);
        line(offset.x+car.position.x, offset.y+car.position.y, offset.x+car.position.x+force.x, offset.y+car.position.y+force.y);
    }

    car.update(dt);

    // Draw
    car.draw();
    print("magnitude: ");
    println(car.velocity.mag());
}
