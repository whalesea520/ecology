<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String querystr=request.getQueryString();
if(true){
	response.sendRedirect("/proj/data/MultiProjectBrowser.jsp?browtype=single&"+querystr);
	return;
}

%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}
</script>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String name = Util.null2String(request.getParameter("name"));
String description = Util.null2String(request.getParameter("description"));
String prjtype = Util.null2String(request.getParameter("prjtype"));
String worktype = Util.null2String(request.getParameter("worktype"));
String manager = Util.null2String(request.getParameter("manager"));
String status = Util.null2String(request.getParameter("status"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.description like '%" + Util.fromScreen2(description,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and t1.description like '%" + Util.fromScreen2(description,user.getLanguage()) +"%' ";
}
if(!prjtype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.prjtype = "+ prjtype ;
	}
	else
		sqlwhere += " and t1.prjtype = "+ prjtype;
}
if(!worktype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.worktype = "+ worktype ;
	}
	else
		sqlwhere += " and t1.worktype = "+ worktype ;
}
if(!manager.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.manager = "+ manager ;
	}
	else
		sqlwhere += " and t1.manager = "+ manager;
}
if(!status.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.status =" + status +" " ;
	}
	else
		sqlwhere += " and t1.status =" + status +" " ;
}
//String sqlstr = "select id,name,description,prjtype,worktype,manager,status from Prj_ProjectInfo " + sqlwhere;

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
if(pagenum <= 0){
	pagenum = 1;
}

//*添加判断权限的内容--new--begin

String SqlWhere = "";

if(!sqlwhere.equals("")){
	SqlWhere = sqlwhere +" and ("+CommonShareManager.getPrjShareWhereByUser(user)+") ";
}else{
	SqlWhere = " where ("+CommonShareManager.getPrjShareWhereByUser(user)+") ";
}

 


//添加判断权限的内容--new--end*/


%>
<BODY style="overflow:hidden;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("101",user.getLanguage()) %>'/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenuHeight += RCMenuHeightStep ; //取消右键按钮 看不到按钮，只能查看3个！

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

/**
if(pagenum>1){ RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:perPage(),_self} " ;
RCMenuHeight += RCMenuHeightStep; };
if(hasNextPage) { RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:nextPage(),_self} " ;
RCMenuHeight += RCMenuHeightStep;} ;**/

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>" class="e8_btn_top"  onclick="submitData()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ProjectBrowser.jsp" method=post>
  <input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input type="hidden" id="pagenum" name="pagenum" value="<%=pagenum%>">
<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'  attributes="{'groupSHBtnDisplay':'none'}" >
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><input name=name value='<%=name%>' class="InputStyle"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></wea:item>
		<wea:item>
			<select  class=InputStyle id=status name=status>
			<option value=""></option>
			<% while(ProjectStatusComInfo.next()) {  
				String tmpstatus = ProjectStatusComInfo.getProjectStatusid() ;
			%>
	          <option value=<%=tmpstatus%> <% if(tmpstatus.equals(status)) {%>selected<%}%>>
			  <%=Util.toScreen(SystemEnv.getHtmlLabelName(Util.getIntValue(ProjectStatusComInfo.getProjectStatusname()),user.getLanguage()),user.getLanguage())%></option>
			<% } %>
	        </select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></wea:item>
		<wea:item>
			<select  class=InputStyle id=prjtype name=prjtype>
	        <option value=""></option>
	       	<%
	       	while(ProjectTypeComInfo.next()){
	       	%>		  
	          <option value="<%=ProjectTypeComInfo.getProjectTypeid()%>" <%if(prjtype.equalsIgnoreCase(ProjectTypeComInfo.getProjectTypeid())) {%>selected<%}%>><%=ProjectTypeComInfo.getProjectTypename()%></option>
	            <%}%>
	        </select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></wea:item>
		<wea:item>
			<select  class=InputStyle id=worktype name=worktype>
	        <option value=""></option>
	       	<%
	       	while(WorkTypeComInfo.next()){
	       	%>		  
	          <option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%if(worktype.equalsIgnoreCase(WorkTypeComInfo.getWorkTypeid())) {%>selected<%}%>><%=WorkTypeComInfo.getWorkTypename()%></option>
	            <%}%>
	        </select>
		</wea:item>
<%
if(!user.getLogintype().equals("2")){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="manager" 
					browserValue='<%=manager %>' browserSpanValue='<%=ResourceComInfo.getLastname(manager) %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" />
		</wea:item>
	<%
}

%>		

	</wea:group>
</wea:layout>
</div>

<%
String orderby =" id ";
String tableString = "";
int perpage=7;
String backfields = " t1.id,t1.name,t1.prjtype,t1.worktype,t1.manager,t1.status";
String fromSql  = " Prj_ProjectInfo  t1 ";

tableString =   " <table instanceid=\"BrowseTable\" id=\"BrowseTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"0%\" hide=\"true\"  text=\""+"ID"+"\" column=\"id\"    />"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("195",user.getLanguage())+"\" column=\"name\" orderkey=\"name\"   />"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("586",user.getLanguage())+"\" column=\"prjtype\" orderkey=\"prjtype\" transmethod='weaver.proj.Maint.ProjectTypeComInfo.getProjectTypename' />"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("432",user.getLanguage())+"\" column=\"worktype\" orderkey=\"worktype\" transmethod='weaver.proj.Maint.WorkTypeComInfo.getWorkTypename'  />"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("144",user.getLanguage())+"\" column=\"manager\" orderkey=\"manager\" transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename'  />"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("587",user.getLanguage())+"\" column=\"status\" orderkey=\"status\" transmethod='weaver.proj.Maint.ProjectStatusComInfo.getProjectStatusdesc'  />"+
                "       </head>"+
                " </table>";
%>

<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />


</FORM>


<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="btnclear_onclick();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>

</BODY></HTML>


<script language="javascript">
function btnclear_onclick(){
	if(dialog){
		var returnjson={id:"",name:""};
		try{
            dialog.callback(returnjson);
       }catch(e){}
	  	try{
	       dialog.close(returnjson);
	   }catch(e){}
	}else{
		window.parent.returnValue = {id:"",name:""};
		window.parent.close();
	}
}
function submitData()
{
	if (check_form(SearchForm,'')){
		document.getElementById("pagenum").value = "1";
		SearchForm.submit();
	}
}

function submitClear()
{
	btnclear_onclick();
}

function nextPage(){
	document.getElementById("pagenum").value=parseInt(document.getElementById("pagenum").value)+1 ;
	SearchForm.submit();	
}

function perPage(){
	document.getElementById("pagenum").value=parseInt(document.getElementById("pagenum").value)-1 ;
	SearchForm.submit();
}



jQuery(document).ready(function(){
	$("#_xTable").find("table.ListStyle").live('click',BrowseTable_onclick);
})
function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
	   
	   if(dialog){
			var returnjson={id:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()};
			try{
	            dialog.callback(returnjson);
	       }catch(e){}
		  	try{
		       dialog.close(returnjson);
		   }catch(e){}
		}else{
     		window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()};
	 		window.parent.parent.close();
		}
	}
}
</script>
