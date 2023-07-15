shader_type canvas_item;

uniform float offset = 1;
uniform float speed = 0.05;

void vertex() {
	VERTEX.x += cos(TIME + offset * 0.4) * (VERTEX.y - 20.0) * speed;
}