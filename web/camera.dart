part of engine;

class Camera {
	Matrix4 projectMatrix, viewMatrix, cameraMatrix, cameraRotationMatrix;
	double x = 0.0,
			y = 0.0,
			z = 0.0;
	double pitch = 0.0,
			yaw = 0.0,
			roll = 0.0;
	Player player;

	Camera(num x, num y, num z) {
		projectMatrix = makePerspectiveMatrix(70.0 * PI / 180, SCREEN_W / SCREEN_H, 0.001, 10000);

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

	void lookAt(double px, double py, double pz) {
	}

	void update() {
		cameraRotationMatrix.setIdentity();
		cameraRotationMatrix.rotateX(pitch * PI / 180);
		cameraRotationMatrix.rotateY(yaw * PI / 180);

		cameraMatrix.setIdentity();
//		cameraMatrix.setTranslation(new Vector3(0.0, 60 * (0 + cos(tick * 0.02)), 1.0));
		cameraMatrix.translate(x, y + 30, z);

//		moveForward(0.1);
//		rotateY(-0.2);

		if (player != null) {
			double distance = 100.0;
			x = -(player.position.x + player.velocity.x) + sin(radians(player.yrot)) * 100;
			y = -(player.position.y * 0.8) + 30;
			z = -(player.position.z + player.velocity.z) + cos(radians(player.yrot)) * 100;
			pitch = 10.0 - player.position.y * 0.08;
			yaw = 180 + player.yrot;
		}
	}
}
