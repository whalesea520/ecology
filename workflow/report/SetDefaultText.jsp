
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
	function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.close();
		}
	}
</script>
</HEAD>


<%
   String title = Util.null2String(request.getParameter("title")); 
   String type = Util.null2String(request.getParameter("type"));
   String defaultval = Util.null2String(request.getParameter("defaultval"));
   String urltarget = Util.null2String(request.getParameter("urltarget"));//浏览按钮browser地址
   String val1="";
   String val2="";
   String val3="";
   String val4="";
   String bclick="";
   String fieldid=Util.null2String(request.getParameter("fieldid"));
   String isbill=Util.null2String(request.getParameter("isbill"));
   String browsertype = Util.null2String(request.getParameter("browsertype"));
   Enumeration<String> items=request.getParameterNames();
   while(items.hasMoreElements()){
	  String name=items.nextElement();
	  //System.out.print(name);
	  //System.out.println(" : "+request.getParameter(name));
   }
   if(!defaultval.equals("")&&type.equals("str")){
	   String[] arr=defaultval.split("~");
	   if(arr.length>0)
	   		val1=arr[0];
	   if(arr.length>1)
	        val2=arr[1];
   }
   if(!defaultval.equals("")&&type.equals("num")){
	   String[] arr=defaultval.split("~");
	   //System.out.println(arr.length);
	   if(arr.length>0)
	   		val1=arr[0];
	   if(arr.length>1)
	        val2=arr[1];
	   if(arr.length>2)
		    val3=arr[2];
	   if(arr.length>3)
		    val4=arr[3];
   }
   if(!defaultval.equals("")&&type.equals("urgency")){
	   val1=defaultval;
   }
   if(!defaultval.equals("")&&type.equals("person")){
	   String[] arr=defaultval.split("~");
	   //System.out.println(arr.length);
	   if(arr.length>0)
	   		val1=arr[0];
	   if(arr.length>1)
	        val2=arr[1];
	   if(arr.length>2)
		    val3=arr[2];
   }
   if(!defaultval.equals("")&&type.equals("check")){
	   String [] arr = defaultval.split("~");
	   if(arr.length>0)
	   		val1=arr[0];
	   if(arr.length>1)
		   val2=arr[1];
   }
   if(!defaultval.equals("")&&type.equals("browser")){
	   String [] arr = defaultval.split("~");
	   if(arr.length>0)
	   		val1=arr[0];
	   if(arr.length>1)
		   val2=arr[1];
	   if(arr.length>2)
		   val3=arr[2];
   }
%>


