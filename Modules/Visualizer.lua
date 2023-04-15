local HttpService = game:GetService("HttpService")

local Visualizer = {
	Instances = {},
	Parent = (function()
		local Parent = Instance.new("Folder")
		Parent.Name = HttpService:GenerateGUID()
		Parent.Parent = workspace
		return Parent
	end)(),
	Defaults = {
		Beam = (function()
			local Beam = Instance.new("Beam")
			Beam.CurveSize0 = 4 / 3
			Beam.CurveSize1 = 4 / 3
			Beam.Transparency = NumberSequence.new(0)
			Beam.Segments = 100
			Beam.Width0 = 15
			Beam.Width1 = 15
			return Beam
		end)(),
		Part = (function()
			local Part = Instance.new("Part")
			Part.CanCollide = false
			Part.Material = Enum.Material.ForceField
			Part.Anchored = true
			Part.Position = Vector3.zero
			Part.Transparency = 1
			return Part
		end)(),
	},
}

function Visualizer:Destroy()
	for i, Child in pairs(self.Instances) do
		Child:Destroy()
	end
	for i, Child in pairs(self.Defaults) do
		Child:Destroy()
	end
	self.Parent:Destroy()
	return true
end

function Visualizer:CreateCircle(Radius)
	local BeamParent = self.Defaults.Part:Clone()
	BeamParent.Parent = self.Parent

	local Attach1 = Instance.new("Attachment")
	Attach1.Name = "1"
	Attach1.CFrame = CFrame.new(0, 0, Radius)
	Attach1.Parent = BeamParent

	local Attach2 = Instance.new("Attachment")
	Attach2.Name = "2"
	Attach1.CFrame = CFrame.new(0, 0, -Radius)
	Attach2.Parent = BeamParent

	local Beam1 = self.Defaults.Beam:Clone()
	Beam1.Attachment0 = Attach2
	Beam1.Attachment1 = Attach1
	Beam1.CurveSize0 *= Radius
	Beam1.CurveSize1 *= Radius
	Beam1.Parent = BeamParent

	local Beam2 = self.Defaults.Beam:Clone()
	Beam2.Attachment0 = Attach2
	Beam2.Attachment1 = Attach1
	Beam2.CurveSize0 *= -Radius
	Beam2.CurveSize1 *= -Radius
	Beam2.Parent = BeamParent

	self.Instances[HttpService:GenerateGUID()] = BeamParent
	return BeamParent
end

return Visualizer
