<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.MeetingShareUtil"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" /> 
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
</HEAD>
<%
String titlename ="";
int from = Util.getIntValue(request.getParameter("from"), -1);
String callbkfun = Util.null2String(request.getParameter("callbkfun"));
int forall=Util.getIntValue(request.getParameter("forall"), 0);
String isInterval=Util.null2String(request.getParameter("isInterval"));

String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String fullname = Util.null2String(request.getParameter("fullname"));
String description = Util.null2String(request.getParameter("description"));
String approver = Util.null2String(request.getParameter("approver"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
} else{
    ishead = 1;
    sqlwhere=" where 1=1 ";
}
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
String subcompanyid= Util.null2String(request.getParameter("subcompanyid"));
    //if("".equals(subcompanyid)){
    //    subcompanyid = user.getUserSubCompany1()+"";
    //}
int isfrist=Util.getIntValue(request.getParameter("isfrist"),0);
boolean isUseMtiManageDetach=ManageDetachComInfo.isUseMtiManageDetach();
int detachable=0;
if(isUseMtiManageDetach){
	detachable=1;
   session.setAttribute("detachable","1");
   session.setAttribute("meetingdetachable","1");
}else{
	detachable=0;
   session.setAttribute("detachable","0");
   session.setAttribute("meetingdetachable","0");
}
    String sqlwhereTemp = "";
    
//int subCompany[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "MeetingType:Maintenance");
//String subCompanyString = "-1";
//for(int i = 0; i < subCompany.length; i++)
//{
//	subCompanyString += "," + subCompany[i];
//}
boolean hasRight = false;
	if (detachable==1 && !"".equals(subcompanyid)){
        if(ishead==0){
            ishead=1;
            sqlwhere=" a.subcompanyid in("+ subcompanyid+",0) ";
        }else{
            sqlwhere+=" and a.subcompanyid in("+subcompanyid+",0) ";
        }
    }
if(!fullname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " a.name like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and a.name like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
    sqlwhereTemp += " and a.name like '%";
    sqlwhereTemp += Util.fromScreen2(fullname,user.getLanguage());
    sqlwhereTemp += "%'";
}
approver="";
if( null != approver && !"".equals(approver)){
    if(sqlwhere.indexOf("where")>-1){
        sqlwhere += " and (a.approver = "+approver+" or a.approver1 ="+approver+") ";
    }else{
        sqlwhere += " where (a.approver = "+approver+" or a.approver1 ="+approver+") ";
    }
}

if(forall != 1){
	sqlwhere += MeetingShareUtil.getTypeShareSql(user);
}

String unionSql = "select a.id,a.name,a.subcompanyid,a.desc_n,a.approver from Meeting_Type a "+sqlwhere+" order by a.id";

   /* String unionSql = "select distinct a.id,a.name,a.subcompanyid,a.desc_n,a.approver from Meeting_Type a,MeetingType_share b "+sqlwhere+" and  a.id = b.mtid and ((b.departmentid="+
            user.getUserDepartment()+" and b.deptlevel<="+user.getSeclevel()+" and b.deptlevelMax>="+user.getSeclevel()+") or(b.subcompanyid in ("+
            user.getUserSubCompany1()+","+user.getUserSubCompany2()+","+user.getUserSubCompany3()+","+user.getUserSubCompany4()+") and b.sublevel<="+
            user.getSeclevel()+" and b.sublevelMax>="+user.getSeclevel()+")or(b.seclevel<="+user.getSeclevel()+"  and b.seclevelMax>="+user.getSeclevel()+")or(b.userid ="+user.getUID()+")) order by a.id"; */
    //String sql  = "select id,name,subcompanyid,desc_n,approver  from Meeting_Type "+sqlwhere +" union "+unionSql + " order by id";
    //System.out.println("uniontypesql:"+unionSql);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:resetCd(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:closeDlg(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_top middle" onclick="javascript:document.SearchForm.submit();"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span><%=SystemEnv.getHtmlLabelName(780,user.getLanguage()) %></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
<div class="zDialog_div_content">
<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="MeetingTypeBrowserChld.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
<input class=inputstyle type=hidden name=approver value="<%=approver%>">
<input type="hidden" name="isfrist" value='1'>
<input type="hidden" name="from" id="from" value='<%=from%>'>
<input type="hidden" name="forall" id="forall" value="<%=forall%>">
<input type="hidden" name="callbkfun" id="callbkfun" value='<%=callbkfun%>'>
<input type="hidden" name="isInterval" id="isInterval" value='<%=isInterval%>'>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<input class=inputstyle type="text" name=fullname value="<%=fullname%>">
		</wea:item>
	<%if(detachable==1){%>
      <wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
      <wea:item>
			<brow:browser viewType="0" name="subcompanyid" browserValue='<%=""+subcompanyid%>' 
			browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids=" 
			hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="150px"
			completeUrl="/data.jsp?type=164&show_virtual_org=-1" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
			browserSpanValue='<%=""+SubCompanyComInfo.getSubCompanyname(subcompanyid)%>'></brow:browser>
      </wea:item>
    <%}%>
    </wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<%
					//得到pageNum 与 perpage
					int perpage=10;
					//设置好搜索条件
					String backFields =" a.id,a.name,a.subcompanyid,a.desc_n,a.approver,a.approver1 ";
					String fromSql = " Meeting_Type a ";

					String orderBy = " a.dsporder,a.name ";
					String linkstr = "";
					linkstr = "";
					String tableString=""+
								"<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
								"<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" />"+
								"<head>"+
									"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"id\" orderkey=\"a.id\" hide=\"true\" />"+
									"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(2104,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" />";
									if(detachable==1){tableString +="<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingSubCompany\"/>";}
								  if("0".equals(isInterval)){ //普通会议流程
									  tableString +="<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(15057,user.getLanguage())+"\" column=\"approver\"  orderkey=\"approver \" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
								  }else if("1".equals(isInterval)){//周期会议流程
									  tableString +="<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(82441,user.getLanguage())+"\" column=\"approver1\"  orderkey=\"approver1 \" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
								  }
					  tableString +="</head>"+
								"</table>";
				%>
				<wea:SplitPageTag isShowTopInfo="true" tableString='<%=tableString%>'  mode="run"/>
			
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%>"
					class="zd_btn_cancle" onclick="javascript:submitClear()">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>"
					class="zd_btn_cancle" onclick="javascript:closeDlg()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>

<script type="text/javascript">
var parentWin ;
var dialog;
try{
	parentWin = parent.parent.parent.getParentWindow(parent.parent);
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(e){}

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#_xTable div.table").find("tr[class!='HeaderForXtalbe']").live("click",function(){
		 var id0  = $(this).find("td:first").next().next().text();
	     id0 = id0.replace("<","&lt;")
	     id0 = id0.replace(">","&gt;")
			var returnjson = {id:$(this).find("td:first").next().text(),name:id0};
			returnValue(returnjson);
	});

});


function submitClear()
{
	var returnjson = {id:"",name:""};
	returnValue(returnjson);
}

function returnValue(returnjson){
	if(1 == <%=from%>){
	    <%if(!"".equals(callbkfun)){%>
			<%="parentWin."+callbkfun+"(returnjson);"%>
		<%}%>
		
	} else {
		if(dialog){
			try{
				  dialog.callback(returnjson);
			 }catch(e){}

			try{
				 dialog.close(returnjson);
			 }catch(e){}
		}else{ 
			window.parent.parent.returnValue  = returnjson;
			window.parent.parent.close();
		}
	}
}

function closeDlg(){
	if(1 == <%=from%>){
		parentWin.closeBrwDlg();
	} else {
		if(dialog){
			dialog.close();
		}else{ 
			window.parent.parent.close();
		}
	}
	
}

function resetCd(){
	resetCondtionBrw('SearchForm');
}
</script>
</BODY></HTML>


