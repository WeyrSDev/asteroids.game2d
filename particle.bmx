

Type TParticle Extends TImageEntity

	Field speed:Float
	Field angle:Float
	Field alphaChange:Float


	Method New()
		Self.SetImage( GetResourceImage("bullet", "images") )
		Self.SetColor(Rnd(100, 255), Rnd(100, 255), Rnd(100, 255))
		Self.alphaChange = 1.0 / Rnd(30,80)
	End Method


	Method UpdateEntity()
		'move
		Self.Move( Sin(angle)* Self.speed, -cos(angle)*Self.speed )

		'burn!
		Self.SetColor(Rnd(100, 255), Rnd(100, 255), Rnd(100, 255))

		'screen wrap
		If EntityX(Self) < -16 Then Self.SetPosition( G_RESX+16, EntityY(Self) )
		If EntityX(Self) > G_RESX+16 Then Self.SetPosition( -16, EntityY(Self) )
		If EntityY(Self) < -16 Then Self.SetPosition( EntityX(Self), G_RESY+16 )
		If EntityY(Self) > G_RESY+16 Then Self.SetPosition( EntityX(Self), -16 )

		Self.SetAlpha( Self.GetAlpha()- Self.alphaChange)
		If Self.GetAlpha() <= 0.0 Then RemoveEntity(Self)
	End Method

EndType