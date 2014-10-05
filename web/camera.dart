part of engine;

class Camera {
	Matrix4 projectMatrix, viewMatrix, cameraMatrix, cameraRotationMatrix;
	double x = 0.0, y = 0.0, z = 0.0;
	double pitch = 0.0, yaw = 0.0, roll = 0.0;

	Camera(num x, num y, num z) {
		projectMatrix = makePerspectiveMatrix(70.0 * PI/180, SCREEN_W / SCREEN_H, 0.001, 10);

		viewMatrix = new Matrix4.identity();
		double scale = 2.0 / SCREEN_H;
		viewMatrix.scale(scale, -scale, scale);

		cameraMatrix = new Matrix4.identity();
		cameraRotationMatrix = new Matrix4.identity();
	}

	void apply(GL.UniformLocation projectMatrixLocation, GL.UniformLocation viewMatrixLocation) {
		gl.uniformMatrix4fv(projectMatrixLocation, false, (projectMatrix * cameraRotationMatrix).storage);
		gl.uniformMatrix4fv(viewMatrixLocation, false, (viewMatrix * cameraMatrix).storage);
	}

	void moveForward(num d) {
		x += sin(radians(yaw)) * d;
		z += cos(radians(yaw)) * d;
	}

	void moveBackward(num d) {
		x -= sin(radians(yaw)) * d;
		z -= cos(radians(yaw)) * d;
	}

	void moveLeft(num d) {
		x += sin(radians(yaw + 90)) * d;
		z += cos(radians(yaw + 90)) * d;
	}

	void moveRight(num d) {
		x -= sin(radians(yaw + 90)) * d;
		z -= cos(radians(yaw + 90)) * d;
	}

	void rotateY(num theta) {
		yaw += theta;
	}

	void rotateX(num theta) {
		pitch += theta;
	}

	void update() {
		cameraRotationMatrix.setIdentity();
		cameraRotationMatrix.rotateX(pitch * PI/180);
		cameraRotationMatrix.rotateY(yaw * PI/180);

		cameraMatrix.setIdentity();
//		cameraMatrix.setTranslation(new Vector3(0.0, 30 * (4 + cos(tick * 0.01)), 0.0));
		cameraMatrix.translate(x, y + 30, z);

//		moveForward(0.1);
//		rotateY(-0.2);

		bool key_w = keyboard.isDown(87);
		bool key_a = keyboard.isDown(65);
		bool key_s = keyboard.isDown(83);
		bool key_d = keyboard.isDown(68);

		num speed = 4.0;

		if (key_w) moveForward(speed);
		else if (key_s) moveBackward(speed);

		if (key_a) moveLeft(speed);
		else if (key_d) moveRight(speed);

		if (keyboard.isDown(37)) rotateY(2.0);
		else if (keyboard.isDown(39)) rotateY(-2.0);
		if (keyboard.isDown(38)) rotateX(-1.0);
		else if (keyboard.isDown(40)) rotateX(1.0);

	}

	void render() {

	}
}