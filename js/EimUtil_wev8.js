if (EimUtil == null) var EimUtil = {};

EimUtil.ActiveName = 'PEEim.PEEIMCOM';

//EimUtil.ActiveCid = 'clsid:AB902754-37E4-4C98-9ECA-3906EC6BED2C';
EimUtil.engine = null;

/*
 * 验证Eim是否安装了。 * Eim安装后会向系统注册这个对象，可以根据此对象能否实例化来判读客户端是否安装。 */
EimUtil.isInstall = function (){
	if(EimUtil.engine == null){
		try{
			EimUtil.engine = new ActiveXObject(EimUtil.ActiveName);
		}catch(e){
			try{
				EimUtil.engine = new ActiveXObject('EIMObj.EIMCOMOBJ');
			}catch(e1){
			}
			//alert(e);
		}
	}
	return EimUtil.engine != null;
}

/*
 * 启动Eim客户端 */
EimUtil.RunEim = function (userName,password){
	if(EimUtil.isInstall()){
		EimUtil.engine.RunEim(userName, password);
	}
}

/*
 * 获取人员在线状态 * 返回值：-1 错误;  0 离线;  1 离开;  2 隐身;  3 在线。 */
EimUtil.getStatus = function (loginName){
	if(loginName != null && EimUtil.isInstall()){
		return EimUtil.engine.getStatus(loginName);
	}
	return -1;
}

/*
 * 打开聊天对话窗口
 */
EimUtil.OpenChatDial = function (loginName){
	if(loginName != null && EimUtil.isInstall()){
		EimUtil.engine.OpenChatDial(loginName, '');
	}
}

/*
 * 在线感知功能
 * 注：本功能只是测试用，实际情况可根据本代码来修改
 */
EimUtil.presenceAwareness = function (loginName){
	//新建一个线程来执行，防止执行时间太长造成页面假死
	setTimeout('EimUtil.agent(\'' + loginName + '\')', 1);
}

/*
 * 在线感知功能代理方法
 */
EimUtil.agent = function (loginName){
	//var div = document.getElementById('EimPresenceAwareness');//获取页面的div
	var div = document.createElement("div");
	if(div == null || loginName == null) return;
	
	div.style.fontSize = '12px';
	
	while(div.hasChildNodes()){//移除div内所有子内容
		div.removeChild(div.firstChild);
	}
	
	if(EimUtil.isInstall()){//安装了客户端
		var image = document.createElement('img');
		image.src = 'images/empty_wev8.gif';
		image.style.backgroundRepeat = 'no-repeat';
		image.style.verticalAlign = 'middle';
		
		var _click = document.createElement('a');
		_click.style.fontSize = '12px';
		_click.href = 'javascript:EimUtil.OpenChatDial(\'' + loginName + '\')';
		_click.title = '点击给我留言';
		
		var state = EimUtil.getStatus(loginName);
		switch(state){//-1  错误，0 离线，1 离开，2 隐身， 3 在线
			case 0:
				image.style.backgroundImage = 'url("images/offline_wev8.gif")';
				_click.appendChild(document.createTextNode('(离线)'));
				break;
			case 1:
				image.style.backgroundImage = 'url("images/busyline_wev8.gif")';
				_click.appendChild(document.createTextNode('(繁忙)'));
				break;
			case 2:
				image.style.backgroundImage = 'url("images/afieldline_wev8.gif")';
				_click.appendChild(document.createTextNode('(隐身)'));
				break;
			case 3:
				image.style.backgroundImage = 'url("images/online_wev8.gif")';
				_click.appendChild(document.createTextNode('(在线)'));
				
				break;
			case -1:
			default:
				image.style.backgroundImage = 'url("images/error_wev8.gif")';
				_click.appendChild(document.createTextNode('(客户端未启动)'));
				_click.title = '点击启动客户端';
				_click.href = 'javascript:EimUtil.RunEim()';
		}
		div.appendChild(image);
		div.appendChild(_click);
		
		if(state == -1){
			var flush = document.createElement('a');
			flush.style.marginLeft = '10px';
			flush.href = 'javascript:EimUtil.presenceAwareness(\'' + loginName + '\')';
			//flush.appendChild(document.createTextNode('[刷新]'));
			div.appendChild(flush);
		}
		
	}else{//没有安装客户端		var label = document.createElement('label');
		label.style.fontSize = '12px';
		label.style.color = 'red';
		label.appendChild(document.createTextNode('本地客户端未安装的'));
		
		var download = document.createElement('a');
		download.style.marginLeft = '10px';
		download.href = 'javascript:alert("这里是下载地址")';
		download.appendChild(document.createTextNode('[下载客户端]'));
		
		var flush = document.createElement('a');
		flush.style.marginLeft = '10px';
		flush.href = 'javascript:EimUtil.presenceAwareness(\'' + loginName + '\')';
		flush.appendChild(document.createTextNode('[刷新]'));
		
		div.appendChild(label);
		div.appendChild(download);
		div.appendChild(flush);
	}
	return div;
}

/*
 * 退出客户端
 */
EimUtil.ExitEim = function (){
	if(EimUtil.isInstall()){
		EimUtil.engine.ExitEim();
	}
}

/*
 * 隐藏客户端 */
EimUtil.HideEim = function (){
	if(EimUtil.isInstall()){
		EimUtil.engine.HideEim();
	}
}

/*
 * 显示客户端 */
EimUtil.ShowEim = function (){
	if(EimUtil.isInstall()){
		EimUtil.engine.ShowEim();
	}
}


