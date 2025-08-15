
function LVS:CalcView( vehicle, client, pos, angles, fov, pod )
	local view = {}
	view.origin = pos
	view.angles = angles
	view.fov = fov
	view.drawviewer = false

	if not pod:GetThirdPersonMode() then return view end

	local mn = vehicle:OBBMins()
	local mx = vehicle:OBBMaxs()
	local radius = ( mn - mx ):Length()
	local radius = radius + radius * pod:GetCameraDistance()

	local TargetOrigin = view.origin + ( view.angles:Forward() * -radius ) + view.angles:Up() * radius * pod:GetCameraHeight()
	local WallOffset = 4

	local tr = util.TraceHull( {
		start = view.origin,
		endpos = TargetOrigin,
		filter = function( e )
			local c = e:GetClass()
			local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "lvs_" ) and not c:StartWith( "player" ) and not e.LVS

			return collide
		end,
		mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
		maxs = Vector( WallOffset, WallOffset, WallOffset ),
	} )

	view.origin = tr.HitPos
	view.drawviewer = true

	if tr.Hit and  not tr.StartSolid then
		view.origin = view.origin + tr.HitNormal * WallOffset
	end

	return view
end

hook.Add( "CalcView", "!!!!LVS_calcview", function(client, pos, angles, fov)
	if client:GetViewEntity() != client then return end

	local pod = client:GetVehicle()
	local vehicle = client:lvsGetVehicle()

	if not IsValid( pod ) or not IsValid( vehicle ) then return end

	local newfov = vehicle:LVSCalcFov( fov, client )

	local base = pod:lvsGetWeapon()

	if IsValid( base ) then
		local weapon = base:GetActiveWeapon()

		if weapon and weapon.CalcView then
			return client:lvsSetView( weapon.CalcView( base, client, pos, angles, newfov, pod ) )
		else
			return client:lvsSetView( vehicle:LVSCalcView( client, pos, angles, newfov, pod ) )
		end
	else
		local weapon = vehicle:GetActiveWeapon()

		if weapon and weapon.CalcView then
			return client:lvsSetView( weapon.CalcView( vehicle, client, pos, angles, newfov, pod ) )
		else
			return client:lvsSetView( vehicle:LVSCalcView( client, pos, angles, newfov, pod ) )
		end
	end
end )
