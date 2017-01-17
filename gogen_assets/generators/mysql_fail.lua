-- Simple script to choose which query and set the time with it

for i=1,count do
  local lower = 1000000000
  local upper = 9999999999
  sessionId = math.random(lower, upper)
  setToken("sessionId2", sessionId)

  if math.random() > .8 then
      setToken("query", "SELECT type, avg(price) FROM customers INNER JOIN orders ON orders.customer_id = customers.customer_id INNER JOIN products ON orders.product_id = products.product_id")
      setToken("transactionSpeed", math.random(30000, 40000))
  else
      setToken("query", "SELECT * FROM customers WHERE customer_id=$customerId$")
      setToken("transactionSpeed", math.random(1000, 2000))
  end

  l = getLine(0)
  l = replaceTokens(l)
  events = { }
  table.insert(events, l)
  send(events)    
end