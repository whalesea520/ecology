
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.wechat.cache.*"%>
<%@page import="weaver.wechat.bean.*"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.wechat.util.Const.MENU_TYPE"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style>
 
#menuOperDiv{
	text-align: center;
	margin:0 auto;
}

#preview_nav{
	margin-top:366px;
    margin-left:0px;
    padding-left:17px;
}

#preview_nav ul {
	padding: 0;
	margin: 0;
	list-style: none;
	position: absolute;
	
}

#preview_nav li {
	display:block;
	float: left;
	position: relative;
	height: 30px;
	border: 1px solid #BFBFBF;
	border-left: 0px solid #BFBFBF;
	color: #2D486C;
	line-height:30px;

}

#preview_nav a{
	display:block;
	text-align:center;
	height: 30px;
	color:#000 !important;
	font-weight:bold;

	 
	overflow:hidden; 
	text-overflow: ellipsis;
	-o-text-overflow:ellipsis;  

}

#preview_nav a:link,#preview_nav a:visited {
	display: block;
	text-decoration: none;
}
#preview_nav a:hover  {
	background-color: #BFBFBF;
}

#preview_nav ul li {
	height: 30px;
	float: none;
	border: 1px solid #BFBFBF;
	border-top: 0px;
	color: #2D486C;
	margin-left: 5px;
	text-align:center;
	
}
#preview_nav li ul {
	display: block;
}

</style>
</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
 
String id = Util.null2String(request.getParameter("id"));
WeChatBean wc=PlatFormCache.getWeChatBeanWithTokenById(id);
if("1".equals(wc.getTokenLock())){
	rs.writeLog("Token锁定,请稍后再试");
}
String publicid=wc.getPublicid();
String click=MENU_TYPE.click.toString();
 
int level1_limit=3;
int level2_limit=5;

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32639,user.getLanguage())+"-"+wc.getName();
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow: hidden;">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(17744,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:doRest(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(17744,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSubmit()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doRest()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doDelete()"/>
			 
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>



<form name=frmmain method=post action="platformMenu.jsp">
<input type="hidden" name="operate" value="save">
<input type="hidden" name="id" value="<%=id %>">


<div>
<div style="position: absolute;width: 95%;border:1px;top:10px;left:10px;">
	<span class="e8_grouptitle"><%=SystemEnv.getHtmlLabelName(32638,user.getLanguage())+SystemEnv.getHtmlLabelName(23036,user.getLanguage())+SystemEnv.getHtmlLabelName(221,user.getLanguage())%></span>
</div>
<div style="position: absolute;overflow: no;width: 95%;border:1px;top:50px;">
	<div style="position: absolute;margin-top:-20px;margin-left:10px;width: 280px;left: 0px; height: 340px;overflow: hidden;">
		<div style="position: absolute; width: 260px;padding: 10px;"> 
			<div style="position: absolute;left:20px;top:-180px;width: 240px;height: 480px;background:url(images/iphone_wev8.png)">
				<ul id="preview_nav">
					 
				</ul>
			</div>
		</div>
	</div>
	 
	<div style="position: absolute;margin-top:-20px;left: 330px;width: 400;height: 480px;">
		<div style="margin-left: 20px;padding: 10px;">
		<%=SystemEnv.getHtmlLabelName(85,user.getLanguage()) %>:<br><br>
		1.<%=SystemEnv.getHtmlLabelName(32909,user.getLanguage()) %><br><br>
		2.<%=SystemEnv.getHtmlLabelName(32910,user.getLanguage()) %><br><br>
		3.<%=SystemEnv.getHtmlLabelName(32911,user.getLanguage()) %><span style="color:red"><%=SystemEnv.getHtmlLabelName(32912,user.getLanguage()) %></span><br><br>
		<span style="color:red">4.<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage()) %></span><br>
		<%=SystemEnv.getHtmlLabelName(32913,user.getLanguage()) %><br><br>
		<%=SystemEnv.getHtmlLabelName(32914,user.getLanguage()) %><br><br>
		<%=SystemEnv.getHtmlLabelName(32915,user.getLanguage()) %><br><br>
		</div>
	</div>
</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<!-- 操作 -->
	     <wea:group context="">
	    	<wea:item type="toolbar">
			  <input type="button"
				value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
				id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
		    </wea:item>
	    </wea:group>
    </wea:layout>
</div>
	 
 
</form>

</body>
<script language="javascript">
var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
}catch(e){}

function btn_cancle(){
	parentWin.closeDialog();
}

