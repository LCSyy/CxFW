#include <iostream>
#include <core/cxcommand_line_parser.h>

int main(int argc, char *argv[]) {
    CxCommandLineParser parser;
    return parser.exec(argc,argv);
}

