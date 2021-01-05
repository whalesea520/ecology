<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="SpecialityComInfo" class="weaver.hrm.job.SpecialityComInfo" scope="page" />
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
LinkedHashMap ht = new LinkedHashMap();
 String id = request.getParameter("id");
  int scopeId = 3;
  String sql = "";

%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
    	getLine:1,
    	image:false,
    	needLine:false,
    	needTopTitle:false,
    	needInitBoxHeight:true,
    	needNotCalHeight:true
    });
});
</script>

<!-- tab 测试 -->
<div class="e8_box">
   <ul class="tab_menu">
   		<%if(HrmListValidate.isValidate(50)){ %>
       	<li class="current">
        	<a href="javascript:void('0');" onclick="jsChangeTab('HrmRelatedContract')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(6161,user.getLanguage()) %>
        	</a>
        </li>
      <%}if(HrmListValidate.isValidate(51)){ %>
        <li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('HrmStatusHistory')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(16136,user.getLanguage()) %>
        	</a>
        </li>
      <%}if(HrmListValidate.isValidate(52)){ %>
				<li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('HrmLanguageAbility')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(815,user.getLanguage()) %>
        	</a>
        </li>
      <%}if(HrmListValidate.isValidate(53)){ %>
        <li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('HrmEducationInfo')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(813,user.getLanguage()) %>
        	</a>
        </li>
     	<%}if(HrmListValidate.isValidate(54)){ %>
       	<li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('HrmWorkResume')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(15716,user.getLanguage()) %>
        	</a>
        </li>
      <%}if(HrmListValidate.isValidate(55)){ %> 
        <li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('HrmTrainBeforeWork')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(15717,user.getLanguage()) %>
        	</a>
        </li>
      <%}if(HrmListValidate.isValidate(56)){ %>  
        <li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('HrmCertification')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(1502,user.getLanguage()) %>
        	</a>
        </li>
      <%}if(HrmListValidate.isValidate(57)){ %>  
        <li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('HrmRewardBeforeWork')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(15718,user.getLanguage()) %>
        	</a>
        </li>
       <%}%>
        <% 
        RecordSet.executeSql("select id, formlabel from cus_treeform where parentid="+scopeId+" order by scopeorder");
        while(RecordSet.next()){
            int subId = RecordSet.getInt("id");
            ht.put(("cus_list_"+subId),RecordSet.getString("formlabel"));
        }
        Iterator iter = ht.entrySet().iterator();
				while (iter.hasNext()){
				Map.Entry entry = (Map.Entry) iter.next();
      	String key = (String)entry.getKey();
     		String val = (String)entry.getValue();
     		if(HrmListValidate.isValidate(58)){
     		%>
     		 <li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('<%=key %>')" target="_self"><%=val%></a>
         </li>
     		<%} }%>
   </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    <div class="tab_box">
	    
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
  <%if(HrmListValidate.isValidate(50)){%>
  <wea:group context='<%=SystemEnv.getHtmlLabelName(6161,user.getLanguage())%>' attributes="{'samePair':'HrmRelatedContract','groupOperDisplay':'none'}">
		<wea:item attributes="{'colspan':'2','isTableList':'true'}">
			<jsp:include page="HrmRelatedContract.jsp">
			<jsp:param name="id" value="<%=id%>"/></jsp:include>
		</wea:item>
	</wea:group>
	<%} %>
	<%
		if(HrmListValidate.isValidate(51)){
	  sql = "select * from HrmStatusHistory where resourceid = "+id+" order by changedate";
	  rs.executeSql(sql);
	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16136,user.getLanguage())%>' attributes="{'samePair':'HrmStatusHistory','groupOperDisplay':'none'}">
	<wea:item attributes="{'colspan':'2','isTableList':'true'}">
	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'5','cws':'16%,16%,16%,16%,36%','expandAllGroup':'true'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(16041,user.getLanguage())%></wea:item>
	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(16137,user.getLanguage())%></wea:item>
	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></wea:item>
	<%
	  while(rs.next()){
	    int type = Util.getIntValue(rs.getString("type_n"));
	    String olddepid = Util.null2String(rs.getString("oldjobtitleid"));
	    if(type == 4){
	      olddepid = Util.null2String(rs.getString("newjobtitleid"));
	    }
		String changedate = Util.null2String(rs.getString("changedate"));
		String changereason = Util.null2String(rs.getString("changereason"));
		String operator = ResourceComInfo.getLastname(""+Util.getIntValue(rs.getString("operator"), 0));
	%>
	<wea:item>
		<%if(type == 1){%><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%><%}%>
		<%if(type == 2){%><%=SystemEnv.getHtmlLabelName(6088,user.getLanguage())%><%}%>
		<%if(type == 3){%><%=SystemEnv.getHtmlLabelName(6089,user.getLanguage())%><%}%>
		<%if(type == 4){%><%=SystemEnv.getHtmlLabelName(6090,user.getLanguage())%><%}%>
		<%if(type == 5){%><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%><%}%>
		<%if(type == 6){%><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%><%}%>
		<%if(type == 7){%><%=SystemEnv.getHtmlLabelName(6093,user.getLanguage())%><%}%>
		<%if(type == 8){%><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%><%}%>
	</wea:item>
	<wea:item><%=JobTitlesComInfo.getJobTitlesname(olddepid)%></wea:item>
	<wea:item><%=changedate%></wea:item>
	<wea:item><%=changereason%></wea:item>
	<wea:item><%=operator%></wea:item>
	<%}%>
	</wea:group>
	</wea:layout>
	 </wea:item>
	 </wea:group>
		<%} %>
		<%
		if(HrmListValidate.isValidate(52)){
		  sql = "select * from HrmLanguageAbility where resourceid = "+id+" order by id";
		  rs.executeSql(sql);
		%>
		 <wea:group context='<%=SystemEnv.getHtmlLabelName(815,user.getLanguage())%>' attributes="{'samePair':'HrmLanguageAbility','groupOperDisplay':'none'}">
			<wea:item attributes="{'colspan':'2','isTableList':'true'}">
		 	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'3','cws':'16%,16%,68%','expandAllGroup':'true'}">
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></wea:item>
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15715,user.getLanguage())%></wea:item>
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item> 
		<%
		  while(rs.next()){
		    String language = Util.null2String(rs.getString("language"));
			String level = Util.null2String(rs.getString("level_n"));
			String memo = Util.null2String(rs.getString("memo"));
		%>
			<wea:item><%=language%></wea:item>
			<wea:item>
				<%if (level.equals("0")) {%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%><%}%>
				<%if (level.equals("1")) {%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%><%}%>
				<%if (level.equals("2")) {%><%=SystemEnv.getHtmlLabelName(822,user.getLanguage())%><%}%>
				<%if (level.equals("3")) {%><%=SystemEnv.getHtmlLabelName(823,user.getLanguage())%><%}%>
		  </wea:item>
			<wea:item><%=memo%></wea:item>
		<%
		  }
		%>
		</wea:group>
		</wea:layout>
		 </wea:item>
		 </wea:group>
	<%} %>
	<%
		if(HrmListValidate.isValidate(53)){
	  sql = "select * from HrmEducationInfo where resourceid = "+id+" order by id";
	  rs.executeSql(sql);
	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(813,user.getLanguage())%>' attributes="{'samePair':'HrmEducationInfo','groupOperDisplay':'none'}">
	<wea:item attributes="{'colspan':'2','isTableList':'true'}">
	 	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'6','cws':'16%,16%,16%,16%,16%,20%','expandAllGroup':'true'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
		  <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1903,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(803,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1942,user.getLanguage())%></wea:item>
	<%
	  while(rs.next()){
	    String startdate = Util.null2String(rs.getString("startdate"));
		String enddate = Util.null2String(rs.getString("enddate"));
		String school = Util.null2String(rs.getString("school"));
		String speciality = Util.null2String(rs.getString("speciality"));
		String educationlevel = Util.null2String(rs.getString("educationlevel"));
		String studydesc = Util.null2String(rs.getString("studydesc"));
	%>
	<wea:item><%=school%></wea:item>
	<wea:item><%=SpecialityComInfo.getSpecialityname(speciality)%></wea:item>
	<wea:item><%=startdate%></wea:item>
	<wea:item><%=enddate%></wea:item>
	<wea:item><%=EducationLevelComInfo.getEducationLevelname(educationlevel)%></wea:item>
	<wea:item><%=studydesc%></wea:item>
	<%
	  }
	%>
	</wea:group>
	</wea:layout>
	</wea:item>
	</wea:group>
	<%} %>
	<%
	if(HrmListValidate.isValidate(54)){
	  sql = "select * from HrmWorkResume where resourceid = "+id+" order by id";
	  rs.executeSql(sql);
	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15716,user.getLanguage())%>' attributes="{'samePair':'HrmWorkResume','groupOperDisplay':'none'}">
	<wea:item attributes="{'colspan':'2','isTableList':'true'}">
	 	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'6','cws':'16%,16%,16%,16%,16%,20%','expandAllGroup':'true'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
		  <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1977,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15676,user.getLanguage())%></wea:item>
	<%
	  while(rs.next()){
	    String startdate = Util.null2String(rs.getString("startdate"));
		String enddate = Util.null2String(rs.getString("enddate"));
		String company = Util.null2String(rs.getString("company"));
		String jobtitle = Util.null2String(rs.getString("jobtitle"));
		String leavereason = Util.null2String(rs.getString("leavereason"));
		String workdesc = Util.null2String(rs.getString("workdesc"));
	%>
	<wea:item><%=company%></wea:item>
	<wea:item><%=startdate%></wea:item>
	<wea:item><%=enddate%></wea:item>
	<wea:item><%=jobtitle%></wea:item>
	<wea:item><%=workdesc%></wea:item>
	<wea:item><%=leavereason%></wea:item>
	<%
	  }
	%>
	</wea:group>
	</wea:layout>
	</wea:item>
	</wea:group>
	<%} %>
	<%
	if(HrmListValidate.isValidate(55)){
	  sql = "select * from HrmTrainBeforeWork where resourceid = "+id+" order by id";
	  rs.executeSql(sql);
	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15717,user.getLanguage())%>' attributes="{'samePair':'HrmTrainBeforeWork','groupOperDisplay':'none'}">
	<wea:item attributes="{'colspan':'2','isTableList':'true'}">
	 	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'5','cws':'16%,16%,16%,16%,36%','expandAllGroup':'true'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15678,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1974,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
	<%
	  while(rs.next()){
	    String startdate = Util.null2String(rs.getString("trainstartdate"));
		String enddate = Util.null2String(rs.getString("trainenddate"));
		String trainname = Util.null2String(rs.getString("trainname"));
		String trainresource = Util.null2String(rs.getString("trainresource"));
		String trainmemo = Util.null2String(rs.getString("trainmemo"));
	%>
	<wea:item><%=trainname%></wea:item>
	<wea:item><%=startdate%></wea:item>
	<wea:item><%=enddate%></wea:item>
	<wea:item><%=trainresource%></wea:item>
	<wea:item><%=trainmemo%></wea:item>
	<%
	  }
	%>
	 </wea:group>
	 </wea:layout>
	 </wea:item>
	 </wea:group>
	<%} %>
	<%
	if(HrmListValidate.isValidate(56)){
	  sql = "select * from HrmCertification where resourceid = "+id+" order by id";
	  rs.executeSql(sql);
	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1502,user.getLanguage())%>' attributes="{'samePair':'HrmCertification','groupOperDisplay':'none'}">
	<wea:item attributes="{'colspan':'2','isTableList':'true'}">
	 	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'4','cws':'16%,16%,16%,52%','expandAllGroup':'true'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15681,user.getLanguage())%></wea:item>
	<%
	  while(rs.next()){
	    String startdate = Util.null2String(rs.getString("datefrom"));
		String enddate = Util.null2String(rs.getString("dateto"));
		String cername = Util.null2String(rs.getString("certname"));
		String cerresource = Util.null2String(rs.getString("awardfrom"));
	
	%>
	<wea:item><%=cername%></wea:item>
	<wea:item><%=startdate%></wea:item>
	<wea:item><%=enddate%></wea:item>
	<wea:item><%=cerresource%></wea:item>
	<%
	  }
	%>
	</wea:group>
	</wea:layout>
	</wea:item>
	</wea:group>
	<%} %>
	<%
		if(HrmListValidate.isValidate(57)){
	  sql = "select * from HrmRewardBeforeWork where resourceid = "+id+" order by id";
	  rs.executeSql(sql);
	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15718,user.getLanguage())%>' attributes="{'samePair':'HrmRewardBeforeWork','groupOperDisplay':'none'}">
	<wea:item attributes="{'colspan':'2','isTableList':'true'}">
	 	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'3','cws':'16%,16%,68%','expandAllGroup':'true'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
		  <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15666,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1962,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
	<%
	  while(rs.next()){
	    String rewarddate = Util.null2String(rs.getString("rewarddate"));
		String rewardname = Util.null2String(rs.getString("rewardname"));
		String rewardmemo = Util.null2String(rs.getString("rewardmemo"));
	%>
	<wea:item><%=rewardname%></wea:item>
	<wea:item><%=rewarddate%></wea:item>
	<wea:item><%=rewardmemo%></wea:item>
	<%
	  }
	%>
	</wea:group>
	</wea:layout>
	</wea:item>
	</wea:group>
	<%} %>
	<%----------------------------自定义明细字段 begin--------------------------------------------%>
	 <%
		if(HrmListValidate.isValidate(58)){
         RecordSet.executeSql("select id, formlabel from cus_treeform where parentid="+scopeId+" order by scopeorder");
         int recorderindex = 0 ;
         while(RecordSet.next()){
             recorderindex = 0 ;
             int subId = RecordSet.getInt("id");
             CustomFieldManager cfm2 = new CustomFieldManager("HrmCustomFieldByInfoType",subId);
             cfm2.getCustomFields();
             CustomFieldTreeManager.getMutiCustomData("HrmCustomFieldByInfoType", subId, Util.getIntValue(id,0));
             int colcount1 = cfm2.getSize() ;
             int colwidth1 = 0 ;
             int rowcount = 0;
             while(cfm2.next()){
            	 if(!cfm2.isUse())continue;
            	 rowcount++;
             }
             if(rowcount==0)continue;
             cfm2.beforeFirst();
             if( colcount1 != 0 ) {
                 colwidth1 = 100/colcount1 ;

                 ht.put(("cus_list_"+subId),RecordSet.getString("formlabel"));
                 
     String attr = "{'samePair':'cus_list_"+subId+"','groupOperDisplay':'none'}";
     %> 
<wea:group context='<%=RecordSet.getString("formlabel")%>' attributes="<%=attr %>" >
<wea:item attributes="{'isTableList':'true'}">
<%
int col = 0;
while(cfm2.next()){
	if(cfm2.isUse())col++;
}
cfm2.beforeFirst();
attr = "{'cols':'"+col+"','layoutTableId':'oTable_"+subId+"','expandAllGroup':'true'}";
%>
 	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes='<%=attr %>'>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
   <%

       while(cfm2.next()){
      	 if(!cfm2.isUse())continue;
		  String fieldlable =String.valueOf(cfm2.getLable());

   %>
		 <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlable),user.getLanguage())%></wea:item>
           <%
	   }
       cfm2.beforeFirst();
%>
<%

    boolean isttLight = false;
    while(CustomFieldTreeManager.nextMutiData()){
            isttLight = !isttLight ;

        while(cfm2.next()){
        	if(!cfm2.isUse())continue;
            String fieldid=String.valueOf(cfm2.getId());  //字段id
            String ismand=String.valueOf(cfm2.isMand());   //字段是否必须输入
            String fieldhtmltype = String.valueOf(cfm2.getHtmlType());
            String fieldtype=String.valueOf(cfm2.getType());
            String fieldvalue =  Util.null2String(CustomFieldTreeManager.getMutiData("field"+fieldid)) ;

%>
            <wea:item>
<%
            if(fieldhtmltype.equals("1")||fieldhtmltype.equals("2")){                          // 单行文本框
%>
                <%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>
<%
            }else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
                String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
                String showname = "";                                   // 新建时候默认值显示的名称
                String showid = "";                                     // 新建时候默认值
        		    if("161".equals(fieldtype) || "162".equals(fieldtype)) {
        		    	url = url + "?type=" + cfm2.getDmrUrl();
        		    	if(!"".equals(fieldvalue)) {
        			    	Browser browser=(Browser) StaticObj.getServiceByFullname(cfm2.getDmrUrl(), Browser.class);
        					try{
        						String[] fieldvalues = fieldvalue.split(",");
        						for(int i = 0;i < fieldvalues.length;i++) {
        	                        BrowserBean bb=browser.searchById(fieldvalues[i]);
        	                        String desc=Util.null2String(bb.getDescription());
        	                        String name=Util.null2String(bb.getName());
        	                        if(!"".equals(showname)) {
        		                        showname += ",";
        	                        }
        	                        showname += name;
        						}
        					}catch (Exception e){}
        		    	}
        		    }
                String newdocid = Util.null2String(request.getParameter("docid"));

                if( fieldtype.equals("37") && !newdocid.equals("")) {
                    if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                    fieldvalue += newdocid ;
                }

                if(fieldtype.equals("2") ||fieldtype.equals("19")){
                    showname=fieldvalue; // 日期时间
                }else if(!fieldvalue.equals("")&& !("161".equals(fieldtype) || "162".equals(fieldtype))) {
                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                    sql = "";

                    HashMap temRes = new HashMap();

                    if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")||fieldtype.equals("194")) {    // 多人力资源,多客户,多会议，多文档
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                    }
                    else {
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                    }

                    rs.executeSql(sql);
                    while(rs.next()){
                        showid = Util.null2String(rs.getString(1)) ;
                        String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
                        if(!linkurl.equals(""))
                        //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                            temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                        else{
                            //showname += tempshowname ;
                            temRes.put(String.valueOf(showid),tempshowname);
                        }
                    }
                    StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                    String temstkvalue = "";
                    while(temstk.hasMoreTokens()){
                        temstkvalue = temstk.nextToken();

                        if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                            showname += temRes.get(temstkvalue);
                        }
                    }

                }
