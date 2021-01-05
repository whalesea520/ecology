
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.docs.category.security.MultiAclManager" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<html><head>
<%//子目录id
	String id = Util.null2String(request.getParameter("id")); 
	RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();
	String validityWfId=Util.null2String(RecordSet.getString("validityApproveWf"));
	String invalidityWfId=Util.null2String(RecordSet.getString("invalidityApproveWf"));
%>
<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>

<script type="text/javascript">

jQuery(document).ready(function(){
	jQuery("#help").wTooltip({html:true});
});

function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}


function onSave(obj){
	obj.disabled=true;
	document.frmMain.operation.value="editApproveWf";
	document.frmMain.submit();
}
 
function onClear(obj){
	obj.disabled=true;

	document.frmMain.isOpenApproveWf[0].checked=false;
	document.frmMain.isOpenApproveWf[1].checked=false;
    document.getElementById("contentDiv").style.display = "none";
    document.getElementById("contentDivHis").style.display = "none";

	document.frmMain.operation.value="editApproveWf";
	document.frmMain.submit();
}

function showContent(objId)
{
	if(objId==1){
        //document.getElementById("contentDiv").style.display = "block";
    	//document.getElementById("contentDivHis").style.display = "none";
		showEle("contentDiv");
		hideEle("contentDivHis");
	}else if(objId==2){
        //document.getElementById("contentDiv").style.display = "none";
    	//document.getElementById("contentDivHis").style.display = "block";
		hideEle("contentDiv");
		showEle("contentDivHis");
	}else{
		hideEle("contentDiv");
		hideEle("contentDivHis");
	}
}

function encode(str){
    return escape(str);
}

function afterAddMoeSpanText1(e,datas,fieldid,params){
	if(datas){
		if(datas.id!=""){
			jQuery("#validityMoreSpan").html("<a href='#' onclick='validityWfSetting("+datas.id+");return false;' ><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>");
		}else{
			jQuery("#validityMoreSpan").html("<a><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>");
		}
	}
}

function addMoeSpanText1(data,e){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			_displayTemplate:"#b{name}",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(data){
		if(data.id!=""){
			jQuery("#validityWfId").val(data.id);
			jQuery("#validityWfIdspan").html("<a HREF='#"+data.id+"' >"+data.name+"</a>");
			jQuery("#validityMoreSpan").html("<a HREF='DocSecCategoryApproveWfDetailEdit.jsp?id=<%=id%>&approveType=1&approveWfId="+data.id+"' ><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>");
		}else{
			jQuery("#validityWfId").val("");
			jQuery("#validityWfIdspan").html("");
			jQuery("#validityMoreSpan").html("<a><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>");
		}
	}
}

function afterAddMoeSpanText2(e,datas,fieldid,params){
	if(datas){
		if(datas.id!=""){
			jQuery("#invalidityMoreSpan").html("<a href='#' onclick='invalidityWfSetting("+datas.id+");return false;' ><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>");
		}else{
			jQuery("#invalidityMoreSpan").html("<a><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>");
		}
	}
}

function addMoeSpanText2(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			_displayTemplate:"#b{name}",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data) {
		if(data.id!=""){
			jQuery("#invalidityWfId").val(data.id);
			jQuery("#invalidityWfIdspan").html("<a HREF='#"+data.id+"' >"+data.name+"</a>");
			jQuery("#invalidityMoreSpan").html("<a href='#' onclick='invalidityWfSetting("+data.id+");return false;' ><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>");
		}else{
			jQuery("#invalidityWfId").val("");
			jQuery("#invalidityWfIdspan").html("");
			jQuery("#invalidityMoreSpan").html("<a><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>");
		}
	}
}

function addMoeSpanText3(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			_displayTemplate:"#b{name}",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	data = window.showModalDialog("/workflow/workflow/WorkflowBrowser.jsp?isValid=1&sqlwhere=where isbill=1 and formid=28","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data) {
		if(data.id!=""){
			jQuery("#approveWorkflowId").val(data.id);
			jQuery("#approveWorkflowIdspan").html("<a HREF='#"+data.id+"' >"+data.name+"</a>");
		}else{
			jQuery("#approveWorkflowId").val("");
			jQuery("#approveWorkflowIdspan").html("");
		}
	}
}


function encodeUrl(option,e){
}

