#include <iostream>
#include <string>
#include "TutorialConfig.h"
#ifdef USE_MYMATH
  #include "mysqrt.h"
#else
  #include <cmath>
#endif



int main(int argc, char* argv[])
{
  if (argc < 2) {
    // report version
    std::cout << argv[0] << " Version " << Tutorial_VERSION_MAJOR << "."
              << Tutorial_VERSION_MINOR << std::endl;
    std::cout << "Usage: " << argv[0] << " number" << std::endl;
    return 1;
  }

  const double inputValue = std::stod(argv[1]);

  #ifdef USE_MYMATH
    const double outputValue = mathfunctions::detail::mysqrt(inputValue);
  #else
    const double outputValue = std::sqrt(inputValue);
  #endif

  std::cout << "The square root of " << inputValue << " is " << outputValue
            << std::endl;
  return 0;


}