
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*,weaver.docs.category.security.*" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page"/>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<jsp:useBean id="privateSecCategoryComInfo" class="weaver.rdeploy.doc.PrivateSecCategoryComInfo" scope="page" />
<script type="text/javascript" src="/js/messagejs/highslide/highslide-full_wev8.js"></script>
<script type="text/javascript" src="/js/messagejs/simplehrm_wev8.js"></script>
<script type="text/javascript" src="/js/messagejs/messagejs_wev8.js"></script>
<script language="javascript" src="/qrcode/js/jquery.qrcode-0.7.0_wev8.js"></script>
<%
int userCategory = Util.getIntValue(request.getParameter("userCategory"));
int docid = Util.getIntValue(request.getParameter("docid"));
boolean isPersonalDoc = Util.null2String(request.getParameter("isPersonalDoc")).equals("true")?true:false;
boolean canPublish = Util.null2String(request.getParameter("canPublish")).equals("true")?true:false;
String selectedpubmould = Util.null2String(request.getParameter("selectedpubmould"));

DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();
int docvestin = DocManager.getDocVestIn();
//文档信息
int docType = DocManager.getDocType();
int maincategory=DocManager.getMaincategory();
int subcategory=DocManager.getSubcategory();
int seccategory=DocManager.getSeccategory();
int doclangurage=DocManager.getDoclangurage();
String docapprovable=DocManager.getDocapprovable();
String docreplyable=SecCategoryComInfo.getSecReplyAbles(""+seccategory);
String isreply=DocManager.getIsreply();
int replydocid=DocManager.getReplydocid();
String docsubject=DocManager.getDocsubject();
String doccontent=DocManager.getDoccontent();
String docpublishtype=DocManager.getDocpublishtype();
int itemid=DocManager.getItemid();
int itemmaincategoryid=DocManager.getItemmaincategoryid();
int hrmresid=DocManager.getHrmresid();
int crmid=DocManager.getCrmid();
int projectid=DocManager.getProjectid();
int financeid=DocManager.getFinanceid();
int doccreaterid=DocManager.getDoccreaterid();
int docdepartmentid=DocManager.getDocdepartmentid();
String doccreatedate=DocManager.getDoccreatedate();
String doccreatetime=DocManager.getDoccreatetime();
int doclastmoduserid=DocManager.getDoclastmoduserid();
String doclastmoddate=DocManager.getDoclastmoddate();
String doclastmodtime=DocManager.getDoclastmodtime();
int docapproveuserid=DocManager.getDocapproveuserid();
String docapprovedate=DocManager.getDocapprovedate();
String docapprovetime=DocManager.getDocapprovetime();
int docarchiveuserid=DocManager.getDocarchiveuserid();
String docarchivedate=DocManager.getDocarchivedate();
String docarchivetime=DocManager.getDocarchivetime();
String docstatus=DocManager.getDocstatus();
String parentids=DocManager.getParentids();
int assetid=DocManager.getAssetid();
int ownerid=DocManager.getOwnerid();
String keyword=DocManager.getKeyword();
int accessorycount=DocManager.getAccessorycount();
int replaydoccount=DocManager.getReplaydoccount();
String usertype=DocManager.getUsertype();
String docno = DocManager.getDocno();

int docvaliduserid = DocManager.getDocValidUserId();
String docvaliddate = DocManager.getDocValidDate();
String docvalidtime = DocManager.getDocValidTime();
int docpubuserid = DocManager.getDocPubUserId();
String docpubdate = DocManager.getDocPubDate();
String docpubtime = DocManager.getDocPubTime();
int docreopenuserid = DocManager.getDocReOpenUserId();
String docreopendate = DocManager.getDocReOpenDate();
String docreopentime = DocManager.getDocReOpenTime();
int docinvaluserid = DocManager.getDocInvalUserId();
String docinvaldate = DocManager.getDocInvalDate();
String docinvaltime = DocManager.getDocInvalTime();
int doccanceluserid = DocManager.getDocCancelUserId();
String doccanceldate = DocManager.getDocCancelDate();
String doccanceltime = DocManager.getDocCancelTime();

String docCode = DocManager.getDocCode();
int docedition = DocManager.getDocEdition();
int doceditionid = DocManager.getDocEditionId();
int ishistory = DocManager.getIsHistory();
int selectedpubmouldid = DocManager.getSelectedPubMouldId();

int maindoc = DocManager.getMainDoc();
int docreadoptercanprint = DocManager.getReadOpterCanPrint();

boolean isTemporaryDoc = false;
String invalidationdate = DocManager.getInvalidationDate();
if(invalidationdate!=null&&!"".equals(invalidationdate))
    isTemporaryDoc = true;

//是否回复提醒
String canRemind=DocManager.getCanRemind();

String checkOutStatus=DocManager.getCheckOutStatus();
int checkOutUserId=DocManager.getCheckOutUserId();
String checkOutUserType=DocManager.getCheckOutUserType();


