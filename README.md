- [Description](#description)
- [Build](#build)
  - [Prerequisites](#prerequisites)
  - [Windows builds](#windows-build)
- [Run](#run)
- [Speed of examples](#speed-of-examples)

# Description

Examples of code written in C++ and MPL

# Build
## Prerequisites
* Git
  * Download it via https://git-scm.com/download/win
  * Install it. During the installation select an option "Add to PATH"
* [Visual Studio 2022 Community](https://visualstudio.microsoft.com/ru/downloads/) (Windows builds and code editing)
  * On the `Workloads` page, select `Desktop development with C++`
  * On the `Individual components` page, select:
    * `Text Template Transformation`
    * `C# and Visual Basic Roslyn compilers`
    * `MSBuild`
    * `MSVC v142 - VS 2019 C++ x64/x86 build tools (v14.29-16.11)`
    * `C++ core features`
    * `IntelliCode`
    * `Windows 10 SDK (10.0.19041.0)`
    * `C++ Clang Compiler for Windows (14.0.5)`
    * `C++ Clang-cl for v143 build tools (x64/x86)`

* MPL language support extension for Visual Studio (Recommended)
  * In Visual Studio: Extensions -> Manage Extensions
  * Type "MPL" in the search box
  * `MPL language support` should appear, click on `Download`
* [MPL compiler](https://github.com/Matway/mpl-c)
  * https://github.com/Matway/mpl-c/releases/latest/download/mplc.exe
  * Put into some folder, for example, `%USERPROFILE%/mpl`
  * Add folder with mplc to PATH: https://www.computerhope.com/issues/ch000549.htm#windows10
* Clang
  * Go to the llvm release page - https://github.com/llvm/llvm-project/releases/latest
  * Download the file that is matched to the pattern `LLVM-xxx-win64.exe` - where `xxx` part represents the version number of latest release
  * During the installation select an option "Add to PATH"
  * Go to the folder with clang.exe (by default it is `C:\Program Files\LLVM\bin`).
  * Move clang.exe to mplc directory.
* [Code examples](https://github.com/Matway/mpl-examples) itself  
  Clone it into the desired location and make sure the **path has no spaces and no non-ASCII characters in it**:
  ```
  git clone https://github.com/Matway/mpl-examples.git
  ```
* [MPL Standard Library](https://github.com/Matway/mpl-sl)  
  Set up the link to sl:
  ```
  git clone https://github.com/Matway/mpl-sl.git
  cd path_to_folder_with_mpl_example
  mklink /J sl "path_to_mpl_sl"
  ```

## Windows build
Build VS project: `project_name.vcxproj`

# Run
Run project in VS via Ctrl + F5.

# Measure execution time
Open PowerShell. Type command `cd [PATH TO mpl-examples folder]`. For example if you want to measure exection time of the project `Array` type
```Measure-Command { .\array\arrayMpl\x64_Release\arrayMpl.exe }``` for mpl and command ```Measure-Command { .\array\arrayCpp\x64\Release\arrayCpp.exe }``` for c++ respectively. If you want to measure execution time of the other example change the command according to the pattern: ```Measure-Command { .\[example name]\[example name]Mpl\x64_Release\[example name]Mpl.exe }``` and ```Measure-Command { .\[example name]\[example name]Cpp\x64_Release\[example name]Cpp.exe }```.

# Benchmarks

Running time, in seconds, as measured on `Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz 2.80 GHz`

| Example name   | C++  | MPL  |
| -------------- | ---- | ---- | 
| bubbleSort     | 15   | 3    |
| ip             | 25   | 1    |
| mergeSort      | 13   | 10   |
| table          | 21.5 | 0.05 |
