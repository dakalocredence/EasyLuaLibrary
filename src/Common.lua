---
--- EasyLua Common Functions.
--- Provides functions for easily manipulating lua tables to ease development.
--- Created by Dakalo.
---

local common = {};

-- COMMON CONSTANTS

---
--- Sort data in ascending order.
--- Use this sort function with any sorting functionality in this library
--- @param value1 any The first value
--- @param value2 any The second value
--- @return boolean True if these values should be sorted.
---
function common.SORT_ASC(value1, value2)
    return value1 > value2
end

---
--- Sort data in descending order.
--- Use this sort function with any sorting functionality in this library
--- @param value1 any The first value
--- @param value2 any The second value
--- @return boolean True if these values should be sorted.
---
function common.SORT_DESC(value1, value2)
    return value1 < value2
end

---
--- Sort data in random order.
--- Use this sort function with any sorting functionality in this library
--- Use math.randomseed to get better random results.
--- @return boolean True if these values should be sorted.
---
function common.SORT_RANDOM()
    return math.random(10) > 5
end


-- COMMON TABLES

---
--- Reliably count the number of elements in the table.
--- The method will return 0 for any type other than table.
--- @param table table The table to count.
--- @return number The number of elements in the table.
---
function common.table_count(table)
    if type(table) ~= 'table' then return 0 end
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end

---
--- Determine whether the table is an array.
--- An array table is one that is fully numerically indexed
--- and its indexes must be contiguous, starting from index 1.
--- The method will return false for any type other than table.
--- @param table table The table to check
--- @return boolean True if the table is an array.
---
function common.table_is_array(table)
    if type(table) ~= 'table' then return false end
    local prev = 0
    for key, _ in pairs(table) do
        if type(key) ~= 'number' or key-1 ~= prev then return false end
        prev = key
    end
    return true
end

---
--- Iterate over the table using a function.
--- @param table table The table to iterate over
--- @param callback function The callback function used over the table entries.
--- If the callback is not a function then a default function is used which
--- simply prints the key and the value.
--- The callback signature is function(key, value).
---
function common.table_for_each(table, callback)
    if type(table) ~= 'table' then return end
    if type(callback) ~= 'function' then callback = function(key, value)
        print(tostring(key)..'=>'..tostring(value))
    end end
    for key, value in pairs(table) do
        callback(key, value)
    end
end

---
--- Check if the table contains the specified value.
--- @param table table The table to check in.
--- @param value any The value to search for.
--- @return boolean, any|nil True if found and the key where it is found.
---
function common.table_contain_value(table, value)
    if type(table) ~= 'table' then return false, nil end
    for i,v in pairs(table) do
        if v == value then return true, i end
    end
    return false, nil
end

---
--- Check if the table contains the specified key.
--- @param table table The table to check in.
--- @param key any The key to search for.
--- @return boolean True if found
---
function common.table_contains_key(table, key)
    if type(table) ~= 'table' then return false end
    for i,_ in pairs(table) do
        if i == key then return true end
    end
    return false
end

