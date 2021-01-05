
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="oracle.sql.CLOB" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AllSubordinate" class="weaver.hrm.resource.AllSubordinate" scope="page"/>


<%
int userid=user.getUID();

String name=Util.null2String(request.getParameter("name")).trim();
String typeid=Util.null2String(request.getParameter("typeid"));
String creater=Util.null2String(request.getParameter("creater"));
String status=Util.null2String(request.getParameter("status"));
String jointype=Util.null2String(request.getParameter("jointype"));
String coworker=Util.null2String(request.getParameter("coworker"));
String startdate=Util.null2String(request.getParameter("startdate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String coworkmanager=Util.null2String(request.getParameter("coworkmanager"));

int curcustid=Util.getIntValue(request.getParameter("id"),0);

String alltypes = "0";
ConnStatement statement=new ConnStatement();
boolean isoracle = (statement.getDBType()).equals("oracle");

if(isoracle){
    RecordSet.executeSql("select id from cowork_types where dbms_lob.instr(managerid,',"+userid+",',1,1)>0");
}else{
    RecordSet.executeSql("select id from cowork_types where managerid like '%,"+userid+",%'");
}
while(RecordSet.next()){
    alltypes+=","+RecordSet.getString("id");
}


String sqlwhere="where 1=1 ";

if(!name.equals("")){
    sqlwhere += " and name like '%"+name+"%' ";
}
if(!typeid.equals("")){
    sqlwhere += " and typeid = "+typeid+" ";
}
if(!creater.equals("")){
    sqlwhere += " and creater = "+creater+" ";
}
if(!status.equals("")){
    sqlwhere += " and status = "+status+" ";
}

if(!enddate.equals("")){
    sqlwhere += " and  begindate <= '"+enddate+"' ";
}
if(!startdate.equals("")){
    sqlwhere += " and  enddate >= '"+startdate +"' ";
}

if(!coworker.equals("")){
    if(isoracle){
        sqlwhere += " and dbms_lob.instr(coworkers,',"+coworker+",',1,1)>0 ";
    }else{
        sqlwhere += " and coworkers like '%,"+coworker+",%' ";
    }
}
if(jointype.equals("")){
    if(isoracle){
        sqlwhere +=" and (dbms_lob.instr(coworkers,',"+userid+",',1,1)>0 or creater="+userid+" or coworkmanager="+userid+" or typeid in ("+alltypes+")) ";
    }else{
        sqlwhere +=" and (coworkers like '%,"+userid+",%' or creater="+userid+" or coworkmanager="+userid+" or typeid in ("+alltypes+")) ";
    }
}else if(jointype.equals("1")){
    if(isoracle){
        sqlwhere +=" and (dbms_lob.instr(coworkers,',"+userid+",',1,1)>0 or creater="+userid+") ";
    }else{
        sqlwhere +=" and (coworkers like '%,"+userid+",%' or creater="+userid+") ";
    }
}else if(jointype.equals("2")){
    if(isoracle){
        sqlwhere +=" and (dbms_lob.instr(coworkers,',"+userid+",',1,1)>0 and creater<>"+userid+" and (typeid in ("+alltypes+") or coworkmanager="+userid+")) ";
    }else{
        sqlwhere +=" and (coworkers not like '%,"+userid+",%' and creater<>"+userid+" and (typeid in ("+alltypes+") or coworkmanager="+userid+")) ";
    }
}
if(!coworkmanager.equals("")){
    sqlwhere += " and coworkmanager = "+coworkmanager+" ";
}
if(isoracle){
    sqlwhere += " and ((creater="+userid+" and coworkmanager="+userid+") or dbms_lob.instr(coworkers,',"+userid+",',1,1)>0 or coworkmanager="+userid+" or typeid in ("+alltypes+"))";
}else{
    sqlwhere += " and ((creater="+userid+" and coworkmanager="+userid+") or coworkers like '%,"+userid+",%' or coworkmanager="+userid+" or typeid in ("+alltypes+"))";
}
String sqlorder=" order by createdate desc,createtime desc";
String searchsql  = "select * from cowork_items "+sqlwhere+sqlorder;
%>

<TABLE ID='BrowseTable' class='ListStyle' cellspacing='1'>

<COLGROUP>
<COL width='2px'>
<COL width="55%">
<COL width="15%">
<COL width="25%">
        
<%
boolean isLight = true;

try {
    statement.setStatementSql(searchsql);
    statement.executeQuery();
	while(statement.next()){
		String id = statement.getString("id");
		String tmpname = statement.getString("name");
		int levelvalue = statement.getInt("levelvalue");
		String tmpcreater = statement.getString("creater");
		
		String tmpcreatedate = statement.getString("createdate");
		String tmpcreatetime = statement.getString("createtime").substring(0,5);
		String title1 = Util.StringReplace(statement.getString("remark"),"<br>","\n");
		
		String isnew = "";
		if(isoracle){
			CLOB theclob = statement.getClob("isnew");
			String readline = "" ;
			StringBuffer clobStrBuff = new StringBuffer("") ;
			BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
			while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline) ;
			clobin.close() ;
			isnew = clobStrBuff.toString();
		}else{
			isnew = statement.getString("isnew");
		}
		
		String userids = statement.getString("userids");
		String tempuserids = ","+userids;
		int index = tempuserids.indexOf(","+userid+",");
		String title = "";
		String src = "";
		if(index!=-1){
			title = SystemEnv.getHtmlLabelName(19781,user.getLanguage());
			src = "/cowork/images/importent_wev8.gif";
		}else{
			title = SystemEnv.getHtmlLabelName(19780,user.getLanguage());
			src = "/cowork/images/notimportent_wev8.gif";	    
		}
%>
	    <TR CLASS="<%if(isLight){%>DataDark<%}else{%>DataLight<%}%>" id="thetr" title="<%=Util.toHtml(title1.length()<300?title1:title1.substring(0,300)).replace("<br>","\n")+"..."%>">
            <td style="display:none"><%=id%></td>
            <td id="Td_<%=id%>" width='8px' onclick="javascript:actionit(<%=id%>)" title="<%=title%>"><img style="cursor:hand" id=Img_<%=id%> name=Img_<%=id%> src="<%=src%>" border=0></td>
			<%  
	    	if(isnew.indexOf(","+userid+",")==-1){%>
            <td onclick="browseTable_onclick()" onmouseover="browseTable_onmouseover()" onmouseout="browseTable_onmouseout()" style="font-weight:bold"><%if(levelvalue==1){%><img src="/cowork/images/isimport_wev8.gif" width=3 height=11 border=0>&nbsp;<%}%><%=tmpname%></td>
			<%}else{%>
            <td onclick="browseTable_onclick()" onmouseover="browseTable_onmouseover()" onmouseout="browseTable_onmouseout()"><%if(levelvalue==1){%><img src="/cowork/images/isimport_wev8.gif" width=3 height=11 border=0>&nbsp;<%}%><%=tmpname%></td>
			<%}%>
            <td onclick="browseTable_onclick()" onmouseover="browseTable_onmouseover()" onmouseout="browseTable_onmouseout()"><%=ResourceComInfo.getResourcename(tmpcreater)%></td>
            <td onclick="browseTable_onclick()" onmouseover="browseTable_onmouseover()" onmouseout="browseTable_onmouseout()"><%=tmpcreatedate.substring(5,10)%>&nbsp;<%=tmpcreatetime%></td>
        </TR>
	<%	
	isLight = !isLight;
	}
}finally{
	statement.close();
}
%>
</TABLE>
