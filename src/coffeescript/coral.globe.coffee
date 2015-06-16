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
    smoothing: 13
    detail: 3
    # radius: 0.5
    radius: 300
    noiseOptions: {
      amplitude: 1.0
      frequency: 0.002
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

  # Generate a different noise field used to populate the globe with objects
  noiseOps = {
    amplitude: 1
    frequency: 5
    octaves: 1
    persistence: 0.5
  }

  geoNoise = new FastSimplexNoise( noiseOps )
  console.assert( geoGlobe.vertices? )

  geometryBlob = []
  meshBlob = []


  ### Add random objects ###
  for v, i in geoGlobe.vertices

    e = geoNoise.get3DNoise( v.x, v.y, v.z )

    if e > TRESHOLD
      ops= {
        smoothing: 2
        radius: 1
        detail: 1
        noiseOptions: {
          amplitude: 1.0
          frequency: 0.3
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
        
        radius = geometryOps.radius / 20
        meshBlob[i].scale.set( radius, radius, radius )
        meshBlob[i].position.set( v.x, v.y, v.z )

      else if Math.random() > 0
        meshBlob[i] = Coral.Tree() # 'mesh' is semantically wrong here

        radius = geometryOps.radius / 1.5
        meshBlob[i].scale.set( radius, radius, radius )
        meshBlob[i].position.set( v.x, v.y , v.z )

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

Coral.Clouds = ->
 
  r = 1000

  objectClouds = new THREE.Object3D()

  # material = new THREE.MeshBasicMaterial {
  #   wireframe: true
  # }

  material = new THREE.MeshPhongMaterial {
    color: 0xffffff
    shading: THREE.FlatShading
  }

  for i in [0..100]
    # Generate a random point on the surface of a sphere (latitude and longitude)
    u = Math.random()
    v = Math.random()

    theta = Math.PI * 2 * u
    phi = Math.acos( 2 * v - 1 )

    # Convert to cartesian coordinates
    x = r * Math.sin( phi ) * Math.cos( theta )
    y = r * Math.sin( phi ) * Math.sin( theta )
    z = r * Math.cos( phi )

    geoCloudOps = {
      smoothing: 2
      detail: 2
      radius: 0.7 # Scale later, noise ratio must be correct
      
      noiseOptions: {
        amplitude: 1.0
        frequency: 0.4
        octaves: 1
        persistence: 0.5
      }
    }

    geoCloud = Coral.Blob( geoCloudOps )
    meshCloud = new THREE.Mesh geoCloud, material

    meshCloud.position.set x, y, z

    scale = ( 10 / geoCloudOps.radius ) * ( 1 + Math.random() )
    meshCloud.scale.set( scale * 2, scale, scale )

    pos = new THREE.Vector3( x, y, z )
    Coral.Globe.Orient( pos, meshCloud )

    objectClouds.add( meshCloud )

  objectClouds

Coral.Globe.Orient = ( vector, object ) ->
  ### Coral.Globe.Orient()
  #
  # Rotate a given object so that it faces the orientation of
  # an arbitrary vector on the surface of a sphere.
  # In this case we assume the sphere's origin is (0,0,0)
  ###

  # Declare the plane on which we will project the given normal
  unit_xy = new THREE.Vector3( 1, 1, 0)

  # The assumed unit vector of the object. TODO: This should be arbitrary
  @unit_y = new THREE.Vector3( 0, 1, 0)

  # Define the position of the normal vecor
  n = new THREE.Vector3( vector.x, vector.y, vector.z )
  
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


