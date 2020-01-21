Car car;

void setup() {
    size(600, 400);

    car = new Car(new PVector(100, 100), 0.0);
    car.angularVelocity = 0.0;
}

void draw() {
    background(255);

    PVector force1 = car.relativeToWord(new PVector(50, 0));
    PVector offset1 = car.relativeToWord(new PVector(25, 15));
    line(offset1.x+car.position.x, offset1.y+car.position.y, offset1.x+car.position.x+force1.x, offset1.y+car.position.y+force1.y);

    PVector force2 = car.relativeToWord(new PVector(50, 0));
    PVector offset2 = car.relativeToWord(new PVector(25, -15));
    line(offset2.x+car.position.x, offset2.y+car.position.y, offset2.x+car.position.x+force2.x, offset2.y+car.position.y+force2.y);
    
    car.addForce(force1, offset1);
    car.addForce(force2, offset2);

    car.update(1.0/60);


    // Draw
    car.draw();
}
