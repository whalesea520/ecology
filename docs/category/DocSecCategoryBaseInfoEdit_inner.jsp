<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="UtilForSendNewDoc" class="weaver.docs.docs.util.UtilForSendNewDoc" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
	String canEdit_str = request.getParameter("canEdit_str");
	String id = request.getParameter("id");
	String hasSecManageRight_str = request.getParameter("hasSecManageRight_str");
	String parentId = request.getParameter("parentId");
	String parentName = request.getParameter("parentName");
	String uploadExt = request.getParameter("uploadExt");
	String dirid = request.getParameter("dirid");
	String dirtype = request.getParameter("dirtype");
	String subcategoryid = request.getParameter("subcategoryid");
	String categoryname = request.getParameter("categoryname");
	String coder = request.getParameter("coder");
	int noRepeatedName = Util.getIntValue(request.getParameter("noRepeatedName"),0);
	int detachable = Util.getIntValue(request.getParameter("detachable"),0);
	String isDialog = request.getParameter("isDialog");
	int isControledByDir = Util.getIntValue(request.getParameter("isControledByDir"),0);
	String secorder = request.getParameter("secorder");
	String publishable = request.getParameter("publishable");
	String defaultDummyCata = request.getParameter("defaultDummyCata");
	String ischeck = request.getParameter("ischeck");
	String PCreaterManager = request.getParameter("PCreaterManager");
	String PCreaterSubCompLS = request.getParameter("PCreaterSubCompLS");
	int isSetShare = Util.getIntValue(request.getParameter("isSetShare"),0);
	int defaultLockedDoc = Util.getIntValue(request.getParameter("defaultLockedDoc"),0);
	int noDownload = Util.getIntValue(request.getParameter("noDownload"),0);
	int maxOfficeDocFileSize = Util.getIntValue(request.getParameter("maxOfficeDocFileSize"),0);
	int maxUploadFileSize = Util.getIntValue(request.getParameter("maxUploadFileSize"),0);
	int pubOperation = Util.getIntValue(request.getParameter("pubOperation"),0);
	int pushOperation = Util.getIntValue(request.getParameter("pushOperation"),0);
	String pushways = request.getParameter("pushways");
	String pushtoMobile="";
	String pushtoEmessage="";
	String pushtoEmail="";
	String pushtoMessage="";
	if(!"".equals(pushways)){
	    String[] pushwaystemp =pushways.split(",");
	    pushtoMobile=pushwaystemp[0];
	    pushtoEmessage=pushwaystemp[1];
	    pushtoEmail=pushwaystemp[2];
	    pushtoMessage=pushwaystemp[3];
	}
	int orderable = Util.getIntValue(request.getParameter("orderable"),0);
	int markable = Util.getIntValue(request.getParameter("markable"),0);
	int relationable = Util.getIntValue(request.getParameter("relationable"),0);
	int markAnonymity = Util.getIntValue(request.getParameter("markAnonymity"),0);
	int childDocReadRemind = Util.getIntValue(request.getParameter("childDocReadRemind"),0);
	String hashrmres = request.getParameter("hashrmres");
	String hascrm = request.getParameter("hascrm");
	String groupAttrs2="{'groupDisplay':'none','itemAreaDisplay':'none'}"; 
    String groupAttrs="{'groupDisplay':''}";  
	String  itemAttrs="{'display':''}"; 
    String itemAttrs2="{'display':'none'}"; 
	int readOpterCanPrint = Util.getIntValue(request.getParameter("readOpterCanPrint"),0);
	String replyable = request.getParameter("replyable");
	int appointedWorkflowId = Util.getIntValue(request.getParameter("appointedWorkflowId"),0);
	int allownModiMShareL = Util.getIntValue(request.getParameter("allownModiMShareL"),0);
	String shareable = request.getParameter("shareable");
	int bacthDownload = Util.getIntValue(request.getParameter("bacthDownload"),0);
	int isOpenAttachment = Util.getIntValue(request.getParameter("isOpenAttachment"),0);
	int isAutoExtendInfo = Util.getIntValue(request.getParameter("isAutoExtendInfo"),0);
	String isPrintControl = request.getParameter("isPrintControl");
	String printApplyWorkflowId = request.getParameter("printApplyWorkflowId");
	int logviewtype = Util.getIntValue(request.getParameter("logviewtype"),0);
	String isLogControl = request.getParameter("isLogControl");
	String isUseFTPOfSystem = request.getParameter("isUseFTPOfSystem");
	String hasasset = request.getParameter("hasasset");
	String assetlabel = request.getParameter("assetlabel");
	String hrmreslabel = request.getParameter("hrmreslabel");
	String hasproject = request.getParameter("hasproject");
	String crmlabel = request.getParameter("crmlabel");
	String projectlabel = request.getParameter("projectlabel");
	String approvewfid = request.getParameter("approvewfid");
	String PCreater = request.getParameter("PCreater");
	String PCreaterSubComp = request.getParameter("PCreaterSubComp");
	String PCreaterDepart = request.getParameter("PCreaterDepart");
	String PCreaterDepartLS = request.getParameter("PCreaterDepartLS");
	String PCreaterW = request.getParameter("PCreaterW");
	String PCreaterManagerW = request.getParameter("PCreaterManagerW");
	
	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
	String appliedTemplateName = request.getParameter("appliedTemplateName");
	int operatelevel = Util.getIntValue(request.getParameter("operatelevel"),0);
	String appliedTemplateId = request.getParameter("appliedTemplateId");
	 
	String searchMsg = SystemEnv.getHtmlLabelName(129944,user.getLanguage()).replaceAll("\"","'");
	boolean canEdit = false;
	boolean hasSecManageRight = false;
	if("true".equals(canEdit_str))
		canEdit = true;
	if("true".equals(hasSecManageRight_str))
		hasSecManageRight = true;
 %>
 
