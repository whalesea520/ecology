
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>
<%@ page import = "weaver.general.Util" %>
<jsp:useBean id = "rs" class = "weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String subcompanyid = Util.null2String(request.getParameter("subcompanyid")) ;
%>

<HTML><HEAD>
<LINK href = "/css/Weaver_wev8.css" type = text/css rel = STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"HrmSalaryItemOperation.jsp?isdialog=1&method=delete&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
					}
				}
			});
		}
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmSalaryItemAdd&isdialog=1";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(33397,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmSalaryItemEdit&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(33397,user.getLanguage())%>";
	}
	url+="&subcompanyid=<%=subcompanyid%>";
	dialog.maxiumnable=true;
	//dialog.DefaultMax=true;
	dialog.Width = 1000;
	dialog.Height = 800;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function openDialogView(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	var url = url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmSalaryItemEdit&isdialog=1&id="+id+"&subcompanyid=<%=subcompanyid%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(33397,user.getLanguage())%>";
	dialog.maxiumnable=true;
	//dialog.DefaultMax=true;
	dialog.Width = 1000;
	dialog.Height = 800;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=63 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=63")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function doProcess(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15840,user.getLanguage())%>\n<%=SystemEnv.getHtmlLabelName(15841,user.getLanguage())%>?",function(){
		jQuery.ajax({
			url:"HrmSalaryItemOperation.jsp?isdialog=1&method=process&id="+id,
			type:"post",
			async:true,
			complete:function(xhr,status){
					_table.reLoad();
			}
		});
	});
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16481 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ;

String itemname = Util.null2String(request.getParameter("itemname"));
String itemcode = Util.null2String(request.getParameter("itemcode"));
String subcompanyid_kwd = Util.null2String(request.getParameter("subcompanyid_kwd"));
if(subcompanyid_kwd.length()==0)subcompanyid_kwd = subcompanyid;
String itemtype = Util.null2String(request.getParameter("itemtype"));

String qname = Util.null2String(request.getParameter("flowTitle"));

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=-1;
if(detachable==1&&subcompanyid.length()>0){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceComponentAdd:Add",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceComponentAdd:Add", user))
        operatelevel=2;
}
if(operatelevel<0){
    		response.sendRedirect("/notice/noright.jsp") ;
    		return ;
}
boolean CanAdd=false;
if(operatelevel>0)
    CanAdd=true;

String rolelevel=CheckUserRight.getRightLevel("HrmResourceComponentAdd:Add" , user);

%>

<BODY>
<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<INPUT type="hidden" name="subcompanyid" value="<%=subcompanyid%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmResourceComponentAdd:Add", user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<%}if(HrmUserVarify.checkUserRight("HrmResourceComponentEdit:Edit", user)){ %>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="subcompanyid_kwd" browserValue='<%= subcompanyid_kwd %>' 
				  browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowserByDec.jsp?rightStr=HrmResourceComponentAdd:Add&selectedids="
				  hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				  completeUrl="/data.jsp?type=164" width="240px"
				  browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subcompanyid_kwd)%>'>
				</brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(590,user.getLanguage())%></wea:item>
			<wea:item>
				<INPUT class=inputstyle maxLength = 50 size = 25 name = "itemcode" style="width: 240px" value="<%=itemcode%>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item>
				<INPUT class=inputstyle maxLength=50 size=25 name="itemname" style="width: 240px" value="<%=itemname%>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
			<wea:item>
	      <select name = "itemtype" style = "width:100px">
	      	<option value = ""></option>
	        <option value = "1" <%if(itemtype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1804 , user.getLanguage())%></option>
	        <option value = "3" <%if(itemtype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15826 , user.getLanguage())%></option>
	        <option value = "4" <%if(itemtype.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(449 , user.getLanguage())%></option>
	        <option value = "9" <%if(itemtype.equals("9")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15825 , user.getLanguage())+SystemEnv.getHtmlLabelName(449 , user.getLanguage())%></option>
	      </select>
			</wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</form>
<%
String backfields = " id, itemname, itemcode, itemtype, isshow, applyscope, subcompanyid"; 
String fromSql  = " from hrmsalaryitem ";
String sqlWhere = " where subcompanyid = "+subcompanyid;
String orderby = " showorder asc " ;
String tableString = "";

if(Util.null2String(request.getParameter("subcompanyid")).length()==0){
	//如果没有传入subcompanyid
	if(detachable==1){
		//分权情况，取有权限的分部
		int[] companyids = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"HrmResourceComponentAdd:Add");
		String comStr = "";
		for(int i=0;companyids!=null&&i<companyids.length;i++){
			if(comStr.length()>0)comStr+=",";
			comStr+=companyids[i];
		}
		
		sqlWhere = " where subcompanyid in ("+comStr+")";
	}else{
		//不分权情况，显示全部
		sqlWhere = " where 1=1 ";
	}
}

if(!qname.equals("")){
	sqlWhere += " and itemname like '%"+qname+"%'";
}		

if (!"".equals(itemname)) {
	sqlWhere += " and itemname like '%"+itemname+"%'";
	}  	  	

if (!"".equals(itemcode)) {  
	sqlWhere += " and itemcode like '%"+itemcode+"%'"; 	  	
}

if (!"".equals(subcompanyid_kwd)) {  
	sqlWhere += " and subcompanyid = "+subcompanyid_kwd; 	  	
}

if (!"".equals(itemtype)) {  
	sqlWhere += " and itemtype = "+itemtype; 	  	
}

//System.out.println(sqlWhere);

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getHrmSalaryItemOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmResourceComponentAdd:Add", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmResourceComponentEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("HrmResourceComponentEdit:Edit", user)+"\"></popedom> ";
 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       operateString+="     <operate href=\"javascript:doProcess()\" text=\""+SystemEnv.getHtmlLabelName(15839,user.getLanguage())+"\" index=\"2\"/>";
 	       operateString+="</operates>";	
 String tabletype="checkbox";
 if(HrmUserVarify.checkUserRight("HrmSpecialityEdit:Delete", user)){
 	tabletype = "checkbox";
 }
 
tableString =" <table pageId=\""+PageIdConst.HRM_SalaryItemList+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_SalaryItemList,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getHrmSalaryItemCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"itemname\" orderkey=\"itemname\" linkvaluecolumn=\"id\" linkkey=\"id\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmSalaryItemDsp\" target=\"_fullwindow\"  />"+
    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"itemtype\" orderkey=\"itemtype\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmSalaryItemTypeName\" otherpara=\""+user.getLanguage()+"\"/>"+
    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(19799,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\"/>"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(19374,user.getLanguage())+"\" column=\"applyscope\" orderkey=\"applyscope\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmSalaryItemScope\" otherpara=\""+user.getLanguage()+"\"/>"+
    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(33602,user.getLanguage())+"\" column=\"isshow\" orderkey=\"isshow\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmSalaryItemIsShowName\" otherpara=\""+user.getLanguage()+"\"/>"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_SalaryItemList %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
</BODY>
</HTML>
