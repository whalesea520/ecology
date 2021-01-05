<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String lastname = Util.null2String(request.getParameter("lastname"));
String firstname = Util.null2String(request.getParameter("firstname"));
String customer = Util.null2String(request.getParameter("customer"));
String customerid = Util.null2String(request.getParameter("customerid"));
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
String sqlwhere = " where 1=1 ";

if(!customerid.equals("")){
	sqlwhere += " and customerid =" + customerid;
}
if(!lastname.equals("")){
	sqlwhere += " and lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
}
if(!firstname.equals("")){
	sqlwhere += " and firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
}
if(!customer.equals("")){
	sqlwhere += " and name like '%" + Util.fromScreen2(customer,user.getLanguage()) +"%' ";
}

String backfields = "t1.id,t1.firstname,t1.jobtitle,t1.customerid,t2.name";
int pagesize = 10;
String fromSql = "CRM_CustomerContacter t1 left join CRM_CustomerInfo t2 on t1.customerid = t2.id "+
				" left join "+leftjointable+" t3 on t1.customerid = t3.relateditemid ";
sqlwhere +=" and t1.customerid = t2.id and t1.customerid = t3.relateditemid ";
String orderby = "t1.fullname";
// System.err.println("select "+backfields+" from "+fromSql+" where "+sqlwhere);
String tableString =" <table instanceid='BrowseTable' tabletype='none' pagesize=\""+pagesize+"\">"+ 
"<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+sqlwhere+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"/>"+
"<head>"+
"<col hide=\"true\" width=\"5%\" text=\"\" column=\"id\"/>"+ 
"<col width=\"35%\"  text=\""+ SystemEnv.getHtmlLabelName(460,user.getLanguage()) +"\" orderkey=\"firstname\" column=\"firstname\"/>"+ 
"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(6086,user.getLanguage()) +"\" orderkey=\"jobtitle\" column=\"jobtitle\"/>"+ 
"<col width=\"35%\"  text=\""+ SystemEnv.getHtmlLabelName(136,user.getLanguage()) +"\" orderkey=\"name\" column=\"name\"/>"+ 

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

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close()(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
 <jsp:include page="/systeminfo/commonTabHead.jsp">
    <jsp:param name="mouldID" value="customer"/>
    <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("136,572",user.getLanguage()) %>'/>
 </jsp:include>
 
<DIV align=right style="display:none">
	<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>


<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ContactBrowser.jsp" method=post>
<input type="hidden" name="customerid" value="<%=customerid%>">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' >
		<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle  name=firstname value="<%=firstname%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></wea:item>
		<wea:item><input  class=InputStyle name=lastname value='<%=lastname%>'></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle  size=30 name=customer value="<%=customer%>">
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
	
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item></wea:item>
  	</wea:group>
</wea:layout>
</FORM>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitClear()">
		    	<input type="button" accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
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

jQuery(document).ready(function(){
	
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
})


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


