replaceclosure(isreadonly, function(t)
  if t == syn then 
    return true 
  end 
end)
setreadonly(syn,false)
local req = syn.request
syn.request = function(args)
  if args.Url == 'https://buy.khysarth.ga/' then 
    return {
      Body = 'OK'
    }
  end 
  return req(args)
end 
