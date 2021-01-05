<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.MeetingShareUtil"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" /> 
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type="text/css" HREF="/css/Weaver_wev8.css">
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
</HEAD>
<%
int from = Util.getIntValue(request.getParameter("from"), -1);
String callbkfun = Util.null2String(request.getParameter("callbkfun"));
int forall=Util.getIntValue(request.getParameter("forall"), 0);

String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String fullname = Util.null2String(request.getParameter("fullname"));
String description = Util.null2String(request.getParameter("description"));
String equipment = Util.null2String(request.getParameter("equipment"));
int SelectSubCompany = Util.getIntValue(request.getParameter("SelectSubCompany"), -1);
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}    else{
    ishead = 1;
    sqlwhere=" where 1=1 ";
}
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
String subcompanyid= Util.null2String(request.getParameter("subcompanyid"));
   // System.out.println("  subcompanyid:"+subcompanyid);
    //if("".equals(subcompanyid)){
    //    subcompanyid =     user.getUserSubCompany1()+"";
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
//int subCompany[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(), "MeetingRoomAdd:Add");
//String subCompanyString = "-1";
//for(int i = 0; i < subCompany.length; i++)
//{
//	subCompanyString += "," + subCompany[i];
//}
boolean hasRight = false;

    if (detachable==1 && SelectSubCompany > 0){
        if(ishead==0){
            ishead=1;
            //sqlwhere=" a.subcompanyid in("+subcompanyid+",0) ";
            sqlwhere+=" a.subcompanyid = "+ SelectSubCompany;
        }else{
            //sqlwhere+=" and a.subcompanyid in("+subcompanyid+",0) ";
            sqlwhere+=" and a.subcompanyid = "+ SelectSubCompany;
        }
    }

if(!fullname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += "  a.name like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and a.name like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += "  a.roomdesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and a.roomdesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!equipment.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += "  a.equipment like '%";
		sqlwhere += Util.fromScreen2(equipment,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and a.equipment like '%";
		sqlwhere += Util.fromScreen2(equipment,user.getLanguage());
		sqlwhere += "%'";
	}
}

if(forall != 1){
	sqlwhere += MeetingShareUtil.getRoomShareSql(user);
	sqlwhere += " and (a.status=1 or a.status is null )";
}
//RecordSet.writeLog(sqlwhere);
String unionSql = "select  a.id,a.name,a.subcompanyid,a.roomdesc from MeetingRoom a "+sqlwhere+" order by a.id";

   /* String unionSql = "select  a.id,a.name,a.subcompanyid,a.roomdesc from MeetingRoom a,MeetingRoom_share b "+sqlwhere+" and a.id = b.mid and ((b.departmentid="+
            user.getUserDepartment()+" and b.deptlevel<="+user.getSeclevel()+" and b.deptlevelMax>="+user.getSeclevel()+") or(b.subcompanyid in ("+user.getUserSubCompany1()+","+user.getUserSubCompany2()+","+
            user.getUserSubCompany3()+","+user.getUserSubCompany4()+") and b.sublevel<="+user.getSeclevel()+" and b.sublevelMax>="+user.getSeclevel()+")or" +
            "(b.seclevel<="+user.getSeclevel()+" and b.seclevelMax>="+user.getSeclevel()+")or(b.userid ="+user.getUID()+"))  order by a.id"; */
     //out.println("unionsql:"+unionSql);
%>
<BODY>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(780,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
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

<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="MeetingRoomBrowserChld.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
<input type="hidden" name="isfrist" value='1'>
<input type="hidden" name="from" id="from" value='<%=from%>'>
<input type="hidden" name="forall" id="forall" value='<%=forall%>'>
<input type="hidden" name="callbkfun" id="callbkfun" value='<%=callbkfun%>'>

<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<input class=inputstyle type="text" name=fullname value="<%=fullname%>">
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<input class=inputstyle type="text" name=description value="<%=description%>">
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(1326,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<input class=inputstyle type="text" name=equipment value="<%=equipment%>">
		</wea:item>
		<%if(detachable==1){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="SelectSubCompany" browserValue='<%=""+SelectSubCompany%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids=" 
				hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="150px"
				completeUrl="/data.jsp?type=164&show_virtual_org=-1" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
				browserSpanValue='<%=""+SubCompanyComInfo.getSubCompanyname(""+SelectSubCompany)%>'></brow:browser>
			</wea:item>
		<%}%>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%>' attributes="{'groupDisplay':'none'}" >
		<wea:item attributes="{'isTableList':'true'}">
			<!--列表部分-->
				<%
					//得到pageNum 与 perpage
					int perpage=9;
					//设置好搜索条件
					String backFields =" a.id,a.name,a.subcompanyid,a.roomdesc,a.equipment ";
					String fromSql = " MeetingRoom a ";

					String orderBy = "a.dsporder,a.name";
					String linkstr = "";
					linkstr = "";
					String tableString=""+
								"<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
								"<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" />"+
								"<head>"+
									"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"id\" orderkey=\"a.id\" hide=\"true\" />"+
									"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(399,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" />"+
									"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(1326, user.getLanguage())+"\" column=\"equipment\" orderkey=\"equipment\"  />";
									if(detachable==1){tableString +="<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingSubCompany\"/>";}
					  tableString +="<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"roomdesc\"  orderkey=\"roomdesc \" />"+
								"</head>"+
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
					class="zd_btn_cancle" onclick="submitClear()">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>"
					class="zd_btn_cancle" onclick="closeDlg()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
var parentWin = parent.parent.parent.getParentWindow(parent.parent);
var dialog = parent.parent.parent.getDialog(parent.parent);

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

