BinairoSolver
=============

An aid for solving binairo puzzles. It's implemented using heuristics, of which two are implemented so far. You can find an overview of the implemented heuristics further down in this document.

This project is not intended as anything serious. It's merely a little project to keep myself busy and to learn the basics of lua and git.


## Implemented Heuristics
1. Counting all 0's and 1's in a row. If either one of those equals the rowlength/2, you know the remaining open cells can be filled in with the other number.

2. Looking for doubles. If you find two 0's or 1's next to eachother, you know the two cells next to them can be filled in.

## Planned Heuristics
- Filling in the middle one. You can fill in all empty cells surrounded by two of the same numbers.
- Don't allow two equal rows. When a certain row or column has all but two cells filled in, try to find a row or column that has all cells filled in in the same way. If you find one, you know how the row or column must be filled in since no two rows or columns can be identical.