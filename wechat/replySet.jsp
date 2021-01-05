
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util,java.net.URLDecoder" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.wechat.cache.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
String id=Util.null2String(request.getParameter("id"));
String publicid = Util.null2String(request.getParameter("publicid"));
String name ="";
String sort ="";
String state ="";
String replytype ="";
String replymsg="";
String classname="";
String news="";
//编辑页面
if(id!=null&&!"".equals(id)){
	rs.execute("select * from wechat_reply where id="+id);
	if(rs.next()){
		name=rs.getString("name");
		sort=rs.getString("sort");
		replytype=rs.getString("replytype");
		if("0".equals(replytype)){
			replymsg=rs.getString("replymsg");
		}else if("2".equals(replytype)){
			news=rs.getString("replymsg");
		}
		classname=rs.getString("classname");
		state=rs.getString("state");
	}
}else{//新增页面,获取sort值
	rs.execute("SELECT max(sort) sort from wechat_reply where publicid='"+publicid+"'");
	sort="1.00";
	if(rs.next()){
		String s=rs.getString("sort");
		if(s!=null&&!"".equals(s)){
			sort=((int)Double.parseDouble(s)+1)+".00";
		}else{
			sort="1.00";
		}
	}
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(32161,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow: hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top" onclick="doSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<form name=frmmain method=post>
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<wea:layout type="2Col">
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}" >
				      <wea:item><%=SystemEnv.getHtmlLabelName(19829,user.getLanguage()) %></wea:item>
				      <wea:item>
				         	<input type="text" id="name" name="name" value="<%=name %>" class="InputStyle" onchange='checkinput("name","nameimage")'>
							<input type="hidden" id="id" name="id" value="<%=id%>">
						  	<SPAN id=nameimage><%if("".equals(name)){ %><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%} %></SPAN>
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(2093,user.getLanguage()) %></wea:item>
				      <wea:item>
				      	<input type="text" id="sort" name="sort" class="InputStyle" value="<%=sort %>" onchange='checkFloat(this);checkinput("sort","sortimage")'>
			  			<SPAN id=sortimage><%if("".equals(sort)){ %><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%} %></SPAN>
				     </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage()) %></wea:item>
				      <wea:item>
				        <select id="state" name="state">
					  		<option value="1" <%if(state.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18096, user.getLanguage())%></option>
					  		<option value="0" <%if(state.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
					  	</select>
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage()) %></wea:item>
				      <wea:item>
				       	  <select id="replytype" name="replytype" onchange="changereplytype()">
					  		<option value="0" <%if(replytype.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
					  		<option value="1" <%if(replytype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32693, user.getLanguage())%></option>
					  		<option value="2" <%if(replytype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(81638, user.getLanguage())%></option>
					  	 </select>
				      </wea:item>
				      
				      <wea:item attributes="{'samePair':'msgtr'}"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></wea:item>
				      <wea:item attributes="{'samePair':'msgtr'}">
				       	  <textarea rows="5" style="width:80%" id="replymsg" name="replymsg" value="<%=replymsg%>" onchange='checkinput("replymsg","replymsgimage")'><%=replymsg %></textarea> 
			  			  <SPAN id=replymsgimage><%if("".equals(replymsg)){ %><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%} %></SPAN>
				      </wea:item>
				      
				      <wea:item attributes="{'samePair':'classtr'}"><%=SystemEnv.getHtmlLabelName(32693, user.getLanguage())%></wea:item>
				      <wea:item attributes="{'samePair':'classtr'}">
				       	  <input type="text" id="classname" name="classname" class="InputStyle"  value="<%=classname %>" onchange='checkinput("classname","classnameimage")'>
			  			  <SPAN id=classnameimage><%if("".equals(classname)){ %><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%} %></SPAN>
				      </wea:item>
				      
				      <wea:item attributes="{'samePair':'newstr'}"><%=SystemEnv.getHtmlLabelName(81638, user.getLanguage())%></wea:item>
				      <wea:item attributes="{'samePair':'newstr'}">
				      		<brow:browser viewType="0" temptitle='<%=SystemEnv.getHtmlLabelName(81638,user.getLanguage())%>' name="news" browserValue='<%=news%>'
								browserOnClick="" browserUrl="/wechat/bowser/news/newsBrowser.jsp?id="  width="80%"
								hasInput="false"  isSingle="true" hasBrowser = "true" isMustInput='2'  
								completeUrl="" linkUrl="/wechat/materialView.jsp?newsid="  browserSpanValue='<%=NewsCache.getNewsRemark(news)%>'
								></brow:browser>
				      </wea:item>
	
				      
		              <wea:item>
		              	<br>
						<%=SystemEnv.getHtmlLabelName(85,user.getLanguage()) %>:<br>
						1.<strong><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%>：</strong>
						<%=SystemEnv.getHtmlLabelName(32923,user.getLanguage()) %><br><br>
						2.<strong><%=SystemEnv.getHtmlLabelName(32693, user.getLanguage())%>：</strong>
						<%=SystemEnv.getHtmlLabelName(32924,user.getLanguage()) %><br>
						<%=SystemEnv.getHtmlLabelName(32925,user.getLanguage()) %><br><br>
		              </wea:item>
			     </wea:group>
			</wea:layout>	
			 <!-- 操作 -->
			<div id="zDialog_div_bottom" class="zDialog_div_bottom">
				<wea:layout type="2col">
			     <wea:group context="">
			    	<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
									id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
				    </wea:item>
			    </wea:group>
			    </wea:layout>
		    </div>
		</td>
		</tr>
		</TABLE>
	</td>
</tr>
</table>
</form>

</body>
<script language="javascript">
var publicid="<%=publicid %>";

var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
}catch(e){}

function btn_cancle(){
	parentWin.closeDialog();
}

$(document).ready(function() {
	changereplytype();
});

function changereplytype(){
	if($('#replytype').val()==0){
		showEle('msgtr');
		hideEle('classtr');
		hideEle('newstr');
	}else if($('#replytype').val()==1){
		hideEle('msgtr');
		showEle('classtr');
		hideEle('newstr');
	}else if($('#replytype').val()==2){
		hideEle('msgtr');
		hideEle('classtr');
		showEle('newstr');
	}
} 


function doSubmit()
{	
	rightMenu.style.visibility="hidden";
	if (onCheckForm()){
		$.post("replyOperate.jsp", 
		{"operate":"save", "publicid": publicid,"id":$('#id').val(),"name":encodeURIComponent($('#name').val()),
			"replytype":$('#replytype').val(),"sort":$('#sort').val(),"replymsg":encodeURIComponent($('#replymsg').val()),
			"classname":$("#classname").val(),"state":$('#state').val(),"news":$('#news').val()},
	   	function(data){
			var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
			 if(data=="true"){
			 	parentWin.closeDlgARfsh();
			 }else{
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
			 }
   		});
    }
}

function onCheckForm(objectname0,objectname1)
{
     if (($('#name').val()=="")||($('#sort').val()=="")||($('#replytype').val()==0&&$('#replymsg').val()=="")||($('#replytype').val()==1&&$('#classname').val()=="")){
         window.top.Dialog.alert ("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>") ;
         return false;
     }else{
         return true;
     }
}
function previewNews(id){
	 openNewsPreview('/wechat/materialView.jsp?newsid='+id,"<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>");
}

</script>
<SCRIPT language="javascript" defer="defer" src="/wechat/js/wechatNews_wev8.js"></script>
</html>
