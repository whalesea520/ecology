
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj,weaver.general.Util" %>
<%@ page import="weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.common.util.taglib.BrowserUtil" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>

<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	int secid=Util.getIntValue(request.getParameter("secid"), -1);

	//out.println(secid);



	int ownerid=Util.getIntValue(request.getParameter("ownerid"),0);
	if(ownerid==0) ownerid=user.getUID() ;
	String owneridname=ResourceComInfo.getResourcename(ownerid+"");


	//System.out.println(secid);
	int subid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+secid), -1);
    int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subid), -1);

	RecordSet.executeProc("Doc_SecCategory_SelectByID",secid+"");
	RecordSet.next();
	String publishable=Util.null2String(""+RecordSet.getString("publishable"));


	String needinputitems = "";

%>



<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(19789,user.getLanguage())%><!--新闻类型--></wea:item>
		<wea:item>
			<%
				if(!publishable.trim().equals("") && !publishable.trim().equals("0")){				
			%>
				<input type=radio name="docpublishtype" id="sel0" value=1 onClick="onshowdocmain(0)"> 
				<label for="sel0"><font color=red><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></font></label>
				<input type=radio name="docpublishtype" id="sel1" value=2 onClick="onshowdocmain(1)" checked><label for="sel1"><font color=red><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></font></label>

				<input type=radio name="docpublishtype" id="sel2" value=3 onClick="onshowdocmain(0)"><label for="sel2"><font color=red><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></font></label>							
			<%
			} else {
				out.println(SystemEnv.getHtmlLabelName(58,user.getLanguage()));
			} 
			%>			
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18656,user.getLanguage())%><!--文档所有者--></wea:item>
		<wea:item>
			<span>
					  <brow:browser viewType="0" name="ownerid" browserValue='<%= ""+ownerid %>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
                completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="30%"
                browserSpanValue='<%=owneridname%>'></brow:browser>
                </span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%><!--虚拟目录--></wea:item>
		<wea:item>
			<%
			String dummyIds="";
			String dummyNames="";
			String strSql="select defaultDummyCata from DocSecCategory where id="+secid;
			rsDummyDoc.executeSql(strSql);
			
			if(rsDummyDoc.next()){							
				dummyIds=Util.null2String(rsDummyDoc.getString("defaultDummyCata"));
				dummyNames=DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(dummyIds,",");
			}						
			%>
			 <span>
					  <brow:browser viewType="0" name="dummycata" browserValue='<%= ""+dummyIds %>' 
                browserUrl="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="
                temptitle='<%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%>'
                language='<%=""+user.getLanguage() %>'
                hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
                width="30%" browserSpanValue='<%=dummyNames%>'></brow:browser>
                </span>
		</wea:item>
		<%

	String  prjid = Util.null2String(request.getParameter("prjid"));
	String  crmid=Util.null2String(request.getParameter("crmid"));
	String  hrmid=Util.null2String(request.getParameter("hrmid"));


	String sepStr="<TR id=oDiv style=\"display:'';height:1px\"><TD class=Line colSpan=4></TD></TR>";
	RecordSet.executeProc("Doc_SecCategory_SelectByID",""+secid);
	if(RecordSet.next());
	String hasasset=Util.toScreen(RecordSet.getString("hasasset"),user.getLanguage());
	String assetlabel=Util.toScreen(RecordSet.getString("assetlabel"),user.getLanguage());
	String hasitems =Util.toScreen(RecordSet.getString("hasitems"),user.getLanguage());
	String itemlabel =Util.toScreenToEdit(RecordSet.getString("itemlabel"),user.getLanguage());
	String hashrmres =Util.toScreen(RecordSet.getString("hashrmres"),user.getLanguage());
	String hrmreslabel =Util.toScreenToEdit(RecordSet.getString("hrmreslabel"),user.getLanguage());
	String hascrm =Util.toScreen(RecordSet.getString("hascrm"),user.getLanguage());
	String crmlabel =Util.toScreenToEdit(RecordSet.getString("crmlabel"),user.getLanguage());
	String hasproject =Util.toScreen(RecordSet.getString("hasproject"),user.getLanguage());
	String projectlabel =Util.toScreenToEdit(RecordSet.getString("projectlabel"),user.getLanguage());
	String hasfinance =Util.toScreen(RecordSet.getString("hasfinance"),user.getLanguage());
	String financelabel =Util.toScreenToEdit(RecordSet.getString("financelabel"),user.getLanguage());
	String isSetShare=Util.null2String(""+RecordSet.getString("isSetShare"));
	String maxuploadfilesize = Util.null2String(RecordSet.getString("maxuploadfilesize"));
	if(!hashrmres.trim().equals("")&&!hashrmres.trim().equals("0")){
			String curlabel = SystemEnv.getHtmlLabelName(179,user.getLanguage());
			if(!hrmreslabel.trim().equals("")) curlabel = hrmreslabel;
			%>
				<wea:item><%=curlabel%></wea:item>
				<wea:item>
					<%if(!user.getLogintype().equals("2")){%>
					<span>
					<%String click = "onShowHrmresID("+hashrmres+",hrmresidspan)"; %>
					  <brow:browser viewType="0" name="hrmresid" browserValue='<%= ""+hrmid %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=hashrmres.equals("2")?"2":"1" %>'
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="30%"
					browserSpanValue='<%=!hrmid.equals("")?ResourceComInfo.getResourcename(hrmid):""%>'></brow:browser>
					</span>
					<%}%>
					<%if(hrmid.equals("")){%>
						<%if(hashrmres.equals("2")){
							needinputitems += ",hrmresid";
						%>
						<%}%>
					<% } else { %>
					<% } %>
				</wea:item>
		<%			
		} else {
		%>
			<wea:item attributes="{'colspan':'full','display':'none','samePair':'hidden2'}">
				<input type=hidden name=hrmresid value=<%=hrmid%>/>
			</wea:item>
		<%
		}
		if(!hasasset.trim().equals("")&&!hasasset.trim().equals("0")){
			String curlabel = SystemEnv.getHtmlLabelName(535,user.getLanguage());
			if(!assetlabel.trim().equals("")) curlabel = assetlabel;
		%>
			<wea:item><%=curlabel%></wea:item>
			<wea:item>
				<% if(!user.getLogintype().equals("2")) { %>
					<span>
					<%String click = "onShowAssetId("+hasasset+")"; %>
					  <brow:browser viewType="0" name="assetid" browserValue="" 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp"
                hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='<%=hasasset.equals("2")?"2":"1" %>'
                completeUrl="/data.jsp" linkUrl="#" width="30%"
                ></brow:browser>
                </span>
				<% } %>
				<% if(hasasset.equals("2")) {
						needinputitems += ",assetid";
				%>
				<% } %>
			</wea:item>
		<%					
		}
		if(!hascrm.trim().equals("")&&!hascrm.trim().equals("0")){
			String curlabel = SystemEnv.getHtmlLabelName(147,user.getLanguage());
			if(!crmlabel.trim().equals("")) curlabel = crmlabel;
			String click = "onShowCrmID("+hascrm+")"; 
		%>
			<wea:item><%=curlabel%></wea:item>
			<wea:item>
				<span>
					  <brow:browser viewType="0" name="crmid" browserValue='<%= ""+crmid %>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=hascrm.equals("2")?"2":"1" %>'
                completeUrl="/data.jsp?type=7" linkUrl="#" width="30%"
                browserSpanValue='<%=!crmid.equals("")?CustomerInfoComInfo.getCustomerInfoname(crmid):""%>'></brow:browser>
					  </span>
				<%if(crmid.equals("")){%>
					<%if(hascrm.equals("2")){
						needinputitems += ",crmid";
					%>
					<%}%>
				<% } else { %>
					<%=CustomerInfoComInfo.getCustomerInfoname(crmid)%>
				<% } %>
			</wea:item>
		<%
		} else {
		%>
			<wea:item attributes="{'colspan':'full','display':'none','samePair':'hidden1'}">
				<input type=hidden name=crmid value=<%=crmid%>>
			</wea:item>
		<% } %>
		<%
		if(!hasitems.trim().equals("")&&!hasitems.trim().equals("0")){
			String curlabel = SystemEnv.getHtmlLabelName(145,user.getLanguage());
			if(!itemlabel.trim().equals("")) curlabel = itemlabel;
			String click = "onShowItemID("+hasitems+",itemidspan)"; 
		%>
			<wea:item><%=curlabel%></wea:item>
			<wea:item>
				<span>
					  <brow:browser viewType="0" name="itemid"
               browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp"
                hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='<%=hasitems.equals("2")?"2":"1" %>'
                completeUrl="/data.jsp?type=7" linkUrl="#" width="30%"
                ></brow:browser>
					  </span>
				<%if(hasitems.equals("2")){
					needinputitems += ",itemid";
				%>
				<%}%>
			</wea:item>
		<%
		}
		%>
		<%
		if(!hasproject.trim().equals("")&&!hasproject.trim().equals("0")){
			String curlabel = SystemEnv.getHtmlLabelName(101,user.getLanguage());
			if(!projectlabel.trim().equals("")) curlabel = projectlabel;
			String click = "onShowProjectID("+hasproject+")";
		%>
		<wea:item><%=curlabel%></wea:item>
		<wea:item>
			<span>
			  <brow:browser viewType="0" name="projectid" browserValue='<%= ""+prjid %>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
                completeUrl="/data.jsp?type=8" linkUrl="#" width="30%"
                browserSpanValue='<%=!prjid.equals("0")?Util.toScreen(ProjectInfoComInfo.getProjectInfoname(prjid+""),user.getLanguage()):""%>'></brow:browser>
                </span>
				<%if(prjid.equals("")){%>
					<%if(hasproject.equals("2")){
						needinputitems += ",projectid";
					%>
					<%}%>
				<%}else{%>
					<%=ProjectInfoComInfo.getProjectInfoname(prjid)%>
				<%}%>
		</wea:item>
		<%
		} else {
		%>
		<wea:item attributes="{'colspan':'full','display':'none','samePair':'hidden3'}">
			<input type=hidden name=projectid value=<%=prjid%>>
		</wea:item>
		<% } %>
		<%
		if(!hasfinance.trim().equals("")&&!hasfinance.trim().equals("0")){
			String curlabel = SystemEnv.getHtmlLabelName(189,user.getLanguage());
			if(!financelabel.trim().equals("")) curlabel = financelabel;
		%>
			<wea:item><%=curlabel%></wea:item>
			<wea:item>
				<button class=Browser type="button"></button>
				<input type=hidden name=financeid>
			</wea:item>
		<%
		}
		%>
		<%
		SecCategoryDocPropertiesComInfo.addDefaultDocProperties(secid);
		SecCategoryDocPropertiesComInfo.setTofirstRow();
		boolean isHaveValue=false;
		while(SecCategoryDocPropertiesComInfo.next()){
			
			int docPropId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getId());
			int docPropSecCategoryId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getSecCategoryId());
			int docPropViewindex = Util.getIntValue(SecCategoryDocPropertiesComInfo.getViewindex());
			int docPropType = Util.getIntValue(SecCategoryDocPropertiesComInfo.getType());
			int docPropLabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId());
			int docPropVisible = Util.getIntValue(SecCategoryDocPropertiesComInfo.getVisible());
			String docPropCustomName = SecCategoryDocPropertiesComInfo.getCustomName(user.getLanguage());
			int docPropColumnWidth = Util.getIntValue(SecCategoryDocPropertiesComInfo.getColumnWidth());
			int docPropMustInput = Util.getIntValue(SecCategoryDocPropertiesComInfo.getMustInput());
			int docPropIsCustom = Util.getIntValue(SecCategoryDocPropertiesComInfo.getIsCustom());
			String docPropScope = SecCategoryDocPropertiesComInfo.getScope();

			
			int docPropScopeId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getScopeId());
			int docPropFieldid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getFieldId());

			if(docPropSecCategoryId!=secid) continue;
			if(docPropType!=0) continue;

			isHaveValue=true;
			

			String label = "";
			if(!docPropCustomName.equals("")) {
				label = docPropCustomName;
			} else if(docPropIsCustom!=1) {
				label = SystemEnv.getHtmlLabelName(docPropLabelid,user.getLanguage());
				if(docPropType==10) label+="("+SystemEnv.getHtmlLabelName(93,user.getLanguage())+")";
			}
		%>
		<wea:item><%=label%></wea:item>
		<wea:item>
			<%-- 自定义字段 start --%>
					<%
	

					    String docid = Util.null2String(request.getParameter("docid"));
					    CustomFieldManager cfm = new CustomFieldManager(docPropScope,docPropScopeId);
					    cfm.getCustomFields(docPropFieldid);
					    if(cfm.next()){
					        if(cfm.isMand()){
					            needinputitems += ",customfield"+cfm.getId();
					        }
							if(cfm.getHtmlType().equals("1")){
								if(cfm.getType()==1){
									if(cfm.isMand()){
					%>
										<input datatype="text" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" size=50 onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
										<span id="customfield<%=cfm.getId()%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
					<%
									} else {
					%>
										<input datatype="text" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" value="" size=50>
					<%
									}
								} else if(cfm.getType()==2) {
									if(cfm.isMand()){
					%>
										<input datatype="int" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" size=10
										onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
										<span id="customfield<%=cfm.getId()%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
					<%
									} else {
					%>
										<input  datatype="int" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
					<%
									}
								} else if(cfm.getType()==3) {
									if(cfm.isMand()){
					%>
										<input datatype="float" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" size=10
										onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
										<span id="customfield<%=cfm.getId()%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
					<%
									} else {
					%>
										<input datatype="float" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
					<%
		                			}
		            			}
							} else if(cfm.getHtmlType().equals("2")) {
								if(cfm.isMand()) {
					%>
									<textarea class=Inputstyle name="customfield<%=cfm.getId()%>" onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')"
									rows="4" cols="40" style="width:80%" class=Inputstyle></textarea>
									<span id="customfield<%=cfm.getId()%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
					<%
								} else {
					%>
									<textarea class=Inputstyle name="customfield<%=cfm.getId()%>" rows="4" cols="40" style="width:80%"></textarea>
					<%
								}
							} else if(cfm.getHtmlType().equals("3")) {
					
					            String fieldtype = String.valueOf(cfm.getType());
							    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
							    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
							    String showname = "";                                   // 新建时候默认值显示的名称
							    String showid = "";                                     // 新建时候默认值
								String fielddbtype=Util.null2String(cfm.getFieldDbType());

					
					            if(fieldtype.equals("8") && !prjid.equals("")){       //浏览按钮为项目,从前面的参数中获得项目默认值
					                showid = "" + Util.getIntValue(prjid,0);
					            }else if((fieldtype.equals("9") || fieldtype.equals("37")) && !docid.equals("")){ //浏览按钮为文档,从前面的参数中获得文档默认值
					                showid = "" + Util.getIntValue(docid,0);
					            }else if((fieldtype.equals("1") ||fieldtype.equals("17")) && !hrmid.equals("")){ //浏览按钮为人,从前面的参数中获得人默认值
					                showid = "" + Util.getIntValue(hrmid,0);
					            }else if((fieldtype.equals("7") || fieldtype.equals("18")) && !crmid.equals("")){ //浏览按钮为CRM,从前面的参数中获得CRM默认值
					                showid = "" + Util.getIntValue(crmid,0);
					            }else if(fieldtype.equals("4") && !hrmid.equals("")){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
					                showid = "" + Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
					            }else if(fieldtype.equals("24") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
					                showid = "" + Util.getIntValue(ResourceComInfo.getJobTitle(hrmid),0);
					            }else if(fieldtype.equals("32") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
					                showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"),0);
					            }
					
					            if(showid.equals("0")) showid = "" ;
		
					            if(! showid.equals("")){       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
					                String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
					                String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
					                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
					                String sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+showid;
					
					                RecordSet.executeSql(sql);
					                if(RecordSet.next()) {
					                    if(!linkurl.equals(""))
					                        showname = "<a href='"+linkurl+showid+"'>"+RecordSet.getString(1)+"</a>&nbsp";
					                    else
					                        showname =RecordSet.getString(1) ;
					                }
								}
			
								//获得当前的日期和时间
					            Calendar today = Calendar.getInstance();
					            String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
					                    Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
					                    Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
					
					            String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
					                    Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
					                    Util.add0(today.get(Calendar.SECOND), 2) ;
					
					            if(fieldtype.equals("2")){                              // 浏览按钮为日期
					                showname = currentdate;
					                showid = currentdate;
					            }
								if(fieldtype.equals("161")||fieldtype.equals("162")){
									url+="?type="+fielddbtype;
								}
								String click = "onShowBrowser('"+cfm.getId()+"','"+url+"','"+linkurl+"','"+fieldtype+"','"+(cfm.isMand()?"1":"0")+"')";
								String name = "customfield"+cfm.getId();
								String completeUrl = "/data.jsp?type="+fieldtype;
								String isSingle = BrowserUtil.isSingle(fieldtype);
					%>
					<%if (!fieldtype.equals("2")
													&& !fieldtype.equals("19")) {%>
								<span>
						  <brow:browser viewType="0" name='<%=name %>' browserValue='<%= ""+showid %>' 
			               browserUrl='<%=url %>'
			                hasInput="true" isSingle='<%=isSingle %>' hasBrowser = "true" isMustInput='<%=(cfm.isMand() && showname.equals(""))?"2":"1" %>'
			                completeUrl='<%=completeUrl %>' linkUrl="#" width="30%"  
			                browserSpanValue='<%=Util.toScreen(showname,user.getLanguage())%>'></brow:browser>
			                </span>
	                <%}else{ %>
	   			 
					<button class=Calendar type="button"
						<%
						if (fieldtype.equals("2")) {%>
						onClick="onShowDocDate('<%=cfm.getId()%>','<%=fieldtype%>','<%=cfm.isMand()%>')"
						<%} else {%>
						onClick="onShowDocsTime(customfield<%=cfm.getId()%>span,customfield<%=cfm.getId()%>,'<%=cfm.isMand()%>')"
						<%}%>
						title="<%=SystemEnv.getHtmlLabelName(172, user
												.getLanguage())%>"></button>
					<input type=hidden name="customfield<%=cfm.getId()%>"
						value="<%=showid%>" temptitle="<%=label %>"> <span
						id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname, user
												.getLanguage())%>
					<%
						if (cfm.isMand() && showname.equals("")) {
					%> <img src="/images/BacoError_wev8.gif" align=absmiddle> <%
			}%></span> 
						  <% }%> 
					<%
							} else if(cfm.getHtmlType().equals("4")) {
					%>
								<input type=checkbox value=1 name="customfield<%=cfm.getId()%>" >
					<%
							} else if(cfm.getHtmlType().equals("5")) {
								cfm.getSelectItem(cfm.getId());
					%>
								<select name="customfield<%=cfm.getId()%>" class=InputStyle viewtype="<%if (cfm.isMand()) {
												out.print("1");
											} else {
												out.print("0");
											}%>"  onChange="checkinput2('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span',this.getAttribute('viewtype'))">
								<option value=""></option>
					<%
								while(cfm.nextSelect()){
					%>
									<option value="<%=cfm.getSelectValue()%>"><%=cfm.getSelectName()%></option>
					<%
								}
					%>
								</select><span id="customfield<%=cfm.getId()%>span">

								<%
				if (cfm.isMand()) {
			 %> <img src="/images/BacoError_wev8.gif" align=absmiddle> <%
				}
			 %> </span>
					<%
							}
						}
					%>
			</wea:item>
		<%}%>
		<wea:item attributes="{'colspan':'full','display':'none','samePair':'hidden'}">
			<INPUT TYPE="hidden" NAME="needinputitems" id="needinputitems" value="<%=needinputitems%>">
			<input type="hidden" name="docedition" value="-1">
			<input type="hidden" name="doceditionid" value="-1">
			<input type="hidden" name="maxuploadfilesize" id="maxuploadfilesize" value="<%=maxuploadfilesize %>">
		</wea:item>
	</wea:group>
</wea:layout>


	
