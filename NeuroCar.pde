Car car;

void setup() {
    size(600, 400);

    car = new Car(new PVector(100, 100), 0.0);
    // car.velocity.set(50, 0);
    // car.angularVelocity = 0.8;
    car.velocity.rotate(0.2);
    car.angle = 0.2;

    car.frontAngle = PI/6;
    car.enginePower = 10000;
}

void draw() {
    background(255);
    float dt = 1.0/60;

    car.update(dt);

    // Draw
    pushMatrix();
    scale(0.5, 0.5);
    car.draw();
    popMatrix();

    print("car speed: ");
    println(car.velocity.mag());
}
