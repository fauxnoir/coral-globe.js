Coral  = Coral  || {}

TRESHOLD = 0
objectPlanet = new THREE.Object3D()

Coral.Globe = ->
  
  COLORS = [
    0x86c9b6
    0x76b290
    0x90c998
    0x81b276
    0xa4c382
  ]

  geometryOptions = {
    smoothing: 25
    detail: 5
    radius: 0.5
    noiseOptions: {
      amplitude: 1.0
      frequency: 0.4
      octaves: 1
      persistence: 0.5
    }
  }

  geometryGlobe = Coral.Blob( geometryOptions )
  material = new THREE.MeshPhongMaterial {
    color: random COLORS
    shading: THREE.FlatShading
  }

  meshGlobe = new THREE.Mesh( geometryGlobe, material )



  noise = new FastSimplexNoise( geometryOptions.noiseOptions )

  console.assert( geometryGlobe.vertices? )
  for v, i in geometryGlobe.vertices
    c = geometryOptions.radius * 2 * Math.PI
    e = @noise.getSpherical3DNoise( c, v.x, v.y, v.z )

    if e > TRESHOLD
      ops= {
        smoothing: 5
        radius: 0.01
        detail: 1
      }

      geometryBlob = Coral.Blob( ops )
      meshBlob = new THREE.Mesh( geometryBlob, material)
      meshBlob.position.set( v.x, v.y, v.z )
      
      objectPlanet.add meshBlob

    

  

  

  


  
  objectPlanet.add meshGlobe

  



