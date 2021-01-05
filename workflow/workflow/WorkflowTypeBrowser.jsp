
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,weaver.workflow.request.todo.RequestUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="requestUtil" class="weaver.workflow.request.todo.RequestUtil" scope="page" />
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css"/>
		<style type="text/css">
		  Table.BroswerStyle TR td {
		    border-bottom:1px solid #F3F2F2!important;
		  }
		  
		  Table.BroswerStyle TR.Selected td {
		    background:#f5fafb;
		    border-bottom:1px solid #F3F2F2!important;
		  }

		  .BroswerStyle {}
		</style>
		<script type="text/javascript">

			jQuery(document).ready(function(){
				jQuery("#BrowseTable").find("tr[class!='DataHeader']").hover(function () {
			        jQuery(this).addClass("Selected");
			    }, function () {
			        jQuery(this).removeClass("Selected");
			    });
			});
			
		</script>
	</head>
<%
String titlename = SystemEnv.getHtmlLabelNames("33251,18499", user.getLanguage());
String propertyOfApproveWorkFlow = Util.null2String(request.getParameter("propertyOfApproveWorkFlow"));//added by XWJ on 2005-03-16 for td:1549
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String fullname = Util.null2String(request.getParameter("fullname"));
String description = Util.null2String(request.getParameter("description"));
int typeid=Util.getIntValue(request.getParameter("typeid"),0);
String sqlwhere = " where (istemplate<>'1' or istemplate is null) and isvalid = '1' ";
String sqlwhereos = " where cancel=0 ";
if("htmllayoutchoose".equals(Util.null2String(request.getParameter("from")))){
	sqlwhere = " where 1=1 ";
	sqlwhereos = " where 1=2 " ;
}
if(!sqlwhere1.equals("")){
	sqlwhere += sqlwhere1;
}
if (typeid != 0) {
	sqlwhere += " and workflowtype='"+typeid+"' ";
	sqlwhereos += " and sysid="+typeid ;
}
if(!fullname.equals("")){
	sqlwhere += " and workflowname like '%"+Util.fromScreen2(fullname,user.getLanguage())+"%' ";
	sqlwhereos += " and workflowname like '%"+Util.fromScreen2(fullname,user.getLanguage())+"%' ";
}
if(!description.equals("")){
	sqlwhere += " and workflowdesc like '%"+Util.fromScreen2(description,user.getLanguage())+"%' ";
	sqlwhereos += " and 1=2 ";
}
if("contract".equals(propertyOfApproveWorkFlow)){
	sqlwhere += " and formid = 49 and isbill = 1";
	sqlwhereos += " and 1=2 ";
}
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
	<jsp:param name="mouldID" value="workflow" />
	<jsp:param name="navName" value="<%=titlename%>" />
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(309 ,user.getLanguage())+",javascript:doClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

String sqlstr = "" ;
String temptable = "wftemptable"+ Util.getNumberRandom() ;
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=30;

String temptable1="";
boolean isopenos = RequestUtil.isOpenOtherSystemToDo();
String showos = Util.null2String(request.getParameter("showos"));

if(RecordSet.getDBType().equals("oracle")){
    temptable1="( select * from (select * from workflow_base " + sqlwhere + "  order by id desc) where rownum<"+ (pagenum*perpage+2) +")  s";
	if(isopenos&&showos.equals("1")){
        temptable1="( select * from ( select * from (select id,workflowname,workflowdesc,workflowtype from workflow_base " + sqlwhere + "  union select workflowid as id ,workflowname, '' as workflowdesc,sysid as workflowtype from ofs_workflow "+sqlwhereos+") s order by id desc) where rownum<"+ (pagenum*perpage+2) +")  s";
    }
	
}else if(RecordSet.getDBType().equals("db2")){
    temptable1=" (select * from workflow_base " + sqlwhere + "order by id  desc fetch  first "+(pagenum*perpage+1)+" rows only ) as s" ;
    if(isopenos&&showos.equals("1")){
        temptable1=" (select * from (select id,workflowname,workflowdesc,workflowtype from workflow_base " + sqlwhere + "  union select workflowid as id ,workflowname, '' as workflowdesc , sysid as workflowtype from ofs_workflow "+sqlwhereos+") order by id  desc fetch  first "+(pagenum*perpage+1)+" rows only ) as s" ;
    }
}else{

    temptable1="( select top "+(pagenum*perpage+1)+" * from workflow_base  " + sqlwhere + " order by id desc ) as s" ;
	if(isopenos&&showos.equals("1")){
        temptable1="( select top "+(pagenum*perpage+1)+" * from (select id,workflowname,workflowdesc,workflowtype from workflow_base " + sqlwhere + "  union select workflowid as id ,workflowname, '' as workflowdesc,sysid as workflowtype from ofs_workflow "+sqlwhereos+") a order by id desc ) as s" ;
    }
}

//System.out.print("Select count(id) RecordSetCounts from "+temptable1);
RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable1);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}


if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}

String sqltemp="";

