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

    @camera = new THREE.PerspectiveCamera(90, @.width / @.height, 0.01, 10 )
    @camera.setLens(35, 35)
    @camera.position.set(0, 0, 0.5 + 0.65)
    @camera.rotation.x = 50 * Math.PI / 180

    # @camera.position.set(0, 0, 2)

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

