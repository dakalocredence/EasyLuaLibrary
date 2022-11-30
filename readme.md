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



To search for values from a table that are present in another table so that the result is only the values that matched both tables

```lua
local materials = {'bricks', 'concrete', 'steel', 'truck'}
local equipment = {'truck', 'crane', 'concrete'}
common.table_for_each(common.table_intersect(materials, equipment))
```

> 1=>concrete
>
> 2=>truck

Remove whitespace from the beginning and the end of a string

```lua
local sample = '  What a beautiful day\n'
print(common.string_trim(sample))
```
> What a beautiful day

To convert a table into a string by joining the values with a delimiter

```lua
local materials = {'concrete', 'truck','steel', 'bricks', 'crane'}
print(common.string_join(materials, ';'))
```

> concrete;truck;steel;bricks;crane

To find out if the current system is windows based or unix based

```lua
print(common.system_name())
```

> windows

To convert and store a lua table into a properties (java) file

```lua
local config = {
    project_name = 'Hello World',
    task_limit = 50,
    installed = true
}
common.prop_write('my_config.properties', config)
```

> project_name=Hello World
>
> task_limit=50
>
> installed=true

To read back the properties (java) file into a lua table

```lua
local config = common.prop_read('my_config.properties')
common.table_for_each(config)
```

> project_name=>Hello World
>
> task_limit=>50
>
> installed=>true

### Documentation

The library categorizes a lua table into two
- An array table - only contains integer keys which are contagious starting from 1 and has no gaps.
- An ordinary table - can be any other form of a lua table which does not satisfy the definition of an array table.

Most of the functions in the library takes the above categorization into consideration such that an array table
is treated as an ordered collection while ordinary table is treated unordered. This means the functions will
respect the order of the values where possible.

##### Lua Table

```lua

---
--- Reliably count the number of elements in the table.
--- The method will return 0 for any type other than table.
--- @param table table The table to count.
--- @return number The number of elements in the table.
---
function common.table_count(table)

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
---
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

---
--- Compare two tables checking if they contain the same pair of entries.
--- All keys and values are cast to string through the 'tostring' function.
--- If both tables are array tables then order is respected.
--- @param table_1 table The first table.
--- @param table_2 table The second table.
--- @return boolean True if and only if the both tables have the same pair of entries.
---
function common.table_equals(table_1, table_2)

```

##### Lua String

```lua

---
--- A buffer for concatenating multiple strings more efficiently.
--- Contains the methods append and tostring to add multiple strings and later convert this buffer to string.
--- @param initial_string string A string to be added at the start of the buffer.
--- @return table An object instance of the newly created string buffer.
---
function common.string_buffer(initial_string)

---
--- Checks if the string contains the search string.
--- @param haystack string The string to perform a search in.
--- @param needle string The string to search for.
--- @return boolean,number,number True if found then the start
--- location and end location of the needle in the haystack.
---
function common.string_contains(haystack, needle)

---
--- Strip whitespace characters from the beginning and end of a string.
--- @param target string The string to operate on.
--- @return string A new string with whitespace characters removed at the start and end.
---
function common.string_trim(target)


---
--- Split the string into a table using the given delimiter.
--- @param target string The target string.
--- @param delimiter string The pattern or string marking the separation points.
--- @return table A table containing strings around the delimiter or pattern match.
---
function common.string_split(target, delimiter)


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

---
--- Retrieve a single character from the input which is in the given index.
--- The index must be a positive number and also it must be less than or equal to
--- the input length otherwise an empty string is returned.
--- @param input string The input string.
--- @param index number The index where the character is located.
--- @return string A string containing a single character.
---
function common.string_char_at(input, index)

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

```
##### Lua System, File Functions and HTTP Functions

```lua

---
--- Get the name of the current operating system.
--- This method resolves to either 'unix' or 'windows'
--- @return string The name of the operating system.
---
function common.system_name()

---
--- Read one line from standard input.
--- The output of the prompt will not add a new line feed.
--- @param prompt string The text to display before accepting input.
--- @return string The read string
---
function common.system_read_line(prompt)

---
--- Execute a command in the current operating system.
--- @param command string The command to execute
--- @return string The resulting string produced by the execution
---
function common.system_execute(command)

---
--- Retrieve the current working directory path for the current executing code.
--- @return string The full current working directory path.
---
function common.system_working_dir()

---
--- Checks whether a file exists in the file system.
--- Note: does not work on directories
--- @param filename string The path and filename.
--- @return boolean True if file exists.
---
function common.file_exists(filename)

---
--- Read all the lines in the file into an array table.
--- Returns an empty table if the file cannot be opened.
--- @param filename string The path and filename.
--- @return table The lines contained in the file.
---
function common.file_read_lines(filename)

---
--- Read all the contents of the file into a string.
--- Returns nil if the file cannot be opened.
--- @param filename string The path and filename.
--- @return string The contents of the file.
---
function common.file_read_contents(filename)

---
--- Write the contents of a string into the file.
--- Note: clears the file first before writing.
--- @param filename string The path and filename.
--- @param content string The contents to write.
--- @return boolean True if writing succeeded.
---
function common.file_write(filename, content)

---
--- Appends the contents of the string into the end of the file.
--- @param filename string The path and filename.
--- @param content string The contents to write.
--- @return boolean True if writing succeeded.
---
function common.file_append(filename, content)

---
--- The size of the file in bytes.
--- @param filename string The path and filename.
--- @return number The number of bytes.
---
function common.file_size(filename)

---
--- Alias for os.remove
---
function common.file_delete(filename)

---
--- Alias for os.rename
---
function common.file_rename(old_filename, new_filename)

---
--- List all the files in the given file path.
--- @param filepath string The path to the directory or directory name.
--- @return table The files in the given path.
---
function common.file_list(filepath)

---
--- The file separator for the current operating system.
--- @return string The separator character.
---
function common.file_separator()

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

---
--- Execute a URL and capture the result in a string.
--- Warning: requires cURL software to be installed on the machine.
--- Supports SSL secured connections.
--- @param url string The full URL.
--- @param post_data table Optional: POST data to include in the body of the request.
--- @return string The response from the server
---
function common.http_execute(url, post_data)

---
--- Download a file into the local system from a URL.
--- Warning: requires cURL software to be installed on the machine.
--- @param url string The full URL
--- @param destination_file string The filename and path where the downloaded file will be stored.
--- @param post_data table Optional: POST data to include in the body of the request.
--- @return string
---
function common.http_file_download(url, destination_file, post_data)

---
--- Upload a file from the local system to a URL.
--- Warning: requires cURL software to be installed on the machine.
--- @param url string The full URL
--- @param key string The POST request body input/key name for the file.
--- @param source_file string The filename and path to an existing file which will be uploaded.
--- @return string
---
function common.http_file_upload(url, key, source_file)

```