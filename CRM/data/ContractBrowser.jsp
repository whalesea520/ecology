<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String name = Util.null2String(request.getParameter("name"));
String typeId = Util.null2String(request.getParameter("typeId"));
String status = Util.null2String(request.getParameter("status"));
String sqlwhere = " 1=1 ";
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " and t1.name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and t1.name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!typeId.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " and t1.typeId = " + typeId;
	}
	else{
		sqlwhere += " and t1.typeId = " + typeId;
	}
}
if(!status.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " and t1.status = " + status;
	}
	else{
		sqlwhere += " and t1.status = " + status;
	}
}
if (sqlwhere.equals(" 1=1 ")) {
	sqlwhere += " and t1.id != 0" ;
}

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("6160",user.getLanguage()) %>'/>
</jsp:include>

<div class="zDialog_div_content">

<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

</DIV>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ContractBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">

<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item><input class=InputStyle type="text" name=name value='<%=name%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(6083,user.getLanguage())%></wea:item>
			<wea:item>
				<select class=InputStyle id=typeId name=typeId>
				 	 <option value="" <%if(typeId.equals("")){%> selected <%}%>> </option>
		          	<%while(ContractTypeComInfo.next()){ %>
		            <option value=<%=ContractTypeComInfo.getContractTypeid()%> <%if(typeId.equals(ContractTypeComInfo.getContractTypeid())){%> selected <%}%>><%=ContractTypeComInfo.getContractTypename()%></option>
		            <%}%>
				</select>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
			<wea:item>
				<select class="InputStyle" id="status" name="status">
				    <option value="" <%if(status.equals("")){%> selected <%}%> ></option>
				    <option value=0 <%if(status.equals("0")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></option>
				    <option value=1 <%if(status.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
				    <option value=2 <%if(status.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(6095,user.getLanguage())%></option>
					<option value=3 <%if(status.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></option>
				</select>	 
			</wea:item>
		</wea:group>
		
	</wea:layout>
<%

String fromSql = "";
if(logintype.equals("1")){
	String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
	fromSql = " CRM_Contract t1 , "+leftjointable+" t2 ";
	sqlwhere += " and t1.crmId = t2.relateditemid ";
}else{
	fromSql = " CRM_Contract t1 ,CRM_CustomerInfo t2 ";
	sqlwhere += " and t1.crmId = t2.id and t2.agent=" + userid;
}
String backfields = " t1.* ";
String orderby = "t1.id";
String tableString =" <table id='BrowseTable' instanceid='BrowseTable' tabletype='none' pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_Contract,user.getUID(),PageIdConst.CRM)+"\">"+ 
"<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+sqlwhere+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"/>"+
"<head>"+
"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" orderkey=\"id\" column=\"id\"/>"+ 
"<col width=\"45%\"  text=\""+ SystemEnv.getHtmlLabelName(195,user.getLanguage()) +"\" orderkey=\"name\" column=\"name\"/>"+ 
"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(6083,user.getLanguage()) +"\" orderkey=\"typeid\" column=\"typeid\""+ " transmethod=\"weaver.crm.Maint.ContractTypeComInfo.getContractTypename\"/>"+ 
"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" otherpara='"+user.getLanguage()+ "' transmethod=\"weaver.crm.Maint.CRMTransMethod.getContractStatus\"/>"+
"</head>"+   			
"</table>";
%>

<div id="e8resultArea">
	<wea:SplitPageTag tableString='<%=tableString%>' mode="run" />
</div>
</FORM>

</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick();">
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


function btnclear_onclick(){
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
</BODY>
</HTML>
