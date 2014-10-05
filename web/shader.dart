part of engine;

class Shaders {
//	static Shader sprite = new Shader(
//"""
//precision highp float;
//
//attribute vec3 a_pos;
//attribute vec2 a_offs;
//attribute vec3 a_col;
//
//uniform mat4 u_projectMatrix;
//uniform mat4 u_viewMatrix;
//uniform mat4 u_modelMatrix;
//
//varying vec3 v_col;
//
//void main() {
//	vec4 pp = u_modelMatrix * u_viewMatrix * vec4(a_pos, 1.0);
//	float br = 1.0 / dot(pp.xyz, pp.xyz);
//	v_col = a_col * vec3(br, br, br);
//	//v_col = a_col;
//	gl_Position = u_projectMatrix * pp;
//}
//
//""",
//"""
//precision highp float;
//
//varying vec3 v_col;
//
//void main() {
//	gl_FragColor = vec4(v_col, 1.0);
//}
//
//"""
//	);

static Shader sprite = new Shader(
"""
precision highp float;

attribute vec3 a_pos;

uniform mat4 u_projectMatrix;
uniform mat4 u_viewMatrix;
uniform mat4 u_objectMatrix;
uniform mat4 u_textureMatrix;

varying vec2 v_texcoord;
varying float v_dist;
varying vec4 v_pos;

void main() {
	v_texcoord = (u_textureMatrix * vec4(a_pos, 1.0)).xy;
	v_pos = vec4(u_projectMatrix * u_viewMatrix * vec4(a_pos, 1.0));
	vec4 pos = u_projectMatrix * u_viewMatrix * u_objectMatrix * vec4(a_pos, 1.0);
	v_dist = pos.z/2.0; // fade in the back
	gl_Position = pos;
}
""",
"""
precision highp float;

uniform sampler2D u_tex;
uniform vec3 u_col;
uniform vec3 u_fogColor;

varying vec2 v_texcoord;
varying float v_dist;
varying vec4 v_pos;

void main() {
	vec4 col = texture2D(u_tex, v_texcoord);
	
	if (col.a > 0.0) {
		float fog = 1.0 / (v_dist*4.0+1.0);
		fog = 2.0 * (fog * fog);
		fog = max(0.0, fog);
		fog = min(1.0, fog);
		gl_FragColor = vec4((col.xyz * u_col).xyz*fog+u_fogColor*(1.0 - fog), col.a);
	} else
		discard;
}

"""
	);
}

class Shader {
	GL.Program program;

	Shader(String vertexShaderSrc, String fragmentShaderSrc) {
		GL.Shader vertexShader = compile(vertexShaderSrc, GL.VERTEX_SHADER);
		GL.Shader fragmentShader = compile(fragmentShaderSrc, GL.FRAGMENT_SHADER);
		program = link(vertexShader, fragmentShader);
	}

	void use() {
		gl.useProgram(program);
	}

	GL.Program link(GL.Shader vertexShader, GL.Shader fragmentShader) {
		GL.Program program = gl.createProgram();
		gl.attachShader(program, vertexShader);
		gl.attachShader(program, fragmentShader);
		gl.linkProgram(program);

		if (!gl.getProgramParameter(program, GL.LINK_STATUS)) {
			throw gl.getProgramInfoLog(program);
		}

		return program;
	}

	GL.Shader compile(String src, int type) {
		GL.Shader shader = gl.createShader(type);
		gl.shaderSource(shader, src);
		gl.compileShader(shader);

		if (!gl.getShaderParameter(shader, GL.COMPILE_STATUS)) {
			throw gl.getShaderInfoLog(shader);
		}

		return shader;
	}
}