<BODY style="overflow:hidden">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=title%>"/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="" method=post>
<input type=hidden name="mark" value="<%=type%>">
<DIV align=right style="display:none">
</DIV>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top"  onclick="btnok_onclick()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" class="e8_btn_top"  onclick="btnclear_onclick()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%>'>
	<%if(type.equals("str")){%>
	<wea:item><%=SystemEnv.getHtmlLabelName(23243,user.getLanguage())%></wea:item>
	<wea:item>
	   <select id=defaulttype name=defaulttype>
	        <option></option>
	        <option value="1" <%if(val1.equals("1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        	<option value="2" <%if(val1.equals("2")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        	<option value="3" <%if(val1.equals("3")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        	<option value="4" <%if(val1.equals("4")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
	   </select>
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></wea:item>
	<wea:item>   
	    <input type="text" name="defaultval" value="<%=val2%>">
	</wea:item>
	<%}else if(type.equals("person")){%>
	<wea:item><%=SystemEnv.getHtmlLabelName(23243,user.getLanguage())%></wea:item>
	<wea:item>
	   <select id=persontype name=persontype>
	  		<option></option>
	        <option value="1" <%if(val1.equals("1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
        	<option value="2" <%if(val1.equals("2")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
	   </select>
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></wea:item>
	<wea:item>
	   <select id=personval name=personval>
	   	    <option></option>
	        <option value="1" <%if(val2.equals("1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
        	<option value="2" <%if(val2.equals("2")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(20558,user.getLanguage())%></option>
        	<option value="3" <%if(val2.equals("3")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(30042,user.getLanguage())%></option>
	   </select>
	</wea:item>
	<wea:item>
	        <%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(30042,user.getLanguage())%>
	</wea:item>	
	<wea:item>
	   <span> <brow:browser viewType="0" name="persondata"
								browserValue='<%=val3%>'
								completeUrl="/data.jsp?type=1"
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput='1' linkUrl="#" width="80%"
								browserSpanValue='<%=Util.toScreen(ResourceComInfo
												.getResourcename(val3), user
												.getLanguage())%>'></brow:browser>
	   </span>
	</wea:item>
	<%}else if(type.equals("urgency")){%>
	 <wea:item><%=SystemEnv.getHtmlLabelName(23243,user.getLanguage())%></wea:item>
	 <wea:item>
	   <select id=urgencyval name=urgencyval>
	   		<option></option>
	        <option value="0" <%if(val1.equals("0")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
        	<option value="1" <%if(val1.equals("1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
        	<option value="2" <%if(val1.equals("2")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
	   </select>
	 </wea:item>
	<%}else if(type.equals("check")){%>
	<wea:item><%=SystemEnv.getHtmlLabelName(23243,user.getLanguage())%></wea:item>
	<wea:item>
	   <select id=checktype name=checktype>
	   		<option></option>
	        <option value="1" <%if(val1.equals("1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        	<option value="2" <%if(val1.equals("2")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
	   </select>
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></wea:item>
	<wea:item>
	   <select id=checkval name=checkval>
	   <option></option>
	    <%
			char flag=2;
			rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+isbill);
			while(rs.next()){
				int tmpselectvalue = rs.getInt("selectvalue");
				String tmpselectname = rs.getString("selectname");
		%>
			<option value="<%=tmpselectvalue%>"><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
        <%}%>
	   </select>
	</wea:item>
	<%}else if(type.equals("browser")){%>
	 <wea:item><%=SystemEnv.getHtmlLabelName(23243,user.getLanguage())%></wea:item>
	 <wea:item>
	   <select id=browsertype name=browsertype>
	   		<option></option>
	        <option value="1" <%if(val1.equals("1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        	<option value="2" <%if(val1.equals("2")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
	   </select>
	 </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></wea:item>
	 <wea:item>
	  <%
	      bclick = "onShowBrowser('"+urltarget+"','"+browsertype+"')";
	  %>
	   <button type=button  class=Browser  onclick="<%=bclick%>"></button>
	   <input type=hidden name="browservalue" value="<%=val2%>">
       <input type=hidden name="browserlabel" value="<%=val3%>">
       <span id="browserspan"><%=val3%></span> 
	 </wea:item>
    <%}else{%>
	<wea:item><%=SystemEnv.getHtmlLabelName(129369, user.getLanguage())%></wea:item>
	<wea:item>
	   <select id=bottomtype name=bottomtype>
	   		<option></option>
	   		<option value="1" <%if(val1.equals("1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        	<option value="2" <%if(val1.equals("2")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        	<option value="3" <%if(val1.equals("3")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        	<option value="4" <%if(val1.equals("4")){%>selected="selected"<%}%> ><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        	<option value="5" <%if(val1.equals("5")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        	<option value="6" <%if(val1.equals("6")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
		</select>
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(129370, user.getLanguage())%></wea:item>
	<wea:item>
	   <input type="text" name="bottomval" value="<%=val2%>">
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(129371, user.getLanguage())%></wea:item>
	<wea:item>
	   <select id=toptype name=toptype>
	   		<option></option>
			<option value="1" <%if(val3.equals("1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        	<option value="2" <%if(val3.equals("2")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        	<option value="3" <%if(val3.equals("3")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        	<option value="4" <%if(val3.equals("4")){%>selected="selected"<%}%> ><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        	<option value="5" <%if(val3.equals("5")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        	<option value="6" <%if(val3.equals("6")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
		</select>
	</wea:item>
	<wea:item>
	   <%=SystemEnv.getHtmlLabelName(129372, user.getLanguage())%>
	</wea:item>
	<wea:item>
	   <input type="text" name="topval" value="<%=val4%>">
	</wea:item>
	<%}%>
	</wea:group>
</wea:layout>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
		    	<input type="button" accessKey=S  id=btnclose value="<%="T-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclose_onclick()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>

<script language="javascript" >
function getajaxurl(typeId){
	var url = "";
	if(typeId == 12|| typeId == 4||typeId==57||typeId==7 || typeId==18 || typeId==164 || typeId== 194 || typeId==23 || typeId==26 || typeId==3 || typeId==8 || typeId==135
	   || typeId== 65 || typeId==9 || typeId== 89 || typeId==87 || typeId==58 || typeId==59){
		url = "/data.jsp?type=" + typeId;			
	} else if(typeId==1 || typeId==165 || typeId==166 || typeId==17){
		url = "/data.jsp";
	} else {
		url = "/data.jsp?type=" + typeId;
	}
    return url;
}

function onShowBrowser(url,type) {
	var reparam = "";
	if(type=="224"||type=="225"||type=="226"||type=="227"){
		reparam = window.showModalDialog(url,window);
	}else{
		reparam = window.showModalDialog(url + "&selectedids=" + document.all("browservalue").value);
	}
	if (reparam != null) {
		var rid = wuiUtil.getJsonValueByIndex(reparam, 0);
		var rname = wuiUtil.getJsonValueByIndex(reparam, 1);
	    if (rid != "" && rid != "0") {
			if (rname.indexOf(",") == 0) {
				rname = rname.substr(1);
			}
			document.all("browservalue").value=rid;
	        document.all("browserlabel").value=rname;
	        $("#browserspan").html(rname);
	    } else {
	    	document.all("browservalue").value="";
	        document.all("browserlabel").value="";
	        $("#browserspan").html("");
	    }
	}
}

// 数字验证
function num_validate(){    
  //定义正则表达式部分    
  var value = document.all("defaultval").value;
  var reg = /^\d+$/;    
  if( value.constructor === String ){ 
        var re = value.match( reg );
        if(!re){
           document.all("defaultval").value="";
        }
   }    
}
// 清除
function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
		try{
			dialog.callback(returnjson);
		}catch(e){
		}
		dialog.close(returnjson);
   	}else{ 
   	    window.parent.returnValue  = returnjson;
   	 	window.parent.close();
   	}
}
// 关闭
function btnclose_onclick(){
    if(dialog){
        try{
		dialog.close();
		}catch(e){
		}
	}else{
	    window.parent.close();
	}
}
// 保存
function btnok_onclick(){
        var mark = document.all("mark").value;
		var val = "";
		if(mark == "str"){
			var val1 = document.all("defaulttype").value;
	        var val2 = document.all("defaultval").value;
	        if("" != val1 || "" != val2)
	        	val = val1+"~"+val2;
		}else if(mark == "person"){
		    var val1 = document.all("persontype").value;
	        var val2 = document.all("personval").value;
	        var val3 = document.all("persondata").value;
	        if("" != val1 || "" != val2 || "" != val3)
	        	val = val1+"~"+val2+"~"+val3;
		}else if(mark == "urgency"){
			val = document.all("urgencyval").value;
	    }else if(mark == "check"){
	        var val1 = document.all("checktype").value;
	        var val2 = document.all("checkval").value;
	        if("" != val1 || "" != val2)
	        	val = val1+"~"+val2;
	    }else if(mark == "browser"){
	        var val1 = document.all("browsertype").value;
	        var val2 = document.all("browservalue").value;
	        var val3 = document.all("browserlabel").value;
	        if("" != val1 || "" != val2 || "" != val3)
	        	val = val1+"~"+val2+"~"+val3;
	    }else{
	        var val1 = document.all("bottomtype").value;
	        var val2 = document.all("bottomval").value;
	        var val3 = document.all("toptype").value;
	        var val4 = document.all("topval").value;
	        if("" != val1 || "" != val2 || "" != val3 || "" != val4)
	        	val = val1+"~"+val2+"~"+val3+"~"+val4;
	    }
        var returnjson = {id:val,name:""};
		if(dialog){
			try{
				dialog.callback(returnjson);
			}catch(e){
			}
			dialog.close(returnjson);
   		}else{ 
   	        window.parent.returnValue  = returnjson;
   	 	    window.parent.close();
   	    }
}
</script>
