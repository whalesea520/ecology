<%@page import="weaver.formmode.tree.CustomTreeUtil"%>
<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.interfaces.workflow.browser.Browser"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo"/>
<jsp:useBean id="FormModeTransMethod" class="weaver.formmode.search.FormModeTransMethod" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
User user = HrmUserVarify.getUser(request , response) ;
String htmltype = Util.null2String(request.getParameter("htmltype"));
String type = Util.null2String(request.getParameter("feildtype"));
String dbtype = Util.null2String(request.getParameter("dbtype"));
String id = Util.null2String(request.getParameter("feildid"));
String feildvalue = Util.null2String(request.getParameter("feildvalue"));
String modeid=Util.null2String(request.getParameter("modeid"));
String formID=Util.null2String(request.getParameter("formid"));
String feildname="";
String interceptedFieldName = "";
String para3=feildvalue+"+"+id+"+"+htmltype+"+"+type+"+"+user.getLanguage()+"+"+1+"+"+dbtype+"+"+0+"+"+modeid+"+"+formID+"+"+0;
if(!feildvalue.equals("")&&!feildvalue.equals("NULL")){
	feildname = FormModeTransMethod.getOthersSearchname(feildvalue,para3);
	interceptedFieldName = FormModeTransMethod.interceptHrefTitle(feildname);
}
String browsertype = type;
String buttonName="con"+id+"_value";
if (type.equals("0")) browsertype = "";
String completeUrl = "javascript:getajaxurl('"+browsertype+"','"+dbtype+"','"+id+"','1')";
String isbill="1";
String width="135px";
//=========================================================================================文本框
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
%>
		<input type=text class=InputStyle style="width:90%" name="con<%=id%>_value" value="<%=feildvalue%>">
<%
//=========================================================================================数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
}else if(htmltype.equals("1")&& !type.equals("1")){
	int qfws=0;
	rs.executeSql("select * from workflow_formdict where id = " + id);

    if(rs.next()){
    	qfws = Util.getIntValue(rs.getString("qfws"),2);
	 }
	 
    if(qfws==0){
	    rs.executeSql("select qfws from workflow_billfield where id="+id+" ");
	    if(rs.next()){
	    	qfws=Util.getIntValue(rs.getString("qfws"),2);
			if(qfws == -1){
				qfws = 2;
			}
	    }
    }
    String fielddbtype= dbtype;
    int decimaldigits_t = 0;
	if(type.equals("3")){
		int digitsIndex = fielddbtype.indexOf(",");
		if(digitsIndex > -1){
			decimaldigits_t = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
		}else{
			decimaldigits_t = 2;
		}
		//add by liaodong for qc75759 in 2013年10月23日 start
		feildvalue = Util.toDecimalDigits(feildvalue,decimaldigits_t);
		//end
	}
	if(type.equals("5")){
		decimaldigits_t = qfws;
	} 
	if(type.equals("2")){%>
		<input type=text class=InputStyle size=10 name="con<%=id%>_value"  onblur="checknumber('con<%=id%>_value');" 
			onKeyPress="ItemCount_KeyPress()" value="<%=feildvalue%>" style="width:90%;">			
	<%} else if(type.equals("3")){%>
		<input type=text class=InputStyle size=10 name="con<%=id%>_value"  onblur="checknumber('con<%=id%>_value');" 
			onKeyPress="ItemDecimal_KeyPress('con<%=id%>_value',15,<%=decimaldigits_t %>)" value="<%=feildvalue%>" style="width:90%;">
	<%} else if(type.equals("5")){%>
		<input type=text class=InputStyle size=10 name="con<%=id%>_value"  onblur="changeToThousands2('con<%=id%>_value',<%=decimaldigits_t %>);" 
			onKeyPress="ItemDecimal_KeyPress('con<%=id%>_value',15,<%=decimaldigits_t %>)"
			datavaluetype="5" datalength="<%=decimaldigits_t %>"
			value="<%=feildvalue%>" style="width:90%;">
	<%} else if(type.equals("4")){%>
		<input type=text class=InputStyle size=10 name="con<%=id%>_value"  onblur="checknumber('con<%=id%>_value');" 
			onKeyPress="ItemDecimal_KeyPress('con<%=id%>_value',15,<%=decimaldigits_t %>)"
			datavaluetype="4" datalength="<%=decimaldigits_t %>"
			value="<%=feildvalue%>" style="width:90%;">
	<%}
%>
<%
//=========================================================================================check类型
}
else if(htmltype.equals("4")){   
%>
<select name="con<%=id%>_value">
	<option <%out.print(feildvalue.equals("")?"selected":""); %>  value=""><%=SystemEnv.getHtmlLabelName(21381, user.getLanguage()) %></option>
	<option <%out.print(feildvalue.equals("1")?"selected":""); %> value="1"><%=SystemEnv.getHtmlLabelName(126151, user.getLanguage()) %></option>
	<option <%out.print(feildvalue.equals("0")?"selected":""); %> value="0"><%=SystemEnv.getHtmlLabelName(82676, user.getLanguage()) %></option>
</select>
<%
//=========================================================================================选择框	
}
else if(htmltype.equals("5")){  //
%>
<%
String selectchange = "";
%>
<select class=inputstyle  value=""  name="con<%=id%>_value" id="con<%=id%>_value"  >
<option value="" ></option>
<%
char flag=2;
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
	String tempcancel = rs.getString("cancel");
	if("1".equals(tempcancel)){
		continue;
	}
%>
<option value="<%=tmpselectvalue%>" <%out.print(feildvalue.equals(tmpselectvalue+"")?"selected":""); %> ><%=tmpselectname%></option>
<%} %>
</select>

