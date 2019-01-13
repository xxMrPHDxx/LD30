part of LD30;

class Shader {
  GL.Shader vertexShader, fragmentShader;
  GL.Program program;
  Shader(String vertexShaderSource,String fragmentShaderSource){
    vertexShader = createShader(vertexShaderSource,GL.WebGL.VERTEX_SHADER);
    fragmentShader = createShader(fragmentShaderSource,GL.WebGL.FRAGMENT_SHADER);
    program = createProgram(vertexShader,fragmentShader);
  }
  use(){
    gl.useProgram(program);
  }
  static GL.Shader createShader(String source,int type){
    GL.Shader shader = gl.createShader(type);
    gl.shaderSource(shader, source);
    gl.compileShader(shader);
    if(!gl.getShaderParameter(shader, GL.WebGL.COMPILE_STATUS))
      throw gl.getShaderInfoLog(shader);
    return shader;
  }
  static GL.Program createProgram(GL.Shader vertexShader,GL.Shader fragmentShader){
    GL.Program program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    if(!gl.getProgramParameter(program, GL.WebGL.LINK_STATUS))
      throw gl.getProgramInfoLog(program);
    return program;
  }
}

Shader testShader = new Shader(
/* Vertex Shader */"""
  precision highp float;
  
  attribute vec3 a_pos;
  attribute vec2 a_offs;
  attribute vec2 a_uv;
  attribute vec3 a_col;
  
  varying vec3 v_col;
  varying vec2 v_uv;
  
  uniform mat4 u_viewMatrix;
  
  void main(){
    v_col = a_col;
    v_uv = a_uv/256.0;
    gl_Position = u_viewMatrix*vec4(a_pos+vec3(a_offs,0.5), 1.0);
  }
""",/* Fragment Shader */ """
  precision highp float;
  
  varying vec2 v_uv;
  varying vec3 v_col;
  
  uniform sampler2D u_tex;
  
  void main(){
    gl_FragColor = texture2D(u_tex, v_uv)*vec4(v_col,1.0);
  }
""");
