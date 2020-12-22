// getFirstLine 获取输入文本中的第一行内容
function getFirstLine(txt) {
    if (txt.length === 0) { return ''; }
    const lineEndIdx = txt.indexOf('\n');
    if (lineEndIdx === -1) {
        return txt;
    }
    return txt.substring(0,lineEndIdx);
}
