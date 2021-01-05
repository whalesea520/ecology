
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
int resource=Util.getIntValue(request.getParameter("viewer"),0);
String resourcename=ResourceComInfo.getResourcename(resource+"");

String subject=Util.fromScreen(request.getParameter("subject"),user.getLanguage());
String customer=Util.fromScreen(request.getParameter("customer"),user.getLanguage());
String sellstatusid=Util.fromScreen(request.getParameter("sellstatusid"),user.getLanguage());
String preyield=Util.null2String(request.getParameter("preyield"));
String preyield_1=Util.null2String(request.getParameter("preyield_1"));
String endtatusid=Util.fromScreen(request.getParameter("endtatusid"),user.getLanguage());

String sqlwhere = " where t1.id != 0 " ;
if(resource!=0){
    sqlwhere+=" and t1.creater = "+resource;
}
if(!subject.equals("")){
	sqlwhere+=" and t1.subject like "+"'%"+subject+"%'";
}

if(!customer.equals("")){
	sqlwhere+=" and t1.customerid="+customer;
}

if(!sellstatusid.equals("") && !sellstatusid.equals("-1")){
    sqlwhere+=" and t1.sellstatusid="+sellstatusid;
}

if(!preyield.equals("")){
	sqlwhere+=" and t1.preyield>="+preyield;
}

if(!preyield_1.equals("")){
	sqlwhere+=" and t1.preyield<="+preyield_1;
}

if(!endtatusid.equals("")&& !endtatusid.equals("-1")){
	sqlwhere+=" and t1.endtatusid ="+endtatusid;
}

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

String temptable = "temptable";
String orderby = "t1.predate";
String backfields = "t1.id,t1.subject,t1.preyield,t1.createdate,t1.sellstatusid,t1.endtatusid,t1.customerid,t1.predate";
String fromSql = "";
if(user.getLogintype().equals("1")){
	fromSql = "CRM_SellChance  t1,"+leftjointable+" t2,CRM_CustomerInfo t3  ";
	sqlwhere += "  and t3.deleted=0  and t3.id= t1.customerid and t1.customerid = t2.relateditemid";
}else{
	fromSql = "CRM_SellChance t1,CRM_CustomerInfo t3";
	sqlwhere += "and t3.deleted=0 and t3.id= t1.customerid  and t1.customerid="+user.getUID();
}

int pagesize = 10;

String tableString =" <table instanceid='BrowseTable' tabletype='none' pagesize=\""+pagesize+"\">"+ 
"<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+sqlwhere+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"/>"+
"<head>"+
"<col hide=\"true\" width=\"5%\" text=\"\" column=\"id\"/>"+ 
"<col width=\"45%\"  text=\""+ SystemEnv.getHtmlLabelName(344,user.getLanguage()) +"\" orderkey=\"subject\" column=\"subject\"/>"+ 
"<col width=\"45%\"  text=\""+ SystemEnv.getHtmlLabelName(2248,user.getLanguage()) +"\" orderkey=\"preyield\" column=\"preyield\"/>"+ 
"<col width=\"45%\"  text=\""+ SystemEnv.getHtmlLabelName(1339,user.getLanguage()) +"\" orderkey=\"createdate\" column=\"createdate\"/>"+ 
"<col width=\"45%\"  text=\""+ SystemEnv.getHtmlLabelName(2250,user.getLanguage()) +"\" orderkey=\"sellstatusid\" column=\"sellstatusid\""+
	" transmethod=\"weaver.crm.report.CRMContractTransMethod.getCRMSellStatus\"/>"+ 
"<col width=\"45%\"  text=\""+ SystemEnv.getHtmlLabelName(15112,user.getLanguage()) +"\" orderkey=\"endtatusid\" column=\"endtatusid\""+
	" transmethod=\"weaver.crm.report.CRMContractTransMethod.getPigeonholeStatus\" otherpara=\""+user.getLanguage()+"\"/>"+ 
