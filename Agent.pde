class Agent {
    Car car = new Car(new PVector(100, 100), 0.0);
    NeuralNetwork neuralNetwork = new NeuralNetwork();

    Agent() {
        
    }

    void update(float dt) {
        // Descision making using neural network
        neuralNetwork.firstLayer.values[0] = 0.0; // x speed
        neuralNetwork.firstLayer.values[1] = 0.0; // y speed
        neuralNetwork.firstLayer.values[2] = 0.0; // turning

        neuralNetwork.firstLayer.values[3] = 20.0; // distance 1
        neuralNetwork.firstLayer.values[4] = 40.0; // distance 2
        neuralNetwork.firstLayer.values[5] = 20.0; // distance 3

        float[] output = neuralNetwork.compute();

        car.enginePower = constrain(output[0], 0, 60000);
        car.frontAngle = constrain(output[1]/100, -PI/4, PI/4);
        println(car.enginePower, car.frontAngle);

        // Physics computation
        car.update(dt);
    }

    void draw() {
        car.draw();
    }

}
