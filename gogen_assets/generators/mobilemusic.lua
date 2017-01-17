-- Utility function for sending an event by line number
function sendEvent(i, choices)
  l = getLine(i)
  if choices == nil then
    l, ret = replaceTokens(l)
  else
    l, ret = replaceTokens(l, choices)
  end
  events = { }
  table.insert(events, l)
  send(events)
  return ret
end

for i=1,count do
  -- Determine whether this transaction is an error
  iserror = math.random()
  errorthreshold = tonumber(options["errorRate"])
  if iserror < errorthreshold then
    cleanup = true
    setToken("httpStatus", "503")
    setToken("userAgent", "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A405 Safari/7534.48.3")
    if math.random() < 0.2 then
        setToken("uri", "GET /sync/addtolibrary/01011207201000005652000000000047")
        setToken("mdn", "5556374832")
    end
  else
    cleanup = false
  end

  -- Setup constant for nanoseconds
  ns = 1000000000

  -- Get length of time for the total transaction
  -- earliest and latest are global variables set by gogen
  -- they are expressed as lua numbers, floating point,
  -- in seconds since epoch at a resolution of nanoseconds
  -- as the fractional second
  transTime = (latest - earliest) * ns
  -- debug("transTime: "..string.format("%.9f", transTime))

  -- Current time offset in the transaction
  currentTimeOffset = 0

  -- Current time since epoch
  currentTimeAbsolute = earliest
  -- debug("currentTimeAbsolute: "..string.format("%.3f", currentTimeAbsolute))

  -- Variable to hold the results from replaceTokens
  choices = nil

  -- Time left in our transaction
  timeLeft = transTime

  -- For each iteration, update offsets and absolute time
  -- and decrease the amount of time we have left
  for i=0,2 do
      nextTimeOffset = math.random(0, timeLeft)
      nextTimeAbsolute = currentTimeAbsolute + (nextTimeOffset/ns)
      -- debug("nextTimeOffset: "..string.format("%f", nextTimeOffset))
      -- debug("nextTimeAbsolute: "..string.format("%.9f", nextTimeAbsolute))

      setTime(nextTimeAbsolute)
      choices = sendEvent(i, choices)

      currentTimeOffset = currentTimeOffset + nextTimeOffset
      currentTimeAbsolute = nextTimeAbsolute
      timeLeft = timeLeft - nextTimeOffset
      -- debug("currentTimeOffset: "..string.format("%f", currentTimeOffset))
      -- debug("currentTimeAbsolute: "..string.format("%.9f", currentTimeAbsolute))
      -- debug("timeLeft: "..string.format("%f", timeLeft))
  end

  -- Clean up tokens we might have set
  if cleanup then
    removeToken("httpStatus")
    removeToken("userAgent")
    removeToken("uri")
    removeToken("mdn")
  end
end