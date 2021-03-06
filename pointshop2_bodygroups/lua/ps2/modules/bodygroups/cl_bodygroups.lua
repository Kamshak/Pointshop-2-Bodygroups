 --{Made by SNO}--

local Player = LocalPlayer() 

Player.BodygroupsData = {}

function MakeNiceName( str )
	local newname = {}

	for _, s in pairs( string.Explode( "_", str ) ) do
		if ( string.len( s ) == 1 ) then table.insert( newname, string.upper( s ) ) continue end
		table.insert( newname, string.upper( string.Left( s, 1 ) ) .. string.Right( s, string.len( s ) - 1 ) ) -- Ugly way to capitalize first letters.
	end

	return string.Implode( " ", newname )
end

hook.Add( "PS2_GetPreviewModel", "BodygroupSupport", function( )
	if Pointshop2:IsPlayerModelEquipped( ) then
		local playerModelItem = Player.PS2_Slots["Model"]
		local BodyGroups = Player.BodygroupsData[playerModelItem.id]
		return {
			model = playerModelItem.playerModel,
			skin =  BodyGroups and BodyGroups[1] or 0,
			bodygroups = BodyGroups and BodyGroups[2] or 0
		}
	end

	return {
		model = Player:GetModel( ),
		bodygroups = "0",
		skin = 0
	}
end )

hook.Add( "PS2_ItemEquipped", "ItemEquiped", function( ply, item )
    if Player.PS2_Slots["Model"] != item then return end
	timer.Simple( 0, function( )
	    Pointshop2.BodyGroups.ApplyBtn:SetVisible(false)
	    Pointshop2.BodyGroups:UpdateAndList()
    end )
end )

net.Receive("Bodygroups_Init", function(len)

	--while true do
	
		local id     = net.ReadUInt(16)
		local skin   = net.ReadUInt(8)
		local groups = net.ReadString()
		
		Player.BodygroupsData[ id ] = {skin, string.gsub(groups, "."," %0"):sub(2)}
		
	--end
	
	hook.Run( "PS2_DoUpdatePreviewModel" )
end)
