
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser,weaver.docs.category.security.*" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<SCRIPT language="javascript" src="/hrm/area/browser/areabrowser_wev8.js"></script>
<LINK href="/hrm/area/browser/areabrowser.css" type=text/css rel=STYLESHEET>
<wea:layout type="4col" attributes="{'formTableId':'docPropTable'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'colspan':'full'}"><%=titlename%></wea:item>
	<%
	boolean canShowDocMain = false;

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

		if(docPropType==1 || docPropType==11||docPropType==13||
				docPropType==14||docPropType==15||
				docPropType==16||docPropType==17||
				docPropType==18||docPropType==20
				)
			continue;
		String docPropCustomName = SecCategoryDocPropertiesComInfo.getCustomName(user.getLanguage());
		String label = "";
		if(!docPropCustomName.equals("")) {
			label = docPropCustomName;
		} else if(docPropIsCustom!=1) {
			label = SystemEnv.getHtmlLabelName(docPropLabelid,user.getLanguage());
			if(docPropType==10) label+="("+SystemEnv.getHtmlLabelName(89,user.getLanguage())+")";
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

			<wea:item><%=label%></wea:item>>
			<%String attr = "{'colspan':'"+(j==3?"full":"1")+"'}";
			%>
			<wea:item attributes='<%=attr%>'>
			<%
				switch(docPropType){
					case 1:{//1 文档标题
			%>
						
			<%		
						break;
					}
					case 2:{//2 文档编号
			%>
						<%=doccode%>
			<%
						break;
					}
					case 3:{//3 发布
						//int tmppos = doccontent.indexOf("!@#$%^&*");
						//if(tmppos!=-1){
						//	docmain = doccontent.substring(0,tmppos);
						//	doccontent = doccontent.substring(tmppos+8,doccontent.length());
						//}
						
						if(!publishable.trim().equals("") && !publishable.trim().equals("0")){
							String ischeck1="";
							String ischeck2="";
							String ischeck3="";
							if(docpublishtype.equals("1")) ischeck1=" selected ";
							if(docpublishtype.equals("2")) {
								ischeck2=" selected ";
							}
							if(docpublishtype.equals("3")) ischeck3=" selected ";
							
							canShowDocMain = true;
			%>
						<select  name="docpublishtype" onchange="if(this.value==2) onshowdocmain(1) ; else onshowdocmain(0)">
							<option value=1 <%=ischeck1%>><font color=red><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></font></option>
							<option value=2 <%=ischeck2%>><font color=red><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></font></option>
							<option value=3 <%=ischeck3%>><font color=red><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></font></option>
						</select>
						<script type="text/javascript">
							function onshowdocmain(vartmp){
												if(vartmp==1){
													//$GetEle("docmainspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
													showEle("otrtmp");
												} else {
													//$GetEle("docmainspan").innerHTML = "";
													hideEle("otrtmp");
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
						  <%if (isPersonalDoc){
						      String catalogIds=DocUserSelfUtil.getParentids(""+userCategory);
						      String catalogNames=DocUserSelfUtil.getCatalogNames(catalogIds) ;
						      out.println("［"+SystemEnv.getHtmlLabelName(17600,user.getLanguage())+"］　"+catalogNames+DocUserSelfUtil.getCatalogName(""+userCategory));
						   } else {
						  %>
						      <%=MainCategoryComInfo.getMainCategoryname(""+maincategory)%>
						  <%}%>
			<%
						break;
					}
					case 7:{//7 分目录
			%>
						  <%if (isPersonalDoc){
						      String catalogIds=DocUserSelfUtil.getParentids(""+userCategory);
						      String catalogNames=DocUserSelfUtil.getCatalogNames(catalogIds) ;
						      out.println("［"+SystemEnv.getHtmlLabelName(17600,user.getLanguage())+"］　"+catalogNames+DocUserSelfUtil.getCatalogName(""+userCategory));
						   } else {
						  %>
						      <%=SubCategoryComInfo.getSubCategoryname(""+subcategory)%>
						  <%}%>
			<%
						break;
					}
					case 8:{//8 子目录
			%>
						  <%if (isPersonalDoc){
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
						if(!SecCategoryComInfo.needPubOperation(seccategory)){
						    int tmpdocmouldid = 0;
						    List selectMouldList = new ArrayList();
						    int selectMouldType = 0;
						    int selectDefaultMould = 0;
							if(docType==1){
								RecordSet.executeSql("select * from DocSecCategoryMould where secCategoryId = "+seccategory+" and mouldType=1 order by id ");
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
							    if(selectMouldType>0)
								    tmpdocmouldid = selectDefaultMould;
								%>
								<select class=InputStyle name=selectedpubmouldid <%if(selectMouldType==2||selectMouldType==3){%>disabled<%}%> style="width:200">
								<%if(selectMouldType<2){%>
								<option value="-1"></option>
								<%}%>
								<%
								for(int i=0;i<selectMouldList.size();i++){
								  	String moduleid = (String) selectMouldList.get(i);
									String modulename = DocMouldComInfo.getDocMouldname(moduleid);
								    String mType = DocMouldComInfo.getDocMouldType(moduleid);
								    String mouldTypeName = "";
								    if(mType.equals("")||mType.equals("0")||mType.equals("1")) {
								        mouldTypeName="HTML";
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
									if(selectedpubmouldid==Util.getIntValue(moduleid)) isselect = " selected";
									%>
							  		<option value="<%=moduleid%>" <%=isselect%> ><%=modulename%>(<%=mouldTypeName%>)</option>
									<%
								}
								%>
								</select>
								<%
							}
						} else {
						    %>
							<a href="/docs/mould/DocMouldDsp.jsp?id=<%=selectedpubmouldid%>">
							<%=DocMouldComInfo.getDocMouldname(selectedpubmouldid+"")%>
							</a>
						<%
						}
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
						<input class=InputStyle maxlength=250 size=26 name=keyword value="<%=keyword%>"
						<% if(docPropMustInput==1){ %>
						onChange="checkinput('keyword','keywordspan')" >
						<span id="keywordspan">
						<%if(keyword.equals("")){%>
						<img src="/images/BacoError_wev8.gif" align=absMiddle>
						<%}%>
						</span>
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
						<%if(usertype.equals("1")){%>
							<a href="javaScript:openhrm(<%=doccreaterid%>);" onclick='pointerXY(event);'>
							<%=Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),user.getLanguage())%>
							</a>
						<%}else{%>
							<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=doccreaterid%>">
							<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doccreaterid),user.getLanguage())%>
							</a>
						<%}%>
						&nbsp;<%=doccreatedate%>&nbsp;<%=doccreatetime%>
			<%
						break;
					}
					case 14:{//14 修改
			%>
						<%if(usertype.equals("1")){%>
							<a href="javaScript:openhrm(<%=doclastmoduserid%>);" onclick='pointerXY(event);'>
							<%=Util.toScreen(ResourceComInfo.getResourcename(""+doclastmoduserid),user.getLanguage())%>
							</a>
						<%}else{%>
							<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=doclastmoduserid%>">
							<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doclastmoduserid),user.getLanguage())%>
							</a>
						<%}%>
						&nbsp;<%=doclastmoddate%>&nbsp;<%=doclastmodtime%>
			<%
						break;
					}
					case 15:{//15 批准
			%>
						<%if(docapproveuserid!=0){%>
							<a<%if(user.getType()==0){%> href="javaScript:openhrm(<%=docapproveuserid%>);" onclick='pointerXY(event);'<%}%>><%=Util.toScreen(ResourceComInfo.getResourcename(""+docapproveuserid),user.getLanguage())%></a>
							&nbsp;<%=docapprovedate%>&nbsp;<%=docapprovetime%>
						<%}%>
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
						<%if(docarchiveuserid!=0){%>
							<a<%if(user.getType()==0){%> href="javaScript:openhrm(<%=docarchiveuserid%><%}%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(""+docarchiveuserid),user.getLanguage())%></a>
							&nbsp;<%=docarchivedate%>&nbsp;<%=docarchivetime%>
						<%}%>
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
						   <brow:browser viewType="0" name="maindoc" browserValue='<%=""+maindoc %>' 
							browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" needHidden="false"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
							completeUrl="/data.jsp?type=37" linkUrl="#"
							browserSpanValue='<%=maindoc==docid?(SystemEnv.getHtmlLabelName(524, user
											.getLanguage())+SystemEnv.getHtmlLabelName(58, user
											.getLanguage())):(DocComInfo.getDocname(maindoc+""))%>'></brow:browser>
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
							<a href="javaScript:openhrm(<%=ownerid%>);" onclick='pointerXY(event);'  >
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
						<button class=Calendar type="button" onClick="getInvalidationDate(<%=user.getLanguage()%>);
						<% if(docPropMustInput==1){ %>
						checkinput('invalidationdate','invalidationdatespan1');"></button> 
						<span id=invalidationdatespan><%=invalidationdate%></span> 
						<input type="hidden" id="invalidationdate" name="invalidationdate" value="<%=invalidationdate%>">
						<span id="invalidationdatespan1">
						<%if(invalidationdate.equals("")){%>
						<img src="/images/BacoError_wev8.gif" align=absMiddle>
						<%}%>
						</span>
						<%
						needinputitems += ",invalidationdate";
						%>
						<%} else {%>
						"></BUTTON> 
						<span id=invalidationdatespan><%=invalidationdate%></span> 
						<input type="hidden"  id="invalidationdate" name="invalidationdate" value="<%=invalidationdate%>">
						<span id="invalidationdatespan1"></span>
						<%}%>
						<%
						break;
					}
					case 24:{//24 虚拟目录
						String strSql="select catelogid from DocDummyDetail where docid="+docid;
						rsDummyDoc.executeSql(strSql);
						String dummyIds="";
						String dummyNames="";
						while(rsDummyDoc.next()){
							dummyIds+=Util.null2String(rsDummyDoc.getString(1))+",";
						}
						if(!"".equals(dummyIds)) {
							dummyIds=dummyIds.substring(0,dummyIds.length()-1);
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
						}
						break;
					}

					case 25:{//25 可打印份数
			%>
						<input class=InputStyle size=4 maxlength=4 name=canPrintedNum value="<%=canPrintedNum%>" onKeyPress="ItemCount_KeyPress()"
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
						CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",seccategory);
					    cfm.getCustomFields(docPropFieldid);
						cfm.getCustomData(docid);
					    if(cfm.next()){
							if(cfm.isMand()){
								needinputitems += ",customfield"+cfm.getId();
							}
							String fieldvalue = cfm.getData(cfm.getFieldName(""+cfm.getId()));
							 if(fieldvalue.startsWith(",")){
						        	fieldvalue = fieldvalue.substring(1);
						     }
						%>
							<%
							if(cfm.getHtmlType().equals("1")){
								if(cfm.getType()==1){
									if(cfm.isMand()){
							%>
										<input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=50 onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
										<span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
									<%
									}else{
									%>
										<input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" value="" size=50>
							<%
									}
								}else if(cfm.getType()==2){
									if(cfm.isMand()){
							%>
										<input datatype="int" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10
										onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
										<span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
									<%
									}else{
									%>
										<input  datatype="int" type=text  value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
								<%
									}
								}else if(cfm.getType()==3){
									if(cfm.isMand()){
								%>
										<input datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10
										onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
										<span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
									<%
									}else{
									%>
										<input datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
									<%
									}
								}
							}else if(cfm.getHtmlType().equals("2")){
								if(cfm.isMand()){
								%>
									<textarea class=Inputstyle name="customfield<%=cfm.getId()%>" onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')"
									rows="4" cols="40" style="width:80%" class=Inputstyle><%=fieldvalue%></textarea>
									<span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
								<%
								}else{
								%>
									<textarea class=Inputstyle name="customfield<%=cfm.getId()%>" rows="4" cols="40" style="width:80%"><%=fieldvalue%></textarea>
								<%
								}
							}else if(cfm.getHtmlType().equals("3")){
	
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
								String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
								String newdocid = Util.null2String(request.getParameter("docid"));
						
								if( fieldtype.equals("37") && !newdocid.equals("")) {
									if( ! fieldvalue.equals("") ) fieldvalue += "," ;
									fieldvalue += newdocid ;
								}
	
								if(fieldtype.equals("2") ||fieldtype.equals("19")){
									showname=fieldvalue; // 日期时间
								}else if(fieldtype.equals("141")){
									showname=ResourceConditionManager.getFormShowName(fieldvalue,user.getLanguage()); // 人力资源条件
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
										showid = Util.null2String(RecordSet.getString(1)) ;
										String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
										if(!linkurl.equals(""))
											//showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
											temRes.put(String.valueOf(showid),"<a target='_blank' href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
										else {
											//showname += tempshowname ;
											temRes.put(String.valueOf(showid),tempshowname);
										}
									}
									StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
									String temstkvalue = "";
									while(temstk.hasMoreTokens()){
										temstkvalue = temstk.nextToken();
	
										if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
											showname += "weaver^^weaver"+temRes.get(temstkvalue);
										}
									}
									if(showname!=null&&showname.startsWith("weaver^^weaver")){
										showname=showname.substring(14);
									}
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
								  showname=Util.HTMLtoTxt(showname);
									%>

									
                              <div  areaType="<%=areaType%>" style="width:319px" areaName="<%="customfield"+cfm.getId()%>" areaValue="<%=fieldvalue%>" 

areaSpanValue="<%= Util.toScreen(showname, user.getLanguage())	 %>"  areaMustInput="<%= (cfm.isMand()?"2":"1")%>"  areaCallback="callBack"  class="_areaselect" id="<%="customfield"+cfm.getId()%>"></div>



						<%
							 
							 }else{
							%>

								   <span>
										  <brow:browser viewType="0" temptitle='<%=label %>' name='<%="customfield"+cfm.getId()%>' browserValue='<%=fieldvalue%>' 
										   browserUrl='<%=url %>'
										   hasInput="true" isSingle='<%=isSingle%>' hasBrowser = "true" isMustInput='<%= (cfm.isMand()?"2":"1")%>'
										   completeUrl='<%="/data.jsp?type="+fieldtype%>' linkUrl='<%=linkurl %>'
										   browserSpanValue='<%= Util.toScreen(showname, user.getLanguage())	 %>'></brow:browser>
								   </span>	
									<%}}else if(fieldtype.equals("2")){ %>
										<button title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>" class=calendar type="button" onClick ="onShowDocDate('<%=cfm.getId()%>','<%=fieldtype%>','<%=cfm.isMand()%>')"></button>
										<input type=hidden name="customfield<%=cfm.getId()%>" value="<%=fieldvalue%>">
										<span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%>
										<%if(cfm.isMand() && fieldvalue.equals("")) {%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%>
										</span>
									<%}else{ %>
										<button title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>" class=Clock type="button" onClick ="onShowDocsTime(customfield<%=cfm.getId()%>span,customfield<%=cfm.getId()%>,'<%=cfm.isMand()%>')"></button>
										<input type=hidden name="customfield<%=cfm.getId()%>" value="<%=fieldvalue%>">
										<span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%>
										<%if(cfm.isMand() && fieldvalue.equals("")) {%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%>
										</span>
									<%} %>
							</span>	
							<%
							}else if(cfm.getHtmlType().equals("4")){
							%>
								<input type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> >
							<%
							}else if(cfm.getHtmlType().equals("5")){
								cfm.getSelectItem(cfm.getId());
								boolean checkempty_tmp = true;
								%>
								<select name="customfield<%=cfm.getId()%>" viewtype="<%if(cfm.isMand()){out.print("1");}else{out.print("0");}%>" class="InputStyle" onChange="checkinput2('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span',this.getAttribute('viewtype'))">
									<option value=""></option>
								<%
								while(cfm.nextSelect()){
									if(cfm.getSelectValue().equals(fieldvalue)){
										checkempty_tmp = false;
									}
								%>
									<option value="<%=cfm.getSelectValue()%>" <%=cfm.getSelectValue().equals(fieldvalue)?"selected":""%>><%=cfm.getSelectName()%></option>
								<%
								}
								%>
								</select>
								<span id="customfield<%=cfm.getId()%>span">
					<%
								if(cfm.isMand() && checkempty_tmp) {
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
		String attrs1 = "{'id':'otrtmp','samePair':'otrtmp','display':'"+(docpublishtype.equals("2")?"":"none")+"'}";
		String attrs2 = "{'samePair':'otrtmp','display':'"+(docpublishtype.equals("2")?"":"none")+"','colspan':'full'}";
	%>
	<wea:item attributes='<%=attrs1%>'><%=SystemEnv.getHtmlLabelName(341,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=attrs2%>'>
			<wea:required id="docmainspan" required="true" value='<%=docmain%>'>
				<input class=InputStyle size=70 id="docmain" name="docmain" onChange="checkinput('docmain','docmainspan')" value="<%=docmain%>">
			</wea:required>
		</wea:item>
	<%
	}
	%>
	<%-- 摘要 end --%>
	
	<%-- 类型 start --%>
	<%
	String sepStr="";
	int needtr=0;
	if(!hashrmres.trim().equals("0")&&!hashrmres.trim().equals("")){
		String curlabel = SystemEnv.getHtmlLabelName(179,user.getLanguage());
		if(!hrmreslabel.trim().equals("")) curlabel = hrmreslabel;
		%>
		<% if(needtr==0){ }%>
			<wea:item><%=curlabel%></wea:item>
			<wea:item>
			<span>
               <brow:browser viewType="0" name="hrmresid" browserValue='<%=""+hrmresid%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%= !user.getLogintype().equals("2")?(hashrmres.equals("2")?"2":"1"):"0"%>'
                completeUrl="/data.jsp" linkUrl="javaScript:openhrm($id$)"
                browserSpanValue='<%= ResourceComInfo.getResourcename(""+hrmresid)	 %>'></brow:browser>
        </span>		
			<%if(hashrmres.equals("2"))
				needinputitems += ",hrmresid";
			%>
		</wea:item>
		<%
		if(needtr==1){ 
			//out.print("</TR>"+sepStr);
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
			<wea:item ><%=curlabel%></wea:item>
			<wea:item>
			<span>
               <brow:browser viewType="0" name="assetid" browserValue='<%=""+assetid%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp"
                hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='<%= !user.getLogintype().equals("2")?(hasasset.equals("2")?"2":"1"):"0"%>'
                completeUrl="/data.jsp" linkUrl="/cpt/capital/CapitalBrowser.jsp"
                browserSpanValue='<%=Util.toScreen(CapitalComInfo.getCapitalname(""+assetid),user.getLanguage())%>'></brow:browser>
			</span>		
			<%if(hasasset.equals("2"))
				needinputitems += ",assetid";
			%>
		</wea:item>
		<%
		if(needtr==1){ 
			//out.print("</TR>"+sepStr);
			needtr=0;
		} else needtr++;
	}
	%>
	
	
	<%
	if(!hascrm.trim().equals("0")&&!hascrm.trim().equals("")){
		String curlabel = SystemEnv.getHtmlLabelName(147,user.getLanguage());
		if(!crmlabel.trim().equals("")) curlabel = crmlabel;
		%>
		<% if(needtr==0){}%>
			<wea:item><%=curlabel%></wea:item>
			<wea:item>
			<span>
               <brow:browser viewType="0" name="crmid" browserValue='<%=""+crmid %>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%= (hascrm.equals("2")?"2":"1")%>'
                completeUrl="/data.jsp?type=7" linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=#id#&id=#id#"
                browserSpanValue='<%=CustomerInfoComInfo.getCustomerInfoname(""+crmid)%>'></brow:browser>
				</span>		
			<%if(hascrm.equals("2"))
				needinputitems += ",crmid";
			%>
		</wea:item>
		<%
		if(needtr==1){
			//out.print("</TR>"+sepStr);
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
			<span>
				  <brow:browser viewType="0" name="itemid" browserValue='<%=""+itemid%>' 
				   browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp"
				   hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='<%= (hasitems.equals("2")?"2":"1")%>'
				   completeUrl="/data.jsp?type=7" linkUrl="/lgc/asset/LgcAsset.jsp?paraid=#id#&id=#id#"
				   browserSpanValue='<%=AssetComInfo.getAssetName(""+itemid)%>'></brow:browser>
		   </span>		
			<%if(hasitems.equals("2")){
				needinputitems += ",itemid";
			}
			%>
		</wea:item>
		<%
		if(needtr==1){
			//out.print("</TR>"+sepStr);
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
			<span>
               <brow:browser viewType="0" name="projectid" browserValue='<%=""+projectid%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
                hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='<%= (hasproject.equals("2")?"2":"1")%>'
                completeUrl="/data.jsp" linkUrl="/proj/data/ViewProject.jsp?ProjID=#id#&id=#id#"
                browserSpanValue='<%=ProjectInfoComInfo.getProjectInfoname(""+projectid)%>'></brow:browser>
				</span>		
			<%if(hasproject.equals("2"))
			needinputitems += ",projectid";
			%>
		</wea:item>
		<%
		if(needtr==1){
			//out.print("</TR>"+sepStr);
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
			<button class=Browser type="button"></button>
			<input type=hidden name=financeid value="<%=financeid%>">
		</wea:item>
	<%
		if(needtr==1){
			//out.print("</TR>"+sepStr);
			needtr=0;
		} else needtr++;
	}
	%>
	<%-- 类型 end --%>



	
	
	<%-- 编辑状态 start --%>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>
				<%-- 插入图片 start --%>

			<%
			int oldpicnum = 0;
			int pos = doccontent.indexOf("<img");
			int pos2 = 0;
			while(pos!=-1){
				pos2 = doccontent.indexOf("?fileid=",pos);
			    if(pos2 == -1) {
			        pos = doccontent.indexOf("<img",pos+1);
			        continue ;
			    }
			    pos = pos2;
				int endpos = doccontent.indexOf("\"",pos);
				String tmpid = doccontent.substring(pos+8,endpos);
				int startpos = doccontent.lastIndexOf("\"",pos);
				//String servername = request.getServerName();

				//String servername = javax.servlet.http.HttpUtils.getRequestURL(request).toString();
				//servername = servername.substring(0,servername.indexOf(request.getServletPath()));
				
				String servername = request.getHeader("host");
				
				String tmpcontent = doccontent.substring(0,startpos+1);
				//tmpcontent += "http://"+servername;
				
				tmpcontent += doccontent.substring(startpos+1);
				doccontent=tmpcontent;
				%>
				<input type=hidden name=olddocimages<%=oldpicnum%> value="<%=tmpid%>">
				<%
				pos = doccontent.indexOf("<img",endpos);
				oldpicnum += 1;
			}
			%>
			<input type=hidden name=olddocimagesnum value="<%=oldpicnum%>">

	<%-- 插入图片 end --%>
		</wea:item>
		<wea:item>

<%


    if(checkOutStatus!=null&&(checkOutStatus.equals("1")||checkOutStatus.equals("2"))){
	    out.print(checkOutUserName+"  "+checkOutDate+"  "+checkOutTime+" "+SystemEnv.getHtmlLabelName(19692,user.getLanguage()));
    }else{ 
	    out.print(SystemEnv.getHtmlLabelName(19988,user.getLanguage()));
	}
%>

			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<%if(replyable.equals("1")){%>
			<input type="checkbox" name="canremind" value="2" id="remindinput" <%=canRemind.equals("2")?"checked":""%>><label for="remindinput"><%=SystemEnv.getHtmlLabelName(18641,user.getLanguage())%></label>
			<%}%>
			<%if(readoptercanprint.equals("2")){%>
			<input type="checkbox" name="readoptercanprint" value="1" id="readoptercanprint" <%=docreadoptercanprint==1?"checked":"" %>><label for="readoptercanprint"><%=SystemEnv.getHtmlLabelName(19462,user.getLanguage())%></label>
			<%} else if(readoptercanprint.equals("1")){%>
			<input type="hidden" name="readoptercanprint" value="1" id="readoptercanprint">
			<%} else if(readoptercanprint.equals("0")){%>
			<input type="hidden" name="readoptercanprint" value="0" id="readoptercanprint">
			<%}%>
		</wea:item>
	<%-- 编辑状态 end --%>
	</wea:group>
</wea:layout>
<script type="text/javascript">
	function afterSelectMainDoc(e,datas,name,params){
		if(datas){
			if(datas.id){
				$GetEle("maindoc").value=datas.id;
			}else{
				$GetEle("maindoc").value="<%=maindoc%>";
			}
		}
	}

</script>

<script>
jQuery(document).ready(function(){

areromancedivs();

});
</script>
