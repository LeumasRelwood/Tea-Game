shader_type canvas_item;

uniform float offset = 0;
uniform float speed = 0;

void vertex() {
	VERTEX.x += cos(TIME + offset * 0.4) * (VERTEX.y - 450.0) * speed;
}