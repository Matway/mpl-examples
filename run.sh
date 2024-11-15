set -e

rm -f -r output
mkdir output

echo Building. Please wait...
echo C++
g++     fibonacciCycle/fibonacciCycleCpp/test.cpp -o output/fibonacciCycleCppGcc -I Cpp                      -D NDEBUG -O3 -march=native -Wall --std=c++20
g++     fibonacciRec/fibonacciRecCpp/test.cpp     -o output/fibonacciRecCppGcc   -I Cpp                      -D NDEBUG -O3 -march=native -Wall --std=c++20
g++     ip/ipCpp/test.cpp                         -o output/ipCppGcc             -I Cpp                      -D NDEBUG -O3 -march=native -Wall --std=c++20
g++     table/tableCpp/test.cpp                   -o output/tableCppGcc          -I Cpp                      -D NDEBUG -O3 -march=native -Wall --std=c++20
clang++ fibonacciCycle/fibonacciCycleCpp/test.cpp -o output/fibonacciCycleCpp    -I Cpp -Wno-override-module -D NDEBUG -O3 -march=native -Wall --std=c++20
clang++ fibonacciRec/fibonacciRecCpp/test.cpp     -o output/fibonacciRecCpp      -I Cpp -Wno-override-module -D NDEBUG -O3 -march=native -Wall --std=c++20
clang++ ip/ipCpp/test.cpp                         -o output/ipCpp                -I Cpp -Wno-override-module -D NDEBUG -O3 -march=native -Wall --std=c++20
clang++ table/tableCpp/test.cpp                   -o output/tableCpp             -I Cpp -Wno-override-module -D NDEBUG -O3 -march=native -Wall --std=c++20
echo mplc
mplc fibonacciCycle/fibonacciCycleMpl/test.mpl -I sl -I MPL -I MPL/linux -o output/fibonacciCycleMpl.ll -ndebug
mplc fibonacciRec/fibonacciRecMpl/test.mpl     -I sl -I MPL -I MPL/linux -o output/fibonacciRecMpl.ll   -ndebug
mplc ip/ipMpl/test.mpl                         -I sl -I MPL -I MPL/linux -o output/ipMpl.ll             -ndebug
mplc table/tableMpl/test.mpl                   -I sl -I MPL -I MPL/linux -o output/tableMpl.ll          -ndebug
echo clang++
clang++ output/fibonacciCycleMpl.ll -o output/fibonacciCycleMpl -Wno-override-module -O3 -march=native
clang++ output/fibonacciRecMpl.ll   -o output/fibonacciRecMpl   -Wno-override-module -O3 -march=native
clang++ output/ipMpl.ll             -o output/ipMpl             -Wno-override-module -O3 -march=native
clang++ output/tableMpl.ll          -o output/tableMpl          -Wno-override-module -O3 -march=native

echo
echo Testing. Please wait...
echo
echo MPL
./output/fibonacciCycleMpl > /dev/null
./output/fibonacciRecMpl   > /dev/null
./output/ipMpl             > /dev/null
./output/tableMpl          > /dev/null
echo
gcc --version | grep -i "(gcc)" || echo C++/GCC
./output/fibonacciCycleCppGcc > /dev/null
./output/fibonacciRecCppGcc   > /dev/null
./output/ipCppGcc             > /dev/null
./output/tableCppGcc          > /dev/null
echo
clang --version | grep -i "clang version" || echo C++/LLVM
./output/fibonacciCycleCpp > /dev/null
./output/fibonacciRecCpp   > /dev/null
./output/ipCpp             > /dev/null
./output/tableCpp          > /dev/null
echo
python3 --version | grep -i "python" || echo Python
TIMEFORMAT='fibonacciCycle ----- %Rs'; time python3 fibonacciCycle/fibonacciCyclePython/test.py -OO > /dev/null
TIMEFORMAT='fibonacciRec ------- %Rs'; time python3 fibonacciRec/fibonacciRecPython/test.py     -OO > /dev/null
TIMEFORMAT='ip ----------------- %Rs'; time python3 ip/ipPython/test.py                         -OO > /dev/null
TIMEFORMAT='table -------------- %Rs'; time python3 table/tablePython/test.py                   -OO > /dev/null
