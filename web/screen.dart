part of engine;

class Screen {
	Shader shader;
	SpritePool sprites;
	Quad quad;

	Screen(this.shader) {
		quad = new Quad(shader);
		sprites = new SpritePool(Shaders.spriteInstancing);
		for (int i = 0; i < 20; i++) {
			double x = rand.nextDouble() * 300 - 150;
    		double y = rand.nextDouble() * 100 - 50;
    		double z = rand.nextDouble() * 300 - 150;
    		sprites.addSprite(new Sprite(x, y, z, 32.0, 32.0, 0.0, 0.0, 1.0, 1.0, 1.0));
		}
	}

	void render() {
		Vector3 color = new Vector3(1.0, 1.0, 1.0);

		screen.sprites.render();

		Matrix4 floorMatrix = new Matrix4.identity();
		floorMatrix.rotateX(PI/2);
		for (int i = -4; i <= 4; i++) {
			for (int j = -4; j <= 4; j++) {
				quad.render(Textures.grass2, new Vector3(i * 256.0, 256.0, j * 256.0), 256, 256, 0, 0, color, floorMatrix);
			}
		}


//		points.forEach((e) {
//			quad.renderBillboard(Textures.tree2, e, 32, 96, 0, 0, color);
//		});


	}

	void renderBillboard() {
	}

	void renderSprite() {
	}

}