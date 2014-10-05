part of engine;

class Keyboard {

	List<bool> keysPressed = new List<bool>(625);
	List<bool> keysDown = new List<bool>(625);

	Keyboard() {
		keysPressed.fillRange(0, 625, false);
		keysDown.fillRange(0, 625, false);

		window.onKeyDown.listen(onKeyDown);
		window.onKeyUp.listen(onKeyUp);
	}

	void onKeyDown(KeyboardEvent e) {
		print(e.keyCode);

		if (e.keyCode < keysDown.length) {
			if (!keysDown[e.keyCode]) {
				keysPressed[e.keyCode] = true;
				keysDown[e.keyCode] = true;
			}
		}
	}

	void onKeyUp(KeyboardEvent e) {
		if (e.keyCode < keysDown.length)
			keysDown[e.keyCode] = false;
	}

	void update() {
		keysPressed.fillRange(0, keysPressed.length, false);
	}

	bool isDown(int key) => keysDown[key];

	bool isPressed(int key) => keysPressed[key];


}