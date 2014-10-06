part of engine;

class Quad {
	Shader shader;
	int posLocation, texCoordLocation;
	GL.Buffer indexBuffer, vertexBuffer;
	GL.UniformLocation objectMatrixLocation, projectMatrixLocation, viewMatrixLocation, colorLocation, fogColorLocation, textureMatrixLocation;
	Matrix4 objectMatrix = new Matrix4.identity();
	Matrix4 objectRotationMatrix = new Matrix4.identity();
	Matrix4 textureMatrix = new Matrix4.identity();

	Quad(this.shader) {
		shader.use();

		posLocation = gl.getAttribLocation(shader.program, 'a_pos');
		texCoordLocation = gl.getAttribLocation(shader.program, 'a_texCoord');
		objectMatrixLocation = gl.getUniformLocation(shader.program, 'u_objectMatrix');
		projectMatrixLocation = gl.getUniformLocation(shader.program, 'u_projectMatrix');
		viewMatrixLocation = gl.getUniformLocation(shader.program, 'u_viewMatrix');
		textureMatrixLocation = gl.getUniformLocation(shader.program, 'u_textureMatrix');
		colorLocation = gl.getUniformLocation(shader.program, 'u_col');
		fogColorLocation = gl.getUniformLocation(shader.program, 'u_fogColor');
		gl.uniform3fv(fogColorLocation, fogColor.storage);

		Float32List vertexData = new Float32List.fromList([
			0.0, 0.0, 0.0,
			0.0, 1.0, 0.0,
			1.0, 1.0, 0.0,
			1.0, 0.0, 0.0,
		]);

		Int16List indexData = new Int16List.fromList([0, 1, 2, 0, 2, 3]);

		vertexBuffer = gl.createBuffer();
		gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		gl.enableVertexAttribArray(posLocation);
		gl.bufferDataTyped(GL.ARRAY_BUFFER, vertexData, GL.STATIC_DRAW);
		gl.vertexAttribPointer(posLocation, 3, GL.FLOAT, false, 0, 0);

		indexBuffer = gl.createBuffer();
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.bufferDataTyped(GL.ELEMENT_ARRAY_BUFFER, indexData, GL.STATIC_DRAW);
	}

	void applyCamera() {
		camera.apply(projectMatrixLocation, viewMatrixLocation);
	}

	void renderBillboard(Texture texture, Vector3 pos, int w, int h, int uo, int vo, [Vector3 color, Matrix4 transform]) {
		if (color == null) color = new Vector3(1.0, 1.0, 1.0);
		if (transform == null) transform = new Matrix4.identity();

		shader.use();

		applyCamera();

		int tw = texture.w;
		int th = texture.h;

		objectMatrix.setIdentity();
		objectMatrix.translate(pos.x - w / 2.0, pos.y - h * 1.0, pos.z);
		objectMatrix.scale(w * 1.0, h * 1.0, w * 1.0);
		objectMatrix *= transform;

		objectMatrix.translate(0.5, 0.5);
		objectMatrix.rotateY(-camera.yaw * PI/180);
		objectMatrix.translate(-0.5, -0.5);

//		objectMatrix.translate(0.0, 0.5);
//		objectMatrix.rotateX(camera.pitch * PI/180);
//		objectMatrix.translate(0.0, -0.5);

		gl.uniformMatrix4fv(objectMatrixLocation, false, objectMatrix.storage);

		textureMatrix.setIdentity();
		textureMatrix.scale(1.0 / tw, 1.0 / th, 1.0);
		textureMatrix.translate(uo + 0.25, vo + 0.25, 0.0);
		textureMatrix.scale(w - 0.5, h - 0.5, 1.0);
		gl.uniformMatrix4fv(textureMatrixLocation, false, textureMatrix.storage);

		gl.uniform3fv(colorLocation, color.storage);
		gl.bindTexture(GL.TEXTURE_2D, texture.tex);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.drawElements(GL.TRIANGLES, 6, GL.UNSIGNED_SHORT, 0);
	}

	void render(Texture texture, Vector3 pos, int w, int h, int uo, int vo, Vector3 color, [Matrix4 transform]) {
		if (color == null) color = new Vector3(1.0, 1.0, 1.0);
		if (transform == null) transform = new Matrix4.identity();

		shader.use();

		applyCamera();

		int tw = texture.w;
		int th = texture.h;

		objectMatrix.setIdentity();
		objectMatrix.translate(pos.x - w / 2.0, pos.y - h * 1.0, pos.z);
		objectMatrix.scale(w * 1.0, h * 1.0, w * 1.0);
		objectMatrix *= transform;

		gl.uniformMatrix4fv(objectMatrixLocation, false, objectMatrix.storage);

		textureMatrix.setIdentity();
		textureMatrix.scale(1.0 / tw, 1.0 / th, 1.0);
		textureMatrix.translate(uo + 0.25, vo + 0.25, 0.0);
		textureMatrix.scale(w - 0.5, h - 0.5, 1.0);
		gl.uniformMatrix4fv(textureMatrixLocation, false, textureMatrix.storage);

		gl.uniform3fv(colorLocation, color.storage);

		gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		gl.vertexAttribPointer(posLocation, 3, GL.FLOAT, false, 0, 0);

		gl.bindTexture(GL.TEXTURE_2D, texture.tex);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.drawElements(GL.TRIANGLES, 6, GL.UNSIGNED_SHORT, 0);
	}
}