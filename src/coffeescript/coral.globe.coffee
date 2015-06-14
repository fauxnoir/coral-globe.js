Coral  = Coral  || {}

Coral.Globe = ->
  
  square = (x) -> x * x

  TRESHOLD = 0.17
  objectPlanet = new THREE.Object3D()

  COLORS = [
    0x86c9b6
    0x76b290
    0x90c998
    0x81b276
    0xa4c382
    0x6d4f33
  ]

  geometryOps = {
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

  geoGlobe = Coral.Blob( geometryOps )
  
  material = new THREE.MeshPhongMaterial {
    color: random COLORS
    shading: THREE.FlatShading
  }

  # material = new THREE.MeshBasicMaterial {
  #   wireframe: true
  # }

  mGlobe = new THREE.Mesh( geoGlobe, material )

  # For populating
  noiseOps = {
    amplitude: 1
    frequency: 2.5
    octaves: 1
    persistence: 0.5
  }

  geoNoise = new FastSimplexNoise( noiseOps )
  console.assert( geoGlobe.vertices? )

  geometryBlob = []
  meshBlob = []

  for v, i in geoGlobe.vertices

    e = geoNoise.get3DNoise( v.x, v.y, v.z )

    if e > TRESHOLD
      ops= {
        smoothing: 3
        radius: 1
        detail: 1
        noiseOptions: {
          amplitude: 1.0
          frequency: 30
          octaves: 1
          persistence: 0.5
        }
      }

      # Quick n dirty cointoss
      if Math.random() > 0.90
        # Create a rock
        geometryBlob[i] = Coral.Blob( ops )
       
        matRock = new THREE.MeshPhongMaterial ( color: 0x9a9da4, shading: THREE.FlatShading )

        meshBlob[i] = new THREE.Mesh( geometryBlob[i], matRock)
        meshBlob[i].scale.set( 0.005, 0.005, 0.005 )
        meshBlob[i].position.set( v.x, v.y + 0.01, v.z )

      else if Math.random() > 0.50
        meshBlob[i] = Coral.Tree() # 'mesh' is semantically wrong here
        meshBlob[i].scale.set( 0.1, 0.1, 0.1 )
        meshBlob[i].position.set( v.x, v.y + 0.04, v.z )

      # Set position
      if meshBlob[i]?

        # Set the orientation
        vector = new THREE.Vector3( v.x, v.y, v.z )
        Coral.Globe.Orient( vector, meshBlob[i] )

        meshBlob[i].castShadow = true
        meshBlob[i].receiveShadow = true
        
        objectPlanet.add meshBlob[i]
      

      

  # RETURN
  objectPlanet.add mGlobe

  
  ### END Coral.Globe() ###

Coral.Globe.Orient = ( vector, object ) ->
  ### Coral.Globe.Orient()
  #
  # Rotate a given object so that it faces the orientation of
  # an arbitrary vector on the surface of a sphere.
  #
  ###

  # Declare the plane on which we will project the given normal
  unit_xy = new THREE.Vector3( 1, 1, 0)

  # The assumed unit vector of the object. TODO: This should be arbitrary
  @unit_y = new THREE.Vector3( 0, 1, 0)

  # Define the position of the normal vecor
  n = new THREE.Vector3( vector.x, vector.y, vector.z )
  
  # Calculate spherical coordinates
  # @theta = new THREE.Vector3() # inclination or Zenith angle
  
  # Project n on the xy plane
  nxy = new THREE.Vector3()
  nxy.multiplyVectors( n, unit_xy )


  # Calculate the angle between the unit vector of the object and nxy
  if ( n.x > 0 && n.y > 0 ) || ( n.x > 0 && n.y < 0 )
    # Quadrant I or IV, we need the bigger of two angles
    @theta = 2 * Math.PI - @unit_y.angleTo( nxy )
  else
    # Assume Queadrant II or III, we need the smaller of two angles
    @theta = @unit_y.angleTo( nxy )


  # Calculate elevetion or Azimuth angle
  @phi = new THREE.Vector3()

  if ( n.z > 0 )
    # Octants where we require the smaller of two angles
    @phi = nxy.angleTo( n )
  else
    # Octants where we require the bigger of two angles
    @phi = - nxy.angleTo( n )

  # Apply rotation to the object
   object.rotation.set( @phi, 0, @theta, 'ZXY')