var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	buildMenu();
}

 var level1_limit="<%=level1_limit%>";
 var level2_limit="<%=level2_limit%>";
  
 var publicid="<%=publicid%>";
 var click="<%=click%>";
 buildMenu();
 function buildMenu(){
 	removeDiv();
 	$('#preview_nav').html("");
  
 	$.post("menuOperate.jsp", 
		{"operate":"query", "publicid": publicid},
	   	function(data){
			var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
			var preview_html="";
			var jsonData=eval('('+data+')');
			var buttons=jsonData.button;
			var size=buttons.length;
			var offset=size>=3?0:30;
			var preview_width=208;
			if(size>0){
				preview_width=(208-offset)/size-1;
			}else{
				offset=preview_width
			}
			if(buttons){
				for(var key in buttons){
					if(isNaN(key)) continue;
					var btn=buttons[key];
					var preview_top=btn.sub_button?-5-(btn.sub_button.length*31)-1:-6;
					
					preview_html+='<li style="width: '+preview_width+'px;'+(key==0?'border-left: 1px solid #BFBFBF;':'')+'"><a id="menu_'+key+'" href="javascript:void(0)" onclick="clickMenu(this)" onMouseover="showOper(this)" n_level="1" n_parent="0" title="'+btn.name+'">'+btn.name+'</a><ul style="top:'+preview_top+'px;">';				
					if(btn.sub_button){
						var subBtns=btn.sub_button;
						for(var subKey in subBtns){
							if(isNaN(subKey)) continue;
							var subBtn=subBtns[subKey];

							preview_html+='<li style="width: '+(preview_width-10)+'px;'+(subKey==0?'border-top: 1px solid #BFBFBF;':'')+'"><a id="menu_'+key+'_'+subKey+'" href="javascript:void(0)" onclick="clickMenu(this)" onMouseover="showOper(this)" n_level="2" n_parent="menu_'+key+'" title="'+subBtn.name+'">'+subBtn.name+'</a></li>';
						}
					}
					preview_html+="</ul></li>";
				}
			}
			if(size<3){
				preview_html+='<li style="width:'+offset+'px;background-color:#558ED5"><a id="menu_add" href="javascript:void(0)" onclick="addMenu(\'menu_add\',1)" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(20015,user.getLanguage()) %>" onMouseover="removeDiv()"><img style="border:0;margin-top:8px;" src="images/1-add_wev8.png"></a></li>';
			}
			
			 

			$('#preview_nav').html(preview_html);
			
   });
 }
 
 function formatUrl(url){
	if(url.indexOf("https://open.weixin.qq.com/connect/oauth2/authorize")>-1){
		var s="redirect_uri=";
		url=url.substr(url.indexOf(s)+s.length);
		url=url.substr(0,url.indexOf("&"));
		url=url.replace(/%3A/g,":").replace(/%2F/g,"/")
		return url;
	}
	return url;
}

 	
 function clickMenu(obj){
 	$('#menuOperDiv').remove();
 	 
 }
 
 //菜单操作
 function addMenu(parentId,level){
 	removeDiv();
	var param="parentId="+parentId+"&level="+level+"&publicid="+publicid;
 	if(level==1){
	 	var levelNum=$('a[n_level=1]').length;
	 	if(levelNum<level1_limit){
	 	
		 	if(window.top.Dialog){
				diag_vote = new window.top.Dialog();
			} else {
				diag_vote = new Dialog();
			};
			diag_vote.currentWindow = window;
			diag_vote.Width = 600;
			diag_vote.Height = 500;
			diag_vote.Modal = true;
			diag_vote.maxiumnable = false;
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(20015,user.getLanguage())%>";
			diag_vote.URL = "/wechat/menuAddTab.jsp?"+param;
			diag_vote.show();
		 	 
	 	}else{
			window.top.Dialog.alert("一级菜单最多"+level1_limit+"个,不能再添加");
	 	} 
 	}else{
 		var levelNum=$('a[n_parent="'+parentId+'"]').length;
	 	if(levelNum<level2_limit){
		 	if(window.top.Dialog){
				diag_vote = new window.top.Dialog();
			} else {
				diag_vote = new Dialog();
			};
			diag_vote.currentWindow = window;
			diag_vote.Width = 600;
			diag_vote.Height = 500;
			diag_vote.Modal = true;
			diag_vote.maxiumnable = false;
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(20016,user.getLanguage())%>";
			diag_vote.URL = "/wechat/menuAddTab.jsp?"+param;
			diag_vote.show();
			
		}else{
	 		window.top.Dialog.alert("二级菜单最多"+level2_limit+"个,不能再添加");
	 	}
 	}
 }
 
 function editMenu(id){
    var level=$("#"+id).attr('n_level');
	removeDiv();
	var param="id="+id+"&publicid="+publicid;
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 500;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"+(level=="1"?"<%=SystemEnv.getHtmlLabelName(20015,user.getLanguage())%>":"<%=SystemEnv.getHtmlLabelName(20016,user.getLanguage())%>");
	diag_vote.URL = "/wechat/menuEditTab.jsp?"+param;
	diag_vote.show();
 }
 
 function delMenu(id){
 	var level=$("#"+id).attr('n_level');
 	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
 	if(level=="1"){
 		str+="<br><span style='color:red'><%=SystemEnv.getHtmlLabelName(32916,user.getLanguage())%></span>";
 	}
   	window.top.Dialog.confirm(str,function(){
	 	$.post("menuOperate.jsp", 
			{"operate":"del", "publicid": publicid,"id":id},
		   	function(data){
				var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				if(data=="true"){
					buildMenu();
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20462,user.getLanguage()) %>");
				}
	   });
 	});
 	
 }
 