String docCreaterType = DocManager.getDocCreaterType();//文档创建者类型（1:内部用户  2：外部用户）
String docLastModUserType = DocManager.getDocLastModUserType();//文档最后修改者类型（1:内部用户  2：外部用户）
String docApproveUserType = DocManager.getDocApproveUserType();//文档审批者类型（1:内部用户  2：外部用户）
String docInvalUserType = DocManager.getDocInvalUserType();//失效操作人类型（1:内部用户  2：外部用户）
String docArchiveUserType = DocManager.getDocArchiveUserType();//文档归档者类型（1:内部用户  2：外部用户）
String docCancelUserType = DocManager.getDocCancelUserType();//作废操作人类型（1:内部用户  2：外部用户）
String ownerType = DocManager.getOwnerType();//文档拥有者类型（1:内部用户  2：外部用户）
if(docpublishtype.equals("2")){
	int tmppos = doccontent.indexOf("!@#$%^&*");
	if(tmppos!=-1) doccontent = doccontent.substring(tmppos+8,doccontent.length());
}
int canPrintedNum=DocManager.getCanPrintedNum();//可打印份数

String docstatusname = DocComInfo.getStatusView(docid,user);

String tmppublishtype="";
if(docpublishtype.equals("2")) tmppublishtype=SystemEnv.getHtmlLabelName(227,user.getLanguage());
else if(docpublishtype.equals("3")) tmppublishtype=SystemEnv.getHtmlLabelName(229,user.getLanguage());
else tmppublishtype=SystemEnv.getHtmlLabelName(58,user.getLanguage());

boolean blnRealViewLog=false;

//子目录信息
RecordSet.executeProc("Doc_SecCategory_SelectByID",seccategory+"");
RecordSet.next();
String categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
String subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));
//String docmouldid=Util.null2String(""+RecordSet.getString("docmouldid"));
String publishable=Util.null2String(""+RecordSet.getString("publishable"));
String replyable=Util.null2String(""+RecordSet.getString("replyable"));
String shareable=Util.null2String(""+RecordSet.getString("shareable"));
String cusertype=Util.null2String(""+RecordSet.getString("cusertype"));
cusertype = cusertype.trim();
String cuserseclevel=Util.null2String(""+RecordSet.getString("cuserseclevel"));
if(cuserseclevel.equals("255")) cuserseclevel="0";
String cdepartmentid1=Util.null2String(""+RecordSet.getString("cdepartmentid1"));
String cdepseclevel1=Util.null2String(""+RecordSet.getString("cdepseclevel1"));
if(cdepseclevel1.equals("255")) cdepseclevel1="0";
String cdepartmentid2=Util.null2String(""+RecordSet.getString("cdepartmentid2"));
String cdepseclevel2=Util.null2String(""+RecordSet.getString("cdepseclevel2"));
if(cdepseclevel2.equals("255")) cdepseclevel2="0";
String croleid1=Util.null2String(""+RecordSet.getString("croleid1"));
String crolelevel1=Util.null2String(""+RecordSet.getString("crolelevel1"));
String croleid2=Util.null2String(""+RecordSet.getString("croleid2"));
String crolelevel2=Util.null2String(""+RecordSet.getString("crolelevel2"));
String croleid3=Util.null2String(""+RecordSet.getString("croleid3"));
String crolelevel3=Util.null2String(""+RecordSet.getString("crolelevel3"));
String approvewfid=RecordSet.getString("approveworkflowid");
String needapprovecheck="";
if(approvewfid.equals(""))  approvewfid="0";
if(approvewfid.equals("0")) needapprovecheck="0";
else needapprovecheck="1";

String hasaccessory =Util.toScreen(RecordSet.getString("hasaccessory"),user.getLanguage());
int accessorynum = Util.getIntValue(RecordSet.getString("accessorynum"),user.getLanguage());
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
String approvercanedit=Util.toScreen(RecordSet.getString("approvercanedit"),user.getLanguage());
String isSetShare=Util.null2String(""+RecordSet.getString("isSetShare"));
int relationable=Util.getIntValue(""+RecordSet.getString("relationable"),0);
int isOpenAttachment=Util.getIntValue(""+RecordSet.getString("isOpenAttachment"),0);
String readCount = " ";
String topage= URLEncoder.encode("/docs/docs/DocDsp.jsp?id="+docid);

boolean canDownload = (Util.getIntValue(Util.null2String(RecordSet.getString("nodownload")),0)==0)?true:false;
int categoryreadoptercanprint = Util.getIntValue(RecordSet.getString("readoptercanprint"),0);

String isOpenApproveWf=Util.null2String(RecordSet.getString("isOpenApproveWf"));

String readerCanViewHistoryEdition=Util.null2String(RecordSet.getString("readerCanViewHistoryEdition"));
int appointedWorkflowId = Util.getIntValue(RecordSet.getString("appointedWorkflowId"),0);

