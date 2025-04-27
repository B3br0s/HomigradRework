SWEP.IconPos = Vector(0,0,0)
SWEP.IconAng = Angle(0,0,0)
SWEP.WepSelectIcon2 = Material("null")
SWEP.IconOverride = ""

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	local WM = self.WorldModel

	if not IsValid(DrawingModel) then
		DrawingModel = ClientsideModel(self.WorldModel,RENDERGROUP_OPAQUE)
		DrawingModel:SetNoDraw(true)
	else
		DrawingModel:SetModel(self.WorldModel)
		local vec = Vector(18.7,150,-3)
		local ang = Vector(0,-90,0):Angle()

		cam.Start3D( vec, ang, 20, x, y+35, wide, tall, 5, 4096 )
			cam.IgnoreZ( true )
			render.SuppressEngineLighting( true )

			render.SetLightingOrigin( self:GetPos() )
			render.ResetModelLighting( 50/255, 50/255, 50/255 )
			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 255 )

			render.SetModelLighting( 4, 1, 1, 1 )

			DrawingModel:SetRenderAngles( self.IconAng )
			DrawingModel:SetRenderOrigin( self.IconPos)
			DrawingModel:DrawModel()
			DrawingModel:SetRenderAngles()

			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 1 )
			render.SuppressEngineLighting( false )
			cam.IgnoreZ( false )
		cam.End3D()
	end

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( self.WepSelectIcon2 )

	surface.DrawTexturedRect( x, y + 10,  256 * ScrW()/1920 , 128 * ScrH()/1080 )

	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )

end