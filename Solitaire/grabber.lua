
require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.prevMousePos = nil
  grabber.currMousePos = nil
  
  grabber.grabPos = nil
  
  return grabber
end

function GrabberClass:update()
  self.currMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
    )  
  --Click
  if love.mouse.isDown(1) and self.grabPos == nil then
    self:grab()
  end
  if not love.mouse.isDown(1) and self.grabPos then
    self:release()
  end
end

function GrabberClass:grab()
  --print("GRAB at: " .. tostring(self.grabPos))
  self.grabPos = self.currMousePos
end

function GrabberClass:release()
  --print("RELEASE at: " .. tostring(self.grabPos))
  self.grabPos = nil
end

function GrabberClass:draw()
  
end