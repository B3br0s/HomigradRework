function EFFECT:Init( data )
	local offset = data:GetOrigin() + Vector( 0, 0, 0.2 )
	local ang = data:GetAngles()
	local scale = data:GetScale()
	
	self.Color = {180,203,203}

	local emitter = ParticleEmitter( offset, true )

			local p1 = emitter:Add( "effects/splashwake3", offset )
			if p1 then
				p1:SetAngles( ang )
				p1:SetColor( self.Color[1],self.Color[2],self.Color[3] )
				p1:SetLifeTime( 0 )
				p1:SetDieTime( math.Rand(0.4,0.5) )
				p1:SetStartAlpha( 255 )
				p1:SetEndAlpha( 0 )
				p1:SetStartSize( 1*scale )
				p1:SetEndSize( 4*scale )
				p1:SetCollide(true)
			end
			emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end