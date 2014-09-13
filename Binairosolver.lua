--HerrSubset's Binairo solver

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--defining global variables
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--implementing functions
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--prints a welcome message
local function printWelcomeMessage()
	print("Welcome to HerrSubset's binairo solver.")
end


--asks the user for the size of the matrix he/she will enter
local function getMatrixSize()
	print("\nEnter the number of rows of the playing field:")
	input = io.read("*line")
	size = tonumber(input)

	if size == nil then
		error("What you entered was not a number")
	end

	return size
end


--takes a line of the matrix that was entered by the user
--and converts it to an array of characters
local function buildLine(inputLine, linelength)
	res = {}

	for i=1, linelength do
		res[i] = string.sub(inputLine, i,i)
	end

	return res
end


--prompts the user to enter the lines in the binairo. These
--lines are given to the buildLine function who returns
--arrays. These arrays are put in a matrix and returned.
local function buildMatrix(size)
	print("\nEnter the lines of the binairo you would like to be solved.")
	print("Enter line by line, using a space for open cells.")

	local matrix = {}

	for i=1, size do
		print("Enter line " .. i .. ":\t")
		input = io.read("*line")

		--TODO checks on input

		if string.len(input) == size then
			line = buildLine(input, size)
		else
			error("line entered has wrong length")
		end

		matrix[i] = line
	end

	return matrix
end


--Prints the matrix
local function printMatrix(matrix, matrixSize)
	print("")

	for i=1, matrixSize do
		local row = matrix[i]
		local line = ""
		for j=1, matrixSize do
			line = line .. row[j]
		end
		print(line)
	end
end


--copies a row from the given matrix into a new row so it can be used
--for manipulation
local function getRowFromMatrix(matrix, row, size)
	res = {}

	for i=1, size do
		res[i] = matrix[row][i]
	end

	return res
end


--extracts a column from the given matrix into a row so that it can be
--used more easily for manipulation
local function getColumnFromMatrix(matrix, column, size)
	res = {}

	for i=1,size do
		res[i] = matrix[i][column]
	end

	return res
end


--replaces a cetrain row in the given matrix by a given row
local function replaceRow(row, rowNumber, originalMatrix, length)
	res = originalMatrix

	for i=1, length do
		res[rowNumber][i] = row[i]
	end

	return res
end


--replaces a certain column in the given matrix by a given column
local function replaceColumn(column, colNumber, originalMatrix, length)
	res = originalMatrix

	for i=1, length do
		res[i][colNumber] = column[i]
	end

	return res
end


--counts the amount of open cells in the matrix
local function countOpenCells(matrix,size)
	res = 0

	for i=1, size do
		for j=1, size do
			if (matrix[i][j] ~= "1") and (matrix[i][j] ~= "0") then
				res = res + 1
			end
		end
	end

	return res
end


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--implementing algorithmes
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--Calculates the amount of 0's and 1's in a row. If the count of either
--one of those equals the rowlength/2, the empty cells are filled in with
--the other number
local function fillInMissing(row, length)
	local count1 = 0
	local count0 = 0
	local filler = "."
	local res = row

	for i=1,length do
		if res[i] == "0" then
			count0 = count0 + 1
		elseif res[i] == "1" then
			count1 = count1 + 1
		end
	end

	if count1 == (length/2) then
		filler = "0"
	elseif count0 == (length/2) then
		filler = "1"
	end

	for i=1,length do
		if res[i] ~= "1" and res[i] ~= "0" then
			res[i] = filler
		end
	end

	return res
end

--Helper function to place a character at a given index in a row.
--Checks if the character is placed within bounds of the row and returns
--the adjusted row.
local function placeAtIndex(char, index, row, rowlength)
	local res = row

	if (index >= 0) and (index <= rowlength) then
		if (res[index] ~= "0") and (res[index] ~= "1") then
			res[index] = char
		end
	end

	return res
end


--checks for 2 identical numbers appearing next to eachother and places
--the other number around it, if not filled in already. Calls the 
--"placeAtIndex" function to do the actual placement
local function doubleNumber(row, length)
	local res = row

	for i=1, length-1 do
		if (row[i] == row[i+1]) then
			if row[i] == "1" then
				res = placeAtIndex("0", i-1, res, length)
				res = placeAtIndex("0", i+2, res, length)
			elseif row[i] == "0" then
				res = placeAtIndex("1", i-1, res, length)
				res = placeAtIndex("1", i+2, res, length)
			end
		end
	end

	return res
end


--function that calls all the heuristics implemented above
local function solveRow(row, length)
	row = doubleNumber(row, length)
	row = fillInMissing(row, length)

	return row
end



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--implementing main loop
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

printWelcomeMessage()

local go = false
local size = getMatrixSize()

local matrix = buildMatrix(size)

print("\nEntered:")
printMatrix(matrix, size)

if matrix ~= nil then
	go = true
end

local openCells = countOpenCells(matrix,size)
--call the algorithmes until they don't complete the matrix any further
while go do

	for i=1, size do
		local row = getRowFromMatrix(matrix, i, size)
		row = solveRow(row,size)
		matrix = replaceRow(row, i, matrix, size)

		local column = getColumnFromMatrix(matrix,i,size)
		column = solveRow(column,size)
		matrix = replaceColumn(column, i, matrix, size)

	end

	--check if going through the algorithmes another time makes sense
	local tmpOpenCells = countOpenCells(matrix,size)
	if (tmpOpenCells == openCells) or (tmpOpenCells == 0) then
		go = false
	else
		openCells = tmpOpenCells
	end
end

print("\nEnd result:")
printMatrix(matrix, size)
print("Thanks for using this program.")