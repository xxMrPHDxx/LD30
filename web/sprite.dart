part of LD30;

class Sprites {
  /*
  Vertex Data
  x,y,z       0 + 3
  x0,y0       3 + 2
  w,h         5 + 2
  r,g,b       7 + 3
                 10
   */

  static const int BYTES_PER_FLOAT = 4;

  static const int FLOATS_PER_VERTEX = 10;
  static const int MAX_VERTICES = 65536;
  static const int MAX_SPRITES = MAX_VERTICES~/4;

  List<Sprite> sprites = new List<Sprite>();
  Shader shader;
  GL.Texture texture;
  GL.Buffer vertexBuffer, indexBuffer;

  int posLocation, offsLocation, uvLocation, rgbLocation;
  GL.UniformLocation viewMatrixLocation;

  Sprites(this.shader, this.texture){
    vertexBuffer = gl.createBuffer();
    gl.bindBuffer(GL.WebGL.ARRAY_BUFFER,vertexBuffer);
    gl.bufferData(GL.WebGL.ARRAY_BUFFER,new Float32List(MAX_VERTICES*FLOATS_PER_VERTEX),GL.WebGL.DYNAMIC_DRAW);

    Int16List indexData = new Int16List(MAX_SPRITES*6);
    for(int i=0;i<MAX_SPRITES;i++){
      int offs = i*4;
      indexData.setAll(i*6, [offs+0,offs+1,offs+2,offs+0,offs+2,offs+3]);
    }
    indexBuffer = gl.createBuffer();
    gl.bindBuffer(GL.WebGL.ELEMENT_ARRAY_BUFFER,indexBuffer);
    gl.bufferData(GL.WebGL.ELEMENT_ARRAY_BUFFER,indexData,GL.WebGL.STATIC_DRAW);

    shader.use();
    posLocation = gl.getAttribLocation(testShader.program, "a_pos");
    offsLocation = gl.getAttribLocation(testShader.program, "a_offs");
    uvLocation = gl.getAttribLocation(testShader.program, "a_uv");
    rgbLocation = gl.getAttribLocation(testShader.program, "a_col");
    viewMatrixLocation = gl.getUniformLocation(testShader.program, "u_viewMatrix");
  }

  void addSprite(Sprite sprite){
    int index = sprite.index = sprites.length;
    if(index<MAX_SPRITES) {
      int offset = index*FLOATS_PER_VERTEX*BYTES_PER_FLOAT;
      gl.bufferSubData(GL.WebGL.ARRAY_BUFFER, offset*BYTES_PER_FLOAT, sprite.data);
    }
    sprites.add(sprite);
  }

  void render(){
    gl.bindTexture(GL.WebGL.TEXTURE_2D, texture);
    shader.use();

    gl.uniformMatrix4fv(viewMatrixLocation,false,viewMatrix.storage);

    gl.enableVertexAttribArray(posLocation);
    gl.enableVertexAttribArray(offsLocation);
    gl.enableVertexAttribArray(uvLocation);
    gl.enableVertexAttribArray(rgbLocation);
    gl.bindBuffer(GL.WebGL.ARRAY_BUFFER,vertexBuffer);
    gl.vertexAttribPointer(posLocation, 3, GL.WebGL.FLOAT, false, FLOATS_PER_VERTEX*BYTES_PER_FLOAT, 0*BYTES_PER_FLOAT);
    gl.vertexAttribPointer(offsLocation, 2, GL.WebGL.FLOAT, false, FLOATS_PER_VERTEX*BYTES_PER_FLOAT, 3*BYTES_PER_FLOAT);
    gl.vertexAttribPointer(uvLocation, 2, GL.WebGL.FLOAT, false, FLOATS_PER_VERTEX*BYTES_PER_FLOAT, 5*BYTES_PER_FLOAT);
    gl.vertexAttribPointer(rgbLocation, 3, GL.WebGL.FLOAT, false, FLOATS_PER_VERTEX*BYTES_PER_FLOAT, 7*BYTES_PER_FLOAT);

    gl.bindBuffer(GL.WebGL.ELEMENT_ARRAY_BUFFER,indexBuffer);
    gl.drawElements(GL.WebGL.TRIANGLES, sprites.length*6, GL.WebGL.UNSIGNED_SHORT, 0);

    int error = gl.getError();
    if(error != 0) print('Error: ${error}');
  }
}

class Sprite {
  double x, y, z;
  double xo, yo;
  double w, h;
  double u, v;
  double r, g, b;
  int index;

  Float32List data = new Float32List(Sprites.FLOATS_PER_VERTEX*4);

  Sprite(this.x,this.y,this.z,this.xo,this.yo,this.w,this.h,this.u,this.v,this.r,this.g,this.b){
    data.setAll(0, [
      x,y,z,xo+0,yo+0,u+0,v+0,r,g,b,
      x,y,z,xo+w,yo+0,u+w,v+0,r,g,b,
      x,y,z,xo+w,yo+h,u+w,v+h,r,g,b,
      x,y,z,xo+0,yo+h,u+0,v+h,r,g,b
    ]);
  }
}