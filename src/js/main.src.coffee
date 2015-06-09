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

    @camera = new THREE.PerspectiveCamera(90, @.width / @.height, 0.01, 400 )
    @camera.setLens(25, 35)
    @camera.position.set(0, 0, 0.5 + 0.55)
    @camera.rotation.x = 70 * Math.PI / 180

    @scene = new THREE.Scene()

    @mesh = Coral.Globe()
    @mesh.castShadow = true
    @mesh.receiveShadow = true

    @light = new THREE.HemisphereLight( 0xffeed1, 0x404040, 1.2)
    @light.position.set(10, 10,10)

    @scene.add(@light)
    @scene.add(@mesh)

  resize: ->
    @camera.aspect = @.width / @.height
    @camera.updateProjectionMatrix()

    renderer.setSize( @.width, @.height )

  draw: ->

    ## Start of stats.js monitored code.
    stats.begin()

    @mesh.rotation.x += 0.002
    # @mesh.rotation.y += 0.002

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

