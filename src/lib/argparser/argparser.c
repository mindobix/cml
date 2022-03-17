#include <stdlib.h>
#include "argparser.h"

struct ArgStruct runArgParser(int argc, char** argv) {
    struct ArgStruct argStruct;

    argStruct.command1 = argv[1];
    argStruct.command2 = argv[2];
    argStruct.command3 = argv[3];
    
    return argStruct;
}
