shader_type spatial;
instance uniform float capture_progress;
instance uniform vec3 capture_color;

void vertex(){
	
} 

void fragment() {
	vec4 world_space_position = FRAGCOORD * INV_VIEW_MATRIX;
}
