<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.docs.docs.reply.DocReplyUtil"%>
<jsp:useBean id="CustomerInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="ProjectInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<%
    User user = HrmUserVarify.getUser (request , response) ;
	String gridUrl = Util.null2String(request.getParameter("gridUrl"));
	int displayUsage =  Util.getIntValue(request.getParameter("displayUsage"),0);
	int seccategory= Util.getIntValue(request.getParameter("seccategory"),0);
	String subcategory =  Util.null2String(request.getParameter("subcategory"));
	String maincategory =  Util.null2String(request.getParameter("maincategory"));
	String customSearchPara =  Util.null2String(request.getParameter("customSearchPara"));
	String from =  Util.null2String(request.getParameter("from"));
	String showtype =  Util.null2String(request.getParameter("showtype"));
	String columnUrl =  Util.null2String(request.getParameter("columnUrl"));
	String urlType =  Util.null2String(request.getParameter("urlType"));
	String isShow =  Util.null2String(request.getParameter("isShow"));
	String offical =  Util.null2String(request.getParameter("offical"));
	String isUsedCustomSearch =  Util.null2String(request.getParameter("isUsedCustomSearch"));
	int userightmenu_self= Util.getIntValue(request.getParameter("userightmenu_self"),0);
	int lang= Util.getIntValue(request.getParameter("lang"),7);
	String topButton =  Util.null2String(request.getParameter("topButton"));
	String useCustomSearch =  Util.null2String(request.getParameter("useCustomSearch"));
	String docdetachable =  Util.null2String(request.getParameter("docdetachable"));
	String isDetach =  Util.null2String(request.getParameter("isDetach"));
	String fromAdvancedMenu =  Util.null2String(request.getParameter("fromAdvancedMenu"));
	String infoId = Util.null2String(request.getParameter("infoId"));
    boolean isRanking = (urlType.equals("2")||urlType.equals("1")||urlType.equals("3")||urlType.equals("4"));
	int mouldid = Util.getIntValue(request.getParameter("mouldid"),0);
	String docsubject = DocSearchComInfo.getDocsubject();
	String searchMsg = Util.null2String(request.getParameter("searchMsg"));
	String currentState = Util.null2String(request.getParameter("currentState"));
	String usertype = Util.null2String(request.getParameter("usertype"));
	String docstatus = Util.null2String(request.getParameter("docstatus"));
	int doccreaterid = Util.getIntValue(request.getParameter("doccreaterid"),0);
    int date2during = Util.getIntValue(request.getParameter("date2during"),0);
	
	int ownerid = Util.getIntValue(request.getParameter("ownerid"),0);
	int ownerid2 = Util.getIntValue(request.getParameter("ownerid2"),0);
	int ownerdepartmentid = Util.getIntValue(request.getParameter("ownerdepartmentid"),0);
	int ownersubcompanyid = Util.getIntValue(request.getParameter("ownersubcompanyid"),0);
	int doclangurage = Util.getIntValue(request.getParameter("doclangurage"),0);
	int doclastmoduserid = Util.getIntValue(request.getParameter("doclastmoduserid"),0);
	int docarchiveuserid = Util.getIntValue(request.getParameter("docarchiveuserid"),0);
	int docapproveuserid = Util.getIntValue(request.getParameter("docapproveuserid"),0);
	int crmid = Util.getIntValue(request.getParameter("crmid"),0);
	int rowNum = 0;
	
	int assetid = Util.getIntValue(request.getParameter("assetid"),0);
	int hrmresid = Util.getIntValue(request.getParameter("hrmresid"),0);
	int projectid = Util.getIntValue(request.getParameter("projectid"),0);
	
	int doccreaterid2 = Util.getIntValue(request.getParameter("doccreaterid2"),0);
	int isgoveproj = Util.getIntValue(request.getParameter("isgoveproj"),0);
	int departmentid = Util.getIntValue(request.getParameter("departmentid"),0);
	int creatersubcompanyid = Util.getIntValue(request.getParameter("creatersubcompanyid"),0);
	String  date2durings = Util.null2String(request.getParameter("date2durings"));
	String dspreply = Util.null2String(request.getParameter("dspreply"));
	String treeDocFieldId = Util.null2String(request.getParameter("treeDocFieldId"));
	String secinput = Util.null2String(request.getParameter("secinput"));
	String docno = Util.null2String(request.getParameter("docno"));
	String containreply = Util.null2String(request.getParameter("containreply"));
	String docpublishtype = Util.null2String(request.getParameter("docpublishtype"));
	String pop_state = Util.null2String(request.getParameter("pop_state"));
	String keyword = Util.null2String(request.getParameter("keyword"));
	String contentname = Util.null2String(request.getParameter("contentname"));
	String advanceattrs = Util.null2String(request.getParameter("advanceattrs"));
	String isNew = Util.null2String(request.getParameter("isNew"));
	
	String subscribeDateFrom = Util.toScreenToEdit(request.getParameter("subscribeDateFrom"),user.getLanguage());
    String subscribeDateTo = Util.toScreenToEdit(request.getParameter("subscribeDateTo"),user.getLanguage());
    String approveDateFrom = Util.toScreenToEdit(request.getParameter("approveDateFrom"),user.getLanguage());
    String  approveDateTo = Util.toScreenToEdit(request.getParameter("approveDateTo"),user.getLanguage());
	
    String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
    //String docarchivedateto = Util.toScreenToEdit(request.getParameter("docarchivedateto"),user.getLanguage());
    String doccreatedatefrom = Util.toScreenToEdit(request.getParameter("doccreatedatefrom"),user.getLanguage());
   String doccreatedateto = Util.toScreenToEdit(request.getParameter("doccreatedateto"),user.getLanguage());
   String  docapprovedatefrom = Util.toScreenToEdit(request.getParameter("docapprovedatefrom"),user.getLanguage());
   String  docapprovedateto = Util.toScreenToEdit(request.getParameter("docapprovedateto"),user.getLanguage());
   String  replaydoccountfrom = Util.toScreenToEdit(request.getParameter("replaydoccountfrom"),user.getLanguage());
   String replaydoccountto = Util.toScreenToEdit(request.getParameter("replaydoccountto"),user.getLanguage());
  //String  accessorycountfrom = Util.toScreenToEdit(request.getParameter("accessorycountfrom"),user.getLanguage());
    //String accessorycountto = Util.toScreenToEdit(request.getParameter("accessorycountto"),user.getLanguage());
	String doclastmoddatefrom = Util.toScreenToEdit(request.getParameter("doclastmoddatefrom"),user.getLanguage());
	String doclastmoddateto = Util.toScreenToEdit(request.getParameter("doclastmoddateto"),user.getLanguage());
	String docarchivedatefrom = Util.toScreenToEdit(request.getParameter("docarchivedatefrom"),user.getLanguage());
	String docarchivedateto = Util.toScreenToEdit(request.getParameter("docarchivedateto"),user.getLanguage());

	
	int language = Util.getIntValue(request.getParameter("language"),7);
	  String attrs = "{'expandAllGroup':'"+((urlType.equals("13")||urlType.equals("14")||urlType.equals("15"))?"true":"false")+"'}"; 
  if(isDetach.equals("3")){
      attrs = "{'expandAllGroup':'"+((urlType.equals("13")||urlType.equals("14")||urlType.equals("15"))?"true":"false")+"','layoutTableDisplay':'none','layoutTableId':'SearchDivlab'}"; 
  }
