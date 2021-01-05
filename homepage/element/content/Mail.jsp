
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/homepage/element/content/Common.jsp" %>
<%
	/*
		基本信息
		--------------------------------------
		hpid:表首页ID
		subCompanyId:首页所属分部的分部ID
		eid:元素ID
		ebaseid:基本元素ID
		styleid:样式ID
		
		条件信息
		--------------------------------------
		strsqlwhere 格式为 条件1^,^条件2...
		perpage  显示页数
		linkmode 查看方式  1:当前页 2:弹出页

		
		字段信息
		--------------------------------------
		fieldIdList
		fieldColumnList
		fieldIsDate
		fieldTransMethodList
		fieldWidthList
		linkurlList
		valuecolumnList
		isLimitLengthList
	*/

%>
<TABLE  style="color:<%=hpsb.getEcolor()%>" id='_contenttable_<%=eid%>' class="Econtent"  width="100%">
<TR>
    <TD width="1px"></TD>
    <TD width="*">      
    <TABLE width="100%">          
     <%
int mailId = 0;
String priority = "";
String senddate = "";

int size=fieldIdList.size();
           int rowcount=0;
           String imgSymbol="";
           if (!"".equals(hpsb.getEsymbol())) imgSymbol="<img name='esymbol' src='"+hpsb.getEsymbol()+"'>";

			  rs.executeSql("SELECT * FROM MailResource WHERE resourceid="+user.getUID()+" AND status='0' AND folderId>=0 ORDER BY senddate DESC");
           while(rs.next() && rowcount<perpage){
				  mailId = rs.getInt("id");
				  priority = rs.getString("priority");
				  senddate = rs.getString("senddate");
           %>
            <TR  height="18px">
                <TD width="8"><%=imgSymbol%></TD>
                <%
                    
                    for(int i=0;i<size;i++){
                        String fieldId=(String)fieldIdList.get(i);
                        String columnName=(String)fieldColumnList.get(i);
                        String strIsDate=(String)fieldIsDate.get(i);
                        String fieldTransMethod=(String)fieldTransMethodList.get(i);
                        String fieldwidth=(String)fieldWidthList.get(i);
                        String linkurl=(String)linkurlList.get(i);
                        String valuecolumn=(String)valuecolumnList.get(i);
                        String isLimitLength=(String)isLimitLengthList.get(i);
                        String showValue="";                    
                        String cloumnValue=Util.null2String(rs.getString(columnName));
                        String urlValue=Util.null2String(rs.getString(valuecolumn));
                        String url="/email/MailView.jsp?id="+mailId;
                        String titleValue=cloumnValue;                  
                        if("1".equals(isLimitLength))   cloumnValue=hpu.getLimitStr(eid,fieldId,cloumnValue,user,hpid,subCompanyId);
    
                        if(!"".equals(linkurl)){
                            if("1".equals(linkmode))
                                showValue="<a href='"+url+"' target='_self'>"+cloumnValue+"</a>";
                            else 
                                showValue="<a href=\"javascript:openFullWindowForXtable('"+url+"')\">"+cloumnValue+"</a>";
                        }

								
        %>

<%if("subject".equals(columnName)){%>
<TD width="<%=fieldwidth%>" <%if("1".equals(isLimitLength)) out.println(" title=\""+titleValue+"\"");%>><%=showValue%></TD>
<%}%>
<%if("priority".equals(columnName)){%>
<TD>
	<%if(priority.equals("3")){out.print(SystemEnv.getHtmlLabelName(2086, user.getLanguage()));}
		else if(priority.equals("2")){out.print(SystemEnv.getHtmlLabelName(15533, user.getLanguage()));}
		else if(priority.equals("4")){out.print(SystemEnv.getHtmlLabelName(19952, user.getLanguage()));}%>
</TD>
<%}%>
<%if("senddate".equals(columnName)){%>
<TD><%=senddate%></TD>
<%}%>
                <%}%>
            </TR>
            <%
            rowcount++;     
            if(rowcount<perpage){%>
                <TR style="background:url('<%=hpsb.getEsparatorimg()%>')" height=1px><td colspan=<%=size+1%>></td></TR>
            <%}%>
            
            <%}%>

<%if(rowcount==perpage){%>
<TR style="background:url('<%=hpsb.getEsparatorimg()%>')" height=1px><td colspan=<%=size+1%>></td></TR>
<%}%>
<TR height="18px">
<TD width="8"><%=imgSymbol%></TD>
<td colspan="<%=size%>">
	<%=SystemEnv.getHtmlLabelName(20265,user.getLanguage())%>:
	<%
	rs.executeSql("SELECT * FROM MailAccount WHERE userId="+user.getUID()+"");
	while(rs.next()){
	%>
	<%=rs.getString("accountName")%><span id="span<%=rs.getInt("id")%><%=eid%>" style="font:12px MS Shell Dlg,Verdana"><img src="/images/loading2_wev8.gif" style="height:16px;vertical-align:middle"/></span>
	<iframe id="iframe<%=rs.getInt("id")%><%=eid%>" 
			style="width:0;height:0" 
			src="/email/UnreadOnMailServer.jsp?mailAccountId=<%=rs.getInt("id")%>" 
			onload="showUnreadNumber(<%=rs.getInt("id")%><%=eid%>)"></iframe>
	<%}%>
	&nbsp;<a href="/email/MailFrame.jsp" style="color:blue;text-decoration:underline"><%=SystemEnv.getHtmlLabelName(20267,user.getLanguage())%></a>
</td>
</TR>

    </TABLE>
    </TD>
    <TD width="1px"></TD>
</TR>
</TABLE>