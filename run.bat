@echo off

rmdir /s /q ".\output" 2>NUL
mkdir output

echo Building. Please wait...
echo C++
clang fibonacciCycle\fibonacciCycleCpp\test.cpp -o output\fibonacciCycleCpp.exe -I Cpp -D NDEBUG -O3 -march=native -Wall --std=c++20
clang fibonacciRec\fibonacciRecCpp\test.cpp     -o output\fibonacciRecCpp.exe   -I Cpp -D NDEBUG -O3 -march=native -Wall --std=c++20
clang ip\ipCpp\test.cpp                         -o output\ipCpp.exe             -I Cpp -D NDEBUG -O3 -march=native -Wall --std=c++20
clang table\tableCpp\test.cpp                   -o output\tableCpp.exe          -I Cpp -D NDEBUG -O3 -march=native -Wall --std=c++20
echo mplc
mplc fibonacciCycle\fibonacciCycleMpl\test.mpl -I sl -I MPL -I MPL\windows -o output\fibonacciCycleMpl.ll -ndebug
mplc fibonacciRec\fibonacciRecMpl\test.mpl     -I sl -I MPL -I MPL\windows -o output\fibonacciRecMpl.ll   -ndebug
mplc ip\ipMpl\test.mpl                         -I sl -I MPL -I MPL\windows -o output\ipMpl.ll             -ndebug
mplc table\tableMpl\test.mpl                   -I sl -I MPL -I MPL\windows -o output\tableMpl.ll          -ndebug
echo clang
clang output\fibonacciCycleMpl.ll -o output\fibonacciCycleMpl.exe -Wno-override-module -O3 -march=native
clang output\fibonacciRecMpl.ll   -o output\fibonacciRecMpl.exe   -Wno-override-module -O3 -march=native
clang output\ipMpl.ll             -o output\ipMpl.exe             -Wno-override-module -O3 -march=native
clang output\tableMpl.ll          -o output\tableMpl.exe          -Wno-override-module -O3 -march=native

echo:
echo Testing. Please wait...
echo:
echo MPL
output\fibonacciCycleMpl.exe >NUL
output\fibonacciRecMpl.exe   >NUL
output\ipMpl.exe             >NUL
output\tableMpl.exe          >NUL
echo:
echo C++
output\fibonacciCycleCpp.exe >NUL
output\fibonacciRecCpp.exe   >NUL
output\ipCpp.exe             >NUL
output\tableCpp.exe          >NUL
echo:
echo Python
echo | set /p="fibonacciCycle	" & call timecmd "python fibonacciCycle\fibonacciCyclePython\test.py -OO >NUL"
echo | set /p="fibonacciRec	"   & call timecmd "python fibonacciRec\fibonacciRecPython\test.py     -OO >NUL"
echo | set /p="ip		"           & call timecmd "python ip\ipPython\test.py                         -OO >NUL"
echo | set /p="table		"         & call timecmd "python table\tablePython\test.py                   -OO >NUL"
