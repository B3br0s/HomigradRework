game.AddParticles("particles/arc9_fas_explosions.pcf")
game.AddParticles("particles/arc9_fas_muzzleflashes.pcf")
game.AddParticles("particles/muzzleflashes_test_b.pcf")

local huyprecahche = {
    "muzzleflash_1",
    "muzzleflash_3",
    "muzzle_trace",
    "muzzle_trace_blue",
    "muzzle_trace_small",
}
for k,v in ipairs(huyprecahche) do
    PrecacheParticleSystem(v)
end