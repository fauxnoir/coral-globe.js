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

