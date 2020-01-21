class NeuralNetwork {
    // car velocity local x and local y
    // turn direction
    // three distances in front of it

    // 2 hidden layers
    // 10 neurons per layer

    // engine power
    // steering angle

    FirstLayer firstLayer     = new FirstLayer(6);
    StandardLayer secondLayer = new StandardLayer(10, firstLayer);
    StandardLayer thirdLayer  = new StandardLayer(10, secondLayer);
    StandardLayer lastLayer   = new StandardLayer(2, thirdLayer);

    NeuralNetwork() {
        
    }

    float[] compute() {
        return lastLayer.compute();
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

    float[] compute() {
        return values;
    }

    int getSize() {
        return values.length;
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

    float compute(float[] inputs) {
        float sum = 0;
        for (int i = 0; i < size; i++) {
            sum += inputs[i]*weights[i]+biases[i];
        }

        return sum;
    }
}