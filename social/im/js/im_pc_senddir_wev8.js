/*
    发送和接收文件夹工具类和对象
*/
(function(window){
    var require = window.Electron.require;
    var ipcRenderer = window.Electron.ipcRenderer;

    var node_util = require('util');
    var node_EventEmitter = require('events');
    var node_request = require('request');
    var node_dingdown = require('ding-download').Download;
    var node_fs = require('fs');
    var node_fse = require('fs-extra');
    var node_querystring = require('querystring');
    var node_os = require('os');
    var node_path = require('path');
    var node_url = require('url');

    var express = require('express');
    var app = express();
    var http = require('http').Server(app);

    var e_dialog = window.Electron.remote.dialog;
    var e_shell = window.Electron.remote.shell;

    // 传输文件夹工具方法
    var PcSendDirUtils = {
        // 工具
        node_request : node_request,
    
        maxFilesCount : 2000, //文件夹可传输的最大量
        maxFileSize : 1024 * 1024 * 1024 * 2,  //文件夹大小最大2G
        maxTimeoutTime : 1000 * 60 * 2,  // 最大等待时间, 2分钟
        portArray : [3000, 3001, 3002, 3003, 3004],
        isServerStarted : false,  // 服务是否启动
        currentPort : null,  //当前服务端口,

        // 当前发送中对象
        currentSendDir : {},
        // 当前接收中对象
        currentReceiveDir : {},
		
		//传输文件夹默认选择路径
		currentChoosedPath : '',
        
        // 当前接收对象超时器
        receiveTimeoutHandle : {},
        
        //对方没接收到消息超时处理器
        noMessageReceiveHandle : {},
        
        //对方发送完就退出处理器
        noReceiveFileHandle : {},

        init : function(){
            /*
            var pcConfig = ipcRenderer.sendSync('global-getDirServerConifg');
            this.isServerStarted = pcConfig.isServerStarted;
            this.currentPort = pcConfig.currentPort;
            */
            this.startServer();
        },
        _savToPc : function(){
            var config = {
                isServerStarted : this.isServerStarted,
                currentPort : this.currentPort
            };
            ipcRenderer.send('global-setDirServerConifg', config);
        },

       // 启动服务器
        startServer : function(){
            var _this = this;
			var _portArray = _this.portArray;
			var _port = _portArray.shift();
            // 注意：页面刷新会自动停止服务
            try {
				this.bindListener(_port);
			} catch(e) {
				console.error(e);
			}
        },
		bindListener: function(_port){
			var _this = this;
			_this.probe(_port, function(canuse, pt){
				if(!canuse){
					_this.bindListener(pt+1);
				}else{
					http.listen(_port, function () {
						_this.isServerStarted = true;
						_this.currentPort = _port;
						// _this._savToPc();
						_this._afterServerStartUp();
						console.log('文件(夹)传输 启动成功 端口：' + _port);
					});
				}
			});
			/*
			if(_portArray.length <= 0)
				return;
			var port = _portArray.shift();
			http.listen(port, function () {
				_this.isServerStarted = true;
				_this.currentPort = port;
				// _this._savToPc();
				_this._afterServerStartUp();
				console.log('文件(夹)传输 启动成功 端口：' + port);
			});
			http.on('error', function (err) {
				if (err.code === 'EADDRINUSE') { // 端口已经被使用
					console.info('端口 ： ' + port + ' 注册失败，尝试下一端口');
					PcSendDirUtils.bindListener(_portArray);
				}
			});
			*/
		},
		// 检测端口是否启动
		probe: function (port, callback) {
			var net = require('net');
		    var server = net.createServer().listen(port)
		    var calledOnce = false
		    var timeoutRef = setTimeout(function () {
		        calledOnce = true
		        callback(false,port)
		    }, 2000)
		    //timeoutRef.unref()
		    var connected = false
		    server.on('listening', function() {
		        clearTimeout(timeoutRef)
		        if (server)
		            server.close()
		        if (!calledOnce) {
		            calledOnce = true
		            callback(true,port)
		        }
		    })
		    server.on('error', function(err) {
		        clearTimeout(timeoutRef)
		
		        var result = true
		        if (err.code === 'EADDRINUSE')
		            result = false
		        if (!calledOnce) {
		            calledOnce = true
		            callback(result,port)
		        }
		    })
		},
        // 服务启动成功后，注册一些路由
        _afterServerStartUp : function(){
            if(this.currentPort == null) return;
            
            // 检测是否能请求到服务
            app.get('/detectingConnect', function(req, res){
                res.send('success');
            });

            // 确认是否能接收
            app.get('/confirmSend', function(req, res){
                var prams = node_url.parse(req.url, true).query;
                var confirm = prams.confirm;
                var msgId = prams.msgId;
                if(confirm) {
                    // 能接收，更新展示
                    //console.info('能接收，更新展示');
                    var dirSender = PcSendDirUtils.currentSendDir[msgId];
                    dirSender.updateSenderInfo({name:dirSender.EventsName.confirm, type: true, msgId : msgId});
                } else {
                    // 不能接收，删除发送，更新展示
                    //console.info('不能接收，删除发送，更新展示');
                    delete PcSendDirUtils.currentSendDir[msgId];
                }
                res.send('success');
            });

            // 获得文件夹内文件列表数据,参数dir=???
            app.get('/getDirFileList', function (req, res) {
                var prams = node_url.parse(req.url, true).query;
                var dir = node_querystring.unescape(prams.dir);
                node_fs.exists(dir, function(exists){
                    if(exists) {
                        var fileList = getFileList(dir);
                        res.send(JSON.stringify(fileList));
                    } else {
                        res.send('no dir');
                    }
                });
            });

            // 下载单个文件,参数path=???
            app.get('/downFile', function (req, res) {
                try {
                    var prams = node_url.parse(req.url, true).query;
                    var filepath = node_querystring.unescape(prams.path);
                    var fileReadStream = node_fs.createReadStream(filepath);
                    fileReadStream.pipe(res);
                } catch(e) {
                    //console.info(e);
                }
            });

            // 获得下载端的回馈
            app.get('/feedback', function (req, res) {
                var prams = node_url.parse(req.url, true).query;
                var msgId = prams.msgId;
                var sender = PcSendDirUtils.currentSendDir[msgId];
                if(sender) {
                    var info = prams.info;
                    var obj = {
                        name : sender.EventsName.info,
                        type : 'client',
                        msg : node_querystring.unescape(info)
                    };
                    sender.updateSenderInfo(obj);
                }
                res.send('success');
            });

            // 传输完成
            app.get('/confirmSendFinish', function(req, res){
                var prams = node_url.parse(req.url, true).query;
                var msgId = prams.msgId;
                var dirSender = PcSendDirUtils.currentSendDir[msgId];
                if(dirSender) {
                    dirSender.updateSenderInfo({name:dirSender.EventsName.finish, msgId : msgId});
                }
                res.send('success');
            });

            // 接收方取消接收
            app.get('/cancelReceive', function(req, res){
                var prams = node_url.parse(req.url, true).query;
                var msgId = prams.msgId;
                var dirSender = PcSendDirUtils.currentSendDir[msgId];
                if(dirSender) {
                    dirSender.updateSenderInfo({name:dirSender.EventsName.abort, msgId : msgId});
                }
                res.send('success');
            });
        },

        // 停止服务
        stopServer : function(){
            var _this = this;
            if(_this.currentPort) {
                http.close(function(){
                    //console.info('服务器停止,port=' + _this.currentPort);
                });
            }
        },

        //获得本机可用ip数组
        getLocalIPs : function(){
            var result = [];
            var reg = /^\b(([01]?\d?\d|2[0-4]\d|25[0-5])\.){3}([01]?\d?\d|2[0-4]\d|25[0-5])\b$/;
            var ifaces = node_os.networkInterfaces();
            for (var dev in ifaces) {
                var ipArray = ifaces[dev];
                for(var i = 0;  i < ipArray.length; i++) {
                    var obj = ipArray[i];
                    if(obj.family == 'IPv4' && obj.address != '127.0.0.1' && obj.address != 'localhost' && obj.address.match(reg)) {
                        result.push(obj.address);
                    }
                }
            }
            return result;
        },

        // 判断是否能链接
        canReceiveDir : function(ips, port, callback){
            var _this = this;
            var request = node_request.defaults({
                timeout : 1000
            });
            var cIp = ips.pop();
            request.get('http://' + cIp + ':' + port + '/detectingConnect', function(error, response, body){
                if(error) {
                    //console.info('无法建立连接，不在同一网络');
                    // 轮询下一个ip
                    if(ips.length <= 0) {
                        _this._getCallback(callback)(false);
                    }else{
                        _this.canReceiveDir(ips, port, callback);
                    }                
                    
                }
                else if(body == 'success') {
                    _this._getCallback(callback)(true, cIp, port);
                }
            });
        },
        //测试是否连接正常
        isReceiveDirNormal : function(ip, port, callback){
            var _this = this;
            var url = 'http://' + ip + ':' + port + '/detectingConnect';
            var request = node_request.defaults({
                timeout : 1000
            });
            request.get(url, function(error, response, body){
                if(error) {
                    _this._getCallback(callback)(false);         
                }else if(body == 'success') {
                    _this._getCallback(callback)(true);
                }
            });
        },
        
        _getCallback : function(callback){
            return typeof callback === 'function' ? callback : function(){};
        },

        // 确认是否可接收
        confirmSend : function(ip, port, flag, msgId){
            node_request.get('http://' + ip + ':' + port + '/confirmSend?confirm=' + flag + '&msgId=' + msgId);
        },
        // 通过FW:SysMsg消息回执对方无法接收
        confirmSendFromRong : function(targetId, msgId){
            var sendTime = new Date().getTime();
            var extra = '{"msg_id":"'+msgId+'","senderid":'+M_USERID+',"receiverids":"'+targetId+'","sendTime":'+sendTime+'}';
            // content这种写法为了兼容后台发送消息的格式
            var content = '{"content":{"pushType":"weaver_confirmSendDir","type":false}, "extra":' + extra + '}';
            var msgObj = {"content": content, "objectName":"FW:SysMsg", "msgType":6, "extra":extra, "senderid":M_USERID, "targetid":targetId, "targetType":"FW:SysMsg"};
            if(WindowDepartUtil.isAllowWinDepart()){
                ClientUtil.sendMessageToUser(targetId, msgObj, 6,"FW:SysMsg");
            }else{
            client && client.sendMessageToUser(targetId, msgObj, 6, function(data){
                if(data.issuccess) {
                    //console.info('确认无法接收 消息发送成功');
                } else {
                    //console.info('确认无法接收 消息发送失败');
                }
            });
            }
        },

        // 页面调用  发送文件夹
        sendDir : function(obj, alreadyPath){
        	var $chatWin = ChatUtil.getchatwin(obj);
            var targetId = $chatWin.attr('_targetid');
            var targetType = $chatWin.attr('_targettype');
            if(targetType != '0'){
            	return;
            }
            var _this = this;
            if(_this.currentPort == null) {
                DragUtils.closeDrags();
                window.top.Dialog.alert('文件夹传输服务启动失败，不能发送', function(){
                    DragUtils.restoreDrags();
                });
                return;
            }
            
            $.post('/social/im/SocialIMOperation.jsp', { operation : 'isPcClientOnline', checkId : targetId }, function(data){
                data = $.trim(data);
                if(data == 1) {
                    var msgId = IMUtil.guid();
                    if(alreadyPath && typeof alreadyPath === 'string') {
                        //console.info('alreadyPath = ' + alreadyPath);
                        _this._execSendDir(msgId, targetId, alreadyPath, obj, node_fs.statSync(alreadyPath).isFile());
                    } else {
                        e_dialog.showOpenDialog(window.Electron.currentWindow, {properties : ['openDirectory'] ,title : '请选择要传输的文件夹' ,defaultPath : PcSendDirUtils.currentChoosedPath}, function(choosed){
                            if(choosed) {
                                var srcPath = choosed[0];
								PcSendDirUtils.currentChoosedPath = node_path.resolve(srcPath, '..');
                                //console.info('srcPath = ' + srcPath);
                                var isFile = node_fs.statSync(srcPath).isFile();
                                _this._execSendDir(msgId, targetId, srcPath, obj, isFile);
                            }
                        });
                    }
                } else {
                    DragUtils.closeDrags();
                    window.top.Dialog.alert('对方客户端不在线，不能发送', function(){
                        DragUtils.restoreDrags();
                    });
                }
            });
        },
        // 执行发送文件夹
        _execSendDir : function(msgId, targetId, srcPath, _obj, isFile){
            var _this = this;
            var dirSender = new DirSender(msgId, targetId, srcPath, isFile);
            var msgId = dirSender.msgId;
            dirSender.on(dirSender.EventsName.info, function(obj){
                var type = obj.type;
                if(type == 'client') {
                    if(PcSendDirUtils.currentSendDir[msgId]) {
                        // 开始传输，清理掉定时取消
                        if(dirSender.timeoutHandle) {
                            dirSender.isStarted = true;
                            clearTimeout(dirSender.timeoutHandle);
                            dirSender.timeoutHandle = null;
                        }
                        var msg = obj.msg;
                        //console.info('发送方收到来自客户端的回馈  = ' + msg);
                        $('#' + msgId).find('.sendok').html(msg);
                    }
                }
            });
            dirSender.on(dirSender.EventsName.confirm, function(obj){
                var type = obj.type;
                var msgId = obj.msgId;
                if(type) {
                    // 可以接收
                    //console.info('可以接收 发送方更新显示');
                    $('#' + msgId).find('.sendok').html('等待对方确认接收');
                    clearTimeout(PcSendDirUtils.noMessageReceiveHandle[msgId]);
                    delete PcSendDirUtils.noMessageReceiveHandle[msgId];
                } else {
                    // 不可接收
                    //console.info('不可接收 发送方更新显示');
                	 if (IS_BASE_ON_OPENFIRE) {
                         delete PcSendDirUtils.currentSendDir[msgId];
                     }
                }
            });
            dirSender.on(dirSender.EventsName.timeout, function(obj){
                //console.info('超时无应答 更新展示 提示用户对方无应答（可能不在线）');
                var msgId = dirSender.msgId;
                delete PcSendDirUtils.currentSendDir[msgId];
                // 更新展示 提示用户对方无应答（可能不在线）
                var $msgDiv = $('#' + msgId);
                $msgDiv.attr('_finish', 'true');
                $msgDiv.find('.sendok').html('对方无应答，传输失败');
                $msgDiv.find('.acccomplete').addClass('accerror').show();
                $msgDiv.find('.optiondiv').html('');
            });
            dirSender.on(dirSender.EventsName.finish, function(obj){
                //console.info('发送方收到完成事件 更新显示为完成');
                var msgId = obj.msgId;
                delete PcSendDirUtils.currentSendDir[msgId];
                var $msgDiv = $('#' + msgId);
                $msgDiv.attr('_finish', 'true');
                $msgDiv.find('.sendok').html('文件' + (dirSender.isFile ? '' : '夹') + '传输完成');
                $msgDiv.find('.acccomplete').show();
                $msgDiv.find('.optiondiv').html('');
            });
            dirSender.on(dirSender.EventsName.abort, function(obj){
                //console.info('接收方取消接收');
                var msgId = obj.msgId;
                delete PcSendDirUtils.currentSendDir[msgId];
                var $msgDiv = $('#' + msgId);
                $msgDiv.attr('_finish', 'true');
                $msgDiv.find('.sendok').html('接收方取消接收');
                $msgDiv.find('.acccomplete').addClass('accerror').show();
                $msgDiv.find('.optiondiv').html('');
            });
            dirSender.startSend(function(senderObj){
                _this.showSenderDiv(_obj, senderObj);
            });
        },
        // 发送方消息展示
        showSenderDiv : function(obj, senderObj){
            var $chatWin = ChatUtil.getchatwin(obj);

            var senderInfo = getUserInfo(M_USERID);
            var senderName=senderInfo.userName;
            var senderHead=senderInfo.userHead;
            var senderid=senderInfo.userid;

            var msgId = senderObj.msgId;
            var srcPath = senderObj.path;
            var sendtime = senderObj.sendTime;
            var isFile = senderObj.isFile;
            var targetid = $chatWin.attr('_targetid');

            var tempdiv=$('#tempChatItem').clone().attr("id","").attr("id",msgId).show();
            tempdiv.attr("_targetid", targetid).attr("_targetName",senderName).attr("_targetHead",senderHead).attr("_targetType","0").attr("_senderid", senderid);
            tempdiv.attr('_dirType', 'send').attr('_finish', 'false').attr('_msgType', 'dirSend').attr('_isFile', isFile);
            tempdiv.find('.chatName').html(senderName);       //发送消息人姓名
            tempdiv.find('.userimage').attr("src",senderHead); //发送消息人头像
			FontUtils.clearFontSetStyle(tempdiv);

            var pathName = '';
            if(PcMainUtils.isWindows()) {
                pathName = srcPath.substring(srcPath.lastIndexOf('\\') + 1);
            } else {
                pathName = srcPath.substring(srcPath.lastIndexOf('/') + 1);
            }
            var accMsgdiv=$("#accMsgTemp").clone().attr("id","").show();
            accMsgdiv.find(".filename").html(pathName).attr("title",srcPath).removeAttr('onclick').click(function(){ e_shell.showItemInFolder(srcPath); });
            accMsgdiv.find('.sendok').html('等待对方确认...');
            accMsgdiv.find('.filesize').html('(' + getSizeFormate(senderObj.totalSize) + ')');
            accMsgdiv.find(".accicon").css({"background-image":"url('/social/images/acc_senddir_wev8.png')"});
            accMsgdiv.find('.acccomplete').hide();
            accMsgdiv.find(".opdiv").attr("_msgId",msgId);
            accMsgdiv.find('.optiondiv').html('<a href="javascript:void(0)" class="opdiv" onclick="PcSendDirUtils.senderCancelDir(\'' + msgId + '\')" >取消</a>');
            tempdiv.find('.chatContent').html("").removeAttr('onmouseover').removeAttr('onmouseout').append(accMsgdiv);
            
            // 以下是发送方的气泡展示
			FontUtils.addFontSetStyle(tempdiv, {
					'bubblecolor': FontUtils.getConfig('bubblecolor')
				});

            var chatList = $chatWin.find(".chatList");
            addSendtime(chatList, tempdiv, sendtime, "send");
            chatList.append(tempdiv);
            scrollTOBottom(chatList);
            
            var _this = this.currentSendDir[msgId];
            var noMessageReceiveHandle = setTimeout(function(){
                _this.emit(_this.EventsName.timeout);
            },1000 * 15);
            PcSendDirUtils.noMessageReceiveHandle[msgId] = noMessageReceiveHandle;
        },
        // 发送方取消发送
        senderCancelDir : function(msgId){
            var _this = this;
            DragUtils.closeDrags();
            window.top.Dialog.confirm('确定要取消发送？', function(){
                var $objDiv = $('#' + msgId);
                var targetId = $objDiv.attr('_targetid');
                _this._exeSenderCancelDir(true, msgId, targetId);
            }, function(){
                DragUtils.restoreDrags();
            });
        },
        // 执行取消发送  flag：是否展示提示信息
        _exeSenderCancelDir : function(type, msgId, targetId){
            if(!PcSendDirUtils.currentSendDir[msgId]) return;
            // 发送消息给接收方
            var sendTime = new Date().getTime();
            var extra = '{"msg_id":"'+msgId+'","senderid":'+M_USERID+',"receiverids":"'+targetId+'","sendTime":'+sendTime+'}';
            // content这种写法为了兼容后台发送消息的格式
            var content = '{"content":{"pushType":"weaver_senderCancelDir"}, "extra":' + extra + '}';
            var msgObj = {"content": content, "objectName":"FW:SysMsg", "msgType":6, "extra":extra, "senderid":M_USERID, "targetid":targetId, "targetType":"FW:SysMsg"};
            if(WindowDepartUtil.isAllowWinDepart()){
                ClientUtil.sendMessageToUser(targetId, msgObj, 6,"FW:SysMsg",function(data){
                if(data.issuccess) {
                    delete PcSendDirUtils.currentSendDir[msgId];
                    if(type) {
                        // 更新展示
                        var $msgDiv = $('#' + msgId);
                        $msgDiv.attr('_finish', 'true');
                        $msgDiv.find('.sendok').html('取消发送');
                        $msgDiv.find('.acccomplete').addClass('accerror').show();
                        $msgDiv.find('.optiondiv').html('');
                    }
                    DragUtils.restoreDrags();
                } else {
                    if(type) {
                        DragUtils.closeDrags();
                        window.top.Dialog.alert('取消失败', function(){
                            DragUtils.restoreDrags();
                        });
                    }
                }
            });
            }else{
            client && client.sendMessageToUser(targetId, msgObj, 6, function(data){
                if(data.issuccess) {
                    delete PcSendDirUtils.currentSendDir[msgId];
                    if(type) {
                        // 更新展示
                        var $msgDiv = $('#' + msgId);
                        $msgDiv.attr('_finish', 'true');
                        $msgDiv.find('.sendok').html('取消发送');
                        $msgDiv.find('.acccomplete').addClass('accerror').show();
                        $msgDiv.find('.optiondiv').html('');
                    }
                    DragUtils.restoreDrags();
                } else {
                    if(type) {
                        DragUtils.closeDrags();
                        window.top.Dialog.alert('取消失败', function(){
                            DragUtils.restoreDrags();
                        });
                    }
                }
            });
            }
        },
        afterSenderCancelSuccess : function(msgId){
            // 停止接收
            var receiverObj = PcSendDirUtils.currentReceiveDir[msgId];
            if(receiverObj) {
                receiverObj.cancelDownload();
                // 删除接收队列
                delete PcSendDirUtils.currentReceiveDir[msgId];
            }
            // 更新展示
            var $msgDiv =  $('#' + msgId);
            $msgDiv.attr('_finish', 'true');
            $msgDiv.find('.sendok').html('对方取消发送');
            $msgDiv.find('.acccomplete').addClass('accerror').show();
            $msgDiv.find('.optiondiv').html('');
        },
        // 取消所有发送
        cancelAllSend : function(){
            var _this = this;
            $.each(_this.currentSendDir, function(k, v){
                try {
                    _this._exeSenderCancelDir(false, k, v.targetId);
                } catch(e) {
                    console.error(e);
                }
            });
        },

        // 处理接收到的发送文件夹通知
        sendAndReceiveDir : function(allContent){
            var extra = allContent.extra;
            var content = allContent.content;
            var ips = content.ips.split(',');
            var port = content.port;
            var msgId = extra.msg_id;
            var srcPath = content.srcPath;
            var isFile = content.isFile;
            var totalSize = content.totalSize;
            var sendTime = extra.sendTime;

            PcSendDirUtils.canReceiveDir(ips, port, function(flag, _ip, _port){
                if(flag) {
                    // 可以传输
                    //console.info('可以传输  ip=' + _ip + ',port=' + _port + ',msgId=' + msgId);
                    PcSendDirUtils.confirmSend(_ip, _port, flag, msgId);
                    // 1、展示消息
                    var senderId = extra.senderid;
                    var targetId = extra.receiverids;
                    var senderInfo = getUserInfo(targetId);
		    		var targetInfo = getUserInfo(senderId);
		    		var bubblecolor = extra.bubblecolor;
                    // --1、增加最近聊天栏(未处理)
                    updateConversationList(senderInfo, senderId, 0, '[文件]传输文件(夹)', sendTime);
                    // --2、添加聊天tab
                    $('#conversation_' + senderId).click();
                    // --3、增加一个聊天内容
                    setTimeout(function(){
                        var node_querystring = require('querystring');

                        var $chatWin = $('div[class="chatWin"][_targetid="'+ senderId +'"]');

                        //var senderName=senderInfo.userName;
                        //var senderHead=senderInfo.userHead;
						
						var senderName = targetInfo.userName;
                        var senderHead = targetInfo.userHead;

                        var tempdiv=$('#tempChatItem').clone().attr("id","").attr("id", msgId).show();
                        tempdiv.attr('_msgId', msgId).attr('_senderId', extra.senderId).attr('_srcIpAddress', _ip).attr('_srcIpPort', _port)
                                .attr('_srcPath', srcPath).attr('_isFile', isFile);
                        tempdiv.attr('_dirType', 'receive').attr('_finish', 'false').attr('_msgType', 'dirSend');
                        tempdiv.attr("_targetid",senderId).attr("_targetName",senderName).attr("_targetHead",senderHead).attr("_targetType","0").attr("_senderid", senderId);
                        tempdiv.find('.chatName').html(senderName);       //发送消息人姓名
                        tempdiv.find('.userimage').attr("src",senderHead); //发送消息人头像
						tempdiv.find(".chatRItem").removeClass("chatRItem").addClass("chatLItem");
						
			
						FontUtils.clearFontSetStyle(tempdiv);
						// 接收方显示
						FontUtils.addFontSetStyle(tempdiv, {
								'bubblecolor': bubblecolor
							});
                        var srcViewPath = node_querystring.unescape(srcPath);
                        var filename = '';
                        if(srcViewPath.indexOf('\\') > 0) {
                            filename = srcViewPath.substring(srcViewPath.lastIndexOf('\\') + 1);
                        } else {
                            filename = srcViewPath.substring(srcViewPath.lastIndexOf('/') + 1);
                        }

                        var accMsgdiv=$("#accMsgTemp").clone().attr("id","").show();
                        accMsgdiv.find(".filename").removeAttr('onclick').html(filename).attr("title", srcViewPath).css('cursor', 'default');
                        accMsgdiv.find('.sendok').html('请确认接收文件' + (isFile ? '' : '夹'));
                        accMsgdiv.find('.filesize').html('(' + getSizeFormate(totalSize) + ')');
                        accMsgdiv.find(".accicon").css({"background-image":"url('/social/images/acc_senddir_wev8.png')"});
                        accMsgdiv.find('.acccomplete').hide();
                        accMsgdiv.find(".opdiv").attr("_msgId",msgId);
                        var aHtml = '<a href="javascript:void(0)" class="opdiv" onclick="PcSendDirUtils.receiveDir(this)">接收</a>';
                        aHtml += '&nbsp;&nbsp;&nbsp;&nbsp;';
                        aHtml += '<a href="javascript:void(0)" class="opdiv" onclick="PcSendDirUtils.receiverCancel(\'' + msgId + '\')">取消</a>';
                        accMsgdiv.find('.optiondiv').html(aHtml);
                        tempdiv.find('.chatContent').html("").removeAttr('onmouseover').removeAttr('onmouseout').append(accMsgdiv);

                        var chatList = $chatWin.find(".chatList");
                        addSendtime(chatList, tempdiv, sendTime, "receive");
                        chatList.append(tempdiv);
                        scrollTOBottom(chatList);
                        
                        // 添加到取消定时器
                        var receiverTimeoutHandle = setTimeout(function(){
                            if(PcSendDirUtils.currentReceiveDir[msgId] || ($('#' + msgId).length > 0 && $('#' + msgId).attr('_finish') == 'false')) {
                                var $msgDiv = $('#' + msgId);
                                $msgDiv.attr('_finish', 'true');
                                $msgDiv.find('.sendok').html('操作超时，接收失败');
                                $msgDiv.find('.acccomplete').addClass('accerror').show();
                                $msgDiv.find('.optiondiv').html('');
                                delete PcSendDirUtils.currentReceiveDir[msgId];
                            }
                        }, PcSendDirUtils.maxTimeoutTime - 1000);
                        PcSendDirUtils.receiveTimeoutHandle[msgId] = receiverTimeoutHandle;
                        
                        TrayUtils.flashingTray();
                    }, 2000);
                } else {
                    //通知发送方无法传输
                    //console.info('通知发送方无法传输 无法传输应该通过消息来发送回馈');
                    var targetId = extra.senderid;
                    PcSendDirUtils.confirmSendFromRong(targetId, msgId);
                }
            });
        },

        // 接收文件夹
        receiveDir : function(obj){
            var _this = this;
            e_dialog.showOpenDialog(window.Electron.currentWindow, {properties : ['openDirectory'],title : '请选择保存文件夹的路径' }, function(choosed){
                if(choosed) {
                    var destPath = choosed[0];
                    var $obj = $(obj).parents('.chatItemdiv');
                    var msgId = $obj.attr('_msgId');
                    var senderId = $obj.attr('_senderId');
                    var srcIpAddress = $obj.attr('_srcIpAddress');
                    var isFile = $obj.attr('_isFile') == 'true';
                    var srcIpPort = $obj.attr('_srcIpPort');
                    var srcPath = node_querystring.unescape($obj.attr('_srcPath'));

                    var pathName = '';
                    if(srcPath.indexOf('\\') > 0) {
                        pathName = srcPath.substring(srcPath.lastIndexOf('\\') + 1);
                    } else {
                        pathName = srcPath.substring(srcPath.lastIndexOf('/') + 1);
                    }
                    destPath = node_path.join(destPath, pathName);
                    
                    // 判断是否有同名文件夹
                    PcMainUtils.getFileStats(destPath, function(err, stats){
                    	var _flag = false;
						// 目标目录包含同名文件夹➕
						if(stats  && !stats.isfile && stats.name == pathName) {
							_flag = true;
						}
						if(_flag) {
							showImConfirm('该路径下已包含'+pathName+'目录，是否覆盖？' , function(){
								 _this._execReceiveDir(msgId, senderId, srcIpAddress, srcIpPort, srcPath, isFile, destPath);
	                    		$(obj).hide();
							}) ;
						}else{
							 _this._execReceiveDir(msgId, senderId, srcIpAddress, srcIpPort, srcPath, isFile, destPath);
	                    	$(obj).hide();
						}
					});
                }
            });
        },
        // 执行接收
        _execReceiveDir : function(msgId, senderId, srcIpAddress, srcIpPort, srcPath, isFile, destPath){
            var receiver = new DirReceiver(msgId, senderId, srcIpAddress, srcIpPort, srcPath, isFile, destPath);
            var $msgDiv =  $('#' + msgId);
            var info = '正在传输...';
            $msgDiv.find('.sendok').html(info);
            
            if(isFile) {
                // 发送回馈
                node_request.get('http://' + srcIpAddress + ':' + srcIpPort + '/feedback?msgId=' + msgId + '&info=' + node_querystring.escape(info));
            }

            // 取消接收超时定时器
            if(PcSendDirUtils.receiveTimeoutHandle[msgId]) {
                var handle = PcSendDirUtils.receiveTimeoutHandle[msgId];
                clearTimeout(handle);
                delete PcSendDirUtils.receiveTimeoutHandle[msgId];
            }
            //接收中信息
            receiver.on(receiver.EventsName.info, function(){
                var $msgDiv =  $('#' + msgId);
                if(PcSendDirUtils.currentReceiveDir[msgId]) {
                    var readyCount = receiver.readyCount + receiver.errorCount + receiver.fileCount;
                    var totalCount = receiver.totalCount;
                    
                    var info = '正在传输  ' + readyCount+ '/' + totalCount;
                    //console.info('接收进度   info=' + info);
                    // 更新展示
                    $msgDiv.find('.sendok').html(info);
                    var schedule = (readyCount/totalCount).toFixed(2);
                    setFileDlBar(msgId, schedule);
                    // 发送回馈
                    node_request.get('http://' + srcIpAddress + ':' + srcIpPort + '/feedback?msgId=' + msgId + '&info=' + node_querystring.escape(info));
                    
                    if(readyCount == totalCount) {
                        receiver.emit(receiver.EventsName.finish);
                        setFileDlBar(msgId, 1.1);
                    }
                    clearTimeout(PcSendDirUtils.noReceiveFileHandle[msgId]);
                    delete PcSendDirUtils.noReceiveFileHandle[msgId];
                }
            });
            // 接收完成
            receiver.on(receiver.EventsName.finish, function(){
                //console.info('接收方下载完成');
                var $msgDiv =  $('#' + msgId);
                $msgDiv.attr('_finish', 'true');
                $msgDiv.find('.sendok').html('文件' + (receiver.isFile ? '' : '夹') + '传输完成');
                $msgDiv.find('.acccomplete').show();
                $msgDiv.find('.optiondiv').html('<a href="javascript:void(0)" class="opdiv" onclick="PcSendDirUtils.openDir(\'' + node_querystring.escape(destPath) + '\');">打开文件' + (receiver.isFile ? '' : '夹') + '</a>');
                node_request.get('http://' + srcIpAddress + ':' + srcIpPort + '/confirmSendFinish?msgId=' + msgId);
                delete PcSendDirUtils.currentReceiveDir[msgId];
            });
            
             receiver.on(receiver.EventsName.error, function(){
                //console.info('接收方下载失败');
                var $msgDiv =  $('#' + msgId);
                $msgDiv.find('.sendok').html('发送方已断开连接，无法继续接收');
                $msgDiv.attr('_finish', 'true');
                $msgDiv.find('.acccomplete').addClass('accerror').show();
                $msgDiv.find('.optiondiv').html('');
                delete PcSendDirUtils.currentReceiveDir[msgId];
            });

            // 加入接收队列
            PcSendDirUtils.currentReceiveDir[msgId] = receiver;
            var handle = setTimeout(function(){
                PcSendDirUtils.isReceiveDirNormal(srcIpAddress,srcIpPort,function(flag){
                        if(!flag){
                            receiver.emit(receiver.EventsName.error);
                        }
                    });
            },1000*15);
            PcSendDirUtils.noReceiveFileHandle[msgId] = handle;
        },
        openDir : function(descPath) {
        	e_shell.openItem(node_querystring.unescape(descPath));
        },
        // 接收方取消接收
        receiverCancel : function(msgId){
            window.top.Dialog.confirm('确定要取消接收？', function(){
                // 停止接收
                var receiverObj = PcSendDirUtils.currentReceiveDir[msgId];
                if(receiverObj) {
                    receiverObj.cancelDownload();
                    // 删除接收队列
                    delete PcSendDirUtils.currentReceiveDir[msgId];
                }
                var $tempChatItem = $('#' + msgId);
                var srcIpAddress = $tempChatItem.attr('_srcIpAddress');
                var srcIpPort = $tempChatItem.attr('_srcIpPort');
                // 通知发送方
                node_request.get('http://' + srcIpAddress + ':' + srcIpPort + '/cancelReceive?msgId=' + msgId);
                setTimeout(function(){
                    // 更新展示
                    var $msgDiv =  $('#' + msgId);
                    $msgDiv.attr('_finish', 'true');
                    $msgDiv.find('.sendok').html('取消接收');
                    $msgDiv.find('.acccomplete').addClass('accerror').show();
                    $msgDiv.find('.optiondiv').html('');
                }, 500);
            });
        },
        // 停止所有接收
        cancelAllReceive : function(){
            var _this = this;
            $.each(_this.currentReceiveDir, function(k, v){
                var receiverObj = PcSendDirUtils.currentReceiveDir[k];
                if(receiverObj) {
                    receiverObj.cancelDownload();
                    // 通知发送方
                    node_request.get('http://' + receiverObj.srcIpAddress + ':' + receiverObj.srcIpPort + '/cancelReceive?msgId=' + k);
                }
            });
        }
    };

    function setFileDlBar(msgId, width) {
        var $fileBar = $('#' + msgId).find('.pc-fileDlBar');
        if(width < 1) {
            $fileBar.show();
            $fileBar.find('.progress-bar').width((width * 100) + '%');
        } else if(width > 1) {
            $fileBar.hide();
        }
    }

    // 获得文件夹文件清单
    function getFileList(dirPath) {
        var fileArray = new Array();
        dirPath = node_path.join(dirPath);
        var wrapperFile = _wrapperReuslt(dirPath);
        fileArray.push(wrapperFile);  
        if(!wrapperFile.isFile) {
            _exeFindFile(wrapperFile.path, fileArray);
        }
        return fileArray;

        function _exeFindFile(_dirPath, _fileArray) {
            var list = node_fs.readdirSync(_dirPath);
            for(var i = 0; i < list.length; i++) {
                // if(list[i].substring(0,1) == '.' || list[i].substring(0,2) == '..') continue;  // 过滤特殊文件
                var path = node_path.join(_dirPath, list[i]);
                var _wrapperFile = _wrapperReuslt(path);
                _fileArray.push(_wrapperFile);

                // 如果需要限制文件数量，可放开此处
                if(PcSendDirUtils.maxFilesCount && _fileArray.length > PcSendDirUtils.maxFilesCount) {
                    throw new Error("The number of files larger than " + PcSendDirUtils.maxFilesCount);
                }

                if(!_wrapperFile.isFile) {
                    _exeFindFile(_wrapperFile.path, _fileArray);
                }
            }
        }

        function _wrapperReuslt(_path) {
            var fileStat = node_fs.statSync(_path);
            return {
                path : _path,
                isFile : fileStat.isFile(),
                size : fileStat.size
            };
        }
    }

    // 文件夹发送方
    function DirSender(msgId, targetId, path, isFile) {
        node_EventEmitter.call(this);
        this.msgId = msgId;
        this.targetId = targetId;
        this.path = path;
        this.sendTime = 0;
        this.total = 0;
        this.currentCount = 0;
        this.totalSize = 0;
        this.isStarted = false;
        this.timeoutHandle = null;
        this.isFile = isFile;  //是否是文件。true：文件，false：文件夹。
    }
    node_util.inherits(DirSender, node_EventEmitter);
    DirSender.prototype.startSend = function(callback) {
        var _this = this;
        var checkResult = _this._checkFilesCount();
        if(checkResult.success) {
            var sendTime = new Date().getTime();
            _this.sendTime = sendTime;
            var extra = '{"msg_id":"'+this.msgId+'","senderid":'+M_USERID+',"receiverids":"'+this.targetId+'","sendTime":'+sendTime+',"bubblecolor":"'+FontUtils.getConfig('bubblecolor')+'"}';
            // content这种写法为了兼容后台发送消息的格式
            var content = '{"content":{"pushType":"weaver_sendDir","isFile":' + _this.isFile + ',"srcPath":"' + node_querystring.escape(this.path) + '","ips":"'+PcSendDirUtils.getLocalIPs().join(',')+'","port":'+PcSendDirUtils.currentPort+',"totalSize":'+_this.totalSize+'}, "extra":' + extra + '}';
            var msgObj = {"content": content, "objectName":"FW:SysMsg", "msgType":6, "extra":extra, "senderid":M_USERID, "targetid":this.targetId, "targetType":"FW:SysMsg"};
            if(WindowDepartUtil.isAllowWinDepart()){
                ClientUtil.sendMessageToUser(this.targetId, msgObj, 6,"FW:SysMsg",function(data){
                if(data.issuccess) {
                    //console.info('消息发送成功 更新提示 等待对方确认接收');
                    PcSendDirUtils.currentSendDir[_this.msgId] = _this;
                    _this.timeoutHandle = setTimeout(function(){
                        if(PcSendDirUtils.currentSendDir[_this.msgId] && PcSendDirUtils.currentSendDir[_this.msgId].timeoutHandle ) {
                            _this.emit(_this.EventsName.timeout);
                        }
                    }, PcSendDirUtils.maxTimeoutTime);
                    typeof callback === 'function' && callback(_this);
                } else {
                    //console.info('消息发送失败');
                }
                });
            }else{
            client && client.sendMessageToUser(this.targetId, msgObj, 6, function(data){
                if(data.issuccess) {
                    //console.info('消息发送成功 更新提示 等待对方确认接收');
                    PcSendDirUtils.currentSendDir[_this.msgId] = _this;
                    _this.timeoutHandle = setTimeout(function(){
                        if(PcSendDirUtils.currentSendDir[_this.msgId] && PcSendDirUtils.currentSendDir[_this.msgId].timeoutHandle ) {
                        	_this.emit(_this.EventsName.timeout);
                        }
                    }, PcSendDirUtils.maxTimeoutTime);
                    typeof callback === 'function' && callback(_this);
                } else {
                    //console.info('消息发送失败');
                }
            });
            }
        } else {
        	DragUtils.closeDrags();
            window.top.Dialog.alert(checkResult.message, function(){
                DragUtils.restoreDrags();
            });
        }
    };
    // 检测文件（夹）是否符合发送规则
    DirSender.prototype._checkFilesCount = function(){
        var flag = {success : false};
        if(this.isFile) {
            var fileStat = node_fs.statSync(this.path);
            this.total = 1;
            this.totalSize = fileStat.size;
            if(this.totalSize > PcSendDirUtils.maxFileSize) {
                flag['message'] = '文件大小不能超过' + getSizeFormate(PcSendDirUtils.maxFileSize);
            }
        } else {
            try {
                var fileArr = getFileList(this.path);
                //console.info('文件数量 ' + fileArr.length);
                if(fileArr.length == 1) {
                    flag['message'] = '无法发送空文件夹';
                } else {
                    this.total = fileArr.length;
                    for(var i = 0; i < this.total; i++) {
                        this.totalSize += fileArr[i].size;
                        if(this.totalSize > PcSendDirUtils.maxFileSize) {
                            flag['message'] = '文件夹大小不能超过' + getSizeFormate(PcSendDirUtils.maxFileSize);
                            break;
                        }
                    }
                }
            } catch(e) {
                console && console.error(e);
                flag['message'] = '文件夹内文件数量超过最大可传输文件数' + PcSendDirUtils.maxFilesCount;
            }
        }
        flag['success'] = !flag.hasOwnProperty('message');
        return flag;
    };
    DirSender.prototype.updateSenderInfo = function(msg){
        this.emit(msg.name, msg);
    };
    DirSender.prototype.EventsName = {
        'info': 'info',
        'confirm' : 'confirm',
        'timeout' : 'timeout',
        'abort' : 'abort',
        'finish': 'finish'
    };



    // 文件夹接收方
    var DirReceiver = function(msgId, senderId, srcIpAddress, srcIpPort, srcPath, isFile, destPath){
        node_EventEmitter.call(this);
        this.msgId = msgId;
        this.senderId = senderId;
        this.srcIpAddress = srcIpAddress;
        this.srcIpPort = srcIpPort;
        this.srcPath = srcPath;
        this.isFile = isFile;
        this.destPath = destPath;
        this.srcFileArray = null;
        this.currentDl = null;
        this.totalCount = 0;
        this.fileCount = 0;
        this.readyCount = 0;
        this.errorCount = 0;
        this._execDown();
    };
    node_util.inherits(DirReceiver, node_EventEmitter);
    // 替换为本地文件路径名
    DirReceiver.prototype._getLocalFilePath = function(fromPath){
        return fromPath.replace(this.srcPath, this.destPath);
    };
    // 执行下载
    DirReceiver.prototype._execDown = function(){
        var _this = this;
        if(_this.isFile) {
            _this.srcFileArray = [];
            var tmp = {
                path : _this.srcPath,
                isFile : true,
                size : 0
            };
            _this.srcFileArray.push(tmp);
            _this.totalCount = 1;
            _this._downNext();
        } else {
            var url = 'http://' + _this.srcIpAddress + ':' + _this.srcIpPort + '/getDirFileList?dir=';
            node_request.get(url + node_querystring.escape(_this.srcPath),  function (error, response, body) {
                if (!error && response.statusCode == 200) {
                    _this.srcFileArray = JSON.parse(body);
                    _this.totalCount = _this.srcFileArray.length - 1;

                    if(_this.srcFileArray.length > 0) {
                        _this._downNext();
                    }
                } else {
                    console.error(error);
                }
            });
        }
    };

    // 执行下一个下载
    DirReceiver.prototype._downNext = function(){
        var _this = this;
        if(_this.srcFileArray && _this.srcFileArray.length > 0) {
            _this._exeDownOnce(_this.srcFileArray.pop());
        }
    };
    //执行一次下载
    DirReceiver.prototype._exeDownOnce = function(srcFileObj){
        var _this = this;
        try {
            var isFile = srcFileObj.isFile;
            var filePath = srcFileObj.path;
            var savePath = filePath.replace( _this.srcPath, _this.destPath);
            //console.info('savePath = ' + savePath);
            if(isFile) {
                node_fse.ensureFileSync(savePath);
                var downUrl = 'http://' + _this.srcIpAddress + ':' + _this.srcIpPort + '/downFile?path=' + node_querystring.escape(filePath);
                var dl = new node_dingdown(downUrl, savePath);
                _this.currentDl = dl;
                dl.on('finish', function(arg1, arg2, arg3){
                    //console.info('下载文件成功  savePath = ' + savePath);
                    _this.readyCount++;
                    _this.currentDl = null;
                    _this.emit(_this.EventsName.info);
                    _this._downNext();
                });
                dl.on('error', function(error){
                    //console.info('下载文件失败  savePath = ' + savePath);
                    PcSendDirUtils.isReceiveDirNormal(_this.srcIpAddress,_this.srcIpPort,function(flag){
                        if(flag){
                            _this.errorCount++;
                            _this.currentDl = null;
                            _this.emit(_this.EventsName.info);
                            _this._downNext();
                        }else{
                            _this.emit(_this.EventsName.error);
                        }
                    }); 
                });
            } else {
                var destTmp = filePath.replace( _this.srcPath, _this.destPath);
                node_fse.ensureDirSync(destTmp);
                _this.emit(_this.EventsName.info);
                _this.fileCount++;
                _this._downNext();
                //console.info('创建文件夹  destTmp=' + destTmp);
            }
        } catch(e){
            //console.info('下载文件失败  savePath = ' + savePath);
            //console.info(e);
            _this.errorCount++;
            _this.currentDl = null;
            _this.emit(_this.EventsName.info);
            _this._downNext();
        }
    };
    // 取消下载
    DirReceiver.prototype.cancelDownload = function(){
        var _this = this;
        _this.srcFileArray = null;
        if(_this.currentDl) {
            _this.currentDl.abort();
            _this.currentDl = null;
        }
    };
    DirReceiver.prototype.EventsName = {
        'info': 'info',
        'finish' : 'finish' ,
        'error' : 'error' 
    };


    $(function(){
        // 允许传输文件
        if(ClientSet && ClientSet.ifForbitFilesTransfer != '1') {
            // 对外暴露对象
            PcSendDirUtils.init();
            window.PcSendDirUtils = PcSendDirUtils;
            window.DirSender = DirSender;
         }
    });
})(window);