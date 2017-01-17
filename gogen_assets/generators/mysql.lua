-- Simple script to set two tokens to the same random value

for i=1,count do
  local lower = 1000000000
  local upper = 9999999999
  sessionId = math.random(lower, upper)
  setToken("sessionId", sessionId)
  setToken("sessionId2", sessionId)

  l = getLine(0)
  l = replaceTokens(l, nil, false)
  events = { }
  table.insert(events, l)
  send(events)    
end