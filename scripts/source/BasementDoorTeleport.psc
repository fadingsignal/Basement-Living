ScriptName BasementDoorTeleport extends ObjectReference

;Basement Living
;by fadingsignal 2016
;version 1.2
;fadingsignalmods@gmail.com



workshopparentscript Property WorkshopParent Auto mandatory

;-- Properties ------------------------------------

ObjectReference property DestinationMarker Auto
ObjectReference Property ReturnDoor Auto

ObjectReference Property WorkshopMain Auto ;the physical workshop in the basement
ObjectReference Property WorkshopContainerDefault Auto ;the container the workshop is linked to

Keyword Property LinkedRefDoorKeyword Auto
Keyword Property WorkshopLinkContainerKeyword Auto

Message Property TestMessage Auto
GlobalVariable Property BasementExists Auto

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
	
	;Link the container in the basement to the workshop where this door was placed
	LinkToParentWorkshop()
	
EndFunction

;New in v1.3, automatically link to the workshop where the basement door is placed so the containers are shared
Function LinkToParentWorkshop()
	;debug.Notification("Attempting to link workshop")
	
	;This is the reference to the ladder in the basement itself which we use to traverse the parent locations to get the workshop
	
	;Get the location of where the door was just placed
	Location currentLocation = Self.GetCurrentLocation()
	
	;Get the reference for the Workshop in this Location
	workshopscript workshopREF = WorkshopParent.GetWorkshopFromLocation(currentLocation)
	
	;Grab the reference of the actual container attached to the Workshop
	ObjectReference parentContainerRef = workshopREF.GetContainer()

	;If we successfully grabbed the parent workshop container, continue
	;Consider an Else condition that will re-attach the default container to avoid having NO container
	If(parentContainerRef)
		;debug.Notification("Parent container found, linking...")
		debug.Trace("Parent Settlement container found, linking to basement...", 0)
		WorkshopMain.SetLinkedRef(None, WorkshopLinkContainerKeyword) ;clear out the current ref to be safe
		WorkshopMain.SetLinkedRef(parentContainerREF, WorkshopLinkContainerKeyword) ;add the ref of the parent container
	Else
		debug.Trace("Could not reach Settlement container, retaining previous container.", 0)
	EndIf
	
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

