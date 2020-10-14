#include "cmdline.hpp"
#include <iostream>

//! class CmdLine
//!
//! 用于解析命令行参数。
//! 符合POSIX标准建议和GNUC的长选项格式。
//! 
//! 创建CmdLineItem，设置选项或者参数名称，描述，以及相应的处理句柄后，使用Cmdline::add_option或Cmdline::add_argument添加到应用的命令行选项里面
//! 最后执行Cmdline::parse，如果参数合法，则会解析并执行相应处理函数；如果不合法则会显示默认错误，或者自定义错误处理函数。

/*!
另一种形式的文档注释。
*/

CmdLine::~CmdLine() {
    // ...
}

/// 添加命令行选项。
void CmdLine::add_option(const std::string &opt, bool short_style, const std::string &arg, const std::string &dft, const std::string &desc) {
    CmdLineItem item;
    item.m_long_name = opt;
    item.m_short_name = std::string(1,opt[0]);
    item.m_arg_name = arg;
    item.m_default_name = dft;
    item.m_desc = desc;

    m_options.insert({item.m_long_name,item});
    m_options.insert({item.m_short_name,item});
}

/// 添加非选项命令行参数。
void CmdLine::add_argument(const std::string &arg, const std::string &desc) {
    CmdLineItem cli_arg;
    cli_arg.m_arg_name = arg;
    cli_arg.m_desc = desc;

    m_args.insert({arg,cli_arg});
}

/// 根据设置，解析输入命令行选项和参数。
/// 根据已解析参数，执行相应操作。
int CmdLine::parse(int argc, char *argv[]) {
    for (int i = 1; i < argc; ++i) {
        std::cout << argv[i] << std::endl;
    }
    return 0;
}

/*

cxfw --version        # option with no arg
cxfw --help writer    # option with arg
cxfw plan1 plan2      # only args

option arg
map
handler
*/