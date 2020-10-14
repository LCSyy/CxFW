#ifndef CXCOMMAND_LINE_PARSER_H
#define CXCOMMAND_LINE_PARSER_H

class CxCommandLineParser {
public:
    int exec(int argc, char *argv[]);
    void add_option();
};

#endif
