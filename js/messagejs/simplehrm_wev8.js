var wemail;
var whrm;
var wmess;
var wmsm;
var W = 0;//取得屏幕分辨率宽度
var H = 0;//取得屏幕分辨率高度
var userid = "";
var tousername;
// 获得窗口宽度 
function getWin()
{
	if (window.innerWidth)   
	{
		W  =  window.innerWidth;
	}   
	else if ((document.body)  &&  (document.body.clientWidth))   
	{
		W  =  document.body.clientWidth;
	} 
	// 获得窗口高度 
	if (window.innerHeight)   
	{
		H  =  window.innerHeight;
	}   
	else if ((document.body)  &&  (document.body.clientHeight))   
	{
		H  =  document.body.clientHeight;
	} 
	if (document.documnetElement  &&  document.documnetElement.clientHeight  &&  document.documnetElement.clientWidth)   
	{
		W  =  document.documnetElement.clientWidth;
		H  =  document.documnetElement.clientHeight;
	} 
	
}
var oIframe = document.createElement('iframe');
var message_table_Div =  document.createElement("div");
var content=null;
if(M('mainsupports')!=null)
{
	content = M('mainsupports').innerHTML;
}

function M(id)
{
    var result = document.getElementById(id);
    if(result==null)
    {
    	result = parent.document.getElementById(id);
    }
    if(result==null)
    {
    	result = parent.parent.document.getElementById(id);
    }
    if(result==null)
    {
    	result = parent.parent.parent.document.getElementById(id);
    }
    return result;
}

function MC(t){
   return document.createElement(t);
};
function isIE(){
      return (document.all && window.ActiveXObject && !window.opera) ? true : false;
} 
var bodySize = [];
var clickSize = [];
function getBodySize(){
   return bodySize;
}
function getClickSize(){
   return clickSize;
}
function pointerXY(event,doc)  
{  
     /*if(event.pageX||event.pageY)
     {
     	bodySize[0] = event.pageX;
     	bodySize[1] = event.pageY;
     	clickSize[0] = event.pageX;
     	clickSize[1] = event.pageY;
     }
     else
     {
     	bodySize[0] = event.clientX + document.body.scrollLeft+document.documentElement.clientWidth;
     	bodySize[1] = event.clientY + document.body.scrollTop+document.documentElement.clientHeight;
     	clickSize[0] = event.clientX;
     	clickSize[1] = event.clientY;
     }*/
	 var evt = event||window.event;
	 bodySize[0] = jQuery(window).width();
	 bodySize[1] = jQuery(window).height();
	 var targ=evt.srcElement ? evt.srcElement:evt.target;
	 clickSize[0] = jQuery(targ).offset().left;
	 clickSize[1] = jQuery(targ).offset().top;
	 clickSize[2] = jQuery(targ).height();
	 //alert(bodySize[0]+"::"+bodySize[1]+":::"+clickSize[0]+"::"+clickSize[1]);
} 

function pointerXYByWfSign(event,doc)  
{    
      var id=jQuery(doc.body).attr("class");
	  var offset=jQuery(document).find("#"+id).offset();
      var left=offset.left;
	  var top=offset.top;

     if(event.pageX||event.pageY)
     {
     	bodySize[0] = event.pageX+left;
     	bodySize[1] = event.pageY+top;
     	clickSize[0] = event.pageX+left;
     	clickSize[1] = event.pageY+top;
     }
     else
     {
     	bodySize[0] = event.clientX + document.body.scrollLeft+document.documentElement.clientWidth+left;
     	bodySize[1] = event.clientY + document.body.scrollTop+document.documentElement.clientHeight+top;
     	clickSize[0] = event.clientX+left
     	clickSize[1] = event.clientY+top;
     }
} 

