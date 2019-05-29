import math

type
  Queue*[N: static int; T] = object of RootObj
    head, tail, depth: int
    body: array[N, T]

proc enqueue*[N, T](q: var Queue[N, T], n: T) {.inline.} =
  q.body[q.tail] = n
  q.tail = floorMod((q.tail + 1), len(q.body))
  q.depth += 1
  if q.depth > len(q.body): 
    raise newException(Exception, "Queue overflow!")

proc dequeue*[N, T](q: var Queue[N, T]): T {.inline.} =
  result = q.body[q.head]
  q.head = floorMod((q.head + 1), len(q.body))
  q.depth -= 1
  if q.depth < 0:
    raise newException(Exception, "Queue underflow!")

when isMainModule:
  const length: int = 10
  var q: Queue[length, int]
  assert q.head == 0
  assert q.tail == 0
  assert q.depth == 0

  for i in 1..length:
    q.enqueue i
  assert q.depth == length
  assert q.body == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  assert q.dequeue == 1
  assert q.dequeue == 2
  assert q.dequeue == 3
  assert q.depth == length - 3

  try:
    for i in 1..length:
      q.enqueue i
  except:
    let e = getCurrentException()
    assert e.msg == "Queue overflow!"
  
  try:
    for i in 0..length:
      discard q.dequeue
  except:
    let e = getCurrentException()
    assert e.msg == "Queue underflow!"
