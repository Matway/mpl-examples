@echo off

rmdir /s /q ".\output" 2>NUL
mkdir output

echo Compilation. Please wait...

clang++ .\array\arrayCpp\test.cpp -o output\arrayCpp.exe -O3
clang++ .\bubbleSort\bubbleSortCpp\test.cpp -o output\bubbleSortCpp.exe -O3
clang++ .\fibonacciCycle\fibonacciCycleCpp\test.cpp -o output\fibonacciCycleCpp.exe -O3
clang++ .\fibonacciRec\fibonacciRecCpp\test.cpp -o output\fibonacciRecCpp.exe -O3
clang++ .\ip\ipCpp\test.cpp -o output\ipCpp.exe -O3
clang++ .\mergeSort\mergeSortCpp\test.cpp -o output\mergeSortCpp.exe -O3
clang++ .\table\tableCpp\test.cpp -o output\tableCpp.exe -O3

mplc .\array\arrayMpl\test.mpl -I .\sl -o "arrayMpl.ll" -ndebug
move .\arrayMpl.ll .\output > NUL

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

clang++ .\output\arrayMpl.ll -o output\arrayMpl.exe -O3 2>NUL
clang++ .\output\bubbleSortMpl.ll -o output\bubbleSortMpl.exe -O3 2>NUL
clang++ .\output\fibonacciCycleMpl.ll -o output\fibonacciCycleMpl.exe -O3 2>NUL
clang++ .\output\fibonacciRecMpl.ll -o output\fibonacciRecMpl.exe -O3 2>NUL 
clang++ .\output\ipMpl.ll -o output\ipMpl.exe -O3 2>NUL
clang++ .\output\mergeSortMpl.ll -o output\mergeSortMpl.exe -O3  2>NUL
clang++ .\output\tableMpl.ll -o output\tableMpl.exe -O3  2>NUL

echo Compilation successful!

echo Time on Array.
echo | set /p="C++: "
call timecmd ".\output\arrayCpp.exe > NUL"
echo | set /p="MPL: "
call timecmd ".\output\arrayMpl.exe > NUL"
echo Time on BubbleSort.
echo | set /p="C++: "
call timecmd ".\output\bubbleSortCpp.exe > NUL"
echo | set /p="MPL: "
call timecmd ".\output\bubbleSortMpl.exe > NUL"
echo Time on fibonacciCycle.
echo | set /p="C++: "
call timecmd ".\output\fibonacciCycleCpp.exe > NUL"
echo | set /p="MPL: "
call timecmd ".\output\fibonacciCycleMpl.exe > NUL"
echo Time on fibonacciRec.
echo | set /p="C++: "
call timecmd ".\output\fibonacciRecCpp.exe > NUL"
echo | set /p="MPL: "
call timecmd ".\output\fibonacciRecMpl.exe > NUL"
echo Time on ip.
echo | set /p="C++: "
call timecmd ".\output\ipCpp.exe > NUL"
echo | set /p="MPL: "
call timecmd ".\output\ipMpl.exe > NUL"
echo Time on MergeSort.
echo | set /p="C++: "
call timecmd ".\output\mergeSortCpp.exe > NUL"
echo | set /p="MPL: "
call timecmd ".\output\mergeSortMpl.exe > NUL"
echo Time on Table.
echo | set /p="C++: "
call timecmd ".\output\tableCpp.exe > NUL"
echo | set /p="MPL: "
call timecmd ".\output\tableMpl.exe > NUL"