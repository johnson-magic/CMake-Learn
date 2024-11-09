# CMake generated Testfile for 
# Source directory: /home/ecs-user/code/CMake-Learn/code
# Build directory: /home/ecs-user/code/CMake-Learn/code/build
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(Runs "/home/ecs-user/code/CMake-Learn/code/build/Tutorial" "25")
set_tests_properties(Runs PROPERTIES  _BACKTRACE_TRIPLES "/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;38;add_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;0;")
add_test(Usage "/home/ecs-user/code/CMake-Learn/code/build/Tutorial")
set_tests_properties(Usage PROPERTIES  PASS_REGULAR_EXPRESSION "Usage:.*number" _BACKTRACE_TRIPLES "/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;41;add_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;0;")
add_test(Comp4 "/home/ecs-user/code/CMake-Learn/code/build/Tutorial" "4")
set_tests_properties(Comp4 PROPERTIES  PASS_REGULAR_EXPRESSION "4 is 2" _BACKTRACE_TRIPLES "/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;48;add_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;55;do_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;0;")
add_test(Comp9 "/home/ecs-user/code/CMake-Learn/code/build/Tutorial" "9")
set_tests_properties(Comp9 PROPERTIES  PASS_REGULAR_EXPRESSION "9 is 3" _BACKTRACE_TRIPLES "/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;48;add_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;56;do_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;0;")
add_test(Comp5 "/home/ecs-user/code/CMake-Learn/code/build/Tutorial" "5")
set_tests_properties(Comp5 PROPERTIES  PASS_REGULAR_EXPRESSION "5 is 2.236" _BACKTRACE_TRIPLES "/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;48;add_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;57;do_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;0;")
add_test(Comp7 "/home/ecs-user/code/CMake-Learn/code/build/Tutorial" "7")
set_tests_properties(Comp7 PROPERTIES  PASS_REGULAR_EXPRESSION "7 is 2.645" _BACKTRACE_TRIPLES "/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;48;add_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;58;do_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;0;")
add_test(Comp25 "/home/ecs-user/code/CMake-Learn/code/build/Tutorial" "25")
set_tests_properties(Comp25 PROPERTIES  PASS_REGULAR_EXPRESSION "25 is 5" _BACKTRACE_TRIPLES "/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;48;add_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;59;do_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;0;")
add_test(Comp-25 "/home/ecs-user/code/CMake-Learn/code/build/Tutorial" "-25")
set_tests_properties(Comp-25 PROPERTIES  PASS_REGULAR_EXPRESSION "-25 is [-nan|nan|0]" _BACKTRACE_TRIPLES "/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;48;add_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;60;do_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;0;")
add_test(Comp0.0001 "/home/ecs-user/code/CMake-Learn/code/build/Tutorial" "0.0001")
set_tests_properties(Comp0.0001 PROPERTIES  PASS_REGULAR_EXPRESSION "0.0001 is 0.01" _BACKTRACE_TRIPLES "/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;48;add_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;61;do_test;/home/ecs-user/code/CMake-Learn/code/CMakeLists.txt;0;")
subdirs("MathFunctions")
