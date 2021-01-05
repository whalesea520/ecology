
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.wechat.cache.PlatFormCache"%>
<%@page import="weaver.wechat.bean.WeChatBean"%>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util,weaver.wechat.request.*" %>
<%@ page import="java.util.*,com.alibaba.fastjson.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="js/wechat_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
String id=Util.null2String(request.getParameter("id"));
String publicid="";
String name="";
rs.executeSql("select * from wechat_band where id="+id);
String url="";
String msg="";
int expires_secends=600;
if(rs.next()){
	publicid=rs.getString("publicid");
	String openid=rs.getString("openid");
	WeChatBean wc=PlatFormCache.getWeChatBeanWithTokenByPublicId(publicid);
	name=wc.getName();
	if(openid!=null&&!"".equals(openid)){
		msg=SystemEnv.getHtmlLabelName(32700,user.getLanguage());
	}else{
		
		long expires=Long.parseLong(rs.getString("expires"));
		long current=QRCodeAction.getScene();
		String ticketStr=rs.getString("ticket");
		if(expires <= current|| ticketStr==null||"".equals(ticketStr)){
			
			QRCodeAction qrc=new QRCodeAction();
			String ticket=qrc.queryTicketByScene(current,wc.getAccess_token(),expires_secends);
			JSONObject json=JSONObject.parseObject(ticket);
			ticketStr=json.getString("ticket");
			if(ticketStr!=null&&!"".equals(ticketStr)){
				String sql="update wechat_band set ticket='"+ticketStr+"',expires="+(current+(expires_secends*1000))+" where id="+id;
				rs1.executeSql(sql);
			}else{
				msg=ticket;
				RespMsg resp=JSON.parseObject(ticket,RespMsg.class);
				PlatFormCache.resetTokenExprie("生成二维码绑定",resp, wc.getAccess_token());
			}
		}
		if(ticketStr!=null&&!"".equals(ticketStr)){
			url="https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket="+ticketStr;
		}
	}
	 
}else{
	msg=SystemEnv.getHtmlLabelName(32140,user.getLanguage());
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32641,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow: hidden;">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
 RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:btn_cancle(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
			
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<form name=frmmain method=post>
<input type="hidden" name="operate" value="save">
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<wea:layout type="2col">
	     	<wea:group context='<%=name %>'>
		      <wea:item><div style="text-align:center"><%=SystemEnv.getHtmlLabelName(32929,user.getLanguage())%></div></wea:item>
	        </wea:group>
	        <wea:group context="" attributes="{'groupDisplay':'none'}">
		      <wea:item attributes="{'isTableList':'true'}">
			      <div style="text-align:center">
			      <%if(!"".equals(url)){ %>
				  <img src="<%=url %>" width="200px"/>
				  <%}else{%>
				  	<%=msg %>
				  <%} %>
				  </div>
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
</html>
<script language="javascript">

var parentWin = null;
try{
parentWin = parent.parent.getParentWindow(parent);
}catch(e){}

function btn_cancle(){
	parentWin.closeDlgARfsh()
}
</script>
