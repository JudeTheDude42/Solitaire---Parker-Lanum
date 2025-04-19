
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  HOVER = 1,
  HELD = 2
}

function CardClass:new(xPos, yPos, value, suit, shown)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(100, 140)
  card.state = CARD_STATE.IDLE
  
  card.value = value
  card.suit = suit
  card.shown = shown
  
  return card
end



grabby = false
function CardClass:update()
  if self.state == CARD_STATE.HOVER and love.mouse.isDown(2) then
    self.shown = true
  end
  
  if self.state == CARD_STATE.HOVER and love.mouse.isDown(1) and grabby == false and self.shown then
    self.state = CARD_STATE.GRABBED
    grabby = true
  end
  
  if self.state == CARD_STATE.GRABBED and love.mouse.isDown(1) then
    local mousePos = grabber.currMousePos
    self.position.x = mousePos.x-50
    self.position.y = mousePos.y-70
  end
  
  if self.state == CARD_STATE.GRABBED and not love.mouse.isDown(1) then
    self.state = CARD_STATE.HOVER
    grabby = false
  end
  
end



function CardClass:draw()
  values = {'A','2','3','4','5','6','7','8','9','10','J','Q','K',}
  suits = {spadeImage, clubImage, heartImage, diamondImage}
  
  if self.shown then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  
    love.graphics.setColor(1,0,0,1)
    if self.suit<3 then love.graphics.setColor(0,0,0,1) end
    love.graphics.setFont(love.graphics.newFont(30))
    love.graphics.printf(values[self.value], self.position.x, self.position.y+5, 50, "center")
    
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(suits[self.suit], self.position.x+10, self.position.y+50)
    love.graphics.draw(suits[self.suit], self.position.x+55, self.position.y+8, 0, 0.4, 0.4)
    
  end
  
  if not self.shown then
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(backImage, self.position.x, self.position.y)
  end
end

function CardClass:checkHover(grabber)
  if self.state == CARD_STATE.GRABBED then
    return
  end
  
  local mousePos = grabber.currMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and mousePos.x < self.position.x+self.size.x and
    mousePos.y > self.position.y and mousePos.y < self.position.y+self.size.y
    
  self.state = isMouseOver and CARD_STATE.HOVER or CARD_STATE.IDLE

end