<%
//=========================================================================================浏览框单人力资源  条件为多人力 (like not lik)
} else if(htmltype.equals("3") && type.equals("1")){////浏览框单人力资源 
//String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')";
String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_value" value="<%=interceptedFieldName %>">
<%
//=========================================================================================浏览框单文挡  条件为多文挡 (like not lik)
} else if(htmltype.equals("3") && type.equals("9")){//浏览框单文挡  
	//String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')";
	String browserUrl = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
//=========================================================================================
} else if(htmltype.equals("3") && type.equals("4")){//浏览框单部门 
	//String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp')";
	String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
	<%
	
//=========================================================================================
} else if(htmltype.equals("3") && type.equals("7")){//浏览框单客户 
	//String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')";
	String browserUrl = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("8")){//浏览框单项目
	//String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp')";
	String browserUrl = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
	
//=========================================================================================
} else if(htmltype.equals("3") && type.equals("16")){//浏览框单请求
	//String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp')";
	String browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
	
//=========================================================================================
}else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别
%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value" value="<%=feildvalue %>" >
<%
//=========================================================================================	
}//职位安全级别end

else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期
	String classStr = "";
	if(type.equals("2")){
		classStr = "calendar";
	}else {
		classStr = "Clock";
	}
%>
<button type=button  class="<%=classStr %>"
<%if(type.equals("2")){%>
 onclick="onSearchWFQTDate(con<%=id%>_valuespan,con<%=id%>_value,'')"
<%}else{%>
 onclick ="onSearchWFQTTime(con<%=id%>_valuespan,con<%=id%>_value,'')"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value" value="<%=feildvalue %>" >
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=feildvalue %></span>
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("17")){ //人力资源 多选框
	String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp')";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("37")){//浏览框 (多文挡)
	//String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?isworkflow=1')";
	String browserUrl = "/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?isworkflow=1";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("57")){//浏览框（多部门）
	//String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowser.jsp')";
	//String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowser.jsp";
	 String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByOrder.jsp";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("135")){//浏览框（多项目 ）
	//String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp')";
	String browserUrl = "/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("152")){//浏览框（多请求 ）
	//String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp')";
	String browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("18")){//浏览框  多选筐条件为单选筐
	//String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp')";
	String browserUrl = "/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
//=========================================================================================	
}
else if(htmltype.equals("3") && type.equals("160")){//浏览框  多选筐条件为单选筐
	//String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')";
	String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("142")){//浏览框多收发文单位
	String urls = "/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp";
    //String browserOnClick="onShowBrowser('"+id+"','"+urls+"')";
    String browserUrl = urls;
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
//=========================================================================================	
}
else if(htmltype.equals("3") && (type.equals("141")||type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137"))){//浏览框
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    //String browserOnClick="onShowBrowser('"+id+"','"+urls+"')";
    String browserUrl = urls;
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
//=========================================================================================	
}
else if(htmltype.equals("3") && id.equals("_5")){//工作流浏览框
String browserOnClick="onShowCQWorkFlow('con"+id+"_value','con"+id+"_valuespan')";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserOnClick="<%=browserOnClick%>"
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
//=========================================================================================	
} else if (htmltype.equals("3") && (type.equals("161") || type.equals("162"))){
	String urls=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype;     // 浏览按钮弹出页面的url
	String browserOnClick = "onShowBrowserCustomNew('"+id+"','"+urls+"','"+type+"')";
	String method2 = "setName('"+id+"')";
    String isSignle = "true";
    if (type.equals("162")) {
    	isSignle = "false";
    }
    Browser browser=(Browser)StaticObj.getServiceByFullname(dbtype, Browser.class);
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserOnClick="<%=browserOnClick %>" browserUrl="<%=urls%>"
	hasInput="true" isSingle="<%=isSignle%>" hasBrowser="true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
//=========================================================================================	
} else if (htmltype.equals("3") && (type.equals("256") || type.equals("257"))){
	String urls=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype+"_"+type;     // 濞村繗顫嶉幐澶愭尦瀵懓鍤い鐢告桨閻ㄥ増rl
	String isSingle = "";
    String browserOnClick="onShowBrowserCustomNew('"+id+"','"+urls+"','"+type+"')";
    if(type.equals("256")){
    	isSingle = "true";
    }else{
    	isSingle = "false";
    }
    feildname = feildname.replace("&nbsp", "&nbsp;&nbsp;");
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserOnClick="<%=browserOnClick %>"
	hasInput="false" isSingle="<%=isSingle%>" hasBrowser = "true" isMustInput='1' type="<%=type %>"
	completeUrl="<%=completeUrl%>" width="135" 
	browserSpanValue="<%=feildname%>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%} else if (htmltype.equals("3")){
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    String browserOnClick="onShowBrowser('"+id+"','"+urls+"')";
	String typeFlag = type.equals("194")?"false":"true";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserUrl='<%= urls %>'
	hasInput="true" isSingle="<%=typeFlag %>" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%
//=========================================================================================	
} else if (htmltype.equals("6")){   //附件上传同多文挡
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1')";
%>
<brow:browser viewType="0" name="<%=buttonName %>" browserValue="<%=feildvalue %>" 
	browserOnClick="<%=browserOnClick%>"
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="<%=width%>" 
	browserSpanValue="<%=feildname %>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=interceptedFieldName %>">
<%}%>