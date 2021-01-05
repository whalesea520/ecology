<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rss" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsn" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsg" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String id=request.getParameter("id");
String  type_c0="";
String  type_c1="";
String  type_c2="";
String  id0="";
String  id1="";
String  id2="";
String  percent_n0="";
String  percent_n1="";
String  percent_n2="";
boolean flag=false;
String cycle=request.getParameter("cycle");
if((HrmUserVarify.checkUserRight("CheckScheme:Performance",user))){//权限判断
rs1.execute("select * from HrmPerformanceSchemeContent where schemeId="+id+" and type_c='0'  and cycle='"+cycle+"' ");  //月考核，是否有目标考核方案
if (rs1.next())
{
  id0=rs1.getString("id");
  type_c0=rs1.getString("type_c");
  percent_n0=rs1.getString("percent_n");
}
rs2.execute("select * from HrmPerformanceSchemeContent where schemeId="+id+" and type_c='1' and cycle='"+cycle+"'");  //是否有自定义考核方案
if (rs2.next())
{
  id1=rs2.getString("id");
  type_c1=rs2.getString("type_c");
  percent_n1=rs2.getString("percent_n");
}
rs3.execute("select * from HrmPerformanceSchemeContent where schemeId="+id+" and type_c='2' and cycle='"+cycle+"'");  //是否有述职报告考核方案
if (rs3.next())
{
  id2=rs3.getString("id");
  type_c2=rs3.getString("type_c");
  percent_n2=rs3.getString("percent_n");
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%

String needfav ="1";
String needhelp ="";

%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("CheckScheme:Performance",user)) {	
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<!--目标考核-->
<FORM name=resource id=resource action="CheckSchemeOperation.jsp" method=post>
<input type=hidden name=inserttype value=content >
<input type=hidden name=mainId value=<%=id%> >
<input type=hidden name=cycle value=<%=cycle%> >
<button id="bton" name="bton" style="display:none"></button>
<input type="hidden" name="changed" value="0">
<button id="bton1" name="bton1" style="display:none"></button>
<table width=100%  border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3">
</td>
</tr>
<tr>
<td></td>
<td valign="top">
<TABLE class=liststyle>
<tr>
<td valign="top">
<TABLE class=viewform>
<tr class=title><th><input type="checkbox" value="1"  name="type_c0" onClick=changes() class=inputstyle <%if (!type_c0.equals("")) {%> checked <%}%> >
<%=SystemEnv.getHtmlLabelName(18060,user.getLanguage())%>　
<%=SystemEnv.getHtmlLabelName(18063,user.getLanguage())%>(%)
<input class=inputstyle type="text" maxlength=4 size=4 name=percent_n0 onchange="checknumber('percent_n0');changes()" value=<%=percent_n0%> >
</th></tr></TABLE>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="10%">
  <COL width="15%">
 <COL width="25%">
 <COL width="30%">
 <COL width="5%">
  <TBODY>
  <%

  if (!type_c0.equals("")) {
  RecordSet.execute("select a.*,b.workflowname from HrmPerformanceSchemeDetail a left join workflow_base  b on a.checkFlow=b.id  where contentId="+id0);
  rss.execute("select count(id) from HrmPerformanceSchemeDetail where contentId="+id0);
  int sum=0;
  if (rss.next())
  {
   sum=Util.getIntValue(rss.getString(1));
  }
  %>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(18064,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18063,user.getLanguage())%>(%)</th>
  <th><%=SystemEnv.getHtmlLabelName(18067,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18134,user.getLanguage())%>(%)</th>
  <th><%=SystemEnv.getHtmlLabelName(18135,user.getLanguage())%>(%)</th>
  <th>
  <%
  
  flag=RecordSet.next();
  if (((cycle.equals("2")||(cycle.equals("3")))&&sum==0)||(!cycle.equals("2")&&sum<2&!cycle.equals("3"))) {%>
  <a href="SchemeDetailAdd.jsp?mainid=<%=id%>&id=<%=id0%>&type=0&cycle=<%=cycle%>"  target="_parent"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
  <%}
 %>
  </th>
  </tr>
 
 <TR class=Line><TD colspan="6"></TD></TR> 
  <%}

//RecordSet.execute("select a.*,b.workflowname from HrmPerformanceSchemeDetail a left join workflow_base  b on a.checkFlow=b.id  where contentId="+id0);
boolean isLight = false;
	if (flag)
	{
	do 
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><a href="SchemeDetailEdit.jsp?mainid=<%=id%>&id=<%=RecordSet.getString("id")%>&contentId=<%=id0%>&type=0&cycle=<%=cycle%>"  target="_parent">
		<%if (RecordSet.getString("item").equals("0")) {%>
		<%=SystemEnv.getHtmlLabelName(18170,user.getLanguage())%>
		<%}
		else
		{%>
		<%=SystemEnv.getHtmlLabelName(18137,user.getLanguage())%>
		<%}%>
		</a></TD>
		<TD><%=Util.toScreen(RecordSet.getString("percent_n"),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(RecordSet.getString("workflowname"),user.getLanguage())%></TD>
		<TD>
		<!-- 权重信息-->
		 <%
          
          rsn.execute("SELECT d.percent_n,b.workflowid, b.nodeid, c.checkFlow, c.item, a.nodename FROM workflow_nodebase a LEFT OUTER JOIN "+
                         "workflow_flownode b ON (a.IsFreeNode is null or a.IsFreeNode!='1') and a.id = b.nodeid LEFT OUTER JOIN "+
                        "HrmPerformanceSchemeDetail c ON b.workflowid = c.checkFlow "+
                        "left join HrmPerformanceSchemePercent d on c.id=d.itemId and a.id=d.nodeId and d.type_d='0' and d.type_n='0'"+
                         " WHERE c.id="+RecordSet.getString("id")+" and b.nodetype!='0' and b.nodetype!='3' ORDER BY a.id");
                        
                         
          while (rsn.next())
          {
          
          %>
          <%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%> <%=Util.toScreen(Util.null2String(rsn.getString("nodename")),user.getLanguage())%> :<%=rsn.getString("percent_n")%><br> 
          <%
         
          rsg.execute("select a.* ,d.percent_n from workflow_nodegroup a  left join HrmPerformanceSchemePercent d on a.id=d.groupId and d.type_n='1' and d.type_d='0' and d.itemId="+RecordSet.getString("id")+" where   a.nodeid="+rsn.getString("nodeid")+" order by a.id ");
          while (rsg.next())
          {
         
          %>
          　　   <%=SystemEnv.getHtmlLabelName(15545,user.getLanguage())%>  <%=Util.toScreen(Util.null2String(rsg.getString("groupname")),user.getLanguage())%>:<%=rsg.getString("percent_n")%><br>
          <%
          }} %>
		<!-- 权重信息结束-->
		</TD>
		<TD>
		<%if (RecordSet.getString("item").equals("0"))
		{%>
		<!-- 权重信息(含下游)-->
		 <%
          
          rsn.execute("SELECT d.percent_n,b.workflowid, b.nodeid, c.checkFlow, c.item, a.nodename FROM workflow_nodebase a LEFT OUTER JOIN "+
                         "workflow_flownode b ON (a.IsFreeNode is null or a.IsFreeNode!='1') and a.id = b.nodeid LEFT OUTER JOIN "+
                        "HrmPerformanceSchemeDetail c ON b.workflowid = c.checkFlow "+
                        "left join HrmPerformanceSchemePercent d on c.id=d.itemId and a.id=d.nodeId and d.type_d='1' and d.type_n='0'"+
                         " WHERE c.id="+RecordSet.getString("id")+"  and b.nodetype!='0' and b.nodetype!='3' ORDER BY a.id");
                        
                         
          while (rsn.next())
          {
          
          %>
          <%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%> <%=Util.toScreen(Util.null2String(rsn.getString("nodename")),user.getLanguage())%> :<%=rsn.getString("percent_n")%><br> 
          <%
         
          rsg.execute("select a.* ,d.percent_n from workflow_nodegroup a  left join HrmPerformanceSchemePercent d on a.id=d.groupId and d.type_n='1' and d.type_d='1' and d.itemId="+RecordSet.getString("id")+"  where   a.nodeid="+rsn.getString("nodeid")+" order by a.id ");
          while (rsg.next())
          {
         
          %>
          　　   <%=SystemEnv.getHtmlLabelName(15545,user.getLanguage())%>  <%=Util.toScreen(Util.null2String(rsg.getString("groupname")),user.getLanguage())%>:<%=rsg.getString("percent_n")%><br>
          <%
          }} %>
          <%=SystemEnv.getHtmlLabelName(18176,user.getLanguage())%>:
           <%
            String down="";
            rsg.execute("select * from  HrmPerformanceSchemePercent where type_n='2' and itemId="+RecordSet.getString("id"));
            if  (rsg.next())
            {
            out.print(rsg.getString("percent_n"));
           } 
           }
          %>
		<!-- 权重信息结束--></TD>
		<TD><a  onclick="deldetail(<%=RecordSet.getString("id")%>,<%=id%>)" href="#"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TD>

	</TR>
<%
	}
	while(RecordSet.next());
	}
%>
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
<!--目标考核结束-->

<!--自定义考核-->
<table width=100%  border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
</td>
</tr>
<tr>
<td></td>
<td valign="top">
<TABLE class=liststyle>
<tr>
<td valign="top">
<table class=viewform>
<tr class=title><th>
<input type="checkbox" value="1"  name="type_c1" onClick=changes() class=inputstyle <%if (!type_c1.equals("")) {%> checked <%}%> >
<%=SystemEnv.getHtmlLabelName(18061,user.getLanguage())%>　
<%=SystemEnv.getHtmlLabelName(18063,user.getLanguage())%>(%)
<input class=inputstyle type="text" maxlength=4 size=4 name=percent_n1 onchange="checknumber('percent_n1');changes()" value=<%=percent_n1%> >
</th></tr></table>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="15%">
  <COL width="20%">
  <COL width="30%">
  <COL width="5%">
  <TBODY>
  <%if (!type_c1.equals("")) {
  RecordSet.execute("select a.*,b.workflowname,c.ruleName from HrmPerformanceSchemeDetail a left join workflow_base  b on a.checkFlow=b.id  left join  HrmPerformanceCheckRule c on a.item=c.id where contentId="+id1);
  flag=RecordSet.next();
  %>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(18064,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18063,user.getLanguage())%>(%)</th>
  <th><%=SystemEnv.getHtmlLabelName(18067,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18134,user.getLanguage())%>(%)</th>
  <th>
  <%if (!flag) {%>
  <a href="SchemeDetailAdd.jsp?mainid=<%=id%>&id=<%=id1%>&type=1&cycle=<%=cycle%>" target="_parent"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
  <%}%>
</tr>
 <TR class=Line><TD colspan="6"></TD></TR> 
<%

 isLight = false;
	if (flag)
	{do
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><a href="SchemeDetailEdit.jsp?mainid=<%=id%>&id=<%=RecordSet.getString("id")%>&contentId=<%=id1%>&type=1&cycle=<%=cycle%>"  target="_parent"><%=Util.toScreen(RecordSet.getString("ruleName"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSet.getString("percent_n"),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(RecordSet.getString("workflowname"),user.getLanguage())%></TD>
		<TD>
			<!-- 权重信息-->
		 <%
          
          rsn.execute("SELECT d.percent_n,b.workflowid, b.nodeid, c.checkFlow, c.item, a.nodename FROM workflow_nodebase a LEFT OUTER JOIN "+
                         "workflow_flownode b ON (a.IsFreeNode is null or a.IsFreeNode!='1') and a.id = b.nodeid LEFT OUTER JOIN "+
                        "HrmPerformanceSchemeDetail c ON b.workflowid = c.checkFlow "+
                        "left join HrmPerformanceSchemePercent d on c.id=d.itemId and a.id=d.nodeId and d.type_d='0' and d.type_n='0'"+
                         " WHERE c.id="+RecordSet.getString("id")+"  and b.nodetype!='0' and b.nodetype!='3' ORDER BY a.id");
                        
                         
          while (rsn.next())
          {
          
          %>
          <%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%> <%=Util.toScreen(Util.null2String(rsn.getString("nodename")),user.getLanguage())%> :<%=rsn.getString("percent_n")%><br> 
          <%
         
          rsg.execute("select a.* ,d.percent_n from workflow_nodegroup a  left join HrmPerformanceSchemePercent d on a.id=d.groupId and d.type_n='1' and d.type_d='0' and d.itemId="+RecordSet.getString("id")+" where   a.nodeid="+rsn.getString("nodeid")+" order by a.id ");
          while (rsg.next())
          {
         
          %>
          　　   <%=SystemEnv.getHtmlLabelName(15545,user.getLanguage())%>  <%=Util.toScreen(Util.null2String(rsg.getString("groupname")),user.getLanguage())%>:<%=rsg.getString("percent_n")%><br>
          <%
          }} %>
		<!-- 权重信息结束-->
		</TD>
		
		<TD><a  onclick="deldetail(<%=RecordSet.getString("id")%>,<%=id%>)" href="#"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TD>

	</TR>
<%
	} while(RecordSet.next());
	}
  }	
%>
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
<!--自定义考核结束-->


<!--述职报告考核-->
<%if (!cycle.equals("2")) {%>
<table width=100%  border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
</td>
</tr>
<tr>
<td></td>
<td valign="top">
<TABLE class=liststyle>
<tr>
<td valign="top">
<table class=viweform><tr class=title><th><input type="checkbox" value="1"  onClick=changes() name="type_c2" class=inputstyle <%if (!type_c2.equals("")) {%> checked <%}%> >
<%=SystemEnv.getHtmlLabelName(18062,user.getLanguage())%>　
<%=SystemEnv.getHtmlLabelName(18063,user.getLanguage())%>(%)
<input class=inputstyle type="text" maxlength=4 size=4 name=percent_n2  onchange="checknumber('percent_n2');changes()" value=<%=percent_n2%>>
</th></tr></table>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="15%">
  <COL width="20%">
  <COL width="30%">
  <COL width="5%">
  <TBODY>
  <%
  flag=false;
  if (!type_c2.equals("")) {
  RecordSet.execute("select a.*,b.workflowname,c.docsubject from HrmPerformanceSchemeDetail a left join workflow_base  b on a.checkFlow=b.id left join DocDetail c on a.item=c.id where contentId="+id2);
  %>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(18064,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18063,user.getLanguage())%>(%)</th>
  <th><%=SystemEnv.getHtmlLabelName(18067,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18134,user.getLanguage())%>(%)</th>
  <th><%
  flag=RecordSet.next();
  if (!flag) {%>
  <a href="SchemeDetailAdd.jsp?mainid=<%=id%>&id=<%=id2%>&type=2&cycle=<%=cycle%>" target="_parent"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
  <%}%>
  </th>
  </tr>
 <TR class=Line><TD colspan="6"></TD></TR> 
<%}
//RecordSet.execute("select a.*,b.workflowname,c.docsubject from HrmPerformanceSchemeDetail a left join workflow_base  b on a.checkFlow=b.id left join DocDetail c on a.item=c.id where contentId="+id1);
 isLight = false;
    if (flag)
    {
	do
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><a href="SchemeDetailEdit.jsp?mainid=<%=id%>&id=<%=RecordSet.getString("id")%>&contentId=<%=id2%>&type=2&cycle=<%=cycle%>"  target="_parent"><%=SystemEnv.getHtmlLabelName(18062,user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSet.getString("percent_n"),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(RecordSet.getString("workflowname"),user.getLanguage())%></TD>
		<TD>
			<!-- 权重信息-->
		 <%
          
          rsn.execute("SELECT d.percent_n,b.workflowid, b.nodeid, c.checkFlow, c.item, a.nodename FROM workflow_nodebase a LEFT OUTER JOIN "+
                         "workflow_flownode b ON (a.IsFreeNode is null or a.IsFreeNode!='1') and a.id = b.nodeid LEFT OUTER JOIN "+
                        "HrmPerformanceSchemeDetail c ON b.workflowid = c.checkFlow "+
                        "left join HrmPerformanceSchemePercent d on c.id=d.itemId and a.id=d.nodeId and d.type_d='0' and d.type_n='0'"+
                         " WHERE c.id="+RecordSet.getString("id")+" and b.nodetype!='0' and b.nodetype!='3' ORDER BY a.id");
                        
                         
          while (rsn.next())
          {
          
          %>
          <%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%> <%=Util.toScreen(Util.null2String(rsn.getString("nodename")),user.getLanguage())%> :<%=rsn.getString("percent_n")%><br> 
          <%
         
          rsg.execute("select a.* ,d.percent_n from workflow_nodegroup a  left join HrmPerformanceSchemePercent d on a.id=d.groupId and d.type_n='1' and d.type_d='0' and d.itemId="+RecordSet.getString("id")+" where   a.nodeid="+rsn.getString("nodeid")+" order by a.id ");
          while (rsg.next())
          {
         
          %>
          　　   <%=SystemEnv.getHtmlLabelName(15545,user.getLanguage())%>  <%=Util.toScreen(Util.null2String(rsg.getString("groupname")),user.getLanguage())%>:<%=rsg.getString("percent_n")%><br>
          <%
          }} %>
		<!-- 权重信息结束-->
		</TD>
		
		<TD><a  onclick="deldetail(<%=RecordSet.getString("id")%>,<%=id%>)" href="#"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TD>

	</TR>
<%
	}
	while (RecordSet.next());
	}
%>
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
<%}%>
</FORM>

<!--述职报告考核结束-->
</BODY>
<script language="vbs">
sub bton_onclick()
OnSubmit()
end sub
</script>
<script language="javascript" for="bton1" event="onclick">
if (!protectsave())
{
parent.document.resource.changed.value="1";
}
else
{parent.document.resource.changed.value="0";
}
</script>

<script>
function protectsave(){ 
        
        if (document.resource.changed.value=="1")
        { 
        if (!confirm("<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>"))
          return false; 
        }
      
        return true;
   }
 function changes()
     {
     document.resource.changed.value="1";
     }  
     
function OnSubmit(){
    if(!ischeck('type_c0','percent_n0')&&!ischeck('type_c1','percent_n1')&&!ischeck('type_c2','percent_n2')&&!checkall())
    
     
	{	
		parent.document.resource.changed.value="0";
		document.resource.submit();
		if (document.resource.changed.value!="2") enablemenu();
	}
	else
	{
	    parent.document.resource.changed.value="1";
	}

}

function ischeck(obj,objp)
{
if (<%=cycle%>!="2")
{
if (document.all(obj).checked==true)
{
   if (document.all(objp).value==""||document.all(objp).value<"0")
   {
  alert("<%=SystemEnv.getHtmlLabelName(18138,user.getLanguage())%>");
   return true;
   }  
}
}
else
{  
return false;
}
return false;
}
function checkall()
{var a=0;
 var b=0;
 var c=0;
if (document.all("type_c0").checked==true)
{
if (document.all("percent_n0").value!="")
{
 a=parseFloat(document.all("percent_n0").value);
}
}
else
{
document.all("percent_n0").value="0";
}

if (document.all("type_c1").checked==true)
{
if (document.all("percent_n1").value!="")
{
 b=parseFloat(document.all("percent_n1").value);
}
}
else
{
document.all("percent_n1").value="0";
}
if (<%=cycle%>!="2")
{
if (document.all("type_c2").checked==true)
{
if (document.all("percent_n2").value!="")
{
 c=parseFloat(document.all("percent_n2").value);
}
}
else
{
document.all("percent_n2").value="0";
}
}
if ((a+b+c)!=100&&(a+b+c)!=0)
{
   alert("<%=SystemEnv.getHtmlLabelName(18139,user.getLanguage())%>");
   return true;
}
/*
if ((a+b+c)==0)
{
   alert("<%=SystemEnv.getHtmlLabelName(18147,user.getLanguage())%>");
   return true;
}
*/
 return false;
}

function deldetail(ids,mainids)
{
if (isdel())
{
location.href="CheckSchemeOperation.jsp?id="+ids+"&type=detaildel&mainid="+mainids;
}
}
</script>
</HTML>
    <%}
else{
response.sendRedirect("/notice/noright.jsp");
    		return;
	}%>
