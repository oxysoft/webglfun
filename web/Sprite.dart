part of engine;

class Sprite {
	Vector3 pos, rot;
	Matrix4 modelMatrix;
	bool billboard;

	Sprite(num x, num y, num z, [num rotx = 0, num roty = 0, num rotz = 0]) {
		this.pos = new Vector3(x, y, z);
		this.rot = new Vector3.identity();
	}

	void render(Quad quad) {
		quad.renderSprite(this);
	}
}