
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AllSubordinate" class="weaver.hrm.resource.AllSubordinate" scope="page"/>

<%
String logintype = ""+user.getLogintype();
String ProcPara = "";
char flag = 2;

int isworkflow = Util.getIntValue(Util.null2String(request.getParameter("isworkflow")),0);

int curcustid=Util.getIntValue(request.getParameter("id"),0);

int userid=user.getUID();

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</HEAD>


<BODY onload='window.parent.frames("frameRight").location="frameRight.jsp?isworkflow=<%=isworkflow%>&id=<%=curcustid%>";'>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

    <TABLE ID=BrowseTable class=ListStyle  onclick="browseTable_onclick()" onmouseover="browseTable_onmouseover()" onmouseout="browseTable_onmouseout()" cellspacing=1>
    <TBODY>

    <COLGROUP>
    <COL width=2px>
    <COL width="55%">
    <COL width="15%">
    <COL width="25%">

    <TR class=Header>
        <TH></TH>
        <TH><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TH>
        <TH><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></TH>
        <TH><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TH>
    </TR>
    <TR class=Line><TH colspan="4" ></TH></TR>
    
<%
String sqlselect ="select distinct t1.requestid,t2.requestname,t2.createdate,t2.createtime,'1' as type,creater,requestlevel from workflow_currentoperator t1,workflow_requestbase t2 "
	+" where t1.isremark in ('0','1') and t1.userid ="+userid+" and t1.usertype=0 "
	+" and t1.requestid = t2.requestid and t2.deleted=0 and t2.currentnodetype<>'3' "
    +" and t1.workflowid<>'1' and t1.workflowid<>'120' and t1.workflowid<>'119'"
	+" union select distinct t1.requestid,t1.requestname,t1.createdate,t1.createtime ,'0' as type,creater,requestlevel "
	+" from workflow_requestbase t1,workflow_base t2 "
	+" where deleted=0 and currentnodetype<>'3' and creater="+userid+" and creatertype=0 and t1.workflowid = t2.id "
    +" and t1.workflowid<>'1' and t1.workflowid<>'120' and t1.workflowid<>'119'"
	+" order by type desc,createdate desc,createtime desc ";
RecordSet.executeSql(sqlselect);

	
boolean isLight = false;
String curtype = "";
while(RecordSet.next()){

	String tmptype=RecordSet.getString("type");	
	String tmpid = RecordSet.getString("requestid");	
	String tmpname = RecordSet.getString("requestname");
	String tmpcreater = RecordSet.getString("creater");
	String tmplevelvalue = RecordSet.getString("requestlevel");
	String tmpcreatedate = RecordSet.getString("createdate");
	String tmpcreatetime = RecordSet.getString("createtime");
	
	//if(!tmpcreatedate.equals("")) tmpcreatedate = tmpcreatedate.substring(5,10);	
	if(!tmpcreatetime.equals("")) tmpcreatetime = tmpcreatetime.substring(0,5);
	
%>
	    
<%  if(tmptype.equals("1")&& !tmptype.equals(curtype)){%>
	<TR class=Header>
	<TH></TH>
	<TH colspan=3><%=SystemEnv.getHtmlLabelName(17699,user.getLanguage())%></TH>
	</TR>
<%
	    curtype = tmptype;
	}
    if(tmptype.equals("0")&& !tmptype.equals(curtype)){%>
	<TR class=Header>
	<TH></TH>
	<TH colspan=3><%=SystemEnv.getHtmlLabelName(17700,user.getLanguage())%></TH>
	</TR>
<%
        curtype = tmptype;
    }
%>
    <TR CLASS=<%if(isLight){%>"DataDark"<%}else{%>"DataLight"<%}%> id="thetr">
        <TD style="display:none"><%=tmpid%></td>
        <td width=8px></td>
        <td><%if(Util.getIntValue(tmplevelvalue)>0){%><img src="/cowork/images/isimport_wev8.gif" width=3 height=11 border=0>&nbsp<%}%><%=tmpname%></td>
        <td><%=ResourceComInfo.getResourcename(tmpcreater)%></td>
        <td><%=tmpcreatedate%>&nbsp<%=tmpcreatetime%></td>
    </TR>
<%  isLight = !isLight;
}
%>

	  </TBODY>
	  </table>

<script language="javascript">
curcustid = <%=curcustid%>
function browseTable_onclick(){
    var id;
    var e = window.event.srcElement;
    if(e.tagName == "TD"){
        id = e.parentElement.cells(0).innerText;
    }
    else if(e.tagName == "A"){
        id = e.parentElement.parentElement.cells(0).innerText;
    }
    curcustid = id;
    window.parent.frames("frameRight").frames("HomePageIframe2").location="ViewCoWork.jsp?isworkflow=1&id="+curcustid;
}

function browseTable_onmouseover(){
    var e = window.event.srcElement;
    if(e.tagName == "TD"){
        e.parentElement.className = "Selected";
    }
    else if(e.tagName == "A"){
        e.parentElement.parentElement.className = "Selected";
    }
}
function browseTable_onmouseout(){
    var e = window.event.srcElement;
    if(e.tagName == "TD"||e.tagName == "A"){
        var p;
        if(e.tagName == "TD"){
            p = e.parentElement;
        }
        else{
            p = e.parentElement.parentElement;
        }
        if(p.rowIndex%2==0){
            p.className = "DataLight";
        }
        else{
            p.className = "DataDark";
        }
    }
}
</script>
</body>
</html>