---
--- Retrieve all the keys in this table
--- @param table table The table to fetch keys from
--- @return table An new array table with all the keys.
---
function common.table_keys(table)
    local bag = {}
    if type(table) ~= 'table' then return bag end
    for k,_ in pairs(table) do
        bag[#bag + 1] = k
    end
    return bag
end

---
--- Retrieve all the values in this table.
--- This function creates a new array table with the values from the given table.
--- @param table table The table to fetch values from.
--- @return table A new array table with all the values.
---
function common.table_values(table)
    local bag = {}
    if type(table) ~= 'table' then return bag end
    for _, v in pairs(table) do
        bag[#bag + 1] = v
    end
    return bag
end

---
--- Create a new array table.
--- If length is not a number or is a number less than 1 then an empty table is returned.
--- @param length number The length of the new table.
--- @param initial_value any The value to fill the table with
--- @return table The created new array table
---
function common.table_create_array(length, initial_value)
    local bag = {}
    if type(length) ~= 'number' or length < 1 or initial_value == nil then return bag end
    for _ = 1,length do
        bag[#bag + 1] = initial_value
    end
    return bag
end

---
--- Combine two tables into one table.
--- When the table is an array it will be re-indexed.
--- When table is not an array then the second table's keys will overwrite the first.
--- @param table_1 table The first table
--- @param table_2 table The second table
--- @return table The resulting new combined table.
function common.table_combine(table_1, table_2)
    local bag = {}
    if type(table_1) ~= 'table' or type(table_2) ~= 'table' then return nil end
    local isArrayTable = common.table_is_array(table_1)
    for k,v in pairs(table_1) do
        if isArrayTable then
            bag[#bag + 1] = v
        else
            bag[k] = v
        end
    end
    isArrayTable = common.table_is_array(table_2)
    for k,v in pairs(table_2) do
        if isArrayTable then
            bag[#bag + 1] = v
        else
            bag[k] = v
        end
    end
    return bag
end

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
    local bag = {}
    if type(table_1) ~= 'table' or type(table_2) ~= 'table' then return nil end
    local isArrayTable = common.table_is_array(table_1) and common.table_is_array(table_2)
    for k1, v1 in pairs(table_1) do
        if isArrayTable then
            for _,v2 in ipairs(table_2) do
                if v1 == v2 then bag[#bag + 1] = v2 break end
            end
        else
            for k2,v2 in pairs(table_2) do
                if k1==k2 and v1==v2 then bag[k2] = v2 break end
            end
        end
    end
    return bag
end

---
--- Exchange the keys with the associated values in the table.
--- @param table table The table to extract from.
--- @return table A new table with its keys and values exchanged.
---
function common.table_flip(table)
    local bag = {}
    if type(table) ~= 'table' then return bag end
    for k,v in pairs(table) do
        bag[v] = k
    end
    return bag
end

---
--- Rearrange all entries from the table in reverse order.
--- Only applies to an array table.
--- @param table table The table to rearrange.
--- @return table A new rearranged table.
---
function common.table_reverse(table)
    local bag = {}
    if not common.table_is_array(table) then return bag end
    for i = #table, 1, -1 do
        bag[#bag + 1] = table[i]
    end
    return bag
end

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
    if not common.table_is_array(table) then return table end
    if type(sort_function) ~= 'function' then sort_function = common.SORT_ASC end
    local temp
    local tableCount = common.table_count(table)
    for x = 1,tableCount do
        for y = x+1,tableCount do
            if sort_function(table[x], table[y]) then
                temp = table[x]
                table[x] = table[y]
                table[y] = temp
            end
        end
    end
    return table
end

---
--- Perform a shallow copy of the given table.
--- If the table is an array then value order is preserved.
--- @param table table The table to create a copy of.
--- @return table A new table instance which is a copy of the given table.
---
function common.table_copy(table)
    local bag = {}
    if common.table_is_array(table) then
        for _,v in ipairs(table) do bag[#bag+1] = v end
    else
        for k,v in pairs(table) do bag[k] = v end
    end
    return bag
end

---
--- Provides the ability to push a value at the end of an array table as in a queue.
--- Only works with array tables.
--- Warning: This method modifies the provided table.
--- @param table table The table to push a value into.
--- @param value any The value to add.
--- @return boolean True if successful.
---
function common.table_push(table, value)
    if not common.table_is_array(table) then return false end
    table[#table+1] = value
    return true
end

---
--- Provides the ability to pop a value at the end of an array table as in a queue.
--- Only works with array tables.
--- Warning: This method modifies the provided table.
--- @param table table The table to pop a value from.
--- @return any The value removed from the end of the array table or nil if no more values can be removed.
---
function common.table_pop(table)
    if not common.table_is_array(table) then return nil end
    local v = table[#table]
    table[#table] = nil
    return v
end




return common;