%>
                    <%=showname%>
<%
            }else if(fieldhtmltype.equals("4")) {                    // check框
%>
                <input type=checkbox disabled value=1 name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" <%if(fieldvalue.equals("1")){%> checked <%}%> >
<%
            }else if(cfm2.getHtmlType().equals("5")){
                cfm2.getSelectItem(cfm2.getId());
                while(cfm2.nextSelect()){
                    if(cfm2.getSelectValue().equals(fieldvalue)){
%>
            <%=cfm2.getSelectName()%>
<%
                        break;
                    }
                }
            }
%>
            </wea:item>
<%
        }
        cfm2.beforeFirst();
        recorderindex ++ ;
    }

%>
</wea:group>
</wea:layout>
</wea:item>
</wea:group>
<%} %>
<%
             }
%>
<%
         }
%>

<%----------------------------自定义明细字段 end  --------------------------------------------%>
</wea:layout>
<script language=javascript>
jQuery(document).ready(function(){
hideAll();
jsChangeTab("HrmRelatedContract");
})

function hideAll(){
hideGroup("HrmRelatedContract");
hideGroup("HrmStatusHistory");
hideGroup("HrmLanguageAbility");
hideGroup("HrmEducationInfo");
hideGroup("HrmWorkResume");
hideGroup("HrmTrainBeforeWork");
hideGroup("HrmCertification");
hideGroup("HrmRewardBeforeWork");
	<% 
	iter = ht.entrySet().iterator();
	while (iter.hasNext()){
	Map.Entry entry = (Map.Entry) iter.next();
	String key = (String)entry.getKey();
	String val = (String)entry.getValue();
	%>
	hideGroup("<%=key %>");
	<% }%>
}

function jsChangeTab(id){
 hideAll();
 showGroup(id);
}

</script>

