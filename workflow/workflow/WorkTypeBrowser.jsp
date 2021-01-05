
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,weaver.workflow.request.todo.RequestUtil" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="requestutil" class="weaver.workflow.request.todo.RequestUtil" scope="page" />
<html>
	<head>
	<link rel="stylesheet" type="text/css" HREF="/css/Weaver_wev8.css"/>
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
String titlename = SystemEnv.getHtmlLabelNames("33251,33806", user.getLanguage());
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String fullname = Util.null2String(request.getParameter("fullname"));
String description = Util.null2String(request.getParameter("description"));
boolean isopenos = RequestUtil.isOpenOtherSystemToDo();
String showos = Util.null2String(request.getParameter("showos"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!fullname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where typename like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and typename like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where typedesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and typedesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
}
%>
<BODY>
<!-- start -->
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

RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:doClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

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
<form name="SearchForm" STYLE="margin-bottom:0" action="WorkTypeBrowser.jsp" method="post">
	<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>"/>
	<input type=hidden name=showos value="<%=showos %>"/>
	<wea:layout type="fourCol" attributes="{'expandAllGroup':'true'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<input class=Inputstyle name=fullname value="<%=fullname%>"/>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<input  class=Inputstyle name=description value="<%=description%>"/>
		</wea:item>
		</wea:group>
	</wea:layout>
	<table width="100%" class="BroswerStyle"  cellspacing="0" style="margin-top:0">
	    <tr class="DataHeader">
			<th width=10%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></th>
			<th width=40%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
			<%
                String showsysname = requestutil.getOfsSetting().getShowsysname();
                if(!showsysname.equals("0")&&showos.equals("1")){
            %>
            <th width=20%><%=SystemEnv.getHtmlLabelName(22677,user.getLanguage())%></th>
            <%
                }
            %>
		</tr>
	    <tr width=100% class="Line">
	    	<th colspan="5" ></th>
	    </tr>          
	    <tr width=100%>
	     	<td width=100% colspan=5>
	       		<div style="overflow-y:scroll;width:100%;height:400px;">
					<table id="BrowseTable" class="ListStyle"  cellspacing="1" width="100%">
						<%
						if(!showos.equals("1")){
                            sqlwhere = "select * from workflow_type "+sqlwhere+" order by id";
                        }else{
                            if(!isopenos){
                                sqlwhere = "select * from workflow_type "+sqlwhere+" order by id";
                            }else{
                                sqlwhere = "select * from ( select id,typename,typedesc,dsporder from workflow_type "+sqlwhere+"  union (select * from (select sysid as id ,sysshortname as typename,sysfullname as typdesc, 9999 as dsporder from ofs_sysinfo where cancel=0 ) a "+sqlwhere+") ) a order by dsporder " ;
                            }
						}
						RecordSet.execute(sqlwhere);
						while(RecordSet.next()){
						%>
						<tr>
							<td width=10%><a HREF=#><%=RecordSet.getString(1)%></a></td>
							<td width=40%><%=RecordSet.getString(2)%></td>
							<td><%=RecordSet.getString(3)%></td>
							<%
                                if(!showsysname.equals("0")&&showos.equals("1")){
                            %>
                            <td width=20%><%=requestutil.getSysname(RecordSet.getInt("id"),showsysname) %></td>
                            <%
                                }
                            %>
						</tr>
						<%}%>
					</table>
				</div>
			</td>
		</tr>
	</table>
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
<script tyep="text/javascript">
var parentWin;
var dialog;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class!='DataHeader']").bind("click",function(){
		selectData($(this).find("td:first").text(), $(this).find("td:first").next().text());
	})

	jQuery("#BrowseTable").find("tr[class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	})

	jQuery("#BrowseTable").find("tr[class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	})
		
})

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
</script>

<script language="javascript">
function submitData()
{
	btnok_onclick();
}

function onSubmit() {
		$G("SearchForm").submit()
	}
	function onReset() {
		$G("SearchForm").reset()
	}
</script>
