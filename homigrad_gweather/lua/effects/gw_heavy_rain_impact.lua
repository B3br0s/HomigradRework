function EFFECT:Init( data )
	local offset = data:GetOrigin() + Vector( 0, 0, 0.2 )
	local ang = data:GetAngles()
	local scale = data:GetScale()
	
	self.Color = {180,203,203}

	local emitter = ParticleEmitter( offset, true )
	local emitter2 = ParticleEmitter( offset, false )

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
			local p2 = emitter2:Add( "particle/smokesprites_0002", offset )
			if p2 then
				p2:SetAngles( ang )
				p2:SetVelocity( gWeather:GetWindDirection()*gWeather:GetWindSpeed()*2 + Vector( 0, 0, 40 ) )
				p2:SetColor( self.Color[1],self.Color[2],self.Color[3] )
				p2:SetLifeTime( 0 )
				p2:SetDieTime( 1 )
				p2:SetStartAlpha( 5 )
				p2:SetEndAlpha( 0 )
				p2:SetStartSize( 1*scale )
				p2:SetEndSize( 100*scale )
				p2:SetCollide(true)
			end
			emitter2:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end