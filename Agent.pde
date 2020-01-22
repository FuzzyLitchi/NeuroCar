class Agent implements Comparable<Agent> {
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

    void update(float dt, Map map) {
        // Descision making using neural network
        PVector relativeSpeed = car.worldToRelative(car.velocity);

        neuralNetwork.firstLayer.values[0] = relativeSpeed.x; // x speed
        neuralNetwork.firstLayer.values[1] = relativeSpeed.y; // y speed

        neuralNetwork.firstLayer.values[2] = car.distanceToNotRoad(-PI/4, map); // distance 1
        neuralNetwork.firstLayer.values[3] = car.distanceToNotRoad(0, map); // distance 2
        neuralNetwork.firstLayer.values[4] = car.distanceToNotRoad(PI/4, map); // distance 3

        float[] output = neuralNetwork.compute();

        car.enginePower = constrain(output[0], 0, 60000);
        car.frontAngle = constrain(output[1]/1000, -PI/4, PI/4);
        car.breaking = constrain(output[2]/1000, 0, 1);
        // println(car.enginePower, car.frontAngle);

        // Physics computation
        car.update(dt);

        // Fitness computation
        // moving around gives fitness
        float dist = car.velocity.mag() * dt;
        if (map.pointOnRoad(car.position.x, car.position.y)) {
            fitness += dist;
        } else {
            fitness -= fitness*pow(dt,1/5);
        }
    }

    void reset() {
        this.fitness = 0.0;
        this.car = new Car(new PVector(100, 100), 0.0);
    }

    Agent makeChild() {
        // Create child with same properties
        NeuralNetwork neuralNetwork = this.neuralNetwork.copy();
        float red = this.red;
        float green = this.green;
        float blue = this.blue;

        // Do mutation
        float v = random(0, 1);
        if (v < 0.2) {
            // Change color
            red = (red + (int) random(-20,20))%256;
            green = (green + (int) random(-20,20))%256;
            blue = (blue + (int) random(-20,20))%256;
        }
        neuralNetwork.mutate();

        return new Agent(neuralNetwork, red, green, blue);
    }

    void draw() {
        fill(red, green, blue, 100);
        car.draw();
    }

    @Override
    public int compareTo(Agent other) {
        float v = this.fitness - other.fitness;
        return v < 0 ? -1 : (v == 0 ? 0 : 1);
    }
}
