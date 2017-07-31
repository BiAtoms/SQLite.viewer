"use strict";

var Api = {};

Api.onError = function (reason) {
    console.log(reason);
}

Api.get = function(url, params, success, options) {
if (typeof success === 'undefined') {
    success = params;
    params = null;
}

$.ajax($.extend({
        url: 'api/databases/' + url,
        type: 'GET',
        data: params,
        dataType: 'json',
        success: function(json) {        
            var handler = json.success ? success : Api.onError;
            handler(json.data);
        },
    }, options));
}

Api.getDbList = function (success) {
    Api.get('/', success);
}

Api.getTableList = function (database, success) {
    Api.get(database + '/tables', success);
}

Api.getTableData = function (database, table, success) {
    Api.get(database + '/tables/' + table, success);
}

Api.executeQuery = function (database, query, success) {
    Api.get(database + '/execute', { query: query } , success);
}

Api.downloadDatabase = function (database, completion) {
    Api.get(database + '/download', null, null, { error: function(_, b) {
        if (b = "parsererror") {
            window.location = "api/databases/" + database + "/download";
            completion();
        }
    }});
}