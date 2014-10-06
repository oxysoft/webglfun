part of engine;

class Textures {

	static List<Texture> all = [];
	static Texture spritesheet;
	static Texture tree;
	static Texture tree2;
	static Texture player;
	static Texture beam;
	static Texture grass;
	static Texture grass2;
	static Texture tt2;

	static void loadAll() {
		spritesheet = new Texture('res/gfx/spritesheet.png');
		tree = new Texture('res/gfx/tree.png');
		tree2 = new Texture('res/gfx/tree2.png');
		player = new Texture('res/gfx/player.png');
		beam = new Texture('res/gfx/beam.png');
		grass = new Texture('res/gfx/grass.png');
		grass2 = new Texture('res/gfx/grass2.png');
		tt2 = new Texture('res/gfx/tt2.png');

		all.forEach((e) => e.load());
	}
}

class Texture {
	String url;
	ImageElement img;
	GL.Texture tex;

	int get w => img.width;
	int get h => img.height;

	Texture(this.url) {
		Textures.all.add(this);
	}

	void load() {
		img = new ImageElement();
		img.src = url;
		img.onLoad.listen((e) {
			tex = gl.createTexture();
			gl.bindTexture(GL.TEXTURE_2D, tex);
			gl.texImage2DImage(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, img);
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
		}).onError((e) {
			print("Error loading texture: " + e);
		});
	}
}