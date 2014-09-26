
Type TTitleState Extends TState

	Field image:TImage

	'for flashy text
	Field colorFlash:Int
	field colorHighLight:Int
	CONST COLORFLASH_DELAY:Int = 20


	Method New()
		image:TImage = GetResourceImage("logo", "images")
	End Method


	Method Enter()
		FlushKeys()
	EndMethod
	

	Method Update(delta:Double)

		'update color flash toggle
		colorFlash:+1
		if colorFlash Mod COLORFLASH_DELAY = 0
			colorHighLight = not colorHighLight
			colorFlash = 0
		endif

		If KeyHit(KEY_ENTER)
			EnterGameState(STATE_PLAY, New TTransitionFadeIn, New TTransitionFadeOut)
		End If

	End Method


	Method Render(tween:Double)
		'take care of side borders in fullscreen mode.
		SetOrigin(TVirtualGfx.VG.vxoff, TVirtualGfx.VG.vyoff)

		SetAlpha 1
		SetColor 255, 255, 255
		SetRotation(10)
		SetScale 2, 2
		DrawImage( image, G_RESX / 2, 30 )

		If not GameTransitioning()
			SetRotation 0

			SetGameColor( WHITE )
			RenderText("Hi-score: " + g_hiscore, 0, 1, True, True)
			RenderText("GAME2D EXAMPLE. C 2014 WDW", 0, 55, True, True)

			SetGameColor( RED )
			if colorHighLight then SetGameColor( WHITE )
			RenderText("PRESS ENTER TO PLAY", 0, G_RESY - 30, True, True)

			SetGameColor( GREEN )
			RenderText("[ESCAPE] pause and configuration menu", 0, G_RESY - 15, True, True)
		EndIf
	End Method

End Type
