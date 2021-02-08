#ifndef SYNTAXDEFINITIONS_H
#define SYNTAXDEFINITIONS_H

// 从文本到HTML
// 不在 Markdown 涵盖范围之内的标签，都可以直接在文档里面用 HTML 撰写。
namespace md {
    enum class Tag {
        Head1,
        Head2,
        Head3,
        Head4,
        Head5,
        Head6,

        Bold,
    };

    static const char *Head = "#";
    static const char *Head1 = "#";
    static const char *Head2 = "##";
    static const char *Head3 = "###";
    static const char *Head4 = "####";
    static const char *Head5 = "#####";
    static const char *Head6 = "######";

    static const char *BoldStart = "**";
    static const char *BoldStop = "**";
}

#endif // SYNTAXDEFINITIONS_H
