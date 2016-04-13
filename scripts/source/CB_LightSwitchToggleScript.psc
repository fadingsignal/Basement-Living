ScriptName CB_LightSwitchToggleScript Extends ObjectReference
{Disables a parent marker linked up to vanilla light sources and fixtures, so player can easily enable/disable and build their own Workshop lights if they want.}

ObjectReference Property EnableLightsMarker Auto
ObjectReference Property EnableFogMarker Auto
ObjectReference Property EnableMiscMarker = None Auto
Message Property InteriorControlsMenu Auto

;Placeholder properties since they can't be added in xEdit
Bool Property Property03 Auto
Bool Property Property04 Auto
Bool Property Property05 Auto
Bool Property Property06 Auto

Function OnActivate(ObjectReference akActionRef)
	ShowControlMenu()
EndFunction

Function ShowControlMenu(Int iButton = 0)

	iButton = InteriorControlsMenu.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	;If we have an EnableMiscMarker being passed in, we can assume that the message being passed in contains more options
	If(EnableMiscMarker != None)
		If iButton == 0 ; Toggle Lights
			ToggleLights()
		ElseIf iButton == 1 ; Toggle Fog
			ToggleFog()
		ElseIf iButton == 2 ; Toggle Misc
			ToggleMisc()
		ElseIf iButton == 3 ; Do Nothing
			;empty
		EndIf		
	Else
		If iButton == 0 ; Toggle Lights
			ToggleLights()
		ElseIf iButton == 1 ; Toggle Fog
			ToggleFog()
		ElseIf iButton == 2 ; Do Nothing
			;empty
		EndIf
	EndIf
	
	
EndFunction

Function ToggleFog()
	If(EnableFogMarker.IsDisabled())
		EnableFogMarker.Enable(False)
	Else
		EnableFogMarker.Disable(False)
	EndIf
EndFunction

Function ToggleLights()
	If(EnableLightsMarker.IsDisabled())
		EnableLightsMarker.Enable(False)
	Else
		EnableLightsMarker.Disable(False)
	EndIf
EndFunction

Function ToggleMisc()
	If(EnableMiscMarker.IsDisabled())
		EnableMiscMarker.Enable(False)
	Else
		EnableMiscMarker.Disable(False)
	EndIf
EndFunction


;---- old state code that isn't really necessary

;/

Function OnInit()
	;debug.Notification("Button Initialized")
	If (EnableMarker.IsDisabled())
		GoToState("LightsOff")
	Else
		GoToState("LightsOn")
	EndIf	
EndFunction


;-- State ---------------------------
State LightsOff

	Function OnBeginState(string asOldState)
		;debug.Notification("state off")
		EnableMarker.Disable(false)
		
		If(EnableMarker.IsDisabled())
			;debug.Notification("marker is disabled")
		EndIf
		;If(SwapMarker)
			;SwapMarker.Enable(true)
		;EndIf
	EndFunction

	Function OnActivate(ObjectReference akActionRef)
		GoToState("LightsOn")
	EndFunction

EndState

;-- State ---------------------------
State LightsOn

	Function OnBeginState(string asOldState)
		;debug.Notification("state on")

		EnableMarker.Enable(false)

		If(!EnableMarker.IsDisabled())
			;debug.Notification("marker is enabled")
		EndIf

		;If(SwapMarker)
			;SwapMarker.Disable(true)
		;EndIf		
	EndFunction

	Function OnActivate(ObjectReference akActionRef)
		GoToState("LightsOff")
	EndFunction

EndState

/;
