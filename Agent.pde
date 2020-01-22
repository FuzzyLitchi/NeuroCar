class Agent {
    Car car = new Car(new PVector(100, 100), 0.0);
    NeuralNetwork neuralNetwork;

    float fitness = 0.0;

    float red;
    float green;
    float blue;

    Agent() {
        neuralNetwork = new NeuralNetwork();

        red = random(0, 255);
        green = random(0, 255);
        blue = random(0, 255);
    }

    Agent(NeuralNetwork neuralNetwork, float red, float green, float blue) {
        this.neuralNetwork = neuralNetwork;
        this.red = red;
        this.green = green;
        this.blue = blue;
    }

    void update(float dt) {
        // Descision making using neural network
        PVector relativeSpeed = car.worldToRelative(car.velocity);

        neuralNetwork.firstLayer.values[0] = relativeSpeed.x; // x speed
        neuralNetwork.firstLayer.values[1] = relativeSpeed.y; // y speed

        neuralNetwork.firstLayer.values[2] = 20.0; // distance 1
        neuralNetwork.firstLayer.values[3] = 40.0; // distance 2
        neuralNetwork.firstLayer.values[4] = 20.0; // distance 3

        float[] output = neuralNetwork.compute();

        car.enginePower = constrain(output[0], 0, 60000);
        car.frontAngle = constrain(output[1]/100, -PI/4, PI/4);
        // println(car.enginePower, car.frontAngle);

        // Physics computation
        car.update(dt);

        // Fitness computation
        // moving around gives fitness
        fitness += car.velocity.mag() * dt;
    }

    void reset() {
        this.fitness = 0.0;
        this.car = new Car(new PVector(100, 100), 0.0);
    }

    Agent makeChild() {
        NeuralNetwork neuralNetwork = this.neuralNetwork.copy();
        float red = this.red;
        float green = this.green;
        float blue = this.blue;

        return new Agent(neuralNetwork, red, green, blue);
    }

    void draw() {
        fill(red, green, blue, 100);
        car.draw();
    }

}
