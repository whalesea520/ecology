
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<jsp:useBean id="ddc" class="weaver.docs.docs.DocDataSource" scope="page" />
<jsp:useBean id="spop" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<script type="text/javascript" src="/js/doc/upload_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<%

String docid = Util.null2String(request.getParameter("docid"));
int votingId=Util.getIntValue(request.getParameter("votingId"),0); 
String mode = Util.null2String(request.getParameter("mode"));
boolean canEdit = Util.null2String(request.getParameter("canEdit")).equals("true");
boolean canDownload = Util.null2String(request.getParameter("canDownload")).equals("true");
String secid = Util.null2String(request.getParameter("secid"));
String meetingid = Util.null2String(request.getParameter("meetingid"));
if(!"".equals(docid)){
	secid = DocComInfo.getDocSecId(docid);
}

boolean hasRight=false;

if(mode.equals("view")&&!docid.equals("")){
	String sessionPara=""+docid+"_"+user.getUID()+"_"+user.getLogintype();
	String right_view=(String)session.getAttribute("right_view_"+sessionPara);
	if("1".equals(right_view)){
		hasRight=true;
	}
	/*int rightcounter=Util.getIntValue((String)session.getAttribute("rightcounter_view_"+sessionPara),-1);

	if(rightcounter<=1){
		session.removeAttribute("right_view_"+sessionPara);
		session.removeAttribute("rightcounter_view_"+sessionPara);
	}else{
		rightcounter--;
		session.setAttribute("rightcounter_view_"+sessionPara,""+rightcounter);
	} */
}

if(!hasRight){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}


%>
<script type="text/javascript">
	
   var checkimageid="";
	function downloadDocImgsSingle(id){
		if(checkimageid!=""){
		  id=checkimageid;
		}
		downloadDocImgs("<%=docid%>",{id:id,votingId:"<%=votingId%>",_window:parent,downloadBatch:0,emptyMsg:"<%=SystemEnv.getHtmlLabelName(31033,user.getLanguage())%>"});
	    checkimageid="";
	}

	function downloadDocImgsVersion(id,params,obj){
		
		jQuery("#selectVersionBtn").attr("data-imgid",id);
		jQuery("#selectVersionBtn").trigger("click");
		
		
	}
	function openTip(flag){
		var dialog = new window.top.Dialog();
		var url="/wui/common/page/sysRemindfordoc.jsp";
		if(flag==1){
			url="/wui/common/page/sysRemindfordoc.jsp?labelid=129755";
		}else if(flag==2){
			url="/wui/common/page/sysRemindfordoc.jsp?labelid=129757";
		}
		dialog.currentWindow = window; 
		dialog.URL = url;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%>";
		dialog.Width = 850;
		dialog.Height = 450;
		dialog.Drag = true;
		dialog.show();
	}
	function getBrowserUrl(){
		return "/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/listVersion.jsp?docid=<%=docid%>&imgId="+jQuery("#selectVersionBtn").attr("data-imgid")+"&canDownload=<%=canDownload%>";
	}

	function afterSelectVersion(e,datas,params,name){		
		if(datas){			
			if(datas.id!=""){
				checkimageid=datas.id;
			}
		}
	}
	
	function used4SelectAccVersion(versionId){
		jQuery("#selectAccVersionBtn").attr("data-versionid",versionId);
		jQuery("#selectAccVersionBtn").trigger("click");	
	}
	
	function getBrowserUrl4selectAccVersionNew(){
		return "/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/listVersion.jsp?versionId="+jQuery("#selectAccVersionBtn").attr("data-versionid")+"&docid=<%=docid%>"+"&canDownload=<%=canDownload%>";	
	}
	
	function afterSelectAccVersionNew(e,datas,params,name){
		if(datas){			
			if(datas.id!=""){
				parent.window.location="DocDspExt.jsp?id=<%=docid%>&versionId="+datas.id+"&isFromAccessory=true&votingId=<%=votingId%>";
			}
		}	
	}
	
</script>

<%

boolean isEditionOpen = SecCategoryComInfo.isEditionOpen(Util.getIntValue(secid));
if(!"".equals(docid)){
	secid = DocComInfo.getDocSecId(docid);
}
isEditionOpen = SecCategoryComInfo.isEditionOpen(Util.getIntValue(secid));
String pagename = Util.null2String(request.getParameter("pagename"));
String qname = Util.null2String(request.getParameter("flowTitle"));
String operation = Util.null2String(request.getParameter("operation"));
int maxUploadImageSize = Util.getIntValue(Util.null2String(request.getParameter("maxUploadImageSize")),-1);
if(maxUploadImageSize==-1){
	maxUploadImageSize = DocUtil.getMaxUploadImageSize(Util.getIntValue(secid));
}
int bacthDownloadFlag = Util.getIntValue(Util.null2String(request.getParameter("bacthDownloadFlag")),0);
String canShare = Util.null2String(request.getParameter("canShare"));
int language = user.getLanguage();

Map<String,String> params = new HashMap<String,String>();
params.put("docid",docid);
params.put("isEditionOpen",isEditionOpen?"true":"false");
params.put("showType",mode);
params.put("canEdit",mode.equals("add")?"true":canEdit+"");
params.put("canDownload",canDownload?"true":"false");
params.put("attachname",qname);
params.put("meetingid",meetingid);

