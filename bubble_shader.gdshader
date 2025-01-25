shader_type spatial;

uniform sampler2D noise_texture;
uniform sampler3D color_texture;
uniform float smoothness = 0.05;

float fresnel(vec3 normal, mat4 cam_matrix){
	vec3 view_dir = (cam_matrix * vec4(0.0, 0.0, 1.0, 0.0)).xyz;
	vec3 normal_world = (cam_matrix * vec4(normal,0.0)).xyz;

	float fresnel = dot(view_dir, normal_world);
	fresnel = clamp(abs(fresnel),0.0,1.0);
	return 1.0 - fresnel;
}

varying vec3 world_position;
void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
	float height = (texture(noise_texture, VERTEX.xz * smoothness+ vec2(TIME  * 0.05)).r/2.0) + 0.5;
	VERTEX += NORMAL * height;

}

void fragment() {

	ALBEDO =   texture(color_texture,world_position.xyz + vec3(TIME * 0.1 )).rgb;
	float fresnel = fresnel(NORMAL,PROJECTION_MATRIX);
	ALPHA = fresnel;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
