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
    });

    // d.changeVersion("0.0.5","0.0.6",function(tx){
    //     tx.executeSql("ALTER TABLE blog RENAME udpate_dt TO update_dt;");
    // });
}

// saveData 保存数据
// 如果有id, 则表示更新数据；没有，则表示新建数据
// params:
//   row: {
//     id: int8,
//     uuid: string,
//     title: string,
//     content: string,
//     tags: array<string>,
//     create_dt: string,
//     update_dt: string
//   }
function saveData(row) {
    var d = db();
    const id = row.id || 0;

    var retId = row.id;
    if (id === 0) {
        d.transaction(function(tx){
            const result = tx.executeSql('INSERT INTO blog(uuid,title,content,tags,create_dt,update_dt) VALUES (?,?,?,?,?,?)',
                [row.uuid, row.title, row.content, row.tags || null, row.create_dt, row.create_dt]
            );

            retId = result.insertId;
        });
    } else {
        d.transaction(function(tx){
            tx.executeSql('UPDATE blog SET title = ?, content = ?, tags = ?, update_dt = ? WHERE id = ?;',
                [row.title, row.content, row.tags || null, row.update_dt, row.id]
            );
        });
    }
    return retId;
}

// removeData 删除数据
function removeData(uuid) {
    var d = db();
    d.transaction(function(tx){
        tx.executeSql("DELETE FROM blog WHERE uuid = ?", [uuid]);
    });
}

// getData 获取所有数据
function getData() {
    var d = db();
    var datas = [];
    d.readTransaction(function(tx){
        const result = tx.executeSql("SELECT * FROM blog ORDER BY update_dt DESC;");
        for (var i = 0; i < result.rows.length; ++i) {
            datas.push(result.rows.item(i));
        }
    });
    return datas;
}
