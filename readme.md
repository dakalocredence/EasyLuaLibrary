# EasyLua Library

Provides functions for manipulating lua tables with ease to aid development. 
Completely written in Lua and inspired by standard libraries in languages such as PHP and Java.

## Introduction

To use the library simply copy the Common.lua (located in the src folder) file to your working directory then use 
the following code
```lua
local common = require('Common')


local building = {manager = 'John', price = 256850.25, size = 250}
common.table_for_each(building)
```

### Documentation

The library categorizes a lua table into two
- An array table - only contains integer keys which are contagious starting from 1 and has no gaps.
- An ordinary table - can be any other form of a lua table which does not satisfy the definition of an array table.

Most of the functions in the library takes the above categorization into consideration such that an array table
is treated as an ordered collection while ordinary table is treated unordered. This means the functions will
respect the order of the values where possible.

```lua

---
--- Reliably count the number of elements in the table.
--- The method will return 0 for any type other than table.
--- @param table table The table to count.
--- @return number The number of elements in the table.
---
function common.table_count(table) do end

---
--- Determine whether the table is an array.
--- An array table is one that is fully numerically indexed
--- and its indexes must be contiguous, starting from index 1.
--- The method will return false for any type other than table.
--- @param table table The table to check
--- @return boolean True if the table is an array.
---
function common.table_is_array(table)

---
--- Iterate over the table using a function.
--- @param table table The table to iterate over
--- @param callback function The callback function used over the table entries.
--- If the callback is not a function then a default function is used which
--- simply prints the key and the value.
--- The callback signature is function(key, value).
---
function common.table_for_each(table, callback)

---
--- Check if the table contains the specified value.
--- @param table table The table to check in.
--- @param value any The value to search for.
--- @return boolean, any|nil True if found and the key where it is found.
---
function common.table_contain_value(table, value)

---
--- Check if the table contains the specified key.
--- @param table table The table to check in.
--- @param key any The key to search for.
--- @return boolean True if found
---
function common.table_contains_key(table, key)

---
--- Retrieve all the keys in this table
--- @param table table The table to fetch keys from
--- @return table An new array table with all the keys.
---
function common.table_keys(table)

---
--- Retrieve all the values in this table.
--- This function creates a new array table with the values from the given table.
--- @param table table The table to fetch values from.
--- @return table A new array table with all the values.
---
function common.table_values(table)

---
--- Create a new array table.
--- If length is not a number or is a number less than 1 then an empty table is returned.
--- @param length number The length of the new table.
--- @param initial_value any The value to fill the table with
--- @return table The created new array table
---
function common.table_create_array(length, initial_value)

---
--- Combine two tables into one table.
--- When the table is an array it will be re-indexed.
--- When table is not an array then the second table's keys will overwrite the first.
--- @param table_1 table The first table
--- @param table_2 table The second table
--- @return table The resulting new combined table.
function common.table_combine(table_1, table_2)

---
--- Compare two tables and extract the matching entries.
--- If both tables are arrays then their indexes are ignored and their values are compared.
--- If at least one of the tables is not an array then both the key and the value are compared.
--- Note: If both tables were arrays the order of the results is preserved in the new array.
--- @param table_1 table The first table
--- @param table_2 table The second table
--- @return table A new table containing matching entries from both tables.
---
function common.table_intersect(table_1, table_2)

---
--- Exchange the keys with the associated values in the table.
--- @param table table The table to extract from.
--- @return table A new table with its keys and values exchanged.
---
function common.table_flip(table)

---
--- Rearrange all entries from the table in reverse order.
--- Only applies to an array table.
--- @param table table The table to rearrange.
--- @return table A new rearranged table.
---
function common.table_reverse(table)

---
--- Sort the values in the given table according to the sort function provided.
--- Built in sort functions are common.SORT_ASC, common.SORT_DESC and common.SORT_RANDOM
--- By default if no sort function is provided then common.SORT_ASC is used.
--- This method only works on array tables, any type other than an array table will result in the provided
--- instance being returned unchanged
--- Warning: This method modifies the provided table without creating a copy.
--- @param table table The table to sort
--- @param sort_function function The sorting function to use.
--- @return table The instance of the given table.
---
function common.table_sort(table, sort_function)

---
--- Perform a shallow copy of the given table.
--- If the table is an array then value order is preserved.
--- @param table table The table to create a copy of.
--- @return table A new table instance which is a copy of the given table.
---
function common.table_copy(table)


---
--- Provides the ability to push a value at the end of an array table as in a queue.
--- Only works with array tables.
--- Warning: This method modifies the provided table.
--- @param table table The table to push a value into.
--- @param value any The value to add.
--- @return boolean True if successful.
function common.table_push(table, value)


--- 
--- Provides the ability to pop a value at the end of an array table as in a queue.
--- Only works with array tables.
--- Warning: This method modifies the provided table.
--- @param table table The table to pop a value from.
--- @return any The value removed from the end of the array table or nil if no more values can be removed.
function common.table_pop(table)

```
## Examples

Some examples for working with the library.

To print the contents of a table for testing purposes.
```lua
local building = {manager = 'John', price = 256850.25, size = 250}
common.table_for_each(building)
```

This simply prints the key and the value for each item in the table.
> price=>256850.25
>
> manager=>John
>
> size=>250

To check if a value exists in a table
```lua
local building = {manager = 'John', price = 256850.25, size = 250}
print(common.table_contain_value(building, 'John'))
```

This returns a boolean true when found and the key where the value is found
> true	manager

To retrieve all the keys in a table
```lua
local building = {manager = 'John', price = 256850.25, size = 250}
common.table_for_each(common.table_keys(building))
```

> 1=>price
>
> 2=>manager
>
> 3=>size

To join two tables together
```lua
local materials = {'bricks', 'concrete', 'steel'}
local equipment = {'truck', 'crane'}
common.table_for_each(common.table_combine(materials, equipment))
```

> 1=>bricks
>
> 2=>concrete
>
> 3=>steel
>
> 4=>truck
>
> 5=>crane

To search for values from a table inside another table so that the result is only the values that matched both tables

```lua
local materials = {'bricks', 'concrete', 'steel', 'truck'}
local equipment = {'truck', 'crane', 'concrete'}
common.table_for_each(common.table_intersect(materials, equipment))
```

> 1=>concrete
>
> 2=>truck

To sort values in descending order from a table

```lua
local materials = {'concrete', 'truck','steel', 'bricks', 'crane'}
common.table_for_each(common.table_sort(materials, common.SORT_DESC))
```

> 1=>truck
>
> 2=>steel
>
> 3=>crane
>
> 4=>concrete
>
> 5=>bricks