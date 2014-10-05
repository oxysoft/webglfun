part of engine;

class Screen {
	Shader shader;
	Quad quad;

	List<Vector3> points = [];

	Screen(this.shader) {
		quad = new Quad(shader);

		for (int i = 0; i < 600; i++) {
			double x = -256*4-128 + (rand.nextDouble() * 256 * 9);
			double y = 0.0;
			double z = -256*3 + (rand.nextDouble() * 256 * 7);

			points.add(new Vector3(x, y, z));
		}
	}

	void render() {
		Vector3 color = new Vector3(1.0, 1.0, 1.0);
//		for (int i = 0; i < 10; i++) {
//			quad.render(i * 2, 0, -3, 16, 16, 0, 0, color);
//		}

		Matrix4 matrix = new Matrix4.identity();
//		matrix.rotateY(tick * PI/180);

//		quad.renderBillboard(Textures.spritesheet, new Vector3(0.0, 0.0, 0.0), 59, 79, 0, 0, color, matrix);
//		quad.renderBillboard(Textures.spritesheet, new Vector3(0.0, 0.0, 0.001), 2, 96, 64, 0, color);

		Matrix4 floorMatrix = new Matrix4.identity();
		floorMatrix.rotateX(PI/2);
		for (int i = -4; i <= 4; i++) {
			for (int j = -4; j <= 4; j++) {
				quad.render(Textures.grass, new Vector3(i * 256.0, 256.0, j * 256.0), 256, 256, 0, 0, color, floorMatrix);
			}
		}
//		quad.renderBillboard(Textures.grass, new Vector3(0.0, 256.0, 0.0), 256, 256, 0, 0, color, floorMatrix);
//		quad.renderBillboard(Textures.grass, new Vector3(0.0, 256.0, 256.0), 256, 256, 0, 0, color, floorMatrix);

		points.forEach((e) {
			quad.renderBillboard(Textures.tree2, e, 32, 96, 0, 0, color);
		});
	}

	void renderBillboard() {
	}

	void renderSprite() {
	}

}