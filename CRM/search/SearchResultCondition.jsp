
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.crm.util.CrmFieldComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rso" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCO" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="TradeInfoComInfo" class="weaver.crm.Maint.TradeInfoComInfo" scope="page" />
<jsp:useBean id="CreditInfoComInfo" class="weaver.crm.Maint.CreditInfoComInfo" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="DeprtmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CrmFieldComInfo" class="weaver.crm.util.CrmFieldComInfo" scope="page" />
<jsp:useBean id="CRMTransMethod" class="weaver.crm.Maint.CRMTransMethod" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/hrm/area/browser/areabrowser_wev8.js"></script>
<LINK href="/hrm/area/browser/areabrowser.css" type=text/css rel=STYLESHEET>
</HEAD>

<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(527,user.getLanguage())+SystemEnv.getHtmlLabelName(356,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%
String userid = ""+user.getUID();
String loginType = ""+user.getLogintype();
String userSeclevel = user.getSeclevel();
String msg = Util.null2String(CRMSearchComInfo.getMsg());//report ：报表查看客户信息
String selectType = Util.null2String(CRMSearchComInfo.getSelectType());//mine 我的客户 ，share批量共享
CrmFieldComInfo comInfo = new CrmFieldComInfo() ;
String mainType=Util.null2String(request.getParameter("mainType"));
String subType=Util.null2String(request.getParameter("subType"));
String mainTypeId=Util.null2String(request.getParameter("mainTypeId"));
String subTypeId=Util.null2String(request.getParameter("subTypeId"));
String customerName=Util.null2String(CRMSearchComInfo.getCustomerName());
String settype=Util.null2String(request.getParameter("settype"));
String cityId = Util.null2String(request.getParameter("cityIds"));
String provinceId = Util.null2String(request.getParameter("provinceIds"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top} " ;
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
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display: block;" >
<FORM id=weaver name="weaver" action="/CRM/search/SearchOperation.jsp" method="post">
<input type="hidden" name="CustomerName" value="<%=customerName %>">
<input type="hidden" name="settype" value="<%=settype %>">
<input type="hidden" name="cityIds" value="<%=cityId %>">
<input type="hidden" name="provinceIds" value="<%=provinceId %>">
	
<wea:layout type="4Col">
	<%
	
	rs.execute("select * from CRM_CustomerDefinFieldGroup where usetable = 'CRM_CustomerInfo' order by dsporder asc");
	while(rs.next()){
		String groupid = rs.getString("id");
		if(!groupid.equals("1") && !groupid.equals("2")){
			rst.execute("select count(*) from CRM_CustomerDefinField where usetable = 'CRM_CustomerInfo' and issearch= 1 and groupid = "+groupid);
			rst.next();
			if(rst.getInt(1)==0){
				continue;
			}
		}
		
		
		%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(rs.getInt("grouplabel"),user.getLanguage())%>'>
			<% while(comInfo.next()){
				if("CRM_CustomerInfo".equals(comInfo.getUsetable())&&groupid.equals(comInfo.getGroupid().toString())){
				//没有作为搜索条件、或者是附件则跳过
				if(comInfo.getIssearch().trim().equals("") || comInfo.getIssearch().trim().equals("0") || comInfo.getFieldhtmltype() == 6){
					continue;
				}
				
			%>
				
				<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
				<wea:item>
					<%=CrmUtil.getHtmlElementSetting(comInfo ,Util.null2String(CRMSearchComInfo.getFieldValue(comInfo.getFieldname())), user , "search")%>
				</wea:item>
			<%}}%>
			
			<%if(groupid.equals("1")){ %>
				<wea:item><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></wea:item>
				<wea:item>
					 <div areaType="province" areaName="province" areaValue="<%=CRMSearchComInfo.getFieldValue("province")+""%>" 
						areaSpanValue="<%=ProvinceComInfo.getProvincename(CRMSearchComInfo.getFieldValue("province")+"")%>"  areaMustInput="1"  areaCallback="areaCallBackUpdate"  class="_areaselect" id="_areaselect_provinceid"></div>																	
														  		
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></wea:item>
		        <wea:item>
		        	<span>
			        	<SELECT  id="datetype" name="datetype" onchange="onChangetype(this)" style="width: 120px;">
						  <option value="" 	<%if(CRMSearchComInfo.getFieldValue("datetype").equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						  <option value="1" <%if(CRMSearchComInfo.getFieldValue("datetype").equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
						  <option value="2" <%if(CRMSearchComInfo.getFieldValue("datetype").equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
						  <option value="3" <%if(CRMSearchComInfo.getFieldValue("datetype").equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
						  <option value="4" <%if(CRMSearchComInfo.getFieldValue("datetype").equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
						  <option value="5" <%if(CRMSearchComInfo.getFieldValue("datetype").equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
						  <option value="6" <%if(CRMSearchComInfo.getFieldValue("datetype").equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
						</SELECT>     
		        	</span>
		        	
		        	<span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
						<BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
						<SPAN id=fromdatespan ><%=CRMSearchComInfo.getFieldValue("fromdate")%></SPAN>
						<input type="hidden" name="fromdate" value=<%=CRMSearchComInfo.getFieldValue("fromdate")%>>
						-
						<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
						<SPAN id=enddatespan ><%=CRMSearchComInfo.getFieldValue("enddate")%></SPAN>
						<input type="hidden" name="enddate" value=<%=CRMSearchComInfo.getFieldValue("enddate")%>>
					</span>
				</wea:item>	
				<wea:item><%=SystemEnv.getHtmlLabelNames("144,124",user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="department" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
				         browserValue='<%=CRMSearchComInfo.getFieldValue("department")+""%>' 
				         browserSpanValue = '<%=DeprtmentComInfo.getDepartmentname(CRMSearchComInfo.getFieldValue("department"))%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				         completeUrl="/data.jsp" width="230px" ></brow:browser> 
				</wea:item>
			<%} %>
			
			<%if(groupid.equals("2")){ 
				String rating = CRMSearchComInfo.getFieldValue("rating")+"";
			%>
				<wea:item><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
				<wea:item>
					<select style="width: 172px"  name="rating" id="rating">
						<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></option>
						<option value="0" <%=rating.equals("0")?"selected":""%>>0</option>
                     	<option value="1" <%=rating.equals("1")?"selected":""%>>1</option>
						<option value="2" <%=rating.equals("2")?"selected":""%>>2</option>
						<option value="3" <%=rating.equals("3")?"selected":""%>>3</option>
						<option value="4" <%=rating.equals("4")?"selected":""%>>4</option>
						<option value="5" <%=rating.equals("5")?"selected":""%>>5</option>
						<option value="6" <%=rating.equals("6")?"selected":""%>>6</option>
						<option value="7" <%=rating.equals("7")?"selected":""%>>7</option>
                    </select>
				</wea:item>
															
				<wea:item><%=SystemEnv.getHtmlLabelName(581,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="contractlevel" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/TradeInfoBrowser.jsp"
				         browserValue='<%=CRMSearchComInfo.getFieldValue("contractlevel")+""%>' 
				         browserSpanValue = '<%=TradeInfoComInfo.getTradeInfoname(CRMSearchComInfo.getFieldValue("contractlevel")+"")%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				         completeUrl="/data.jsp?type=debtorNumber" width="230px" ></brow:browser>
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(580,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="creditlevel" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CreditInfoBrowser.jsp"
				         browserValue='<%=CRMSearchComInfo.getFieldValue("creditlevel")+""%>' 
				         browserSpanValue = '<%=CreditInfoComInfo.getCreditInfoname(CRMSearchComInfo.getFieldValue("creditlevel")+"")%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				         completeUrl="/data.jsp?type=creditorNumber" width="230px" ></brow:browser>
				</wea:item>
			<%} %>
		</wea:group>
	<%}%>
	

</wea:layout>			
</FORM>
</div>

<script language="javascript">
    $(document).ready(function(){
        areromancedivs();

    });
	function onSearch(){
		window.weaver.submit();
	}


	function checklength(){

	}
</script>
</body>
</html>