<div id="divContent">
		<%if(canEdit){ %>
			<span style="display:none;">
			   <brow:browser viewType="0" browserBtnID="dirMouldBtn" name="dirmouldid" browserValue='<%=""+appliedTemplateId%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/category/DocSecCategoryTmplBrowser.jsp"
				hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='1' language='<%=""+user.getLanguage() %>'
				_callback="changeTemplate"
				completeUrl="/data.jsp?type=9" linkUrl="#" temptitle='<%=SystemEnv.getHtmlLabelName(19456,user.getLanguage())%>'
				browserSpanValue='<%= appliedTemplateName%>'></brow:browser>
			</span>	
		<%} %>
		<wea:layout>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%>'>
				<wea:item type="groupHead">
					<a name="baseInfoSet" id="baseInfoSet">
					
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(81530,user.getLanguage())%></wea:item>
				<wea:item>
					<%if(canEdit && HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user)){%>
						<% 
							String completeUrl="/data.jsp?type=categoryBrowser&onlySec=true&currentSecId="+id;
							String browserUrl="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/category/MultiCategorySingleBrowser.jsp?currentSecId="+id;
							if(!HrmUserVarify.checkUserRight("DocSecCategoryEdit:edit", user) && hasSecManageRight){
								completeUrl+="&operationcode="+MultiAclManager.OPERATION_CREATEDIR;
								browserUrl+="?operationcode="+MultiAclManager.OPERATION_CREATEDIR;
							}
						%>
							<span>
							   <brow:browser viewType="0" name="parentid" idKey="id" nameKey="path" browserValue='<%=""+parentId%>' 
								browserUrl='<%=browserUrl %>'
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' language='<%=""+user.getLanguage() %>'
								completeUrl='<%=completeUrl %>' linkUrl="#" temptitle='<%=SystemEnv.getHtmlLabelName(81530,user.getLanguage())%>'
								browserSpanValue='<%= parentName%>' _callback="showOrHideExtendAttr"></brow:browser>
							</span>	
					<%}else{
						if(canEdit){
					%> 
						<input type=hidden name="parentid" value="<%=parentId%>">
					<%} %>
						<%=parentName %>
					<%} %>
					<input type=hidden name="dirid" id="dirid" value="<%=dirid%>">
					<input type=hidden name="dirType" id="dirType" value="<%=dirtype%>">
					<input type=hidden name="subcategoryid" value="<%=subcategoryid%>">
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(24764,user.getLanguage())%></wea:item>
				<wea:item>
					<wea:required id="categorynamespan" required="true" value='<%=categoryname%>'>
						<%if(canEdit){%>
							<INPUT class=InputStyle maxLength=100 size=60 name=categoryname value="<%=categoryname%>" onChange="checkinput('categoryname','categorynamespan')">
						<%}else{%>
							<%=categoryname%>
						<%}%>
							<INPUT type=hidden maxLength=100 size=60 name=srccategoryname value="<%=categoryname%>" >
					</wea:required>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(81529,user.getLanguage())%></wea:item>
				<wea:item><%if(canEdit){%><INPUT maxLength=50 size=30 class=InputStyle name="coder" value='<%=coder%>'><%}else{%><%=coder%><%}%></wea:item>
				<wea:item>ID</wea:item>
				<wea:item>
					<%=id%>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
				<wea:item>
					<%if(canEdit){%><INPUT maxLength=5 size=5 style="width:50px;" class=InputStyle name="secorder" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("secorder")' value="<%=secorder%>"><%}else{%><%=secorder%><%}%>
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(19449,user.getLanguage())%></wea:item>
				<wea:item>
					  <INPUT class=InputStyle tzCheckbox="true" type=checkbox <%if(noRepeatedName==1){%>checked<%}%> <%if(noRepeatedName==11){%>checked disabled<%}%> value=1 name="noRepeatedName" <%if(!canEdit){%>disabled<%}%>>
					    <%if(isDialog.equals("1")){%>
						 <INPUT  type=hidden value=<%=isControledByDir%> id="isControledByDir" name="isControledByDir" >
						 <INPUT  type=hidden value=<%=defaultDummyCata%> id="defaultDummyCata" name="defaultDummyCata" >
						<%}%>
				</wea:item>
				<%if(detachable==1 && Util.getIntValue(parentId)<=0){ 
					String attrs = "{'samePair':'_subcompanyid'}";
				%>
    			<wea:item attributes='<%=attrs %>'><%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
    			<wea:item attributes='<%=attrs %>'>
    				<span>
		        		<brow:browser viewType="0" name="subcompanyId" browserValue='<%= ""+subcompanyid %>' 
		                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
		                language='<%=""+user.getLanguage() %>'
		                hasInput='<%=operatelevel>0?"true":"false" %>' isSingle="true" hasBrowser = "true" isMustInput='<%=operatelevel>0?"2":"0" %>'
		                completeUrl="/data.jsp?type=164"  temptitle='<%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>'
		                browserSpanValue='<%=subcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid+""),user.getLanguage()):""%>'>
		        		</brow:browser>
		        	</span>
    			</wea:item>
    		<%} %>

<%
String itemAttrs_isDialog=!isDialog.equals("1")?itemAttrs:itemAttrs2;
if(!isDialog.equals("1")){%>
					<wea:item attributes="<%=itemAttrs_isDialog %>"><%=SystemEnv.getHtmlLabelName(19459,user.getLanguage())%></wea:item>
					<wea:item attributes="<%=itemAttrs_isDialog %>">
						 <INPUT class=InputStyle  tzCheckbox="true" type=checkbox <%if(isControledByDir==1){%>checked<%}%> value=1 name="isControledByDir" <%if(!canEdit){%>disabled<%}%>>
					</wea:item>
					<wea:item attributes="<%=itemAttrs_isDialog %>"><%=SystemEnv.getHtmlLabelName(20498,user.getLanguage())%></wea:item>
					<wea:item attributes="<%=itemAttrs_isDialog %>">
						<%if(canEdit){
						String spanvalue = DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(defaultDummyCata).replaceAll("\\\"","'");
						%>
							<span>
							   <brow:browser viewType="0" name="defaultDummyCata" browserValue='<%=""+defaultDummyCata%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para=#id#_1"
								hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1' language='<%=""+user.getLanguage() %>'
								completeUrl="/data.jsp?type=9" linkUrl="#" temptitle='<%=SystemEnv.getHtmlLabelName(20498,user.getLanguage())%>'
								browserSpanValue='<%=spanvalue%>'></brow:browser>
							</span>	
						<%}else{%> 
							<%= DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(defaultDummyCata).replaceAll("\\\"","'")%>
						<%}%>
					</wea:item>
<%}%>				
			</wea:group>
			 <%String isdisable = ""; %>
			
				 <wea:group context='<%=SystemEnv.getHtmlLabelName(32383,user.getLanguage())%>'  attributes='<%=!isDialog.equals("1")?groupAttrs:groupAttrs2 %>'>
						<wea:item type="groupHead">
							<a name="managentSet" id="managentSet">
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(32387,user.getLanguage())%></wea:item>
						<wea:item>  
							<INPUT class=InputStyle  tzCheckbox="true" type=checkbox <%if(pubOperation==1){%>checked<%}%> value=1 name="pubOperation" <%if(!canEdit){%>disabled<%}%>>
						</wea:item>	
						<wea:item> <%=SystemEnv.getHtmlLabelName(19790,user.getLanguage())%></wea:item>
						<wea:item>
							 <%
								if(!canEdit) isdisable ="disabled";
								ischeck="";
								if(publishable.equals("1")) ischeck=" checked";
							%>
							<input class=InputStyle tzCheckbox="true"  type=checkbox value=1 name=publishable <%=ischeck%> <%=isdisable%>>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(115,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></wea:item>
						<wea:item>
							 <%
								isdisable = "";
								if(!canEdit) isdisable ="disabled";
								ischeck="";
								if(replyable.equals("1")) ischeck=" checked";
							%>
							  <input class=InputStyle tzCheckbox="true" type=checkbox value=1 name=replyable <%=ischeck%> <%=isdisable%>>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(18572,user.getLanguage())%></wea:item>
						<wea:item>
							<INPUT class=InputStyle tzCheckbox="true" type=checkbox <%if(orderable==1){%>checked<%}%> value=1 name="orderable" <%if(!canEdit){%>disabled<%}%>>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(18575,user.getLanguage())%></wea:item>
						<wea:item>
							 <INPUT class=InputStyle tzCheckbox="true" type=checkbox <%if(markable==1){%>checked<%}%> value=1 name="markable" onclick="onMarkableClick()" <%if(!canEdit){%>disabled<%}%>>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(18576,user.getLanguage())%></wea:item>
						<wea:item> 
							<INPUT class=InputStyle tzCheckbox="true" type=checkbox  <%if(markable!=1){%>disabled<%}%> <%if(markAnonymity==1){%>checked<%}%> value=1 name="markAnonymity" <%if(!canEdit){%>disabled<%}%>>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(22672,user.getLanguage())%></wea:item>
						<wea:item>
							 <INPUT class=InputStyle tzCheckbox="true" type=checkbox <%if(relationable==1){%>checked<%}%> value=1 name="relationable" <%if(!canEdit){%>disabled<%}%>>
						</wea:item>
			<!-- 新文档阅读 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(131339,user.getLanguage())%></wea:item>
			<wea:item>
			<INPUT class=InputStyle  tzCheckbox="true" type=checkbox <%if(pushOperation==1){%>checked<%}%> value=1 onclick="onPushOperationClick();" name="pushOperation" <%if(!canEdit){%>disabled<%}%>>
			<div>
								<span  class="pushway" <%if(pushOperation!=1){%>style="display:none"<%}%> <%if(!canEdit){%>disabled<%}%>>
									<%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%>：
									<%if(UtilForSendNewDoc.isSendForMobile()){%>
										<input  name="pushtoMobile" type="checkbox" <%if("1".equals(pushtoMobile)){%>checked<%}%> value="1"/>&nbspe-mobile<%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>&nbsp&nbsp
									 <%}else{%>
									 	<input  name="pushtoMobile" type="hidden" value="0"/>
									<%}%>
									<%if(UtilForSendNewDoc.isSendForMessage()){%>
										<input  name="pushtoEmessage" type="checkbox" <%if("1".equals(pushtoEmessage)){%>checked<%}%> value="1"/>&nbspe-message<%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>&nbsp&nbsp
                                    <%}else{%>
										 <input  name="pushtoEmessage" type="hidden" value="0"/>
									<%}%>
									<input  name="pushtoEmail" type="checkbox" <%if("1".equals(pushtoEmail)){%>checked<%}%> value="1"/>&nbsp<%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>&nbsp&nbsp<a href="/email/maint/MailSystemFrame.jsp" target="_blank"><img src="/images/homepage/style/setting_wev8.png"/></a>&nbsp&nbsp
									<input  name="pushtoMessage" type="checkbox" <%if("1".equals(pushtoMessage)){%>checked<%}%> value="1"/>&nbsp<%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>&nbsp&nbsp<a href="/sms/SmsSetupTab.jsp?method=ALL" target="_blank"><img src="/images/homepage/style/setting_wev8.png"/></a>
							</span>
			</div>
			<div >
								<span  class="pushway" <%if(pushOperation!=1){%>style="display:none"<%}%> >
									<a href="#" onclick="settingForNewDoc();"><%=SystemEnv.getHtmlLabelName(27415 ,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></a>（<%=SystemEnv.getHtmlLabelName(131392,user.getLanguage())%>）
								</span>
			</div>
			</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(19461,user.getLanguage())%></wea:item>
						<wea:item>
							 <INPUT class=InputStyle tzCheckbox="true" type=checkbox <%if(childDocReadRemind==1){%>checked<%}%> value=1 name="childDocReadRemind" <%if(!canEdit){%>disabled<%}%>>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(18578,user.getLanguage())%></wea:item>
						<wea:item>
							<INPUT class=InputStyle tzCheckbox="true" type=checkbox <%if(defaultLockedDoc==1){%>checked<%}%> value=1 name="defaultLockedDoc" <%if(!canEdit){%>disabled<%}%>>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(21382,user.getLanguage())%></wea:item>
						<wea:item>
							<%if(canEdit){%>
								<span>
							   <brow:browser viewType="0" name="appointedWorkflowId" browserValue='<%=""+appointedWorkflowId%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1"
								hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=9" linkUrl="#" 
								browserSpanValue='<%= WorkflowComInfo.getWorkflowname(""+appointedWorkflowId)%>'></brow:browser>
								</span>						
								<%}else{%>
											<%=WorkflowComInfo.getWorkflowname(""+appointedWorkflowId)%>
								<%}%>
						</wea:item>
				 </wea:group>
				 <wea:group context='<%=SystemEnv.getHtmlLabelName(2112,user.getLanguage())%>'  attributes='<%=!isDialog.equals("1")?groupAttrs:groupAttrs2 %>'>
					<wea:item type="groupHead">
						<a name="shareSet" id="shareSet">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(20449,user.getLanguage())%></wea:item>
					<wea:item>
						 <%
							ischeck="";
							if(shareable.equals("1")) ischeck=" checked";
							%>
							  <%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%><input type="checkbox" name="allownModiMShareL" class="inputstyle" value="1" <%if(allownModiMShareL==1){out.println("checked");}%> <%if(!canEdit){%>disabled<%}%>>
							&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18574,user.getLanguage())%><INPUT class=InputStyle type=checkbox value=1 name=shareable <%=ischeck%> <%=isdisable%>> 
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(19435,user.getLanguage())%></wea:item>
					<wea:item>
						 <INPUT class=InputStyle tzCheckbox="true" type=checkbox <%if(isSetShare==1){%>checked<%}%> value=1 name="isSetShare" <%if(!canEdit){%>disabled<%}%>>
					</wea:item>
				 </wea:group>
				  <wea:group context='<%=SystemEnv.getHtmlLabelName(32384,user.getLanguage())%>'  attributes='<%=!isDialog.equals("1")?groupAttrs:groupAttrs2 %>'>
					<wea:item type="groupHead">
						<a name="officeDocSet" id="officeDocSet">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(19458,user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle tzCheckbox="true"  type=checkbox <%if(noDownload==1){%>checked<%}%> value=1 name="noDownload" <%if(!canEdit){%>disabled<%}%>>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(24024,user.getLanguage())%></wea:item>
					<wea:item>
						 <INPUT class=InputStyle type=input size=4 style="width:30px;" defValue="<%=maxOfficeDocFileSize%>" onchange="checkPositiveNumber('<%=SystemEnv.getHtmlLabelName(24024,user.getLanguage())%>',this)" name="maxOfficeDocFileSize" onKeyPress="ItemCount_KeyPress()" value="<%=maxOfficeDocFileSize%>" <%if(!canEdit){%>disabled<%}%>>M（<%=SystemEnv.getHtmlLabelName(24025,user.getLanguage())%>）
					</wea:item>
				</wea:group>
				 <wea:group context='<%=SystemEnv.getHtmlLabelName(23796,user.getLanguage())%>'  attributes='<%=!isDialog.equals("1")?groupAttrs:groupAttrs2 %>'>
					<wea:item type="groupHead">
						<a name="attachmentSet" id="attachmentSet"></a>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(18580,user.getLanguage())%></wea:item>
					<wea:item>
						 <INPUT class=InputStyle style="width:30px;" defValue="<%=maxUploadFileSize%>" onchange="checkPositiveNumber('<%=SystemEnv.getHtmlLabelName(18580,user.getLanguage())%>',this)" type=input size=4 name="maxUploadFileSize" onKeyPress="ItemCount_KeyPress()" value="<%=maxUploadFileSize%>" <%if(!canEdit){%>disabled<%}%>>M
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(27025,user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle tzCheckbox="true" type=checkbox <%if(bacthDownload==1){%>checked<%}%> <%if(noDownload==1){%>disabled<%}%> value=1 name="bacthDownload" <%if(!canEdit){%>disabled<%}%>>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(24000,user.getLanguage())%></wea:item>
					<wea:item>
						 <INPUT class=InputStyle tzCheckbox="true" type=checkbox <%if(isOpenAttachment==1){%>checked<%}%> value=1 name="isOpenAttachment"  <%if(!canEdit){%>disabled<%}%>>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(24417,user.getLanguage())%></wea:item>
					<wea:item>
						  <INPUT class=InputStyle tzCheckbox="true" type=checkbox <%if(isAutoExtendInfo==1){%>checked<%}%> value=1 name="isAutoExtendInfo"  <%if(!canEdit){%>disabled<%}%>>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(127231,user.getLanguage())%></wea:item>
						<wea:item>
						<input type="text"  class="InputStyle" style="width:50%" id="uploadExt" name="uploadExt" value="<%=uploadExt%>" <% if(!canEdit) { %>disabled<%}%>></input>
						  <span class="e8tips" title="<%=searchMsg%>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
						</wea:item>
				</wea:group>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(20756,user.getLanguage())%>'  attributes='<%=!isDialog.equals("1")?groupAttrs:groupAttrs2 %>'>
					<wea:item type="groupHead">
						<a name="printSet" id="printSet">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(21528,user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle tzCheckbox="true" type=checkbox <%if(isPrintControl.equals("1")){%>checked<%}%> value=1 name="isPrintControl"  <%if(!canEdit){%>disabled<%}%>>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(21532,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(canEdit){%>
							<span>
							   <brow:browser viewType="0" name="printApplyWorkflowId" browserValue='<%=""+printApplyWorkflowId%>' 
								browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere="+xssUtil.put(" where isbill=1 and formid=200")%>'
								hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=9" linkUrl="#" 
								browserSpanValue='<%= WorkflowComInfo.getWorkflowname(""+printApplyWorkflowId)%>'></brow:browser>
						</span>			
					<%}else{%>
								<%=WorkflowComInfo.getWorkflowname(""+printApplyWorkflowId)%>
					<%}%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(19462,user.getLanguage())%></wea:item>
					<wea:item>
						<select  class=InputStyle style="width:100px;" name=readOpterCanPrint size=1 <%if(!canEdit){%>disabled<%}%>>
							<option value=1 <%if(readOpterCanPrint==1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(115,user.getLanguage())%></option>
							<option value=0 <%if(readOpterCanPrint==0){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(233,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(115,user.getLanguage())%></option>
							<option value=2 <%if(readOpterCanPrint==2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(19463,user.getLanguage())%></option>
						</select>
					</wea:item>
				</wea:group>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(21990,user.getLanguage())%>'  attributes='<%=!isDialog.equals("1")?groupAttrs:groupAttrs2 %>'>
					<wea:item type="groupHead">
						<a name="docLog" id="docLog">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(20997,user.getLanguage())%></wea:item>
					<wea:item>
						<select style="width:150px;"  class=InputStyle name=logviewtype size=1 <%if(!canEdit){%>disabled<%}%>>
							<option value=0 <%if(logviewtype==0){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(20998,user.getLanguage())%></option>
							<!-- TD12005 文档日志查看 "仅管理员能查看"改为"按文档日志权限查看" -->
							<option value=1 <%if(logviewtype==1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(23751,user.getLanguage())%></option>
						</select>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(21996,user.getLanguage())%></wea:item>
					<wea:item>
						  <INPUT class=InputStyle tzCheckbox="true" type=checkbox <%if(isLogControl.equals("1")){%>checked<%}%> value=1 name="isLogControl"  <%if(!canEdit){%>disabled<%}%>>
					</wea:item>
				</wea:group>
				<%
					if("1".equals(isUseFTPOfSystem)){%>
					<jsp:include page="DocSecCategoryBaseInfoEdit_inner3.jsp">
			    		<jsp:param name="canEdit" value="<%=canEdit %>"/>
			    		<jsp:param name="id" value="<%=id %>"/>
			    		<jsp:param name="isDialog" value="<%=isDialog %>"/>
			    		<jsp:param name="isUseFTPOfSystem" value="<%=isUseFTPOfSystem %>"/>
			    	</jsp:include>
			<%}%>

			
				<wea:group context='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>' attributes='<%=!isDialog.equals("1")?groupAttrs:groupAttrs2 %>' >
					<wea:item type="groupHead">
						<a name="type" id="type"></a>
					</wea:item>
					<%String attrs = "{\"isTableList\":true}"; %>
					<wea:item attributes='<%=attrs %>'>
						<wea:layout type="fourCol" needImportDefaultJsAndCss="false" attributes='<%=attrs %>'>
							<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
								<%if(software.equals("ALL")){%>
									<wea:item><%=SystemEnv.getHtmlLabelName(16173,user.getLanguage())%></wea:item>
									<wea:item>
										<select  class=InputStyle name=hasasset size=1 <%=isdisable%>>
											<option value=1 <%if(hasasset.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16174,user.getLanguage())%></option>
											<option value=0 <%if(hasasset.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16175,user.getLanguage())%></option>
											<option value=2 <%if(hasasset.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16176,user.getLanguage())%></option>
										</select>
									</wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></wea:item>
									<wea:item>
										<input class=InputStyle maxlength=30 size=15 name=assetlabel value="<%=Util.toScreenToEdit(assetlabel,user.getLanguage())%>" <%=isdisable%>>
									</wea:item>
								<%}%>
								<wea:item><%=SystemEnv.getHtmlLabelName(16177,user.getLanguage())%></wea:item>
								<wea:item>
									<select class=InputStyle  name=hashrmres size=1 <%=isdisable%>>
										<option value=1 <%if(hashrmres.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16174,user.getLanguage())%></option>
										<option value=0 <%if(hashrmres.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16175,user.getLanguage())%></option>
										<option value=2 <%if(hashrmres.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16176,user.getLanguage())%></option>
									</select>
								</wea:item>
								<wea:item><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></wea:item>
								<wea:item>
									<input class=InputStyle maxlength=30 size=15 name=hrmreslabel value="<%=Util.toScreenToEdit(hrmreslabel,user.getLanguage())%>" <%=isdisable%>>
								</wea:item>
								<%if(software.equals("ALL") || software.equals("CRM")){%>
									<wea:item>CRM<%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></wea:item>
									<wea:item>
										<select class=InputStyle  name=hascrm size=1 <%=isdisable%>>
											<option value=1 <%if(hascrm.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16174,user.getLanguage())%></option>
											<option value=0 <%if(hascrm.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16175,user.getLanguage())%></option>
											<option value=2 <%if(hascrm.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16176,user.getLanguage())%></option>
										</select>
									</wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></wea:item>
									<wea:item>
										<input class=InputStyle maxlength=30 size=15 name=crmlabel value="<%=Util.toScreenToEdit(crmlabel,user.getLanguage())%>" <%=isdisable%>>
									</wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(16178,user.getLanguage())%></wea:item>
									<wea:item>
										<select class=InputStyle  name=hasproject size=1 <%=isdisable%>>
											<option value=1 <%if(hasproject.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16174,user.getLanguage())%></option>
											<option value=0 <%if(hasproject.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16175,user.getLanguage())%></option>
											<option value=2 <%if(hasproject.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16176,user.getLanguage())%></option>
										</select>
									</wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></wea:item>
									<wea:item>
										<input class=InputStyle maxlength=30 size=15 name=projectlabel value="<%=Util.toScreenToEdit(projectlabel,user.getLanguage())%>" <%=isdisable%>>
									</wea:item>
								<%}%>
							</wea:group>
						</wea:layout>
					</wea:item>
				</wea:group>
		</wea:layout>
    	<jsp:include page="DocSecCategoryBaseInfoEdit_inner2.jsp">
    		<jsp:param name="canEdit" value="<%=canEdit %>"/>
    		<jsp:param name="approvewfid" value="<%=approvewfid %>"/>
    		<jsp:param name="PCreaterSubCompLS" value="<%=PCreaterSubCompLS %>"/>
    		<jsp:param name="PCreaterDepartLS" value="<%=PCreaterDepartLS %>"/>
    		<jsp:param name="id" value="<%=id %>"/>
    		<jsp:param name="PCreater" value="<%=PCreater %>"/>
    		<jsp:param name="PCreaterManager" value="<%=PCreaterManager %>"/>
    		<jsp:param name="PCreaterSubComp" value="<%=PCreaterSubComp %>"/>
    		<jsp:param name="PCreaterDepart" value="<%=PCreaterDepart %>"/>
    		<jsp:param name="PCreaterW" value="<%=PCreaterW %>"/>
    		<jsp:param name="PCreaterManagerW" value="<%=PCreaterManagerW %>"/>
    	</jsp:include>
        </div>
