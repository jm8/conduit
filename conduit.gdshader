shader_type spatial;
instance uniform float capture_progress;
//instance uniform vec3 capture_color;

//varying vec3 local_position;
//
//void vertex(){
//	local_position = VERTEX;
//} 

void fragment() {
	EMISSION = vec3(1.0, 0.0, 0.0);
	ALBEDO = vec3(capture_progress, 0.0, 0.0);
	//float t = (atan(local_position.z, local_position.x) + PI) / TAU;
	//if(t < capture_progress){
	//	EMISSION = vec3(0.0, 1.0, 0.0);
	//}else{
	//	EMISSION = vec3(t);
	//}
	
}
