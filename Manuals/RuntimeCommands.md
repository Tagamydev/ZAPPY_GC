Great! Here's a complete breakdown of **all the live update commands** your **graphic client** may receive from the server **after initialization**, based on the Zappy (Zappy-like) protocol.

---

## 📡 **LIVE UPDATE COMMANDS**

These commands update the game world **in real time** after initialization.

---

### ### 🔄 **Map and Inventory Updates**

#### `bct X Y q0 q1 q2 q3 q4 q5 q6`

> Tile content has changed.

**Example:**

```
bct 4 4 1 0 1 0 0 1 0
```

→ Tile (4,4) now has:

* 1 food
* 1 Deraumère
* 1 Phiras

---

#### `pin #n X Y q0 q1 q2 q3 q4 q5 q6`

> Player inventory has changed.

**Example:**

```
pin 1 2 2 3 0 0 0 0 1 0
```

→ Player 1 is at (2,2) and now holds:

* 3 food
* 1 Phiras

---

### 🧍 **Player Events**

#### `ppo #n X Y O`

> Player has moved or turned.

**Example:**

```
ppo 1 3 5 2
```

→ Player 1 is at (3,5), facing East.

---

#### `plv #n L`

> Player leveled up.

**Example:**

```
plv 1 2
```

→ Player 1 reached level 2.

---

#### `pex #n`

> Player expelled others (used the *kick* action).

**Example:**

```
pex 3
```

→ Player 3 performed an expulsion.

---

#### `pgt #n i`

> Player picked up a resource.

**Example:**

```
pgt 2 1
```

→ Player 2 picked up Linemate (resource 1).

---

#### `pdr #n i`

> Player dropped a resource.

**Example:**

```
pdr 2 1
```

→ Player 2 dropped Linemate.

---

#### `pbc #n M`

> Player broadcasted a message.

**Example:**

```
pbc 4 Hello there!
```

→ Player 4 shouted “Hello there!”

---

#### `pdi #n`

> Player died of hunger.

**Example:**

```
pdi 6
```

→ Player 6 has died.

---

### 🔮 **Incantations (Level Up Rituals)**

#### `pic X Y L #n #n ...`

> Incantation started on tile (X, Y) at level L by players.

**Example:**

```
pic 2 2 2 1 3 4
```

→ An incantation is starting at (2,2) for level 2, involving players 1, 3, and 4.

---

#### `pie X Y R`

> Incantation result.

**Example:**

```
pie 2 2 1
```

→ Incantation at (2,2) succeeded (1 = success, 0 = fail).

---

### 🥚 **Egg Events (Forking and Spawning)**

#### `pfk #n`

> Player is forking (laying an egg).

**Example:**

```
pfk 1
```

→ Player 1 initiated egg-laying.

---

#### `enw #e #n X Y`

> A new egg was laid.

**Example:**

```
enw 7 1 4 3
```

→ Egg 7 laid by player 1 at (4,3).

---

#### `eht #e`

> Egg hatched.

**Example:**

```
eht 7
```

→ Egg 7 hatched.

---

#### `ebo #e`

> A player has connected using an egg.

**Example:**

```
ebo 7
```

→ Player connected using egg 7.

---

#### `edi #e`

> Egg died (was not used in time).

**Example:**

```
edi 7
```

→ Egg 7 has died (expired).

---

### 🏁 **Game State / System Events**

#### `sgt T`

> Current time unit (used for adjusting animation pacing, etc.)

```
sgt 100
```

→ 1 unit of time = 100 ms

---

#### `sst T`

> Time unit has been modified.

**Example:**

```
sst 80
```

→ Time unit changed to 80 ms

---

#### `seg N`

> End of game — team `N` wins.

```
seg RedTeam
```

→ Game over, "RedTeam" wins!

---

#### `smg M`

> Server message (chat, info, debug).

```
smg The game will restart in 60 seconds. 
```

---

#### `suc`

> Unknown command (error feedback).

#### `sbp`

> Bad parameters for a valid command.

---

## 🎯 Summary Table

| Command | Meaning                         |
| ------- | ------------------------------- |
| `bct`   | Tile content update             |
| `pin`   | Player inventory update         |
| `ppo`   | Player position/orientation     |
| `plv`   | Player level up                 |
| `pex`   | Player expulsion (kick)         |
| `pgt`   | Player picks up item            |
| `pdr`   | Player drops item               |
| `pbc`   | Player broadcasts               |
| `pdi`   | Player dies                     |
| `pic`   | Incantation begins              |
| `pie`   | Incantation ends (success/fail) |


| `pfk`   | Player lays egg                 |
| `enw`   | New egg created                 |
| `eht`   | Egg hatches                     |
| `ebo`   | Player connects via egg         |
| `edi`   | Egg dies                        |



| `sgt`   | Current time unit               |
| `sst`   | Time unit changed               |
| `seg`   | End of game                     |
| `smg`   | Server message                  |
| `suc`   | Unknown command                 |
| `sbp`   | Bad parameters                  |

---

Would you like a **working state manager design** (e.g., data structures) for storing all this in a graphics engine like Godot or Unity/Unreal?
