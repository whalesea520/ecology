<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.StaticObj"%> 
<jsp:include page="/systeminfo/init_wev8.jsp" />

<%
User user = HrmUserVarify.getUser (request , response) ;
int isIncludeToptitle = 0 ;
String software = (String) StaticObj.getInstance().getObject("software") ;
%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
 parent.setTabObjName('<%=SystemEnv.getHtmlLabelName(32668,user.getLanguage())%>')
</script>
</head>
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
String hasvirtualdepartment = "";
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
String hasgroup = "";

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
	 hasvirtualdepartment = RecordSet.getString("hasvirtualdepartment");
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

   	 hasgroup =Util.fromScreen(RecordSet.getString("hasgroup"),user.getLanguage());
   	 
}

String ischecked = "";

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(343,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<jsp:include page="HrmUserDefine_click.jsp" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		  <input type=button class="e8_btn_top" onclick="submitData()" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="UserDefineOperation.jsp" method=post>
<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("1361",user.getLanguage())%>'>
		<wea:item>
			<%
       ischecked = "";
       if(hasworkcode.equals("1"))ischecked = " checked";
      %>
			<input type=checkbox name=hasworkcode value=1 <%=ischecked%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
		<wea:item>
			<%
      	ischecked = "";
        if(hasresourcename.equals("1")) ischecked = " checked";
    	%> 
			<input type=checkbox name=hasresourcename value=1 <%=ischecked%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
		<wea:item>
			<%
	      ischecked = "";
	      if(hassex.equals("1"))ischecked = " checked";
	    %> 
			<input type=checkbox name=hassex value=1 <%=ischecked%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></wea:item>
		<%if(flagaccount) {%>
		<wea:item>
		<%
      ischecked = "";
      if(hasaccounttype.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasaccounttype value=1 <%=ischecked%>></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17745,user.getLanguage())%></wea:item>
		<%}%>
		<wea:item>
		<%
    	ischecked = "";
      if(hasdepartment.equals("1"))ischecked = " checked";
    %>  
		<input type=checkbox name=hasdepartment value=1 <%=ischecked%>>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		<wea:item>
		<%
    	ischecked = "";
      if(hassubcompany.equals("1")) ischecked = " checked";
    %> 
		<input type=checkbox name=hassubcompany value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
    <wea:item>
    <%
    	ischecked = "";
      if(hasstatus.equals("1"))	ischecked = " checked";
    %> 
		<input type=checkbox name=hasstatus value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>  
    <wea:item>
    <%
    	ischecked = "";
      if(hasjobtitle.equals("1"))ischecked = " checked";
    %>  
		<input type=checkbox name=hasjobtitle value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item> 
    <wea:item>
		<%
      ischecked = "";
      if(hasactivitydesc.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasactivitydesc value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15856,user.getLanguage())%></wea:item>
    <wea:item>
	  <%
    	ischecked = "";
			if(hasjobgroup.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasjobgroup value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></wea:item>   
		<wea:item> 
    <%
   		ischecked = "";
   		if(hasjobactivity.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasjobactivity value=1 <%=ischecked%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></wea:item>
    <wea:item>
		<%
    	ischecked = "";
			if(hasjobcall.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasjobcall value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></wea:item>
		<wea:item>
		<%
     	ischecked = "";
      if(hasjoblevel.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasjoblevel value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></wea:item>
  	<wea:item>
		<%
      ischecked = "";
      if(hasmanager.equals("1"))ischecked = " checked";
    %>
    <input type=checkbox name=hasmanager value=1 <%=ischecked%>>
    </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></wea:item>        
		<wea:item>
		<%
    	ischecked = "";
      if(hasassistant.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasassistant value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></wea:item>   
    <wea:item>
		<%
      ischecked = "";
      if(haslocation.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=haslocation value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></wea:item>
		<wea:item>
		<%
      ischecked = "";
      if(hasworkroom.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasworkroom value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></wea:item>      
    <wea:item>
		<%
     	ischecked = "";
      if(hastelephone.equals("1"))ischecked = " checked";
    %>
		<input type=checkbox name=hastelephone value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%></wea:item>         
    <wea:item>
    <%
    	ischecked = "";
      if(hasmobile.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasmobile value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></wea:item>
 		<wea:item>
		<%
    	ischecked = "";
      if(hasmobilecall.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasmobilecall value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></wea:item>
		<wea:item>
		<%
			ischecked = "";
			if(hasfax.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasfax value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></wea:item>
		<wea:item>
		<%
    	ischecked = "";
      if(hasemail.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasemail value=1 <%=ischecked%>>
		</wea:item>
    <wea:item>E-mail</wea:item> 
   	<wea:item>
		<%
    	ischecked = "";
      if(hasvirtualdepartment.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasvirtualdepartment value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(34069,user.getLanguage())%></wea:item>    
	<%
  ischecked = "";
  if(hasgroup.equals("1"))ischecked = " checked";
  %> 
<wea:item>
	<input type=checkbox name=hasgroup value=1 <%=ischecked%>>
</wea:item>
  	<wea:item><%=SystemEnv.getHtmlLabelName(81554,user.getLanguage())%></wea:item>                     
	</wea:group>
	<%
  if(software.equals("ALL") || software.equals("HRM")){
     if(ishr){
	%>   
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%>'>
		<wea:item>
		<%
    	ischecked = "";
      if(hasbirthday.equals("1"))ischecked = " checked";
    %>
		<input type=checkbox name=hasbirthday value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></wea:item>
    <wea:item>
		<%
    	ischecked = "";
      if(hasage.equals("1"))ischecked = " checked";
    %>
	  <input type=checkbox name=hasage value=1 <%=ischecked%>>
	  </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></wea:item>
    <wea:item>
	  <%
    	ischecked = "";
    	if(hasfolk.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasfolk value=1 <%=ischecked%>></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></wea:item>
		<wea:item>
		<%
    	ischecked = "";
    	if(hasnativeplace.equals("1"))ischecked = " checked";
    %>
		<input type=checkbox name=hasnativeplace value=1 <%=ischecked%>></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></wea:item>
    <wea:item>
		<%
   		ischecked = "";
      if(hasregresidentplace.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasregresidentplace value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></wea:item>
		<wea:item>
		<%
    	ischecked = "";
      if(hasmaritalstatus.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasmaritalstatus value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></wea:item>
 		<wea:item>
		<%
    	ischecked = "";
      if(hascertificatenum.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hascertificatenum value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></wea:item>
 		<wea:item>
		<%
			ischecked = "";
			if(hastempresidentnumber.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hastempresidentnumber value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15685,user.getLanguage())%></wea:item>                          
    <wea:item>
		<%
    	ischecked = "";
      if(hasresidentplace.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasresidentplace value=1 <%=ischecked%>></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></wea:item>
  	<wea:item>
		<%
    ischecked = "";
    if(hashomeaddress.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hashomeaddress value=1 <%=ischecked%>></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(16018,user.getLanguage())%></wea:item>
		<wea:item>
		<%
    	ischecked = "";
      if(hashealthinfo.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hashealthinfo value=1 <%=ischecked%>></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></wea:item>
   	<wea:item>
		<%
    	ischecked = "";
      if(hasheight.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasheight value=1 <%=ischecked%>></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></wea:item>
 		<wea:item>
		<%
    	ischecked = "";
      if(hasweight.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasweight value=1 <%=ischecked%>></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15674,user.getLanguage())%></wea:item>           
    <wea:item>
		<%
    ischecked = "";
    if(haseducationlevel.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=haseducationlevel value=1 <%=ischecked%>></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></wea:item>      
    <wea:item>
		<%
    ischecked = "";
    if(hasdegree.equals("1"))ischecked = " checked";
    %>
		<input type=checkbox name=hasdegree value=1 <%=ischecked%>></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></wea:item>
		<wea:item>
		<%
    ischecked = "";
    if(hasusekind.equals("1"))ischecked = " checked";
    %>
		<input type=checkbox name=hasusekind value=1 <%=ischecked%>></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></wea:item>
		<wea:item>
		<%
     ischecked = "";
     if(haspolicy.equals("1"))ischecked = " checked";
    %>
		<input type=checkbox name=haspolicy	 value=1 <%=ischecked%>></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></wea:item>
    <wea:item>
		<%
    ischecked = "";
    if(hasbememberdate.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasbememberdate value=1 <%=ischecked%>></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1834,user.getLanguage())%></wea:item>      
    <wea:item>
		<%
    ischecked = "";
    if(hasbepartydate.equals("1"))ischecked = " checked";
  	%>
		<input type=checkbox name=hasbepartydate value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1835,user.getLanguage())%></wea:item>           
    <wea:item>
		<%
    ischecked = "";
    if(hasroles.equals("1"))ischecked = " checked";
    %>
		<input type=checkbox name=hasroles value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>           
    <wea:item>
		<%
    ischecked = "";
    if(hasislabouunion.equals("1"))ischecked = " checked";
    %>
		<input type=checkbox name=hasislabouunion value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15684,user.getLanguage())%></wea:item>
		<wea:item>
		<%
    ischecked = "";
    if(hasstartdate.equals("1"))ischecked = " checked";
    %>
		<input type=checkbox name=hasstartdate value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></wea:item>
		<wea:item>
		<%
    ischecked = "";
    if(hasenddate.equals("1"))ischecked = " checked";
    %> 
		<input type=checkbox name=hasenddate value=1 <%=ischecked%>>
		</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></wea:item>        
    <wea:item>
		<%
    ischecked = "";
    if(hascontractdate.equals("1"))ischecked = " checked";
    %>
		<input type=checkbox name=hascontractdate value=1 <%=ischecked%>>
		</wea:item>
  	<wea:item><%=SystemEnv.getHtmlLabelName(15778,user.getLanguage())%></wea:item>
	</wea:group>
	<%
	}
	%>
	<%
  if(isgoveproj==0){
  if( ishr || isfin ) {
	%>  
<wea:group context='<%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%>'>
	<wea:item>
	<%
    ischecked = "";
    if(hasbankid1.equals("1"))ischecked = " checked";
  %> 
	<input type=checkbox name=hasbankid1 value=1 <%=ischecked%>> </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%></wea:item>
	<wea:item>
	<%
    ischecked = "";
    if(hasaccountid1.equals("1"))ischecked = " checked";
  %> 
	<input type=checkbox name=hasaccountid1 value=1 <%=ischecked%>></wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(16016,user.getLanguage())%></wea:item>
	<wea:item>
	<%
		ischecked = "";
		if(hasaccumfundaccount.equals("1"))ischecked = " checked";
	%> 
	<input type=checkbox name=hasaccumfundaccount value=1 <%=ischecked%>></wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(1939,user.getLanguage())%></wea:item> 
</wea:group>
<%
  }
}
}
%>
<%
  if(issys || ishr){
%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%>'>
<wea:item>
	<%
  ischecked = "";
  if(hasseclevel.equals("1"))ischecked = " checked";
  %> 
	<input type=checkbox name=hasseclevel value=1 <%=ischecked%>></wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
  <wea:item>
	<%
  	ischecked = "";
    if(hasloginid.equals("1"))ischecked = " checked";
  %> 
	<input type=checkbox name=hasloginid value=1 <%=ischecked%>></wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(16126,user.getLanguage())%></wea:item>
  <wea:item>
	<%
 		ischecked = "";
   	if(hassystemlanguage.equals("1"))ischecked = " checked";
  %> 
	<input type=checkbox name=hassystemlanguage value=1 <%=ischecked%>></wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%></wea:item> 
</wea:group> 
<%
  }
%> 
<wea:group context='<%=SystemEnv.getHtmlLabelName(321,user.getLanguage())%>' attributes="{'samePair':'dspperpage'}">
	<wea:item> 
  <input type="text" class=InputStyle name="dspperpage" value=<%=dspperpage%> size="3" maxlength=2 onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)'>
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%></wea:item>
</wea:group>
</wea:layout>
 <input type=hidden name=userid value="<%=userid%>">
 <input type=hidden name=projectable value="<%=projectable%>">
 <input type=hidden name=crmable value="<%=crmable%>">
 <input type=hidden name=itemable value="<%=itemable%>">
 <input type=hidden name=docable value="<%=docable%>">
 <input type=hidden name=workflowable value="<%=workflowable%>">
 <input type=hidden name=subordinateable value="<%=subordinateable%>">
 <input type=hidden name=budgetable value="<%=budgetable%>">
 <input type=hidden name=fnatranable value="<%=fnatranable%>">
 <input type=hidden name=dspperpage value="<%=dspperpage%>">
 <input type=hidden name=workplanable value="<%=workplanable%>">
 <input type=hidden name=returnurl value='<%=Util.null2String(request.getParameter("returnurl"))%>'>
 </FORM>
</BODY></HTML>
<script language=javascript>
function submitData() {
 frmMain.submit();
}
hideGroup("dspperpage");
</script>
