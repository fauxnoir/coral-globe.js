var Coral, demo, renderer, rendererStats, stats;

Coral = Coral || {};

Coral.Globe = function() {
  var COLORS, geometry, geometryOptions, material, mesh;
  COLORS = [0x86c9b6, 0x76b290, 0x90c998, 0x81b276, 0xa4c382];
  geometryOptions = {
    smoothing: 25,
    detail: 5,
    radius: 0.5,
    noiseOptions: {
      amplitude: 1.0,
      frequency: 0.4,
      octaves: 1,
      persistence: 0.5
    }
  };
  geometry = Coral.Blob(geometryOptions);
  material = new THREE.MeshPhongMaterial({
    color: random(COLORS),
    shading: THREE.FlatShading
  });
  return mesh = new THREE.Mesh(geometry, material);
};

stats = new Stats();

stats.domElement.style.position = 'absolute';

stats.domElement.style.left = '0px';

stats.domElement.style.top = '0px';

rendererStats = new THREEx.RendererStats();

rendererStats.domElement.style.position = 'absolute';

rendererStats.domElement.style.left = '0px';

rendererStats.domElement.style.bottom = '0px';

renderer = new THREE.WebGLRenderer();

demo = Sketch.create({
  type: Sketch.WEBGL,
  element: renderer.domElement,
  context: renderer.context,
  setup: function() {
    this.camera = new THREE.PerspectiveCamera(90, this.width / this.height, 0.01, 400);
    this.camera.setLens(25, 35);
    this.camera.position.set(0, 0, 0.5 + 0.55);
    this.camera.rotation.x = 70 * Math.PI / 180;
    this.scene = new THREE.Scene();
    this.mesh = Coral.Globe();
    this.mesh.castShadow = true;
    this.mesh.receiveShadow = true;
    this.light = new THREE.PointLight(0xffeed1);
    this.light.position.set(10, 10, 10);
    this.scene.add(this.light);
    return this.scene.add(this.mesh);
  },
  resize: function() {
    this.camera.aspect = this.width / this.height;
    this.camera.updateProjectionMatrix();
    return renderer.setSize(this.width, this.height);
  },
  draw: function() {
    stats.begin();
    this.mesh.rotation.x += 0.002;
    renderer.render(this.scene, this.camera);
    stats.end();
    return rendererStats.update(renderer);
  }
});

window.onload = function() {
  var gui;
  document.body.appendChild(stats.domElement);
  document.body.appendChild(rendererStats.domElement);
  return gui = new dat.GUI();
};

//# sourceMappingURL=main.js.map
