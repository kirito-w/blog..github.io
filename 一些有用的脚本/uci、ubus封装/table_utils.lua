local function table_is_empty(t)
    return _G.next( t ) == nil
end

local function table_len(t)
    local leng = 0
    for _, _ in pairs(t) do
      leng = leng + 1
    end
    return leng
end

local function same_aux(a, b)
	for k, v1 in pairs(a) do
		local v2 = b[k]
		if v1 ~= v2 then
			if not (type(v1) == "table" and type(v2) == "table") then
				return false
			end
			if not same_aux(v1, v2) then
				return false
			end
		end
	end
	return true
end

local function table_is_same(t1, t2)
	return same_aux(t1, t2) and same_aux(t2, t1)
end

return {
    table_len = table_len,
    table_is_empty = table_is_empty,
    table_is_same = table_is_same
}