function invalidityWfSetting(wfid0){
	if(!wfid0)wfid0="<%=invalidityWfId%>";
	if(!wfid0)return;
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=75&isdialog=1&id=<%=id%>&approveType=2&approveWfId="+wfid0;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("19342",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function validityWfSetting(wfid0){
	if(!wfid0)wfid0="<%=validityWfId%>";
	if(!wfid0)return;
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=75&isdialog=1&id=<%=id%>&approveType=1&approveWfId="+wfid0;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("19342",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

</script>
</head>

<%
	String titlename = "";
    String pzgzlurl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1&sqlwhere="+xssUtil.put("where isbill=1 and formid=28");
	String subcategoryid=RecordSet.getString("subcategoryid");
	String isOpenApproveWf=Util.null2String(RecordSet.getString("isOpenApproveWf"));

	String approveWorkflowId=Util.null2String(RecordSet.getString("approveWorkflowId"));

	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);


	boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	MultiAclManager am = new MultiAclManager();
	hasSubManageRight = am.hasPermission(mainid, MultiAclManager.CATEGORYTYPE_MAIN, user, MultiAclManager.OPERATION_CREATEDIR);
	int parentId = Util.getIntValue(scc.getParentId(""+id));
	if(parentId>0){
		hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
	}

    boolean canEdit = false ;
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user)|| hasSecManageRight) {
		canEdit = true ;   
	}
	 int detachable = ManageDetachComInfo.isUseDocManageDetach()?1:0;
  int operatelevel=0;
  if(detachable==1){
	   operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryAdd:Add",Util.getIntValue(scc.getSubcompanyIdFQ(id+""),0));
  }else{
	   if(HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user) || hasSecManageRight)
	         operatelevel=2;
 }

