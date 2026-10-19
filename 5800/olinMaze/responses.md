# PS2: Written responses

Name: Alexandra Chase

NetID: ac3442

Write one short paragraph per question. Use examples from your code and the
supplied maps. Keep the numbered questions and replace each TODO with your answer.

1. **Why track your CornellID?** In the [small Part 2 map](data/test_part_2.txt), why    must the search treat `(2, 4, false)` and `(2, 4, true)` as two states? What can go wrong if the set of discovered states stores only `(row, column)`? Why can a shortest route visit `(2, 4)` twice?

The search must treat those as two distinct states because they are different states. When has_cornell_id is true, we have access to more positions because 'K' and 'D' are not limited, along with states that are only reachable through the 'K' position. 

If we only store row, column with no regard to whether or not we have the id, we will dismiss positions we have already been to without the ID, when revisiting it WITH the id would be beneficial. 

A shortest route could include the same position twice, if once you go through without the key, you might have to come back through later with the key. 

2. **Why use a queue?** Explain why breadth-first search with a first-in,
   first-out queue finds a route with the fewest moves. Would the first route
   found by depth-first search always have the fewest moves? Explain. If some
   moves took longer than others, with all travel times greater than zero,
   which algorithm from Week 4 would find the fastest route? Why?

BFS uses a FIFO queue, so it explores every state one move away, then two moves away, then three moves away, and so on. Therefore, the first time it reaches the exit, it has guaranteed found a route with the fewest moves. DFS follows one branch as far as it can before backtracking, so it almost certainly finds a longer route before a shorter one. If moves have different costs, neither is not enough because the route with the fewest moves may have expensive cost. Dijkstra's algorithm finds the fastest route by expanding the reachable state with the lowest cost, but this is only true for graphs with nonnegative edges. 


3. **How many states can the search discover?** Let `P` be the number of cells
   that are not walls, including `S`, `E`, `K`, and `D`. Give an upper bound,
   in terms of `P`, on the number of states in each part. Why might the search
   reach fewer states than your bound? Consider walls and the CornellID rules.
   Explain why recording a state in the discovered set when adding it to the
   queue prevents the same state from being added twice.

In part one, a state is just a plausible position, so the search can discover at most P states:

P = (pS + p2 + p3 + ... pE)

In part two, the number of states not only depends on the number of plausible positions P, but also DOUBLES it because of has_cornell_id. So it would kind of look like this:

2P = 2 * (pS + p2 + p3 + ... pE)

That is because each state is its own bool var, for which we must account for both the true and false versions of these positions. 
The search may discover fewer because walls and doors can make positions unreachable, For example the keycard rules make some states impossible: a state on a door without the ID is invalid. When a state is discovered, we add it to the discovered set before enqueueing it. If another state can also reach it, it doesn't matter since BFS ensures we already found it in the cheapest num of moves. The set check then prevents it from being enqueued a second time.