

Type TRock Extends TImageEntity

	Field rotationSpeed:Float
	Field speed:Float
	Field angle:Float


	Method New()
		Self.SetImage( GetResourceImage("rocks", "images") )
		Self.SetColor(Rnd(100, 255), Rnd(100, 255), Rnd(100, 255))
		Self.SetRotation(Rnd(360))
		Self.rotationSpeed = Rnd(-0.7,0.7)
		Self.angle = Rnd(360)
	End Method


	'0 = large, 1 = medium, 2 = small.
	Method SetSize(size:Int)
		Self.SetFrame(size)
		Select size
			Case 0	Self.speed = Rnd(0.1,0.2)
			Case 1  Self.speed = Rnd(0.3,0.4)
			Case 2  Self.speed = Rnd(0.5,0.7)
		EndSelect
	EndMethod


	Method UpdateEntity()
		'turn
		Self.SetRotation( Self.GetRotation() + Self.rotationSpeed)

		'move
		Self.Move( Sin(angle)* Self.speed, -cos(angle)*Self.speed )

		'screen wrap
		If EntityX(Self) < -16 Then Self.SetPosition(G_RESX+16, EntityY(Self))
		If EntityX(Self) > G_RESX+16 Then Self.SetPosition( -16, EntityY(Self) )
		If EntityY(Self) < -16 Then Self.SetPosition( EntityX(Self), G_RESY+16 )
		If EntityY(Self) > G_RESY+16 Then Self.SetPosition( EntityX(Self), -16 )
	End Method

EndType