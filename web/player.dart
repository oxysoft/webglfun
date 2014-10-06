part of engine;

class Player extends Entity {
	Texture texture;

	Player() : super() {
		texture = Textures.player;
		radius = 4.0;
	}

	void moveForward(num d) {
		velocity.x += sin(radians(yrot)) * d;
		velocity.z += cos(radians(yrot)) * d;
	}

	void moveBackward(num d) {
		velocity.x -= sin(radians(yrot)) * d;
		velocity.z -= cos(radians(yrot)) * d;
	}

	void moveLeft(num d) {
		velocity.x += sin(radians(yrot + 90)) * d;
		velocity.z += cos(radians(yrot + 90)) * d;
	}

	void moveRight(num d) {
		velocity.x -= sin(radians(yrot + 90)) * d;
		velocity.z -= cos(radians(yrot + 90)) * d;
	}

	void rotate(num theta) {
		yrot += theta;
	}

	void update() {
		bool key_w = keyboard.isDown(87);
		bool key_a = keyboard.isDown(65);
		bool key_s = keyboard.isDown(83);
		bool key_d = keyboard.isDown(68);

		num speed = 1.0;

		if (key_w) moveForward(speed);
		else if (key_s) moveBackward(speed);

		if (key_a) moveLeft(speed);
		else if (key_d) moveRight(speed);

		if (keyboard.isDown(37)) rotate(2.0);
		else if (keyboard.isDown(39)) rotate(-2.0);

		if (keyboard.isPressed(32)) {
			if (velocity.y == 0.0)
				velocity.y = -6.0;
		}


		velocity.y += 0.2;
		velocity.xz *= 0.745;

		position.add(velocity);

//		velocity.y = min(9.5, velocity.y);

		if (position.y > 0.0) {
			position.y = 0.0;
			velocity.y = 0.0;
		}
	}

	void render(Quad quad) {
		Matrix4 matrix = new Matrix4.identity();

		matrix.translate(0.5, 0.5);
		matrix.rotateY(-yrot * PI/180);
		matrix.translate(-0.5, -0.5);

		quad.render(texture, position, 19, 30, 0, 0, null, matrix);
	}
}