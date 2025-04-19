-- Parker Lanum
-- CMPM 121 - Solitaire
-- 4/18/25

io.stdout:setvbuf("no")

require "card"
require "grabber"

math.randomseed(os.time())

function love.load()
  love.window.setMode(1280,720)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  
  deckImage = love.graphics.newImage("Sprites/deck.png")
  backImage = love.graphics.newImage("Sprites/back.png")
  spadeImage = love.graphics.newImage("Sprites/spade.png")
  clubImage = love.graphics.newImage("Sprites/club.png")
  heartImage = love.graphics.newImage("Sprites/heart.png")
  diamondImage = love.graphics.newImage("Sprites/diamond.png")
  spadeFrame = love.graphics.newImage("Sprites/spadeframe.png")
  clubFrame = love.graphics.newImage("Sprites/clubframe.png")
  heartFrame = love.graphics.newImage("Sprites/heartframe.png")
  diamondFrame = love.graphics.newImage("Sprites/diamondframe.png")  
        
  cardTable = {}
  grabber = GrabberClass:new()
  
  --Create Deck
  for val=1,13 do
    for suit=1,4 do
      table.insert(cardTable, CardClass:new(-260, 100, val, suit, true))
    end
  end
  
  --Fisher-Yates shuffle from lecture notes
  local cardCount = 52
	for i = 1, cardCount do
		local randIndex = math.random(cardCount)
    local temp = cardTable[randIndex]
    cardTable[randIndex] = cardTable[cardCount]
    cardTable[cardCount] = temp
    cardCount = cardCount - 1
	end
  
  tempIndex = 0
  for i=0,6 do
    for j=0,i do
      tempIndex = tempIndex +1
      cardTable[tempIndex].position.x = 240+(i*120)
      cardTable[tempIndex].position.y = 100+(j*60)
      if i~=j then cardTable[tempIndex].shown=false end
    end
  end
  tempIndex=1

--Move the rest of the cards to drawing deck
deck = {}
for i = 29, 52 do
  deck[#deck + 1] = cardTable[i]
end

end

function love.update()
  --print(tostring(#deck - tempIndex))
  
  grabber:update()
  
  checkForMouseMoving()
  
  --update backwards to give topmost cards priority
  for i = #cardTable, 1, -1 do
    local card = cardTable[i]
    card:update()
  end
  
  for index, card in ipairs(cardTable) do
    --grabbing a card brings it to top via draw order
    if card.state == CARD_STATE.GRABBED then
      table.remove(cardTable, index)
      table.insert(cardTable, card)
    end
  end
  
  for index, card in ipairs(deck) do
    if card.state == CARD_STATE.GRABBED then
      table.remove(deck, index)
    end
  end
end

 function love.mousepressed(x, y, button, istouch, presses)
  if button == 1 then
    if x > 60 and x < 160 and y > 100 and y < 240 then
      for _, card in ipairs(deck) do
        card.position.x = -200
      end
      local lap = 2
      if #deck - tempIndex < 0 then
        tempIndex = 1
      end
      
      if tempIndex+3 > #deck then
        lap = #deck - tempIndex
      end
      
      for i=0,lap do
        deck[tempIndex].position.x = 60
        deck[tempIndex].position.y = 300+(40*i)
        deck[tempIndex].shown = true
        tempIndex=tempIndex+1
      end
    end
  end
end

function checkForMouseMoving()
  if grabber.currMousePos == nil then
    return
  end
  
  for _, card in ipairs(cardTable) do
    card:checkHover(grabber)
  end
end

function love.draw()
  love.graphics.setColor(1,1,1,1)
  love.graphics.setFont(love.graphics.newFont(20))
  love.graphics.printf("Click and drag cards from the tableau to the four rightmost piles in ascending order in suit from Ace to King. Cards in the tableau can be moved to each other if they are one rank lower and of the opposite color. Right click newly exposed cards in the tableu to flip them over. New cards can be drawn from the deck on the left, but only take topmost cards that can be used.", 10,10, 1260, "center")
  
  love.graphics.setColor(1,1,1,0.4)
  love.graphics.draw(spadeFrame, 1120, 100)
  love.graphics.draw(clubFrame, 1120, 250)
  love.graphics.draw(heartFrame, 1120, 400)
  love.graphics.draw(diamondFrame, 1120, 550)
  
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(deckImage, 60, 95)
  
  for _, card in ipairs(cardTable) do
    card:draw()
  end
  
  --love.graphics.print("Mouse: " .. tostring(grabber.currMousePos.x) .. ", " .. tostring(grabber.currMousePos.y))
end