if(RecordSet.getDBType().equals("oracle")){
   
	sqltemp="select * from (select * from  "+temptable1+" order by id ) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
   
    sqltemp="select  * from "+temptable1+"  order by id fetch first "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only ";
}else{
    
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable1+"  order by id ";
}
%>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:onSubmit();"/>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<form id="weaver" name="SearchForm" style="margin-bottom:0" action="WorkflowTypeBrowser.jsp" method="post">
	<input type="hidden" name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
	<input type="hidden" name="pagenum" value=''>
	<input type="hidden" name="typeid" value='<%=typeid%>'>
	<input type="hidden" name="showos" value='<%=showos %>'>
	<%--added by XWJ on 2005-03-16 for td:1549--%>
	<input type="hidden" name="propertyOfApproveWorkFlow" value="<%=propertyOfApproveWorkFlow%>">

	<wea:layout type="fourCol" attributes="{'expandAllGroup':'true'}">
		<%
			String groupContext = SystemEnv.getHtmlLabelName(33806,user.getLanguage()) 
									+ ":" + WorkTypeComInfo.getWorkTypename(""+typeid);
		%>
		<wea:group context='<%=groupContext%>' attributes="{'class':'e8_title e8_title_1'}">
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<input class="Inputstyle" name="fullname" value="<%=fullname%>"/>
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<input class="Inputstyle"  name="description" value="<%=description%>"/>
			</wea:item>
		</wea:group>
	</wea:layout>

	<table class="BroswerStyle"  cellspacing="1" width="100%">
		<tr class="DataHeader">
			<th width="10%"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></th>
			<th width="40%"><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
			<%
                String showtype = requestUtil.getOfsSetting().getShowsysname();
            	if(!showtype.equals("0")&&showos.equals("1")){
             %>
            <th width="20%"><%=SystemEnv.getHtmlLabelName(22677,user.getLanguage())%></th>
            <%
                }
            %>
		</tr>
		<tr width="100%" class="Line">
	    	<th colspan="5" ></th>
	    </tr>          
	    <tr width="100%">
	     	<td width=100% colspan=5>
	       		<div style="overflow-y:scroll;width:100%;height:400px;">
					<table id="BrowseTable" class="ListStyle"  cellspacing="1" width="100%">
					<%
						RecordSet.execute(sqltemp);
						int totalline=1;
						if(RecordSet.last()){
							do{
					%>
						<tr>
							<td width="10%"><a href="#"><%=RecordSet.getString(1)%></a></td>
							<td width="40%"><%=RecordSet.getString(2)%></td>
							<td><%=RecordSet.getString(3)%></td>
							<%
                                if(!showtype.equals("0")&&showos.equals("1")){
                            %>
                            <td width="20%"><%=requestUtil.getSysname(RecordSet.getInt("workflowtype"),showtype) %></td>
                            <%
                                }
                            %>
						</tr>
					<%  
								if(hasNextPage){
									totalline+=1;
									if(totalline>perpage)	break;
								}
							}while(RecordSet.previous());
						}
					%>
					</table>
				</div>
			</td>
		</tr>
	</table>
					
	<%if(pagenum>1){%>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<button type=button  style="display:none" class=btn accessKey=P id=prepage onclick="document.all('pagenum').value=<%=pagenum-1%>;onSubmit();"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
	<%}%>
	<%if(hasNextPage){%>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<button type=button style="display:none" class=btn accessKey=N  id=nextpage onclick="document.all('pagenum').value=<%=pagenum+1%>;onSubmit();"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
	<%}%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
		    <wea:group context="">
		    	<wea:item type="toolbar">
		    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="dialog.closeByHand();" 
		    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
		    	</wea:item>
		    </wea:group>
		</wea:layout>
</div>
</body>
</html>

<script type="text/javascript">
//<!--
var parentWin;
var dialog;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class!='DataHeader']").bind("click",function(){
		selectData($(this).find("td:first").text(), $(this).find("td:first").next().text());
	})
	jQuery("#BrowseTable").find("tr[class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	})
	jQuery("#BrowseTable").find("tr[class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	})
});
function submitClear() {
	var returnValue = {id:"",name:""};
	if(dialog) {
	    try {
			dialog.callback(returnjson);
		} catch(e) {}

		try {
			dialog.close(returnjson);
		} catch(e) {}
	} else {  
	    window.parent.returnValue  = returnValue;
	    window.parent.close();
	}
}

function submitClear() {
	selectData('', '');
}

function doClose(){
	if(dialog){
		try {
			dialog.close();
		} catch(e) {}
	}else{
		window.parent.parent.close();
	}
}

function selectData(id, name) {
	var returnjson = {id: id,name: name};
	if(dialog){
		try {
			dialog.callback(returnjson);
		} catch(e) {}

		try {
			dialog.close(returnjson);
		} catch(e) {}
	}else{
		window.parent.parent.returnValue = returnjson;
		window.parent.parent.close();
	}
}
//-->
</script>

 <script language="javascript">
function submitData()
{btnok_onclick();
}

function onSubmit() {
	$G("SearchForm").submit()
}
function onReset() {
	$G("SearchForm").reset()
}
</script>
