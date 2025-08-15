
if CLIENT then 
	net.Receive( "lvs_hurtmarker", function( len )
		if not LVS.ShowHitMarker then return end

		local client = LocalPlayer()

		local vehicle = client:lvsGetVehicle()

		if not IsValid( vehicle ) then return end

		vehicle:HurtMarker( net.ReadFloat() )
	end )

	net.Receive( "lvs_hitmarker", function( len )
		if not LVS.ShowHitMarker then return end

		local client = LocalPlayer()

		local vehicle = client:lvsGetVehicle()

		local IsCrit = net.ReadBool()

		if not IsValid( vehicle ) then
			hook.Run( "LVS:OnHudIndicator", client,  IsCrit and "crit" or "hit" )

			return
		end

		if IsCrit then
			vehicle:CritMarker()
		else
			vehicle:HitMarker()
		end
	end )

	net.Receive( "lvs_killmarker", function( len )
		if not LVS.ShowHitMarker then return end

		local client = LocalPlayer()

		local vehicle = client:lvsGetVehicle()

		if not IsValid( vehicle ) then
			hook.Run( "LVS:OnHudIndicator", client, "kill" )

			return
		end

		vehicle:KillMarker()
	end )

	net.Receive( "lvs_armormarker", function( len )
		if not LVS.ShowHitMarker then return end

		local client = LocalPlayer()

		local vehicle = client:lvsGetVehicle()

		local IsDamage = net.ReadBool()

		if not IsValid( vehicle ) then
			hook.Run( "LVS:OnHudIndicator", client, IsDamage and "armorcrit" or "armor" )

			return
		end

		vehicle:ArmorMarker( IsDamage )
	end )

	return
end

util.AddNetworkString( "lvs_hitmarker" )
util.AddNetworkString( "lvs_hurtmarker" )
util.AddNetworkString( "lvs_killmarker" )
util.AddNetworkString( "lvs_armormarker" )