@echo off

rmdir /s /q ".\output" 2>NUL
mkdir output

echo Compilation. Please wait...

clang++ .\bubbleSort\bubbleSortCpp\test.cpp -o output\bubbleSortCpp.exe -O3 -D NDEBUG
clang++ .\fibonacciCycle\fibonacciCycleCpp\test.cpp -o output\fibonacciCycleCpp.exe -O3 -D NDEBUG
clang++ .\fibonacciRec\fibonacciRecCpp\test.cpp -o output\fibonacciRecCpp.exe -O3 -D NDEBUG
clang++ .\ip\ipCpp\test.cpp -o output\ipCpp.exe -O3 -D NDEBUG
clang++ .\mergeSort\mergeSortCpp\test.cpp -o output\mergeSortCpp.exe -O3 -D NDEBUG
clang++ .\table\tableCpp\test.cpp -o output\tableCpp.exe -O3 -D NDEBUG

mplc .\bubbleSort\bubbleSortMpl\test.mpl -I .\sl -o "bubbleSortMpl.ll" -ndebug
move .\bubbleSortMpl.ll .\output  > NUL

mplc .\fibonacciCycle\fibonacciCycleMpl\test.mpl -I .\sl -o "fibonacciCycleMpl.ll" -ndebug
move .\fibonacciCycleMpl.ll .\output  > NUL

mplc .\fibonacciRec\fibonacciRecMpl\test.mpl -I .\sl -o "fibonacciRecMpl.ll" -ndebug
move .\fibonacciRecMpl.ll .\output  > NUL

mplc .\ip\ipMpl\test.mpl -I .\sl -o "ipMpl.ll" -ndebug
move .\ipMpl.ll .\output  > NUL

mplc .\mergeSort\mergeSortMpl\test.mpl -I .\sl -o "mergeSortMpl.ll" -ndebug
move .\mergeSortMpl.ll .\output  > NUL

mplc .\table\tableMpl\test.mpl -I .\sl -o "tableMpl.ll" -ndebug
move .\tableMpl.ll .\output  > NUL

clang++ .\output\bubbleSortMpl.ll -o output\bubbleSortMpl.exe -O3 2>NUL
clang++ .\output\fibonacciCycleMpl.ll -o output\fibonacciCycleMpl.exe -O3 2>NUL
clang++ .\output\fibonacciRecMpl.ll -o output\fibonacciRecMpl.exe -O3 2>NUL
clang++ .\output\ipMpl.ll -o output\ipMpl.exe -O3 2>NUL
clang++ .\output\mergeSortMpl.ll -o output\mergeSortMpl.exe -O3  2>NUL
clang++ .\output\tableMpl.ll -o output\tableMpl.exe -O3  2>NUL

echo Compilation successful!

echo 	C++
echo | set /p="BubbleSort:	"
call timecmd ".\output\bubbleSortCpp.exe > NUL"
echo | set /p="fibonacciCycle:	"
call timecmd ".\output\fibonacciCycleCpp.exe > NUL"
echo | set /p="fibonacciRec:	"
call timecmd ".\output\fibonacciRecCpp.exe > NUL"
echo | set /p="ip:		"
call timecmd ".\output\ipCpp.exe > NUL"
echo | set /p="MergeSort:	"
call timecmd ".\output\mergeSortCpp.exe > NUL"
echo | set /p="Table:		"
call timecmd ".\output\tableCpp.exe > NUL"

echo 	MPL
echo | set /p="BubbleSort:	"
call timecmd ".\output\bubbleSortMpl.exe > NUL"
echo | set /p="fibonacciCycle:	"
call timecmd ".\output\fibonacciCycleMpl.exe > NUL"
echo | set /p="fibonacciRec:	"
call timecmd ".\output\fibonacciRecMpl.exe > NUL"
echo | set /p="ip:		"
call timecmd ".\output\ipMpl.exe > NUL"
echo | set /p="MergeSort:	"
call timecmd ".\output\mergeSortMpl.exe > NUL"
echo | set /p="Table:		"
call timecmd ".\output\tableMpl.exe > NUL"

echo 	Python benchmark:
echo | set /p="BubbleSort: "
call timecmd "python -OO .\bubbleSort\bubbleSortPython\test.py > NUL"
echo | set /p="fibonacciCycle: "
call timecmd "python -OO .\fibonacciCycle\fibonacciCyclePython\test.py > NUL"
echo | set /p="fibonacciRec: "
call timecmd "python -OO .\fibonacciRec\fibonacciRecPython\test.py > NUL"
echo | set /p="ip: "
call timecmd "python -OO .\ip\ipPython\test.py > NUL"
echo | set /p="MergeSort: "
call timecmd "python -OO .\mergeSort\mergeSortPython\test.py > NUL"
echo | set /p="Table: "
call timecmd "python -OO .\table\tablePython\test.py > NUL"