part of engine;

class SpritePool {
	static const int FLOATS_PER_VERTEX = 8;
	static const int BYTES_PER_FLOAT = 4;
	static const int VERTICES_PER_SPRITE = 4;
	static const int MAX_VERTICES = 65536;
	static const int MAX_SPRITES = MAX_VERTICES ~/ VERTICES_PER_SPRITE;

	List<Sprite> sprites = [MAX_SPRITES];

	Shader shader;
	GL.Buffer vertexBuffer, indexBuffer;
	int posLocation, offsLocation, uvLocation, rgbLocation;
	GL.UniformLocation projectMatrixLocation, viewMatrixLocation, modelMatrixLocation, billboardMatrixLocation, fogColorLocation;

	SpritePool(this.shader) {
		// locations
		shader.use();

		posLocation = gl.getAttribLocation(shader.program, 'a_pos');
		uvLocation = gl.getAttribLocation(shader.program, 'a_uv');
		rgbLocation = gl.getAttribLocation(shader.program, 'a_col');

		projectMatrixLocation = gl.getUniformLocation(shader.program, 'u_projectMatrix');
		billboardMatrixLocation = gl.getUniformLocation(shader.program, 'u_billboardMatrix');
		viewMatrixLocation = gl.getUniformLocation(shader.program, 'u_viewMatrix');
		modelMatrixLocation = gl.getUniformLocation(shader.program, 'u_modelMatrix');
		fogColorLocation = gl.getUniformLocation(shader.program, 'u_fogColor');

		// vertex buffer
		vertexBuffer = gl.createBuffer();
		gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		gl.bufferDataTyped(GL.ARRAY_BUFFER, new Float32List(MAX_VERTICES * FLOATS_PER_VERTEX), GL.DYNAMIC_DRAW);

		// index buffer
		indexBuffer = gl.createBuffer();
        Int16List indices = new Int16List(MAX_SPRITES * FLOATS_PER_VERTEX);
		for (int i = 0; i < MAX_SPRITES; i++) {
			int off = i * VERTICES_PER_SPRITE;
			indices.setAll(i * 6, [
				off + 0, off + 1, off + 2,
				off + 0, off + 2, off + 3
			]);
		}
        gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
        gl.bufferDataTyped(GL.ELEMENT_ARRAY_BUFFER, indices, GL.STATIC_DRAW);
	}

	void addSprite(Sprite sprite) {
		int index = sprite.index = sprites.length;

		if (index < MAX_SPRITES) {
			int offset = index * FLOATS_PER_VERTEX * VERTICES_PER_SPRITE;
			gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
			gl.bufferSubDataTyped(GL.ARRAY_BUFFER, offset * BYTES_PER_FLOAT, sprite.vertices);
		}

		sprites.add(sprite);
	}

	void render() {
		shader.use();
		gl.bindTexture(GL.TEXTURE_2D, Textures.tt2.tex);

		gl.uniform3fv(fogColorLocation, fogColor.storage);
		camera.apply(projectMatrixLocation, viewMatrixLocation);

		Matrix4 billboardMatrix = new Matrix4.identity();
		//billboardMatrix.translate(-0.5, -0.5);
		billboardMatrix.rotateY(camera.yaw * PI/180);
		//billboardMatrix.translate(0.5, 0.5);
		gl.uniformMatrix4fv(billboardMatrixLocation, false, billboardMatrix.storage);

		gl.enableVertexAttribArray(posLocation);
		gl.enableVertexAttribArray(uvLocation);
		gl.enableVertexAttribArray(rgbLocation);
		gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		gl.vertexAttribPointer(posLocation, 3, GL.FLOAT, false, FLOATS_PER_VERTEX * BYTES_PER_FLOAT, 0);
		gl.vertexAttribPointer(uvLocation, 2, GL.FLOAT, false, FLOATS_PER_VERTEX * BYTES_PER_FLOAT, 3 * BYTES_PER_FLOAT);
		gl.vertexAttribPointer(rgbLocation, 3, GL.FLOAT, false, FLOATS_PER_VERTEX * BYTES_PER_FLOAT, 5 * BYTES_PER_FLOAT);

		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.drawElements(GL.TRIANGLES, sprites.length * 6, GL.UNSIGNED_SHORT, 0);
	}
}

class Sprite {

	double x, y, z;
	double xo, yo;
	double w, h;
	double u,v;
	double r, g, b;
	int index;

	Float32List vertices;
	Matrix4 modelMatrix;

	Sprite(this.x, this.y, this.z, this.w, this.h, this.u, this.v, this.r, this.g, this.b) {
		modelMatrix = new Matrix4.identity();
		vertices = new Float32List.fromList([
			0.0, 0.0, 0.0, u+0-0.5, v+h-0.5, r, g, b,
			0.0, 1.0, 0.0, u+w+0.5, v+h-0.5, r, g, b,
			1.0, 1.0, 0.0, u+w+0.5, v+0+0.5, r, g, b,
			1.0, 0.0, 0.0, u+0-0.5, v+0+0.5, r, g, b,
		]);

		updateVertices();
	}

	void updateModelMatrix() {
		modelMatrix.setIdentity();
		modelMatrix.translate(x - w / 2.0, y - h, z);
		modelMatrix.scale(w, h, w);

		modelMatrix.translate(0.5, 0.5);
		modelMatrix.rotateY(-camera.yaw * PI/180);
		modelMatrix.translate(-0.5, -0.5);
	}

	void updateVertices() {
		updateModelMatrix();

		Vector3 v1 = new Vector3(0.0, 0.0, 0.0);
		Vector3 v2 = new Vector3(0.0, 1.0, 0.0);
		Vector3 v3 = new Vector3(1.0, 1.0, 0.0);
		Vector3 v4 = new Vector3(1.0, 0.0, 0.0);

		v1 = modelMatrix * v1;
		v2 = modelMatrix * v2;
		v3 = modelMatrix * v3;
		v4 = modelMatrix * v4;

		vertices.setAll(0 * SpritePool.FLOATS_PER_VERTEX, [v1.x, v1.y, v1.z]);
		vertices.setAll(1 * SpritePool.FLOATS_PER_VERTEX, [v2.x, v2.y, v2.z]);
		vertices.setAll(2 * SpritePool.FLOATS_PER_VERTEX, [v3.x, v3.y, v3.z]);
		vertices.setAll(3 * SpritePool.FLOATS_PER_VERTEX, [v4.x, v4.y, v4.z]);
	}

}