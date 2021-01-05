<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- added by wcd 2014-07-10 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	int userid = user.getUID();
	boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();//账号类型
	boolean issys = false;
	boolean isfin = false;
	boolean ishr  = false;

	String sql = "select hrmid from HrmInfoMaintenance where id = 1";
	rs.executeSql(sql);
	while(rs.next()){
	  int hrmid = Util.getIntValue(rs.getString(1));
	  if(userid == hrmid){
		issys = true;
		break;
	  }
	}
	sql = "select hrmid from HrmInfoMaintenance where id = 2";
	rs.executeSql(sql);
	while(rs.next()){
	  int hrmid = Util.getIntValue(rs.getString(1));
	  if(userid == hrmid){
		isfin = true;
		break;
	  }
	}
	if(HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
	  ishr = true;
	}

	String hasresourceid="";
	String hasresourcename="";
	String hasjobtitle    ="";
	String hasactivitydesc="";
	String hasjobgroup    ="";
	String hasjobactivity ="";
	String hascostcenter  ="";
	String hascompetency  ="";
	String hasresourcetype="";
	String hasstatus      ="";
	String hassubcompany  ="";
	String hasdepartment  ="";
	String haslocation    ="";
	String hasmanager     ="";
	String hasassistant   ="";
	String hasroles       ="";
	String hasseclevel    ="";
	String hasjoblevel    ="";
	String hasworkroom    ="";
	String hastelephone   ="";
	String hasstartdate   ="";
	String hasenddate     ="";
	String hascontractdate="";
	String hasbirthday    ="";
	String hassex         ="";
	String hasaccounttype = "";
	String hasage         ="";
	String projectable    ="";
	String crmable        ="";
	String itemable       ="";
	String docable        ="";
	String workflowable   ="";
	String subordinateable="";
	String trainable      ="";
	String budgetable     ="";
	String fnatranable    ="";
	String dspperpage     ="";
	String workplanable   ="";

	String hasworkcode = "";
	String hasjobcall = "";
	String hasmobile = "";
	String hasmobilecall = "";
	String hasfax = "";
	String hasemail = "";
	String hasfolk = "";
	String hasnativeplace = "";
	String hasregresidentplace = "";
	String hasmaritalstatus = "";
	String hascertificatenum = "";
	String hastempresidentnumber = "";
	String hasresidentplace = "";
	String hashomeaddress = "";
	String hashealthinfo = "";
	String hasheight = "";
	String hasweight = "";
	String haseducationlevel = "";
	String hasdegree = "";
	String hasusekind = "";
	String haspolicy = "";
	String hasbememberdate = "";
	String hasbepartydate = "";
	String hasislabouunion = "";
	String hasbankid1 = "";
	String hasaccountid1 = "";
	String hasaccumfundaccount = "";
	String hasloginid = "";
	String hassystemlanguage = "";

	RecordSet.executeProc("HrmUserDefine_SelectByID",""+userid);

	if(RecordSet.next()){
		   hasresourceid=RecordSet.getString("hasresourceid");
		   hasresourcename=RecordSet.getString("hasresourcename");
		   hasjobtitle    =RecordSet.getString("hasjobtitle");
		   hasactivitydesc=RecordSet.getString("hasactivitydesc");
		   hasjobgroup    =RecordSet.getString("hasjobgroup");
		   hasjobactivity =RecordSet.getString("hasjobactivity");
		   hascostcenter  =RecordSet.getString("hascostcenter");
		   hascompetency  =RecordSet.getString("hascompetency");
		   hasresourcetype=RecordSet.getString("hasresourcetype");
		   hasstatus      =RecordSet.getString("hasstatus");
		   hassubcompany  =RecordSet.getString("hassubcompany");
		   hasdepartment  =RecordSet.getString("hasdepartment");
		   haslocation    =RecordSet.getString("haslocation");
		   hasmanager     =RecordSet.getString("hasmanager");
		   hasassistant   =RecordSet.getString("hasassistant");
		   hasroles       =RecordSet.getString("hasroles");
		   hasseclevel    =RecordSet.getString("hasseclevel");
		   hasjoblevel    =RecordSet.getString("hasjoblevel");
		   hasworkroom    =RecordSet.getString("hasworkroom");
		   hastelephone   =RecordSet.getString("hastelephone");
		   hasstartdate   =RecordSet.getString("hasstartdate");
		   hasenddate     =RecordSet.getString("hasenddate");
		   hascontractdate=RecordSet.getString("hascontractdate");
		   hasbirthday    =RecordSet.getString("hasbirthday");
		   hassex         =RecordSet.getString("hassex");
		   hasaccounttype = RecordSet.getString("hasaccounttype");
		   hasage         =RecordSet.getString("hasage");
		   projectable    =RecordSet.getString("projectable");
		   crmable        =RecordSet.getString("crmable");
		   itemable       =RecordSet.getString("itemable");
		   docable        =RecordSet.getString("docable");
		   workflowable   =RecordSet.getString("workflowable");
		   subordinateable=RecordSet.getString("subordinateable");
		   trainable      =RecordSet.getString("trainable");
		   budgetable     =RecordSet.getString("budgetable");
		   fnatranable    =RecordSet.getString("fnatranable");
		   dspperpage     =RecordSet.getString("dspperpage");
		   workplanable   =RecordSet.getString("workplanable");
		   
		 hasworkcode = RecordSet.getString("hasworkcode");
		 hasjobcall = RecordSet.getString("hasjobcall");
		 hasmobile = RecordSet.getString("hasmobile");
		 hasmobilecall = RecordSet.getString("hasmobilecall");
		 hasfax = RecordSet.getString("hasfax");
		 hasemail = RecordSet.getString("hasemail");
		 hasfolk = RecordSet.getString("hasfolk");
		 hasnativeplace = RecordSet.getString("hasnativeplace");
		 hasregresidentplace = RecordSet.getString("hasregresidentplace");
		 hasmaritalstatus = RecordSet.getString("hasmaritalstatus");
		 hascertificatenum = RecordSet.getString("hascertificatenum");
		 hastempresidentnumber = RecordSet.getString("hastempresidentnumber");
		 hasresidentplace = RecordSet.getString("hasresidentplace");
		 hashomeaddress = RecordSet.getString("hashomeaddress");
		 hashealthinfo = RecordSet.getString("hashealthinfo");
		 hasheight = RecordSet.getString("hasheight");
		 hasweight = RecordSet.getString("hasweight");
		 haseducationlevel = RecordSet.getString("haseducationlevel");
		 hasdegree = RecordSet.getString("hasdegree");
		 hasusekind = RecordSet.getString("hasusekind");
		 haspolicy = RecordSet.getString("haspolicy");
		 hasbememberdate = RecordSet.getString("hasbememberdate");
		 hasbepartydate = RecordSet.getString("hasbepartydate");
		 hasislabouunion = RecordSet.getString("hasislabouunion");
		 hasbankid1 = RecordSet.getString("hasbankid1");
		 hasaccountid1 = RecordSet.getString("hasaccountid1");
		 hasaccumfundaccount = RecordSet.getString("hasaccumfundaccount");
		 hasloginid = RecordSet.getString("hasloginid");
		 hassystemlanguage = RecordSet.getString("hassystemlanguage");

	}

	String ischecked = "";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript>
			function doSave() {
				frmMain.submit();
			}
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;

			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/search/HrmResourceView.jsp?id="+userid+",_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="UserDefineOperation.jsp" method=post>
			<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())+SystemEnv.getHtmlLabelName(531,user.getLanguage())%>'>
				<wea:item>
				<%
				ischecked = "";
				if(workplanable.equals("1"))ischecked = " checked";
			  %> 
				<input type=checkbox name=workplanable value=1 <%=ischecked%>></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(2192,user.getLanguage())%></wea:item>
				<wea:item>
				<%
			   ischecked = "";
			   if(workflowable.equals("1"))ischecked = " checked";
			  %>
				<input type=checkbox name=workflowable value=1 <%=ischecked%>></wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></wea:item>
			  <wea:item>
				<%
			  ischecked = "";
			  if(docable.equals("1"))ischecked = " checked";
			  %> 
				<input type=checkbox name=docable value=1 <%=ischecked%>></wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></wea:item>
			<%if(isgoveproj==0){%>
				<wea:item>
				<%
				ischecked = "";
				if(projectable.equals("1"))ischecked = " checked";
			  %> 
				<input type=checkbox name=projectable value=1 <%=ischecked%>></wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></wea:item>             
			<%if(software.equals("ALL") || software.equals("CRM")){%>                
				<wea:item>
				<%
			  ischecked = "";
			  if(crmable.equals("1"))ischecked = " checked";
			  %>
				<input type=checkbox name=crmable value=1 <%=ischecked%>></wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></wea:item>          
			<%}%>
			<%}%>
			<%if(software.equals("ALL")){%>
				<wea:item>
				<%
				ischecked = "";
				if(itemable.equals("1"))ischecked = " checked";
			  %> 
				<input type=checkbox name=itemable value=1 <%=ischecked%>></wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></wea:item>            
			<%}%>
			  <wea:item>
				<%
				ischecked = "";
				if(subordinateable.equals("1"))ischecked = " checked";
			  %> 
				<input type=checkbox name=subordinateable value=1 <%=ischecked%>></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(442,user.getLanguage())%></wea:item>
				<%if(isgoveproj==0){%>
			  <wea:item>
				<%
				ischecked = "";
				if(budgetable.equals("1"))ischecked = " checked";
				%> 
				<input type=checkbox name=budgetable value=1 <%=ischecked%>></wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></wea:item>
				<wea:item>
				<%
			   ischecked = "";
			   if(fnatranable.equals("1"))ischecked = " checked";
			  %>
				<input type=checkbox name=fnatranable value=1 <%=ischecked%>></wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(428,user.getLanguage())%></wea:item>      
				<%}%>
			</wea:group>
			</wea:layout>
			 <input type=hidden name=userid value="<%=userid%>">
			 <input type=hidden name=hasresourceid value="<%=hasresourceid%>">
			 <input type=hidden name=hasresourcename value="<%=hasresourcename%>">
			 <input type=hidden name=hasjobtitle value="<%=hasjobtitle%>">
			 <input type=hidden name=hasactivitydesc value="<%=hasactivitydesc%>">
			 <input type=hidden name=hasjobgroup value="<%=hasjobgroup%>">
			 <input type=hidden name=hasjobactivity value="<%=hasjobactivity%>">
			 <input type=hidden name=hascostcenter value="<%=hascostcenter%>">
			 <input type=hidden name=hascompetency value="<%=hascompetency%>">
			 <input type=hidden name=hasresourcetype value="<%=hasresourcetype%>">
			 <input type=hidden name=hasstatus value="<%=hasstatus%>">
			 <input type=hidden name=hassubcompany value="<%=hassubcompany%>">
			 <input type=hidden name=hasdepartment value="<%=hasdepartment%>">
			 <input type=hidden name=haslocation value="<%=haslocation%>">
			 <input type=hidden name=hasmanager value="<%=hasmanager%>">
			 <input type=hidden name=hasassistant value="<%=hasassistant%>">
			 <input type=hidden name=hasroles value="<%=hasroles%>">
			 <input type=hidden name=hasseclevel value="<%=hasseclevel%>">
			 <input type=hidden name=hasjoblevel value="<%=hasjoblevel%>">
			 <input type=hidden name=hasworkroom value="<%=hasworkroom%>">
			 <input type=hidden name=hastelephone value="<%=hastelephone%>">
			 <input type=hidden name=hasstartdate value="<%=hasstartdate%>">
			 <input type=hidden name=hasenddate value="<%=hasenddate%>">
			 <input type=hidden name=hascontractdate value="<%=hascontractdate%>">
			 <input type=hidden name=hasbirthday value="<%=hasbirthday%>">
			 <input type=hidden name=hassex value="<%=hassex%>">
			 <input type=hidden name=hasaccounttype value="<%=hasaccounttype%>">
			 <input type=hidden name=hasage value="<%=hasage%>">
			 <input type=hidden name=hasworkcode value="<%=hasworkcode%>">
			 <input type=hidden name=hasjobcall value="<%=hasjobcall%>">
			 <input type=hidden name=hasmobile value="<%=hasmobile%>">
			 <input type=hidden name=hasmobilecall value="<%=hasmobilecall%>">
			 <input type=hidden name=hasfax value="<%=hasfax%>">
			 <input type=hidden name=hasemail value="<%=hasemail%>">
			 <input type=hidden name=hasfolk value="<%=hasfolk%>">
			 <input type=hidden name=hasnativeplace value="<%=hasnativeplace%>">
			 <input type=hidden name=hasregresidentplace value="<%=hasregresidentplace%>">
			 <input type=hidden name=hasmaritalstatus value="<%=hasmaritalstatus%>">
			 <input type=hidden name=hascertificatenum value="<%=hascertificatenum%>">
			 <input type=hidden name=hastempresidentnumber value="<%=hastempresidentnumber%>">
			 <input type=hidden name=hasresidentplace value="<%=hasresidentplace%>">
			 <input type=hidden name=hashomeaddress value="<%=hashomeaddress%>">
			 <input type=hidden name=hashealthinfo value="<%=hashealthinfo%>">
			 <input type=hidden name=hasheight value="<%=hasheight%>">
			 <input type=hidden name=hasweight value="<%=hasweight%>">
			 <input type=hidden name=haseducationlevel value="<%=haseducationlevel%>">
			 <input type=hidden name=hasdegree value="<%=hasdegree%>">
			 <input type=hidden name=hasusekind value="<%=hasusekind%>">
			 <input type=hidden name=haspolicy value="<%=haspolicy%>">
			 <input type=hidden name=hasbememberdate value="<%=hasbememberdate%>">
			 <input type=hidden name=hasbepartydate value="<%=hasbepartydate%>">
			 <input type=hidden name=hasislabouunion value="<%=hasislabouunion%>">
			 <input type=hidden name=hasbankid1 value="<%=hasbankid1%>">
			 <input type=hidden name=hasaccountid1 value="<%=hasaccountid1%>">
			 <input type=hidden name=hasaccumfundaccount value="<%=hasaccumfundaccount%>">
			 <input type=hidden name=hasloginid value="<%=hasloginid%>">
			 <input type=hidden name=dspperpage value="<%=dspperpage%>">
			 <input type=hidden name=hassystemlanguage value="<%=hassystemlanguage%>">
			 <input type=hidden name=returnurl value='<%=Util.null2String(request.getParameter("returnurl"))%>'>
		 </FORM>
	</BODY>
</HTML>
