function EFFECT:Init( data )
	local ang = data:GetAngles()
	local scale = data:GetScale()
	local offset = data:GetOrigin() - ang:Forward()*5
	
	self.Color = {192,192,192}

		local emitter = ParticleEmitter( offset, false )

			local p2 = emitter:Add( "particle/smokesprites_0002", offset )
			if p2 then
				p2:SetAngles( ang )
				p2:SetVelocity( gWeather:GetWindDirection()*20 - ang:Forward()*20*scale )
				p2:SetColor( self.Color[1],self.Color[2],self.Color[3] )
				p2:SetLifeTime( 0 )
				p2:SetDieTime( 1 )
				p2:SetStartAlpha( 25 )
				p2:SetEndAlpha( 0 )
				p2:SetStartSize( 1*scale )
				p2:SetEndSize( 50*scale )
			end
			emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end