"<col width=\"45%\"  text=\""+ SystemEnv.getHtmlLabelName(136,user.getLanguage()) +"\" orderkey=\"customerid\" column=\"customerid\""+
	" transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\"/>"+ 
"</head>"+   			
"</table>";

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
%>

<div class="zDialog_div_content">
<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="SellChanceBrowser.jsp" method=post>

<DIV align=right style="display:none">
	<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

<input type="hidden" name="sqlwhere" value="<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>">
<input type="hidden" name="pagenum" value="">
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' >
		<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
		<wea:item><INPUT class=InputStyle size=18 id="subject" name="subject" value='<%=subject%>' style="width: 76%"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%>  </wea:item>
		<wea:item>
			<INPUT  text style="width: 52px;" class=InputStyle maxLength=20 size=6 id="preyield" name="preyield"    onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield");comparenumber()' value="<%=preyield%>">
			-- <INPUT text style="width: 52px;" class=InputStyle maxLength=20 size=6 id="preyield_1" name="preyield_1"   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1");comparenumber()' value="<%=preyield_1%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="customer" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
				browserValue='<%=customer%>' 
				browserSpanValue = '<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customer),user.getLanguage())%>'
				isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				completeUrl="/data.jsp?type=7" width="95%" ></brow:browser>
		</wea:item>
		<%if(!user.getLogintype().equals("2")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="viewer" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				browserValue='<%=resource+""%>' 
				browserSpanValue = '<%=Util.toScreen(resourcename,user.getLanguage())%>'
				isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				completeUrl="/data.jsp" width="95%" ></brow:browser>
			</wea:item>
		<%}%>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%> </wea:item>
		<wea:item>
			<select id=sellstatusid name=sellstatusid style="width: 65%">
			  <option value=-1 <%if(endtatusid.equals("-1")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%> </option>
			<%  
			String theid="";
			String thename="";
			String sql="select * from CRM_SellStatus ";
			RecordSet3.executeSql(sql);
			while(RecordSet3.next()){
			    theid = RecordSet3.getString("id");
			    thename = RecordSet3.getString("fullname");
			    if(!thename.equals("")){
			    %>
			<option value=<%=theid%>  <%if(sellstatusid.equals(theid)){%> selected<%}%> ><%=thename%></option>
			<%}
			}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></wea:item>
		<wea:item>
			<select  id=endtatusid  name=endtatusid style="width: 65%">
				<option value=-1 <%if(endtatusid.equals("-1")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%> </option>
				<option value=1 <%if(endtatusid.equals("1")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%> </option>
				<option value=2 <%if(endtatusid.equals("2")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%> </option>
				<option value=0 <%if(endtatusid.equals("0")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%> </option>
			</select>
		</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<wea:SplitPageTag tableString='<%=tableString%>'   mode="run" isShowTopInfo="false" />
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>


<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitClear()">
		    	<input type="button" accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">

var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}

jQuery(function(){
	
	jQuery(".ListStyle").find("tbody tr").live('click',function(){
		var id = jQuery.trim(jQuery(this).find("td:eq(1)").html());
		var name = jQuery.trim(jQuery(this).find("td:eq(2)").html());
		
		var returnValue = {id:id,name:name};
		if(dialog){
			try{
	            dialog.callback(returnValue);
	      	}catch(e){}
	      	 
		  	try{
		       dialog.close(returnValue);
		   }catch(e){}
		}else{
     		window.parent.parent.returnValue = returnValue;
	 		window.parent.parent.close();
		}
		
	});
});


function submitClear()
{
	var returnValue = {id:"",name:""};
	if(dialog){
		try{
            dialog.callback(returnValue);
       }catch(e){}
	  	try{
	       dialog.close(returnValue);
	   }catch(e){}
	}else{
		window.parent.returnValue = returnValue;
		window.parent.close();
	}
	
}


</script>
</BODY></HTML>
