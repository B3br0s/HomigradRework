function EFFECT:Init(data)
	local NumParticles=1000
	local emitter=ParticleEmitter(data:GetOrigin())
		
	emitter:Finish()
end
function EFFECT:Think()
	return false
end
function EFFECT:Render()
end

--// Copyright © 2020 by GalaxyHighMarshal, All rights reserved.
--// All trademarks are property of their respective owners.
--// No parts of this coding or any of its contents may be reproduced, copied, modified or adapted, without the prior written consent of the author, unless otherwise indicated for stand-alone materials. Doing so would be violating
--// https://store.steampowered.com/subscriber_agreement/ 
--// I Have Spoken!
