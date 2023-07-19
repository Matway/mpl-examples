@echo off

rmdir /s /q ".\output" 2>NUL
mkdir output

echo Compilation. Please wait...

clang++ .\bubbleSort\bubbleSortCpp\test.cpp         -o output\bubbleSortCpp.exe     -D NDEBUG -O3
clang++ .\fibonacciCycle\fibonacciCycleCpp\test.cpp -o output\fibonacciCycleCpp.exe -D NDEBUG -O3
clang++ .\fibonacciRec\fibonacciRecCpp\test.cpp     -o output\fibonacciRecCpp.exe   -D NDEBUG -O3
clang++ .\ip\ipCpp\test.cpp                         -o output\ipCpp.exe             -D NDEBUG -O3
clang++ .\table\tableCpp\test.cpp                   -o output\tableCpp.exe          -D NDEBUG -O3

mplc .\bubbleSort\bubbleSortMpl\test.mpl         -I .\sl -o output\bubbleSortMpl.ll     -ndebug
mplc .\fibonacciCycle\fibonacciCycleMpl\test.mpl -I .\sl -o output\fibonacciCycleMpl.ll -ndebug
mplc .\fibonacciRec\fibonacciRecMpl\test.mpl     -I .\sl -o output\fibonacciRecMpl.ll   -ndebug
mplc .\ip\ipMpl\test.mpl                         -I .\sl -o output\ipMpl.ll             -ndebug
mplc .\table\tableMpl\test.mpl                   -I .\sl -o output\tableMpl.ll          -ndebug

clang++ .\output\bubbleSortMpl.ll     -o output\bubbleSortMpl.exe     -O3 2>NUL
clang++ .\output\fibonacciCycleMpl.ll -o output\fibonacciCycleMpl.exe -O3 2>NUL
clang++ .\output\fibonacciRecMpl.ll   -o output\fibonacciRecMpl.exe   -O3 2>NUL
clang++ .\output\ipMpl.ll             -o output\ipMpl.exe             -O3 2>NUL
clang++ .\output\tableMpl.ll          -o output\tableMpl.exe          -O3 2>NUL

echo Compilation successful!
echo:
echo Mpl
echo | set /p="bubbleSort:	"     & call timecmd ".\output\bubbleSortMpl.exe     >NUL"
echo | set /p="fibonacciCycle:	" & call timecmd ".\output\fibonacciCycleMpl.exe >NUL"
echo | set /p="fibonacciRec:	"   & call timecmd ".\output\fibonacciRecMpl.exe   >NUL"
echo | set /p="ip:		"           & call timecmd ".\output\ipMpl.exe             >NUL"
echo | set /p="table:		"         & call timecmd ".\output\tableMpl.exe          >NUL"
echo:
echo C++
echo | set /p="bubbleSort:	"     & call timecmd ".\output\bubbleSortCpp.exe     >NUL"
echo | set /p="fibonacciCycle:	" & call timecmd ".\output\fibonacciCycleCpp.exe >NUL"
echo | set /p="fibonacciRec:	"   & call timecmd ".\output\fibonacciRecCpp.exe   >NUL"
echo | set /p="ip:		"           & call timecmd ".\output\ipCpp.exe             >NUL"
echo | set /p="table:		"         & call timecmd ".\output\tableCpp.exe          >NUL"
echo:
echo Python
echo | set /p="bubbleSort:	"     & call timecmd "python .\bubbleSort\bubbleSortPython\test.py         -OO >NUL"
echo | set /p="fibonacciCycle:	" & call timecmd "python .\fibonacciCycle\fibonacciCyclePython\test.py -OO >NUL"
echo | set /p="fibonacciRec:	"   & call timecmd "python .\fibonacciRec\fibonacciRecPython\test.py     -OO >NUL"
echo | set /p="ip:		"           & call timecmd "python .\ip\ipPython\test.py                         -OO >NUL"
echo | set /p="table:		"         & call timecmd "python .\table\tablePython\test.py                   -OO >NUL"