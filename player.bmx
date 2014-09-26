
Type TPlayer Extends TImageEntity

	Field lives:Int
	Field score:Int
	Field warps:Int

	Field dead:Int
	Field deadPause:Int

	field immune:Int
	field immuneDelay:Int
	const immuneFlashDelay:int = 6

	Field velocity:TVector2D
	Field acceleration:TVector2D

	Const THRUST:Float = 0.06

	'playstate for this entity
	Field state:TPlayState


	Method New()
		velocity = New TVector2D
		acceleration = New TVector2D
		Self.SetImage( GetResourceImage("player", "images") )
		Self.SetColor(255,50,50)
	End Method


	Method Reset()
		Self.velocity.Set(0,0)
		Self.acceleration.Set(0,0)
		Self.SetPosition( G_RESX/2, G_RESY/2 )
		Self.SetRotation(0)

		Self.immune = true
		Self.immuneDelay = 100

		FlushKeys()
	End Method


	Method UpdateEntity()
		if dead
			deadPause:-1
			if deadPause = 0
				If lives > 0
					dead = false
					Self.Reset()
					Self.SetVisible(True)
				EndIf
			EndIf
			return
		EndIf

		if immune
			immuneDelay:-1
			if immuneDelay mod immuneFlashDelay = 0
				Self.SetVisible(not self.GetVisible())
			EndIf
			if immuneDelay = 0
				immune= false
				Self.SetVisible(true)
			endif
		endif


		'screen wrap
		If EntityX(Self) < -3 Then Self.SetPosition( G_RESX+3, EntityY(Self) )
		If EntityX(Self) > G_RESX+3 Then Self.SetPosition( -3, EntityY(Self) )
		If EntityY(Self) < -3 Then Self.SetPosition( EntityX(Self), G_RESY+3 )
		If EntityY(Self) > G_RESY+3 Then Self.SetPosition( EntityX(Self), -3 )

		'input
		If KeyControlDown("TURN LEFT") Then Self.AddRotation(-3)
		If KeyControlDown("TURN RIGHT") Then Self.AddRotation(3)
		If KeyControlDown("THRUST")
			Self.acceleration.SetX(Sin(Self.GetRotation())*THRUST)
			Self.acceleration.SetY(-Cos(Self.GetRotation())*THRUST)
		EndIf

		If KeyControlHit("TELEPORT") and warps > 0
			warps:-1
			Self.SetPosition( Rnd(3,G_RESX-3), Rnd(3,G_RESY-3) )
			Self.velocity.Set(0,0)
			Self.acceleration.Set(0,0)
			'play sound on random channel, volume 1.0
			PlayGameSound( "warp", "sounds")
		Endif


		If KeyControlHit("SHOOT")
			state.CreateBullet(EntityX(Self), EntityY(Self), Self.GetRotation())
			PlayGameSound("bulletfire", "sounds")
		EndIf

		'process physics
		Self.velocity.AddV(Self.acceleration)
		Self.velocity.Multiply(0.95)

		'move along vector
		Self.MoveV(Self.velocity)

		'reset acceleration
		Self.acceleration.Set(0,0)

		'collision with rocks?
		if not immune
			local r:TRock = TRock( Self.CollideWithGroup("rocks") )
			if r
				Self.dead = true
				Self.deadPause = 100
				Self.lives:-1
				Self.SetVisible(false)
				state.CreateExplosion(Self.GetPosition(), 15, 0.7)
				PlayGameSound("explosion", "sounds")
			endif
		endif

		'all rocks gone? go up one level
		'award extra warp
		If state.rockCount = 0
			state.LevelUp()
			warps:+ 1
		Endif

	EndMethod

EndType
