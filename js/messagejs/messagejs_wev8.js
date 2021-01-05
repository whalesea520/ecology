
function showHide(id) {
	var el = window.parent.frames[0].document.getElementById(id);
	var bExpand = true;
	var images = el.getElementsByTagName("IMG");
	if (images[0].src.indexOf("minus_wev8.gif") != -1) {
		bExpand = false;
		images[0].src = "/images/messageimages/plus_wev8.gif";
		images[0].onclick="javascript:showHide('" + id + "');";
	} else {
		images[0].src = "/images/messageimages/minus_wev8.gif";
		images[0].onclick="javascript:showHide('" + id + "');"
	}
	var subs = el.lastChild;
	if (subs.nodeName == "UL" || subs.nodeName == "ul") {
		if (bExpand) {
			subs.style.display = "";
		} else {
			subs.style.display = "none";
		}
	}
}
function getColleague(id) {
	var select_name = window.parent.frames[0].document.getElementById(id);
	var to_id = window.parent.frames[1].document.getElementById("to_id");
	var to_name = window.parent.frames[1].document.getElementById("to_name");
	var user_id = window.parent.frames[1].document.getElementById("user_id");
	if(id.substring(0, id.indexOf("&"))==user_id.value)
	{
		return;
	}
	to_name.innerText = ","+select_name.innerText;
	to_id.value = ","+id.substring(0, id.indexOf("&"));
	
}
function getSubTree(id) {
	var user_id = window.parent.frames[1].document.getElementById("user_id").value;
	var submitURL = "/treeview?parent=" + id+"&rightStr=HrmResourceAdd:All&user_id="+user_id;
	postXmlHttp(submitURL, "parseSubTree(\"" + id + "\")", "load(\"" + id + "\")");
}
function getMessages() {
	var submitURL = "/treeview?";
	var user_id = window.parent.frames[1].document.getElementById("user_id").value;
	var to_id = window.parent.frames[1].document.getElementById("to_id").value;

	submitURL = submitURL + "user_id=" + user_id + "&to_id=" + to_id + "&operation=" + 2;
	postXmlHttp(submitURL, "displayMessages()", "loadMessages()");
}
function getAllMessages() {
	var submitURL = "/treeview?";
	var user_id = window.parent.frames[1].document.getElementById("user_id").value;
	var to_id = window.parent.frames[1].document.getElementById("to_id").value;
	submitURL = submitURL + "user_id=" + user_id + "&to_id=" + to_id + "&operation=" + 3;
	postXmlHttp(submitURL, "displayMessagesLog()", "loadMessages()");
}
function sendMessages() {
	var submitURL = "/treeview?";
	var user_id = window.parent.frames[1].document.getElementById("user_id").value;
	var user_name = window.parent.frames[1].document.getElementById("user_name").value;
	var to_id = window.parent.frames[1].document.getElementById("to_id").value;
	var to_name = window.parent.frames[1].document.getElementById("to_name").innerHTML;
	var content = window.parent.frames[1].document.getElementById("sendcontent").innerHTML;
	var r, re;           
    re = /contentEditable=true/g;          
    content = content.replace(re, ""); 
    //re = /&nbsp;/g;          
    //content = content.replace(re, " ");
    content = encodeURIComponent(content);
    //alert(content.length);原始div长度为289
	var now = new Date();
	var year = now.getYear();
	var month = now.getMonth() + 1;
	var day = now.getDate();
	var hour = now.getHours();
	var minute = now.getMinutes();
	if(minute.length==1)
	{
		minute = "0"+minute;
	}
	var second = now.getSeconds();
	var date = year + "-" + month + "-" + day;
	var time = hour + ":" + minute + ":" + second;
	submitURL = submitURL + "user_id=" + user_id + "&to_id=" + to_id + "&to_name=" + encodeURI(to_name) + "&content=" + encodeURI(content) + "&operation=" + 1 + "&date=" + date + "&time=" + time + "&user_name=" + encodeURI(user_name);
	postXmlHttp(submitURL, "displayMessages()", "loadMessages()");
}
function displayMessages() {
	var messagecontainer = window.parent.frames[1].window.frames['TranscriptFrame'].document.getElementById("transcriptDiv");
	var reps = decodeURIComponent(_xmlHttpRequestObj.responseText);
	//alert(reps+": "+reps.length);
	if(reps!="")
	{
		var message = window.parent.frames[1].window.frames['TranscriptFrame'].document.createElement("div");
		message.innerHTML = reps;
		messagecontainer.appendChild(message);
		messagecontainer.scrollTop = messagecontainer.scrollHeight;
	}
}
function displayMessagesLog() {
	var messagecontainer = window.parent.frames[1].window.frames['TranscriptFrame'].document.getElementById("transcriptDiv");
	var reps = decodeURIComponent(_xmlHttpRequestObj.responseText);
	//alert(reps+": "+reps.length);
	if(reps!="")
	{
		messagecontainer.innerHTML = "";
		var message = window.parent.frames[1].window.frames['TranscriptFrame'].document.createElement("div");
		message.innerHTML = reps;
		messagecontainer.appendChild(message);
		messagecontainer.scrollTop = messagecontainer.scrollHeight;
	}
}

