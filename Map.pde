class Map {
    PImage image;
    PGraphics rendered; // prerender it for speedup

    float width;
    float height;

    Map(String filename, float width, float height) {
        image = loadImage(filename);
        this.width = width;
        this.height = height;

        rendered = createGraphics(1000, 800);

        rendered.beginDraw();
        rendered.scale(width/image.width/2, height/image.height/2);
        rendered.image(image, 0, 0);
        rendered.endDraw();
    }

    boolean pointOnRoad(float x, float y) {
        // return true if inside picture and white, otherwise returns false
        return image.get(
            (int)(x/width * image.width),
            (int)(y/height * image.height)
        ) == -1;
    }

    void draw() {
        image(rendered, 0, 0);
    }
}