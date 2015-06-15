var Coral, demo, renderer, rendererStats, stats;

Coral = Coral || {};

Coral.Globe = function() {
  var COLORS, TRESHOLD, e, geoGlobe, geoNoise, geometryBlob, geometryOps, i, j, len, mGlobe, matRock, material, meshBlob, noiseOps, objectPlanet, ops, radius, ref, square, v, vector;
  square = function(x) {
    return x * x;
  };
  TRESHOLD = 0.17;
  objectPlanet = new THREE.Object3D();
  COLORS = [0x86c9b6, 0x76b290, 0x90c998, 0x81b276, 0xa4c382, 0x6d4f33];
  geometryOps = {
    smoothing: 13,
    detail: 3,
    radius: 300,
    noiseOptions: {
      amplitude: 1.0,
      frequency: 0.002,
      octaves: 1,
      persistence: 0.5
    }
  };
  geoGlobe = Coral.Blob(geometryOps);
  material = new THREE.MeshPhongMaterial({
    color: random(COLORS),
    shading: THREE.FlatShading
  });
  mGlobe = new THREE.Mesh(geoGlobe, material);
  noiseOps = {
    amplitude: 1,
    frequency: 5,
    octaves: 1,
    persistence: 0.5
  };
  geoNoise = new FastSimplexNoise(noiseOps);
  console.assert(geoGlobe.vertices != null);
  geometryBlob = [];
  meshBlob = [];
  ref = geoGlobe.vertices;
  for (i = j = 0, len = ref.length; j < len; i = ++j) {
    v = ref[i];
    e = geoNoise.get3DNoise(v.x, v.y, v.z);
    if (e > TRESHOLD) {
      ops = {
        smoothing: 2,
        radius: 1,
        detail: 1,
        noiseOptions: {
          amplitude: 1.0,
          frequency: 0.3,
          octaves: 1,
          persistence: 0.5
        }
      };
      if (Math.random() > 0.90) {
        geometryBlob[i] = Coral.Blob(ops);
        matRock = new THREE.MeshPhongMaterial({
          color: 0x9a9da4,
          shading: THREE.FlatShading
        });
        meshBlob[i] = new THREE.Mesh(geometryBlob[i], matRock);
        radius = geometryOps.radius / 20;
        meshBlob[i].scale.set(radius, radius, radius);
        meshBlob[i].position.set(v.x, v.y, v.z);
      } else if (Math.random() > 0) {
        meshBlob[i] = Coral.Tree();
        radius = geometryOps.radius / 1.5;
        meshBlob[i].scale.set(radius, radius, radius);
        meshBlob[i].position.set(v.x, v.y, v.z);
      }
      if (meshBlob[i] != null) {
        vector = new THREE.Vector3(v.x, v.y, v.z);
        Coral.Globe.Orient(vector, meshBlob[i]);
        meshBlob[i].castShadow = true;
        meshBlob[i].receiveShadow = true;
        objectPlanet.add(meshBlob[i]);
      }
    }
  }
  return objectPlanet.add(mGlobe);

  /* END Coral.Globe() */
};

Coral.Globe.Orient = function(vector, object) {

  /* Coral.Globe.Orient()
   *
   * Rotate a given object so that it faces the orientation of
   * an arbitrary vector on the surface of a sphere.
   *
   */
  var n, nxy, unit_xy;
  unit_xy = new THREE.Vector3(1, 1, 0);
  this.unit_y = new THREE.Vector3(0, 1, 0);
  n = new THREE.Vector3(vector.x, vector.y, vector.z);
  nxy = new THREE.Vector3();
  nxy.multiplyVectors(n, unit_xy);
  if ((n.x > 0 && n.y > 0) || (n.x > 0 && n.y < 0)) {
    this.theta = 2 * Math.PI - this.unit_y.angleTo(nxy);
  } else {
    this.theta = this.unit_y.angleTo(nxy);
  }
  this.phi = new THREE.Vector3();
  if (n.z > 0) {
    this.phi = nxy.angleTo(n);
  } else {
    this.phi = -nxy.angleTo(n);
  }
  return object.rotation.set(this.phi, 0, this.theta, 'ZXY');
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
    this.camera = new THREE.PerspectiveCamera(90, this.width / this.height, 0.01, 10000);
    this.camera.position.set(0, 0, 1300);
    this.scene = new THREE.Scene();
    this.mesh = Coral.Globe();
    this.mesh.castShadow = true;
    this.mesh.receiveShadow = true;
    this.light = new THREE.HemisphereLight(0xffeed1, 0x404040, 1.2);
    this.light.position.set(10, 600, 600);
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
    this.mesh.rotation.x += 0.0005;
    this.mesh.rotation.y += 0.0007;
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
