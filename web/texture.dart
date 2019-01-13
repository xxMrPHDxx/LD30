part of LD30;

class Texture {
  static List<Texture> all = new List<Texture>();
  static int added=0, loaded=0;

  String url;
  Texture(this.url){
    all.add(this);
    load();
    added++;
  }

  GL.Texture texture;

  void load(){
    ImageElement img = new ImageElement(src: url);
    texture = gl.createTexture();
    img.onLoad.listen((e){
      gl.texImage2D(GL.WebGL.TEXTURE_2D, 0, GL.WebGL.RGBA, GL.WebGL.RGBA, GL.WebGL.UNSIGNED_BYTE, img);
      gl.bindTexture(GL.WebGL.TEXTURE_2D, texture);
      gl.texParameteri(GL.WebGL.TEXTURE_2D, GL.WebGL.TEXTURE_MIN_FILTER, GL.WebGL.NEAREST);
      gl.texParameteri(GL.WebGL.TEXTURE_2D, GL.WebGL.TEXTURE_MAG_FILTER, GL.WebGL.NEAREST);
      loaded++;
    }, onError: (error){
      print("Error: ${error}");
    });
  }
  
  static Future<String> loadAll(){
    if(loaded >= added){
      return Future.value("DONE!");
    }
    return Future.delayed(Duration(seconds: 1),loadAll);
  }
}