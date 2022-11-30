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

---
--- Compare two tables checking if they contain the same pair of entries.
--- All keys and values are cast to string through the 'tostring' function.
--- If both tables are array tables then order is respected.
--- @param table_1 table The first table.
--- @param table_2 table The second table.
--- @return boolean True if and only if the both tables have the same pair of entries.
---
function common.table_equals(table_1, table_2)
    if type(table_1) ~= 'table' or type(table_2) ~= 'table' then return false end
    if common.table_count(table_1) ~= common.table_count(table_2) then return false end
    if common.table_is_array(table_1) and common.table_is_array(table_2) then -- array mode
        for i=1,#table_1 do
            if tostring(table_1[i]) ~= tostring(table_2[i]) then return false end
        end
    else -- map mode
        local exists = false
        for k1,v1 in pairs(table_1) do
            exists = false
            for k2, v2 in pairs(table_2) do
                if tostring(k1) == tostring(k2) and tostring(v1) == tostring(v2) then
                    exists = true
                end
            end
            if not exists then return false end
        end
    end
    return true
end

-- COMMON STRING

---
--- A buffer for concatenating multiple strings more efficiently.
--- Contains the methods append and tostring to add multiple strings and later convert this buffer to string.
--- @param initial_string string A string to be added at the start of the buffer.
--- @return table An object instance of the newly created string buffer.
---
function common.string_buffer(initial_string)
    -- construct
    local instance = {}
    instance.table_for_each = common.table_for_each
    if initial_string ~= nil then
        instance.stack = {tostring(initial_string)}
    else
        instance.stack = {''}
    end
    ---
    --- Add a string to the buffer
    --- @param s string The string to add
    --- @return table The instance of this string buffer
    ---
    function instance:append(s)
        s = tostring(s)
        table.insert(self.stack, s)    -- push 's' into the the stack
        for i=table.getn(self.stack)-1, 1, -1 do
            if string.len(self.stack[i]) > string.len(self.stack[i+1]) then
                break
            end
            self.stack[i] = self.stack[i] .. table.remove(self.stack)
        end
        return self
    end
    ---
    --- Convert this string buffer into a string
    --- @return string The final string built from this string buffer
    ---
    function instance:tostring()
        local bag = ''
        self.table_for_each(self.stack, function (_,val) bag = bag .. val end)
        return bag
    end
    return instance;
end

---
--- Checks if the string contains the search string.
--- @param haystack string The string to perform a search in.
--- @param needle string The string to search for.
--- @return boolean,number,number True if found then the start
--- location and end location of the needle in the haystack.
---
function common.string_contains(haystack, needle)
    local begin, finish = string.find(haystack, needle, 0, true)
    if begin ~= nil then
        return true, begin, finish
    end
    return false, 0, 0
end

---
--- Strip whitespace characters from the beginning and end of a string.
--- @param target string The string to operate on.
--- @return string A new string with whitespace characters removed at the start and end.
---
function common.string_trim(target)
    local i1,i2 = string.find(target,'^%s*')
    if i2 >= i1 then
        target = string.sub(target,i2+1)
    end
    i1,i2 = string.find(target,'%s*$')
    if i2 >= i1 then
        target = string.sub(target,1,i1-1)
    end
    return target
end

