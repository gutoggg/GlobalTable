GlobalTable = {}

local Library = require(script:WaitForChild('library'))

GlobalTable.Library = Library

local Nodes = {}
Nodes.__index = Nodes

Nodes.Library = GlobalTable.Library

function GlobalTable:Boot()
	
	local nodes = script:WaitForChild('nodes')
	local modulesStartSignal = self.Library.Signal.new()
	local moduleImportPromiseList = {}

	for index, module in pairs(nodes:GetChildren()) do
		local moduleImportPromise = self:_setupModule(module, modulesStartSignal)
		moduleImportPromise:andThen(function(moduleTable)
			Nodes[module.Name] = moduleTable
		end)
		table.insert(moduleImportPromiseList, moduleImportPromise)
	end
	
	local AllModulesPromise = self.Library.Promise.all(moduleImportPromiseList)
	
	AllModulesPromise:await()
	
	warn('All the nodes was booted')
	
	modulesStartSignal:Fire()
	warn('All the nodes was inicilized')
	warn('GlobalTable was created')
	
	return Nodes
	
end

function GlobalTable:_setupModule(moduleScript : ModuleScript, modulesStartSignal : RBXScriptSignal)
	return self.Library.Promise.new(function(accept, reject)
		local module = require(moduleScript) 
		if module.Boot ~= nil and type(module.Boot) == 'function' then
			module:Boot()
			accept(module)
		end
		
		modulesStartSignal:Connect(function()
			setmetatable(module, Nodes)
			module:Initialize()
			warn('Node ' .. moduleScript.Name .. ' Inicialized.')
		end)
		
	end)
end

return GlobalTable