function pointerXYByWfSign2(event,doc)  
{    
      var id=jQuery(doc.body).attr("class");
	  var offset=jQuery(document).find("#"+id).offset();
      var left=offset.left;
	  var top=offset.top;
	
     if(event.pageX||event.pageY)
     {
     	bodySize[0] = event.pageX+left;
     	bodySize[1] = event.pageY+top;
     	clickSize[0] = event.pageX+left;
     	clickSize[1] = event.pageY+top;
     }
     else
     {
     	bodySize[0] = event.clientX + document.body.scrollLeft+document.documentElement.clientWidth+left;
     	bodySize[1] = event.clientY + document.body.scrollTop+document.documentElement.clientHeight+top;
     	clickSize[0] = event.clientX+left
     	clickSize[1] = event.clientY+top;
     }
} 





function pointerXYByObj(obj)  
{    
    
    	var p =  $(obj).position()
     	bodySize[0] = p.left;
     	bodySize[1] = p.top;
     	clickSize[0] = p.left;
     	clickSize[1] = p.top;
     
} 


//让层显示为块 
function openResource()
{
	var submitURL = "/hrm/resource/simpleHrmResourceTemp.jsp?userid="+userid+"&date="+new Date();
	postXmlHttp(submitURL, "showResource()", "loadEmpty()");
}
function loadEmpty()
{
	void(0);
}
function showResource()
{
	var userinfo = _xmlHttpRequestObj.responseText;
	var re = /\$+([^\$]+)/ig; // 创建正则表达式模式。 
	var arr; 
	var i = 0;
	var language=readCookie("languageidweaver");
	
	var lastname="";
	var mobile="";
	var telephone="";
	var email="";
	var jobtitle="";
	var departmentname="";
	var location="";
	
	
	while ((arr = re.exec(userinfo)) != null) 
	{
		var result = arr[1];

		if(result=="noright"){
			var noright = SystemEnv.getHtmlNoteName(3420,languageid);
			/*if(language==7||language==9){
				noright = "对不起，您暂时没有权限！";
			} else {
				noright = "Sorry,you haven''t popedom temporarily!";
			}*/
			M("message_table").innerHTML = "<div style=\"border:1px solid #aaaaaa;width:100%;height:100%;\"><div style=\"float:right; clear:both; width:100%; text-align:right; margin:5px 0 0 0\"><IMG style=\"COLOR: #262626; CURSOR: hand\" id=closetext onclick=javascript:closediv(); src=\"/images/messageimages/temp/closeicno_wev8.png\" width=34 height=34></div><div style=\"text-indent:1.5pc; line-height:21px \"><b>"+noright+"</b></div></div>";
			return;
		}
		if(result ==',')
		{
			result = "";
			try{M("result"+i).innerHTML= result;}catch(e){}
		}
		else
		{
			if(result=='Mr.'||result=='Ms.')
			{
				if(language==7||language==9)
				{
					if(result=='Mr.')
					{
						
						M("result"+i).innerHTML= "（"+SystemEnv.getHtmlNoteName(3421,languageid)+"）";
					}
					else if(result=='Ms.')
					{
						M("result"+i).innerHTML= "（"+SystemEnv.getHtmlNoteName(3422,languageid)+"）";
					}					
				}
				else
				{
					M("result"+i).innerHTML= result;
				}
			}
			else if(result.indexOf("imageid=")!=-1)
			{
				var resourceimageid = result.substring(8,result.length);
				if(resourceimageid!="" && resourceimageid!="0") 
				{
					M("resourceimg").src="/weaver/weaver.file.FileDownload?fileid="+resourceimageid;
					M("resourceimghref").href = "/weaver/weaver.file.FileDownload?fileid="+resourceimageid;
				}
				else
				{
					if(M("result2").innerHTML=="（"+SystemEnv.getHtmlNoteName(3421,languageid)+"）"||M("result2").innerHTML=="Mr.")
					{
						M("resourceimg").src="/images/messageimages/temp/man_wev8.png";
					}
					else
					{
						M("resourceimg").src="/images/messageimages/temp/women_wev8.png";
					}
					M("resourceimghref").href="javascript:void(0);"
				}
			}
			else if(result.indexOf("ip=")!=-1)
			{
				var isonline = result.substring(3,result.length);
				if(isonline == ',')
				{
					M("isonline").src = "/images/messageimages/temp/offline_wev8.png";
					if(language==7||language==9)
					{
						M("isonline").title = SystemEnv.getHtmlNoteName(3423,languageid);
					}
					else
					{
						M("isonline").title =SystemEnv.getHtmlNoteName(3423,languageid);
					}
					M("result0").innerHTML = "";
				}
				else
				{
					M("isonline").src = "/images/messageimages/temp/online_wev8.png";
					if(language==7||language==9)
					{
						M("isonline").title = SystemEnv.getHtmlNoteName(3424,languageid);
					}
					else
					{
						M("isonline").title = SystemEnv.getHtmlNoteName(3423,languageid);
					}
					M("result0").innerHTML = isonline;
				}
			}
			else if(result.indexOf("messager")!=-1){
				try {
				M("showMessagerTrForSimpleHrm").style.display="";
				} catch(e){}
			}
			else
			{
				if(M("result"+i)!=null){
					if(i==1){
						M("result"+i).innerHTML="<a href=\"javascript:void(0)\" style='color: #008df6;' onclick=\"openhrmresource()\">"+result+"</a>";
					}else{
						M("result"+i).innerHTML= result;
					}
					
					if(i==1){
						lastname=result;
					}else if(i==3){
						mobile=result;
					}else if(i==4){
						telephone=result;
					}else if(i==5){
						email=result;
					}else if(i==10){
						jobtitle=result;
					}else if(i==6){
						departmentname=result;
					}else if(i==12){
						location=result;
					}
				}
			}
		}
		i++;
	}
	tousername = M('result1').innerHTML;

	createHrmQRCode(lastname,mobile,telephone,email,jobtitle,departmentname,location);
}

