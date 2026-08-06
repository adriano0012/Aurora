    if not flag then
        workspace.Terrain.WaterColor = Color3.fromRGB(52, 120, 154)
      end
      spawn(function(rgbwater)
        while wait() do
          if swin.flags.water then
                          workspace.Terrain.WaterColor = Color3.fromHSV(tick() * 24 % 255/255, 1, 1)
                          wait()
                        end
                      end
