

Type TBullet Extends TImageEntity

	Field life:Int
	Field angle:Float
	Field state:TPlayState

	Const SPEED:Float = 2.5


	Method New()
		Self.SetImage( GetResourceImage("bullet", "images") )
		Self.SetColor(255,255,255)
		Self.life = 60
	End Method


	Method UpdateEntity()
		life:-1
		If life = 0
			RemoveEntity(Self)
			Return
		Endif

		'move
		Self.Move( Sin(angle)* Self.SPEED, -cos(angle)*Self.Speed )

		'screen wrap
		If EntityX(Self) < -2 Then Self.SetPosition( G_RESX+2, EntityY(Self) )
		If EntityX(Self) > G_RESX+2 Then Self.SetPosition( -2, EntityY(Self) )
		If EntityY(Self) < -2 Then Self.SetPosition( EntityX(Self), G_RESY+2 )
		If EntityY(Self) > G_RESY+2 Then Self.SetPosition( EntityX(Self), -2 )

		'collision with rocks?
		local r:TRock = TRock( Self.CollideWithGroup("rocks") )
		if r
			'remove bullet
			RemoveEntity(self)

			'create explosion on rock position
			Local position:TPosition = r.GetPosition()
			state.CreateExplosion(position, 15)
			PlayGameSound( "explosion", "sounds" )

			'score
			Local frame:Int = r.GetFrame()
			state.player.score:+ (frame+1)*10

			'create new rocks if frame 0 or 1
			If frame < 2
				Local newRock:TRock
				For Local i:int = 1 to state.rockSplit
					newRock = New TRock
					newRock.SetSize(frame+1)
					newRock.SetPosition( position.GetX(), position.GetY() )

					AddEntity( newRock, LAYER_ROCKS, "rocks" )
					state.RockCount:+1
				next
			endif

			'remove old rock
			RemoveEntity(r)
			state.rockCount:-1
		endif
	End Method

EndType