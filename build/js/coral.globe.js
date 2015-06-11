var Coral;

Coral = Coral || {};

Coral.Globe = function() {
  var COLORS, TRESHOLD, e, geoGlobe, geoNoise, geometryBlob, geometryOps, i, j, len, mGlobe, material, meshBlob, noiseOps, objectPlanet, ops, ref, square, v, vector;
  square = function(x) {
    return x * x;
  };
  TRESHOLD = 0.35;
  objectPlanet = new THREE.Object3D();
  COLORS = [0x86c9b6, 0x76b290, 0x90c998, 0x81b276, 0xa4c382];
  geometryOps = {
    smoothing: 15,
    detail: 4,
    radius: 0.5,
    noiseOptions: {
      amplitude: 1.0,
      frequency: 1.5,
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
    frequency: 2.5,
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
        smoothing: 3,
        radius: Math.random() / 35,
        detail: 1,
        noiseOptions: {
          amplitude: 1.0,
          frequency: 30,
          octaves: 1,
          persistence: 0.5
        }
      };
      if (Math.random() > 0.75) {
        geometryBlob[i] = Coral.Blob(ops);
        meshBlob[i] = new THREE.Mesh(geometryBlob[i], material);
      } else {
        geometryBlob[i] = new THREE.BoxGeometry(0.015, 0.2, 0.015);
        meshBlob[i] = new THREE.Mesh(geometryBlob[i], material);
      }
      meshBlob[i].position.set(v.x, v.y, v.z);
      vector = new THREE.Vector3(v.x, v.y, v.z);
      Coral.Globe.Orient(vector, meshBlob[i]);
      meshBlob[i].castShadow = true;
      meshBlob[i].receiveShadow = true;
      objectPlanet.add(meshBlob[i]);
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
