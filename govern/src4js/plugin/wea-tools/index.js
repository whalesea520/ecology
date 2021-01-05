import { message } from 'antd';
// import message from '../../_antd1.11.2/message'
import isEmpty from 'lodash/isEmpty'

const server = window.server || "";

const getFd = (values) => {
    let fd = "";
    for (let p in values) {
        if (p == 'jsonstr' && typeof values[p] === 'object') {
            fd += p + "=" + JSON.stringify(values[p]).replace(/\\/g, '') + "&";
        } else {
            fd += p + "=" + encodeURIComponent(values[p]) + "&";
        }
    }
    fd += "__random__=" + new Date().getTime();
    return fd;
}

const getFetchParams = (method, params) => {
    let obj = {
        method: method,
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
            'X-Requested-With': 'XMLHttpRequest'
        },
    };
    if (server == "") {
        obj.credentials = "include";
    }
    if (!isEmpty(params) && method.toUpperCase() !== 'GET') {
        obj.body = getFd(params);
    }
    return obj;
}

const checkReject = (obj) => {
    let isFalse = false;
    if (obj.errorCode && obj.errorCode === "001") { //session异常，如果有路由就强制跳转
        message.error("session过期，请重新登陆！", 5);
        //跳转登陆页
        if (weaHistory) {
            weaHistory.push("/");
        }
        else if (weaWfHistory) {
            window.href.location = "/wui/index.jsp";
        }
        isFalse = true;
    }
    else if (typeof obj.status !== 'undefined' && (!obj.status || obj.status === 'false')) {
        message.error("接口业务逻辑错误：" + obj.error, 5);
        isFalse = true;
    }
    return isFalse;
}

const trim = (s) => {
    return s.replace(/(^\s*)|(\s*$)/g, '');
}

const tools = {
    ls: {
        set: function (key, val) {
            if (typeof val === "string") {
                window.localStorage[key] = val;
            }
            if (typeof val === "object") {
                window.localStorage[key] = JSON.stringify(val);
            }
        },
        getStr: function (key) {
            return window.localStorage[key] || "";
        },
        getJSONObj: function (key) {
            if (!window.localStorage[key]) return null;
            return JSON.parse(window.localStorage[key]);
        }
    },
    ss: {
        set: function (key, val) {
            if (typeof val === "string") {
                window.sessionStorage[key] = val;
            }
            if (typeof val === "object") {
                window.sessionStorage[key] = JSON.stringify(val);
            }
        },
        getStr: function (key) {
            return window.sessionStorage[key] || "";
        },
        getJSONObj: function (key) {
            if (!window.sessionStorage[key]) return null;
            return JSON.parse(window.sessionStorage[key]);
        }
    },
    tryCatch: function (React, ErrorHandler, handlerOptions) {
        if (!React || !React.Component) {
            throw new Error('arguments[0] for react-try-catch-render does not look like React.');
        }
        if (typeof ErrorHandler !== 'function') {
            throw new Error('arguments[1] for react-try-catch-render does not look like a function.');
        }
        /**
         * Implementation of the try/catch wrapper
         * @param  {[React.Component]} component The ES6 React.Component
         */
        return function wrapWithTryCatch(Component) {
            const originalRender = Component.prototype.render;

            Component.prototype.render = function tryRender() {
                try {
                    return originalRender.apply(this, arguments);
                } catch (err) {
                    // Log an error
                    window.console && console.error("errorLog:", err);
                    if (ErrorHandler.prototype && ErrorHandler.prototype.render) {
                        return React.createElement(ErrorHandler, handlerOptions);
                    }
                    // ErrorHandler is at least a valid function
                    return ErrorHandler(err);
                }
            };
            return Component;
        };
    },
    callApi: (url, method = 'GET', params = {}, type = 'json') => {
        url = `${server}${url}`;
        if (method.toUpperCase() === 'GET' && !isEmpty(params)) {
            url = `${url}?${getFd(params)}`;
        }
        return new Promise((resolve, reject) => {
            fetch(url, getFetchParams(method, params)).then(function (response) {
                let data = "";
                if (type === "json")
                    data = response.json();
                else
                    data = response.text();
                return data
            }).then(data => {
                if (checkReject(data)) {
                    reject(`${url} fetch 请求异常: ${data.error || 'error'}`);
                }
                else {
                    resolve(data);
                }
            }).catch(function (ex) {
                reject(`${url} fetch 数据处理异常: ${ex}`);
            });
        });
    },
    onUrl: (key, title, url) => {
        if (typeof (window.top.onUrl) == "function") {
            window.top.onUrl(key, title, url);
        } else {
            var obj = window.self;
            while (true) {
                if (typeof (obj.window.onUrl) == "function") {
                    obj.window.onUrl(key, title, url);
                    break;
                }
                if (obj == obj.window.parent) {
                    break;
                }
                obj = obj.window.parent;
            }
        }
    },
    onCloseMenu: () => {
        if (typeof (window.top.closeGovernMenu) == "function") {
            window.top.closeGovernMenu();
        } else {
            var obj = window.self;
            while (true) {
                if (typeof (obj.window.closeGovernMenu) == "function") {
                    obj.window.closeGovernMenu();
                    break;
                }
                if (obj == obj.window.parent) {
                    break;
                }
                obj = obj.window.parent;
            }
        }
    },
    checkSession: (nextState, replace, callback) => {
        //console.log("in checkSession!");
        /*setTimeout(()=>{
            console.log("listDoing async!");
            replace({pathname:"/"}); //强制登出或者报错
            callback();
        },1000);

        */
        callback();
    },
    contains: (arr, obj) => {
        if (!arr)
            return false;
        var i = arr.length;
        while (i--) {
            if (arr[i] === obj) {
                return true;
            }
        }
        return false;

    },
    getTextWidth: (str) => {
        let width = 0;
        if (str) {
            for (var i = 0; i < str.length; i++) {
                //如果是汉字
                if (str.charCodeAt(i) > 255) {
                    width += 14;
                }
                else {
                    width += 7;
                }
            }
        }
        return width;
    }
}

export default tools;