int isAutoExtendInfo = Util.getIntValue(RecordSet.getString("isAutoExtendInfo"),0);

boolean isEditionOpen = SecCategoryComInfo.isEditionOpen(seccategory);




//取得模版设置
String mouldtext = "";
int docmouldid = 0;

List selectMouldList = new ArrayList();
int selectMouldType = 0;
int selectDefaultMould = 0;

if(SecCategoryDocPropertiesComInfo.getDocProperties(""+seccategory,"10")&&SecCategoryDocPropertiesComInfo.getVisible().equals("1")){

	if(docType==1){
		RecordSet.executeSql("select t1.* from DocSecCategoryMould t1 right join DocMould t2 on t1.mouldId = t2.id where t1.secCategoryId = "+seccategory+" and t1.mouldType=1 order by t1.id");
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
			        selectMouldType = 1;
				    selectDefaultMould = Util.getIntValue(moduleid);
					selectMouldList.add(moduleid);
			    } else {
			        if(Util.getIntValue(modulebind,1)!=3)
						selectMouldList.add(moduleid);
			    }
			}
		}
		
		if(canPublish && docstatus.equals("6")){
		    if(Util.getIntValue(Util.null2String(selectedpubmould),0)<=0){
				if(selectMouldType>0){
				    docmouldid = selectDefaultMould;
				}
		    } else {
		        docmouldid = Util.getIntValue(selectedpubmould);
		    }
		} else {
		    if(Util.getIntValue(Util.null2String(selectedpubmould),0)<=0){
		    	if(selectedpubmouldid<=0){
		    	    if(selectMouldType>0)
		    	        docmouldid = selectDefaultMould;
		    	} else {
		    	    docmouldid = selectedpubmouldid;
		    	}
		    } else {
		        docmouldid = Util.getIntValue(selectedpubmould);
		    }
		}
	}
}

if(docmouldid<=0)
    docmouldid = MouldManager.getDefaultMouldId();


String owneridname=ResourceComInfo.getResourcename(ownerid+"");

