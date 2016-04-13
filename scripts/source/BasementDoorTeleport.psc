ScriptName BasementDoorTeleport extends ObjectReference

;Basement Living
;by fadingsignal 2016
;version 1.2
;fadingsignalmods@gmail.com

;-- Properties ------------------------------------
ObjectReference property DestinationMarker Auto
ObjectReference Property ReturnDoor Auto
Keyword Property LinkedRefDoorKeyword Auto

workshopparentscript Property WorkshopParent Auto mandatory
Message Property TestMessage Auto
GlobalVariable Property BasementExists Auto

;placeholder properties since adding them is so hard in xEdit
Bool Property Property04 Auto
Bool Property Property05 Auto
Bool Property Property06 Auto

int countertest = 0

;Runs before OnWorkshopObjectPlaced
Function OnInit()

	;This ended up being unused but I'm keeping it anyway for later
	If (BasementExists.GetValue() as bool == False)
		;debug.Notification("first time crafting setting value from 0 to 1")
		BasementExists.SetValue(1)
	EndIf	

	;Grab the 'old' door, if it's not there this value will be "None"
	ObjectReference existingEntryDoor = ReturnDoor.GetLinkedRef(LinkedRefDoorKeyword)
	
	;Check if the teleport return is already assigned somewhere, if so, tell player and remove the old door and its link
	If(existingEntryDoor)
		
		;Grab locations (this was finnicky without them being dedicated variables
		Location doorLocation = existingEntryDoor.GetCurrentLocation()
		Location myLocation = Game.GetPlayer().GetCurrentLocation()
		
		;Check if the old door is in the same location as us or not, and tell the user what settlement it moved from
		If(myLocation != doorLocation)
			WorkshopParent.DisplayMessage(TestMessage, None, doorLocation)
		EndIf
		
		;Unlink the old door as a linked ref to avoid any issues
		ReturnDoor.SetLinkedRef(None, LinkedRefDoorKeyword)
		
		;Destroy the old door entirely
		existingEntryDoor.Delete()
	EndIf
		
	;Set the linked reference between this NEW door and the ladder
	ReturnDoor.SetLinkedRef(Self, LinkedRefDoorKeyword)
		
EndFunction

Function OnWorkshopObjectPlaced(ObjectReference akReference)
	;empty
EndFunction

Function OnActivate(ObjectReference akActionRef)
	;debug.Notification("door activated")
	Game.FadeOutGame(True, True, 0, 1, True)
	Utility.Wait(1.5)
	;akActionRef.MoveTo(DestinationMarker, 0, 0, 0, True)
	Game.FastTravel(DestinationMarker)
EndFunction

Function OnWorkshopObjectDestroyed(ObjectReference akReference)
	ReturnDoor.SetLinkedRef(None, LinkedRefDoorKeyword)
	;debug.Notification("teleport return link removed")
EndFunction

