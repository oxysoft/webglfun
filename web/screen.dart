part of engine;

class Screen {
	Shader shader;
	SpritePool sprites;
	SpritePool groundPool;
	Quad quad;

	Screen(this.shader) {
		quad = new Quad(shader);
		sprites = new SpritePool(Shaders.spriteInstancing, Textures.tt2);
		groundPool = new SpritePool(Shaders.spriteInstancing, Textures.grassbotch);

		for (int i = 0; i < 5000; i++) {
			double x = rand.nextDouble() * 300 - 150;
    		double y = 24.0;
    		double z = rand.nextDouble() * 300 - 150;
    		double r = rand.nextDouble() * 0.6 + 0.4;
    		double g = rand.nextDouble() * 0.6 + 0.4;
    		double b = rand.nextDouble() * 0.8 + 0.4;
//    		sprites.addSprite(new Sprite(x, y, z, 32.0, 32.0, 0.0, 0.0, r, g, b));
		}
//		groundPool.addSprite(new Sprite(i * 32.0 + rand.nextDouble()*30, 0.0, j * 16.0 + rand.nextDouble()*4, 32.0, 16.0, 0.0, 0.0, 1.0, 1.0, 1.0));
		for (int i = -4; i <= 4; i++) {
			for (int j = -4; j <= 4; j++) {
				for (int k = 0; k < 20; k++) {
					groundPool.addSprite(new Sprite(i * 32.0 + rand.nextDouble()*30, 12.0, j * 16.0 + rand.nextDouble()*30, 32.0, 16.0, 0.0, 0.0, 1.0, 1.0, 1.0));
				}
			}
		}
	}

	void render() {
		Vector3 color = new Vector3(1.0, 1.0, 1.0);


		Matrix4 floorMatrix = new Matrix4.identity();
		floorMatrix.rotateX(PI/2);
		for (int i = -4; i <= 4; i++) {
			for (int j = -4; j <= 4; j++) {
//				quad.render(Textures.grass2, new Vector3(i * 256.0, 256.0, j * 256.0), 256, 256, 0, 0, color, floorMatrix);
			}
		}


		screen.sprites.render();
		screen.groundPool.render();
	}

	void renderBillboard() {
	}

	void renderSprite() {
	}

}