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



stats = new Stats()
stats.domElement.style.position = 'absolute'
stats.domElement.style.left = '0px'
stats.domElement.style.top = '0px'

rendererStats = new THREEx.RendererStats()
rendererStats.domElement.style.position = 'absolute'
rendererStats.domElement.style.left = '0px'
rendererStats.domElement.style.bottom   = '0px'

# Generate a WebGLrenderer instance
renderer = new THREE.WebGLRenderer()

# The actal boilerplate part
demo = Sketch.create({

  type: Sketch.WEBGL
  element: renderer.domElement
  context:renderer.context

  setup: ->

    @camera = new THREE.PerspectiveCamera(90, @.width / @.height, 0.01, 10000 )
    # @camera.setLens(150, 105) # Dat gui!
    # @camera.position.set(0, 100, 1000)
    # @camera.rotation.x = 30 * Math.PI / 180

    @camera.position.set(0, 0, 1300)

    @scene = new THREE.Scene()

    @mesh = Coral.Globe()
    @mesh.castShadow = true
    @mesh.receiveShadow = true

    @light = new THREE.HemisphereLight( 0xffeed1, 0x404040, 1.2)
    @light.position.set(10, 600,600)

    @scene.add(@light)
    @scene.add(@mesh)

  resize: ->
    @camera.aspect = @.width / @.height
    @camera.updateProjectionMatrix()

    renderer.setSize( @.width, @.height )

  draw: ->

    ## Start of stats.js monitored code.
    stats.begin()

    @mesh.rotation.x += 0.0005
    @mesh.rotation.y += 0.0007

    renderer.render( @scene, @camera )

    ## End of stats.js monitored code.
    stats.end()

    # pass renderer to update renderer stats
    rendererStats.update(renderer)
  })

window.onload = ->

  # Append stats indicators to the dom
  document.body.appendChild( stats.domElement )
  document.body.appendChild( rendererStats.domElement )

  gui = new dat.GUI()

