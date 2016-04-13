ScriptName BasementLadderTeleportReturn Extends ObjectReference

;Basement Living
;by fadingsignal 2016
;version 1.2
;fadingsignalmods@gmail.com

ObjectReference Property TeleportDoorSource Auto Hidden ;deprecated but kept to avoid errors

;placeholder properties
Keyword Property LinkedRefDoorKeyword Auto
Bool Property Property01 Auto
Bool Property Property02 Auto
Bool Property Property03 Auto
Bool Property Property04 Auto
Bool Property Property05 Auto
Bool Property Property06 Auto

Function OnActivate(ObjectReference akActionRef)
		;debug.Notification("door activated")
		
		;If we have a linked ref
		If Self.GetLinkedRef(LinkedRefDoorKeyword)
			ObjectReference destinationDoor = Self.GetLinkedRef(LinkedRefDoorKeyword)
			Game.FadeOutGame(True, True, 0, 1, True)
			Utility.Wait(1.5)			
			;akActionRef.MoveTo(destinationDoor, 0, 0, 0, False)
			Game.FastTravel(destinationDoor)
		Else
			debug.MessageBox("This door doesn't know where to go. Fast Travel to where you placed it, scrap it, and re-build it.")
		EndIf
EndFunction