function changehrm()
{
   var mainsupports = M("mainsupports");   
   var bodySize = getBodySize();
   var clickSize = getClickSize();
   /*var wi = W-clickSize[0];
   var hi = H-clickSize[1];
   if(wi<372)
   {
   		wi=bodySize[0]+wi-372;
   }
   else
   {
   		wi = bodySize[0]
   }
   if(hi<230)
   {
   		hi=bodySize[1]+hi-230;
   }
   else
   {
   		hi = bodySize[1];
   }
   

   if(!window.ActiveXObject) {
	   var msfTop = document.body.clientHeight - (bodySize[1] - document.body.scrollTop) - 230;
	   if (msfTop < 0) {
		   hi = bodySize[1] + msfTop;
	   } else {
		   hi = bodySize[1];
	   }
   }*/
   var wi = clickSize[0];
   var hi = clickSize[1]+clickSize[2];
   if(bodySize[0]>0&&bodySize[0]-wi<463){
		wi = clickSize[0]-463;
   }
   if(bodySize[1]>0&&bodySize[1]-hi<300){
		hi = clickSize[1]-300;
   }
   if(!hi || hi<0)hi=10;
   if(!wi || wi<0)wi=10;  
   showIframe(mainsupports,hi,wi);
}
function showIframe(div,hi,wi){
	 div.style.width = 463+"px";
   div.style.height = 300+"px";
   div.style.left = wi+"px";
   div.style.top = hi+"px";
	 div.style.display = 'block';
	 if(content==undefined||content==null){
	 	content = M('mainsupports').innerHTML;
	 }
	 div.innerHTML = "";
	 oIframe.id = 'HelpFrame';
   div.appendChild(oIframe);
   oIframe.frameborder = 0;
   oIframe.scrolling = "no";
   //oIframe.src = "#";
   oIframe.style.filter = 'Alpha(Opacity=0);Opacity:0';
   oIframe.style.position = 'absolute';
   oIframe.style.zIndex = 9;
   
   oIframe.style.width = 463+"px"; 
   oIframe.style.height = 300+"px";
   oIframe.style.top = 'auto';
   oIframe.style.left = 'auto';
   oIframe.style.display = 'block';
   message_table_Div.id="message_table";
   message_table_Div.className="xTable_message1";
   div.appendChild(message_table_Div);
   
   message_table_Div.innerHTML=content;
   message_table_Div.style.position="absolute"
   message_table_Div.style.width = 455+"px";
   message_table_Div.style.height = 293+"px";
   message_table_Div.style.padding = "0px";
   message_table_Div.style.margin = "0px";
   message_table_Div.style.border = "0px";
   message_table_Div.style.zIndex=10;
   message_table_Div.style.display="block";
   message_table_Div.style.top="3px";
   message_table_Div.style.left="4px";

}
//打开DIV层
function openhrm(tempuserid)
{
	userid = tempuserid;
	getWin();
  	openResource();
  	changehrm();
  	void(0);
}
function setUserId(tempuserid)
{
	userid = tempuserid;
}

