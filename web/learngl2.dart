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

GL.RenderingContext gl;
const int SCREEN_W = 400;
const int SCREEN_H = 400;

Keyboard keyboard;
Camera camera;
Screen screen;
//SpritePool spritePool;
Random rand;
int tick = 0;
int fps = 0;

CanvasElement canvasElement;
DivElement fpsElement;

Vector3 fogColor = new Vector3(0.05, 0.11, 0.20);
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
	camera.update();
	keyboard.update();
}

void render() {
	fps++;
	tick++;
	gl.viewport(0, 0, SCREEN_W, SCREEN_H);
	gl.clearColor(fogColor.r, fogColor.g, fogColor.b, 1.0);
	gl.clear(GL.DEPTH_BUFFER_BIT | GL.COLOR_BUFFER_BIT);
	gl.enable(GL.DEPTH_TEST);

	camera.render();
	screen.render();
}
