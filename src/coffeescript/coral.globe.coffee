Coral  = Coral  || {}

TRESHOLD = 0.3
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
    smoothing: 20
    detail: 4
    radius: 0.5
    noiseOptions: {
      amplitude: 1.0
      frequency: 1.5
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




  noiseOptions = {
    amplitude: 1
    frequency: 5
    octaves: 1
    persistence: 0.5
  }

  beir = new FastSimplexNoise( noiseOptions )
  console.log beir
  console.assert( geometryGlobe.vertices? )

  geometryBlob = []
  meshBlob = []

  for v, i in geometryGlobe.vertices
    e = beir.get3DNoise( v.x, v.y, v.z )

    console.log e
    if e > TRESHOLD
      ops= {
        smoothing: 3
        radius: 0.01
        detail: 2
        noiseOptions: {
          amplitude: 1.0
          frequency: 30
          octaves: 1
          persistence: 0.5
        }
      }

      geometryBlob[i] = Coral.Blob( ops )
      meshBlob[i] = new THREE.Mesh( geometryBlob[i], material)
      meshBlob[i].position.set( v.x, v.y, v.z )
      
      meshBlob[i].castShadow = true
      meshBlob[i].receiveShadow = true
      
      console.log meshBlob[i]
      objectPlanet.add meshBlob[i]

    

  

  

  


  
  objectPlanet.add meshGlobe

  



