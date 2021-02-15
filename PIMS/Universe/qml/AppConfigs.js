.pragma library
.import Universe 0.1 as Universe

// Content s0tatus
const status = {
    Active: 0, // 激活
    InActive: 1, // 未激活
    InValid: 2, // 失效
    Trash: 3, // 删除
};

// Content badges
const badges = {
    Rank: 0, // 置顶排序
};

// Settings options
const settings = {
    contentLineWrap: "contentLineWrap",
    contentFontPointSize: "contentFontPointSize",
    host: "host",
    port: "port",
    basicAuthKey: "basicAuthKey",
    basicAuthValue: "basicAuthValue",
    naviExpandArray: "naviExpand",
    naviItemExpand: "expand",
    defaultNavi: "defaultNavi",
    naviSizeName: "naviSize",
    naviSize: 300,
};

function basicAuth() {
    var auth = {
        "Authorization": Universe.CxSettings.get(settings.basicAuthKey) + ":" + Universe.CxSettings.get(settings.basicAuthValue),
    };
    return auth;
}
