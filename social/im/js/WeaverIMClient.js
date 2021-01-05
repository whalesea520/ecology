(function(global, undefined) {
    if (global.RongIMClient) {
        return
    }

    // 通讯工具方法
    var WeaverBridge;

    // 生成一个UUID
    var CHARS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
    function getUUID() {
        var chars = CHARS, uuid = new Array(36), rnd=0, r;
        for (var i = 0; i < 36; i++) {
            if (i==8 || i==13 ||  i==18 || i==23) {
                uuid[i] = '-';
            } else if (i==14) {
                uuid[i] = '4';
            } else {
                if (rnd <= 0x02) rnd = 0x2000000 + (Math.random()*0x1000000)|0;
                r = rnd & 0xf;
                rnd = rnd >> 4;
                uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
            }
        }
        return uuid.join('');
    }



    var RongIMEnum = function(namesToValues) {
        var enumeration = function() {
            throw "can't Instantiate Enumerations"
        };
        enumeration.setValue = function(x) {
            var val = null;
            enumeration.foreach(function(i) {
                if (i.value == x || i.name == x) {
                    val = enumeration[i.name]
                }
            }, null);
            return val
        };

        function inherit(superCtor) {
            var ctor = function() {};
            ctor.prototype = superCtor;
            return new ctor
        }
        var proto = enumeration.prototype = {
            constructor: enumeration,
            toString: function() {
                return this.name
            },
            valueOf: function() {
                return this.value
            },
            toJSON: function() {
                return this.name
            }
        };
        enumeration.values = [];
        for (var _name in namesToValues) {
            var e = inherit(proto);
            e.name = _name;
            e.value = namesToValues[_name];
            enumeration[_name] = e;
            enumeration.values.push(e)
        }
        enumeration.foreach = function(f, c) {
            for (var i = 0, len = this.values.length; i < len; i++) {
                f.call(c, this.values[i])
            }
        };
        return enumeration
    };
    var io = {
            util: {
                load: function(fn) {
                    if (document.readyState == "complete" || io.util._pageLoaded) {
                        return fn()
                    }
                    if (global.attachEvent) {
                        global.attachEvent("onload", fn)
                    } else {
                        global.addEventListener("load", fn, false)
                    }
                },
                inherit: function(ctor, superCtor) {
                    for (var i in superCtor.prototype) {
                        ctor.prototype[i] = superCtor.prototype[i]
                    }
                },
                _extends: function(one, two) {
                    one.prototype = new two;
                    one.prototype.constructor = one
                },
                indexOf: function(arr, item, from) {
                    for (var l = arr.length, i = (from < 0) ? Math.max(0, +from) : from || 0; i < l; i++) {
                        if (arr[i] == item) {
                            return i
                        }
                    }
                    return -1
                },
                isArray: function(obj) {
                    return Object.prototype.toString.call(obj) == "[object Array]"
                },
                forEach: (function() {
                    if ([].forEach) {
                        return function(arr, func) {
                            [].forEach.call(arr, func)
                        }
                    } else {
                        return function(arr, func) {
                            for (var i = 0, len = arr.length; i < len; i++) {
                                func.call(arr, arr[i], i, arr)
                            }
                        }
                    }
                })(),
                each: function(obj, callback) {
                    if (this.isArray(obj)) {
                        this.forEach(x, callback)
                    } else {
                        for (var _name in obj) {
                            if (obj.hasOwnProperty(_name)) {
                                callback.call(obj, _name, obj[_name])
                            }
                        }
                    }
                },
                merge: function(target, additional) {
                    for (var i in additional) {
                        if (additional.hasOwnProperty(i)) {
                            target[i] = additional[i]
                        }
                    }
                },
                arrayFrom: function(typedarray) {
                    if (Object.prototype.toString.call(typedarray) == "[object ArrayBuffer]") {
                        var arr = new Int8Array(typedarray);
                        return [].slice.call(arr)
                    }
                    return typedarray
                },
                arrayFromInput: function(typedarray) {
                    if (Object.prototype.toString.call(typedarray) == "[object ArrayBuffer]") {
                        var arr = new Uint8Array(typedarray);
                        return arr
                    }
                    return typedarray
                },
                remove: function(array, func) {
                    for (var i = 0, len = array.length; i < len; i++) {
                        if (func(array[i])) {
                            return array.splice(i, 1)[0]
                        }
                    }
                    return null
                },
                int64ToTimestamp: function(obj, isDate) {
                    if (obj.low === undefined) {
                        return obj
                    }
                    var low = obj.low;
                    if (low < 0) {
                        low += 4294967295 + 1
                    }
                    low = low.toString(16);
                    var timestamp = parseInt(obj.high.toString(16) + "00000000".replace(new RegExp("0{" + low.length + "}$"), low), 16);
                    if (isDate) {
                        return new Date(timestamp)
                    }
                    return timestamp
                },
                ios: /iphone|ipad/i.test(navigator.userAgent),
                android: /android/i.test(navigator.userAgent)
            }
        },
        func = function() {
            io.util.cookieHelper = (function() {
                var obj, old;
                if (window.FORCE_LOCAL_STORAGE === true) {
                    old = localStorage.setItem;
                    localStorage.setItem = function(x, value) {
                        if (localStorage.length == 15) {
                            localStorage.removeItem(localStorage.key(0))
                        }
                        old.call(localStorage, x, value)
                    };
                    obj = localStorage
                } else {
                    obj = {
                        getItem: function(x) {
                            x = x.replace(/\|/, "\\|");
                            var arr = document.cookie.match(new RegExp("(^| )" + x + "=([^;]*)(;|$)"));
                            if (arr != null) {
                                return (arr[2])
                            }
                            return null
                        },
                        setItem: function(x, value) {
                            var exp = new Date();
                            exp.setTime(exp.getTime() + 15 * 24 * 3600 * 1000);
                            document.cookie = x + "=" + escape(value) + ";path=/;expires=" + exp.toGMTString()
                        },
                        removeItem: function(x) {
                            if (this.getItem(x)) {
                                document.cookie = x + "=;path=/;expires=Thu, 01-Jan-1970 00:00:01 GMT"
                            }
                        },
                        clear: function() {
                            var keys = document.cookie.match(/[^ =;]+(?=\=)/g);
                            if (keys) {
                                for (var i = keys.length; i--;) {
                                    document.cookie = keys[i] + "=0;path=/;expires=" + new Date(0).toUTCString()
                                }
                            }
                        }
                    }
                }
                return obj
            })();
        };
    if (document.readyState == "interactive" || document.readyState == "complete") {
        func()
    } else {
        if (document.addEventListener) {
            document.addEventListener("DOMContentLoaded", function() {
                document.removeEventListener("DOMContentLoaded", arguments.callee, false);
                func()
            }, false)
        } else {
            if (document.attachEvent) {
                document.attachEvent("onreadystatechange", function() {
                    if (document.readyState === "interactive" || document.readyState === "complete") {
                        document.detachEvent("onreadystatechange", arguments.callee);
                        func()
                    }
                })
            }
        }
    }
    var Qos = RongIMEnum({
            AT_MOST_ONCE: 0,
            AT_LEAST_ONCE: 1,
            EXACTLY_ONCE: 2,
            DEFAULT: 3
        }),
        Type = RongIMEnum({
            CONNECT: 1,
            CONNACK: 2,
            PUBLISH: 3,
            PUBACK: 4,
            QUERY: 5,
            QUERYACK: 6,
            QUERYCON: 7,
            SUBSCRIBE: 8,
            SUBACK: 9,
            UNSUBSCRIBE: 10,
            UNSUBACK: 11,
            PINGREQ: 12,
            PINGRESP: 13,
            DISCONNECT: 14
        }),
        DisconnectionStatus = RongIMEnum({
            RECONNECT: 0,
            OTHER_DEVICE_LOGIN: 1,
            CLOSURE: 2,
            UNKNOWN_ERROR: 3,
            LOGOUT: 4,
            BLOCK: 5
        }),
        ConnectionState = RongIMEnum({
            ACCEPTED: 0,
            UNACCEPTABLE_PROTOCOL_VERSION: 1,
            IDENTIFIER_REJECTED: 2,
            SERVER_UNAVAILABLE: 3,
            TOKEN_INCORRECT: 4,
            NOT_AUTHORIZED: 5,
            REDIRECT: 6,
            PACKAGE_ERROR: 7,
            APP_BLOCK_OR_DELETE: 8,
            BLOCK: 9,
            TOKEN_EXPIRE: 10,
            DEVICE_ERROR: 11,
            NETWORK_ERROR: 12
        });

    (function() {
        io.util.load(function() {
            io.util._pageLoaded = true;
            if (!global.JSON) {
                global.JSON = {
                    parse: function(sJSON) {
                        return eval("(" + sJSON + ")")
                    },
                    stringify: (function() {
                        var toString = Object.prototype.toString;
                        var isArray = Array.isArray || function(a) {
                                return toString.call(a) === "[object Array]"
                            };
                        var escMap = {
                            '"': '\\"',
                            "\\": "\\\\",
                            "\b": "\\b",
                            "\f": "\\f",
                            "\n": "\\n",
                            "\r": "\\r",
                            "\t": "\\t"
                        };
                        var escFunc = function(m) {
                            return escMap[m] || "\\u" + (m.charCodeAt(0) + 65536).toString(16).substr(1)
                        };
                        var escRE = new RegExp('[\\"' + unescape("%00-%1F%u2028%u2029") + "]", "g");
                        return function stringify(value) {
                            if (value == null) {
                                return "null"
                            } else {
                                if (typeof value === "number") {
                                    return isFinite(value) ? value.toString() : "null"
                                } else {
                                    if (typeof value === "boolean") {
                                        return value.toString()
                                    } else {
                                        if (typeof value === "object") {
                                            if (typeof value.toJSON === "function") {
                                                return stringify(value.toJSON())
                                            } else {
                                                if (isArray(value)) {
                                                    var res = "[";
                                                    for (var i = 0, len = value.length; i < len; i++) {
                                                        res += (i ? ", " : "") + stringify(value[i])
                                                    }
                                                    return res + "]"
                                                } else {
                                                    if (toString.call(value) === "[object Object]") {
                                                        var tmp = [];
                                                        for (var k in value) {
                                                            if (value.hasOwnProperty(k)) {
                                                                tmp.push(stringify(k) + ": " + stringify(value[k]))
                                                            }
                                                        }
                                                        return "{" + tmp.join(", ") + "}"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            return '"' + value.toString().replace(escRE, escFunc) + '"'
                        }
                    })()
                }
            }
        })
    })();
    var mapping = {
            "1": 4,
            "2": 2,
            "3": 3,
            "4": 0,
            "5": 1,
            "6": 5
        },
        typeMapping = {
            "RC:TxtMsg": "TextMessage",
            "RC:ImgMsg": "ImageMessage",
            "RC:VcMsg": "VoiceMessage",
            "RC:ImgTextMsg": "RichContentMessage",
            "RC:LBSMsg": "LocationMessage",
            "RC:CmdMsg": "CommandMessage",
            "RC:ReadNtf": "ReadReceiptMessage",
            "RC:TypSts": "TypingStatusMessage"
        },
        sysNtf = {
            "RC:InfoNtf": "InformationNotificationMessage",
            "RC:ContactNtf": "ContactNotificationMessage",
            "RC:ProfileNtf": "ProfileNotificationMessage",
            "RC:CmdNtf": "CommandNotificationMessage",
            "RC:DizNtf": "DiscussionNotificationMessage"
        },
        _ReceiveMessageListener, _ConnectionStatusListener;
    var _func = function() {
        this.add = function(x) {
            for (var i = 0, len = this.length; i < len; i++) {
                if (this[i].getTargetId() === x.getTargetId() && i != 0 && this[i].getConversationType() == x.getConversationType()) {
                    this.unshift(this.splice(i, 1)[0]);
                    return
                }
            }
            this.unshift(x)
        };
        this.get = function(conver, tarid) {
            for (var i = 0, len = this.length; i < len; i++) {
                if (this[i].getTargetId() == tarid && this[i].getConversationType() == conver) {
                    return this[i]
                }
            }
            return null
        }
    };
    _func.prototype = [];
    var C2S = {
        "4": 1,
        "2": 2,
        "3": 3,
        "1": 5
    };
    function getType(str) {
        var temp = Object.prototype.toString.call(str).toLowerCase();
        return temp.slice(8, temp.length - 1)
    }

    function check(f, d) {
        var c = arguments.callee.caller;
        for (var g = 0, e = c.arguments.length; g < e; g++) {
            if (!new RegExp(getType(c.arguments[g])).test(f[g])) {
                throw new Error("The index of " + g + " parameter was wrong type " + getType(c.arguments[g]) + " [" + f[g] + "]")
            }
        }
    }

    function RongIMClient(domain, severip, serverport, resource) {
        var appkey = '',
            self = this,
            a, listenerList = [],
            _ConversationList = new _func(),
            sessionStore = global.sessionStorage || new function() {
                    var c = {};
                    this.length = 0;
                    this.clear = function() {
                        c = {};
                        this.length = 0
                    };
                    this.setItem = function(e, f) {
                        !c[e] && this.length++;
                        c[e] = f;
                        return e in c
                    };
                    this.getItem = function(e) {
                        return c[e]
                    };
                    this.removeItem = function(f) {
                        if (f in c) {
                            delete c[f];
                            this.length--;
                            return true
                        }
                        return false
                    }
                };
        // 传输工具对象
        var weaverBridge = new WeaverBridge(domain, severip, serverport, resource);


        this.bolHistoryMessages = true;
        this.deltaTime = 0;
        this.clearTextMessageDraft = function(c, e) {
            check(["object", "string"]);
            return sessionStore.removeItem(c + "_" + e)
        };
        this.getTextMessageDraft = function(c, d) {
            check(["object", "string"]);
            return sessionStore.getItem(c + "_" + d)
        };
        this.saveTextMessageDraft = function(d, e, c) {
            check(["object", "string", "string"]);
            return sessionStore.setItem(d + "_" + e, c)
        };
        this.connect = function(_id, _udid, _connectionListener) {
            check(["string", "string", "object|undefined"]);
            if(weaverBridge.connected) {
                return;
            }
            weaverBridge.connect(_id, _udid, RongIMClient.connect.token, _connectionListener, RongIMClient.connect.callback);

            // 重连
            this.reconnect = function(callback){
                check(["object|undefined"]);
                if(weaverBridge.connected) return;
                 weaverBridge.connect(_id, _udid, RongIMClient.connect.token, _connectionListener,callback);
            };
        };
        this.disconnect = function() {
            if(weaverBridge.connected) {
                weaverBridge.disconnect();
            }
        };
        /**ping  30秒触发一次*/
        this.pingSend = function(callback){
            if((new Date().getTime()-weaverBridge.pingTime) >30000){
                try {
                    var ping = $iq({
                        to: weaverBridge.domain,
                        type: "get",
                        id: getUUID()}).c("ping", {xmlns: "urn:xmpp:ping"});
                       weaverBridge._sendPing(ping.tree(),function(iq){
                            weaverBridge.pingTime = new Date().getTime();
                            callback.onSuccess(iq.getAttribute("type")=="result");
                        },callback.onError,1000*5); 
                } catch (error) {
                     callback.onError(weaverBridge.connected);
                }
                }      
        };
        this.getPingTime = function(){
            return weaverBridge.pingTime;
        };
        this.setPingTime = function(t){
            if(t>weaverBridge.pingTime){
                weaverBridge.pingTime =t;
            }
        };
        /**ping  end*/
        this.syncConversationList = function(callback) {
            //check(["object"]);
        };
        this.sortConversationList = function(List) {
            function clone(obj) {
                var o, obj;
                if (obj.constructor == Object) {
                    o = new obj.constructor()
                } else {
                    o = new obj.constructor(obj.valueOf())
                }
                for (var key in obj) {
                    if (o[key] != obj[key]) {
                        if (typeof(obj[key]) == "object") {
                            o[key] = clone(obj[key])
                        } else {
                            o[key] = obj[key]
                        }
                    }
                }
                o.toString = obj.toString;
                o.valueOf = obj.valueOf;
                return o
            }
        };
        this.getDelaTime = function() {
            return this.deltaTime
        };
        this.getConversation = function(c, e) {
            check(["object", "string"]);
            return this.getConversationList().get(c, e)
        };
        this.getConversationList = function() {
            return _ConversationList
        };
        this.getConversationNotificationStatus = function(f, d, e) {
            //check(["object", "string", "object"]);
        };
        this.clearConversations = function(list) {
            //check(["array"]);
        };
        this.getGroupConversationList = function() {
            var arr = [];
            return arr
        };
        this.removeConversation = function(c, e) {
            //check(["object", "string"]);
        };
        this.setConversationNotificationStatus = function(f, d, g, e) {
            //check(["object", "string", "object", "object"]);
        };
        this.setConversationToTop = function(c, e) {
            //check(["object", "string"]);
        };
        this.setConversationName = function(f, e, d) {
            //check(["object", "string", "string"]);
        };
        this.createConversation = function(f, d, e, islocal) {
            check(["object", "string", "string", "boolean|undefined"]);
            var g = this.getConversationList().get(f, d);
            if (g) {
                return g
            }
            var c = new RongIMClient.Conversation();
            c.setTargetId(d);
            c.setConversationType(f);
            c.setConversationTitle(e);
            c.setTop();
            return c
        };
        this.getCurrentUserInfo = function(callback) {
            //check(["object"]);
        };
        this.getUserInfo = function(c, e) {
            //check(["string", "object"]);
        };
        this.sendMessage = function(_con, _toId, _msgObj, _callback) {
            //check(["string", "object", "object|null|global"]);
            if(weaverBridge.connected) {
                weaverBridge.sendMessage(_con, _toId, _msgObj, _callback);
            } else {
                _callback.onError(weaverBridge.connected);
                // // FIXME 重连 会造成多次重连的bug
                // this.reconnect({
                //     onSuccess : function(){
                //         weaverBridge.sendMessage(_con, _toId, _msgObj, _callback)
                //     },
                //     onError : function(){
                //         _callback.onError();
                //     }
                // });
            }
        };
        this.uploadMedia = function(f, c, d, e) {
            //check(["object", "string", "string", "object"])
        };
        this.getUploadToken = function(c) {
            //check(["object"]);
        };
        this.getDownloadUrl = function(d, c) {
            //check(["string", "object"]);
        };
        this.setConnectionStatusListener = function(c) {
            weaverBridge.setOnConnectionStatusListener(c);
        };
        this.setOnReceiveMessageListener = function(c) {
            weaverBridge.setOnReceiveMessageListener(c);
        };
        this.getTotalUnreadCount = function() {
            var count = 0;
            return count
        };
        this.getUnreadCount = function(_conversationTypes, targetId) {
            //check(["array|object", "string|undefined"]);
            return count
        };
        this.clearMessagesUnreadStatus = function(conversationType, targetId) {
            //check(["object", "string"]);
            if (conversationType == 0) {
                return false
            }
            var end = this.getConversationList().get(conversationType, targetId);
            return !!(end ? end.setUnreadMessageCount(0) || 1 : 0)
        };
        this.initChatRoom = function(Id) {
            //check(["string"]);
        };
        this.joinChatRoom = function(Id, defMessageCount, callback) {
            //check(["string", "number", "object"]);
        };
        this.quitChatRoom = function(Id, callback) {
            //check(["string", "object"]);
        };
        this.sendNotification = function(_conversationType, _targetId, _content, _callback) {
            //check(["object", "string", "object", "object"]);
            if (_content instanceof RongIMClient.NotificationMessage) {
                this.sendMessage(_conversationType, _targetId, new RongIMClient.MessageContent(_content), null, _callback)
            } else {
                throw new Error("Wrong Parameters")
            }
        };
        this.sendStatus = function(_conversationType, _targetId, _content, _callback) {
            //check(["object", "string", "object", "object"]);
            if (_content instanceof RongIMClient.StatusMessage) {
                this.sendMessage(_conversationType, _targetId, new RongIMClient.MessageContent(_content), null, _callback)
            } else {
                throw new Error("Wrong Parameters")
            }
        };
        this.setDiscussionInviteStatus = function(_targetId, _status, _callback) {
            //check(["string", "object", "object"]);
        };


        this.setDiscussionName = function(_discussionId, _name, _callback) {
            check(["string", "string", "object"]);
            weaverBridge.groupUtils.setDiscussionName(_discussionId, _name, _callback);
        };
        this.setDiscussionAdmin = function(_discussionId, _admins, _callback){
            check(["string", "string", "object"]);
            weaverBridge.groupUtils.setDiscussionAdmin(_discussionId, _admins, _callback);
        };
        this.setDiscussionIcon = function(_discussionId,_discussionIcon,_callback){
             check(["string", "string", "object"]);
            weaverBridge.groupUtils.setDiscussionIcon(_discussionId,_discussionIcon,_callback);
        };
        this.removeMemberFromDiscussion = function(_disussionId, _userId, _callback) {
            check(["string", "string", "object"]);
            weaverBridge.groupUtils.removeMemberFromDiscussion(_disussionId, _userId, _callback);
        };
        this.createDiscussion = function(_name, _userIdList, _callback) {
            check(["string", "array", "object"]);
            weaverBridge.groupUtils.createDiscussion(_name, _userIdList, _callback);
        };
        this.addMemberToDiscussion = function(_discussionId, _userIdList, _callback) {
            check(["string", "array", "object"]);
            weaverBridge.groupUtils.addMemberToDiscussion(_discussionId, _userIdList, _callback);
        };
        this.getDiscussion = function(_discussionId, _callback) {
            check(["string", "object"]);
            weaverBridge.groupUtils.getDiscussion(_discussionId, _callback);
        };
        this.getServerConfig = function(_callback){
            check(["object"]);
            weaverBridge.groupUtils.getServerConfig(_callback);
        };
        this.quitDiscussion = function(_discussionId, _callback) {
            check(["string", "object"]);
            weaverBridge.groupUtils.quitDiscussion(_discussionId, _callback);
        };
        
        //获取在线状态
        this.getUserOnlineStatus = function(_members, _callback) {
            check(["array","object"]);
            weaverBridge.onlineStatusUtils.getUserOnlineStatus(_members,_callback);
        };
        
         //设置在线状态
        this.setUserOnlineStatus = function(status,_callback) {
            check(["string","object"]);
            weaverBridge.onlineStatusUtils.setUserOnlineStatus(status,_callback);
        };
        
        this.quitGroup = function(_groupId, _callback) {
            //check(["string", "object"]);
        };
        this.joinGroup = function(_groupId, _groupName, _callback) {
            //check(["string", "string", "object"]);
        };
        this.syncGroup = function(_groups, _callback) {
            //check(["array", "object"]);
        };
        this.addToBlacklist = function(userId, callback) {
            //check(["string", "object"]);
        };
        this.getBlacklist = function(callback) {
            //check(["object"]);
        };
        this.getBlacklistStatus = function(userId, callback) {
            //check(["string", "object"]);
        };
        this.removeFromBlacklist = function(userId, callback) {
            //check(["string", "object"]);
        };

        var HistoryMsgType = {
                "4": "qryPMsg",
                "1": "qryCMsg",
                "3": "qryGMsg",
                "2": "qryDMsg",
                "5": "qrySMsg"
            },
            LimitableMap = function(limit) {
                this.limit = limit || 10;
                this.map = {};
                this.keys = []
            },
            lastReadTime = new LimitableMap();
        LimitableMap.prototype.set = function(key, value) {
            var map = this.map;
            var keys = this.keys;
            if (!map.hasOwnProperty(key)) {
                if (keys.length === this.limit) {
                    var firstKey = keys.shift();
                    delete map[firstKey]
                }
                keys.push(key)
            }
            map[key] = value
        };
        LimitableMap.prototype.get = function(key) {
            return this.map[key] || 0
        };
        LimitableMap.prototype.remove = function(key) {
            delete this.map[key]
        };
        this.resetGetHistoryMessages = function(conversationType, userId) {
            if (typeof userId != "string") {
                userId = userId.toString()
            }
            lastReadTime.remove(conversationType + userId)
        };
        this.getSendingBox = function(callback) {
            //check(["object"]);
        };
        this.getHistoryMessages = function(targetType, fromUserId, targetId, pageSize, callback) {
            check(["string|number", "string", "string|number", "string|number", "object|undefined"]);
            var lastTime = lastReadTime.get(targetType + targetId);
            if(!lastTime || lastTime == 0) {
                lastTime = (new Date().getTime()) * 2;
            }
            weaverBridge.getHistoryMessage(targetType, fromUserId, targetId, lastTime, pageSize, {
                onSuccess: function(data) {
                    var list = data.list.reverse();
                    lastReadTime.set(targetType + targetId, io.util.int64ToTimestamp(data.syncTime));
                    setTimeout(function() {
                        callback.onSuccess(data.hasMsg, list);
                    })
                },
                onError: function(err) {
                    setTimeout(function() {
                        callback.onError(err);
                    })
                }
            });
        }
    }

    RongIMClient.isSyncOfflineMsg = true;
    RongIMClient.PCClient = false;
    RongIMClient.firstSync = true;
    RongIMClient.keepMsg = true;
    RongIMClient.connect = function(_id, _udid, _p, _connectionListener, _callback) {
        if (!RongIMClient.getInstance) {
            throw new Error("please init")
        }
        RongIMClient.connect.token = _p;
        RongIMClient.connect.callback = _callback;
        RongIMClient.getInstance().connect(_id, _udid, _connectionListener);

    };
    RongIMClient.hasUnreadMessages = function(appkey, token, callback) {
    };
    RongIMClient.init = function(domain, severip, serverport, resource) {
        var instance = null;
        RongIMClient.getInstance === undefined && (RongIMClient.getInstance = function() {
            if (instance == null) {
                instance = new RongIMClient(domain, severip, serverport, resource)
            }
            return instance
        })
    };
    var registerMessageTypeMapping = {};
    RongIMClient.registerMessageType = function(regMsg) {
        if (!RongIMClient.getInstance) {
            throw new Error("unInitException")
        }
        if ("messageType" in regMsg && "objectName" in regMsg && "fieldName" in regMsg) {
            registerMessageTypeMapping[regMsg.objectName] = regMsg.messageType;
            var temp = RongIMClient[regMsg.messageType] = function(c) {
                RongIMClient.RongIMMessage.call(this, c);
                RongIMClient.MessageType[regMsg.messageType] = regMsg.messageType;
                this.setMessageType(regMsg.messageType);
                this.setObjectName(regMsg.objectName);
                for (var i = 0, len = regMsg.fieldName.length; i < len; i++) {
                    var item = regMsg.fieldName[i];
                    this["set" + item] = (function(na) {
                        return function(a) {
                            this.setContent(a, na)
                        }
                    })(item);
                    this["get" + item] = (function(na) {
                        return function() {
                            return this.getDetail()[na]
                        }
                    })(item)
                }
            };
            io.util._extends(temp, RongIMClient.RongIMMessage)
        } else {
            throw new Error("registerMessageType:arguments type is error")
        }
    };
    RongIMClient.setConnectionStatusListener = function(a) {
        if (!RongIMClient.getInstance) {
            throw new Error("unInitException")
        }
        RongIMClient.getInstance().setConnectionStatusListener(a)
    };




    // 融云消息类型
    RongIMClient.RongIMMessage = function(content) {
        var x = "unknown",
            ISPERSISTED = 1,
            ISCOUNTED = 2,
            u, z = content || {},
            o, q, t, y, a, p, s, v, r, h = false,
            mu, c = "",b = false;
        this.getPushContent = function() {
            return c
        };
        this.getDetail = function() {
            return z
        };
        this.getMessageTag = function() {
            return [RongIMClient.MessageTag.ISPERSISTED, RongIMClient.MessageTag.ISCOUNTED, RongIMClient.MessageTag.ISDISPLAYED]
        };
        this.getContent = function() {
            return z.content
        };
        this.getConversationType = function() {
            return o
        };
        this.getPersist = function() {
            return ISPERSISTED
        };
        this.getCount = function() {
            return ISCOUNTED
        };
        this.getHasReceivedByOtherClient = function() {
            return h
        };
        this.setHasReceivedByOtherClient = function(x) {
            h = x
        };
        this.getMessageUId = function() {
            return mu
        };
        this.setMessageUId = function(x) {
            mu = x
        };
        this.setPersist = function(x) {
            var arr = [0, 1];
            if (x in arr) {
                ISPERSISTED = x
            }
        };
        this.setCount = function(x) {
            var arr = [0, 2];
            if (x in arr) {
                ISCOUNTED = x
            }
        };
        this.getExtra = function() {
            return z.extra
        };
        this.getMessageDirection = function() {
            return q
        };
        this.getMessageId = function() {
            return t
        };
        this.getObjectName = function() {
            return y
        };
        this.getReceivedStatus = function() {
            return a
        };
        this.getReceivedTime = function() {
            return u
        };
        this.getSenderUserId = function() {
            return p
        };
        this.getSentStatus = function() {
            return s
        };
        this.getTargetId = function() {
            return r
        };
        this.setPushContent = function(v) {
            c = v
        };
        this.setContent = function(c, d) {
            z[d || "content"] = c
        };
        this.setConversationType = function(c) {
            o = c
        };
        this.setExtra = function(c) {
            z.extra = c
        };
        this.setMessageDirection = function(c) {
            q = c
        };
        this.setMessageId = function(c) {
            t = c
        };
        this.setObjectName = function(c) {
            y = c
        };
        this.setReceivedStatus = function(c) {
            a = c
        };
        this.setSenderUserId = function(c) {
            p = c
        };
        this.setSentStatus = function(c) {
            return !!(s = c)
        };
        this.setSentTime = function(c) {
            v = io.util.int64ToTimestamp(c)
        };
        this.getSentTime = function() {
            return v
        };
        this.setTargetId = function(c) {
            r = c
        };
        this.setReceivedTime = function(c) {
            u = c
        };
        this.toJSONString = function() {
            var c = {
                receivedTime: u,
                messageType: x,
                details: z,
                conversationType: o,
                direction: q,
                messageId: t,
                objectName: y,
                senderUserId: p,
                sendTime: v,
                targetId: r,
                hasReceivedByOtherClient: h
            };
            return JSON.stringify(c)
        };
        this.getMessageType = function() {
            return x
        };
        this.setMessageType = function(c) {
            x = c
        };
        this.setIsOfflineMsg = function(c) {
            b = c
        };
		this.getIsOfflineMsg = function() {
			return b;
		};
    };
    RongIMClient.NotificationMessage = function(c) {
        RongIMClient.RongIMMessage.call(this, c);
        this.getMessageTag = function() {
            return [RongIMClient.MessageTag.ISPERSISTED, RongIMClient.MessageTag.ISDISPLAYED]
        };
        this.setCount(0)
    };
    io.util._extends(RongIMClient.NotificationMessage, RongIMClient.RongIMMessage);
    RongIMClient.StatusMessage = function(c) {
        RongIMClient.RongIMMessage.call(this, c);
        this.getMessageTag = function() {
            return ["NONE"]
        };
        this.setCount(0);
        this.setPersist(0)
    };
    io.util._extends(RongIMClient.StatusMessage, RongIMClient.RongIMMessage);
    RongIMClient.TextMessage = function(c) {
        RongIMClient.RongIMMessage.call(this, c);
        this.setMessageType(RongIMClient.MessageType.TextMessage);
        this.setObjectName("RC:TxtMsg")
    };
    RongIMClient.TextMessage.obtain = function(text) {
        return new RongIMClient.TextMessage({
            content: text,
            extra: ""
        })
    };
    io.util._extends(RongIMClient.TextMessage, RongIMClient.RongIMMessage);
    RongIMClient.TypingStatusMessage = function(c) {
        RongIMClient.RongIMMessage.call(this, c);
        this.setMessageType(RongIMClient.MessageType.TypingStatusMessage);
        this.setObjectName("RC:TypSts")
    };
    io.util._extends(RongIMClient.TypingStatusMessage, RongIMClient.RongIMMessage);
    RongIMClient.ReadReceiptMessage = function(c) {
        RongIMClient.RongIMMessage.call(this, c);
        this.setMessageType(RongIMClient.MessageType.ReadReceiptMessage);
        this.setObjectName("RC:ReadNtf")
    };
    io.util._extends(RongIMClient.ReadReceiptMessage, RongIMClient.RongIMMessage);
    RongIMClient.ImageMessage = function(c) {
        RongIMClient.RongIMMessage.call(this, c);
        this.setMessageType(RongIMClient.MessageType.ImageMessage);
        this.setObjectName("RC:ImgMsg");
        this.setImageUri = function(a) {
            this.setContent(a, "imageUri")
        };
        this.getImageUri = function() {
            return this.getDetail().imageUri
        }
    };
    RongIMClient.ImageMessage.obtain = function(content, imageUri) {
        return new RongIMClient.ImageMessage({
            content: content,
            imageUri: imageUri,
            extra: ""
        })
    };
    io.util._extends(RongIMClient.ImageMessage, RongIMClient.RongIMMessage);
    RongIMClient.RichContentMessage = function(c) {
        RongIMClient.RongIMMessage.call(this, c);
        this.setMessageType(RongIMClient.MessageType.RichContentMessage);
        this.setObjectName("RC:ImgTextMsg");
        this.setTitle = function(a) {
            this.setContent(a, "title")
        };
        this.getTitle = function() {
            return this.getDetail().title
        };
        this.setImageUri = function(a) {
            this.setContent(a, "imageUri")
        };
        this.getImageUri = function() {
            return this.getDetail().imageUri
        }
    };
    RongIMClient.RichContentMessage.obtain = function(title, content, imageUri) {
        return new RongIMClient.RichContentMessage({
            title: title,
            content: content,
            imageUri: imageUri,
            extra: ""
        })
    };
    io.util._extends(RongIMClient.RichContentMessage, RongIMClient.RongIMMessage);
    RongIMClient.VoiceMessage = function(c) {
        RongIMClient.RongIMMessage.call(this, c);
        this.setObjectName("RC:VcMsg");
        this.setMessageType(RongIMClient.MessageType.VoiceMessage);
        this.setDuration = function(a) {
            this.setContent(a, "duration")
        };
        this.getDuration = function() {
            return this.getDetail().duration
        }
    };
    RongIMClient.VoiceMessage.obtain = function(content, duration) {
        return new RongIMClient.VoiceMessage({
            content: content,
            duration: duration,
            extra: ""
        })
    };
    io.util._extends(RongIMClient.VoiceMessage, RongIMClient.RongIMMessage);
    RongIMClient.HandshakeMessage = function() {
        RongIMClient.RongIMMessage.call(this);
        this.setMessageType(RongIMClient.MessageType.HandshakeMessage);
        this.setObjectName("RC:HsMsg")
    };
    io.util._extends(RongIMClient.HandshakeMessage, RongIMClient.RongIMMessage);
    RongIMClient.SuspendMessage = function() {
        RongIMClient.RongIMMessage.call(this);
        this.setMessageType(RongIMClient.MessageType.SuspendMessage);
        this.setObjectName("RC:SpMsg")
    };
    io.util._extends(RongIMClient.SuspendMessage, RongIMClient.RongIMMessage);
    RongIMClient.UnknownMessage = function(c, o) {
        RongIMClient.RongIMMessage.call(this, c);
        this.setMessageType(RongIMClient.MessageType.UnknownMessage);
        this.setObjectName(o)
    };
    io.util._extends(RongIMClient.UnknownMessage, RongIMClient.RongIMMessage);
    RongIMClient.LocationMessage = function(c) {
        RongIMClient.RongIMMessage.call(this, c);
        this.setMessageType(RongIMClient.MessageType.LocationMessage);
        this.setObjectName("RC:LBSMsg");
        this.setLatitude = function(a) {
            this.setContent(a, "latitude")
        };
        this.getLatitude = function() {
            return this.getDetail().latitude
        };
        this.setLongitude = function(a) {
            this.setContent(a, "longitude")
        };
        this.getLongitude = function() {
            return this.getDetail().longitude
        };
        this.setPoi = function(a) {
            this.setContent(a, "poi")
        };
        this.getPoi = function() {
            return this.getDetail().poi
        }
    };
    RongIMClient.LocationMessage.obtain = function(content, latitude, longitude, poi) {
        return new RongIMClient.LocationMessage({
            content: content,
            latitude: latitude,
            longitude: longitude,
            poi: poi,
            extra: ""
        })
    };
    io.util._extends(RongIMClient.LocationMessage, RongIMClient.RongIMMessage);
    RongIMClient.DiscussionNotificationMessage = function(c) {
        RongIMClient.NotificationMessage.call(this, c);
        this.setMessageType(RongIMClient.MessageType.DiscussionNotificationMessage);
        this.setObjectName("RC:DizNtf");
        var isReceived = false;
        this.getExtension = function() {
            return this.getDetail().extension
        };
        this.getOperator = function() {
            return this.getDetail().operator
        };
        this.getType = function() {
            return this.getDetail().type
        };
        this.getAdmins = function () {
            return this.getDetail().admins
        }
        this.isHasReceived = function() {
            return isReceived
        };
        this.setExtension = function(a) {
            this.setContent(a, "extension")
        };
        this.setHasReceived = function(x) {
            isReceived = !!x
        };
        this.setOperator = function(a) {
            this.setContent(a, "operator")
        };
        this.setType = function (a) {
            this.setContent(a, "type")
        };
        this.setAdmins = function (a) {
            this.setContent(a,"admins");
        }
    };
    io.util._extends(RongIMClient.DiscussionNotificationMessage, RongIMClient.NotificationMessage);
    RongIMClient.InformationNotificationMessage = function(c) {
        RongIMClient.NotificationMessage.call(this, c);
        this.setMessageType(RongIMClient.MessageType.InformationNotificationMessage);
        this.setObjectName("RC:InfoNtf")
    };
    RongIMClient.InformationNotificationMessage.obtain = function(content) {
        return new RongIMClient.InformationNotificationMessage({
            content: content,
            extra: ""
        })
    };
    io.util._extends(RongIMClient.InformationNotificationMessage, RongIMClient.NotificationMessage);
    RongIMClient.CommandMessage = function(c) {
        RongIMClient.RongIMMessage.call(this, c);
        this.setMessageType(RongIMClient.MessageType.CommandMessage);
        this.setObjectName("RC:CmdMsg");
        this.setCount(0);
        this.setPersist(0);
        this.getMessageTag = function() {
            return ["NONE"]
        };
        this.getData = function() {
            return this.getDetail().data
        };
        this.setData = function(o) {
            this.setContent(o, "data")
        };
        this.getName = function() {
            return this.getDetail().name
        };
        this.setName = function(o) {
            this.setContent(o, "name")
        }
    };
    RongIMClient.CommandMessage.obtain = function(x, data) {
        return new RongIMClient.CommandMessage({
            name: x,
            data: data,
            extra: ""
        })
    };
    io.util._extends(RongIMClient.CommandMessage, RongIMClient.RongIMMessage);
    RongIMClient.ContactNotificationMessage = function(c) {
        RongIMClient.NotificationMessage.call(this, c);
        this.setMessageType(RongIMClient.MessageType.ContactNotificationMessage);
        this.setObjectName("RC:ContactNtf");
        this.getOperation = function() {
            return this.getDetail().operation
        };
        this.setOperation = function(o) {
            this.setContent(o, "operation")
        };
        this.setMessage = function(m) {
            this.setContent(m, "message")
        };
        this.getMessage = function() {
            return this.getDetail().message
        };
        this.getSourceUserId = function() {
            return this.getDetail().sourceUserId
        };
        this.setSourceUserId = function(m) {
            this.setContent(m, "sourceUserId")
        };
        this.getTargetUserId = function() {
            return this.getDetail().targetUserId
        };
        this.setTargetUserId = function(m) {
            this.setContent(m, "targetUserId")
        }
    };
    RongIMClient.ContactNotificationMessage.obtain = function(operation, sourceUserId, targetUserId, message) {
        return new RongIMClient.ContactNotificationMessage({
            operation: operation,
            sourceUserId: sourceUserId,
            targetUserId: targetUserId,
            message: message,
            extra: ""
        })
    };
    RongIMClient.ContactNotificationMessage.CONTACT_OPERATION_ACCEPT_RESPONSE = "ContactOperationAcceptResponse";
    RongIMClient.ContactNotificationMessage.CONTACT_OPERATION_REJECT_RESPONSE = "ContactOperationRejectResponse";
    RongIMClient.ContactNotificationMessage.CONTACT_OPERATION_REQUEST = "ContactOperationRequest";
    io.util._extends(RongIMClient.ContactNotificationMessage, RongIMClient.NotificationMessage);
    RongIMClient.ProfileNotificationMessage = function(c) {
        RongIMClient.NotificationMessage.call(this, c);
        this.setMessageType(RongIMClient.MessageType.ProfileNotificationMessage);
        this.setObjectName("RC:ProfileNtf");
        this.getOperation = function() {
            return this.getDetail().operation
        };
        this.setOperation = function(o) {
            this.setContent(o, "operation")
        };
        this.getData = function() {
            return this.getDetail().data
        };
        this.setData = function(o) {
            this.setContent(o, "data")
        }
    };
    RongIMClient.ProfileNotificationMessage.obtain = function(operation, data) {
        return new RongIMClient.ProfileNotificationMessage({
            operation: operation,
            data: data,
            extra: ""
        })
    };
    io.util._extends(RongIMClient.ProfileNotificationMessage, RongIMClient.NotificationMessage);
    RongIMClient.CommandNotificationMessage = function(c) {
        RongIMClient.NotificationMessage.call(this, c);
        this.setMessageType(RongIMClient.MessageType.CommandNotificationMessage);
        this.setObjectName("RC:CmdNtf");
        this.getData = function() {
            return this.getDetail().data
        };
        this.setData = function(o) {
            this.setContent(o, "data")
        };
        this.getName = function() {
            return this.getDetail().name
        };
        this.setName = function(o) {
            this.setContent(o, "name")
        }
    };
    RongIMClient.CommandNotificationMessage.obtain = function(x, data) {
        return new RongIMClient.CommandNotificationMessage({
            name: x,
            data: data,
            extra: ""
        })
    };
    io.util._extends(RongIMClient.CommandNotificationMessage, RongIMClient.NotificationMessage);
    RongIMClient.MessageContent = function(f) {
        if (!(f instanceof RongIMClient.RongIMMessage)) {
            throw new Error("wrong parameter")
        }
        this.getMessage = function() {
            return f
        };
        this.encode = function() {
            var c = new Modules.UpStreamMessage();
            c.setSessionId(f.getPersist() | f.getCount());
            c.setClassname(f.getObjectName());
            c.setContent(JSON.stringify(f.getDetail()));
            c.setPushText(f.getPushContent());
            var val = c.toArrayBuffer();
            if (Object.prototype.toString.call(val) == "[object ArrayBuffer]") {
                return [].slice.call(new Int8Array(val))
            }
            return val
        }
    };
    RongIMClient.MessageHandler = function(a) {
        if (typeof a == "function") {
            this.process = a
        } else {
            throw new Error("MessageHandler:arguments type is error")
        }
    };
    RongIMClient.ReceivedStatus = function(d) {
        var a = d || 1;
        this.getFlag = function() {
            return a
        };
        this.isDownload = function() {
            return a == 1
        };
        this.isListened = function() {
            return a == 2
        };
        this.isRead = function() {
            return a == 3
        };
        this.setDownload = function() {
            a = 1
        };
        this.setListened = function() {
            a = 2
        };
        this.setRead = function() {
            a = 3
        }
    };
    RongIMClient.UserInfo = function(h, l, a) {
        var k = h,
            j = l,
            i = a;
        this.getUserName = function() {
            return j
        };
        this.getPortraitUri = function() {
            return i
        };
        this.getUserId = function() {
            return k
        };
        this.setUserName = function(c) {
            j = c
        };
        this.setPortraitUri = function(c) {
            i = c
        };
        this.setUserId = function(c) {
            k = c
        }
    };
    RongIMClient.Conversation = function() {
        var s = this,
            a = (new Date).getTime(),
            D, v, B, w, E, G, t, F, y, C, A, H, x, u = 0,
            por, z = RongIMClient.ConversationNotificationStatus.NOTIFY;
        this.getConversationTitle = function() {
            return G
        };
        this.toJSONString = function() {
            var c = {
                senderUserName: E,
                lastTime: a,
                objectName: D,
                senderUserId: v,
                receivedTime: B,
                conversationTitle: G,
                conversationType: t,
                latestMessageId: C,
                sentTime: H,
                targetId: x,
                notificationStatus: z
            };
            return JSON.stringify(c)
        };
        this.setReceivedStatus = function(c) {
            w = c
        };
        this.getReceivedStatus = function() {
            return w
        };
        this.getConversationType = function() {
            return t
        };
        this.getDraft = function() {
            return F
        };
        this.getLatestMessage = function() {
            return y
        };
        this.getLatestMessageId = function() {
            return C
        };
        this.getNotificationStatus = function() {
            return z
        };
        this.getObjectName = function() {
            return D
        };
        this.getReceivedTime = function() {
            return B
        };
        this.getSenderUserId = function() {
            return v
        };
        this.getSentStatus = function() {
            return A
        };
        this.getSentTime = function() {
            return H
        };
        this.getTargetId = function() {
            return x
        };
        this.getUnreadMessageCount = function() {
            return u
        };
        this.isTop = function() {
            var e = RongIMClient.getInstance().getConversationList();
            return e[0] != undefined && e[0].getTargetId() == this.getTargetId() && e[0].getConversationType() == this.getConversationType()
        };
        this.setConversationTitle = function(c) {
            G = c
        };
        this.getConversationPortrait = function() {
            return por
        };
        this.setConversationPortrait = function(p) {
            por = p
        };
        this.setConversationType = function(c) {
            t = c
        };
        this.setDraft = function(c) {
            F = c
        };
        this.setSenderUserName = function(c) {
            E = c
        };
        this.setLatestMessage = function(c) {
            y = c
        };
        this.setLatestMessageId = function(c) {
            C = c
        };
        this.setNotificationStatus = function(c) {
            z = c instanceof RongIMClient.ConversationNotificationStatus ? c : RongIMClient.ConversationNotificationStatus.setValue(c)
        };
        this.setObjectName = function(c) {
            D = c
        };
        this.setReceivedTime = function(c) {
            a = B = c
        };
        this.setSenderUserId = function(c) {
            v = c
        };
        this.getLatestTime = function() {
            return a
        };
        this.setSentStatus = function(c) {
            return !!(A = c)
        };
        this.setSentTime = function(c) {
            a = H = c
        };
        this.setTargetId = function(c) {
            x = c
        };
        this.setTop = function() {
            if (s.getTargetId() == undefined || this.isTop()) {
                return
            }
            RongIMClient.getInstance().getConversationList().add(this)
        };
        this.setUnreadMessageCount = function(c) {
            u = c
        }
    };
    RongIMClient.Discussion = function(m, l, a, q, p,k) {
        var s = m,
            t = l,
            r = a,
            o = q,
            n = p,
            v = k,
            u = false,
            d = false;
        this.isDisableAddUser = function () {
            return u;
        };
        this.isDisableMsgRead = function () {
            return d;
        };
        this.getCreatorId = function() {
            return r
        };
        this.getId = function() {
            return s
        };
        this.getMemberIdList = function() {
            return n
        };
        this.getName = function() {
            return t
        };
        this.isOpen = function() {
            return o
        };
        this.getIcon = function(){
            return v
        };
        this.setCreatorId = function(c) {
            r = c
        };
        this.setId = function(c) {
            s = c
        };
        this.setMemberIdList = function(c) {
            n = c
        };
        this.setName = function(c) {
            t = c
        };
        this.setOpen = function(c) {
            o = !!c
        };
        this.setIcon = function(c){
            v = c
        };
        this.setDisableAddUser = function (c) {
            u = !!c;
        };
        this.setDisableMsgRead = function (c) {
            d = !!c;
        };
    };
    RongIMClient.Group = function(j, l, a) {
        var h = j,
            k = l,
            i = a;
        this.getId = function() {
            return h
        };
        this.getName = function() {
            return k
        };
        this.getPortraitUri = function() {
            return i
        };
        this.setId = function(c) {
            h = c
        };
        this.setName = function(c) {
            k = c
        };
        this.setPortraitUri = function(c) {
            i = c
        }
    };
    var _enum = {
        MessageTag: {
            ISPERSISTED: "ISPERSISTED",
            ISCOUNTED: "ISCOUNTED",
            NONE: "NONE",
            ISDISPLAYED: "ISDISPLAYED"
        },
        ConversationNotificationStatus: ["DO_NOT_DISTURB", "NOTIFY"],
        ConversationType: ["CHATROOM", "CUSTOMER_SERVICE", "DISCUSSION", "GROUP", "PRIVATE", "SYSTEM"],
        SentStatus: ["DESTROYED", "FAILED", "READ", "RECEIVED", "SENDING", "SENT"],
        DiscussionInviteStatus: ["CLOSED", "OPENED"],
        MediaType: ["AUDIO", "FILE", "IMAGE", "VIDEO"],
        MessageDirection: ["RECEIVE", "SEND"],
        MessageType: ["DiscussionNotificationMessage", "TextMessage", "ImageMessage", "VoiceMessage", "RichContentMessage", "HandshakeMessage", "UnknownMessage", "SuspendMessage", "LocationMessage", "InformationNotificationMessage", "ContactNotificationMessage", "ProfileNotificationMessage", "CommandNotificationMessage", "CommandMessage", "TypingStatusMessage", "ReadReceiptMessage"],
        SendErrorStatus: {
            REJECTED_BY_BLACKLIST: 405,
            NOT_IN_DISCUSSION: 21406,
            NOT_IN_GROUP: 22406,
            NOT_IN_CHATROOM: 23406
        },
        BlacklistStatus: ["EXIT_BLACK_LIST", "NOT_EXIT_BLACK_LIST"],
        ConnectionStatus: ["CONNECTED", "CONNECTING", "RECONNECT", "OTHER_DEVICE_LOGIN", "CLOSURE", "UNKNOWN_ERROR", "LOGOUT", "BLOCK"]
    };
    io.util.each(_enum, function(_name, option) {
        var val = {};
        if (io.util.isArray(option)) {
            io.util.forEach(option, function(x, i) {
                val[x] = i
            })
        } else {
            val = option
        }
        RongIMClient[_name] = RongIMEnum(val)
    });
    RongIMClient.ConnectErrorStatus = ConnectionState;
    RongIMClient.callback = function(d, a) {
        this.onError = a;
        this.onSuccess = d
    };
    RongIMClient.callback.ErrorCode = RongIMEnum({
        TIMEOUT: -1,
        UNKNOWN_ERROR: -2
    });


    if ("function" === typeof require && "object" === typeof module && module && module.id && "object" === typeof exports && exports) {
        module.exports = RongIMClient
    } else {
        if ("function" === typeof define && define.amd) {
            define("RongIMClient", [], function() {
                return RongIMClient
            });
            define(function() {
                return RongIMClient
            })
        } else {
            global.RongIMClient = RongIMClient
        }
    }



    /**
     * 定义Strophe的封装工具
     */
    (function(w){
        // 存放消息id和callback
        var MsgCbMap = {};

        // 收到的message消息队列，容量100，过滤防止重复。
        var ReceivedQueue = [];

        // 存放connect和reconnect的回调
        var ConCbMap = {};

        WeaverBridge = function(domain, severip, serverport, resource){
            var self = this;

            // linkType浏览器支持的链接方式，0：websocket，1：httpbind
            var linkType = ("WebSocket" in global && "ArrayBuffer" in global && !global.WEB_XHR_POLLING) ? 0 : 1;
            var serverIp = severip + ':' + serverport;
            var idWss  = serverport=='7070'?'ws':'wss';
            var protocol = linkType == 0 ? idWss : 'http-bind';
            var boshService = linkType == 0 ? idWss+'://' + serverIp + '/ws/' : 'http://' + serverIp + '/http-bind/';

            this.socket = null;  // 链接对象
            this.connected = false;  //是否已连接（状态）
            this.serverIp = serverIp;
            this.boshService = boshService;  //建立链接server地址
            this.protocol = protocol;  //建立连接的类型
            this.domain = domain;
            this.resource = resource;
            this.currentUser = '';
            this.udid = '';
            this.from = '';
            this.pingTime = 1;//缓存时间
            this.onConnectionStatusListener = null;  //链接状态变化监听
            this.onReceiveMessageListener = null;  //接收消息监听

            /**
             * 设置连接状态变化监听
             * @param c
             */
            this.setOnConnectionStatusListener = function(c){
                self.onConnectionStatusListener = c;
            };
            /**
             * 设置接收消息监听
             * @param r
             */
            this.setOnReceiveMessageListener = function(r) {
                self.onReceiveMessageListener = r;
            };

            //xmpp消息中UDID必须使用小写！！！
            this.getXMPPUserIMId = function(_oaId){
                try{
                    var sufs = '|' + self.udid.toLowerCase();
                    var index = _oaId.toLowerCase().indexOf(sufs);
                    if (index == -1) {
                        return _oaId + sufs;
                    }else{
                        return _oaId.substring(0, index) + sufs;
                    }
                }catch(e){}
            };
            
            //xmpp消息中UDID必须使用小写！！！
            this.getUserIMId = function(_oaId){
                try{
                    var sufs = '|' + self.udid;
                    var index = _oaId.indexOf(sufs);
                    if (index == -1) {
                        return _oaId + sufs;
                    }else{
                        return userId.substring(0, index + sufs.length);
                    }
                }catch(e){}
            };

            // 融云及XMPP，页面级udid是大小写混杂
            this.getRealUserId = function(imUserId){
                if (imUserId) {
                    try{
                        var index = imUserId.indexOf('|');
                        if (index > 0) {
                            return imUserId.substring(0, index);
                        }
                    }catch(e){}
                }
                return imUserId;
            };
            
            /**
             * 链接服务器
             * @param _id  oa用户id
             * @param _udid  udid
             * @param _p  密码
             * @param _listeners  监听器
             * @param _callback  回调
             */
            this.connect = function(_id, _udid, _p, _connectionListener, _callback){
                self.currentUser = _id;
                self.udid = _udid;
                self.from = self.getXMPPUserIMId(self.currentUser) + '@' + self.domain + '/' + self.resource;

                var conCallback = new ConCallback(_callback);
                ConCbMap[conCallback.id] = conCallback;

                var stropheObj = self.socket = new Strophe.Connection(self.boshService, {protocol: self.protocol});
                stropheObj.rawInput = function(data){
                    //writeLog('RECV: ' + data);
                };
                stropheObj.rawOutput = function(data){
                    //writeLog('SENT: ' + data);
                };

                stropheObj.xmlOutput = function (data) {
                    writeLog('xmlOutput: ');
                    writeLog(data)
                };

                stropheObj.xmlInput = function (data) {
                    writeLog('xmlInput: ');
                    writeLog(data)
                };
                
                
                stropheObj.connect(self.getXMPPUserIMId(_id) + '@' + self.serverIp + '/' + self.resource, _p, onConnectionStatusChanged, 60, 1, self.resource, self.getXMPPUserIMId(_id));

                // 链接状态变动
                function onConnectionStatusChanged(status) {
                    /*
                    switch (status) {
                        case Strophe.Status.ERROR :
                            writeLog('onConnectionStatusChanged.  服务端有错误');
                            break;
                        case Strophe.Status.CONNECTING :
                            writeLog('onConnectionStatusChanged.  正在建立连接');
                            break;
                        case Strophe.Status.CONNFAIL :
                            writeLog('The connection attempt failed.');
                            break;
                        case Strophe.Status.AUTHENTICATING :
                            writeLog('The connection is authenticating.');
                            break;
                        case Strophe.Status.AUTHFAIL :
                            writeLog('onConnectionStatusChanged.  验证尝试失败');
                            break;
                        case Strophe.Status.CONNECTED :
                            writeLog('onConnectionStatusChanged.  建立链接成功');
                            break;
                        case Strophe.Status.DISCONNECTED :
                            writeLog('TonConnectionStatusChanged.  链接已断开');
                            break;
                        case Strophe.Status.DISCONNECTING :
                            writeLog('onConnectionStatusChanged.  正在断开连接');
                            break;
                        case Strophe.Status.ATTACHED :
                            writeLog('The connection has been attached.');
                            break;
                    }
                    */
                    
                    // 触发用户定义状态监听
                    self.onConnectionStatusListener.onChanged(status);

                    self.connected = status == Strophe.Status.CONNECTED;
                    if(status == Strophe.Status.CONNECTED) {  // 链接成功
                        afterConnected();  //链接成功后注册事件

                        // 触发页面链接成功事件
                        _connectionListener.onSuccess(_id);
                        conCallback && conCallback.onSuccess && conCallback.onSuccess();
                    }
                    if(status == Strophe.Status.AUTHFAIL || 
                    	status == Strophe.Status.DISCONNECTED || 
                    	status == Strophe.Status.CONNFAIL ||
                    	status == Strophe.Status.CONNTIMEOUT) {  // 4:验证失败|6:断开连接|2:连接失败|10:连接超时
                        _connectionListener.onError(status);
                        conCallback && conCallback.onError && conCallback.onError();
                    }
                }

                // 链接成功后处理
                function afterConnected() {
                    if(self.connected) {
                        self.sendPresenceMessage(self.from, 1);  // 发送出席消息
                        stropheObj.addHandler(wapperMessage, null, 'message', null, null, null);
                        //初次登陆设置Presence消息监听
                        stropheObj.addHandler(handlePresenceMessage, null, 'presence', null, null, null,null);
                    }
                     //专门用来处理presence消息
                     function handlePresenceMessage(data) {
                        var from = data.getAttribute('from');
                        var to = data.getAttribute('to');
                        var StatusElems = data.getElementsByTagName('status');
                        var status = StatusElems[0].hasOwnProperty('innerHTML') ? StatusElems[0].innerHTML : StatusElems[0].textContent;
                        if(from==to){
                            return true;
                        }else{
                            self.onReceiveMessageListener.OnLineStatuHandler(status,getRealUserId(from));
                        }
                        //递归调用添加监听,不需要递归，但是每次都得返回true
                        //stropheObj.addHandler(handlePresenceMessage, null, 'presence', null, null, null,null);
                        return true;
                    };
                    
                    // 获取数据
                    function wapperMessage (data) {
                        //writeLog('接收到的数据------------开始');
                        //writeLog(data);
                        //writeLog('接收到的数据------------结束');

                        var id = data.getAttribute('id');
                        var type = data.getAttribute('type');
                        var from = data.getAttribute('from');
                        var to = data.getAttribute('to');
                        var bodyElems = data.getElementsByTagName('body');
						var timeElems = data.getElementsByTagName('time');
                        // 处理chat消息, normal：离线补偿
                        if (bodyElems.length > 0 && (type == "chat" || type == "normal")) {
							// 收到消息立马发送反馈回执                            
							try{
								var backMsg = getHeadlineMessage(data);
								if(backMsg) {
									self._execSend(backMsg);
								}
							}catch(e){
                                    console.error(e);
                                }                           
                            if(!isDuplicateMessage(id)) {  //重复消息不处理
                                var body = bodyElems[0].hasOwnProperty('innerHTML') ? bodyElems[0].innerHTML : bodyElems[0].textContent;
                                try {
                                    var delayTime = null;
                                    var delayElems = data.getElementsByTagName('delay');
                                    if(delayElems.length > 0){
                                        var stamp = delayElems[0].getAttribute('stamp');
                                        delayTime = (new Date(stamp)).getTime(); //得到毫秒数
                                    }
                                    var msgBody = JSON.parse(body);
                                    var message = new WeaverIMMessage(from, to, msgBody, delayTime, self.udid);
                                    
                                    if(type == "normal") {
                                        // message.setHasReceivedByOtherClient(true);
                                    } 
                                    // 返回消息给页面
                                    self.onReceiveMessageListener.onReceived(message);
									
                                } catch(e){
                                    console.error(e);
                                }
                            }
                        }
                        //处理消息回执
                        else if(type == "headline") {
                            var temp = MsgCbMap[id];
                            if(timeElems.length > 0){
                            	var ts = timeElems[0].textContent;
                            	d = new Date(ts);
    							ts = d.getTime();
                            }
                            if (temp) {
                                temp.onSuccess(ts);
                            }
                        }
                        // 错误
                        else if(type == 'error') {
                            var temp = MsgCbMap[id];
                            if (temp) {
                                temp.onError();
                            }
                        }
                        // we must return true to keep the handler alive.returning false would remove it after it finishes.
                        return true;
                    }
                }

                /**
                 * 根据id判断消息是否收到过
                 * @param msgId
                 * @returns {boolean}
                 */
                function isDuplicateMessage(msgId) {
                    if(ReceivedQueue.length == 0) {
                        ReceivedQueue.unshift(msgId);
                        return false;
                    } else if(indexOfArr(ReceivedQueue, msgId) >= 0) {
                        return true;
                    } else {
                        if(ReceivedQueue.length == 100) {  // 最大100的值
                            ReceivedQueue.pop();
                        }
                        ReceivedQueue.unshift(msgId);
                        return false;
                    }

                    // 判断item是否存在数组arr中
                    function indexOfArr(arr, item) {
                        var index = -1;
                        for(var i = 0; i < arr.length; i++) {
                            if(arr[i] == item) {
                                index = i;
                                break;
                            }
                        }
                        return index;
                    }
                }
            };

            // 发送消息
            this.sendMessage = function(_con, _toId, _msgObj, _callback){
                var pckMsg = packMessage(_con, _toId, _msgObj);
                if(pckMsg.dataTree) {
                    self._execSend(pckMsg.dataTree);

                    //writeLog('发送的数据------------开始');
                    //writeLog(pckMsg.dataTree);
                    //writeLog('发送的数据------------结束');

                    if(_callback && typeof _callback === 'object') {
                    	//console.log(pckMsg);
                        MsgCbMap[pckMsg.msgId] = new OpMsgCallback(pckMsg.msgId, _callback);
                    }
                }
            };
            

            // 发送出席消息
            this.sendPresenceMessage = function(_from, _priority){
                var data = $pres({id:getUUID() ,from:_from}).c('priority', _priority).tree();
                self._execSend(data);
            };
            
            // 发送状态申请消息
            this.sendStatusMessage = function(data){
                self._execSend(data);
            };
            
            // 断开连接
            this.disconnect = function(){
                self.socket.disconnect();
            };

            // 群组相关工具
            this.groupUtils = {
                //获取讨论组配置
                getServerConfig :function(callback){
                    var queryJson={};
                    var iqMsg = packIQMessage(OpXmlnsNameSpace.SERVERFUN,GroupEmun.GroupIQType.GET,queryJson);
                    self._exeSendIQ(iqMsg.dataTree,handlerServerConfig,callback.onError,1000*20);
                    // 处理获取的配置信息
                    function handlerServerConfig(data){
                        var queryElems =data.getElementsByTagName('query');
                        try {
                            var innerHTML = queryElems[0].hasOwnProperty('innerHTML') ? queryElems[0].innerHTML : queryElems[0].textContent;
                            var config = JSON.parse(innerHTML);
                            // 执行成功回调
                            callback.onSuccess(config);
                        } catch(e) {
                            callback.onError('信息内容错误:' + e);
                            return;
                        }
                    }
                },
                // 获取讨论组信息
                getDiscussion : function(discussionId, callback){
                    var queryJson = {
                        groupId : discussionId
                    };
                    var iqMsg = packIQMessage(OpXmlnsNameSpace.GROUP, GroupEmun.GroupIQType.GET, queryJson);
                    self._exeSendIQ(iqMsg.dataTree, wapperGetDiscussion, callback.onError, 1000 * 20);

                    // 组装 RongIMClient.Discussion 消息并返回给onSuccess回调
                    function wapperGetDiscussion(data) {
                        var queryElems = data.getElementsByTagName('query');
                        if(queryElems.length == 0) {
                            callback.onError('返回消息体信息错误');
                            return;
                        }
                        try {
                            var innerHTML = queryElems[0].hasOwnProperty('innerHTML') ? queryElems[0].innerHTML : queryElems[0].textContent;
                            var groupInfos = JSON.parse(innerHTML);

                            var disInfo = new RongIMClient.Discussion();
                            disInfo.setCreatorId(groupInfos.admins[0]);
                            disInfo.setId(groupInfos.groupId);
                            disInfo.setMemberIdList(groupInfos.members);
                            disInfo.setName(groupInfos.groupName);
                            disInfo.setOpen(RongIMClient.DiscussionInviteStatus.setValue(1));
                            disInfo.setIcon(groupInfos.groupIconUrl);
                            disInfo.setDisableAddUser(groupInfos.isDisableAddUser);
                            disInfo.setDisableMsgRead(groupInfos.isDisableMsgRead);
                        } catch(e) {
                            callback.onError('设置群组信息内容错误:' + e);
                            return;
                        }

                        // 执行成功回调
                        callback.onSuccess(disInfo);
                    }
                },

                // 主动退出群组
                quitDiscussion : function(discussionId, callback){
                    var queryJson = {
                        method : 'exitGroup',
                        groupId : discussionId
                    };
                    var iqMsg = packIQMessage(OpXmlnsNameSpace.GROUP, GroupEmun.GroupIQType.SET, queryJson);
                    self._exeSendIQ(iqMsg.dataTree, callback.onSuccess, callback.onError, 1000 * 20);
                },

                // 添加成员到群
                addMemberToDiscussion : function (discussionId, members, callback){
                    var queryJson = {
                        method : 'addGroupUsers',
                        groupId : discussionId,
                        members : members
                    };
                    var iqMsg = packIQMessage(OpXmlnsNameSpace.GROUP, GroupEmun.GroupIQType.SET, queryJson);
                    self._exeSendIQ(iqMsg.dataTree, callback.onSuccess, callback.onError, 1000 * 20);
                },

                // 异步删除群成员
                removeMemberFromDiscussion : function(discussionId, members, callback){
                    var queryJson = {
                        method : 'deleteGroupUsers',
                        groupId : discussionId,
                        members : [members]
                    };
                    var iqMsg = packIQMessage(OpXmlnsNameSpace.GROUP, GroupEmun.GroupIQType.SET, queryJson);
                    self._exeSendIQ(iqMsg.dataTree, getRemovedMemberIdList, callback.onError, 1000 * 20);
                    
                    // 组装 removeMemberFromDiscussion 并把移除人员列表返回给onSuccess回调
                    function getRemovedMemberIdList(data) {
                        var queryElems = data.getElementsByTagName('query');
                        if(queryElems.length == 0) {
                            callback.onError('返回消息体信息错误');
                            return;
                        }
                        try {
                            var innerHTML = queryElems[0].hasOwnProperty('innerHTML') ? queryElems[0].innerHTML : queryElems[0].textContent;
                            var groupInfos = JSON.parse(innerHTML.toLowerCase());
							var memberIdList = groupInfos.members; 
                            
                        } catch(e) {
                            callback.onError('设置群组信息内容错误:' + e);
                            return;
                        }

                        // 执行成功回调
                        callback.onSuccess(memberIdList);
                    }
                },

                //设置群名称
                setDiscussionName : function(discussionId, discussTitle, callback){
                    var queryJson = {
                        method : 'changeGroupName',
                        groupId : discussionId,
                        groupName : discussTitle
                    };
                    var iqMsg = packIQMessage(OpXmlnsNameSpace.GROUP, GroupEmun.GroupIQType.SET, queryJson);
                    self._exeSendIQ(iqMsg.dataTree, callback.onSuccess, callback.onError, 1000 * 20);
                },
                //设置群头像
                setDiscussionIcon:function(discussionId,discussionIcon,callback){
                    var queryJson = {
                        method : 'setGroupIcon',
                        groupId : discussionId,
                        groupIconUrl : discussionIcon
                    };
                    var iqMsg = packIQMessage(OpXmlnsNameSpace.GROUP, GroupEmun.GroupIQType.SET, queryJson);
                    self._exeSendIQ(iqMsg.dataTree,setDiscussionIcoReuslt, callback.onError, 1000 * 20);
                     function  setDiscussionIcoReuslt(data) {
                        var queryElems = data.getElementsByTagName('query');
                        if(queryElems.length == 0) {
                            callback.onError('返回消息体信息错误');
                            return;
                        }
                        var innerHTML = queryElems[0].hasOwnProperty('innerHTML') ? queryElems[0].innerHTML : queryElems[0].textContent;
                        var groupInfos = JSON.parse(innerHTML);
                        var discussionId  = groupInfos.groupId;
                        if(discussionId) {
                            callback.onSuccess(discussionId);
                        } else {
                            callback.onError('返回异常，groupid为空');
                        }
                    }
                },
                // 创建群组
                createDiscussion : function(name, userIdList, callback){
                    var queryJson = {
                        method : 'createGroup',
                        groupName : name,
                        members : userIdList
                    };
                    var iqMsg = packIQMessage(OpXmlnsNameSpace.GROUP, GroupEmun.GroupIQType.SET, queryJson);
                    self._exeSendIQ(iqMsg.dataTree, createDisReuslt, callback.onError, 1000 * 20);

                    function createDisReuslt(data) {
                        var queryElems = data.getElementsByTagName('query');
                        if(queryElems.length == 0) {
                            callback.onError('返回消息体信息错误');
                            return;
                        }
                        var innerHTML = queryElems[0].hasOwnProperty('innerHTML') ? queryElems[0].innerHTML : queryElems[0].textContent;
                        var groupInfos = JSON.parse(innerHTML);
                        var discussionId  = groupInfos.groupId;
                        if(discussionId) {
                            callback.onSuccess(discussionId);
                        } else {
                            callback.onError('返回异常，groupid为空');
                        }
                    }
                },
                //转让群组
                setDiscussionAdmin : function(discussionId, adminId, callback){
                    var queryJson = {
                        method : 'changeGroupAdmin',
                        groupId : discussionId,
                        admins : adminId
                    };
                    var iqMsg = packIQMessage(OpXmlnsNameSpace.GROUP, GroupEmun.GroupIQType.SET, queryJson);
                    self._exeSendIQ(iqMsg.dataTree, wapperGetDiscussion, callback.onError, 1000 * 20);
                     // 组装 RongIMClient.Discussion 消息并返回给onSuccess回调
                    function wapperGetDiscussion(data) {
                        var queryElems = data.getElementsByTagName('query');
                        if(queryElems.length == 0) {
                            callback.onError('返回消息体信息错误');
                            return;
                        }
                        try {
                            var innerHTML = queryElems[0].hasOwnProperty('innerHTML') ? queryElems[0].innerHTML : queryElems[0].textContent;
                            var groupInfos = JSON.parse(innerHTML);

                            var disInfo = new RongIMClient.Discussion();
                            disInfo.setCreatorId(groupInfos.admins[0]);
                            disInfo.setId(groupInfos.groupId);
                            disInfo.setMemberIdList(groupInfos.members);
                            disInfo.setName(groupInfos.groupName);
                            disInfo.setOpen(RongIMClient.DiscussionInviteStatus.setValue(1));
                            disInfo.setIcon(groupInfos.groupIconUrl);
                            disInfo.setDisableAddUser(groupInfos.isDisableAddUser);
                            disInfo.setDisableMsgRead(groupInfos.isDisableMsgRead);
                        } catch(e) {
                            callback.onError('设置群组信息内容错误:' + e);
                            return;
                        }

                        // 执行成功回调
                        callback.onSuccess(disInfo);
                    }
                }                
            };

            // 获得历史消息
            this.getHistoryMessage = function(targetType, fromUserId, targetId, lastTime, pageSize, callback){
                var queryJson = {
                    targetType : targetType,
                    fromUserId : fromUserId,
                    targetId : targetId,
                    lastTime : lastTime,
                    pageSize : pageSize
                };
                var iqMsg = packIQMessage(OpXmlnsNameSpace.HISTORY, GroupEmun.GroupIQType.GET, queryJson);
                self._exeSendIQ(iqMsg.dataTree, wapperGetHistory, callback.onError, 1000 *20);

                function wapperGetHistory(data) {
                    var queryElems = data.getElementsByTagName('query');
                    if(queryElems.length == 0) {
                        callback.onError('返回消息体信息错误');
                        return;
                    }
                    var innerHTML = queryElems[0].hasOwnProperty('innerHTML') ? queryElems[0].innerHTML : queryElems[0].textContent;
                    var histroyInfos = JSON.parse(innerHTML);
                    var syncTime  = histroyInfos.lastTime;
                    var historyList = histroyInfos.history;

                    var result = {
                        syncTime : syncTime,
                        hasMsg : historyList.length > 0,
                        list : []
                    };
                    for(var i = 0; i < historyList.length; i++) {
                        var oneMsg = historyList[i];
                        var from,to;
                        if(targetType == 0||targetType == 8) {
                            from  = self.getUserIMId(oneMsg.fromUserId) + '@' + self.domain;
                            to = self.getUserIMId(oneMsg.targetId) + '@' + self.domain;
                        } else if(targetType == 1) {
                            if(oneMsg.fromUserId == fromUserId) {
                                from = self.getUserIMId(oneMsg.fromUserId) + '@' + self.domain;
                                to = oneMsg.targetId + '@group.' + self.domain;
                            } else {
                                from = self.getUserIMId(oneMsg.fromUserId) + '@group.' + self.domain + '/' + oneMsg.targetId;
                                to = self.getUserIMId(oneMsg.fromUserId) + '@' + self.domain;
                            }
                        }
                        var msgBody = JSON.parse(oneMsg.opBody);
                        msgBody.sendTime = oneMsg.sendTime;
                        var message = new WeaverIMMessage(from, to, msgBody,msgBody.sendTime, self.udid);
                        result.list.push(message)
                    }
                    callback.onSuccess(result);
                }
            };
            //在线状态设置
            this.onlineStatusUtils = {
                getUserOnlineStatus :function(members,callback){
                    var queryJson = members;
                    var iqMsg = packIQMessage(OpXmlnsNameSpace.STATUS, GroupEmun.GroupIQType.GET, queryJson);
                    self._exeSendIQ(iqMsg.dataTree,wapperUserOnlineStatus,callback.onError,1000 * 20);
                    function wapperUserOnlineStatus(data) {
                        try{
                            var queryElems = data.getElementsByTagName('query');
                            if(queryElems.length == 0) {
                                callback.onError('返回消息体信息错误');
                                return;
                            }
                            if(queryElems==undefined){
                                callback.onError('服务器暂时不接受请求');
                                return;
                            }
                        }catch(err){
                            return;
                        }
                        var innerHTML = queryElems[0].hasOwnProperty('innerHTML') ? queryElems[0].innerHTML : queryElems[0].textContent; 
                        callback.onSuccess(innerHTML);
                    }
                },
                setUserOnlineStatus :function(status,callback){
                    var iqMsg = packStatusMessage(status,self.from);
                    if(self.connected) {
                        //这边只需要发送Presence消息，不需要监听
                        self.sendStatusMessage(iqMsg.dataTree);
                        //发送完就执行回调 
                        callback.onSuccess();
                    }else{
                        callback.onError();
                    }
                }
             };


            // 执行发送 send 方法
            this._execSend = function(data) {
                if(self.connected && data) {
                    self.socket.send(data);
                }
            };

            // 执行发送 sendIQ 方法
            this._exeSendIQ = function(elem, callback, errback, timeout){
                if(self.connected) {
                    self.socket.sendIQ(elem, callback, errback, timeout);
                }
            };
            // 发送ping
            this._sendPing= function(elem, callback, errback, timeout){
                 self.socket.sendIQ(elem, callback, errback, timeout);
            };
            // 组装要发送的消息
            function packMessage(_con, _toId, _msgObj) {
                var msgId = getUUID();
                var msg;
                var data = null;
                try {
                    var opt = {
                        id : msgId,
                        to : null,
                        from : null,
                        type : 'chat'
                    };
                    // 单聊
                    if(_con == RongIMClient.ConversationType.PRIVATE.value) {
                        opt.from = self.getXMPPUserIMId(self.currentUser) + '@' + self.domain + '/' + self.resource;
                        opt.to = self.getXMPPUserIMId(_toId) + '@' + self.domain;
                    }
                    // 群聊
                    else {
                        opt.from =  self.getXMPPUserIMId(self.currentUser) + '@' + self.domain + '/' + self.resource;
                        opt.to = _toId + '@group.' + self.domain + '/' + self.resource;
                    }
                    msg = $msg(opt);
                    msg.c("body", null, JSON.stringify(_msgObj));
                    msg.c('thread', null, getUUID());
                    msg.c('x', {xmlns : 'jabber:x:event'}).c('offline').up().c('composing');
                    data = msg.tree();
                } catch(e) {
                    writeLog('组装发送消息异常 method:packMessage  error:' + e)
                }
                return {msgId : msgId, dataTree : data};
            }
            
            //封装status消息
            function packStatusMessage(status,from) {
                var msgId = getUUID();
                var data = null;
                try {
                    var opt = {
                        id : msgId,
                        from : from
                    };
                    var iqMsg = $pres(opt);
                    if(status=='online'){
                        iqMsg.c('priority',1);
                    }else{
                        iqMsg.c('status',status).up().c('priority',1);
                    }
                    data = iqMsg.tree();
                } catch(e) {
                    writeLog('组装IQ消息异常 method:packStatusMessage  error:' + e)
                }
                return { msgId : msgId, dataTree : data };
            }

            // 群组消息常量
            var GroupEmun = {
                GroupIQType : {
                    'GET' : 'get',  //获取信息
                    'SET' : 'set'  //设置信息
                },
                GroupOpType : {
                    'JOIN' : 1,  //加入
                    'EXIT' : 2,  //主动退出
                    'RENAME' : 3,  //变更群名称
                    'EXCLUD' : 4  //被管理员踢出
                }
            };
            // IQ消息域
            var OpXmlnsNameSpace = {
                "GROUP" : 'http://weaver.com.cn/group',  //群组
                "HISTORY" : 'http://weaver.com.cn/history',  //历史消息
                "SERVERFUN" :'http://weaver.com.cn/serverFun',//获取群配置
                "STATUS" :'http://weaver.com.cn/status'  //在线状态
            };

            // 获得IQ消息体和msgid
            function packIQMessage(xmlns, type, queryJson) {
                var msgId = getUUID();
                var data = null;
                try {
                    var opt = {
                        id : msgId,
                        type : type,
                        xmlns : xmlns
                    };
                    var iqMsg = $iq(opt);
                    iqMsg.c('query', null, JSON.stringify(queryJson));
                    data = iqMsg.tree();
                } catch(e) {
                    writeLog('组装IQ消息异常 method:packIQMessage  error:' + e)
                }
                return { msgId : msgId, dataTree : data };
            }

            // 组装回执消息
            function getHeadlineMessage(data) {
                var id = data.getAttribute('id');
                var oldFrom = data.getAttribute('from');
                var oldTo = data.getAttribute('to');
                var toArr = oldFrom.split('@');
                var newTo = toArr[0] + '@confirm.' + self.domain;
                //var bodyElems = data.getElementsByTagName('body');

                var msg = $msg({
                    id : id,
                    to: newTo,
                    from: oldTo,
                    type: 'headline'
                });
                // msg.c("body", null, bodyElems.length > 0 ? bodyElems[0].innerHTML : '');
                return msg.tree();
            }

            // 处理发送消息的回调
            function OpMsgCallback(msgId, callback){
                var self = this;
                var timeout = 1000 * 8;
                this.msgId = msgId;
                this.timehandle = setTimeout(function(){
                    self.onError('timeout');
                }, timeout);
                this.onSuccess = function(ts){
                    try {
                        self.clearTimeout();
                        callback.onSuccess({timestamp : ts?ts : new Date().getTime()});
                        writeLog('发送成功回调');
                    } catch(e) {
                        writeLog('执行发送成功回调错误！！' + e);
                    }
                };
                this.onError = function(err){
                    try {
                        self.clearTimeout();
                        callback.onError(err);
                        writeLog('发送失败回调：' + err);
                    } catch(e) {
                        writeLog('执行发送失败回调错误！！' + e);
                    }
                };
                this.clearTimeout = function(){
                    if(self.timehandle) {
                        clearTimeout(self.timehandle);
                        self.timehandle = null;
                        delete MsgCbMap[self.msgId];
                    }
                };
                return this;
            }

            /**
             * connect和reconnect回调对象
             * @param _callback
             * @returns {conCallback}
             */
            function ConCallback(_callback) {
                var self = this;
                var timeout = 1000 * 20;
                var hasCallback = _callback && typeof _callback == 'object' && _callback.onSuccess && _callback.onError;
                var timoutHandle = setTimeout(function(){
                    clearTimeout(timoutHandle);
                    timoutHandle = null;
                    if(hasCallback) {
                        _callback.onError();
                    }
                }, timeout);
                this.id = getUUID();
                this.onSuccess = function(){
                    if(hasCallback) {
                        clearTimeout(timoutHandle);
                        timoutHandle = null;
                        setTimeout(function(){
                            _callback.onSuccess();
                        });
                        delete ConCallback[self.id];
                    }
                };
                this.onError = function(){
                    if(hasCallback) {
                        clearTimeout(timoutHandle);
                        timoutHandle = null;
                        _callback.onError();
                        delete ConCallback[self.id];
                    }
                };
                return this;
            }

            // html特殊字符处理工具
            var HtmlUtil = {
                htmlEncodeByRegExp:function (str){
                    var s = "";
                    if(str.length == 0) return "";
                    s = str.replace(/&/g,"&amp;");
                    s = s.replace(/</g,"&lt;");
                    s = s.replace(/>/g,"&gt;");
                    s = s.replace(/ /g,"&nbsp;");
                    s = s.replace(/\'/g,"&#39;");
                    s = s.replace(/\"/g,"&quot;");
                    return s;
                },
                /*4.用正则表达式实现html解码*/
                htmlDecodeByRegExp:function (str){
                    var s = "";
                    if(str.length == 0) return "";
                    s = str.replace(/&amp;/g,"&");
                    /*
                    s = s.replace(/&lt;/g,"<");
                    s = s.replace(/&gt;/g,">");
                    s = s.replace(/&nbsp;/g," ");
                    s = s.replace(/&#39;/g,"\'");
                    s = s.replace(/&quot;/g,"\"");
                    */
                    return s;
                }
            };

            // 基础数据转换
            function buildUpBaseObj(obj) {
                var opt = {
                    messageId : '',
                    senderUserId : '',
                    targetId : '',
                    content : '',
                    extra : '',
                    msgType : null,
                    objectName : null,
                    sendTime : null,
                    detail : null,
                    conversationType : 4,
                    hasReceivedByOtherClient : false
                };
                for(var key in opt) {
                    opt[key] = obj[key];
                }
                return opt;
            }

            // 泛微自定义数据类型及解析类型
            var weaverMsgTypeMapping = {
                'FW:SyncMsg' : 'TextMessage',  //同步消息
                'FW:CustomMsg' : 'TextMessage',  //抖动等用到
                'FW:CountMsg' : 'TextMessage',  //count消息(已读状态)
                'FW:SysMsg' : 'TextMessage',  //系统消息（推送提醒）
                'FW:attachmentMsg' : 'TextMessage',  //附件
                'FW:CustomShareMsg' : 'TextMessage',  //分享
                'FW:PersonCardMsg' : 'TextMessage',  //名片
                'FW:richTextMsg' : 'TextMessage',  //图文
                'FW:SyncQuitGroup' : 'TextMessage',  //删除本地讨论组
                'RC:PublicNoticeMsg' : 'TextMessage',  //群公告
                'FW:ClearUnreadCount' : 'TextMessage',  //端已读状态消息
				'FW:InfoNtf':'TextMessage', //自定义通知类消息，(取消网盘分享消息)
				'FW:InfoNtf:cancelShare:RC:TxtMsg':'TextMessage', //取消分享后的消息类型
				'FW:CloseMsg' : 'TextMessage', //手机发消息退出pc端
                'FW:CustomShareMsgVote' : 'TextMessage',//投票消息
                'RC:InfoNtfVote' : 'TextMessage' //投票相关通知消息
            };
            
            // 非通讯层UDID还是保持原样，非全小写形式！！
            function wapperUserId(userid, udid){
                var index = userid.lastIndexOf('|');
                if(userid.indexOf('|ding') != -1){
                	return userid;
                }
                if(userid.indexOf('|sysnotice') != -1){
                	return userid;
                } 
                if(userid.indexOf("|wf|") != -1||
				    userid.indexOf("|mails") != -1||
				    userid.indexOf("|schedus") != -1||
				    userid.indexOf("|meetting") != -1||
				    userid.indexOf("|doc") != -1||
				    userid.indexOf("|notice") != -1){
					return userid;
	        	}               
                if(index != -1) {
                    return userid.substring(0, index) + '|' + udid;
                } else {
                    return userid
                }
            }

            // 转换json为融云消息对象
            var WeaverIMMessage = function(from, to, msgBody, delay, udid){
                var message = null;
                var msgObj = msgBody;
                var objectName = msgObj.objectName;
				var extra = msgObj.extra;
                
                // 获取body中json的需要内容
                var entity = {};
                var senderId, targetId, conversationType;
                
                var privateSyncFlag = '@confirm.' + self.domain;  // 同步消息标志
                var groupSyncFlag = '@confirm.group.' + self.domain;
                if(from.indexOf(privateSyncFlag) > 0 || from.indexOf(groupSyncFlag) > 0) {
                    senderId = from.substring(0, from.indexOf('@'));
                    targetId = from.substring(from.lastIndexOf('/') + 1);
                    if(from.indexOf(groupSyncFlag) > 0) {
                        conversationType = RongIMClient.ConversationType.DISCUSSION.value;
                    } else {
                        conversationType = RongIMClient.ConversationType.PRIVATE.value;
                    }
                } else {  //非同步消息
                    //判断主次账号消息
                    if(from.indexOf('@auxiliaryservice')>=0){
                        targetId = from.substring(0, from.indexOf('@'));
                        senderId = from.substring(from.lastIndexOf('/') + 1);
                        targetId  = 'push_'+targetId.substring(targetId.indexOf("|")+1);
                        //全是单聊
                        conversationType = RongIMClient.ConversationType.PRIVATE.value;
						if(senderId.indexOf("|wf|") != -1||
								senderId.indexOf("|mails") != -1||
								senderId.indexOf("|schedus") != -1||
								senderId.indexOf("|meetting") != -1||
								senderId.indexOf("|doc") != -1||
								senderId.indexOf("|notice") != -1){
								targetId = senderId;
							}
                    }else{
                         // 收到群组消息
                        if(from.indexOf('@group.' + self.domain) > 0) {
                            senderId = from.substring(0, from.indexOf('@'));
                            targetId = from.substring(from.lastIndexOf('/') + 1);
                            conversationType = RongIMClient.ConversationType.DISCUSSION.value;
                        }
                        // 收到单聊消息
                        else {
                            senderId = from.substring(0, from.indexOf('@'));
                            targetId = senderId;  // 单聊
                            conversationType = RongIMClient.ConversationType.PRIVATE.value;
                        }
                    }
                }

                entity.senderUserId = wapperUserId(senderId, udid);
                entity.targetId = wapperUserId(targetId, udid);
                entity.objectName = objectName;
                entity.sendTime = msgObj.sendTime;
                entity.conversationType = conversationType;
                if ((objectName in typeMapping) || (objectName in weaverMsgTypeMapping)) {
                    // 同步消息
                    if(objectName === 'FW:SyncMsg') {
                        var syncContentObj = JSON.parse(msgObj.content);
                        entity.content = HtmlUtil.htmlDecodeByRegExp(getObjString(syncContentObj.content));
                        entity.extra = getObjString(syncContentObj.extra);
                        entity.msgType = syncContentObj.messageType ? syncContentObj.messageType : getMsgTypeByObjectName(objectName);
                    }
                    // 非同步消息
                    else {
                        entity.content = HtmlUtil.htmlDecodeByRegExp(getObjString(msgObj.content));
                        entity.extra = getObjString(msgObj.extra);
                        entity.msgType = msgObj.msgType ? msgObj.msgType : getMsgTypeByObjectName(objectName);
                    }
                    if(entity.extra) {
                        var extreObj = JSON.parse(entity.extra);
                        entity.messageId = extreObj.msg_id;
                        if(!entity.sendTime && extreObj.sendTime) {
                        	entity.sendTime = extreObj.sendTime;
                        }
                    }
                } else {
                    if (objectName in sysNtf) {
                        entity.content = '';
                        entity.extra = extra;

                        // 特殊情况处理
                        if(objectName === 'RC:DizNtf') {
                            entity.senderUserId = msgObj.operator;  //群灰条消息，服务端不能from和to相同，导致操作者收不到消息，所以特殊处理用admin发送
                        }
                    }
                    else if(objectName == 'FW:CountMsg') {
                        entity.messageId = msgObj.content;
                        entity.content = msgObj.content;
                        entity.extra = msgObj.extra;
                        conversationType = msgObj.conversationType;
                    }else if(objectName =='FW:Extension_Msg'){
                        entity.msgType = 6;
                    }
                }

                for(var key in msgObj) {
                    if(!entity.hasOwnProperty(key)) {
                        entity[key] = msgObj[key];
                    }
                }
                var de = entity;

                if (objectName in typeMapping) {
                    message = new RongIMClient[typeMapping[objectName]](de)
                } else {
                    if (objectName in sysNtf) {
                        message = new RongIMClient[sysNtf[objectName]](de)
                    }
                    // 泛微自定义的类型
                    else if(objectName in weaverMsgTypeMapping) {
                        message = new RongIMClient.TextMessage(de); //普通文本
                    }
                }
                // 如果类型都在其中，就默认是文本类型
                if(message == null) {
                    message = RongIMClient.TextMessage.obtain(de.content);
                }

                message.setSentTime(entity.sendTime || new Date().getTime());
                message.setObjectName(objectName);
                message.setMessageType(entity.msgType);
                message.setSenderUserId(entity.senderUserId);
                message.setConversationType(entity.conversationType);
                message.setTargetId(entity.targetId);
                message.setMessageUId(entity.messageId);

                var receivedTime = delay ? delay : (new Date).getTime();
                message.setReceivedTime(receivedTime);
                var isOfflineMsg = delay ? true: false;
                message.setIsOfflineMsg(isOfflineMsg);
                RongIMClient.getInstance().setPingTime(new Date().getTime());
                message.setMessageId(entity.messageId);
                message.setReceivedStatus(new RongIMClient.ReceivedStatus());

                // 特殊子类的值设置(原因是json中字段的值跟 类 的域名称不一样)
                if (objectName in typeMapping) {
                    var msgType = message.getMessageType();
                    if(msgType == 2) { //图片
                        var imageUri = entity.imageUri;
                        if(!imageUri) {
                            imageUri = entity.imgUrl;
                        }
                        message.setImageUri(imageUri);
                    }
                }
                return message;
            };

            function getObjString(obj) {
                if(!obj) return "";
                return typeof obj === 'object' ? JSON.stringify(obj) : obj;
            }

            // 
            function getMsgTypeByObjectName(objectName) {
                var msgType = 6;
                switch (objectName) {
                    case 'RC:TxtMsg' :
                        msgType = 1;
                        break;
                    case 'RC:ImgMsg' :
                        msgType = 2;
                        break;
                    case 'RC:VcMsg' :
                        msgType = 3;
                        break;
                    case 'RC:LBSMsg' :
                        msgType = 8;
                        break;
                    case 'RC:InfoNtf':
                        msgType = 9;
                        break;
                }
                return msgType;
            }

            // 输出日志到控制台
            function writeLog(log){
                return;
                var ua = navigator.userAgent.toLowerCase();
                if(ua.match(/chrome\/([\d.]+)/)){
                   // console.log(log);
                }
            }
        };
    })();


})(window);