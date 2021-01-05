// 功能：检测控件版本
// 参数：o	-- 控件对象
function checkActivexVersion(o,sPsrviewVer)
{
	try
	{
		var bIsSetupPsrview;
		var sLocalVersion, sPsrviewVersion;
		var arrLocalVersion, arrPsrviewVersion;
		
		bIsSetupPsrview = false;
		sLocalVersion = o.GetCurrentVersion();
		sPsrviewVersion = sPsrviewVer;
		arrLocalVersion = sLocalVersion.split(".");
		arrPsrviewVersion = sPsrviewVersion.split(".");
		for (var i = 0; i < arrPsrviewVersion.length; i++)
		{
			if (arrLocalVersion[i] < arrPsrviewVersion[i])
			{
				bIsSetupPsrview = true;
				break;
			}
			else if (arrLocalVersion[i] > arrPsrviewVersion[i])
				break;
		}
	}
	catch(e)
	{
	}
	return bIsSetupPsrview;
}

// 功能：检测 ActiveX 如果没有正确安装，弹出安装提示
function checkWeaverActiveX(language)
{
	var lang = readCookie("languageidweaver");
	var url = "";
	var acceptlanguage = getOuterLanguage();
 	 if(acceptlanguage!="")
 	 	acceptlanguage = acceptlanguage.toLowerCase();
 	 if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1)
 	 {
		url = "/activex/ActiveXBIG5.xml";
	 }
	 else
	 {
	 	if(language==8){
			url = "/activex/ActiveXEN.xml";
		}else if(language==9){
			url = "/activex/ActiveXBIG5.xml";
		}else{
			url = "/activex/ActiveX.xml";
		}
	 }
	 
	$.ajax({
        url: url,
		async:true,
        dataType: 'xml',
        type: 'GET',
        timeout: 2000,
        error: function(xml)
        {
        	if(typeof xml.responseText == 'string'  && xml.responseText.indexOf("activex") > -1){
        		var xmlText  = xml.responseText
        		var xmlData;
				if($.browser.msie){
					xmlData = new ActiveXObject("Microsoft.XMLDOM");
					xmlData.async = false;
					xmlData.loadXML(xmlText);
			   }else{
				   xmlData = new DOMParser().parseFromString(xmlText, "text/xml");
				}
        		showDialogWithXml(xmlData,lang)
        	}else{
        		alert("Load XML Error！");
        	}
        },
        success: function(xml)
        {
        	showDialogWithXml(xml,lang)	
        }
    });
}
function showDialogWithXml(xml,lang){
	$(xml).find("activex").each(function(i)
	{
		if (!Detect($(this).children("progid").text()))
		{
			var dlg=new window.top.Dialog();//定义Dialog对象
			var title = title;
			dlg.currentWindow = window;
			dlg.Width=730;//定义长度
			dlg.Height=600;
			dlg.URL="/weaverplugin/PluginMaintenance.jsp";
			dlg.Title=SystemEnv.getHtmlNoteName(3620,lang);
			dlg.show();
			return false;
		}
	});
}
function OnCheckPage(url,w,h){
	window.location=url;
    self.resizeTo(w,h);
}

function Winopen(url,winname,nstyle){
	window.open(url,winname,nstyle);
}

// 功能：用创建对象的方法检测 ActiveX 是否安装
function Detect(ProgID)
{
	var obj;
	var bOk=false;
	try
	{		
		obj = new ActiveXObject(ProgID);
		if(obj) bOk = true;
		delete(obj);
	} 
	catch(e) {}
	obj=null;
	return bOk;
}

//从链接中获取域名
function GetDomain(sUrl)
{
	var re = new RegExp("^(http://|https://|)(([\\w\\-.])+)($|:|/)", "ig");
	if (re.exec(sUrl) == null) return "";

	return RegExp.$2;
}
