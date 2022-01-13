- [Description](#description)
- [Build](#build)
  - [Prerequisites](#prerequisites)
  - [Windows builds](#windows-build)
- [Run](#run)

# Description

Examples of code written in C++ and MPL

# Build
## Prerequisites
* [Visual Studio 2019](https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=Community&rel=16) (Windows builds and code editing)
  * On the `Workloads` page, select `Desktop development with C++`
  * On the `Individual components` page, select:
    * `Text Template Transformation`
    * `C# and Visual Basic Roslyn compilers`
    * `C++ 2019 Redistributable Update`
    * `MSBuild`
    * `MSVC v142 - VS 2019 C++ x64/x86 build tools (v14.28)`
    * `C++ core features`
    * `IntelliCode`
    * `Windows 10 SDK (10.0.19041.0)`

  Anything else is not needed and may be unselected.
* MPL language support extension for Visual Studio (Recommended)
  * In Visual Studio: Extensions -> Manage Extensions
  * Type "MPL" in the search box
  * `MPL language support` should appear, click on `Download`
* Clang
  * Go to the llvm release page - https://github.com/llvm/llvm-project/releases/latest
  * Download the file that is matched to the pattern `LLVM-xxx-win64.exe` - where `xxx` part represents the version number of latest release
  * Open the file with an archive manager and extract `bin/clang.exe` to Path-accessible folder, for example, `%USERPROFILE%/mpl`
* [MPL compiler](https://github.com/Matway/mpl-c)
  * https://github.com/Matway/mpl-c/releases/latest/download/mplc.exe
  * Put into Path-accessible folder, for example, `%USERPROFILE%/mpl`
* [Code examples](https://dev.gravilink.com/mpl/mpl-examples) itself  
  Clone it into the desired location and make sure the **path has no spaces and no non-ASCII characters in it**:
  ```
  git clone https://dev.gravilink.com/mpl/mpl-examples.git
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
Run project in VS or run 
`path_to_example/x64_Release/project_name.exe` for MPL projects and
`path_to_example/x64/Release/project_name.exe` for C++ projects.
