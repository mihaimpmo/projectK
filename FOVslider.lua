local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local sliderFrame = script.Parent
local sliderButton = sliderFrame:WaitForChild("SliderButton")
local sliderBackground = sliderFrame:WaitForChild("SliderBackground")
local instructionLabel = sliderFrame:WaitForChild("InstructionLabel")

local minSensitivity = 0.1
local maxSensitivity = 3.0

-- Define the positions for min and max sensitivity (0 and 3)
local minPosition = 0.1 -- Example: 10% from the left
local maxPosition = 0.9 -- Example: 90% from the left

local dragging = false

local function updateCameraSensitivity(sensitivity, percentage)
	player.CameraMaxZoomDistance = sensitivity * 50 -- Adjust multiplier as needed
	player.CameraMinZoomDistance = sensitivity * 10 -- Adjust multiplier as needed
	instructionLabel.Text = string.format("FOV: %.0f%%", percentage * 100)
end

sliderButton.MouseButton1Down:Connect(function()
	dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local sliderFrameAbsPos = sliderFrame.AbsolutePosition
		local sliderFrameAbsSize = sliderFrame.AbsoluteSize

		local rawPosition = (input.Position.X - sliderFrameAbsPos.X) / sliderFrameAbsSize.X
		local clampedPosition = math.clamp(rawPosition, minPosition, maxPosition)
		local newSliderPosition = (clampedPosition - minPosition) / (maxPosition - minPosition)

		sliderButton.Position = UDim2.new(clampedPosition, 0, sliderButton.Position.Y.Scale, sliderButton.Position.Y.Offset)

		local newSensitivity = minSensitivity + (newSliderPosition * (maxSensitivity - minSensitivity))
		updateCameraSensitivity(newSensitivity, newSliderPosition)
	end
end)
