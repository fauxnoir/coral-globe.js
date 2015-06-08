Coral  = Coral  || {}

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

  geometry = Coral.Blob( geometryOptions )
  material = new THREE.MeshPhongMaterial {
    color: random COLORS
    shading: THREE.FlatShading
  }

  mesh = new THREE.Mesh( geometry, material )


