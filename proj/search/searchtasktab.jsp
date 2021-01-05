
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>

</head>
<%
String nameQuery = Util.null2String(request.getParameter("nameQuery"));
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav ="1";
String needhelp ="";

String sqlwhere="";

String taskname = Util.null2String(request.getParameter("taskname"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String resourcespan = ResourceComInfo.getResourcename(resourceid);
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
String fromdate2 = Util.null2String(request.getParameter("fromdate2"));
String todate2 = Util.null2String(request.getParameter("todate2"));
int taskstatus = Util.getIntValue(Util.null2String(request.getParameter("taskstatus")),0);
//add by chengfeng.han 2011-7-18 td 27219
sqlwhere += " and t3.usertype="+user.getLogintype()+" and t3.userid="+user.getUID() + " ";
//end
if(!taskname.equals("")){
    sqlwhere += " and t1.subject like '%"+taskname+"%'";
}
if(!resourceid.equals("")){
    sqlwhere += " and t1.hrmid="+resourceid;
}
if(!fromdate.equals("")){
    sqlwhere += " and t1.begindate>='"+fromdate+"'";
}
if(!todate.equals("")){
    sqlwhere += " and t1.begindate<='"+todate+"'";
}
if(!fromdate2.equals("")){
    sqlwhere += " and t1.enddate>='"+fromdate2+"'";
}
if(!todate2.equals("")){
    sqlwhere += " and t1.enddate<='"+todate2+"'";
}
if(taskstatus==1){
    sqlwhere += " and t1.finish<=0";
}else if(taskstatus==2){
    sqlwhere += " and t1.finish<100 and t1.finish>0";
}else if(taskstatus==3){
    sqlwhere += " and t1.finish>=100";
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<!-- <input type="button" value="<%=SystemEnv.getHtmlLabelName( 615 ,user.getLanguage()) %>" class="e8_btn_top"  onclick="submitData(this)"/> -->
			<input type="text" class="searchInput" name="flowTitle" value="<%=nameQuery %>" />
			<span id="advancedSearch" class="advancedSearch" style="display:;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv" ></div>


<FORM id=weaver name=frmmain method=post action="searchtask.jsp">

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSearch(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<table width=100% height=94% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<table class="viewform">
  <colgroup>
  <col width="10%">
  <col width="40%">
  <col width="10%">
  <col width="40%">
  <tbody>
    <tr>
    	<td><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></td>
    	<td class=field><input class=inputstyle type="text" name="taskname" value="<%=taskname%>"></td>
    	<td><%=SystemEnv.getHtmlLabelName(15285,user.getLanguage())%></td>
    	<td class=field>
    		
    		<input type="hidden" class="wuiBrowser" id="resourceid" name="resourceid" value="<%=resourceid%>"
    			_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"  _displayText="<%=resourcespan%>">
    	</td>
    </tr>
    <TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
    <tr>
    	<td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
    	<td class=field>
    	<button type="button" class=calendar onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>
    	<SPAN id=fromdatespan><%=fromdate%></SPAN>
    	-&nbsp;&nbsp;
    	<button type="button" class=calendar onclick="gettheDate(todate,todatespan)"></BUTTON>
    	<SPAN id=todatespan><%=todate%></SPAN>
    	<input type="hidden" name="fromdate" value="<%=fromdate%>">
    	<input type="hidden" name="todate" value="<%=todate%>">
    	</td>
    	
    	<td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
    	<td class=field>
    	<button type="button" class=calendar onclick="gettheDate(fromdate2,fromdatespan2)"></BUTTON>
    	<SPAN id=fromdatespan2><%=fromdate2%></SPAN>
    	-&nbsp;&nbsp;
    	<button type="button" class=calendar onclick="gettheDate(todate2,todatespan2)"></BUTTON>
    	<SPAN id=todatespan2><%=todate2%></SPAN>
    	<input type="hidden" name="fromdate2" value="<%=fromdate2%>">
    	<input type="hidden" name="todate2" value="<%=todate2%>">
    	</td>
    </tr> 
    <TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
    
    <tr>
    	<td><%=SystemEnv.getHtmlLabelName(22074,user.getLanguage())%></td>
    	<td class=field>
    		<select id="taskstatus" name="taskstatus">
    			<option value=0 <%if(taskstatus==0){%>selected<%}%>></option>
    			<option value=1 <%if(taskstatus==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1979,user.getLanguage())%></option>
    			<option value=2 <%if(taskstatus==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%></option>
    			<option value=3 <%if(taskstatus==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%></option>
    		</select>
    	</td>
    	<td></td>
    	<td></td>
    </tr> 
    <TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
  </tbody>
</table>
</form>
 <TABLE width="100%">
                    <tr>
                      <td valign="top">                                                                                    
                          <%
                          String tableString = "";
                          
                          int perpage=10;                                 
                        
                          String backfields = " t2.id as projectid,t2.name,t2.manager,t1.prjid,t1.dsporder,t1.subject,t1.hrmid,t1.begindate,t1.enddate,t1.finish,t1.id ";
                          //modified by chengfeng.han 2011-7-18 td 27219
                          String fromSql  = " from Prj_TaskProcess t1, prj_projectinfo t2 ,PrjShareDetail t3 ";
                          String sqlWhere = " t1.prjid=t2.id and t2.id = t3.prjid "+sqlwhere;
                          //end
                          String orderby = " t1.prjid, t1.dsporder";
                            
                          tableString = " <table tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                                        " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                                        " <head>"+
                                        "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1353,user.getLanguage())+"\" orderkey=\"name\" column=\"projectid\" transmethod=\"weaver.general.TaskTransMethod.getPrjName\" />"+
                                        "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17802,user.getLanguage())+"\" column=\"manager\" transmethod=\"weaver.general.TaskTransMethod.getResouceName\"/>"+
                                        "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1352,user.getLanguage())+"\" orderkey=\"subject\" column=\"id\" transmethod=\"weaver.general.TaskTransMethod.getTaskName\" />"+
                                        "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15285,user.getLanguage())+"\" column=\"hrmid\"  transmethod=\"weaver.general.TaskTransMethod.getResouceName\"/>"+
                                        "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"\" orderkey=\"begindate\" column=\"begindate\" />"+
                                        "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(741,user.getLanguage())+"\" orderkey=\"enddate\" column=\"enddate\" />"+
                                        "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(22069,user.getLanguage())+"\" orderkey=\"finish\" column=\"finish\" transmethod=\"weaver.general.TaskTransMethod.getFinish\"/>"+
                                        "	</head>"+   			
                                        "</table>";
                          %>
                          
                          <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
                      </td>
                    </tr>
                  </TABLE>

<!--   added by xwj for td2023 on 2005-05-20  end  -->
     
<table align=right>
   <tr>
   <td>&nbsp;</td>
   <td>
   <%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
   %>
 <td>&nbsp;</td>
   </tr>
	  </TABLE>
	  
	  </td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>



<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
<script language=vbs>
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		resourcespan.innerHtml = id(1)
		frmmain.resourceid.value=id(0)
		else
		resourcespan.innerHtml = ""
		frmmain.resourceid.value=""
		end if
	end if

end sub
</script>

<SCRIPT language="javascript">
function OnSearch(){
		document.frmmain.submit();
}
</script>
<script language=vbs src="/js/browser/WorkFlowBrowser.vbs"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
