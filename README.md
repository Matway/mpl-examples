- [Description](#description)
- [Prerequisites](#prerequisites)
- [Run](#run)
- [Speed of examples](#speed-of-examples)

# Description

Examples of code written in C++ and MPL

# Prerequisites
* Git
  * Download via https://git-scm.com/download/win
  * Install, during the installation select an option "Add to PATH"
* MPL compiler
  * https://github.com/Matway/mpl-c/releases/latest/download/mplc.exe
  * Put into some folder, for example, `%USERPROFILE%/mpl`
  * Add the folder with mpl-c to PATH environment variable: https://www.computerhope.com/issues/ch000549.htm#windows10
* Clang
  * Go to the llvm release page - https://github.com/llvm/llvm-project/releases/latest
  * Download the file that is matched to the pattern `LLVM-xxx-win64.exe` - where `xxx` part represents the version number of the latest release
  * Execute this file, during the installation select an option "Add to PATH"
* [Visual Studio](https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=Community&rel=16)
  * Download the installer, execute it
  * On the `Workloads` page, select `Desktop development with C++`
  * On the `Individual components` page, select:
    * `C++ 2022 Redistributable Update`
    * `MSBuild`
    * `MSVC v143 - VS 2022 C++ x64/x86 build tools`
    * `C++ core features`
    * `Windows 10 SDK`
* [Code examples](https://github.com/Matway/mpl-examples) itself  
  Clone it into the desired location and make sure the **path has no spaces and no non-ASCII characters in it**:
  ```
  git clone https://github.com/Matway/mpl-examples.git
  ```
* [MPL Standard Library](https://github.com/Matway/mpl-sl)  
  Set up the link to sl:
  ```
  git clone https://github.com/Matway/mpl-sl.git
  cd path/to/folder/with/mpl/example
  mklink /J sl "path_to_mpl_sl"
  ```

# Run
* Open x64 [native tools command prompt for VS](https://learn.microsoft.com/en-us/cpp/build/building-on-the-command-line?view=msvc-170)
* Type command ```cd path/to/folder/with/mpl/example```
* Type command ```run.bat```

# Speed of examples

Running time, in seconds, as measured on `Intel Core i9-12950HX @ 2.30GHz`

| Example name   | C++  | MPL  |
| -------------- | ---- | ---- | 
| bubbleSort     | 9.85 | 1.32 |
| fibonacciCycle | 1.83 | 0.05 |
| fibonacciRec   | 3.70 | 0.06 |
| ip             | 0.88 | 0.06 |
| mergeSort      | 7.49 | 5.34 |
| table          | 6.31 | 0.06 |
