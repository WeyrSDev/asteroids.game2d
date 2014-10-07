
'Asteroids, with game2d

SuperStrict
Framework wdw.game2d

'-----------------------------------------------

Include "titlestate.bmx"
Include "playstate.bmx"
Include "player.bmx"
Include "bullet.bmx"
Include "rock.bmx"
Include "particle.bmx"

Const STATE_TITLE:Int = 0
Const STATE_PLAY:Int = 1
Const G_RESX:Int = 160
Const G_RESY:Int = 120

'render layers
Const LAYER_ROCKS:Int = 0
Const LAYER_PLAYER:Int = 1
Const LAYER_PARTICLES:Int = 2

Global g_hiscore:Int = 1206

New TAsteroidsGame.Start()
End

'-----------------------------------------------

Type TAsteroidsGame Extends TGame

	Method New()
		SetGameTitle("Asteroids! - Powered by GAME2D")
	EndMethod


	Method Startup()
		HideMouse()
		SeedRnd(MilliSecs())

		'setup window size and game res. also creates graphics
		InitializeGraphics( 800, 600, G_RESX, G_RESY )

		'set up some controls
		AddKeyControl( "TURN LEFT", KEY_LEFT )
		AddKeyControl( "TURN RIGHT", KEY_RIGHT )
		AddKeyControl( "THRUST", KEY_UP )
		AddKeyControl( "TELEPORT", KEY_DOWN )
		AddKeyControl( "SHOOT", KEY_A )

		'reset the render state
		TRenderState.Reset()
		SetClsColor(0, 10, 30)

		'set image loading preferences
		AutoMidHandle( True )
		SetMaskColor( 0, 0, 0 )
		AutoImageFlags( MASKEDIMAGE )

		'create resouce manager groups
		AddResourceGroup("images")
		AddResourceGroup("sounds")

		'load graphics and store them
		AddResourceImage( LoadImage("images/logo.png"), "logo", "images" )
		AddResourceImage( LoadImage("images/player.png"), "player" , "images" )
		AddResourceImage( LoadAnimImage("images/rocks.png", 16, 16, 0, 3) , "rocks" , "images" )
		AddResourceImage( LoadImage("images/bullet.png"), "bullet" , "images" )

		'load sounds and store them
		AddResourceSound( LoadSound("sounds/bullet.wav"), "bulletfire", "sounds" )
		AddResourceSound( LoadSound("sounds/warp.wav"), "warp", "sounds" )
		AddResourceSound( LoadSound("sounds/explosion.wav"), "explosion", "sounds" )
		AddResourceSound( LoadSound("sounds/stageup.wav"), "stageup", "sounds" )

		'create collision groups for entities
		AddEntityGroup( "player" )
		AddEntityGroup( "particles" )
		AddEntityGroup( "rocks" )
		AddEntityGroup( "bullets" )

		'load and set font
		Self.SetGameFont( LoadImageFont("images/wendy.ttf", 10, 0) )

		'add states
		'first state added is the start state.
		AddGameState(New TTitleState, STATE_TITLE)
		AddGameState(New TPlayState, STATE_PLAY)

		'force game to fade in.
		_enterTransition = New TTransitionFadeIn
	End Method


	'gets called when the user selects restart
	'in the game menu
	Method OnRestartGame()
		EnterGameState(STATE_TITLE, New TTransitionFadeIn, New TTransitionFadeOut)
	EndMethod

End Type
