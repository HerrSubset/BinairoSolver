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


dom = require "domain"

print("Welcome to HerrSubset's binairo solver.")

--get user input
local size = getMatrixSize()
local matrix = buildMatrix(size)

print("\nEntered:")
printMatrix(matrix, size)

matrix = dom.solve(matrix,size)

print("\nEnd result:")
printMatrix(matrix, size)
