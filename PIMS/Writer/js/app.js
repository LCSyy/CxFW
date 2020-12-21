
// format 格式化时间
Date.prototype.format = function(format) {
    var date = {
        "M+": this.getMonth() + 1,
        "d+": this.getDate(),
        "h+": this.getHours(),
        "m+": this.getMinutes(),
        "s+": this.getSeconds(),
        "q+": Math.floor((this.getMonth() + 3) / 3),
        "S+": this.getMilliseconds()
    };
    if (/(y+)/i.test(format)) {
        format = format.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
    }
    for (var k in date) {
        if (new RegExp("(" + k + ")").test(format)) {
            format = format.replace(RegExp.$1, RegExp.$1.length === 1
                ? date[k] : ("00" + date[k]).substr(("" + date[k]).length));
        }
    }
    return format;
}

// getFirstLine 获取输入文本中的第一行内容
function getFirstLine(txt) {
    if (txt.length === 0) { return ''; }
    const lineEndIdx = txt.indexOf('\n');
    if (lineEndIdx === -1) {
        return txt;
    }
    return txt.substring(0,lineEndIdx);
}

// db 返回数据库对象
function db() {
    return LocalStorage.openDatabaseSync("writer.db",DBVersion,"storage",1000000);
}

// initDB 应用启动时尝试初始化数据库
function initDB() {
    var d = db();
    d.transaction(function(tx){
        tx.executeSql('CREATE TABLE IF NOT EXISTS blog (' +
                      'id INTEGER PRIMARY KEY ASC,'+
                      'uuid TEXT NOT NULL UNIQUE,'+
                      'title TEXT,'+
                      'content TEXT,'+
                      'tags TEXT,'+
                      'status TEXT,'+
                      'create_dt TEXT,'+
                      'update_dt TEXT)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS tags (id INTEGER PRIMARY KEY ASC, name TEXT NOT NULL UNIQUE, title TEXT);');
    });
}

// getData 获取所有数据
function getData(sql,params) {
    console.log("[SQL] " + sql);
    var d = db();
    var datas = [];
    d.readTransaction(function(tx){
        var result = null;
        if (params === undefined) {
            result = tx.executeSql(sql);
        } else {
            result = tx.executeSql(sql,params);
        }
        for (var i = 0; i < result.rows.length; ++i) {
            datas.push(result.rows.item(i));
        }
    });
    return datas;
}