function showOper(obj){
	$('#menuOperDiv').remove();
	var level=$(obj).attr('n_level');
	var id=$(obj).attr('id')
	var offset=level-1;
	var showadd=false;
	if(level==1){
		var levelNum=$('a[n_parent="'+id+'"]').length;
		if(levelNum<level2_limit){
			showadd=true;
		}
	}
	var newDiv=document.createElement("div");//创建div
	newDiv.setAttribute("id","menuOperDiv");
	newDiv.setAttribute("name","menuOperDiv");
	newDiv.style.position="absolute";//relative
	newDiv.style.backgroundColor="#558ED5";
	newDiv.style.height=obj.offsetHeight+"px";
	newDiv.style.width=(obj.offsetWidth+2)+"px";
	var xy=elemOffset(obj);
	newDiv.style.top=(xy.y+obj.offsetHeight+2)+"px";
	newDiv.style.left=(xy.x+offset)+"px";
	newDiv.style.zIndex="100"
	newDiv.style.visibility ="visible";//hidden
	newDiv.style.agile ="visible";//hidden
	//有哪些操作..
	var add="<span style='cursor:hand;' onclick='addMenu(\""+id+"\",2)' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(20016,user.getLanguage()) %>'><img style='margin-top:8px;' src='images/1-add_wev8.png'></span>";
	var edit="<span style='cursor:hand;' onclick='editMenu(\""+id+"\")' title='<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(524,user.getLanguage())+SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>'><img style='margin-top:8px;' src='images/1-edit_wev8.png'></span>";
	var del="<span style='cursor:hand;' onclick='delMenu(\""+id+"\")' title='<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())+SystemEnv.getHtmlLabelName(524,user.getLanguage())+SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>'><img style='margin-top:8px;' src='images/1-del_wev8.png'></span>";
	var kg="&nbsp;";
	var o1=(showadd?(add+kg+kg):"")+edit+kg+kg+del;
	var o2=edit+kg+kg+del;
	 
	newDiv.innerHTML=level==1?o1:o2;
	document.body.appendChild(newDiv);

	
    $(newDiv).mouseleave(function(){
       $(newDiv).remove();
    });
	 
	
}

function removeDiv(){
	$('#menuOperDiv').remove();
}

function elemOffset(elem)
{
     var t = elem.offsetTop;  
     var l = elem.offsetLeft;  
     while( elem = elem.offsetParent) 
     {  
          t += elem.offsetTop;  
          l += elem.offsetLeft;  
     }
     return {
        x : l ,
        y : t
     };
}

function doSubmit(){
	rightMenu.style.visibility="hidden";
	var str = "<%=SystemEnv.getHtmlLabelName(32696,user.getLanguage())%>";
   	window.top.Dialog.confirm(str,function(){
	   $.post("menuOperate.jsp", 
			{"operate":"update", "publicid": publicid},
		   	function(data){
				var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				if(data=="true"){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31439,user.getLanguage()) %>");
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31825,user.getLanguage()) %>");
				}
	   });
   });
}

function doRest(){
	rightMenu.style.visibility="hidden";
	var str = "<%=SystemEnv.getHtmlLabelName(32697,user.getLanguage())%>";
   	window.top.Dialog.confirm(str,function(){
	   $.post("menuOperate.jsp", 
			{"operate":"refresh", "publicid": publicid},
		   	function(data){
				var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				if(data){
					buildMenu();
				} 
	   });
   });
}

function doDelete(){
	rightMenu.style.visibility="hidden";
	var str = "<%=SystemEnv.getHtmlLabelName(32737,user.getLanguage())%>";
   	window.top.Dialog.confirm(str,function(){
	   $.post("menuOperate.jsp", 
			{"operate":"delMenu", "publicid": publicid},
		   	function(data){
				var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				if(data){
					buildMenu();
				} 
	   });
   });
}

function doBack(){
    
}

function preDo(){
	$("#topTitle").topMenuTitle({});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	jQuery("#hoverBtnSpan").hoverBtn();
};

 
</script>

</html>
