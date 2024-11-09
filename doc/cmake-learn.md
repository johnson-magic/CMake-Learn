- [1. cmake learn](#1-cmake-learn)
  - [1.1 CMakeLists.txt的最小单元（以及cmake对工程的版本号处理）](#11-cmakeliststxt的最小单元以及cmake对工程的版本号处理)
  - [1.2 CMake调用依赖库](#12-cmake调用依赖库)
  - [1.3 通过外部开关激活库中的不同代码组件(编译)](#13-通过外部开关激活库中的不同代码组件编译)
  - [1.4 通过系统内省（system introspection）(更加智能的)激活库中的不同代码组件(编译)](#14-通过系统内省system-introspection更加智能的激活库中的不同代码组件编译)
  - [1.5 将你的库安装到本地](#15-将你的库安装到本地)
    - [1.5.2 通过CPack将你的库进行distribution发布。](#152-通过cpack将你的库进行distribution发布)
  - [1.6 测试 并将 测试结果推向Dashboard](#16-测试-并将-测试结果推向dashboard)
- [2. cmake高阶玩法](#2-cmake高阶玩法)
  - [2.1  通过add\_custom\_command实现在编译的过程中生成代码](#21--通过add_custom_command实现在编译的过程中生成代码)
  - [2.2 import \&\& export](#22-import--export)
  - [2.3 package](#23-package)
- [3. 一些不成熟的想法](#3-一些不成熟的想法)
- [4. 做中想](#4-做中想)



# 1. cmake learn
该文档是对cmake学习过程的总结，涉及到以下特性：

* cmake的最小工作单元
* cmake对工程的版本号处理


## 1.1 CMakeLists.txt的最小单元（以及cmake对工程的版本号处理）
&emsp;&emsp;本小节中涉及CMake的如下两个特性
* cmake的最小工作单元
* cmake对工程的版本号处理

&emsp;&emsp;初衷: 虽然可以将project的版本号显示的写在代码内部，但将其通过CMakeLists.txt进行管理会更加灵活。（思考：这里的灵活体现在哪里？）
&emsp;&emsp;如何做：

将版本信息通过project指令显式的写入CMakeLists.txt中（隐含的思想：关于project的信息集中存放）

```
project(Tutorial VERSION 1.0)
```
该指令的隐含操作，会（自动）设置VERSION相关的变量：<PROJECT-NAME>_VERSION_MAJOR、<PROJECT-NAME>_VERSION_MINOR、<PROJECT-NAME>_VERSION_PATCH、<PROJECT-NAME>_VERSION_TWEAK，对应到这里就是Tutorial_VERSION_MAJOR和Tutorial_VERSION_MINOR分别为1和0。 

```
configure_file(TutorialConfig.h.in TutorialConfig.h)
```
该指令会起两个作用：文件的搬运和文件内相关变量的替换。具体到本工程：TutorialConfig.h.in的内容为：
```
#define Tutorial_VERSION_MAJOR @Tutorial_VERSION_MAJOR@
#define Tutorial_VERSION_MINOR @Tutorial_VERSION_MINOR@
```
该文件首先会被搬运至build文件夹，文件中的内容@VAR@会被替换为VAR的内容。此时就会有一个含有显式版本信息的头文件，只不过要注意的是该头文件是在编译的过程中自动生成的，且存放的位置为build文件。本质上还是将版本号写在了源代码里面，但源代码是自动生成的，且位于build目录，多此一举的目的就是将信息集中管控、集中修改。
有了含有版本号的头文件，源代码中就可以像普通头文件一样使用：在哪里？拿过来？使用。
在哪里(CMakeLists.txt)：
```
target_include_directories(Tutorial PUBLIC
                           "${PROJECT_BINARY_DIR}"
                           )
```
拿过来(tutorial.cxx)：
```
#include "TutorialConfig.h"
```
使用(tutorial.cxx)：
```
 std::cout << argv[0] << " Version " << Tutorial_VERSION_MAJOR << "."
              << Tutorial_VERSION_MINOR << std::endl;
```
杂：c++编译器编译器可能同时支持不同的C++标准，可以通过以下配置，为编译器进一步明确它该使用的版本，因为有可能project的代码中使用到了11中才有的高级特性。
```
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)
```

## 1.2 CMake调用依赖库
略

## 1.3 通过外部开关激活库中的不同代码组件(编译)

三步走：
1. 添加选项
2. 根据选项，在编译子文件夹中设置分叉
3. 将选项童工configure_file抓换为C++中能够使用的宏，在代码中设置分叉

添加选项的脚本如下所示：
```
cmake_minimum_required(VERSION 3.10)
project(Tutorial VERSION 1.0)
option(USE_MYMATH "Use tutorial provided math implementation" ON)
```
选项类似于CMakeLists.txt的接口，因此可以尽量的放在CMakeLists.txt的前部，并添加参数说明和默认值。
根据选项（可能需要）决定一些子文件夹是否“中断”开来
#if(USE_MYMATH)
add_subdirectory(MathFunctions)
list(APPEND EXTRA_LIBS MathFunctions)
list(APPEND EXTRA_INCLUDES "${PROJECT_SOURCE_DIR}/MathFunctions")
#endif()
这里建议，将头文件和库用list变量的方式，来与target发生关系，达到解除耦合的目的。
然后通过configure_file的方式，将CMakeLists.txt中的变量转换为C++可以使用的宏。
```
#define Tutorial_VERSION_MAJOR @Tutorial_VERSION_MAJOR@
#define Tutorial_VERSION_MINOR @Tutorial_VERSION_MINOR@
#cmakedefine USE_MYMATH
```
最后在代码层面，包含该头文件，就可以使用宏来处理代码中“残留”的分支。
```
#include "TutorialConfig.h"
#ifdef USE_MYMATH
  #include "mysqrt.h"
#else
  #include <cmath>
#endif
```

```
 #ifdef USE_MYMATH
    const double outputValue = mathfunctions::detail::mysqrt(inputValue);
  #else
    const double outputValue = std::sqrt(inputValue);
  #endif
```

&emsp;&emsp;该特色可以用于编译不同的库，（例如CI，不同的镜像编译不同的库，传递不同的参数）。前同事用的方式是在CMakeLists.txt中，根据USE_MYMATH的变量再定义一个USE_MYMATH的宏，这个可读性和封装性，显然不如使用.in文件。如果有机会，在看到，可以纠正他的这种写法（但估计机会的概率不大，hh）。

## 1.4 通过系统内省（system introspection）(更加智能的)激活库中的不同代码组件(编译)
&emsp;&emsp; 这里讲的更加智能是相对于1.3小节中一外部option配置的方式来选择激活库中的不同代码组件，1.4小节则是通过CMakeLists.txt中的system introspection机制做自我判断，例如：当introspection到系统中含有期待的数学库函数，则使用系统中的库函数，如果introspection的结果是不存在，则激活自我定义的函数。基于上述的描述，认为这是一种更加智能的方式。


## 1.5 将你的库安装到本地
&emsp;&emsp;截止到目前你的可执行文件、库和头文件仍旧杂乱的存在于source目录和binary目录。显然，如何像安装其他库（例如cuda)一样将其规范的收纳入
```
/usr/local/bin
/usr/local/lib
/usr/local/include
```
三个目录下。

首先需要在CMakeLists.txt中，通过install指令撰写出“收纳”清单
在tutorial的CMakeLists.txt中（靠近尾部）添加如下代码：
```
install(TARGETS Tutorial DESTINATION bin)
install(FILES "${PROJECT_BINARY_DIR}/TutorialConfig.h"
  DESTINATION include
  )
```
而在MathFunctions目录下的CMakeLists.txt中添加如下的“收纳”指令
```
install(TARGETS MathFunctions DESTINATION lib)
install(FILES mysqrt.h DESTINATION include)
```
至此，在build目录中
```
cmake ..
make
cmake --install .
```
就会得到, 规整的收纳结果
```
-- Install configuration: ""
-- Installing: /usr/local/bin/Tutorial
-- Installing: /usr/local/include/TutorialConfig.h
-- Installing: /usr/local/lib/libMathFunctions.a
-- Installing: /usr/local/include/mysqrt.h
```
当然，库的安装一般都在默认目录/usr/local/目录下，你也可以通过指令设置自己的“收纳”目录
```
cmake --install . --prefix "/home/myuser/installdir"
```

### 1.5.2 通过CPack将你的库进行distribution发布。
&emsp;&emsp;这里涉及到distribution的几个概念，distribution称之为分发。分为binary distribution和source distribution.
```
cd build
cmake ..
make
cpack  # 生成binary distribution
cpack --config CPackSourceConfig.cmake  # 生成source distribution
```
私以为：有了git的存在，源代码分发的方式用到的几率很小了。


## 1.6 测试 并将 测试结果推向Dashboard
&emsp;&emsp;这里的测试指的是集成测试。测试的好处之前也提到过：及时发现问题，提升开发者信心以及提升软件质量。
&emsp;&emsp;CMake中的测试分为四步走：
* 打开test开关
* 增加测试用例(如下所示，这里建议将测试用例的添加和属性的设置放在一个函数中进行)
* 为测试用例添加属性
* 执行ctest指令

```
enable_testing()

add_test(NAME Runs COMMAND Tutorial 25)
add_test(NAME Usage COMMAND Tutorial)
set_tests_properties(Usage
  PROPERTIES PASS_REGULAR_EXPRESSION "Usage:.*number"
  )

function(do_test target arg result)
  add_test(NAME Comp${arg} COMMAND ${target} ${arg})
  set_tests_properties(Comp${arg}
    PROPERTIES PASS_REGULAR_EXPRESSION ${result}
    )
endfunction(do_test)

# do a bunch of result based tests
do_test(Tutorial 4 "4 is 2")
do_test(Tutorial 9 "9 is 3")
do_test(Tutorial 5 "5 is 2.236")
do_test(Tutorial 7 "7 is 2.645")
do_test(Tutorial 25 "25 is 5")
do_test(Tutorial -25 "-25 is [-nan|nan|0]")
do_test(Tutorial 0.0001 "0.0001 is 0.01")
```

另外需要注意的是，set_tests_properties起作用的是可执行文件中的stdout或者stderr。

Output written to stdout or stderr is captured by ctest(1) and only affects the pass/fail status via the PASS_REGULAR_EXPRESSION, FAIL_REGULAR_EXPRESSION, or SKIP_REGULAR_EXPRESSION test properties.

另外，CTest提供功能可以将测试结果以XML的形式输出，而上传至Dashboard后，server中的CDash可以将xml转换为http网页。

需要在CMakeLists.txt中将enable_testing()修改为include(CTest)。另外需要新建CTestConfig.cmake文件，文件的内容为：

```
set(CTEST_PROJECT_NAME "CMakeTutorial")
set(CTEST_NIGHTLY_START_TIME "00:00:00 EST")

set(CTEST_DROP_METHOD "http")
set(CTEST_DROP_SITE "my.cdash.org")
set(CTEST_DROP_LOCATION "/submit.php?project=CMakeTutorial")
set(CTEST_DROP_SITE_CDASH TRUE)
```
然后再build文件夹中执行：
```
ctest -D experimental
```
就可以在https://my.cdash.org/index.php?project=CMakeTutorial网页上看到测试结果的记录。
通过ctest想到的点有：ci的记录、风阵、TensorBoard和Wandb。

CI的记录有点像这里的Dashboard，网页化记录所有的信息，方便查找和对比。
风阵的记录，只不过是二次开发出来的，也是网页化记录所有的信息，方便查找和对比。
TensorBoard和wandb是深度学习的Dashboard，但是之前自己都每用过，后面要用起来。(思考：再一次的不要相信人类)

# 2. cmake高阶玩法
## 2.1  通过add_custom_command实现在编译的过程中生成代码
&emsp;&emsp;设想以下工作场景，自研的计算sqrt的方法，初始值都是从0开始计算。通过add_custom_command指令实现动态的生成一个称之为Table.h的文件，文件的内容为一个table表，每次查表获得sqrt迭代计算的初始值。
```
double sqrtTable[] = {
0,
1,
1.41421,
1.73205,
2,
2.23607,
2.44949,
2.64575,
2.82843,
3,
0};
```
&emsp;&emsp;实现以上想法，分三步走，第一步是创建MakeTable.cxx来实现创建Table.h文件的功能，其内容如下：
```
// A simple program that builds a sqrt table
#include <cmath>
#include <fstream>
#include <iostream>

int main(int argc, char* argv[])
{
  // make sure we have enough arguments
  if (argc < 2) {
    return 1;
  }

  std::ofstream fout(argv[1], std::ios_base::out);
  const bool fileOpen = fout.is_open();
  if (fileOpen) {
    fout << "double sqrtTable[] = {" << std::endl;
    for (int i = 0; i < 10; ++i) {
      fout << sqrt(static_cast<double>(i)) << "," << std::endl;
    }
    // close the table with a zero
    fout << "0};" << std::endl;
    fout.close();
  }
  return fileOpen ? 0 : 1; // return 0 if wrote the file
}
```
&emsp;&emsp;第二步是修改子文件夹MathFunctions下的CMakeLists.txt，设计custom_command相关的内容：
```
add_executable(MakeTable MakeTable.cxx)
add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/Table.h
  COMMAND MakeTable ${CMAKE_CURRENT_BINARY_DIR}/Table.h
  DEPENDS MakeTable
  )
add_library(MathFunctions mysqrt.cxx ${CMAKE_CURRENT_BINARY_DIR}/Table.h)
```
&emsp;&emsp;这里比较要强调的点，在于add_library这个地方，需要将生成的头文件显式的体现出来（否则，MakeTable指令无法执行）这里暂时还没查到相关资料。这里知道有这种写法（截止到2024年10月31日），可以这样理解，CMake之间的编译顺序是根据指定的依赖顺序来进行的，正向来讲，这里add_library显然是依赖MakeTable，因此应该将这种依赖关系体现在CMakeLists.txt中，一种更加好理解的写法如下所示(实际上仅仅针对target,lib不可以这么写)，因此，最后写成了上面的形式。
```

add_library(MathFunctions mysqrt.cxx)
add_dependencies(MathFunctions ${CMAKE_CURRENT_BINARY_DIR}/Table.h)
```

## 2.2 import && export
&emsp;&emsp;思路按照实验室下的import和export到产业界的import和export。这种感觉很像c/c++中的include以及python中的import（各种语言，只不过是计算机/软件思想的实例化，构建化然后集成，类和实例）。
有了这个想法，import就顺利成章了。
```
add_executable(myexe IMPORTED)
set_property(TARGET myexe PROPERTY
             IMPORTED_LOCATION "../InstallMyExe/bin/myexe")
```

```
add_library(foo STATIC IMPORTED)
set_property(TARGET foo PROPERTY
             IMPORTED_LOCATION "/path/to/libfoo.a")
```

&emsp;&emsp；export的机制的引入，事实上是有点增加了一层的感觉，把路径等属性，统一在一个与imported target相关联的一个配置文件中。所以export事实上，就是在尝试生成这一配置文件。（想法：有点把工作量尽量放在底层/生产者的意思）

```
target_include_directories(MathFunctions
                           PUBLIC
                           "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>"
                           "$<INSTALL_INTERFACE:include>"
)

install(TARGETS MathFunctions
        EXPORT MathFunctionsTargets
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        RUNTIME DESTINATION bin
        INCLUDES DESTINATION include
)

install(FILES MathFunctions.h DESTINATION include)
```
这样就会在install的命令，构造了一个称之为MathFunctionsTargets的export对象，接下来，就是指明生成的cmake文件的存放路径,cmake的配置文件名称为MathFunctionsTargets.cmake。
```
install(EXPORT MathFunctionsTargets
        FILE MathFunctionsTargets.cmake
        NAMESPACE MathFunctions::
        DESTINATION lib/cmake/MathFunctions
)
```

MathFunctionsTargets.cmake的内容如下

```
# Create imported target MathFunctions::MathFunctions
add_library(MathFunctions::MathFunctions STATIC IMPORTED)

set_target_properties(MathFunctions::MathFunctions PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include"
)
```

&emsp;&emsp;使用MathFunctionsTargets的方法：
```
include(${INSTALL_PREFIX}/lib/cmake/MathFunctionTargets.cmake)
 add_executable(myexe src1.c src2.c )
 target_link_libraries(myexe PRIVATE MathFunctions::MathFunctions)
```
&emsp;&emsp;一个export name可以关联多个target, 例如：
```
# A/CMakeLists.txt
add_executable(myexe src1.c)
install(TARGETS myexe DESTINATION lib/myproj
        EXPORT myproj-targets)

# B/CMakeLists.txt
add_library(foo STATIC foo1.c)
install(TARGETS foo DESTINATION lib EXPORTS myproj-targets)

# Top CMakeLists.txt
add_subdirectory (A)
add_subdirectory (B)
install(EXPORT myproj-targets DESTINATION lib/myproj)
```


&emsp;&emsp;但要注意的是，这里仍旧有一个${INSTALL_PREFIX}的路径，这也是include这种方式的笨拙之处，更加灵巧的方式是利用find_package（见2.3 package节）。

## 2.3 package
<!-- &emsp;&emsp;find_package在用的时候，需要用到如下的两个文件：
* a configuration file
* a package version file

&emsp;&emsp;那么如何生成这两个文件呢？
&emsp;&emsp;首先把这个工具include进来
```
include(CMakePackageConfigHelpers)
```

CMakePackageConfigHelpers提供了configure_package_config_file指令来生成配置文件。

```configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/MathFunctionsConfig.cmake"
  INSTALL_DESTINATION lib/cmake/MathFunctions
)
``` -->
这部分暂且跳过，等用到了再看

# 3. 一些不成熟的想法

* 什么是targets？
targets可以理解为executable和library两种

* 学习一个新的概念？
了解这个概念的提出是为了什么。

# 4. 做中想

* 为什么提出这一概念
* 这一概念是如何实现的
  * 这一概念实现的先驱是什么
* 这一概念的抽象意义