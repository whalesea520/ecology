<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.*" %> 
<%@ page import="java.util.*" %> 

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CareerInviteComInfo" class="weaver.hrm.career.CareerInviteComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="HrmCareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="session"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CareerPlanComInfo" class="weaver.hrm.career.CareerPlanComInfo" scope="page" />
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="session" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
var dialog = parent.parent.getDialog(parent);
dialog.checkDataChange = false
function excel(){
	window.location.href="/weaver/weaver.file.ExcelOut";
}
</script>
</head>
<%
String isDialog = Util.null2String(request.getParameter("isdialog"));
String planid = Util.null2String(request.getParameter("plan"));
String sqlwhere="";

sqlwhere=HrmCareerApplyComInfo.FormatSQLSearch(user.getLanguage());

if(!planid.equals("")){

}

String sqlstr = "";
if(sqlwhere.equals("")){           
    if(!planid.equals("")){  
        sqlstr = "select * from HrmCareerApply ,HrmCareerApplyOtherInfo,HrmCareerInvite where HrmCareerApplyOtherInfo.applyid=HrmCareerApply.id and careerinviteid = HrmCareerInvite.id and HrmCareerInvite.careerplanid="+planid;
    }else{
        sqlstr = "select * from HrmCareerApply ,HrmCareerApplyOtherInfo  where HrmCareerApplyOtherInfo.applyid = HrmCareerApply.id";
    }
}else{
    if(!planid.equals("")){
        sqlstr = "select * from HrmCareerApply ,HrmCareerApplyOtherInfo,HrmCareerInvite "+sqlwhere+" and HrmCareerApplyOtherInfo.applyid = HrmCareerApply.id and careerinviteid = HrmCareerInvite.id and HrmCareerInvite.careerplanid="+planid;
    }else{
        sqlstr = "select * from HrmCareerApply ,HrmCareerApplyOtherInfo "+sqlwhere+" and HrmCareerApplyOtherInfo.applyid = HrmCareerApply.id";
    }
}

