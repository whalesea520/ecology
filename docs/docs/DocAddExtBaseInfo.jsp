
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util,
				 java.util.*,
                 weaver.docs.docs.CustomFieldManager,
                 java.net.*" %>
<%@ page import="weaver.docs.category.security.MultiAclManager " %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mouldfile.DocMouldComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page"/>
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="RequestDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>  
<SCRIPT language="javascript" src="/hrm/area/browser/areabrowser_wev8.js"></script>
<LINK href="/hrm/area/browser/areabrowser.css" type=text/css rel=STYLESHEET>


	<%-- 文档类型 start --%>
	

	<%-- 文档类型 end --%>


	<%
	User user = HrmUserVarify.getUser (request , response) ;
	int languageId = user.getLanguage();
	int secid = Util.getIntValue(request.getParameter("secid"),-1);

	String sessionPara=""+secid+"_"+user.getUID()+"_"+user.getLogintype();
	session.setAttribute("right_add_"+sessionPara,"1");	

	String hasasset="";
	String assetlabel="";
	String hasitems ="";
	String itemlabel ="";
	String hashrmres ="";
	String hrmreslabel ="";
	String hascrm ="";
	String crmlabel ="";
	String hasproject ="";
	String projectlabel ="";
	String hasfinance ="";
	String financelabel ="";
	String isSetShare="";

	String replyable = "";
	String readoptercanprint = "";
	String publishable = "";

	RecordSet.executeProc("Doc_SecCategory_SelectByID", ""+secid);
	if(RecordSet.next()){
		hasasset=Util.toScreen(RecordSet.getString("hasasset"),languageId);
		assetlabel=Util.toScreen(RecordSet.getString("assetlabel"),languageId);
		hasitems =Util.toScreen(RecordSet.getString("hasitems"),languageId);
		itemlabel =Util.toScreenToEdit(RecordSet.getString("itemlabel"),languageId);
		hashrmres =Util.toScreen(RecordSet.getString("hashrmres"),languageId);
		hrmreslabel =Util.toScreenToEdit(RecordSet.getString("hrmreslabel"),languageId);
		hascrm =Util.toScreen(RecordSet.getString("hascrm"),languageId);
		crmlabel =Util.toScreenToEdit(RecordSet.getString("crmlabel"),languageId);
		hasproject =Util.toScreen(RecordSet.getString("hasproject"),languageId);
		projectlabel =Util.toScreenToEdit(RecordSet.getString("projectlabel"),languageId);
		hasfinance =Util.toScreen(RecordSet.getString("hasfinance"),languageId);
		financelabel =Util.toScreenToEdit(RecordSet.getString("financelabel"),languageId);
		isSetShare=Util.null2String(""+RecordSet.getString("isSetShare"));

		replyable=Util.null2String(""+RecordSet.getString("replyable"));
		readoptercanprint = Util.null2String(""+RecordSet.getString("readoptercanprint"));
		publishable=Util.null2String(""+RecordSet.getString("publishable"));
	}


	String  prjid = Util.null2String(request.getParameter("prjid"));
	String  crmid=Util.null2String(request.getParameter("crmid"));
	String  hrmid=Util.null2String(request.getParameter("hrmid"));
	String  coworkid = Util.null2String(request.getParameter("coworkid"));
	String  showsubmit=Util.null2String(request.getParameter("showsubmit"));

	String  topage=Util.null2String(request.getParameter("topage"));
	String  tmptopage=URLEncoder.encode(topage);//专门用于页面直接导向
	String from =  Util.null2String(request.getParameter("from"));
	int userCategory= Util.getIntValue(request.getParameter("userCategory"),0);
	boolean isTemporaryDoc = false;
	String invalidationdate = Util.null2String(request.getParameter("invalidationdate"));
	if(invalidationdate!=null&&!"".equals(invalidationdate))
	    isTemporaryDoc = true;
	String docmodule=Util.null2String(request.getParameter("docmodule"));
	String docid = "";
	String docCode = "";

	String usertype = user.getLogintype();
	int ownerid=user.getUID() ;
	String owneridname=ResourceComInfo.getResourcename(ownerid+"");
	boolean isPersonalDoc = false ;
	int docdepartmentid=user.getUserDepartment() ;
	String needinputitems = "";
	String  docType=Util.null2String(request.getParameter("docType"));
	String mouldtext = "" ;
	int mouldType = 0;
	String editMouldIdAndSecCategoryId="";
	int mouldSecCategoryId=0;
	int countNum = 0;
	List countMouldList = new ArrayList();
	String fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //来源于流程建文挡 
	String  docsubject=Util.null2String(request.getParameter("docsubject"));
	int requestid=Util.getIntValue(request.getParameter("requestid"),0);
	int workflowid=-1;
	if (fromFlowDoc.equals("1")) {
		docsubject=Util.null2String((String)session.getAttribute(""+user.getUID()+"_"+requestid+"docsubject"));
		docCode=Util.null2String((String)session.getAttribute(""+user.getUID()+"_"+requestid+"docCode"));
		if(docsubject.equals("")){
			docsubject=Util.null2String((String)session.getAttribute("docsubject"+user.getUID()));
		}
		if(docCode.equals("")){
			docCode=Util.null2String((String)session.getAttribute("docCode"+user.getUID()));
		}
	}
	if(docmodule.equals("")&&fromFlowDoc.equals("1")){
		editMouldIdAndSecCategoryId=RequestDoc.getEditMouldIdAndSecCategoryIdForDocAddExt(requestid);
		int indexId=editMouldIdAndSecCategoryId.indexOf("_");
		docmodule=""+Util.getIntValue(editMouldIdAndSecCategoryId.substring(0,indexId),0);
		mouldSecCategoryId=Util.getIntValue(editMouldIdAndSecCategoryId.substring(indexId+1),0);

		RecordSet.executeSql("SELECT docMouldFile.ID,docMouldFile.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMouldFile WHERE docMouldFile.id in (select mouldid from workflow_mould where visible=1 and mouldType = 3 and seccategory="+mouldSecCategoryId+" and workflowid = "+workflowid+") and docSecCategoryMould.mouldID = docMouldFile.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + mouldSecCategoryId);//获取模板的数量
		while(RecordSet.next()){
	        String docMouldID = RecordSet.getString("ID");
			String mode_name = RecordSet.getString("mouldName");
	        countMouldList.add(docMouldID);
		}
	    countNum = countMouldList.size();
	}

	List selectMouldList = new ArrayList();
	int selectMouldType = 0;
	int selectDefaultMould = 0;

	if(docType.equals(".doc")||docType.equals(".xls")||docType.equals(".wps")||docType.equals(".et")){
		int  tempMouldType=4;//4：WORD编辑模版
		if(docType.equals(".xls")){
			tempMouldType=6;//6：EXCEL编辑模版
		}else if(docType.equals(".wps")){
			tempMouldType=8;//8：WPS文字编辑模版
		}else if(docType.equals(".et")){
			tempMouldType=10;//8：WPS表格编辑模版
		}

		RecordSet.executeSql("select * from DocSecCategoryMould where secCategoryId = "+secid+" and mouldType="+tempMouldType+" order by id ");
		while(RecordSet.next()){
			String moduleid=RecordSet.getString("mouldId");
			String mType = DocMouldComInfo.getDocMouldType(moduleid);
			String modulebind = RecordSet.getString("mouldBind");
			int isDefault = Util.getIntValue(RecordSet.getString("isDefault"),0);

			if(isTemporaryDoc){
			    
				if(Util.getIntValue(modulebind,1)==3){
				    selectMouldType = 3;
				    selectDefaultMould = Util.getIntValue(moduleid);
				    selectMouldList.add(moduleid);
			    } else if(Util.getIntValue(modulebind,1)==1&&isDefault==1){
			        if(selectMouldType==0){
				        selectMouldType = 1;
					    selectDefaultMould = Util.getIntValue(moduleid);
			        }
					selectMouldList.add(moduleid);
			    } else {
			        if(Util.getIntValue(modulebind,1)!=2)
						selectMouldList.add(moduleid);
			    }

			} else {
			
				if(Util.getIntValue(modulebind,1)==2){
				    selectMouldType = 2;
				    selectDefaultMould = Util.getIntValue(moduleid);
				    selectMouldList.add(moduleid);
			    } else if(Util.getIntValue(modulebind,1)==1&&isDefault==1){
				    if(selectMouldType==0){
				        selectMouldType = 1;
					    selectDefaultMould = Util.getIntValue(moduleid);
				    }
					selectMouldList.add(moduleid);
			    } else {
			        if(Util.getIntValue(modulebind,1)!=3)
						selectMouldList.add(moduleid);
			    }
			}
		}
		
	        %>
			
	<%
	       
	}
	
	boolean canShowDocMain = false;
	
	int j = 1;
	SecCategoryDocPropertiesComInfo.addDefaultDocProperties(secid);
	SecCategoryDocPropertiesComInfo.setTofirstRow();
	%>
	<wea:layout type="4col" attributes="{'formTableId':'docPropTable'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
	<%
	while(SecCategoryDocPropertiesComInfo.next()){
		int docPropId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getId());
		int docPropSecCategoryId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getSecCategoryId());

		if(docPropSecCategoryId!=secid) continue;

		int docPropViewindex = Util.getIntValue(SecCategoryDocPropertiesComInfo.getViewindex());
		int docPropType = Util.getIntValue(SecCategoryDocPropertiesComInfo.getType());
		int docPropLabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId());
		int docPropVisible = Util.getIntValue(SecCategoryDocPropertiesComInfo.getVisible());
		int docPropColumnWidth = Util.getIntValue(SecCategoryDocPropertiesComInfo.getColumnWidth());
		int docPropMustInput = Util.getIntValue(SecCategoryDocPropertiesComInfo.getMustInput());
		int docPropIsCustom = Util.getIntValue(SecCategoryDocPropertiesComInfo.getIsCustom());
		String docPropScope = SecCategoryDocPropertiesComInfo.getScope();
		int docPropScopeId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getScopeId());
		int docPropFieldid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getFieldId());


		
		String tagName = "";
		String tagValue = "";
		
		if(docPropLabelid==MultiAclManager.MAINCATEGORYLABEL||docPropLabelid==MultiAclManager.SUBCATEGORYLABEL)continue;
				
		if(docPropVisible==0) continue;
		
		if(docPropType==1||docPropType==11||docPropType==13||
				docPropType==14||docPropType==15||
				docPropType==16||docPropType==17||
				docPropType==18||docPropType==20)
			continue;


		String docPropCustomName = SecCategoryDocPropertiesComInfo.getCustomName(user.getLanguage());
		String label = "";
		if(!docPropCustomName.equals("")) {
			label = docPropCustomName;
		} else if(docPropIsCustom!=1) {
			label = SystemEnv.getHtmlLabelName(docPropLabelid,languageId);
			if(docPropType==10) label+="("+SystemEnv.getHtmlLabelName(93,user.getLanguage())+")";
		}

		
		if(docPropColumnWidth>1){
			if(j==2){
			}
			j=3;
		}
	%>
			<% if(j==1||j==3){ %>
			<% } %>
			
			<wea:item><%=label%></wea:item>
			<%String attr = "{'colspan':'"+(j==3?"full":"1")+"'}";%>
			<wea:item attributes='<%=attr %>'>
			<%
				switch(docPropType){
					case 1:{//1 文档标题
					
						break;
					}
					case 2:{//2 文档编号
			%>
						<%=docCode%>
			<%
						break;
					}
					case 3:{//3 发布
						if(!publishable.trim().equals("") && !publishable.trim().equals("0")){
						    canShowDocMain = true;
						%>
		                <select  name="docpublishtype" onchange="if(this.value==2) onshowdocmain(1) ; else onshowdocmain(0)">
							<option value=1  ><font color=red><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></font></option>
							<option value=2 selected><font color=red><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></font></option>
							<option value=3  ><font color=red><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></font></option>
						</select>
						<script type="text/javascript">
							function onshowdocmain(vartmp){
												if(vartmp==1){
													//$GetEle("docmainspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
													showEle("_showDocMain");
												} else {
													hideEle("_showDocMain");
												}
							}
						</script>						
						<%
						} else {
						%>
						<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>
						<% } %>
			<%		
						break;
					}
					case 4:{//4 文档版本
			%>
			<%
						break;
					}
					case 5:{//5 文档状态
			%>
						<%=SystemEnv.getHtmlLabelName(220,languageId)%>
			<%
						break;
					}
					case 6:{//6 主目录
			%>
						  <%if (isPersonalDoc){
				              String catalogIds=DocUserSelfUtil.getParentids(""+userCategory);
				              String catalogNames=DocUserSelfUtil.getCatalogNames(catalogIds) ;
						      out.println("［"+SystemEnv.getHtmlLabelName(17600,languageId)+"］　"+catalogNames+DocUserSelfUtil.getCatalogName(""+userCategory));
						   } else {
						  %>
						      <%=SecCategoryComInfo.getTopName(""+secid)%>
						  <%}%>
			<%
						break;
					}
					case 7:{//7 分目录
			%>
						  <%if (isPersonalDoc){
						      String catalogIds=DocUserSelfUtil.getParentids(""+userCategory);
						      String catalogNames=DocUserSelfUtil.getCatalogNames(catalogIds) ;
						      out.println("［"+SystemEnv.getHtmlLabelName(17600,languageId)+"］　"+catalogNames+DocUserSelfUtil.getCatalogName(""+userCategory));
						   } else {
						  %>
						     <%=SecCategoryComInfo.getParentName(""
												+ secid)%>
						  <%}%>
			<%
						break;
					}
					case 8:{//8 子目录
			%>
						  <%if (isPersonalDoc){
						      String catalogIds=DocUserSelfUtil.getParentids(""+userCategory);
						      String catalogNames=DocUserSelfUtil.getCatalogNames(catalogIds) ;
						      out.println("［"+SystemEnv.getHtmlLabelName(17600,languageId)+"］　"+catalogNames+DocUserSelfUtil.getCatalogName(""+userCategory));
						   } else {
							   String docsecname =SecCategoryComInfo.getAllParentName("" + secid,true);
				                            docsecname=Util.replace(docsecname,"&amp;quot;","\"",0);
                                                            docsecname=Util.replace(docsecname,"&quot;","\"",0);
                                                            docsecname=Util.replace(docsecname,"&lt;","<",0);
                                                            docsecname=Util.replace(docsecname,"&gt;",">",0);
		                                            docsecname=Util.replace(docsecname,"&apos;","'",0);
		                                            String browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp?operationcode="+MultiAclManager.OPERATION_CREATEDOC;
		            								String completeUrl = "/data.jsp?type=categoryBrowser&onlySec=true&&operationcode="+MultiAclManager.OPERATION_CREATEDOC;
						  %>
						      <span>
						    <brow:browser viewType="0" name="seccategory_brow" idKey="id" nameKey="path" browserValue='<%=secid==-1?"":""+secid%>' 
							browserUrl='<%=browserUrl %>' _callback="afterSelectCategory" needHidden="false"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
							completeUrl='<%=completeUrl %>' linkUrl="#"
							browserSpanValue='<%= docsecname %>'></brow:browser>
					</span>	
						  <%}%>
			<%
						break;
					}
					case 9:{//9 部门
			%>
						<span id=docdepartmentidspan>
							<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=docdepartmentid%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+docdepartmentid),user.getLanguage())%></a>
						</span>
			<%
						break;
					}
					case 10:{//10 模版
			%>
					<script language=javascript>
						function onChangeDocModule(thisvalue1){
							var value= "<%=SystemEnv.getHtmlLabelName(81566,user.getLanguage())%>";
							if(document.getElementById("tempDocModule").value == thisvalue1)return;
							top.Dialog.confirm(value,function(){
								window.onbeforeunload=null;
								loadEditMould("<%=secid%>",{mouldid:thisvalue1,clearContent:true});
								//使用 id为tempDocModule的隐藏表单域来 存储   选择框(上次)的值。
								document.getElementById("tempDocModule").value = document.getElementById("docmodule").value;
							}, function(){
								//如果用户点击"取消"，则将选择框的值重置之前的值。
								document.getElementById("docmodule").value = document.getElementById("tempDocModule").value;
							});
						}
					</script>
					
					<input type="hidden" id="tempDocModule" name="tempDocModule" value="" >
					<select class=InputStyle name=docmodule <%if(selectMouldType==2||selectMouldType==3){%>disabled<%}%> style="width:200" onchange="onChangeDocModule(this.value)">
						<%if(selectMouldType<2){%>
						<option value="-1"></option>
						<%}%>
						<%
						int tmpcount = 0;
						int tmpMouldId = 0;
						
						for(int i=0;i<selectMouldList.size();i++){
						  	String moduleid = (String) selectMouldList.get(i);
							String modulename = DocMouldComInfo.getDocMouldname(moduleid);
						    String mType = DocMouldComInfo.getDocMouldType(moduleid);
						    String mouldTypeName = "";
						    if((mType.equals("")||mType.equals("0")||mType.equals("1"))&&docType.equals(".htm")){
						        mouldTypeName="HTML";
						        tmpMouldId = Util.getIntValue(moduleid);
						    }else if(mType.equals("2")&&docType.equals(".doc")){
						        mouldTypeName="WORD";
						        tmpMouldId = Util.getIntValue(moduleid);
						    }else if(mType.equals("3")&&docType.equals(".xls")){
						        mouldTypeName="EXCEL";
						        tmpMouldId = Util.getIntValue(moduleid);
						    }else if(mType.equals("4")&&docType.equals(".wps")){
						        mouldTypeName=SystemEnv.getHtmlLabelName(22359,languageId);
						        tmpMouldId = Util.getIntValue(moduleid);
						    }else if(mType.equals("5")&&docType.equals(".et")){
						        mouldTypeName=SystemEnv.getHtmlLabelName(24545,languageId);
						        tmpMouldId = Util.getIntValue(moduleid);
						    } else {
						        continue;
						    }
							String isselect ="" ;
							if(docmodule.equals(moduleid)) isselect = " selected";
						%>
							<option value="<%=moduleid%>" <%=isselect%> ><%=modulename%>(<%=mouldTypeName%>)</option>
						<%
							tmpcount++;
						}
						if(tmpcount==1&&Util.getIntValue(docmodule,0)==0&&tmpMouldId!=0){
						%>
						<%-- 
						<script language=javascript>
					        window.onbeforeunload=null;
							location='DocAddExt.jsp?mainid=<%=mainid%>&fromFlowDoc=<%=fromFlowDoc%>&requestid=<%=requestid%>&secid=<%=secid%>&subid=<%=subid%>&topage=<%=tmptopage%>&showsubmit=<%=showsubmit%>&prjid=<%=prjid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&from=<%=from%>&docsubject='+weaver.docsubject.value+'&invalidationdate=<%=invalidationdate%>&docmodule=<%=tmpMouldId%>';
						</script>
						--%>
						<%
						}
						%>
					</select>
			<%
						break;
					}
					case 11:{//11 语言
			%>
			<%
						break;
					}
					case 12:{//12 关键字
			%>
						<input class=InputStyle maxlength=250 size=26 name=keyword value=""
						<% if(docPropMustInput==1){ %>
						onChange="checkinput('keyword','keywordspan')" >
						<SPAN id="keywordspan">
						<%if("".equals("")){%>
						<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
						<%}%>
						</SPAN>
						<%
						needinputitems += ",keyword";
						%>
						<%} else {%>
						>
						<%}%>
			<%
						break;
					}
					case 13:{//13 创建
			%>
			<%
						break;
					}
					case 14:{//14 修改
			%>
			<%
						break;
					}
					case 15:{//15 批准
			%>
			<%
						break;
					}
					case 16:{//16 失效
			%>
			<%
						break;
					}
					case 17:{//17 归档
			%>
			<%
						break;
					}
					case 18:{//18 作废
			%>
			<%
						break;
					}
					case 19:{//19 主文档
			%>
						<span>
						   <brow:browser viewType="0" name="maindoc" browserValue="-1" 
							browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" needHidden="false"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
							completeUrl="/data.jsp?type=37" linkUrl="#"
							browserSpanValue='<%=SystemEnv.getHtmlLabelName(524, user
											.getLanguage())+SystemEnv.getHtmlLabelName(58, user
											.getLanguage())%>'></brow:browser>
					</span>		
			<%
						break;
					}
					case 20:{//20 被引用列表
			%>
			<%
						break;
					}
					case 21:{//21 文档所有者
						if(user.getType()==0){
							%>
								<span>
								   <brow:browser viewType="0" name="ownerid" browserValue='<%=""+ownerid%>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
									_callback="afterOnShowResource"
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
									completeUrl="/data.jsp" linkUrl="#"
									browserSpanValue='<%= Util.toScreen(owneridname, user
														.getLanguage())	 %>'></brow:browser>
							</span>	
						<%
						} else {
						%>
							<%=CustomerInfoComInfo.getCustomerInfoname(""+ownerid)%>
						<%
						}
						break;
					}
					case 22:{//22 失效时间
						%>
						<script language=javascript>
						function onChangeDocInvalidationDate(){
							
						}
						</script>
						<BUTTON type="button" class=Calendar onclick="getInvalidationDate2(<%=user.getLanguage()%>,onChangeDocInvalidationDate);
						<% if(docPropMustInput==1){ %>
						checkinput('invalidationdate','invalidationdatespan1');"></BUTTON> 
						<SPAN id=invalidationdatespan><%=invalidationdate%></SPAN> 
						<input type="hidden" name="invalidationdate" value="<%=invalidationdate%>">
						<SPAN id="invalidationdatespan1">
						<%if(invalidationdate.equals("")){%>
						<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
						<%}%>
						</SPAN>
						<%
						needinputitems += ",invalidationdate";
						%>
						<%} else {%>
						"></BUTTON> 
						<SPAN id=invalidationdatespan><%=invalidationdate%></SPAN> 
						<input type="hidden" name="invalidationdate" value="<%=invalidationdate%>">
						<SPAN id="invalidationdatespan1"></SPAN>
						<%}%>
						<%
						break;
					}
					case 24:{//24虚拟目录	
						String dummyIds="";
						String dummyNames="";
						String strSql="select defaultDummyCata from DocSecCategory where id="+secid;
						rsDummyDoc.executeSql(strSql);
						
						if(rsDummyDoc.next()){							
							dummyIds=Util.null2String(rsDummyDoc.getString("defaultDummyCata"));
							dummyNames=DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(dummyIds);
						}						
						%>
						<span>
						  <brow:browser viewType="0" name="dummycata" browserValue='<%=""+dummyIds%>' 
						   browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="
						   hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='<%=docPropMustInput == 1?"2":"1" %>'
						   completeUrl="/data.jsp" linkUrl="/docs/docdummy/DocDummyList.jsp?dummyId="
						   browserSpanValue='<%= dummyNames	 %>'></brow:browser>
				   </span>
						<% 
						if(docPropMustInput==1){
							
							needinputitems += ",dummycata";
						}%>
						<%
						break;
					}
					case 25:{//25 可打印份数
			%>
						<input class=InputStyle size=4 maxlength=4 name=canPrintedNum value="0" onKeyPress="ItemCount_KeyPress()"
						<% if(docPropMustInput==1){ %>
						    onChange="checknumber('canPrintedNum');checkinput('canPrintedNum','canPrintedNumSpan')" 
						<%
						needinputitems += ",canPrintedNum";
						%>
						<%}else{%>
						    onChange="checknumber('canPrintedNum')" 
						<%}%>
						>						
						<span id="canPrintedNumSpan">
						</span>
			<%
						break;
					}
					case 0:{//0 自定义字段
			%>
			
			
					<%-- 自定义字段 start --%>
					<%
					    docid = Util.null2String(request.getParameter("docid"));
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
										<input datatype="text" type=text class=InputStyle name="customfield<%=cfm.getId()%>" size=50 onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
										<span id="customfield<%=cfm.getId()%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
					<%
									} else {
					%>
										<input datatype="text" type=text class=InputStyle name="customfield<%=cfm.getId()%>" value="" size=50>
					<%
									}
								} else if(cfm.getType()==2) {
									if(cfm.isMand()){
					%>
										<input datatype="int" type=text class=InputStyle name="customfield<%=cfm.getId()%>" size=10
										onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
										<span id="customfield<%=cfm.getId()%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
					<%
									} else {
					%>
										<input  datatype="int" type=text class=InputStyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
					<%
									}
								} else if(cfm.getType()==3) {
									if(cfm.isMand()){
					%>
										<input datatype="float" type=text class=InputStyle name="customfield<%=cfm.getId()%>" size=10
										onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
										<span id="customfield<%=cfm.getId()%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
					<%
									} else {
					%>
										<input datatype="float" type=text class=InputStyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
					<%
		                			}
		            			}
							} else if(cfm.getHtmlType().equals("2")) {
								if(cfm.isMand()) {
					%>
									<textarea class=InputStyle name="customfield<%=cfm.getId()%>" onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')"
									rows="4" cols="40" style="width:80%" class=InputStyle></textarea>
									<span id="customfield<%=cfm.getId()%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
					<%
								} else {
					%>
									<textarea class=InputStyle name="customfield<%=cfm.getId()%>" rows="4" cols="40" style="width:80%"></textarea>
					<%
								}
							} else if(cfm.getHtmlType().equals("3")) {
					
					            String fieldtype = String.valueOf(cfm.getType());
							    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
								String isSingle="false";
								String paraName="selectids";
								if("135".equals(fieldtype)){
									paraName="projectids";
								}
							    String _url = url;		
								try{
									_url = url.substring(url.indexOf("?url")+4);
								}catch(Exception e){}
								if(_url.indexOf("?")!=-1){
									url += "&"+paraName+"=";
								}else{
									url += "?"+paraName+"=";
								}
							    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
							    String showname = "";                                   // 新建时候默认值显示的名称
							    String showid = "";                                     // 新建时候默认值
								String fielddbtype=Util.null2String(cfm.getFieldDbType());
								if(fielddbtype.equals("int") || fielddbtype.equals("integer")){
										isSingle="true";
									}
							    if(fieldtype.equals("152") || fieldtype.equals("16")){
									linkurl = "/workflow/request/ViewRequest.jsp?requestid=";
								}
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
					                        showname = "<a target='_blank' href='"+linkurl+showid+"'>"+RecordSet.getString(1)+"</a>&nbsp";
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
									_url = url;		
									try{
										_url = url.substring(url.indexOf("?url")+4);
									}catch(Exception e){}
									if(_url.indexOf("?")!=-1){
										url += "&type="+fielddbtype;
									}else{
										url += "?type="+fielddbtype;
									}
								}
					%>
								<span>
									<% 
									if(!fieldtype.equals("2") && !fieldtype.equals("19")){
						 if(fieldtype.equals("263")||fieldtype.equals("258")||fieldtype.equals("58")){
								  String  areaType="country";
								 if(fieldtype.equals("58")){
								    areaType="city";
								 }else if(fieldtype.equals("263")){
								   areaType="citytwo";								 
								 }
									%>

									
                             <div  areaType="<%=areaType%>" style="width:319px" areaName="<%="customfield"+cfm.getId()%>" areaValue="<%=showid%>" 

areaSpanValue="<%= Util.toScreen(showname, user.getLanguage())	 %>"  areaMustInput="<%= (cfm.isMand()?"2":"1")%>"  areaCallback="callBack"  class="_areaselect" id="<%="customfield"+cfm.getId()%>"></div>

						<%
							 
							 }else{
							%>

								   <span>
										  <brow:browser viewType="0" temptitle='<%=label %>' name='<%="customfield"+cfm.getId()%>' browserValue='<%=showid%>' 
										   browserUrl='<%=url %>'
										   hasInput="true" isSingle='<%=isSingle%>' hasBrowser = "true" isMustInput='<%= (cfm.isMand()?"2":"1")%>'
										   completeUrl='<%="/data.jsp?type="+fieldtype%>' linkUrl='<%=linkurl %>'
										   browserSpanValue='<%= Util.toScreen(showname, user.getLanguage())	 %>'></brow:browser>
								   </span>	
									<%}}else if(fieldtype.equals("2")){ %>
										<button title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>" class=Calendar type="button" onClick ="onShowDocDate('<%=cfm.getId()%>','<%=fieldtype%>','<%=cfm.isMand()%>')"></button>
										<input  temptitle="<%=label %>" type=hidden name="customfield<%=cfm.getId()%>" value="<%=showid%>">
										<span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%>
										</span>
									<%}else{ %>
										<button title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>" class=Clock type="button" onClick ="onShowDocsTime(customfield<%=cfm.getId()%>span,customfield<%=cfm.getId()%>,'<%=cfm.isMand()%>')"></button>
										<input  temptitle="<%=label %>" type=hidden name="customfield<%=cfm.getId()%>" value="<%=showid%>">
										<span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname, user.getLanguage())%>
					<%
						if (cfm.isMand() && showname.equals("")) {
					%> 
						<img src="/images/BacoError_wev8.gif" align=absmiddle> 
					<%
						 }
					}%> 
							  </span>
					<%
							} else if(cfm.getHtmlType().equals("4")) {
					%>
								<input type=checkbox value=1 name="customfield<%=cfm.getId()%>" >
					<%
							} else if(cfm.getHtmlType().equals("5")) {
								cfm.getSelectItem(cfm.getId());
					%>
								<select name="customfield<%=cfm.getId()%>" viewtype="<%if(cfm.isMand()){out.print("1");}else{out.print("0");}%>" class="InputStyle" onChange="checkinput2('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span',this.getAttribute('viewtype'))">
									<option value=""></option>
					<%
								while(cfm.nextSelect()){
					%>
									<option value="<%=cfm.getSelectValue()%>"><%=cfm.getSelectName()%></option>
					<%
								}
					%>
								</select>
								<span id="customfield<%=cfm.getId()%>span">
					<%
								if(cfm.isMand()) {
					%>
									<img src="/images/BacoError_wev8.gif" align=absmiddle>
					<%
								}
					%>
								</span>
					<%
							}
						}
					%>
					<%-- 自定义字段 end--%>
			
			<%
					}
				}
			%>
			</wea:item>
			<% if(j==2||j==3){ %>
			<% } %>
	<%
		j++;
		if(j>2) j=1;
	}
	%>
	<% if(j==2){ %>
	<% } %>	
	
	<%-- 摘要 start  --%>
	<% 
	if(canShowDocMain){
	%>
		<wea:item attributes="{'samePair':'_showDocMain'}"><%=SystemEnv.getHtmlLabelName(341, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'_showDocMain','colspan':'full'}">
			<wea:required id="docmainspan" required="true">
				<input class=InputStyle size=70 name="docmain" onChange="checkinput('docmain','docmainspan')">
			</wea:required>
		</wea:item>
	<%
	}
	%>
	<%-- 摘要 end --%>

	<%-- 类型 start --%>

	<%if(!hasasset.equals("0")||!hasitems.equals("0")||!hashrmres.equals("0")||!hascrm.equals("0")||!hasproject.equals("0")||!hasfinance.equals("0")){%>
	<%}%>
	<%
	int needtr=0;
	String sepStr="<TR><TD class=Line colSpan=4></TD></TR>";
	
	if(!hashrmres.trim().equals("")&&!hashrmres.trim().equals("0")){
		String curlabel = SystemEnv.getHtmlLabelName(179,languageId);
		if(!hrmreslabel.trim().equals("")) curlabel = hrmreslabel;
		%>
		<% if(needtr==0){ }%>
			<wea:item ><%=curlabel%></wea:item>
			<wea:item>
			<span>
               <brow:browser viewType="0" name="hrmresid" browserValue='<%=hrmid%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%= !user.getLogintype().equals("2")?(hashrmres.equals("2")?"2":"1"):"0"%>'
                completeUrl="/data.jsp" linkUrl="javaScript:openhrm($id$)"
                browserSpanValue='<%= ResourceComInfo.getResourcename(hrmid)	 %>'></brow:browser>
        </span>
			<%if(hrmid.equals("")){%>
				<%if(hashrmres.equals("2")){
					needinputitems += ",hrmresid";
					%>
				<%}%>
			<%}else{%>
			<%}%>
			</wea:item>
			<%
			if(needtr==1){
				//out.print("</tr>"+sepStr);
				needtr=0;
			} else needtr++;
	}else{
	%>
		<input type=hidden name=hrmresid value=<%=hrmid%>>
	<%
	}
	%>

	<%
	if(!hasasset.trim().equals("")&&!hasasset.trim().equals("0")){
		String curlabel = SystemEnv.getHtmlLabelName(535,languageId);
		if(!assetlabel.trim().equals("")) curlabel = assetlabel;
		%>
		<% if(needtr==0){ }%>
			<wea:item ><%=curlabel%></wea:item>
			<wea:item>
			<span>
               <brow:browser viewType="0" name="assetid" browserValue="" 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp"
                hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='<%= !user.getLogintype().equals("2")?(hasasset.equals("2")?"2":"1"):"0"%>'
                completeUrl="/data.jsp" linkUrl="#"
                browserSpanValue=""></brow:browser>
			</span>		
				<%if(hasasset.equals("2")){
					needinputitems += ",assetid";
				%>
				<%}%>
			</wea:item>
			
		<%
		if(needtr==1){
			//out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}
	
	
	if(!hascrm.trim().equals("")&&!hascrm.trim().equals("0")){
		String curlabel = SystemEnv.getHtmlLabelName(147,languageId);
		if(!crmlabel.trim().equals("")) curlabel = crmlabel;
		%>
		<% if(needtr==0){ }%>
			<wea:item><%=curlabel%></wea:item>
			<wea:item>
			<span>
               <brow:browser viewType="0" name="crmid" browserValue='<%=crmid %>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%= (hascrm.equals("2")?"2":"1")%>'
                completeUrl="/data.jsp?type=7" linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=#id#&id=#id#"
                browserSpanValue='<%=CustomerInfoComInfo.getCustomerInfoname(crmid)%>'></brow:browser>
				</span>		
			<%if(crmid.equals("")){%>
				<%if(hascrm.equals("2")){
					needinputitems += ",crmid";
				%>
				<%}%>
			<%}else{%>
			<%}%>
			</wea:item>
		<%
		if(needtr==1){
			//out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}else{
	%>
		<input type=hidden name=crmid value=<%=crmid%>>
	<%}%>
	
	
	<%
	if(!hasitems.trim().equals("")&&!hasitems.trim().equals("0")){
		String curlabel = SystemEnv.getHtmlLabelName(145,languageId);
		if(!itemlabel.trim().equals("")) curlabel = itemlabel;
		%>
		<% if(needtr==0){}%>
			<wea:item><%=curlabel%></wea:item>
			<wea:item>
			<span>
				  <brow:browser viewType="0" name="itemid" browserValue="" 
				   browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp"
				   hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='<%= (hasitems.equals("2")?"2":"1")%>'
				   completeUrl="/data.jsp?type=7" linkUrl="/lgc/asset/LgcAsset.jsp?paraid=#id#&id=#id#"
				   browserSpanValue=""></brow:browser>
		   </span>	
			<%if(hasitems.equals("2")){
				needinputitems += ",itemid";
				%>
			<%}%>
			</wea:item>
		<%
		if(needtr==1){
				//out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}
	%>

	<%
	if(!hasproject.trim().equals("")&&!hasproject.trim().equals("0")){
		String curlabel = SystemEnv.getHtmlLabelName(101,languageId);
		if(!projectlabel.trim().equals("")) curlabel = projectlabel;
		%>
		<% if(needtr==0){}%>
			<wea:item><%=curlabel%></wea:item>
			<wea:item>
			<span>
               <brow:browser viewType="0" name="projectid" browserValue='<%=prjid%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
                hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='<%= (hasproject.equals("2")?"2":"1")%>'
                completeUrl="/data.jsp" linkUrl="/proj/data/ViewProject.jsp?ProjID=#id#&id=#id#"
                browserSpanValue='<%=ProjectInfoComInfo.getProjectInfoname(prjid)%>'></brow:browser>
				</span>		
			<%if(prjid.equals("")){%>
				<%if(hasproject.equals("2")){
					needinputitems += ",projectid";
					%>
				<%}%>
			<%}else{%>
			<%}%>
			</span>
			</wea:item>
			
		<%
		if(needtr==1){
			//out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}else{
	%>
		<input type=hidden name=projectid value=<%=prjid%>>
	<%}%>

	<%
	if(!hasfinance.trim().equals("")&&!hasfinance.trim().equals("0")){
		String curlabel = SystemEnv.getHtmlLabelName(189,languageId);
		if(!financelabel.trim().equals(""))	curlabel = financelabel;
		%>
		<% if(needtr==0){ }%>
			<wea:item><%=curlabel%></wea:item>
			<wea:item>
			<button type="button" class=Browser></button>
			<input type=hidden name=financeid>
			</wea:item>
	<%
		if(needtr==1){
			//out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}
	%>
	<%
	if(needtr==1){
	%>
	<%}%>
	<%-- 类型 end --%>
	</wea:group>
</wea:layout>
<input type="hidden" name="__needinputitems" id="__needinputitems" value="<%=needinputitems %>"/>

<script>
jQuery(document).ready(function(){

areromancedivs();

});
</script>