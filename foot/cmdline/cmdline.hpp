#ifndef CMDLINE_HPP
#define CMDLINE_HPP

#include <string>
#include <map>
#include "cmditem"

class CmdLine {
public:
    ~CmdLine();

    void add_option(const std::string &opt, bool short_style = false, const std::string &arg="", const std::string &dft="", const std::string &desc="");
    void add_argument(const std::string &arg, const std::string &desc="");
    int parse(int argc, char *argv[]);

private:
    std::map<std::string, CmdLineItem> m_options;
    std::map<std::string, CmdLineItem> m_args;
};

#endif
