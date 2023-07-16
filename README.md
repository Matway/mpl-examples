- [Description](#description)
- [Build](#build)
  - [Prerequisites](#prerequisites)
- [Run](#run)
- [Speed of examples](#speed-of-examples)

# Description

Examples of code written in C++ and MPL.

# Build
## Prerequisites
* Git
  * Download it via https://git-scm.com/download/win
  * Install it. During the installation select an option "Add to PATH"
* [MPL compiler](https://github.com/Matway/mpl-c)
  * https://github.com/Matway/mpl-c/releases/latest/download/mplc.exe
  * Put into some folder, for example, `%USERPROFILE%/mpl`
  * Add folder with mplc to PATH: https://www.computerhope.com/issues/ch000549.htm#windows10
* Clang
  * Go to the llvm release page - https://github.com/llvm/llvm-project/releases/latest
  * Download the file that is matched to the pattern `LLVM-xxx-win64.exe` - where `xxx` part represents the version number of latest release
  * During the installation select an option "Add to PATH"
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

# Run
Open cmd. Type command ```cd path_to_folder_with_mpl_example```. Type command ```run.bat```.

# Speed of examples

Running time, in seconds, as measured on `Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz 2.80 GHz`

| Example name   | C++  | MPL  |
| -------------- | ---- | ---- | 
| bubbleSort     | 15   | 3    |
| ip             | 25   | 1    |
| mergeSort      | 13   | 10   |
| table          | 21.5 | 0.05 |