if(operatelevel>0){
	 canEdit = true;
	
}else{
	 canEdit = false;
	
}
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
  //菜单
  if (canEdit){
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	  RCMenuHeight += RCMenuHeightStep ;
  }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


	<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(canEdit){ %>
				<input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>

<FORM METHOD="POST" name="frmMain" ACTION="DocSecCategoryApproveWfOperation.jsp">
<INPUT TYPE="hidden" NAME="operation">
<INPUT TYPE="hidden" NAME="id" value="<%=id%>">
<INPUT TYPE="hidden" NAME="hisValidityWfId" value="<%=validityWfId%>">
<INPUT TYPE="hidden" NAME="hisInvalidityWfId" value="<%=invalidityWfId%>">

	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(30041,user.getLanguage())+SystemEnv.getHtmlLabelName(30835,user.getLanguage())+SystemEnv.getHtmlLabelName(26361,user.getLanguage())%>'>
				<%
					String title="<p><strong>"+SystemEnv.getHtmlLabelName(19540,user.getLanguage())+"：</strong></p>"+
                    "<ul style='padding-left:15px;'>"+
					  "<li>"+SystemEnv.getHtmlLabelName(20291,user.getLanguage())+"</li>"+
					  "<li>"+SystemEnv.getHtmlLabelName(20292,user.getLanguage())+"</li>"+
					  "<li>"+SystemEnv.getHtmlLabelName(20293,user.getLanguage())+"</li>"+
                    "</ul>"+
                  "<br/>"+
                 "<p><strong>"+SystemEnv.getHtmlLabelName(19758,user.getLanguage())+"：</strong></p>"+
                   "<ul style='padding-left:15px;'>"+
					  "<li>"+SystemEnv.getHtmlLabelName(20294,user.getLanguage())+"</li>"+
					  "<li>"+SystemEnv.getHtmlLabelName(20295,user.getLanguage())+"</li>"+
					  "<li>"+SystemEnv.getHtmlLabelName(20296,user.getLanguage())+"</li>"+
                    "</ul>"; 
					title=Util.StringReplace(title,"\"","&quot;");
				%>
			<wea:item><%=SystemEnv.getHtmlLabelName(25102,user.getLanguage())%></wea:item>
			<wea:item>
				<select onchange="showContent(this.value);" name="isOpenApproveWf">
	            	<option value=""><%=SystemEnv.getHtmlLabelName(32386,user.getLanguage())%></option>
	            	<option value="1" <%if ("1".equals(isOpenApproveWf)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(19540,user.getLanguage())%></option>
	            	<option value="2" <%if ("2".equals(isOpenApproveWf)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(19758,user.getLanguage())%></option>
	            </select>
	            <span id="help" title="<%=title %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
			</wea:item>
			<%String attr = "{'isTableList':'true','samePair':'contentDiv','colspan':'full','display':'"+("1".equals(isOpenApproveWf)?"":"none")+"'}"; %>
			<wea:item attributes='<%=attr %>'>
				<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'3','cws':'20%,50%,30%'}">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19535,user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15058,user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(19536,user.getLanguage())%></wea:item>
						<wea:item>
							<%
								if(canEdit){
							%>
										<!-- <input  class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1" _callBack="addMoeSpanText1"  _displayText="<%=Util.toScreen(WorkflowComInfo.getWorkflowname(validityWfId),user.getLanguage())%>" type=hidden name="validityWfId" value="<%=validityWfId%>"> -->

										<brow:browser viewType="0" name="validityWfId" browserSpanValue='<%=Util.toScreen(WorkflowComInfo.getWorkflowname(validityWfId),user.getLanguage())%>' 
											_callback="afterAddMoeSpanText1" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1"
											hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
											completeUrl="/data.jsp" browserValue='<%=validityWfId %>' linkUrl="#" width="80%"
											></brow:browser>
								
							<%
								}else{
							%>
												 <span id=validityWfSpan><%=Util.toScreen(WorkflowComInfo.getWorkflowname(validityWfId),user.getLanguage())%></span>
							<%} %>
						</wea:item>
						<wea:item>
							<span id=validityMoreSpan>
							<%
								if(validityWfId!=null&&!validityWfId.equals("")&&!validityWfId.equals("0")){
							%>
											<a href="#" onclick="validityWfSetting();return false;"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>
							<%
								}else{
							%>
											<a><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>
							<%
								}	
							%>

											</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(19537,user.getLanguage())%></wea:item>
						<wea:item>
							<%
								if(canEdit){
							%>
										<!-- <input  class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1" _callBack="addMoeSpanText2"  _displayText="<%=Util.toScreen(WorkflowComInfo.getWorkflowname(invalidityWfId),user.getLanguage())%>" type=hidden name="invalidityWfId" value="<%=invalidityWfId%>"> -->
										<brow:browser viewType="0" name="invalidityWfId" browserSpanValue='<%=Util.toScreen(WorkflowComInfo.getWorkflowname(invalidityWfId),user.getLanguage())%>' 
											_callback="afterAddMoeSpanText2" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1"
											hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
											completeUrl="/data.jsp" browserValue='<%=invalidityWfId %>' linkUrl="#" width="80%"
											></brow:browser>
							<%
								}else{
							%>
										<span id=invalidityWfSpan><%=Util.toScreen(WorkflowComInfo.getWorkflowname(invalidityWfId),user.getLanguage())%></span>
							<%} %>              　　
						</wea:item>
						<wea:item>
							<span id=invalidityMoreSpan>
								<%
									if(invalidityWfId!=null&&!invalidityWfId.equals("")&&!invalidityWfId.equals("0")){
								%>
												<a href="#" onclick="invalidityWfSetting();return false;"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>
								<%
									}else{	
								%>
												<a  ><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>
								<%
									}	
								%>
							</span>
						</wea:item>
					</wea:group>
				</wea:layout>
			</wea:item>
			<% attr = "{'isTableList':'true','samePair':'contentDivHis','colspan':'full','display':'"+("2".equals(isOpenApproveWf)?"block":"none")+"'}"; %>
			<wea:item attributes='<%=attr %>'>
				<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'2','cws':'35%,65%'}">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19761,user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19762,user.getLanguage())%></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(1003,user.getLanguage())%></wea:item>
						<wea:item>
							<%
								if(canEdit){
							%>
							   　　<!-- <input class="wuiBrowser" type=hidden name="approveWorkflowId" _beforeShow="encodeUrl" _url="/workflow/workflow/WorkflowBrowser.jsp?isValid=1&sqlwhere=where isbill=1 and formid=28" _displayText="<%=Util.toScreen(WorkflowComInfo.getWorkflowname(approveWorkflowId),user.getLanguage())%>" value="<%=approveWorkflowId%>"> -->
							   <brow:browser viewType="0" name="approveWorkflowId" browserSpanValue='<%=Util.toScreen(WorkflowComInfo.getWorkflowname(approveWorkflowId),user.getLanguage())%>' 
											browserUrl="<%=pzgzlurl%>"
											hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
											completeUrl="/data.jsp" browserValue='<%=approveWorkflowId %>' linkUrl="#" width="150px"
											></brow:browser>
							<%
								}else{
							%>    
							<span id="approveWorkflowIdSpan"><%=Util.toScreen(WorkflowComInfo.getWorkflowname(approveWorkflowId),user.getLanguage())%></span>
             　　			<%} %>
						</wea:item>
					</wea:group>
				</wea:layout>
			</wea:item>
		</wea:group>
	</wea:layout>
		
</FORM>
</BODY>
</html>

