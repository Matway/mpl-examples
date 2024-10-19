- [Description](#description)
- [Prerequisites](#prerequisites)
- [Run](#run)
- [Speed of examples](#speed-of-examples)

# Description

Examples of code written in MPL/C++/Python

# Prerequisites
* Python
  * Download via https://www.python.org/ftp/python/3.11.4/python-3.11.4-amd64.exe
  * Install, during the installation select an option "Add to PATH"
* MPL compiler
  * https://github.com/Matway/mpl-c/releases/latest/download/mplc.exe
  * Put into some folder, for example, `%USERPROFILE%/mpl`
  * Add the folder with mpl-c to PATH environment variable: https://www.computerhope.com/issues/ch000549.htm#windows10
* Clang
  * Go to the llvm release page - https://github.com/llvm/llvm-project/releases/latest
  * Download the file that is matched to the pattern `LLVM-xxx-win64.exe` - where `xxx` part represents the version number of the latest release
  * Execute this file, during the installation select an option "Add to PATH"
* [Build Tools for Visual Studio 2022](https://aka.ms/vs/17/release/vs_BuildTools.exe)
  * Download the installer, execute it
  * On the `Workloads` page, select `Desktop development with C++`
  * On the `Individual components` page, select:
    * `C++ 2022 Redistributable Update`
    * `MSVC v143 - VS 2022 C++ x64/x86 build tools (Latest)`
    * `C++ core features`
    * `Windows 11 SDK`
* [Code examples](https://github.com/Matway/mpl-examples/archive/refs/heads/master.zip) itself  
  Unpack it into the desired location and make sure the **path has no spaces and no non-ASCII characters in it**:
* [MPL Standard Library](https://github.com/Matway/mpl-sl/archive/refs/heads/master.zip)  
  Unpack and set up the link to it:
  ```
  cd path/to/folder/with/mpl/example
  mklink /J sl "path_to_mpl_sl"
  ```

# Run
* Press `Win+R`, then type `cmd` and press `Enter`
* Type command `cd path/to/folder/with/mpl/example`
* Type command `run.bat`

# Speed of examples

Running time, as measured on `Fedora Linux 42` with `Intel Core i7-12700H` using `LLVM 19.1.0`:

```
| Example name   | MPL            | C++    | Python
| -------------- | ---------------| ------ | ------
| bubbleSort     | 1.17s          | 09.55s |    03m 43s
| fibonacciCycle | 0.000'000'028s | 01.23s |    03m 40s
| fibonacciRec   | 0.000'000'076s | 10.48s |    06m 22s
| ip             | 0.000'000'059s | 00.43s |    21m 16s
| table          | 0.000'085'534s | 06.90s | 5h 29m 00s
```