function openemail()
{  
	window.open("/email/MailAdd.jsp?isInternal=1&internalto="+userid);
}
function openhrmresource()
{
  	openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+userid);
}
function openmessage()
{
	openFullWindowForXtable("/sms/SmsMessageEdit.jsp?hrmid="+userid);
}

function doAddWorkPlan() {
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workplan/data/WorkPlan.jsp?resourceid="+userid+"&add=1";
	dialog.Title = "新建日程";
	dialog.Width = 800;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
	
}
function doAddCoWork(){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/cowork/AddCoWork.jsp?hrmid="+userid;
	dialog.Title = "新建协作";
	dialog.Width = 800;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function sendSimpleEmessage(){
	sendMsgToPCorWeb(userid,'0','','');	
}

//关闭DIV层
function closediv()
{
	M('mainsupports').style.display="none";
	//M('HelpFrame').style.display = 'none';
	M('message_table').style.display="none";
	
  	void(0);
}

function createHrmQRCode(lastname,mobile,telephone,email,jobtitle,departmentname,location){
	//生成二维码	
	var	txt = "BEGIN:VCARD \n"+
	"VERSION:3.0 \n"+
	"N:"+lastname+" \n"+
	"TEL;CELL;VOICE:"+mobile+" \n"+ 
	"TEL;WORK;VOICE:"+telephone+" \n"+
	"EMAIL:"+email+" \n"+
	"TITLE:"+jobtitle+" \n"+
	"ROLE:"+departmentname+" \n"+
	"ADR;WORK:"+location+" \n"+
	"END:VCARD";
			
	jQuery('#showSQRCodeDiv').qrcode({
		render: 'canvas',
		background:"#ffffff",
		foreground:"#000000",
		msize:0.3,
		size:120,
		mode:0,
		//mode 1,2 二维码中插入lable、mode=3或4 二维码中插入 插入，注意IE8及以下版本不支持插图及labelmode设置无效
		label:lastname,
		image:"/images/hrm/weixin_wev8.png",
		text: utf16to8(txt)
	});
		jQuery("#showSQRCodeDiv").hide();
	}
	
	function utf16to8(str) {                                         
  var out, i, len, c;                                          
  out = "";                                                    
  len = str.length;                                            
  for(i = 0; i < len; i++) {                                   
  c = str.charCodeAt(i);                                       
  if ((c >= 0x0001) && (c <= 0x007F)) {                        
      out += str.charAt(i);                                    
  } else if (c > 0x07FF) {                                     
      out += String.fromCharCode(0xE0 | ((c >> 12) & 0x0F));  
      out += String.fromCharCode(0x80 | ((c >>  6) & 0x3F));  
      out += String.fromCharCode(0x80 | ((c >>  0) & 0x3F));  
  } else {                                                    
      out += String.fromCharCode(0xC0 | ((c >>  6) & 0x1F));  
      out += String.fromCharCode(0x80 | ((c >>  0) & 0x3F));  
  }                                                           
  }                                                           
  return out;                                                 
} 
//在线聊天
function showHrmChat(){
    try {    	
		top.Page.showMessage(userid);
		 /*var docobj="top.hrmChat";
		while (!eval(docobj)) {
		    docobj="opener."+docobj;  
		}
		eval(docobj).sendChatFun(objid);*/		
	} catch(e) {
	   //alert(e);
	}
}
