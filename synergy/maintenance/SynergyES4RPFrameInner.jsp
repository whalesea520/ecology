
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="spc" class="weaver.synergy.SynergyParamsComInfo" scope="page" />
<jsp:useBean id="sgwff" class="weaver.synergy.SynergyGetWFField" scope="page" />
<jsp:useBean id="sowf" class="weaver.synergy.SynergyOperatWorkflow" scope="page" />
<jsp:useBean id="sc" class="weaver.synergy.SynergyComInfo" scope="page" />
<%@ page import="weaver.synergy.SynergyGetWFField" %>
<%
	String eid = Util.null2String(request.getParameter("eid"));
	String synergybaseid = Util.null2String(request.getParameter("sbaseid"));
	String varType = Util.null2String(request.getParameter("varType"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	String nodeid=Util.null2String(request.getParameter("nodeid"));
	String elementbaseid = "reportForm";
	HashMap spcmap = (HashMap)spc.getParamnameList("sysparam",Math.abs(Util.getIntValue(synergybaseid)));
	ArrayList pidlist = (ArrayList)spcmap.get("paramid");
	ArrayList pnamelist = (ArrayList)spcmap.get("paramname");
	ArrayList plabellist = (ArrayList)spcmap.get("paramlabel");
	ArrayList ptypelist = (ArrayList)spcmap.get("paramtype");
	ArrayList pbrowlist = (ArrayList)spcmap.get("browid");
	
	if("".equals(wfid) || "0".equals(wfid))
	{
		wfid = sc.getWfidByHpid(Math.abs(Util.getIntValue(synergybaseid))+"");
	}
	ArrayList flist = null;
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
   $(function(){
       var pheight=$(parent).height();
       var cheight=pheight-65;
	   $(parent.document).find("#tabcontentframe").css("height",cheight+"px");
   });
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(569,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="text" class="searchInput" value="" name="contactWay"/>
			&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<div style="height:547px;width:100%;overflow-y:auto;">
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
      <TH width=*><%=SystemEnv.getHtmlLabelName(20968, user.getLanguage())%></TH>      
      <TH width=25%><%=SystemEnv.getHtmlLabelName(84281, user.getLanguage())%></TH>
      <% if ("form".equals(varType)) {%>
      <TH width=25%><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></TH>
      <%} %>
      <TH width=25%><%=SystemEnv.getHtmlLabelName(32400, user.getLanguage())%></TH>
      </tr><TR class=Line style="height: 1px"><TH colspan="4" ></TH></TR>
<%
if ("sys".equals(varType)) {
for (int i=0;i<pnamelist.size();i++)
{
	if(i%2 == 0){
%>
<TR class=DataLight>
<%
	}else{
%>
<TR class=DataDark>
<%
}
	String paraname = pnamelist.get(i).toString();
	paraname = "$P_sys."+paraname;
	String paralabel = plabellist.get(i).toString();
%>
	<TD style="padding: 0px 5px 0px 12px;"><%=paraname%></TD>
	<TD style="padding: 0px 5px 0px 12px;"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(paralabel),user.getLanguage())%></TD>
	<TD style="padding: 0px 5px 0px 12px;"><%=SystemEnv.getHtmlLabelName(130008, user.getLanguage())%></TD>
</TR>
<%}
} else if ("form".equals(varType)) {
%>
<%
if(!"".equals(wfid))
{
	flist = sowf.getWFFieldByWFID(wfid,user);
	if(flist != null && flist.size() > 0)
	{
		for(int j=0;j<flist.size();j++)
		{
	if(j%2 == 0){
	%>
	<TR class=DataLight>
	<%
		}else{
	%>
	<TR class=DataDark>
	<%
	}
	sgwff = (SynergyGetWFField)flist.get(j);
	String paraname = sgwff.getFieldname();
	String parahtmltype = sgwff.getFieldhtmltype();
	paraname = "$P_form."+paraname;
	String paralabel = sgwff.getFieldlable();
	%>
	<TD style="padding: 0px 5px 0px 12px;"><%=paraname%></TD>
	<TD style="padding: 0px 5px 0px 12px;"><%=paralabel%></TD>
	<TD style="padding: 0px 5px 0px 12px;"><%=Util.null2String(SystemEnv.getHtmlLabelName(sowf.transLabel4FieldbyHtmltype(Util.getIntValue(parahtmltype)),user.getLanguage()))%></TD>
	<TD style="padding: 0px 5px 0px 12px;"><%=SystemEnv.getHtmlLabelName(130009, user.getLanguage())%></TD>
<%
		}
	}
}
}
%>
</TABLE>
</div>
</BODY>
</HTML>
