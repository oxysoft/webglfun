part of engine;

abstract class Entity {
	Vector3 position, velocity;
	double yrot = 0.0;
	double radius = 0.0;

	Entity() {
		position = new Vector3(0.0, 0.0, 0.0);
		velocity = new Vector3(0.0, 0.0, 0.0);
	}

	void update();

	void render(Quad quad);

	void eject(Entity entity) {
		double combinedRadius = radius + entity.radius;
		Vector3 dist = position.xyz - entity.position.xyz;
		if (dist.length2 < combinedRadius * combinedRadius) {
			double length = dist.length;
			dist.normalize();
			entity.position.xyz -= dist * (combinedRadius-length);
		}
	}
}

class Tree extends Entity {
	Tree() : super() {
		radius = 35.0;
	}

	@override
	void render(Quad quad) {
		quad.renderBillboard(Textures.tree, position, 59, 78, 0, 0);
	}

	@override
	void update() {
	}
}