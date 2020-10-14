#ifndef CMDITEM_HPP
#define CMDITEM_HPP

struct CmdLineItem {
    const std::string &long_name() const { return m_long_name; }
    const std::string &short_name() const { return m_short_name; }
    const std::string &arg_name() const { return m_arg_name; }
    const std::string &default_value() const { return m_default_name; }
    const std::string &desciption() const { return m_desc; }

    std::string m_long_name;
    std::string m_short_name;
    std::string m_arg_name;
    std::string m_default_name;
    std::string m_desc;
};

#endif
