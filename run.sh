set -e

rm -f -r "./output"
mkdir output

echo Building. Please wait...
echo C++
mplc ./MPL/common.mpl -ndebug -begin_func startUp -end_func tearDown -o output/common.ll -I ./sl -I ./MPL -I ./MPL/linux
clang++ ./fibonacciCycle/fibonacciCycleCpp/test.cpp ./output/common.ll -o output/fibonacciCycleCpp -I ./Cpp -Wno-override-module -D NDEBUG -O3 -march=native -Wall --std=c++20
clang++ ./fibonacciRec/fibonacciRecCpp/test.cpp     ./output/common.ll -o output/fibonacciRecCpp   -I ./Cpp -Wno-override-module -D NDEBUG -O3 -march=native -Wall --std=c++20
clang++ ./ip/ipCpp/test.cpp                         ./output/common.ll -o output/ipCpp             -I ./Cpp -Wno-override-module -D NDEBUG -O3 -march=native -Wall --std=c++20
clang++ ./table/tableCpp/test.cpp                   ./output/common.ll -o output/tableCpp          -I ./Cpp -Wno-override-module -D NDEBUG -O3 -march=native -Wall --std=c++20
echo mplc
mplc ./fibonacciCycle/fibonacciCycleMpl/test.mpl -I ./sl -I ./MPL -I ./MPL/linux -o output/fibonacciCycleMpl.ll -ndebug
mplc ./fibonacciRec/fibonacciRecMpl/test.mpl     -I ./sl -I ./MPL -I ./MPL/linux -o output/fibonacciRecMpl.ll   -ndebug
mplc ./ip/ipMpl/test.mpl                         -I ./sl -I ./MPL -I ./MPL/linux -o output/ipMpl.ll             -ndebug
mplc ./table/tableMpl/test.mpl                   -I ./sl -I ./MPL -I ./MPL/linux -o output/tableMpl.ll          -ndebug
echo clang++
clang++ ./output/fibonacciCycleMpl.ll -o output/fibonacciCycleMpl -Wno-override-module -O3 -march=native
clang++ ./output/fibonacciRecMpl.ll   -o output/fibonacciRecMpl   -Wno-override-module -O3 -march=native
clang++ ./output/ipMpl.ll             -o output/ipMpl             -Wno-override-module -O3 -march=native
clang++ ./output/tableMpl.ll          -o output/tableMpl          -Wno-override-module -O3 -march=native

echo
echo Testing. Please wait...
echo
echo MPL:
./output/fibonacciCycleMpl > /dev/null
./output/fibonacciRecMpl   > /dev/null
./output/ipMpl             > /dev/null
./output/tableMpl          > /dev/null
echo
echo C++:
./output/fibonacciCycleCpp > /dev/null
./output/fibonacciRecCpp   > /dev/null
./output/ipCpp             > /dev/null
./output/tableCpp          > /dev/null
echo
echo Python:
echo fibonacciCycle & time python3 ./fibonacciCycle/fibonacciCyclePython/test.py -OO > /dev/null
echo fibonacciRec   & time python3 ./fibonacciRec/fibonacciRecPython/test.py     -OO > /dev/null
echo ip             & time python3 ./ip/ipPython/test.py                         -OO > /dev/null
echo table          & time python3 ./table/tablePython/test.py                   -OO > /dev/null
