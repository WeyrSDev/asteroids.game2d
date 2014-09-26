
'asteroids play state

Type TPlayState Extends TState

	'current rocks in this stage
	Field rockCount:Int
	'max rocks to make at start of stage
	Field maxRocks:Int
	'how many rocks a rock splits into
	Field rockSplit:Int

	Field player:TPlayer


	Method New()
	EndMethod


	'start a new game
	Method Enter()
		CreatePlayer()
		player.Reset()
		player.score = 0
		player.lives = 3
		player.warps = 3
		player.dead = false

		maxRocks = 4
		rockSplit = 2
		CreateRocks()
	End Method


	Method Leave()
		g_hiscore = max(player.score, g_hiscore)
		player = Null
		ClearEntities()
	End Method


	Method CreatePlayer()
		player = New TPlayer
		player.state = Self
		AddEntity( player, LAYER_PLAYER, "player" )
	End Method


	Method CreateBullet(xpos:float, ypos:float, angle:Float)
		Local bullet:TBullet = New TBullet
		bullet.state = Self
		bullet.SetPosition( xpos,ypos )
		bullet.angle = angle
		AddEntity( bullet, LAYER_PLAYER, "bullets" )
	End Method


	Method CreateRocks()
		Local rock:TRock
		For Local i:Int = 0 To maxRocks
			rock = New TRock
			rock.SetSize(0)
			rock.SetPosition( Rnd(3, G_RESX-3), Rnd(3, G_RESY-3) )
			AddEntity( rock, LAYER_ROCKS, "rocks" )
		Next
		rockCount = maxRocks
	EndMethod


	Method CreateExplosion(position:TPosition, amount:Int, speed:Float=0.7)
		Local particle:TParticle
		For local i:Int = 0 to amount
			particle = New TParticle
			particle.SetPosition( position.GetX(), position.GetY() )
			particle.speed = Rnd(0.2,speed)
			particle.angle = Rnd(360)
			AddEntity( particle, LAYER_PARTICLES, "particles" )
		Next
	EndMethod


	Method LevelUp()
		maxRocks:+ 1
		If maxRocks = 11 then maxRocks = 10
		CreateRocks()

		'rocks split into more parts from now on
		rockSplit:+ 1

		PlayGameSound( "stageup", "sounds" )
	End Method


	Method Render(tween:Double)
		TRenderState.Push()
		TRenderState.Reset()

		local ox:float, oy:float
		Getorigin( ox, oy)
		SetOrigin(TVirtualGfx.VG.vxoff, TVirtualGfx.VG.vyoff)

		SetGameColor( WHITE )
		RenderText("SCORE:" + player.score, 5, 1, False, True)
		RenderText("LIVES:" + player.lives, 0, 1, True, True)
		RenderText("WARPS:" + player.warps, 130, 1, False, True)

		If player.lives = 0
			SetColor Rnd(100, 200), Rnd(0, 100), Rnd(100, 255)
			RenderText("GAME OVER", 0, G_RESY/2, True, True)
			SetGameColor( WHITE )
			RenderText("PRESS ENTER TO CONTINUE", 0, 100, True, True)
		End If

		SetOrigin(ox,oy)
		TRenderState.Pop()
	End Method


	Method Update(delta:Double)
		If player.lives = 0 And KeyHit(KEY_ENTER) = 1
			EnterGameState( STATE_TITLE, New TTransitionFadeIn, New TTransitionFadeOut )
		End If
	End Method
End Type
