getgenv().DumpFunction(func)
	if type(func) == 'function' then
		local tbl = {}
		tbl.Parent = func
		for i,v in pairs(getupvalues(func)) do
			if type(v) == 'function' then
				tbl[i] = {}
				for l,k in pairs(getupvalues(v)) do
					tbl[i][l] = [k]
				end
			else
				tbl[i]=v
			end
		end
		return tbl
	else
		return nil
	end
end
