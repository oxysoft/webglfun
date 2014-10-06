library engine;

import 'dart:html';

import 'dart:math';
import 'dart:typed_data';
import 'dart:web_gl' as GL;
import 'package:vector_math/vector_math.dart';

part 'shader.dart';
part 'screen.dart';
part 'camera.dart';
part 'quad.dart';
part 'texture.dart';
part 'inputs.dart';
part 'sprite.dart';

part 'entities.dart';
part 'player.dart';

GL.RenderingContext gl;
const int SCREEN_W = 400;
const int SCREEN_H = 400;

Keyboard keyboard;
Camera camera;
Screen screen;
Random rand;

List<Entity> entities;
Player player;

int tick = 0;
int fps = 0;

CanvasElement canvasElement;
DivElement fpsElement;

Vector3 fogColor = new Vector3(0.7, 0.75, 0.8);
//Vector3 fogColor = new Vector3(0.0, 0.0, 0.0);

void main() {
	canvasElement = querySelector('#game');
	canvasElement.setAttribute('width', '$SCREEN_W');
	canvasElement.setAttribute('height', '$SCREEN_H');

	fpsElement = querySelector('#fps');

	gl = canvasElement.getContext('webgl');

	if (gl == null) gl = canvasElement.getContext('experimental-webgl');
	if (gl == null) {
		showNoWebglError(); //nigga, that's sad
	} else start();
}

void showNoWebglError() {
	fpsElement.innerHtml = 'Sorry, but your graphics card or browser may not support webgl.';
}

void start() {
	Textures.loadAll();
	keyboard = new Keyboard();
	rand = new Random();
	camera = new Camera(0.0, 0.0, 0.0);
	screen = new Screen(Shaders.sprite);

	entities = new List<Entity>();
	for (int i = 0; i < 40; i++) {
		for (int j = 0; j < 4; j++) {
			if ((i == 20 || i == 21) && j == 2)
				continue;
			Tree tree = new Tree();
    		double x = cos(i) * 140;
    		double y = j * -60.0;
    		double z = sin(i) * 140;
    		tree.position.setValues(x, y, z);
//    		entities.add(tree);
		}
	}

	player = new Player();
	camera.player = player;

	gl.viewport(0, 0, SCREEN_W, SCREEN_H);
	gl.clearColor(fogColor.r, fogColor.g, fogColor.b, 1.0);
	gl.enable(GL.DEPTH_TEST);

	window.requestAnimationFrame(animate);
}

int lastTime = new DateTime.now().millisecondsSinceEpoch;
double unprocessedFrames = 0.0;
num elapsedTime = 0;

void animate(double time) {
	try {
		int now = new DateTime.now().millisecondsSinceEpoch;

		elapsedTime += now - lastTime;

		if (elapsedTime > 1000) {
			fpsElement.setInnerHtml('fps: $fps');
			elapsedTime = 0;
			fps = 0;
		}

		unprocessedFrames += (now - lastTime) * 60.0 / 1000.0;
		lastTime = now;
		if (unprocessedFrames > 10.0) unprocessedFrames = 10.0;
		while (unprocessedFrames > 1.0) {
			update();
			unprocessedFrames -= 1.0;
		}

		render();
		window.requestAnimationFrame(animate);
	} catch (e) {
		rethrow;
	}
}

void update() {
	player.update();
	for (Entity e in entities) {
		e.update();
		e.eject(player);
	}
	camera.update();
	keyboard.update();
}

void render() {
	fps++;
	tick++;
	gl.clear(GL.DEPTH_BUFFER_BIT | GL.COLOR_BUFFER_BIT);

	screen.render();
	player.render(screen.quad);
	for (Entity e in entities) {
		e.render(screen.quad);
	}
}
