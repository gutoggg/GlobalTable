local Node1 = {}

function Node1:Boot()
	self.TesteNumber = 1
end

function Node1:Initialize()
	task.spawn(function()
		wait(2)
		print(self.TesteNumber)
	end)
end

return Node1
