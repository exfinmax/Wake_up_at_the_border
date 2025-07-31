shader_type canvas_item;

instance uniform vec2 parent_scale = vec2(1,1);


void vertex() {
	VERTEX.x *= parent_scale.x;
	VERTEX.x *= parent_scale.y;
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
