Car car;

void setup() {
    size(600, 400);

    car = new Car(new PVector(100, 100), 0.0);
    // car.velocity.set(50, 0);
    // car.angularVelocity = 0.8;
    car.velocity.rotate(0.2);
    car.angle = 0.2;
    car.motorTorque = 100;
}

void draw() {
    background(255);
    float dt = 1.0/60;

    car.update(dt);

    // Draw
    car.draw();

    print("car speed: ");
    println(car.velocity.mag());
}