%>

<wea:layout type="4col" attributes='<%=attrs %>'>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(((isRanking)?20331:32905),user.getLanguage())%>'>
			<%if(mouldid==0||!(docsubject.equals(""))){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
				<wea:item>
					<input class=InputStyle type="text"  name="docsubject" id="docsubject" value="<%=docsubject%>">
	                   <span class="e8tips" title="<%=searchMsg %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
				</wea:item>
			<%}%>
			<% if(urlType.equals("7") || urlType.equals("8") || urlType.equals("9")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></wea:item>
				<wea:item>
					 <SELECT NAME="currentState">
					  <OPTION value=""  <%if (currentState.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
					  <OPTION value="1" <%if (currentState.equals("1")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(18659,user.getLanguage())%></OPTION>
					  <OPTION value="2" <%if (currentState.equals("2")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(18660,user.getLanguage())%></OPTION>
					  <OPTION value="3" <%if (currentState.equals("3")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(18661,user.getLanguage())%></OPTION>  
				  </SELECT>
				</wea:item>
			<%}%>
			<%if(!urlType.equals("5")){ %>
				<%if(!(urlType.equals("7") || urlType.equals("8") || urlType.equals("9"))){ %>
					<%if(mouldid==0||doccreaterid!=0||doccreaterid2!=0){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
						<wea:item>
							<%if(!user.getLogintype().equals("2")){%>
							 <span style="float:left;">
									<select id="doccreateridsel" style="width:80px;" name="doccreaterididsel" onchange="changeType(this.value,'doccreaterid','doccreaterid2','usertype');">
										<option value="1" <%=doccreaterid2==0?"selected":"" %>>
											<%=isgoveproj==0?SystemEnv.getHtmlLabelName(362,user.getLanguage()):SystemEnv.getHtmlLabelName(20098,user.getLanguage()) %>
										</option>
										<option value="2" <%=doccreaterid2!=0?"selected":"" %>>
											<%=SystemEnv.getHtmlLabelName(136,user.getLanguage()) %>
										</option>
									</select>
								 </span>
							<%if(mouldid==0||doccreaterid != 0){%>
							  <span id="doccreateridselspan" style="<%=doccreaterid2==0?"":"display:none;" %>">
							   <brow:browser viewType="0" name="doccreaterid" browserValue='<%= ""+doccreaterid %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								_callback="afterShowResource"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="49%"
								browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(doccreaterid+""),user.getLanguage())%>'></brow:browser>
								</span>
									  
								<%}%>
						  <%}%>
						  <%if(isgoveproj==0){%>
					  
								<%if(mouldid==0||doccreaterid2 != 0){%>
			                      <span id="doccreaterid2selspan" style="<%=doccreaterid2!=0?"":"display:none;" %>">
										  <brow:browser viewType="0" name="doccreaterid2" browserValue='<%= ""+doccreaterid2 %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" _callback="afterShowParent"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=7" linkUrl="javascript:openhrm($id$)" width="150px"
								browserSpanValue='<%=doccreaterid2!=0?Util.toScreen(CustomerInfo.getCustomerInfoname(doccreaterid2+""),user.getLanguage()):""%>'></brow:browser>
									</span>
							  <%}%>
							  <%}%>
					  				<input type="hidden" name="usertype" value="<%=usertype%>">
						</wea:item>
					<%}%>
				<%} %>
			<%}else{ %>
				<%if((mouldid==0||!(docstatus.equals("")))){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(urlType.equals("5")){ %>
							<select class=InputStyle id="docstatus" name="docstatus">
								<option value=""></option>
                                <option value="0" <%if (docstatus.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
                                <option value="1" <%if (docstatus.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
                                <option value="2" <%if (docstatus.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1423,user.getLanguage())%>)</option>
                                <option value="3" <%if (docstatus.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
                                <option value="4" <%if (docstatus.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
                                <option value="5" <%if (docstatus.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
                                <option value="6" <%if (docstatus.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19564,user.getLanguage())%></option>
                                <option value="7" <%if (docstatus.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
						  </select>
						<%}else{ %>
							<select class=InputStyle id="docstatus" name="docstatus">
								<option value=""></option>
								<option value="1" <%if (docstatus.equals("1")||docstatus.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18431,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
								<option value="5" <%if (docstatus.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
								<option value="7" <%if (docstatus.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
						  </select>
						 <%} %>
					</wea:item>
				<%}%>
			<%} %>
			<% if(urlType.equals("7")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(18658,user.getLanguage())%></wea:item>
				<wea:item>
					<span class="wuiDateSpan" selectId="approvedateselect">
					    <input class=wuiDateSel type="hidden" name="approveDateFrom" value="<%=approveDateFrom%>">
					    <input class=wuiDateSel  type="hidden" name="approveDateTo" value="<%=approveDateTo%>">
					</span>
				</wea:item>
			<%}else{%>
				<%if(mouldid==0||seccategory!=0){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></wea:item>
					<wea:item>
						<span >
							<brow:browser viewType="0" name="seccategory" browserValue='<%=""+seccategory%>' idKey="id" nameKey="path"
							 browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
							 hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=""+secinput%>'
							 completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" linkUrl="#" width="80%"
							 _callback="setCustomSearch"
							browserSpanValue='<%=SecCategoryComInfo.getAllParentName(""+seccategory,true)%>'></brow:browser>
						</span>
					</wea:item>
				<%} %>
			<%} %>
			<%if(!(urlType.equals("7") || urlType.equals("8") || urlType.equals("9"))){ %>
			<%if(mouldid==0|| !doccreatedatefrom.equals("") || !doccreatedateto.equals("")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
				<wea:item>
					<span class="wuiDateSpan" selectId="doccreatedateselect" _defaultValue=<%=urlType.equals("0")?"1":"0" %>>
					    <input class=wuiDateSel type="hidden" name="doccreatedatefrom" value="<%=doccreatedatefrom%>">
					    <input class=wuiDateSel  type="hidden" name="doccreatedateto" value="<%=doccreatedateto%>">
					</span>
				</wea:item>
			<%}%>
			<%} %>
			<%if(!urlType.equals("5")){ %>
				<%if(!(urlType.equals("7") || urlType.equals("8") || urlType.equals("9"))){ %>
					<%if(!user.getLogintype().equals("2")){%>
				     <%if(mouldid==0||departmentid!=0){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="departmentid" browserValue='<%= ""+departmentid %>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
										hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
										completeUrl="/data.jsp?type=4" 
										browserSpanValue='<%=departmentid!=0?Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid+""),user.getLanguage()):""%>'>
								</brow:browser>
							</span>
						</wea:item>
				<%}}%>
				<%} %>
			<%}else{ %>
				<%if((mouldid==0||!(docno.equals("")))){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
					<wea:item><input class=InputStyle  type="text" name="docno" value='<%=docno%>'></wea:item>
				<%}%>
			<%} %>
			<%if(!user.getLogintype().equals("2") && (isRanking)){%>
				<%if(mouldid==0||creatersubcompanyid!=0){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="creatersubcompanyid" browserValue='<%= ""+creatersubcompanyid %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=164" 
									browserSpanValue='<%=creatersubcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(creatersubcompanyid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</span>
					</wea:item>
				<%}%>
			<%}%>
			<%if((mouldid==0||treeDocFieldId!="")&& (isRanking)){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
                        <brow:browser viewType="0" name="treeDocFieldId" browserValue='<%= ""+treeDocFieldId %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="
					hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=-99999" 
					browserSpanValue='<%=!"".equals(treeDocFieldId)?DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(treeDocFieldId,","):""%>'>
					</brow:browser>
					</span>
				</wea:item>
			<%}%>
			<%if(isRanking){ 
			    if(!DocReplyUtil.isUseNewReply()) {
			%>
				<wea:item><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></wea:item>
				<wea:item>
					<SELECT  class=InputStyle id="dspreply" name=dspreply>
					   <option value="0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					   <option value="1" <%if (dspreply.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18467,user.getLanguage())%></option>
					   <option value="2" <%if (dspreply.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18468,user.getLanguage())%></option>
					</SELECT>
				</wea:item>
			<% }}%>
			<% if(urlType.equals("7") || urlType.equals("8") || urlType.equals("9")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(18657,user.getLanguage())%></wea:item>
				<wea:item>
					<span class="wuiDateSpan" selectId="subscribedateselect">
					    <input class=wuiDateSel type="hidden" name="subscribeDateFrom" value="<%=subscribeDateFrom%>">
					    <input class=wuiDateSel  type="hidden" name="subscribeDateTo" value="<%=subscribeDateTo%>">
					</span>
				</wea:item>
			<%}%>
			<%if(date2duringTokens.length>0){ %>
				<wea:item><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=inputstyle  size=1 id=date2during name=date2during>
						<!-- 全部 -->
						<option value="38" <%if (date2during==38) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						<%
						for(int i=0;i<date2duringTokens.length;i++)
						{
							int tempdate2during = Util.getIntValue(date2duringTokens[i],0);
							if(tempdate2during>36||tempdate2during<1)
							{
								continue;
							}
						%>
						<!-- 最近个月 -->
						<option value="<%=tempdate2during %>" <%if (date2during==tempdate2during) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><%=tempdate2during %><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%></option>
						<%
						} 
						%>
						
					 </select>
				</wea:item>
			<%}%>
		</wea:group>
		<%if(!(isRanking)){ %>
		<%String __attrs = "{'itemAreaDisplay':'"+((urlType.equals("13")||urlType.equals("14")||urlType.equals("15"))?"":"none")+"'}"; %>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>' attributes="<%=__attrs %>">
			<%if((mouldid==0||!(docno.equals("")))&&!urlType.equals("5")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
				<wea:item><input class=InputStyle  type="text" name="docno" value='<%=docno%>'></wea:item>
			<%}%>
			<%if(urlType.equals("5")){
			    if(!DocReplyUtil.isUseNewReply()) {
				%>
		    <wea:item><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></wea:item>
			<wea:item>
				<SELECT  class=InputStyle id="dspreply" name=dspreply>
				   <option value="0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				   <option value="1" <%if (dspreply.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18467,user.getLanguage())%></option>
				   <option value="2" <%if (dspreply.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18468,user.getLanguage())%></option>
				</SELECT>
			</wea:item>
		<% }} %>
			<%if((mouldid==0||(containreply.equals("1"))) && !urlType.equals("7")  && !urlType.equals("8")  && !urlType.equals("9") && !urlType.equals("5")){
			    if(!DocReplyUtil.isUseNewReply()) {
					%>
			    <wea:item><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></wea:item>
				<wea:item>
					<SELECT  class=InputStyle id="dspreply" name=dspreply>
					   <option value="0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					   <option value="1" <%if (dspreply.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18467,user.getLanguage())%></option>
					   <option value="2" <%if (dspreply.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18468,user.getLanguage())%></option>
					</SELECT>
				</wea:item>
			<% }}%>
			<%if(!user.getLogintype().equals("2") && !urlType.equals("5")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%></wea:item>
				<wea:item>
					<%if(mouldid==0||ownerid != 0){%>
						<span style="float:left;">
							<select style="width:80px;" id="owneridsel" name="owneridsel" onchange="changeType(this.value,'ownerid','ownerid2','usertype');">
								<option value="1" <%=ownerid2==1?"selected":"" %>>
									<%=isgoveproj==0?SystemEnv.getHtmlLabelName(362,user.getLanguage()):SystemEnv.getHtmlLabelName(20098,user.getLanguage()) %>
								</option>
								<option value="2" <%=ownerid2!=0?"selected":"" %>>
									<%=SystemEnv.getHtmlLabelName(136,user.getLanguage()) %>
								</option>
							</select>
    					</span>
						<span id="owneridselspan" style="<%=ownerid2==0?"":"display:none;" %>">
						  <brow:browser viewType="0" name="ownerid" browserValue='<%= ""+ownerid %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					_callback="afterShowResource"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="49%"
					browserSpanValue='<%=ownerid!=0?Util.toScreen(ResourceComInfo.getResourcename(ownerid+""),user.getLanguage()):""%>'></brow:browser>
					    </span>
					<%}%>
					<%if(isgoveproj==0){%>
						<%if(mouldid==0||ownerid2 != 0){%>
							<span id="ownerid2selspan" style="<%=ownerid2!=0?"":"display:none;" %>"><brow:browser viewType="0" name="ownerid2" browserValue='<%= ""+ownerid2 %>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" _callback="afterShowParent"
                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
                completeUrl="/data.jsp?type=7" width="150px"
                browserSpanValue='<%=Util.toScreen(CustomerInfo.getCustomerInfoname(ownerid2+""),user.getLanguage())%>'></brow:browser>
					</span>
						<%}%>
					<%}%>
				</wea:item>
			<%}%>
			<%if(!user.getLogintype().equals("2") && !urlType.equals("5")){%>
				<%if(mouldid==0||ownerdepartmentid!=0){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="ownerdepartmentid" browserValue='<%= ""+ownerdepartmentid %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=4" 
									browserSpanValue='<%=ownerdepartmentid!=0?Util.toScreen(DepartmentComInfo.getDepartmentname(ownerdepartmentid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</span>
					</wea:item>
				<%}%>
			<%}%>
			<%if(!user.getLogintype().equals("2") && !urlType.equals("5")){%>
				<%if(mouldid==0||ownersubcompanyid!=0){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="ownersubcompanyid" browserValue='<%= ""+ownersubcompanyid %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=164" 
									browserSpanValue='<%=ownersubcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(ownersubcompanyid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</span>
					</wea:item>
				<%}%>
			<%}%>
			<%if(!user.getLogintype().equals("2") && !urlType.equals("5")){%>
				<%if(mouldid==0||creatersubcompanyid!=0){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="creatersubcompanyid" browserValue='<%= ""+creatersubcompanyid %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=164" 
									browserSpanValue='<%=creatersubcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(creatersubcompanyid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</span>
					</wea:item>
				<%}%>
			<%}%>
			<%if(mouldid==0||!(docpublishtype.equals("0"))){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(19789,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=InputStyle  id="docpublishtype" size="1" name="docpublishtype">
                            <option value="0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
                            <option value="1" <%if (docpublishtype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
                            <option value="2" <%if (docpublishtype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></option>
                            <option value="3" <%if (docpublishtype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></option>
                          </select>
				</wea:item>
			<%}%>
			<%if(mouldid==0|| !doclastmoddatefrom.equals("") || !doclastmoddateto.equals("")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%></wea:item>
				<wea:item>
					<span class="wuiDateSpan" selectId="doclastmoddateselect">
					    <input class=wuiDateSel type="hidden" name="doclastmoddatefrom" value="<%=doclastmoddatefrom%>">
					    <input class=wuiDateSel  type="hidden" name="doclastmoddateto" value="<%=doclastmoddateto%>">
					</span>
				</wea:item>
			<%}%>
			<% if(urlType.equals("12")){ %>
				<wea:item><%=SystemEnv.getHtmlLabelName(21887,user.getLanguage())%></wea:item>
				<wea:item>
					<select name="pop_state">
						<option value=""></option>
						<option value="0" <%if("0".equals(pop_state)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21888,user.getLanguage())%></option>
						<option value="1" <%if("1".equals(pop_state)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21889,user.getLanguage())%></option>
						<option value="2" <%if("2".equals(pop_state)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21917,user.getLanguage())%></option>
					 </select>
				</wea:item>
			<%}%>
			
			<%if(mouldid==0||treeDocFieldId!=""){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
                        <brow:browser viewType="0" name="treeDocFieldId" browserValue='<%= ""+treeDocFieldId %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="
					hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=-99999" 
					browserSpanValue='<%=!"".equals(treeDocFieldId)?DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(treeDocFieldId,","):""%>'>
					</brow:browser>
					</span>
				</wea:item>
			<%}%>
			<%if(mouldid==0||!(keyword.equals(""))){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(2005,user.getLanguage())%></wea:item>
				<wea:item><input class=InputStyle  type="text" name="keyword" <%if(!(keyword.equals(""))){%>value='<%=keyword%>'<%}%>></wea:item>
			<%}%>
			<%if(mouldid==0 || !replaydoccountfrom.equals("") || !replaydoccountto.equals("") ){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(2001,user.getLanguage())%></wea:item>
				<wea:item>
					<input class=InputStyle style="width:39%!important;" type="text"  name="replaydoccountfrom" value="<%=replaydoccountfrom%>" size=8>
                          -
                          <input class=InputStyle style="width:39%!important;" type="text"  name="replaydoccountto" value="<%=replaydoccountto%>" size=9>
				</wea:item>
			<%}%>
			<%if(urlType.equals("7")){ %>
			<%if(mouldid==0||!(contentname.equals(""))){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(24764,user.getLanguage())%></wea:item>
				<wea:item><input class=InputStyle  type="text" name="contentname" <%if(!(contentname.equals(""))){%>value='<%=contentname%>'<%}%>></wea:item>
			<%}}%>
			<%if((mouldid==0||!(docstatus.equals("")))&& !urlType.equals("5")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=InputStyle id="docstatus" name="docstatus">
						<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						<option value="1" <%if (docstatus.equals("1")||docstatus.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18431,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
						<option value="5" <%if (docstatus.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
						<option value="7" <%if (docstatus.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
				  </select>
				</wea:item>
			<%}%>
			</wea:group>
			<wea:group context='' attributes="{groupDisplay:none,itemAreaDisplay:none}">
			<wea:item type="groupHead">
				<input type="hidden" name="threeGroupTable" id="threeGroupTable"/>
			</wea:item>
			<%if(mouldid==0||doclangurage!=0){%>
				<wea:item attributes='<%=advanceattrs %>'><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></wea:item>
				<wea:item attributes='<%=advanceattrs %>'>
					<span>
					 <brow:browser viewType="0" name="doclangurage" browserValue='<%= ""+doclangurage %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/systeminfo/language/LanguageBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=-99998" linkUrl="#" 
								browserSpanValue='<%=doclangurage!=0?Util.toScreen(LanguageComInfo.getLanguagename(doclangurage+""),user.getLanguage()):"" %>'></brow:browser>
				  </span>
				</wea:item>
			 <%}%>
			<%if(!user.getLogintype().equals("2")){%>
				<%if(mouldid==0|| doclastmoduserid!=0){%>
					<wea:item attributes='<%=advanceattrs %>'><%=SystemEnv.getHtmlLabelName(3002,user.getLanguage())%></wea:item>
					<wea:item attributes='<%=advanceattrs %>'>
						<brow:browser viewType="0" name="doclastmoduserid" browserValue='<%= ""+doclastmoduserid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue='<%= doclastmoduserid!=0?Util.toScreen(ResourceComInfo.getResourcename(doclastmoduserid+""),user.getLanguage()):"" %>'></brow:browser>
						   <input type="hidden" id="seccategory" name="seccategory" value="<%=seccategory%>">
						   <input type="hidden" name="isNew" value="<%= isNew %>">
					</wea:item>
				 <%}%>
			<%}%>
			<%if(mouldid==0|| !docarchivedatefrom.equals("") || !docarchivedateto.equals("")){%>
					<wea:item attributes='<%=advanceattrs %>'><%=SystemEnv.getHtmlLabelName(3000,user.getLanguage())%></wea:item>
					<wea:item attributes='<%=advanceattrs %>'>
						<span class="wuiDateSpan" selectId="docarchivedateselect">
						    <input class=wuiDateSel type="hidden" name="docarchivedatefrom" value="<%=docarchivedatefrom%>">
						    <input class=wuiDateSel  type="hidden" name="docarchivedateto" value="<%=docarchivedateto%>">
						</span>
					</wea:item>
			<%}%>
			<%if(!user.getLogintype().equals("2")){%>
				<%if(mouldid==0|| docarchiveuserid!=0){%>
					<wea:item attributes='<%=advanceattrs %>'><%=SystemEnv.getHtmlLabelName(3003,user.getLanguage())%></wea:item>
					<wea:item attributes='<%=advanceattrs %>'>
						<span>
						   <brow:browser viewType="0" name="docarchiveuserid" browserValue='<%= ""+docarchiveuserid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue='<%= docarchiveuserid!=0?Util.toScreen(ResourceComInfo.getResourcename(docarchiveuserid+""),user.getLanguage()):"" %>'></brow:browser>
						</span>
					</wea:item>
			 <%}%>
			<%}%>
			<%if(mouldid==0|| !docapprovedatefrom.equals("") || !docapprovedateto.equals("")){%>
				<wea:item attributes='<%=advanceattrs %>'>
					<%=SystemEnv.getHtmlLabelName(1425,user.getLanguage())%>
				</wea:item>
				<wea:item attributes='<%=advanceattrs %>'>
					<span class="wuiDateSpan" selectId="docapprovedateselect">
					    <input class=wuiDateSel type="hidden" name="docapprovedatefrom" value="<%=docapprovedatefrom%>">
					    <input class=wuiDateSel type="hidden" name="docapprovedateto" value="<%=docapprovedateto%>">
					</span>
                          <input type="hidden" name="docapprovedatetonouse" value="<%=docapprovedateto%>">
				</wea:item>
			<%}%>
			<%if(!user.getLogintype().equals("2")){%>
                <%if(mouldid==0||docapproveuserid!=0){%>
					<wea:item attributes='<%=advanceattrs %>'><%=SystemEnv.getHtmlLabelName(3001,user.getLanguage())%></wea:item>
					<wea:item attributes='<%=advanceattrs %>'>
						<span>
						  <brow:browser viewType="0" name="docapproveuserid" browserValue='<%= ""+docapproveuserid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue='<%=docapproveuserid!=0?Util.toScreen(ResourceComInfo.getResourcename(docapproveuserid+""),user.getLanguage()):""%>'></brow:browser>
						</span>
					</wea:item>
			<%}%>
			
			 <%if(isgoveproj==0){%>
			  <%if(mouldid==0||crmid!=0){
				rowNum++;
			  %>
					<wea:item attributes='<%=advanceattrs %>'><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></wea:item>
					<wea:item attributes='<%=advanceattrs %>'>
						<span>
	                      <brow:browser viewType="0" name="crmid" browserValue='<%= ""+crmid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp?type=7"  
							browserSpanValue='<%=crmid!=0?Util.toScreen(CustomerInfo.getCustomerInfoname(crmid+""),user.getLanguage()):""%>'></brow:browser>
						</span>
					</wea:item>
			<%}%>
			<%}%>
			<%if(mouldid==0||assetid!=0){%>
				<wea:item attributes='<%=advanceattrs %>'><%=SystemEnv.getHtmlLabelName(858,user.getLanguage())%></wea:item>
				<wea:item attributes='<%=advanceattrs %>'>
					<span>
	                      <brow:browser viewType="0" name="assetid" browserValue='<%= ""+assetid %>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp"
                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
                completeUrl="/data.jsp?type=23"  
                browserSpanValue='<%=assetid!=0?Util.toScreen(CapitalComInfo.getCapitalname(assetid+""),user.getLanguage()):""%>'></brow:browser>
					</span>
				</wea:item>
			<%}%>
			
			<%}%>
			<%if(mouldid==0||hrmresid!=0){%>
				<wea:item attributes='<%=advanceattrs %>'><%=SystemEnv.getHtmlLabelName(792,user.getLanguage())%></wea:item>
				<wea:item attributes='<%=advanceattrs %>'>
					<span>
					  <brow:browser viewType="0" name="hrmresid" browserValue='<%= ""+hrmresid %>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
						browserSpanValue='<%=hrmresid!=0?Util.toScreen(ResourceComInfo.getResourcename(hrmresid+""),user.getLanguage()):""%>'></brow:browser>
					</span>
				</wea:item>
			<%}%>
			<%if(isgoveproj==0){%>
               <%if(mouldid==0||projectid!=0){%>
					<wea:item attributes='<%=advanceattrs %>'><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></wea:item>
					<wea:item attributes='<%=advanceattrs %>'>
						<span>
						  <brow:browser viewType="0" name="projectid" browserValue='<%= ""+projectid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp?type=8" linkUrl="#" 
							browserSpanValue='<%=projectid!=0?Util.toScreen(ProjectInfo.getProjectInfoname(projectid+""),user.getLanguage()):""%>'></brow:browser>
						</span>
					</wea:item>
			   <%}%>
			<%}%>
		</wea:group>
		<%} %>
		<%if(!urlType.equals("13")&&!urlType.equals("14")&&!urlType.equals("15")){ %>
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
					<span class="e8_sep_line">|</span>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<span class="e8_sep_line">|</span>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
		<%}%>
  </wea:layout>
