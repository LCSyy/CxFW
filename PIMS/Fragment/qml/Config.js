.pragma library
.import CxQuick 0.1 as Cx

// Settings options
const settings = {
    host: "host",
    port: "port",
    basicAuthKey: "basicAuthKey",
    basicAuthValue: "basicAuthValue",
};

function basicAuth() {
    var auth = {
        "Authorization": Cx.CxSettings.get(settings.basicAuthKey) + ":" + Cx.CxSettings.get(settings.basicAuthValue),
    };
    return auth;
}
