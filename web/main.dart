library LD30;

import 'dart:html';
import 'dart:web_gl' as GL;
import 'dart:typed_data';
import 'dart:async';

import 'package:vector_math/vector_math.dart';

part 'shader.dart';
part 'sprite.dart';
part 'texture.dart';

const double GAME_WIDTH = 240;
const double GAME_HEIGHT = 320;

CanvasElement canvas;
GL.RenderingContext gl;

Sprites sprites;

void main() {
  canvas = querySelector('#Game');
  gl = canvas.getContext('webgl');

  window.addEventListener('resize', resize);
  resize(null);
  if(gl == null) gl = canvas.getContext('experimental-webgl');

  if(gl == null){
    noWebGL();
  }else{
    init();
  }
}

void resize(Event event){
  var width = window.innerWidth;
  var height = window.innerHeight;
  var xScale = width / GAME_WIDTH;
  var yScale = height / GAME_HEIGHT;
  if(xScale < yScale){
    var newHeight = (GAME_HEIGHT*xScale).floor();
    canvas.setAttribute('style',"width: ${width}px; height: ${newHeight}px; left: 0px; top: ${(height-newHeight)/2}px;");
  }
  else{
    var newWidth = (GAME_WIDTH*yScale).floor();
    canvas.setAttribute('style',"width: ${newWidth}px; height: ${height}px; left: ${(width-newWidth)/2}px; top: 0px;");
  }
}

void noWebGL(){

}

Texture spriteSheet;

void init() async{
  spriteSheet = new Texture("sprites.png");

  String message = await Texture.loadAll();
  if(message == "DONE!") start();
}

GL.Buffer vertexBuffer, indexBuffer;
Matrix4 viewMatrix;

void start(){
  viewMatrix = makeOrthographicMatrix(0.0, GAME_WIDTH, GAME_HEIGHT, 0.0, 0.0, 1.0);

  sprites = new Sprites(testShader, spriteSheet.texture);
  sprites.addSprite(new Sprite(0.0, 0.0, 0.0, 50, 50, 16, 16, 0, 0, 1.0, 1.0, 1.0));
  sprites.addSprite(new Sprite(0.0, 0.0, 0.0, 60, 60, 16, 16, 0, 0, 1.0, 1.0, 1.0));
  sprites.addSprite(new Sprite(0.0, 0.0, 0.0, 70, 70, 16, 16, 0, 0, 1.0, 1.0, 1.0));

  window.requestAnimationFrame(render);
}

void render(num time){
  gl.clearColor(51/256,51/256,51/256,1.0);
  gl.clear(GL.WebGL.DEPTH_BUFFER_BIT | GL.WebGL.COLOR_BUFFER_BIT);
  gl.enable(GL.WebGL.BLEND);
  gl.blendFunc(GL.WebGL.SRC_ALPHA, GL.WebGL.ONE_MINUS_SRC_ALPHA);

  sprites.render();

  window.requestAnimationFrame(render);
}