RecordSet.executeSql(sqlstr);//得出页面记录


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(773,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="submitData()" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		  <input type=button class="e8_btn_top" onclick="excel();" value="<%=SystemEnv.getHtmlLabelName(28343, user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=frmain action="HrmRpCareerApplyOperation.jsp" method=post>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
      <wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
      <wea:item><INPUT class=inputStyle maxlength=10 size=10 name="Name"  value='<%=HrmCareerApplyComInfo.getName()%>'></wea:item>  
      <wea:item><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%></wea:item>
      <wea:item>
		    <brow:browser viewType="0" name="plan" browserValue='<%=planid %>' 
		      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/career/careerplan/CareerPlanBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
		      completeUrl="/data.jsp?type=164" width="250px"
		      browserSpanValue='<%=CareerPlanComInfo.getCareerPlantopic(planid)%>'>
		   	</brow:browser>
      </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></wea:item>
     <wea:item> 
       <input class=inputStyle value="<%=HrmCareerApplyComInfo.getCareerAgeFrom()%>" maxlength=10 size=5 name=CareerAgeFrom style="width: 80px" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(CareerAgeFrom)'>-
       <input class=inputStyle value="<%=HrmCareerApplyComInfo.getCareerAgeTo()%>" maxlength=10  size=5 name=CareerAgeTo style="width: 80px" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(CareerAgeTo)'>
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(1855,user.getLanguage())%></wea:item>
     <wea:item>
     <%
      String fromdateselect =	HrmCareerApplyComInfo.getFromdateselect();
      String fromdate =	HrmCareerApplyComInfo.getFromDate();
      String enddate =	HrmCareerApplyComInfo.getEndDate();
     %>
     	<select name="fromdateselect" id="fromdateselect" onchange="changeDate(this,'spanFromdate');" style="width: 135px">
	    		<option value="0" <%=fromdateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	    		<option value="1" <%=fromdateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
	    		<option value="2" <%=fromdateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
	    		<option value="3" <%=fromdateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
	    		<option value="4" <%=fromdateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
	    		<option value="5" <%=fromdateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
	    		<option value="6" <%=fromdateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
    	</select>
       <span id=spanFromdate style="<%=fromdateselect.equals("6")?"":"display:none;" %>">
      		<BUTTON class=Calendar type="button" id=selectFromdate onclick="getDate(fromdatespan,fromdate)"></BUTTON>
       		<SPAN id=fromdatespan ><%=fromdate%></SPAN>－
       		<BUTTON class=Calendar type="button" id=selectEnddate onclick="getDate(enddatespan,enddate)"></BUTTON>
       		<SPAN id=enddatespan ><%=enddate%></SPAN>
       </span>
       <input class=inputstyle type="hidden" id="fromdate" name="fromdate" value="<%=fromdate%>">
       <input class=inputstyle type="hidden" id="enddate" name="enddate" value="<%=enddate%>"> 
     </wea:item>  
     <wea:item><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></wea:item>
     <wea:item> 
       <select class=inputStyle id=Sex name=Sex>  
         <option value=""></option>
         <option value=0 <%=HrmCareerApplyComInfo.getSex().equals("0")?"selected":""%> ><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
         <option value=1 <%=HrmCareerApplyComInfo.getSex().equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>         
       </select>
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%></wea:item>
     <wea:item> 
      <input class=inputStyle maxlength=10 size=5 name=WorkTimeFrom style="width: 80px" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("WorkTimeFrom")' value="<%=HrmCareerApplyComInfo.getWorkTimeFrom()%>">-<input class=inputStyle style="width: 80px"  maxlength=10  size=5 name=WorkTimeTo onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("WorkTimeTo")' value="<%=HrmCareerApplyComInfo.getWorkTimeTo()%>"> 
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></wea:item>
     <wea:item> 
       <SELECT class=inputStyle id=MaritalStatus name=MaritalStatus>			
         <OPTION value=""></OPTION>		   
         <OPTION value=0 <%=HrmCareerApplyComInfo.getMaritalStatus().equals("0")?"selected":""%>><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%></OPTION>
         <OPTION value=1 <%=HrmCareerApplyComInfo.getMaritalStatus().equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%></OPTION>	   
       </SELECT>
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(15675,user.getLanguage())%></wea:item>
     <wea:item> 
       <select class=inputStyle id=Category name=Category>	
       	 <option value=""></option>	    
         <option value="0" <%=HrmCareerApplyComInfo.getCategory().equals("0")?"selected":""%>><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></option>
         <option value="1" <%=HrmCareerApplyComInfo.getCategory().equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(1830,user.getLanguage())%></option>
         <option value="2" <%=HrmCareerApplyComInfo.getCategory().equals("2")?"selected":""%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
         <option value="3" <%=HrmCareerApplyComInfo.getCategory().equals("3")?"selected":""%>><%=SystemEnv.getHtmlLabelName(1832,user.getLanguage())%></option>
       </select>
     </wea:item>     
     <wea:item><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></wea:item>
     <wea:item> 
      <input class=inputStyle maxlength=25 size=25 name=RegResidentPlace value="<%=HrmCareerApplyComInfo.getRegResidentPlace()%>">
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(15673,user.getLanguage())%></wea:item>
     <wea:item>
       <input class=inputStyle maxlength=10 size=5 value="<%=HrmCareerApplyComInfo.getSalaryNeedFrom()%>" name=SalaryNeedFrom style="width: 80px" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=HrmCareerApplyComInfo.getSalaryNeedFrom()%>">-
       <input class=inputStyle maxlength=10  size=5 value="<%=HrmCareerApplyComInfo.getSalaryNeedTo()%>" name=SalaryNeedTo style="width: 80px" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=HrmCareerApplyComInfo.getSalaryNeedTo()%>">
     </wea:item>        
     <wea:item><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%></wea:item>
      <wea:item>  
      	<brow:browser viewType="0" name="jobtitle" browserValue='<%=HrmCareerApplyComInfo.getJobTitle()%>' 
		      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
		      completeUrl="/data.jsp?type=hrmjobtitles" width="250px"
		      browserSpanValue='<%=JobTitlesComInfo.getJobTitlesname(HrmCareerApplyComInfo.getJobTitle())%>'>
		   	</brow:browser>
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></wea:item>
     <wea:item>
         <brow:browser viewType="0" name="EducationLevel" browserValue='<%=HrmCareerApplyComInfo.getEducationLevel()%>' 
		      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
		      completeUrl="/data.jsp?type=educationlevel" width="250px"
		      browserSpanValue='<%=EduLevelComInfo.getEducationLevelname(HrmCareerApplyComInfo.getEducationLevel())%>'>
		   	</brow:browser>
     </wea:item>     
	</wea:group>
</wea:layout>
 </FORM>
<%   
   ExcelFile.init ();
   String filename = Util.toScreen(""+SystemEnv.getHtmlLabelName(83538,user.getLanguage()),user.getLanguage(),"0");
   ExcelFile.setFilename(""+filename) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(""+filename) ;
   
   ExcelRow er = null ;
   er = et.newExcelRow() ;
   er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(15671,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(1844,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(15673,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(15675,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(1855,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(416,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(464,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(15683,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(469,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(818,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(1837,user.getLanguage()),"Header") ;   
%>   
    <TABLE class=ListStyle cellspacing=1 style="display: none">
        <TBODY>
        <TR class=Header>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(773,user.getLanguage())%></TH>
        </TR>
        </TBODY>
    </TABLE>
    <TABLE class=ListStyle cellspacing=1 style="display: none">
        <THEAD>
        <COLGROUP>
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
        <TR class=Header>        
            <TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(15673,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(15931,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(1855,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></TH>            
            <TH><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></TH>
        </TR>
        <TR class=Line><TD colspan="12" ></TD></TR> 
        </THEAD>
<%
HrmCareerApplyComInfo.resetSearchInfo();
    boolean islight=true;
    int totalline=1;
    while(RecordSet.next()){
        ExcelRow erdep = et.newExcelRow() ;         
        String lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage());
        
        //String jobtitle = Util.toScreen(JobTitlesComInfo.getJobTitlesname(RecordSet.getString("jobtitle")),user.getLanguage());        
        rs.executeSql("SELECT b.id, b.jobtitlename FROM HrmCareerInvite a, HrmJobTitles b where a.careername=b.id and a.id="+Util.getIntValue(RecordSet.getString("jobtitle")));
        rs.next();
        String jobtitlename = Util.null2String(rs.getString("jobtitlename"));
        
        String worktime = Util.toScreen(RecordSet.getString("worktime"),user.getLanguage());
        String salaryneed = Util.toScreen(RecordSet.getString("salaryneed"),user.getLanguage());
        int category = Util.getIntValue(RecordSet.getString("category"));
        String categorystr = "";
             if(category==0){ 
                categorystr = SystemEnv.getHtmlLabelName(134,user.getLanguage());
             }
             if(category==1){ 
                categorystr = SystemEnv.getHtmlLabelName(1830,user.getLanguage());
             }
             if(category==2){ 
                categorystr = SystemEnv.getHtmlLabelName(1831,user.getLanguage());
             }
             if(category==3){ 
                categorystr = SystemEnv.getHtmlLabelName(1832,user.getLanguage());
             }             
        String createdate = Util.toScreen(RecordSet.getString("createdate"),user.getLanguage());        
        String sex = Util.null2String(RecordSet.getString("sex")) ; 
        String sexstr = "";
        if (sex.equals("0")) sexstr = SystemEnv.getHtmlLabelName(417,user.getLanguage());
        if (sex.equals("1")) sexstr = SystemEnv.getHtmlLabelName(418,user.getLanguage());
        String applydate = Util.null2String(RecordSet.getString("createdate")) ;
        String regresidentplace = Util.toScreen(RecordSet.getString("regresidentplace"),user.getLanguage());
        int MaritalStatus = Util.getIntValue(RecordSet.getString("MaritalStatus"));
        String MaritalStatusstr = "";
        if(MaritalStatus==0){ 
            MaritalStatusstr = SystemEnv.getHtmlLabelName(470,user.getLanguage());
        }
        if(MaritalStatus==1){ 
            MaritalStatusstr = SystemEnv.getHtmlLabelName(471,user.getLanguage());
        }
        String educationlevel = Util.null2String(RecordSet.getString("educationlevel")) ; 
        String edulevel = Util.toScreen(EduLevelComInfo.getEducationLevelname(educationlevel),user.getLanguage());
        String policy = Util.toScreen(RecordSet.getString("policy"),user.getLanguage());
        
        erdep.addStringValue(lastname);
        erdep.addStringValue(jobtitlename);
        erdep.addStringValue(worktime);
        erdep.addStringValue(salaryneed);
        erdep.addStringValue(categorystr);
        erdep.addStringValue(createdate);
        erdep.addStringValue(sexstr);
        erdep.addStringValue(applydate);
        erdep.addStringValue(regresidentplace);
        erdep.addStringValue(MaritalStatusstr);
        erdep.addStringValue(edulevel);
        erdep.addStringValue(policy);        
%>
        <tr <%if(islight){%> class=datalight <%}else {%> class=datadark <%}%>>            
            <TD>
                <A HREF="/hrm/career/HrmCareerApplyEdit.jsp?applyid=<%=RecordSet.getString("id")%>"><%=lastname%></A>
            </TD>
            <td><%=jobtitlename%></td>
            <td><%=worktime%></td>
            <td><%=salaryneed%></td>
            <td><%=categorystr%></td>
            <td><%=createdate%></td>
            <TD><%=sexstr%></TD>
            <TD><%=applydate%></TD>
            <TD><%=regresidentplace%></TD>
            <TD><%=MaritalStatusstr%></TD>
            <TD><%=edulevel%></TD>
            <TD><%=policy%></TD>            
        </tr>
<%
    islight=!islight;       
    }
%>
</TABLE>
<wea:layout type="diycol">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15101,356",user.getLanguage())%>' >
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<%
				request.getSession().setAttribute("et",et);
				String tableString =" <table datasource=\"weaver.hrm.HrmDataSource.getHrmCareerApplyReport\" sourceparams=\"\" pageId=\""+PageIdConst.Hrm_RpCareerApply+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Hrm_RpCareerApply,user.getUID(),PageIdConst.HRM)+"\" tabletype=\"none\">"+
					" <sql backfields=\"*\" sqlform=\"temp\" sqlwhere=\"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"/>"+
				"	<head>";
				er = et.getExcelRow(0);
		  	for(int i=0;er!=null&&i<er.size();i++){
					tableString+="		<col width=\"30%\" text=\""+er.getValue(i).replace("s_","")+"\" column=\""+i+"\" />";
			  }
				tableString+="	</head></table>";
			%>
						<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.Hrm_RpUseDemand %>"/>
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
		</wea:item>
	</wea:group>
</wea:layout>
   <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</SCRIPT>
<SCRIPT language="javascript">
function OnSubmit(){
		document.frmain.submit();
}
function submitData() {
 frmain.submit();
}

</script>
 </BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
