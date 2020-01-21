Car car;

void setup() {
    size(600, 400);

    car = new Car(new PVector(100, 100), 0.0);
}

void draw() {
    car.addForce(new PVector(0, 50), new PVector(1, 0));
    car.update(1.0/60);


    // Draw
    background(255);
    car.draw();
}
