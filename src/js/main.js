var Coral, TRESHOLD, demo, objectPlanet, renderer, rendererStats, stats;

Coral = Coral || {};

TRESHOLD = 0.3;

objectPlanet = new THREE.Object3D();

Coral.Globe = function() {
  var COLORS, beir, e, geometryBlob, geometryGlobe, geometryOptions, i, j, len, material, meshBlob, meshGlobe, noiseOptions, ops, ref, v;
  COLORS = [0x86c9b6, 0x76b290, 0x90c998, 0x81b276, 0xa4c382];
  geometryOptions = {
    smoothing: 20,
    detail: 4,
    radius: 0.5,
    noiseOptions: {
      amplitude: 1.0,
      frequency: 1.5,
      octaves: 1,
      persistence: 0.5
    }
  };
  geometryGlobe = Coral.Blob(geometryOptions);
  material = new THREE.MeshPhongMaterial({
    color: random(COLORS),
    shading: THREE.FlatShading
  });
  meshGlobe = new THREE.Mesh(geometryGlobe, material);
  noiseOptions = {
    amplitude: 1,
    frequency: 5,
    octaves: 1,
    persistence: 0.5
  };
  beir = new FastSimplexNoise(noiseOptions);
  console.log(beir);
  console.assert(geometryGlobe.vertices != null);
  geometryBlob = [];
  meshBlob = [];
  ref = geometryGlobe.vertices;
  for (i = j = 0, len = ref.length; j < len; i = ++j) {
    v = ref[i];
    e = beir.get3DNoise(v.x, v.y, v.z);
    console.log(e);
    if (e > TRESHOLD) {
      ops = {
        smoothing: 3,
        radius: 0.01,
        detail: 2,
        noiseOptions: {
          amplitude: 1.0,
          frequency: 30,
          octaves: 1,
          persistence: 0.5
        }
      };
      geometryBlob[i] = Coral.Blob(ops);
      meshBlob[i] = new THREE.Mesh(geometryBlob[i], material);
      meshBlob[i].position.set(v.x, v.y, v.z);
      meshBlob[i].castShadow = true;
      meshBlob[i].receiveShadow = true;
      console.log(meshBlob[i]);
      objectPlanet.add(meshBlob[i]);
    }
  }
  return objectPlanet.add(meshGlobe);
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
    this.camera = new THREE.PerspectiveCamera(90, this.width / this.height, 0.01, 10);
    this.camera.setLens(35, 35);
    this.camera.position.set(0, 0, 0.5 + 0.65);
    this.camera.rotation.x = 50 * Math.PI / 180;
    this.scene = new THREE.Scene();
    this.mesh = Coral.Globe();
    this.mesh.castShadow = true;
    this.mesh.receiveShadow = true;
    this.light = new THREE.HemisphereLight(0xffeed1, 0x404040, 1.2);
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