String strSql="select catelogid from DocDummyDetail where docid="+docid;
rsDummyDoc.executeSql(strSql);
String dummyIds="";
while(rsDummyDoc.next()){
	dummyIds+=Util.null2String(rsDummyDoc.getString(1))+",";
}
%>
	<wea:layout type="4col" attributes="{'formTableId':'docPropTable'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
	  
	<%-- 文档属性 start --%>
	<%
	int j = 1;
	SecCategoryDocPropertiesComInfo.addDefaultDocProperties(seccategory);
	SecCategoryDocPropertiesComInfo.setTofirstRow();
	while(SecCategoryDocPropertiesComInfo.next()){
		int docPropId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getId());
		int docPropSecCategoryId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getSecCategoryId());

		if(docPropSecCategoryId!=seccategory) continue;

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


		if(docPropLabelid==MultiAclManager.MAINCATEGORYLABEL||docPropLabelid==MultiAclManager.SUBCATEGORYLABEL)continue;
		String tagName = "";
		String tagValue = "";

		if(docPropVisible==0) continue;
		if(docPropLabelid==MultiAclManager.MAINCATEGORYLABEL||docPropLabelid==MultiAclManager.SUBCATEGORYLABEL)continue;
		if(docPropType==1)
			continue;


		String docPropCustomName = SecCategoryDocPropertiesComInfo.getCustomName(user.getLanguage());
		String label = "";
		if(!docPropCustomName.equals("")) {
			label = docPropCustomName;
		} else if(docPropIsCustom!=1) {
			label = SystemEnv.getHtmlLabelName(docPropLabelid,user.getLanguage());
		}


		if(docPropColumnWidth>1){
			if(j==2){
	%>
			
	<%
			}
			j=3;
		}
	%>
			<% if(j==1||j==3){ %>
			
			<% } %>

			<wea:item><%=label%></wea:item>
			<%String attr = "{'colspan':'"+(j==3?"full":"1")+"'}";
			%>
			<wea:item attributes='<%=attr%>'>
			<%
				switch(docPropType){
					case 1:{//1 文档标题
			%>
						<%=docsubject%>
			<%		
						break;
					}
					case 2:{//2 文档编号
			%>
						<%=docCode%>
						<!-- <%=docno%> -->
						<!-- <%=docid%> -->
			<%
						break;
					}
					case 3:{//3 发布
						if(!publishable.trim().equals("")){
			%>
							<%=tmppublishtype%>
						<%}%>
			<%		
						break;
					}
					case 4:{//4 文档版本
			%>
						<%=DocComInfo.getEditionView(docid)%>
			<%
						break;
					}
					case 5:{//5 文档状态
			%>
						<%=docstatusname%>
			<%
						break;
					}
					case 6:{//6 主目录
			%>
						<%
							if(docvestin == 0)
							{
							    if (isPersonalDoc){
								      String catalogIds=DocUserSelfUtil.getParentids(""+userCategory);
								      String catalogNames=DocUserSelfUtil.getCatalogNames(catalogIds) ;
								      out.println("［"+SystemEnv.getHtmlLabelName(17600,user.getLanguage())+"］　"+catalogNames+DocUserSelfUtil.getCatalogName(""+userCategory));
								   } else {
								  %>
								      <%=MainCategoryComInfo.getMainCategoryname(""+maincategory)%>
								  <%}
							}
							else
							{
							    %>
							    <%= privateSecCategoryComInfo.getAllParentName(maincategory,"/",user.getUID()+"",user.getLanguage()+"") %>
							    <%
							}
						%>						  
			<%
						break;
					}
					case 7:{//7 分目录
			%>
						  <%
							if(docvestin == 0)
							{
							    if (isPersonalDoc){
								      String catalogIds=DocUserSelfUtil.getParentids(""+userCategory);
								      String catalogNames=DocUserSelfUtil.getCatalogNames(catalogIds) ;
								      out.println("［"+SystemEnv.getHtmlLabelName(17600,user.getLanguage())+"］　"+catalogNames+DocUserSelfUtil.getCatalogName(""+userCategory));
								   } else {
								  %>
								      <%=SubCategoryComInfo.getSubCategoryname(""+subcategory)%>
								  <%}
							}
							else
							{
							    %>
							    <%= privateSecCategoryComInfo.getAllParentName(maincategory,"/",user.getUID()+"",user.getLanguage()+"") %>
							    <%
							}
						%>	
					<%
						break;
					}
					case 8:{//8 子目录
			%>
						  
						  <%
							if(docvestin == 0)
							{
								  if (isPersonalDoc){
								      String catalogIds=DocUserSelfUtil.getParentids(""+userCategory);
								      String catalogNames=DocUserSelfUtil.getCatalogNames(catalogIds) ;
								      out.println("［"+SystemEnv.getHtmlLabelName(17600,user.getLanguage())+"］　"+catalogNames+DocUserSelfUtil.getCatalogName(""+userCategory));
								   } else {
									   String docsecname =SecCategoryComInfo.getAllParentName("" + seccategory,true);
						              	           docsecname=Util.replace(docsecname,"&amp;quot;","\"",0);
				                                           docsecname=Util.replace(docsecname,"&quot;","\"",0);
		                                                           docsecname=Util.replace(docsecname,"&lt;","<",0);
		                                                           docsecname=Util.replace(docsecname,"&gt;",">",0);
				                                           docsecname=Util.replace(docsecname,"&apos;","'",0);
								  %>
								      <%--<BUTTON class=Browser onClick="onSelectCategory()" name=selectCategory></BUTTON>--%>
								      <span id=path name=path><%=docsecname.equals("")?"<IMG src='/images/BacoError_wev8.gif' align=absMiddle>":docsecname%></span>
								  <%}
							}
							else
							{
							    %>
							    <%= privateSecCategoryComInfo.getAllParentName(maincategory,"/",user.getUID()+"",user.getLanguage()+"") %>
							    <%
							}
						%>	
			<%
						break;
					}
					case 9:{//9 部门
			%>
						<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=docdepartmentid%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+docdepartmentid),user.getLanguage())%></a>
			<%
						break;
					}
					case 10:{//10 模版
						%>
						<%
						if(canPublish && docstatus.equals("6")){
						%>
							<select class=InputStyle name=selectedpubmould <%if(selectMouldType==2||(isTemporaryDoc&&selectMouldType==3)){%>disabled<%}%> style="width:200" onchange="onChangeDocModule(this.value)">
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
								    if(mType.equals("")||mType.equals("0")||mType.equals("1")) {
								        mouldTypeName="HTML";
								        tmpMouldId = Util.getIntValue(moduleid);
								    } else if(mType.equals("2")) {
								        mouldTypeName="WORD";
								        continue;
								    } else if(mType.equals("3")){
								        mouldTypeName="EXCEL";
								        continue;
								    } else {
								        continue;
								    }
									String isselect ="" ;
									if(docmouldid==Util.getIntValue(moduleid)) isselect = " selected";
									%>
							  		<option value="<%=moduleid%>" <%=isselect%> ><%=modulename%>(<%=mouldTypeName%>)</option>
									<%
									tmpcount++;
								}
								%>
							</select>
							<script language=javascript>
							function onChangeDocModule(thisvalue1){
						        window.onbeforeunload=null;
								location='DocDsp.jsp?id=<%=docid%>&selectedpubmould='+thisvalue1;
							}
							</script>
						<% } else { %>
							<a href="/docs/mould/DocMouldDsp.jsp?id=<%=docmouldid%>"    target="_blank">
							<%=DocMouldComInfo.getDocMouldname(docmouldid+"")%>
							</a>
						<% } %>
			<%
						break;
					}
					case 11:{//11 语言
			%>
						<%=LanguageComInfo.getLanguagename(""+doclangurage)%>
			<%
						break;
					}
					case 12:{//12 关键字
			%>
						<a target="_blank" href="/docs/search/DocSearchTab.jsp?keyword=<%=keyword%>"><%=keyword%></a>
			<%
						break;
					}
					case 13:{//13 创建
			
						    if("2".equals(docCreaterType)){
							    if("1".equals(user.getLogintype())){
						%>
							    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=doccreaterid%>"  target='_new'>
							        <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doccreaterid),user.getLanguage())%>
							    </a>
						<%
							    }else{
						%>
							        <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doccreaterid),user.getLanguage())%>
						<% 
							    }
						    } else { 
							    if("1".equals(user.getLogintype())){
						%>
							    <a href="javaScript:openhrm(<%=doccreaterid%>);" onclick='pointerXY(event);'>
								    <%=Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),user.getLanguage())%>
							    </a>
						<%
							    }else{
						%>
							        <%=Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),user.getLanguage())%>
						<% 
							    }
						    }
						%>
							&nbsp;<%=doccreatedate%>&nbsp;<%=doccreatetime%>
						<%
						break;
					}
					case 14:{//14 修改
			
						    if("2".equals(docLastModUserType)){
							    if("1".equals(user.getLogintype())){
						%>
							    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=doclastmoduserid%>"  target='_new'>
							        <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doclastmoduserid),user.getLanguage())%>
							    </a>
						<%
							    }else{
						%>
							        <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doclastmoduserid),user.getLanguage())%>
						<% 
							    }
						    } else { 
							    if("1".equals(user.getLogintype())){
						%>
							    <a href="javaScript:openhrm(<%=doclastmoduserid%>);" onclick='pointerXY(event);'>
								    <%=Util.toScreen(ResourceComInfo.getResourcename(""+doclastmoduserid),user.getLanguage())%>
							    </a>
						<%
							    }else{
						%>
							        <%=Util.toScreen(ResourceComInfo.getResourcename(""+doclastmoduserid),user.getLanguage())%>
						<% 
							    }
						    }
						%>
							&nbsp;<%=doclastmoddate%>&nbsp;<%=doclastmodtime%>
						<%
						break;
					}
					case 15:{//15 批准
			
						if(docapproveuserid!=0){
							
						    if("2".equals(docApproveUserType)){
							    if("1".equals(user.getLogintype())){
						%>
							    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=docapproveuserid%>"  target='_new'>
							        <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+docapproveuserid),user.getLanguage())%>
							    </a>
						<%
							    }else{
						%>
							        <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+docapproveuserid),user.getLanguage())%>
						<% 
							    }
						    } else { 
							    if("1".equals(user.getLogintype())){
						%>
							    <a href="javaScript:openhrm(<%=docapproveuserid%>);" onclick='pointerXY(event);' >
								    <%=Util.toScreen(ResourceComInfo.getResourcename(""+docapproveuserid),user.getLanguage())%>
							    </a>
						<%
							    }else{
						%>
							        <%=Util.toScreen(ResourceComInfo.getResourcename(""+docapproveuserid),user.getLanguage())%>
						<% 
							    }
						    }
						%>
							&nbsp;<%=docapprovedate%>&nbsp;<%=docapprovetime%>
						<%
						}
						break;
					}
					case 16:{//16 失效
			
						if(docinvaluserid!=0){
							
						    if("2".equals(docInvalUserType)){
							    if("1".equals(user.getLogintype())){
						%>
							    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=docinvaluserid%>"  target='_new'>
							        <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+docinvaluserid),user.getLanguage())%>
							    </a>
						<%
							    }else{
						%>
							        <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+docinvaluserid),user.getLanguage())%>
						<% 
							    }
						    } else { 
							    if("1".equals(user.getLogintype())){
						%>
							    <a href="javaScript:openhrm(<%=docinvaluserid%>);" onclick='pointerXY(event);'>
								    <%=Util.toScreen(ResourceComInfo.getResourcename(""+docinvaluserid),user.getLanguage())%>
							    </a>
						<%
							    }else{
						%>
							        <%=Util.toScreen(ResourceComInfo.getResourcename(""+docinvaluserid),user.getLanguage())%>
						<% 
							    }
						    }
						%>
							&nbsp;<%=docinvaldate%>&nbsp;<%=docinvaltime%>
						<%
						}
						break;
					}
					case 17:{//17 归档
			
						if(docarchiveuserid!=0){
							
						    if("2".equals(docArchiveUserType)){
							    if("1".equals(user.getLogintype())){
						%>
							    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=docarchiveuserid%>"  target='_new'>
							        <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+docarchiveuserid),user.getLanguage())%>
							    </a>
						<%
							    }else{
						%>
							        <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+docarchiveuserid),user.getLanguage())%>
						<% 
							    }
						    } else { 
							    if("1".equals(user.getLogintype())){
						%>
							    <a href="javaScript:openhrm(<%=docarchiveuserid%>);" onclick='pointerXY(event);'>
								    <%=Util.toScreen(ResourceComInfo.getResourcename(""+docarchiveuserid),user.getLanguage())%>
							    </a>
						<%
							    }else{
						%>
							        <%=Util.toScreen(ResourceComInfo.getResourcename(""+docarchiveuserid),user.getLanguage())%>
						<% 
							    }
						    }
						%>
							&nbsp;<%=docarchivedate%>&nbsp;<%=docarchivetime%>
						<%
						}
						break;
					}
					case 18:{//18 作废
						if(doccanceluserid!=0){
							
						    if("2".equals(docCancelUserType)){
							    if("1".equals(user.getLogintype())){
						%>
							    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=doccanceluserid%>"  target='_new'>
							        <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doccanceluserid),user.getLanguage())%>
							    </a>
						<%
							    }else{
						%>
							        <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doccanceluserid),user.getLanguage())%>
						<% 
							    }
						    } else { 
							    if("1".equals(user.getLogintype())){
						%>
							    <a href="javaScript:openhrm(<%=doccanceluserid%>);" onclick='pointerXY(event);'>
								    <%=Util.toScreen(ResourceComInfo.getResourcename(""+doccanceluserid),user.getLanguage())%>
							    </a>
						<%
							    }else{
						%>
							        <%=Util.toScreen(ResourceComInfo.getResourcename(""+doccanceluserid),user.getLanguage())%>
						<% 
							    }
						    }
						%>
							&nbsp;<%=doccanceldate%>&nbsp;<%=doccanceltime%>
						<%
						}
						break;
					}

					case 19:{//19 主文档
			%>
						<% if(maindoc==docid){ %>
						<%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>
						<% } else { %>
						<a target="_blank" href="/docs/docs/DocDsp.jsp?id=<%=maindoc%>"><%=DocComInfo.getDocname(maindoc+"")%></a>
						<% } %>
			<%
						break;
					}
					case 20:{//20 被引用列表
			%>
						<%
						int newDocId = -1;
						String docSubject = "";
						if(doceditionid>-1){
							RecordSet.executeSql(" select id,docSubject from DocDetail where doceditionid = " + doceditionid + " and doceditionid > 0  and (isHistory<>'1' or isHistory is null or isHistory='') order by docedition desc ");
				            RecordSet.next();
				            newDocId = Util.getIntValue(RecordSet.getString("id"));
				            docSubject = Util.null2String(RecordSet.getString("docSubject"));
						} else {
							newDocId = docid;
							docSubject = docsubject;
						}
			            if(newDocId>0){
						%>
							<img src="/images/replyDoc/openfld_wev8.gif"/> <a href="/docs/docs/DocDsp.jsp?id=<%=newDocId%>"  target="_blank"><%=docSubject%></a>&nbsp;
							<%
					        int childDocId=-1;
							String childDocSubject = "";
							RecordSet.executeSql(" select id,docSubject from DocDetail where id <> " + newDocId + " and mainDoc = " + newDocId + " and (isHistory<>'1' or isHistory is null or isHistory='') order by id asc ");
							while(RecordSet.next()){
								childDocId = Util.getIntValue(RecordSet.getString("id"));;
								childDocSubject = Util.null2String(RecordSet.getString("docSubject"));
								if(childDocId>0){
				    			%>
					    		<img src="/images/replyDoc/news_general_wev8.gif"> <a href="/docs/docs/DocDsp.jsp?id=<%=childDocId%>"  target="_blank" ><%=childDocSubject%></a>&nbsp;
					    		<% } %>
					    	<% } %>
					    <% } %>
			<%
						break;
					}
					case 21:{//21 文档所有者
						if("2".equals(ownerType)){
							if("1".equals(user.getLogintype())){
						%>
							<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=ownerid%>"  target='_new'>
							    <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+ownerid),user.getLanguage())%>
							</a>
						<%
							}else{
						%>
							    <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+ownerid),user.getLanguage())%>
						<% 
							}
						} else { 
							if("1".equals(user.getLogintype())){
						%>
							<a href="javaScript:openhrm(<%=ownerid%>);" onclick='pointerXY(event);'>
								<%=Util.toScreen(ResourceComInfo.getResourcename(""+ownerid),user.getLanguage())%>
							</a>
						<%
							}else{
						%>
							    <%=Util.toScreen(ResourceComInfo.getResourcename(""+ownerid),user.getLanguage())%>
						<% 
							}
						}
						break;
					}
					case 22:{//22 失效时间
						%>
						<%if(!"".equals(invalidationdate)){%>
						<%=invalidationdate%>
						<%}%>
						<%
						break;
					}
					case 24:{//24 虚拟目录
						if(!"".equals(dummyIds)) {
							dummyIds=dummyIds.substring(0,dummyIds.length()-1);
							out.println(DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(dummyIds));
						}
						break;
					}
					case 25:{//可打印份数
						%>
						<%=canPrintedNum%>
						<%
						break;
					}
					case 0:{//0 自定义字段
			%>
						<!--begin 自定义字段-->
						<%
						CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",seccategory);
					    cfm.getCustomFields(docPropFieldid);
						cfm.getCustomData(docid);
					    if(cfm.next()){
					        String fieldvalue = cfm.getData(cfm.getFieldName(""+cfm.getId()));
					        if(fieldvalue.startsWith(",")){
					        	fieldvalue = fieldvalue.substring(1);
					        }
					        fieldvalue=Util.StringReplace(fieldvalue,"\n","<br>");
					        fieldvalue=Util.StringReplace(fieldvalue,"\r","");
						%>
						<script >
							try{
								insertToCustomer('<%=cfm.getId()%>', '<%=fieldvalue%>');
							}catch(e){
								if(window.console)console.log(e+"-->DocDspBaseInfo.jsp-->insertToCustomer");
							}
						</script>
						<%
							if(cfm.getHtmlType().equals("1")||cfm.getHtmlType().equals("2")){
							%>
								<%=fieldvalue%>
							<%
							}else if(cfm.getHtmlType().equals("3")){
								String fieldtype = String.valueOf(cfm.getType());
								String url=BrowserComInfo.getBrowserurl(fieldtype); // 浏览按钮弹出页面的url
								String linkurl=BrowserComInfo.getLinkurl(fieldtype);// 浏览值点击的时候链接的url
								String showname = "";                               // 新建时候默认值显示的名称
								String showid = "";                                 // 新建时候默认值
								String fielddbtype=Util.null2String(cfm.getFieldDbType());
								if(fieldtype.equals("152") || fieldtype.equals("16")){
									linkurl = "/workflow/request/ViewRequest.jsp?requestid=";
								}
								if(fieldtype.equals("2") ||fieldtype.equals("19")){
									showname=fieldvalue; // 日期时间
								}else if(fieldtype.equals("141")) {
									showname=ResourceConditionManager.getFormShowName(fieldvalue,user.getLanguage());
								}else if(fieldtype.equals("4")) {
									showname="<a href='#' onclick=\"openFullWindowHaveBar('"+linkurl+fieldvalue+"');\">"+DepartmentComInfo.getDepartmentname(fieldvalue)+"</a>";
								}else if(fieldtype.equals("161")){//自定义单选
								    showname = "";                                   // 新建时候默认值显示的名称
								    String showdesc="";
								    showid =fieldvalue;                                     // 新建时候默认值
								    try{
										Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
										BrowserBean bb=browser.searchById(showid);
										String desc=Util.null2String(bb.getDescription());
										String name=Util.null2String(bb.getName());
										showname="<a title='"+desc+"'>"+name+"</a>&nbsp";
								    }catch(Exception e){
								    }
								}else if(fieldtype.equals("162")){//自定义多选
								    showname = "";                                   // 新建时候默认值显示的名称
								    showid =fieldvalue;                                     // 新建时候默认值
								    try{
										Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
										List l=Util.TokenizerString(showid,",");
										for(int jindex=0;jindex<l.size();jindex++){
											String curid=(String)l.get(jindex);
											BrowserBean bb=browser.searchById(curid);
											String name=Util.null2String(bb.getName());
											String desc=Util.null2String(bb.getDescription());
											showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
										}
								    }catch(Exception e){
								    }
								} else if(!fieldvalue.equals("")) {
									String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
									String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
									String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
									String sql = "";
									
									HashMap temRes = new HashMap();
									
									if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("142")||fieldtype.equals("152")||fieldtype.equals("168")||fieldtype.equals("171")||fieldtype.equals("166")||fieldtype.equals("135")||fieldtype.equals("278")||fieldtype.equals("194")) {    // 多人力资源,多客户,多会议，多文档，多流程
										sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
									} else if(fieldtype.equals("143")){
										//树状文档字段
										String tempFieldValue="0";
										int beginIndex=0;
										int endIndex=0;
										if(fieldvalue.startsWith(",")){
											beginIndex=1;
										}else{
											beginIndex=0;
										}
										if(fieldvalue.endsWith(",")){
											endIndex=fieldvalue.length()-1;
										}else{
											endIndex=fieldvalue.length();
										}
										if(fieldvalue.equals(",")){
											tempFieldValue="0";			
										}else{
											tempFieldValue=fieldvalue.substring(beginIndex,endIndex);			
										}
										sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+tempFieldValue+")";

									} else {
										sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
									}

									RecordSet.executeSql(sql);
									while(RecordSet.next()){
										showid = Util.null2String(RecordSet.getString(1));
										String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage());
										if(!linkurl.equals("")) {
											//showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
											temRes.put(String.valueOf(showid),"<a href='#' onclick=\"openFullWindowHaveBar('"+linkurl+showid+"');\">"+tempshowname+"</a> ");
										} else {
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

									if(fieldtype.equals("263")||fieldtype.equals("258")||fieldtype.equals("58")){
										 showname=Util.HTMLtoTxt(showname);
									
									}

								}
								%>
								<span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%></span>
							<%
							} else if(cfm.getHtmlType().equals("4")) {
							%>
								<input type=checkbox value=1 name="customfield<%=cfm.getId()%>checkbox" <%=fieldvalue.equals("1")?"checked":""%> disabled >
							<%
							} else if(cfm.getHtmlType().equals("5")) {
								cfm.getSelectItem(cfm.getId());
								while(cfm.nextSelect()){
									if(cfm.getSelectValue().equals(fieldvalue)){
									%>
										<%=cfm.getSelectName()%>
										<%
										break;
									}
								}
							}
						}
						%>
						<!--end   自定义字段-->			
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
	<%-- 文档属性 end --%>


	<%-- 类型 start --%>
	<%
	String sepStr="<TR style='height:1px'><TD class=Line colSpan=4></TD></TR>";
	int needtr=0;
	if(!hashrmres.trim().equals("0")&&!hashrmres.trim().equals("")){
		String curlabel = SystemEnv.getHtmlLabelName(179,user.getLanguage());
		if(!hrmreslabel.trim().equals("")) curlabel = hrmreslabel;
		%>
		<% if(needtr==0){}%>
		<wea:item><%=curlabel%></wea:item>
		<wea:item>
		<%if(!user.getLogintype().equals("2")){%>
			<%if(hrmresid!=0){%>
				<A href="javaScript:openhrm(<%=hrmresid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(""+hrmresid),user.getLanguage())%></A>
			<%}%>
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
	if(!hasasset.trim().equals("0")&&!hasasset.trim().equals("")){
		String curlabel = SystemEnv.getHtmlLabelName(535,user.getLanguage());
		if(!assetlabel.trim().equals("")) curlabel = assetlabel;
		%>
		<% if(needtr==0){ }%>
		<wea:item><%=curlabel%></wea:item>
		<wea:item>
		<%if(!user.getLogintype().equals("2")){%>
			<%if(assetid!=0){%>
				<a href="/cpt/capital/CptCapital.jsp?id=<%=assetid%>" target="_blank"><%=Util.toScreen(CapitalComInfo.getCapitalname(assetid+""),user.getLanguage())%></a>
			<%}%>
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
	if(!hascrm.trim().equals("0")&&!hascrm.trim().equals("")){
		String curlabel = SystemEnv.getHtmlLabelName(147,user.getLanguage());
		if(!crmlabel.trim().equals("")) curlabel = crmlabel;
		%>
		<% if(needtr==0){ }%>
		<wea:item><%=curlabel%></wea:item>
		<wea:item>
		<%if(crmid!=0){%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=crmid%>" target="_blank"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+crmid),user.getLanguage())%></a>
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
	if(!hasitems.trim().equals("0")&&!hasitems.trim().equals("")){
		String curlabel = SystemEnv.getHtmlLabelName(145,user.getLanguage());
		if(!itemlabel.trim().equals("")) curlabel = itemlabel;
		%>
		<% if(needtr==0){}%>
		<wea:item><%=curlabel%></wea:item>
		<wea:item>
		<%if(itemid!=0){%>
			<A href='/lgc/asset/LgcAsset.jsp?paraid=<%=itemid%>' target="_blank"><%=AssetComInfo.getAssetName(""+itemid)%></a>
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
	if(!hasproject.trim().equals("0")&&!hasproject.trim().equals("")){
		String curlabel = SystemEnv.getHtmlLabelName(101,user.getLanguage());
		if(!projectlabel.trim().equals("")) curlabel = projectlabel;
		%>
		<% if(needtr==0){}%>
		<wea:item><%=curlabel%></wea:item>
		<wea:item>
		<%if(projectid!=0){%>
			<A href="/proj/data/ViewProject.jsp?ProjID=<%=projectid%>" target="_blank"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(""+projectid),user.getLanguage())%></a>
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
	if(!hasfinance.trim().equals("0")&&!hasfinance.trim().equals("")){
		String curlabel = SystemEnv.getHtmlLabelName(189,user.getLanguage());
		if(!financelabel.trim().equals("")) curlabel = financelabel;
		%>
		<% if(needtr==0){ }%>
		<wea:item><%=curlabel%></wea:item>
		<wea:item>
		<%if(financeid!=0) {%><%=financeid%><%}%>
		</wea:item>
		<%
		if(needtr==1){
			//out.print("</tr>"+sepStr+"<tr>");
			needtr=0;
		} else needtr++;
	}
	%>
	<%-- 类型 end --%>

</wea:group>
</wea:layout>