#include <iostream>
#include <unordered_map>

#include <cmdline/cmdline.hpp>

using namespace std;

struct MyNode {
    std::string msg;
};

int main(int argc, char *argv[]) {
    CmdLine cli;
    
    // CmdLineItem item;
    // item.long_name = "";
    // item.short_name = "";
    // item.desc = "";
    // item.args = "";
    // item.handler = ...;

    cli.add_option("version",true,"","","Show the cxfw version.");
    cli.add_option("help",true,"","","Show help.");

    return cli.parse(argc, argv);
}
