hook.Add( "PlayerButtonDown", "!!!lvsSeatSwitcherButtonDown", function( client, button )
	local vehicle = client:lvsGetVehicle()

	if not IsValid( vehicle ) then return end

	local CurPod = client:GetVehicle()

	if button == KEY_1 then
		if client == vehicle:GetDriver() then
			if vehicle:GetlvsLockedStatus() then
				vehicle:UnLock()
			else
				vehicle:Lock()
			end
		else
			if IsValid( vehicle:GetDriver() ) then return end

			if vehicle:GetAI() then
				vehicle:SetAI( false )
				vehicle:SetAIGunners( true )
			end

			if hook.Run( "LVS.CanPlayerDrive", client, vehicle ) == false then
				hook.Run( "LVS.OnPlayerCannotDrive", client, vehicle )
				return
			end

			client:ExitVehicle()

			local DriverSeat = vehicle:GetDriverSeat()

			if not IsValid( DriverSeat ) then return end

			if hook.Run( "LVS.OnPlayerRequestSeatSwitch", client, vehicle, CurPod, DriverSeat ) == false then return end

			timer.Simple( 0, function()
				if not IsValid( vehicle ) or not IsValid( client ) then return end
				if IsValid( vehicle:GetDriver() ) or not IsValid( DriverSeat ) or vehicle:GetAI() then return end

				client:EnterVehicle( DriverSeat )
				vehicle:AlignView( client )
				vehicle:OnSwitchSeat( client, CurPod, DriverSeat )
			end)
		end
	else
		for _, Pod in pairs( vehicle:GetPassengerSeats() ) do
			if not IsValid( Pod ) or Pod:GetNWInt( "pPodIndex", 3 ) != LVS.pSwitchKeys[ button ] or IsValid( Pod:GetDriver() ) then continue end

			if hook.Run( "LVS.OnPlayerRequestSeatSwitch", client, vehicle, CurPod, Pod ) == false then continue end

			client:ExitVehicle()

			timer.Simple( 0, function()
				if not IsValid( Pod ) or not IsValid( client ) then return end
				if IsValid( Pod:GetDriver() ) then return end

				client:EnterVehicle( Pod )
				vehicle:AlignView( client, true )
				vehicle:OnSwitchSeat( client, CurPod, Pod )
			end)
		end
	end
end )
