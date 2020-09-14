.import QtQuick.LocalStorage 2.15 as DB

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

function isEmptyRow(row) {
    // ...
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

// uuid 根据当前时间生成uuid
function uuid(date) {
    return date.format('YYYYMMddhhmmssSS')
}

// db 返回数据库对象
function db() {
    return DB.LocalStorage.openDatabaseSync("writer.db","","storage",1000000);
}

// initDB 应用启动时尝试初始化数据库
function initDB() {
    var d = db();
    d.transaction(function(tx){
        tx.executeSql('CREATE TABLE IF NOT EXISTS blog (id INTEGER PRIMARY KEY ASC, uuid TEXT NOT NULL UNIQUE, title TEXT, content TEXT, tags TEXT, create_dt TEXT, update_dt TEXT);');
        tx.executeSql('CREATE TABLE IF NOT EXISTS tags (id INTEGER PRIMARY KEY ASC, name TEXT NOT NULL UNIQUE, title TEXT);');
    });

    // d.changeVersion("0.0.5","0.0.6",function(tx){
    //     tx.executeSql("ALTER TABLE blog RENAME udpate_dt TO update_dt;");
    // });
}

// makeRow
// params:
//   row: map
// return:
//   array<any>
function makeRow(keys, row) {
    var vals = [];
    for (var i in keys) {
        const key = keys[i];
        const val = row[key];
        vals.push(val || null);
    }
    return vals;
}

// insertRow
function insertRow(sql, keys, row) {
    console.log("[SQL] " + sql);
    var d = db();
    var retId = 0;
    d.transaction(function(tx){
        const result = tx.executeSql(sql,makeRow(keys,row));
        retId = result.insertId;
    });
    return retId;
}

// updateRow
function updateRow(sql, keys, row) {
    console.log("[SQL] " + sql);
    var d = db();
    if ((row.id || 0) === 0) { throw "[SQL ERROR] UPDATE sql has no id."; }

    d.transaction(function(tx){
        tx.executeSql(sql,makeRow(keys, row));
    });
}

// removeData 删除数据
function removeData(sql, id) {
    console.log("[SQL] " + sql);
    var d = db();
    d.transaction(function(tx){
        tx.executeSql(sql, [id]);
    });
}

// getData 获取所有数据
function getData(sql) {
    console.log("[SQL] " + sql);
    var d = db();
    var datas = [];
    d.readTransaction(function(tx){
        const result = tx.executeSql(sql);
        for (var i = 0; i < result.rows.length; ++i) {
            datas.push(result.rows.item(i));
        }
    });
    return datas;
}