---
--- Split the string into a table using the given delimiter.
--- @param target string The target string.
--- @param delimiter string The pattern or string marking the separation points.
--- @return table A table containing strings around the delimiter or pattern match.
---
function common.string_split(target, delimiter)
    local bag = {}
    for item in string.gmatch(target, '[^'..delimiter..']+') do
        bag[#bag+1] = item
    end
    return bag
end

---
--- Concatenate the values of the given table using the provided delimiter.
--- If the provided table is not a table type then nil is returned.
--- If the table is an array table then order will be respected otherwise the table
--- values are concatenated as is ignoring the keys.
--- If the delimiter is not a string then an empty string is used instead.
--- @param table table The table to operate on.
--- @param delimiter string The string to separate the table values.
--- @return string The concatenated values of the given table using provided delimiter
---
function common.string_join(table, delimiter)
    if type(table) ~= 'table' then return nil end
    if common.table_count(table) <= 1 then
        for _,val in pairs(table) do return val end
        return ''
    end
    local sb = common.string_buffer()
    if type(delimiter) ~= 'string' then delimiter = '' end
    if common.table_is_array(table) then
        for index, val in ipairs(table) do
            sb:append(val)
            if index ~= #table then sb:append(delimiter) end
        end
    else
        for _,val in pairs(table) do
            sb:append(val):append(delimiter)
        end
        local bag = sb:tostring()
        return string.sub(bag, 0, string.len(bag)-1)
    end
    return sb:tostring()
end

---
--- Retrieve a single character from the input which is in the given index.
--- The index must be a positive number and also it must be less than or equal to
--- the input length otherwise an empty string is returned.
--- @param input string The input string.
--- @param index number The index where the character is located.
--- @return string A string containing a single character.
---
function common.string_char_at(input, index)
    if type(input) ~= 'string' then return nil end
    if type(index) ~= 'number' or index < 1 or index > string.len(input) then return '' end
    return string.sub(input, index, index)
end

---
--- Searches the haystack for the needle and the replaces it with replacement a number of times provided.
--- By default replacement is done throughout the entire string unless times is provided.
--- @param haystack string The string to search in.
--- @param needle string The string to search for.
--- @param replacement string The replacement string
--- @param times number Optional, the number of times to replace the needle if it occurs more than once.
--- @return string, number A new string with all replacement operations performed and the number of replacements performed.
---
function common.string_replace(haystack, needle, replacement, times)
    haystack = tostring(haystack)
    needle = tostring(needle)
    replacement = tostring(replacement)
    return string.gsub(haystack, needle, replacement, times)
end

---
--- Modify the target string such that the replacement string overwrites the contents of the target string
--- starting from the start index.
--- If the replacement string length exceeds the length of the target string when replacement occurs
--- then the string is expanded to accommodate the replacement string.
--- @param target string The target string.
--- @param replacement string The replacement string.
--- @param start_index number The index where to begin replacement on the target string.
--- @return string The updated string
---
function common.string_update(target, replacement, start_index)
    target = tostring(target)
    replacement = tostring(replacement)
    if type(start_index) ~= 'number' or start_index < 1 then start_index = 1 end
    local prefix = string.sub(target, 1, start_index-1)
    local suffix = string.sub(target, start_index+string.len(replacement))
    return prefix .. replacement ..suffix
end

-- COMMON SYSTEM

---
--- Get the name of the current operating system.
--- This method resolves to either 'unix' or 'windows'
--- @return string The name of the operating system.
---
function common.system_name()
    local sep = package.config:sub(1,1)
    if sep == '/' then return 'unix' end
    if sep == '\\' then return 'windows' end
    return nil
end

---
--- Read one line from standard input.
--- The output of the prompt will not add a new line feed.
--- @param prompt string The text to display before accepting input.
--- @return string The read string
---
function common.system_read_line(prompt)
    prompt = tostring(prompt)
    io.stdout:write(prompt)
    io.stdout:flush()
    return io.stdin:read()
end

---
--- Execute a command in the current operating system.
--- @param command string The command to execute
--- @return string The resulting string produced by the execution
---
function common.system_execute(command)
    local handle = io.popen(command)
    local result = handle:read('*all')
    handle:close()
    return result
end

---
--- Retrieve the current working directory path for the current executing code.
--- @return string The full current working directory path.
---
function common.system_working_dir()
    if common.system_name() == 'windows' then
        return common.system_execute('chdir')
    end
    return common.system_execute('pwd')
end

-- COMMON FILE SYSTEM

---
--- Checks whether a file exists in the file system.
--- Note: does not work on directories
--- @param filename string The path and filename.
--- @return boolean True if file exists.
---
function common.file_exists(filename)
    local f = io.open(filename, 'rb')
    if f then f:close() end
    return f ~= nil
end

---
--- Read all the lines in the file into an array table.
--- Returns an empty table if the file cannot be opened.
--- @param filename string The path and filename.
--- @return table The lines contained in the file.
---
function common.file_read_lines(filename)
    if not common.file_exists(filename) then return {} end
    local lines = {}
    for line in io.lines(filename) do
        lines[#lines + 1] = line
    end
    return lines
end

---
--- Read all the contents of the file into a string.
--- Returns nil if the file cannot be opened.
--- @param filename string The path and filename.
--- @return string The contents of the file.
---
function common.file_read_contents(filename)
    local file = io.open(filename, 'rb')
    if not file then return nil end
    local content = file:read("*all")
    file:close()
    return content
end

---
--- Write the contents of a string into the file.
--- Note: clears the file first before writing.
--- @param filename string The path and filename.
--- @param content string The contents to write.
--- @return boolean True if writing succeeded.
---
function common.file_write(filename, content)
    local file = io.open(filename, 'w')
    if not file then return false end
    content = tostring(content)
    file:write(content)
    file:close()
    return true
end

---
--- Appends the contents of the string into the end of the file.
--- @param filename string The path and filename.
--- @param content string The contents to write.
--- @return boolean True if writing succeeded.
---
function common.file_append(filename, content)
    local file = io.open(filename, 'a')
    if not file then return false end
    content = tostring(content)
    file:write(content)
    file:close()
    return true
end

---
--- The size of the file in bytes.
--- @param filename string The path and filename.
--- @return number The number of bytes.
---
function common.file_size(filename)
    local file = io.open(filename, 'r')
    if not file then return nil end
    return file:seek('end')
end

---
--- Alias for os.remove
---
function common.file_delete(filename)
    return os.remove(filename)
end

---
--- Alias for os.rename
---
function common.file_rename(old_filename, new_filename)
    return os.rename(old_filename, new_filename)
end

---
--- List all the files in the given file path.
--- @param filepath string The path to the directory or directory name.
--- @return table The files in the given path.
---
function common.file_list(filepath)
    if type(filepath) ~= 'string' then return nil end
    if common.system_name() == 'windows' then
        local result = common.system_execute('dir /b '..filepath)
        result = common.string_trim(result)
        return common.string_split(result, '\n')
    else
        local result = common.system_execute('ls '..filepath)
        result = common.string_trim(result)
        return common.string_split(result, '\n')
    end
end

---
--- The file separator for the current operating system.
--- @return string The separator character.
---
function common.file_separator()
    if common.system_name() == 'windows' then return '\\' end
    return '/'
end

---
--- Writes a table into a properties file.
--- Note: The implementation lacks many of properties file specifications.
--- The table values must be of one of type string, number or boolean, any
--- other type will be ignored.
--- The comments can be a string each new line representing a new line of comments or
--- a table where each value represent a new line of comments, comments as an array
--- table will respect the order of the values.
--- All Comments are written at the beginning of the file.
--- @param filename string The filename to save the contents.
--- @param input_table table The table containing the data to save.
--- @param comments string|table The comments for the file.
--- @return boolean True if operation succeeded.
---
function common.prop_write(filename, input_table, comments)
    local buffer = common.string_buffer()
    -- comments
    local clines
    if type(comments) == 'string' then
       clines = common.string_split(comments, '\n')
    end
    if type(comments) == 'table' then clines = common.table_values(comments) end
    if clines then
        for _,val in ipairs(clines) do
            buffer:append('# '..val..'\n')
        end
    end
    for key,val in pairs(input_table) do
        -- key
        local valid_key = type(key) == 'string' or type(key) == 'number'
        if valid_key then
            key = string.gsub(key, '%s', '')
            buffer:append(common.string_trim(key))
        end
        -- value
        local valid_value = type(val) == 'string' or type(val) == 'number' or type(val) == 'boolean'
        val = tostring(val)
        if valid_key and valid_value then
            val = common.string_trim(val)
            val = common.string_replace(val, '\n', '')
            buffer:append('=')
            buffer:append(val)
        end
        -- line ending
        if valid_key then buffer:append('\n') end
    end
    return common.file_write(filename, buffer:tostring())
end

---
--- Read a properties file into a table.
--- Note: The implementation lacks many of properties file specifications.
--- The comments will be collected in a separate table, all comments in the
--- file will be included regardless of their position in the file.
--- Keys without values will be assigned an empty string.
--- @param filename string The filename to read contents from.
--- @return table, table The properties read from the file into key value pairs and
--- the comments found in the file.
---
function common.prop_read(filename)
    local prop_table = {}
    local comments = {}
    local file = common.file_read_lines(filename)
    for _, line in ipairs(file) do
        if common.string_char_at(line, 1) == '#' then
            line = common.string_update(line, ' ', 1)
            line = common.string_trim(line)
            comments[#comments + 1] = line
        else
            line = common.string_trim(line)
            local sepval, seploc = common.string_contains(line, '=')
            if not sepval and line then
                prop_table[line] = ''
            else
                local key = string.sub(line, 1, seploc-1)
                local val = string.sub(line, seploc+1)
                key = common.string_trim(key)
                val = common.string_trim(val)
                prop_table[key] = val
            end
        end
    end
    return prop_table, comments
end

-- COMMON IP (HTTP, FTP, ETC)

---
--- Execute a URL and capture the result in a string.
--- Warning: requires cURL software to be installed on the machine.
--- Supports SSL secured connections.
--- @param url string The full URL.
--- @param post_data table Optional: POST data to include in the body of the request.
--- @return string The response from the server
---
function common.http_execute(url, post_data)
    local post_buffer = common.string_buffer()
    if post_data ~= nil then
        for key,val in pairs(post_data) do
            post_buffer:append('-d "'..key..'='..val..'" ')
        end
    end
    return common.system_execute('curl -s '..post_buffer:tostring()..' "'..url..'"')
end

---
--- Download a file into the local system from a URL.
--- Warning: requires cURL software to be installed on the machine.
--- @param url string The full URL
--- @param destination_file string The filename and path where the downloaded file will be stored.
--- @param post_data table Optional: POST data to include in the body of the request.
--- @return string
---
function common.http_file_download(url, destination_file, post_data)
    local post_buffer = common.string_buffer()
    if type(post_data) == 'table' then
        for key,val in pairs(post_data) do
            post_buffer:append('-d "'..key..'='..val..'" ')
        end
    end
    return common.system_execute('curl -s '..post_buffer:tostring()..' -o "'
            ..destination_file..'" "'..url..'"')
end

---
--- Upload a file from the local system to a URL.
--- Warning: requires cURL software to be installed on the machine.
--- @param url string The full URL
--- @param key string The POST request body input/key name for the file.
--- @param source_file string The filename and path to an existing file which will be uploaded.
--- @return string
---
function common.http_file_upload(url, key, source_file)
    return common.system_execute('curl -s '..' -F "'
            ..key..'=@'..source_file..'" "'..url..'"')
end

-- COMMON DATE TIME

-- COMMON JSON



return common;