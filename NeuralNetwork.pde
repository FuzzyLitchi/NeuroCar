class NeuralNetwork {
    // car velocity local x and local y
    // three distances in front of it

    // 2 hidden layers
    // 10 neurons per layer

    // engine power
    // steering angle

    FirstLayer firstLayer;
    StandardLayer secondLayer;
    StandardLayer thirdLayer;
    StandardLayer lastLayer;

    NeuralNetwork() {
        firstLayer  = new FirstLayer(5);
        secondLayer = new StandardLayer(10, firstLayer);
        thirdLayer  = new StandardLayer(10, secondLayer);
        lastLayer   = new StandardLayer(2, thirdLayer);
    }

    NeuralNetwork(FirstLayer firstLayer, StandardLayer secondLayer, StandardLayer thirdLayer, StandardLayer lastLayer) {
        this.firstLayer = firstLayer;
        this.secondLayer = secondLayer;
        this.thirdLayer = thirdLayer;
        this.lastLayer = lastLayer;
    }

    float[] compute() {
        return lastLayer.compute();
    }

    NeuralNetwork copy() {
        FirstLayer firstLayer = this.firstLayer.copy();
        StandardLayer secondLayer = this.secondLayer.copy(firstLayer);
        StandardLayer thirdLayer  = this.thirdLayer.copy(secondLayer);
        StandardLayer lastLayer   = this.lastLayer.copy(thirdLayer);

        return new NeuralNetwork(firstLayer, secondLayer, thirdLayer, lastLayer);
    }

    void mutate() {
        // I have 22 neurons that have weights and biases
        int totalNeurons = secondLayer.getSize() + thirdLayer.getSize() + lastLayer.getSize();
        
        int amountToMutate = (int) random(0, 3);
        for (int i = 0; i < amountToMutate; i++) {
            // Choose neuron at random to receive mutation
            int chosen = (int)random(0, totalNeurons);

            // Find the layer the neuron is in;
            StandardLayer chosenLayer;
            if (chosen < secondLayer.getSize()) {
                chosenLayer = secondLayer;
            } else if (chosen < secondLayer.getSize() + thirdLayer.getSize()) {
                chosenLayer = thirdLayer;
                chosen -= secondLayer.getSize();
            } else {
                chosenLayer = lastLayer;
                chosen -= secondLayer.getSize() + thirdLayer.getSize();
            }

            chosenLayer.neurons[chosen].mutate();
        }
    }
}

abstract class Layer {
    abstract float[] compute();
    abstract int getSize();
}

class FirstLayer extends Layer {
    float[] values;

    FirstLayer(int size) {
        values = new float[size];
    }

    FirstLayer(float[] values) {
        this.values = values;
    }

    float[] compute() {
        return values;
    }

    int getSize() {
        return values.length;
    }

    FirstLayer copy() {
        return new FirstLayer(this.values.clone());
    }
}

class StandardLayer extends Layer {
    Neuron neurons[];

    Layer previous;

    StandardLayer(int size, Layer previous) {
        this.previous = previous;

        neurons = new Neuron[size];
        for (int i = 0; i < size; i++) {
            neurons[i] = new Neuron(previous.getSize());
        }
    }

    StandardLayer(Neuron[] neurons, Layer previous) {
        this.neurons = neurons;
        this.previous = previous;
    }

    float[] compute() {
        float[] previousValues = previous.compute();

        float[] values = new float[neurons.length];

        for (int i = 0; i < neurons.length; i++) {
            values[i] = neurons[i].compute(previousValues);
        }

        return values;
    }

    int getSize() {
        return neurons.length;
    }

    StandardLayer copy(Layer previous) {
        Neuron[] neuronsCopy = new Neuron[neurons.length];
        for (int i = 0; i < neurons.length; i++) {
            neuronsCopy[i] = neurons[i].copy();
        }

        return new StandardLayer(neuronsCopy, previous);
    }
}

class Neuron {
    // amount of neurons this neuron is dependent upon.
    int size;
    float weights[];
    float biases[];

    Neuron(int size) {
        this.size = size;

        weights = new float[size];
        for (int i = 0; i < size; i++) {
            weights[i] = random(-10, 10);
        }

        biases = new float[size];
        for (int i = 0; i < size; i++) {
            biases[i] = random(-10, 10);
        }
    }

    Neuron(int size, float[] weights, float biases[]) {
        this.size = size;
        this.weights = weights;
        this.biases = biases;
    }

    float compute(float[] inputs) {
        float sum = 0;
        for (int i = 0; i < size; i++) {
            sum += inputs[i]*weights[i]+biases[i];
        }

        return sum;
    }

    Neuron copy() {
        return new Neuron(this.size, this.weights.clone(), this.biases.clone());
    }

    void mutate() {
        float v = random(0, 1);

        if (v < 0.5) {
            weights[(int) random(0, size)] += random(-3, 3);
        } else {
            biases[(int) random(0, size)] += random(-3, 3);
        }
    }
}