List<Map<String,String>> accs = ddc.getDocImgList(user,params,request,response);
%>
 <brow:browser name="versionId" viewType="0" display="none"  browserBtnID="selectVersionBtn" getBrowserUrlFn="getBrowserUrl"  isMustInput="1"  _callback="afterSelectVersion"/>
 <brow:browser name="_selectAccVersionBtn" viewType="0" display="none"  browserBtnID="selectAccVersionBtn" getBrowserUrlFn="getBrowserUrl4selectAccVersionNew"  isMustInput="1"  _callback="afterSelectAccVersionNew"/>
 <script type="text/javascript">
 	function hideAccPanel(){
 		jQuery("div.e8AccListArea").hide();
 		jQuery("div.e8AccListBtn").show();
 		jQuery("#e8DocAccviewIframe").show();
 		adjustContentHeight("",0);
 		jQuery("div.e8AccListArea").data("isClosed",true);
 	}
 	
 	function showAccPanel(){
 		jQuery("div.e8AccListArea").show();
 		jQuery("div.e8AccListBtn").hide();
 		jQuery("#e8DocAccviewIframe").hide();
 		adjustContentHeight("");
 		jQuery("div.e8AccListArea").data("isClosed",false);
 	}
 	function openDivAcc(tab){
 		jQuery("div.e8AccListArea").hide();
 		jQuery("div.e8AccListBtn").hide();
 		jQuery("#e8DocAccviewIframe").hide();
 		adjustContentHeight("",0);
 		onActiveTab(tab);
 	}
 </script>
<div class="e8AccListBtn" onclick="javascript:showAccPanel();"></div>
<div class="e8AccListArea">
	<div class="e8AccListHead">
		<div class="e8AccListHeadLeft">
			<span style="padding-left:10px;"><img src="/images/docs/accTitle_wev8.png" width="16px" height="16px" style="vertical-align:middle;"/></span>
			<span style="padding-left:10px;"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage()) %></span>
		</div>
		<div class="e8AccListHeadRight" onclick="javascript:hideAccPanel();"></div>
	</div>
	<div class="e8AccListContent">
		<table class="e8AccListTable">
			<colgroup>
				<col width="45%"/>
				<col width="45%"/>
				<col width="10%"/>
			</colgroup>
			<tbody>
				<%for(int i=0;i<accs.size();){  
					if(i<6){
						Map<String,String> acc = accs.get(i);
						String icon = acc.get("icon");
						String name = acc.get("name");
						String size = acc.get("size");
						List<String> opts = spop.getImageOpt(acc.get("imgid"),docid);
						i++;
				%>
					<tr>
						<td>
							<table style="width:100%;">
								<col width="5%"/>
								<col width="55%"/>
								<col width="15%"/>
								<col width="25%"/>
								<tbody>
									<tr>
										<td><%=icon %></td>
										<td><%= name%></td>
										<td style="color:#8d8d8d;"><%= size %></td>
										<td>
											<%if(canDownload){ %>
												<a href="#" onclick="downloadDocImgsSingle('<%= acc.get("imgid")%>','',this);return false;">
													<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage()) %>
												</a>
												<%if(opts.get(1).equals("true")){ %>
													<a href="#" onclick="downloadDocImgsVersion('<%= acc.get("imgid")%>','<%= acc.get("imgid")%>',this);return false;">
														<%=SystemEnv.getHtmlLabelName(16384,user.getLanguage()) %>
													</a>
												<%} %>
											<%} %>
										</td>
									</tr>
								</tbody>
							</table>
						</td>
						<td>
				<%
						if(i<accs.size()){
							acc = accs.get(i);
							icon = acc.get("icon");
							name = acc.get("name");
							size = acc.get("size");
							opts = spop.getImageOpt(acc.get("imgid"),docid);
							i++;
				%>
							<table style="width:100%;">
								<col width="5%"/>
								<col width="55%"/>
								<col width="15%"/>
								<col width="25%"/>
								<tbody>
									<tr>
										<td><%=icon %></td>
										<td><%= name%></td>
										<td style="color:#8d8d8d;"><%= size %></td>
										<td>
											<%if(canDownload){ %>
												<a href="#" onclick="downloadDocImgsSingle('<%= acc.get("imgid")%>','',this);return false;">
													<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage()) %>
												</a>
												<%if(opts.get(1).equals("true")){ %>
													<a href="#" onclick="downloadDocImgsVersion('<%= acc.get("imgid")%>','<%= acc.get("imgid")%>',this);return false;">
														<%=SystemEnv.getHtmlLabelName(16384,user.getLanguage()) %>
													</a>
												<%} %>
											<%} %>
										</td>
									</tr>
								</tbody>
							</table>
						<%} %>
						</td>
						<td>
							<%if(i<=2 && accs.size()>6){ %>
								<span style="cursor:pointer;color:#8d8d8d;" onclick="openDivAcc('divAcc');">MORE &gt;&gt;</span>
							<%} %>
						</td>
					</tr>	
				<%
					}else{
						break;
					}
				} %>
			</tbody>
		</table>
	</div>
</div>
