local library = {}

for i, j in pairs(script:GetChildren()) do
	if j:IsA('ModuleScript') then
		library[j.Name] = require(j)
	end
end

return library