function parseSubTree(id) {
	var el = window.parent.frames[0].document.getElementById(id);
	var ulElmt = window.parent.frames[0].document.createElement("UL");
	ulElmt.innerHTML = _xmlHttpRequestObj.responseText;
	el.appendChild(ulElmt);
	var images = el.getElementsByTagName("IMG");
	images[0].setAttribute("src", "/images/messageimages/minus_wev8.gif");
	images[0].setAttribute("onclick", "javascript:showHide('" + id + "');");
	var aTag = el.getElementsByTagName("A");
	aTag[0].setAttribute("onclick", "showHide('" + id + "')");
	aTag[0].setAttribute("href", "javascript:showHide('" + id + "')");
	var loadDiv = window.parent.frames[0].document.getElementById("load");
	loadDiv.style.display = "none";
}
function load(id) {
	var loadDiv = window.parent.frames[0].document.getElementById("load");
	loadDiv.style.display = "block";
}
function loadMessages() 
{
	
}
var _postXmlHttpProcessPostChangeCallBack;
var _xmlHttpRequestObj;
var _loadingFunction;
function postXmlHttp(submitUrl, callbackFunc, loadFunc) {
	var submitUrlhead = submitUrl.substring(0,submitUrl.indexOf("?"));
	var submitUrlcontent = submitUrl.substring(submitUrl.indexOf("?")+1,submitUrl.length);
	_postXmlHttpProcessPostChangeCallBack = callbackFunc;
	_loadingFunction = loadFunc;
	if (window.ActiveXObject) {
		try {
			_xmlHttpRequestObj = new ActiveXObject("Microsoft.XMLHTTP");
			_xmlHttpRequestObj.open("POST", submitUrlhead, true);
			_xmlHttpRequestObj.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;multipart/form-data;text/html;charset=utf-8");
			_xmlHttpRequestObj.onreadystatechange = postXmlHttpProcessPostChange;
			_xmlHttpRequestObj.send(submitUrlcontent);
		}
		catch (ee) {
			alert(ee.message)
		}
	} else {
		if (window.XMLHttpRequest) {
			_xmlHttpRequestObj = new XMLHttpRequest();
			_xmlHttpRequestObj.open("POST", submitUrlhead, true);
			_xmlHttpRequestObj.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;multipart/form-data;text/html;charset=utf-8");
			_xmlHttpRequestObj.onreadystatechange = postXmlHttpProcessPostChange;
			_xmlHttpRequestObj.send(submitUrlcontent);
		} else {
			if (window.createRequest) {
				_xmlHttpRequestObj = window.createRequest();
				_xmlHttpRequestObj.open("POST", submitUrlhead, true);
				_xmlHttpRequestObj.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;multipart/form-data;text/html;charset=utf-8");
				_xmlHttpRequestObj.onreadystatechange = postXmlHttpProcessPostChange;
				_xmlHttpRequestObj.send(submitUrlcontent);
			}
		}
	}
}
function postXmlHttpProcessPostChange() 
{
	if (_xmlHttpRequestObj.readyState==4) 
	{
		if(_xmlHttpRequestObj.status==200)
		{
			setTimeout(_postXmlHttpProcessPostChangeCallBack, 2);
		}
	}
	if (_xmlHttpRequestObj.readyState == 1) 
	{
		setTimeout(_loadingFunction, 2);
	}
}
function resetCookies()
{ 
	document.cookie="msmwindowOpen=notOpened"; 
} 
function setCookies()
{ 
	document.cookie="msmwindowOpen=isOpened"; 
}