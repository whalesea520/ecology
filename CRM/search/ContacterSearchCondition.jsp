
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.crm.util.CrmFieldComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(572,user.getLanguage())+SystemEnv.getHtmlLabelName(527,user.getLanguage());
String needfav ="1";
String needhelp ="";


rs.execute("select fieldhtmltype ,type,fieldname , candel,groupid from CRM_CustomerDefinField where usetable = 'CRM_CustomerContacter' and issearch= 1 and isopen=1");
String fieldName = "";
String fieldValue = "";
String htmlType = "";
String type= "";
Map map = new HashMap();
while(rs.next()){
	fieldName = rs.getString("fieldName");
	fieldValue = Util.null2String(Util.null2String(request.getParameter(fieldName)));

	if(fieldName.equals("") || fieldValue.equals("")){
		continue;
	}
	map.put(fieldName ,fieldValue);

}


%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input class="e8_btn_top" type="button" name="btn_search" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>" onclick="onSearch();" />
			<input class="e8_btn_top" type="button" name="btn_reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>" onclick="resetCondition();" />
		</td>
	</tr>
</table>

<!-- 高级搜索 -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:block;" >
<FORM id=report name=report action=ContacterSearch.jsp method=post>
<wea:layout type="4col">
	<%
	CrmFieldComInfo comInfo = new CrmFieldComInfo() ;
	rs.execute("select * from CRM_CustomerDefinFieldGroup where usetable = 'CRM_CustomerContacter' order by dsporder asc");
	while(rs.next()){
		String groupid = rs.getString("id");
		rst.execute("select count(*) from CRM_CustomerDefinField where usetable = 'CRM_CustomerContacter' and issearch= 1 and groupid = "+groupid);
		rst.next();
		if(rst.getInt(1)==0){
			continue;
		}
		
		
		%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(rs.getInt("grouplabel"),user.getLanguage())%>'>
			<% while(comInfo.next()){
				if("CRM_CustomerContacter".equals(comInfo.getUsetable())&&groupid.equals(comInfo.getGroupid().toString())){
				//没有作为搜索条件、或者是附件则跳过
				if(comInfo.getIssearch().trim().equals("") || comInfo.getIssearch().trim().equals("0") || comInfo.getFieldhtmltype() == 6){
					continue;
				}
			%>
				
				<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
				<wea:item>
					<%=CrmUtil.getHtmlElementSetting(comInfo ,Util.null2String(map.get(comInfo.getFieldname())), user , "search")%>
				</wea:item>
			<%}}%>	
			
			<%if(rs.getString("id").equals("6")){ %>
				<wea:item><%=SystemEnv.getHtmlLabelName(21313,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="customerid" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
			         browserValue=''
			         browserSpanValue = ''
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=7" width="230px" ></brow:browser>
				</wea:item>
				
			<%} %>
		</wea:group>
	<%}%>	
</wea:layout>
</FORM>
</div>

		

<script>
function onSearch(){
	report.submit();
}

</script>


</BODY>
</HTML>
