@echo off

rmdir /s /q ".\output" 2>NUL
mkdir output

echo Compilation. Please wait...
echo C++
mplc .\MPL\common.mpl -ndebug -begin_func startUp -end_func tearDown -o output\common.ll -I .\sl -I .\MPL -I .\MPL\windows
clang .\bubbleSort\bubbleSortCpp\test.cpp         .\output\common.ll -o output\bubbleSortCpp.exe     -I .\Cpp -Wno-override-module -D NDEBUG -O3 -march=native -Wall
clang .\fibonacciCycle\fibonacciCycleCpp\test.cpp .\output\common.ll -o output\fibonacciCycleCpp.exe -I .\Cpp -Wno-override-module -D NDEBUG -O3 -march=native -Wall
clang .\fibonacciRec\fibonacciRecCpp\test.cpp     .\output\common.ll -o output\fibonacciRecCpp.exe   -I .\Cpp -Wno-override-module -D NDEBUG -O3 -march=native -Wall
clang .\ip\ipCpp\test.cpp                         .\output\common.ll -o output\ipCpp.exe             -I .\Cpp -Wno-override-module -D NDEBUG -O3 -march=native -Wall
clang .\table\tableCpp\test.cpp                   .\output\common.ll -o output\tableCpp.exe          -I .\Cpp -Wno-override-module -D NDEBUG -O3 -march=native -Wall
echo mplc
mplc .\bubbleSort\bubbleSortMpl\test.mpl         -I .\sl -I .\MPL -I .\MPL\windows -o output\bubbleSortMpl.ll     -ndebug
mplc .\fibonacciCycle\fibonacciCycleMpl\test.mpl -I .\sl -I .\MPL -I .\MPL\windows -o output\fibonacciCycleMpl.ll -ndebug
mplc .\fibonacciRec\fibonacciRecMpl\test.mpl     -I .\sl -I .\MPL -I .\MPL\windows -o output\fibonacciRecMpl.ll   -ndebug
mplc .\ip\ipMpl\test.mpl                         -I .\sl -I .\MPL -I .\MPL\windows -o output\ipMpl.ll             -ndebug
mplc .\table\tableMpl\test.mpl                   -I .\sl -I .\MPL -I .\MPL\windows -o output\tableMpl.ll          -ndebug
echo clang\link
clang .\output\bubbleSortMpl.ll     -o output\bubbleSortMpl.exe     -Wno-override-module -O3 -march=native
clang .\output\fibonacciCycleMpl.ll -o output\fibonacciCycleMpl.exe -Wno-override-module -O3 -march=native
clang .\output\fibonacciRecMpl.ll   -o output\fibonacciRecMpl.exe   -Wno-override-module -O3 -march=native
clang .\output\ipMpl.ll             -o output\ipMpl.exe             -Wno-override-module -O3 -march=native
clang .\output\tableMpl.ll          -o output\tableMpl.exe          -Wno-override-module -O3 -march=native

echo:
echo Testing. Please wait...
echo:
echo MPL:
.\output\bubbleSortMpl.exe     >NUL
.\output\fibonacciCycleMpl.exe >NUL
.\output\fibonacciRecMpl.exe   >NUL
.\output\ipMpl.exe             >NUL
.\output\tableMpl.exe          >NUL
echo:
echo C++:
.\output\bubbleSortCpp.exe     >NUL
.\output\fibonacciCycleCpp.exe >NUL
.\output\fibonacciRecCpp.exe   >NUL
.\output\ipCpp.exe             >NUL
.\output\tableCpp.exe          >NUL
echo:
echo Python:
echo | set /p="bubbleSort	"     & call timecmd "python .\bubbleSort\bubbleSortPython\test.py         -OO >NUL"
echo | set /p="fibonacciCycle	" & call timecmd "python .\fibonacciCycle\fibonacciCyclePython\test.py -OO >NUL"
echo | set /p="fibonacciRec	"   & call timecmd "python .\fibonacciRec\fibonacciRecPython\test.py     -OO >NUL"
echo | set /p="ip		"           & call timecmd "python .\ip\ipPython\test.py                         -OO >NUL"
echo | set /p="table		"         & call timecmd "python .\table\tablePython\test.py                   -OO >NUL"