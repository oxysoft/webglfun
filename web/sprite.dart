part of engine;

class SpritePool {
	static const int FLOATS_PER_VERTEX = 6;
	static const int BYTES_PER_FLOAT = 4;
	static const int VERTICES_PER_SPRITE = 4;
	static const int MAX_VERTICES = 65536;
	static const int MAX_SPRITES = MAX_VERTICES ~/ VERTICES_PER_SPRITE;

	List<Sprite> sprites = [MAX_SPRITES];

	Shader shader;
	GL.Buffer vertexBuffer, indexBuffer;
	int posLocation, rgbLocation;
	GL.UniformLocation projectMatrixLocation, viewMatrixLocation, modelMatrixLocation;

	SpritePool(this.shader) {
		// locations
		shader.use();
		posLocation = gl.getAttribLocation(shader.program, 'a_pos');
		rgbLocation = gl.getAttribLocation(shader.program, 'a_col');

		vertexBuffer = gl.createBuffer();
		gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		gl.bufferDataTyped(GL.ARRAY_BUFFER, new Float32List(MAX_VERTICES * FLOATS_PER_VERTEX), GL.DYNAMIC_DRAW);

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

        shader.use();
		posLocation = gl.getAttribLocation(shader.program, 'a_pos');
		//offsLocation = gl.getAttribLocation(shader.program, 'a_offs');
		rgbLocation = gl.getAttribLocation(shader.program, 'a_col');
        projectMatrixLocation = gl.getUniformLocation(shader.program, 'u_projectMatrix');
        viewMatrixLocation = gl.getUniformLocation(shader.program, 'u_viewMatrix');
        modelMatrixLocation = gl.getUniformLocation(shader.program, 'u_modelMatrix');
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

		camera.apply(projectMatrixLocation, viewMatrixLocation, modelMatrixLocation);

		gl.enableVertexAttribArray(posLocation);
		//gl.enableVertexAttribArray(offsLocation);
		gl.enableVertexAttribArray(rgbLocation);
		gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		gl.vertexAttribPointer(posLocation, 3, GL.FLOAT, false, FLOATS_PER_VERTEX * BYTES_PER_FLOAT, 0 * BYTES_PER_FLOAT);
		gl.vertexAttribPointer(rgbLocation, 3, GL.FLOAT, false, FLOATS_PER_VERTEX * BYTES_PER_FLOAT, 3 * BYTES_PER_FLOAT);

		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.drawElements(GL.TRIANGLES, sprites.length * 6, GL.UNSIGNED_SHORT, 0);
	}
}

class Sprite {

	double x, y, z;
	double xo, yo;
	double r, g, b;
	double w, h;
	double u, v;
	int index;

	Float32List vertices;

	Sprite(this.x, this.y, this.z, this.w, this.h, this.r, this.g, this.b) {
		vertices = new Float32List.fromList([
			x + 0, y + 0, z, rand.nextDouble(), rand.nextDouble(), rand.nextDouble(),
			x + w, y + 0, z, rand.nextDouble(), rand.nextDouble(), rand.nextDouble(),
			x + w, y + h, z, rand.nextDouble(), rand.nextDouble(), rand.nextDouble(),
			x + 0, y + h, z, rand.nextDouble(), rand.nextDouble(), rand.nextDouble(),
		]);

	}

}