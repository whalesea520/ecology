<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.service.CustomSearchService"%>
<%@page import="org.apache.lucene.util.StringHelper"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.workflow.workflow.BillComInfo"%>
<%@page import="weaver.formmode.service.CommonConstant"%>
<%@page import="weaver.formmode.service.AppInfoService"%>
<%@page import="weaver.formmode.service.SelectItemPageService"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%
int id = Util.getIntValue(request.getParameter("id"), 0);
int statelev = Util.getIntValue(request.getParameter("statelev"), 1);
int initpid = Util.getIntValue(request.getParameter("pid"), 0);
String selectitemname = "";
String selectitemdesc = "";
int opentype = 0;
String norightlist = "";
String formID = "";	
String formName = "";
String modeid = "";
String modename = "";
String isBill = "1";
String appid=Util.null2String(request.getParameter("appid"));
String searchconditiontype = "1";
String javafilename = "";
String dsporder = "";
int pagenumber = 10;
String detailtable="";
int rowno =0;
String isnullFun=CommonConstant.DB_ISNULL_FUN;
String sql = "";

String titlename = "";
SelectItemPageService selectItemPageService=new SelectItemPageService();
BillComInfo billComInfo=new BillComInfo();
if(id!=0){
	Map<String,Object> map=selectItemPageService.getSelectItemPageById(id);
	if(map.size()>0){
		selectitemname=Util.toScreen(Util.null2String(map.get("selectitemname")),user.getLanguage());
		selectitemdesc=Util.toScreenToEdit(Util.null2String(map.get("selectitemdesc")),user.getLanguage());
		modeid=Util.null2String(map.get("appid"));
		if(appid.equals("")||appid.equals("0")){
			appid=Util.null2String(map.get("appid"));
		}
		if ("".equals(appid)) appid=Util.null2String(map.get("appid"));
		pagenumber = Util.getIntValue(Util.null2String(map.get("pagenumber")),10);
	}
}
if(!"".equals(modeid)){
	rs.executeSql("select modename from modeinfo where id="+modeid+"");
	if(rs.next()){
		modename = rs.getString("modename");
	}
}
int isvirtualform = 0;


int subCompanyId = -1;
String userRightStr = "FORMMODEAPP:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

String allStateName = "";
if(statelev>1){
	allStateName = selectItemPageService.getAllStateName(initpid,id,appid,allStateName);
}


String initsql = "select * from mode_selectitempage where uuid is null";
rs.executeSql(initsql);
while(rs.next()){
	String uuid = selectItemPageService.getUUID();
	String tempid = rs.getString("id");
	String updatesql = "update mode_selectitempage set uuid='"+uuid+"' where id="+tempid;
	RecordSet.executeSql(updatesql);
}

initsql = "select * from mode_selectitempagedetail where uuid is null";
rs.executeSql(initsql);
while(rs.next()){
	String uuid = selectItemPageService.getUUID();
	String tempid = rs.getString("id");
	String updatesql = "update mode_selectitempagedetail set uuid='"+uuid+"' where id="+tempid;
	RecordSet.executeSql(updatesql);
}

%>
<html>
<head>
	<title></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET> 
<script language=javascript src="/js/weaver_wev8.js"></script>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<style>
a:hover{color:#0072C6 !important;}
.e8_data_virtualform{
	background: url(/formmode/images/circleBgGold_wev8.png) no-repeat 1px 1px;
	width: 16px;
	display:inline;
	color: #fff;
	font-size: 9px;
	font-style: italic;
	top: 5px;
	padding-left: 3px;
	padding-right: 6px;
	padding-top: 2px;
}
</style>
<style>
.cbboxContainer{
	margin: 3px 0px 0px -2px;
}
.cbboxEntry{
	display: inline-block;position: relative;padding-right: 20px;
}
.cbboxLabel{
	color: #999;font-size: 11px;position: absolute;top:2px;left:18px;
}
.codeEditFlag{
	padding-left:20px;
	padding-right: 10px;
	height: 16px;
	background:transparent url('/formmode/images/list_edit_wev8.png') no-repeat !important;
	cursor: pointer;
	margin-left: 2px;
	margin-top: 2px;
	position: relative;
}
.codeDelFlag{
	position: absolute;
	top: 2px;
	right: 2px;
	width:9px;
	height:9px;
	background:transparent url('/images/messageimages/delete_wev8.gif') no-repeat !important;
	cursor: pointer;	
}
#detailtable_loading{
	position: absolute;top: 0px;left: 5px;z-index: 10000;
	padding: 3px 10px 3px 20px; 
	vertical-align:middle; 
	background-image: url('/images/messageimages/loading_wev8.gif');
	background-repeat: no-repeat;
	background-position: 0px center;
	color: #aaa;
	display: none;
}
#detailtable_tr{
	display:none;
}
</style>
<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></SCRIPT>
<script language="JavaScript" src="/js/addRowBg_wev8.js"></script>
<script>
$(document).ready(function () {
	$(".codeDelFlag").click(function(e){
		if(confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>？")){//确认要删除吗？
			$("#javafilename_span").html("");
			$("#javafilename").val("");
			$(".codeDelFlag").hide();
		}
		e.stopPropagation(); 
	});
	formidChange();
});

function changeSCT(cbObj){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			jQuery("input[type='checkbox'][name='searchConditionType']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		
		jQuery(".sctContent").hide();
		jQuery("#SCT_Div_"+objV).show();
	},100);
}

function openCodeEdit(){
	top.openCodeEdit({
		"type" : "2",
		"filename" : $("#javafilename").val()
	}, function(result){
		if(result){
			var fName = result["fileName"];
			$("#javafilename_span").html(fName);
			$("#javafilename").val(fName);
			$(".codeDelFlag").show();
		}
	});
}
function checkVal(){
			var valid=false;
			var checkrule='^(-?\\d+)(\\.\\d+)?$';
			var dsporder=document.getElementById("dsporder").value;
			eval("valid=/"+checkrule+"/.test(\""+dsporder+"\");");
			if (dsporder!=''&&!valid){
				alert('<%=SystemEnv.getHtmlLabelName(82018,user.getLanguage())%>');//显示顺序中请输入数字!
				document.getElementById("dsporder").value='';
			}
}
function checkPageNumVal(){
	var pagenumber=document.getElementById("pagenumber").value;
	if(!/^\+?[1-9][0-9]*$/.test(pagenumber)){
		document.getElementById("pagenumber").value='';
		document.getElementById("pagenumberspan").innerHTML="<font color='red'><%=SystemEnv.getHtmlLabelName(82019,user.getLanguage())%></font>";//输入值不符合正整数!
	}else{
		document.getElementById("pagenumberspan").innerHTML="";
	}
}
</script>
</head>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;//保存
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<form id="formCustomSearch" name="formCustomSearch" method="post" action="/formmode/setup/SelectItemPageAction.jsp">
<input type="hidden" name="id" id="id" value="<%=id %>" />
<input type="hidden" name="appid" id="appid" value="<%=appid %>"/>
<input type="hidden" name="action" id="action" value="selectitemedit"/>
<input type="hidden" name="operation" id="operation" value="saveorupdate"/>
<input type="hidden" name="fmdetachable" id="fmdetachable" value="<%=fmdetachable %>"/>
<input type="hidden" name="detailjson" id="detailjson" value=""/>
<input type="hidden" name="statelev" id="statelev" value="<%=statelev %>"/>
<input type="hidden" name="pid" id="pid" value="<%=initpid %>"/>
<input type="hidden" name="delids" id="delids" value=""/>

<table class="e8_tblForm">

<tr>
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td><!-- 名称 -->
	<td class="e8_tblForm_field">
		<input type="text" id="selectitemname" name="selectitemname" style="width:80%;" onchange='checkinput("selectitemname","selectitemnamespan")' value="<%=selectitemname %>"/> 
		<span id="selectitemnamespan">
		    <%if ("".equals(selectitemname)) { %>
				<img src="/images/BacoError_wev8.gif"/>
			<% } %>
		</span>
	</td>
</tr>
<%
String _style = "display:none;";
if (!"".equals(formID)) { 
	_style = "";
}%>
<tr id="modetr" style="<%=_style%>">
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%></td><!-- 模块名称 -->
	<td class="e8_tblForm_field">
	<select id="modeid" name="modeid" style="width: 200px;">
		<option></option>
		<%if(!formID.isEmpty()){
			String modeSql = "select id,modename from modeinfo where formid="+formID+" and "+isnullFun+"(isdelete,0)!=1 ";
			if(fmdetachable.equals("1")){
              	CheckSubCompanyRight mSubRight = new CheckSubCompanyRight();
	  			int[] mSubCom = mSubRight.getSubComByUserRightId(user.getUID(),"ModeSetting:All",0);
	  			String subCompanyIds = "";
	  			for(int i=0;i<mSubCom.length;i++){
	  				if(i==0){
	  					subCompanyIds += ""+mSubCom[i];
	  				}else{
	  					subCompanyIds += ","+mSubCom[i];
	  				}
	  			}
	  			if(subCompanyIds.equals("")){
	  				modeSql+= " and 1=2 ";
	  			}else{
	  				modeSql+= " and subCompanyId in ("+subCompanyIds+") ";
	  			}
          }
			modeSql += " order by id ";
			rs.executeSql(modeSql);
			boolean isInSubCompany = false;
			while(rs.next()){
				String mid = rs.getString("id");
				String mname = rs.getString("modename");
				if(mid.equals(modeid)){
					isInSubCompany = true;
				}
		%>
				<option <%if(mid.equals(modeid)){%>selected="selected"<%} %> value="<%=mid %>"><%=mname %></option>
		<%} 
			if(!isInSubCompany){
				modeSql = "select id,modename from modeinfo where id="+modeid;
				rs.executeSql(modeSql);
				if(rs.next()){
					String mname = rs.getString("modename");
			%>
				<option  selected="selected"  value="<%=modeid %>"><%=mname %></option>
			<% } }
		} %>
	</select>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!-- 描述 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82050,user.getLanguage())%><!-- 描述报表用途。 --></div></td>
	<td class="e8_tblForm_field">
		<textarea name="selectitemdesc" style="width:80%;height:50px;"><%=selectitemdesc %></textarea>
	</td>
</tr>
</table>
<%
		if(id!=0){//新增的时候子表不加入。在编辑的时候才能进行子表编辑
%>
<TABLE class="e8_tblForm">
						        		<TBODY>
									        <TR class=title>
									        <td style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(82455,user.getLanguage())%><!--选择项内容--><%=allStateName %></td>
									        <td id="btnTD" align=right>
<%if(operatelevel>0){%>
	<button
		type="button"
		title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" 
		class="addbtn2" 
		onclick="addRow()"></button><!-- 添加 -->
<%} %>
									            
<%if(operatelevel>1){%>
	<button 
		type="button"
		title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" 
		class="deletebtn2" 
		onclick="if(isdel()){delRow();}"></button><!-- 删除 -->
<%} %>									            

												</td>
											</TR>
						        			<tr>
										        <td colspan=2>
													<table class="e8_tblForm" id="oTable" style="margin-top: 5px;">
											            <COLGROUP>
												    		<COL width="5%">
												    		<COL width="20%">
												    		<COL width="10%">
												    		<COL width="10%">
												    		<!--<COL width="25%"> -->
												    		<COL width="10%">
												    		<COL width="20%">
											    		</COLGROUP>
											    		<tr class="header" >
											    		   <th><input type="checkbox" name="selectall" id="selectall" onclick="SelAll(this)"></th>
											    		   <th><%=SystemEnv.getHtmlLabelName(82456,user.getLanguage())%></th><!-- 可选择项文字 -->
											    		   <th><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></th><!-- 显示顺序 -->
														   <th><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></th><!-- 默认值 -->
											    		   <!--<th><%=SystemEnv.getHtmlLabelName(19207,user.getLanguage())%></th> 关联文档目录 -->
														   <th><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></th><!-- 描述 -->
														   <th><%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%></th><!-- 封存 -->
											    		</tr>
											    		<%
											    			String needcheck = "";
											    			sql = "select b.*,(select count(1) from mode_selectitempagedetail a where a.pid=b.id ) as subcount from mode_selectitempagedetail b where mainid = "+id+" and statelev='"+statelev+"' and pid='"+initpid+"' order by disorder asc,id asc ";
											    			rs.executeSql(sql);
											    			while(rs.next()){
											    				String detailid = Util.null2String(rs.getString("id"));
											    		    	String name = Util.null2String(rs.getString("name"));
											    		    	String defaultvalue = Util.null2String(rs.getString("defaultvalue"));
											    		    	String pathcategory = Util.null2String(rs.getString("pathcategory"));
											    		    	String maincategory = Util.null2String(rs.getString("maincategory"));
											    		    	String pid = Util.null2String(rs.getString("pid"));
											    		    	String subcount = Util.null2String(rs.getString("subcount"));
											    		    	double disorder = Util.getDoubleValue(rs.getString("disorder"),0);
											    		    	int cancel = Util.getIntValue(rs.getString("cancel"),0);
											    		    	needcheck += ",name_"+rowno;
											    		%>
											    				<tr>
											    					<td>
											    						<input <%if(cancel==1){%>style="display:none;"<%} %> type="checkbox" name="check_node">
											    						<%if(cancel==1){%><input disabled="disabled" type="checkbox" ><%} %>
											    						<input type="hidden" class="detailid" id="detailid_<%=rowno%>" name="detailid_<%=rowno%>" value="<%=detailid %>">
											    					</td>
											    					<td>
											    						<input <%if(cancel==1){%>style="display:none;"<%} %> class=inputstyle type='text' maxlength='400' name='name_<%=rowno%>' id='hreftitle_<%=rowno%>' value="<%=name%>">
											    						<%if(cancel==1){%><input disabled="disabled" class=inputstyle type='text' maxlength='400'  value="<%=name%>"><%} %>
											    					</td>
											    					<td>
											    						<input <%if(cancel==1){%>style="display:none;"<%}else{%>style="width:80px;"<%} %> class=inputstyle type='text' maxlength='400' name='disorder_<%=rowno%>' id='disorder_<%=rowno%>' value="<%=disorder%>" >
											    						<%if(cancel==1){%><input disabled="disabled" style="width:80px;" class=inputstyle type='text' maxlength='400'  value="<%=disorder%>"><%} %>
											    					</td>
											    					<td>
											    						<input <%if(cancel==1){%>style="display:none;"<%} %> vname='defaultvalue' class=inputstyle type='checkbox' <%if("1".equals(defaultvalue)){%>checked<%} %> onclick='changeBoxVal(this);' name='defaultvalue_<%=rowno%>' id='defaultvalue_<%=rowno%>' value="<%=defaultvalue%>">
											    						<%if(cancel==1){%><input <%if("1".equals(defaultvalue)){%>checked<%} %>  disabled="disabled" type="checkbox" ><%} %>
											    					</td>
											    					<!-- 
											    					<td>
											    						<%if(cancel==1){%><input disabled="disabled" type="checkbox" ><%} %>
											    						<input <%if(cancel==1){%>style="display:none;"<%} %> type='checkbox' name='isAccordToSubCom_<%=rowno%>' id='isAccordToSubCom_<%=rowno%>' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;
																		<button <%if(cancel==1){%>disabled="disabled"<%} %> type='button' class=Browser onclick="onShowDetailCatalog('mypath_<%=rowno%>','<%=rowno%>')" name=selectCategory></BUTTON>
																		<span id='mypath_<%=rowno%>'><%=pathcategory %></span>
						    											<input type=hidden id='pathcategory_<%=rowno%>' name='pathcategory_<%=rowno%>' value='<%=pathcategory %>'>
						    											<input type=hidden id='maincategory_<%=rowno%>' name='maincategory_<%=rowno%>' value='<%=maincategory %>'>
											    					</td>
											    					 -->
											    					<td>
											    						<input class=inputstyle type='hidden' maxlength='400' name='pid_<%=rowno%>' id='pid_<%=rowno%>' value="<%=pid%>"/>
											    						<a  style="<%if(!subcount.equals("0")){%>color: blue;<%} %>" href="javascript:goToChildren('<%=rowno%>','<%=cancel %>')"><%=SystemEnv.getHtmlLabelName(82467,user.getLanguage())%><!-- 子项 --></a>
											    					</td>
											    					<td>
											    						<input initcancel='<%=cancel %>' subcount='<%=subcount %>' vname='cancel' class=inputstyle type='checkbox' <%if(1==cancel){%>checked<%} %> onclick='changeCalcelVal(this);' name='cancel_<%=rowno%>' id='cancel_<%=rowno%>' value="<%=cancel%>">
											    						<%if(cancel==1){%>
											    							<a style="color: blue;" href="javascript:notCancel('<%=detailid%>');"><%=SystemEnv.getHtmlLabelName(82570,user.getLanguage())%><!-- 子项 --></a>
											    						<%} %>
											    					</td>
											    				</tr>
											    		<%		
											    				rowno++;
											    			}
											    		%>
													</table>
										        </td>
									        </tr>
						        		</TBODY>
									</TABLE>
									<input type="hidden" id="needcheck" name="needcheck" value="<%=needcheck%>">
									<input type="hidden" id="rowno" name="rowno" value="<%=rowno%>">
									<%
										}
									%>
</form>

<script type="text/javascript">
function changeModeSel(){
	var modeid = document.getElementById("modeid");
	//删除所有的选择项
	for (var i = modeid.options.length-1; i >0; i--) {        
	        modeid.options.remove(i);        
	}
	var formid = $("#formid").val();
	if(formid!=""){
		jQuery.ajax({
		   type: "POST",
		   dataType:"json",
		   url: "/weaver/weaver.formmode.servelt.CustomSearchAction?action=getModeDataByFormId",
		   data: "formid="+formid,
		   success: function(data){
				if(data&&data.length>0){
					for(var i=0;i<data.length;i++){
						var varItem = new Option(data[i].modename, data[i].id);      
        				modeid.options.add(varItem); 
        				if(i==0){
        					modeid.value = data[i].id;
        				}
					}
				}
		   }
		});
	}
	
}

/**
 * 解禁此项以及子项
 * @param {Object} selid 
 */
function notCancel(detailid){
	jQuery.ajax({
	   type: "POST",
	   url: "/formmode/setup/SelectItemPageAction.jsp?operation=notcancel",
	   data: "detailid="+detailid,
	   dataType:"json",
	   success: function(data){
			if(data&&data.detailid>0){
				window.location.href = window.location.href;
			}
	   }
	});
}

function submitData(){
	rightMenu.style.visibility = "hidden";
	if ($("#id").val()==0) {
		document.formCustomSearch.action.value="selectitemadd";
	}
    var checkfields = "selectitemname,formid";
    var nameArr = jQuery("[name^=name_]");
    for(var i=0;i<nameArr.length;i++){
    	if(nameArr.get(i).value==""){
    		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage()) %>");
    		return;
    	}
    }
	if (checkFieldValue(checkfields)){
		enableAllmenu();
		formCustomSearch.submit();
    }
}

function checkFieldValue(ids){
	var idsArr = ids.split(",");
	for(var i=0;i<idsArr.length;i++){
		var obj = document.getElementById(idsArr[i]);
		if(obj&&obj.value==""){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});//必要信息不完整！
			return false;
		}
	}
	return true;
}

function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {//你确定要删除这条记录吗?
		document.formCustomSearch.action.value="selectitemdelete";
		enableAllmenu();
		document.formCustomSearch.submit();
	}
}

function onShowModeSelect(inputName, spanName){
	var formid_ = $("#formid").val();
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp?formid="+formid_);
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
	    }else{
		    $(inputName).val("");
			$(spanName).html("");
		}
	}
}

function doCustomSearchBatchSet(){
    //enableAllmenu();
    if(confirm("<%=SystemEnv.getHtmlLabelName(31851,user.getLanguage())%>")){//在此页面设置查看或监控权限后，模块中设置的共享或监控权限将不能访问对应的菜单页面
    	location.href="/formmode/search/CustomSearchShare.jsp?id=<%=id%>";
    }
    
}

function doBatchSet(){
    enableAllmenu();
    location.href="/formmode/batchoperate/ModeBatchSet.jsp?id=<%=id%>";
}
function onShowFormSelect(inputName, spanName){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormBrowser.jsp");
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
			$("#modetr").css("display","");
	    }else{
		    $(inputName).val("");
			$(spanName).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$("#modeid").val("");
			$("#modetr").css("display","none");
		}
	    changeModeSel();
	} 
}

function toformtabFormChoosed(data){
	var dataArr=data.split("_");
	var formid=dataArr[0];
	var isvirtualform=dataArr[1];
	toformtab(formid,isvirtualform);
}

function toformtab(formid,isvirtualform){
    if (<%=isvirtualform%> == 1||isvirtualform==1) {
        FormmodeUtil.writeCookie(FormModeConstant._CURRENT_SELECTITEM, formid);
    	clickTopSubMenu(2);
    } else {
		diag_vote = new window.top.Dialog();
		diag_vote.currentWindow = window;	
		var parm = "&formid="+formid;
		if(formid=='') {
			parm = '';
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82021,user.getLanguage())%>";//新建表单
		}else{
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82022,user.getLanguage())%>";//编辑表单
		}
		diag_vote.Width = 1000;
		diag_vote.Height = 600;
		diag_vote.Modal = true;
		
		diag_vote.URL = "/workflow/form/addDefineForm.jsp?dialog=1&isFromMode=1"+parm;
		diag_vote.isIframe=false;
		diag_vote.show();
	}
}

function copyCustomSearc(){
	$('#rightMenu').css('visibility','hidden');
	parent.copyCustomSearcSetting();
}


function customDialogCallBack(isvirtualform){
	if(isvirtualform==1){//虚拟表单
		$(".isvirtualformhide").hide();
		$(".isvirtualformhide input").each(function(i,obj){
		     changeCheckboxStatus(obj, false);
		});
	}else{
		$(".isvirtualformhide").show();
	}
}

function formidChange(){
	var $detailtable=jQuery("#detailtable");
	var $detailtableTR=jQuery("#detailtable_tr");
	$detailtable.find("option").remove();
	$detailtable.append("<option></option>");
	var formid=jQuery("#formid").val();
	if(formid=="")return;
	$detailtable.attr("disabled","true");
	var $detailtable_loading=jQuery("#detailtable_loading");
	$detailtable_loading.show();
	var url = "/formmode/setup/formSettingsAction.jsp?action=getDetailTables&formid="+formid;
	FormmodeUtil.doAjaxDataLoad(url, function(result){
		var status = result.status;
		if(status == "1"){
			$detailtable.find("option").remove();
			$detailtable.append("<option></option>");
			var data = result.data;
			if(data.length==0){
				$detailtableTR.hide();
			}else{
				var table_name_prefix="<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%>";//明细表
				for(var i = 0; i < data.length; i++){
					var table_name = data[i]["tablename"];
					var show_name=table_name_prefix+(i+1)+" "+table_name;
					var selected="";
					if(table_name=="<%=detailtable%>"){
						selected="selected";
					}
					var optionHtml = "<option value=\""+table_name+"\" "+selected+">"+show_name+"</option>";
					$detailtable.append(optionHtml);
				}
				$detailtableTR.show();
			}
		}
		$detailtable.removeAttr("disabled");
		$detailtable_loading.hide();
		$detailtable.selectbox("detach");
        beautySelect($detailtable);
	});
}
function clickTopSubMenu(menuIndex){
	var tDoc = top.document;
	var $submenusUL = $("#submenu", tDoc);
	$(".menuitem:eq("+menuIndex+")", $submenusUL).click();
}
var rowColor="" ;
rowindex = "<%=rowno%>";
function addRow()
{	
	if(!isNaN(rowindex)){
		rowindex = parseInt(rowindex);
	}
	rowColor = getRowBg();
	oRow = oTable.insertRow(-1);
	for(j=0; j<6; j++) {//7列数据
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		//oCell.style.background= rowColor;
		oCell.style.wordBreak = "break-all";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node'>"
						   +"<input type='hidden' class='detailid' id='detailid_"+rowindex+"' name='detailid_"+rowindex+"' value=''>"; 
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='text' maxlength='400' name='name_"+rowindex+"' id='name_"+rowindex+"' onchange='checkinput(\"name_"+rowindex+"\",\"name_"+rowindex+"span\")'>";
					sHtml += "<span id='name_"+rowindex+"span'><IMG src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\"></span>";
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv);
				$("#needcheck").val($("#needcheck").val() + "," + "name_"+rowindex+"");
				break;			
			case 2:
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle style='width:80px;' type='text' maxlength='400' name='disorder_"+rowindex+"' id='disorder_"+rowindex+"' value='"+(rowindex+1)+".0'>";
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv); 
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<input vname='defaultvalue' class=inputstyle type='checkbox'  onclick='changeBoxVal(this);' name='defaultvalue_"+rowindex+"' id='defaultvalue_"+rowindex+"' value='0'>";
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv); 
				break;
			//case 4:
			//	var oDiv = document.createElement("div");
			//	var sHtml = "<input type='checkbox' name='isAccordToSubCom_"+rowindex+"' id='isAccordToSubCom_"+rowindex+"' value='0' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;  "
			//				+ "<button type='button' class=Browser onClick=\"onShowDetailCatalog('mypath_"+rowindex+"',"+rowindex+")\" name=selectCategory></BUTTON>"
			//				+ "<span id=mypath_"+rowindex+"></span>"
			//			    + "<input type=hidden id='pathcategory_"+rowindex+"' name='pathcategory_" + rowindex+"' value=''>"
			//			    + "<input type=hidden id='maincategory_" + rowindex +"' name='maincategory_" +rowindex+"' value=''>";
			//	$(oDiv).html(sHtml);
			//	oCell.appendChild(oDiv); 
			//	break;
			case 4:
				var max = getMaxNo();
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='hidden' maxlength='10' name='pid_"+rowindex+"' id='pid_"+rowindex+"' value='<%=initpid %>'>";
					sHtml +="<a href='javascript:noGoChildren()'><%=SystemEnv.getHtmlLabelName(82467,user.getLanguage())%></a>";//<!-- 子项 -->
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv);
				break;
			case 5:
				var max = getMaxNo();
				var oDiv = document.createElement("div");
				var sHtml = "<input vname='cancel' class=inputstyle type='checkbox'  onclick='changeCalcelVal(this);' name='cancel_"+rowindex+"' id='cancel_"+rowindex+"' value='0'>";
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex = rowindex*1 +1;
	$("#rowno").val(rowindex);
	jQuery("#oTable").jNice();
}

function delRow(){
	var delids = jQuery("#delids");
	var delidsVal = delids.val();
	var i=0;
	var rowsum1 = 1;
	var nodeArr = $("input[name='check_node']");
	rowsum1 = $("input[name='check_node']").length + 1; 
	for(i=nodeArr.length-1; i >= 0;i--) {
		var nodeObj = nodeArr.get(i);
		if (nodeObj.name=='check_node'){
			if(nodeObj.checked==true) {
				var td = jQuery(nodeObj).closest("td");
				var detailid = td.find(".detailid");
				if(detailid.length>0&&detailid.val()!=0){
					delidsVal = delidsVal+","+detailid.val();
				}
				oTable.deleteRow(rowsum1-1);	
			}
			rowsum1 -=1;
		}
	}
	if(delidsVal!=""){
		if(delidsVal.indexOf(",")==0){
			delidsVal = delidsVal.substring(1);
		}
		delids.val(delidsVal);
	}
}

function SelAll(obj){
	//$("input[type=checkbox]").attr("checked",obj.checked);
	 var chks = document.getElementsByName("check_node"); 
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        changeCheckboxStatus(chk, obj.checked);
    }  
}
function changeCbox(objspan){
	var objbox = $(objspan).find(".jNiceHidden");
	changeCheckboxStatus(objbox.get(0), !objbox.get(0).checked);
	if(objbox.attr("vname")=="defaultvalue"){
		changeBoxVal(objbox.get(0));
	}
}

function changeCalcelVal(obj){
	var name = obj.name;
	if(obj.checked){
		obj.value=1;
	}else{
		obj.value=0;
	}
}

function changeBoxVal(obj){
	var name = obj.name;
	if(obj.checked){
		obj.value=1;
	}else{
		obj.value=0;
	}
	
	var defaultvalueArr = jQuery("[vname=defaultvalue]:not([name="+name+"])");
	for(var i=0;i<defaultvalueArr.length;i++){
		var tempObj = defaultvalueArr.get(i);
		tempObj.value = 0;
		changeCheckboxStatus(tempObj, false);
	}
}

function getMaxNo(){
	var max = 0;
	$("input[name^='disorder_']").each(function(){
		var temp = $(this).val() * 1.0
		if(temp>max){
			max = temp;
		}
	});

	try{
		var temp = parseFloat(max.toFixed(0));
		if(temp == max){
			max = max + 1;
		}else if(temp<max){
			max = temp + 1;
		}else{
			max = temp;
		}
	}catch(e){
		max = max + 1;
	}
	
	return max;
}
function onShowDetailCatalog(spanName, index){
	var isAccordToSubCom=0;
	if($G("isAccordToSubCom_"+index)!=null){
		if($G("isAccordToSubCom_"+index).checked){
			isAccordToSubCom=1;
		}
	}
	if(isAccordToSubCom==1){
		onShowDetailCatalogSubCom(spanName, index);
	}else{
		onShowDetailCatalogHis(spanName, index);
	}
}
function onShowDetailCatalogHis(spanName,  index) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
    if (result != null){
    	var rid = wuiUtil.getJsonValueByIndex(result, 0);
    	var rname = wuiUtil.getJsonValueByIndex(result, 1);
    	var rkey3 = wuiUtil.getJsonValueByIndex(result, 2);
    	var rkey4 = wuiUtil.getJsonValueByIndex(result, 3);
    	var rkey5 = wuiUtil.getJsonValueByIndex(result, 4);
        if (rid > 0){
            $("#"+spanName).html(rkey3);
            $G("pathcategory_"+index).value= rkey3;
            $G("maincategory_"+index).value= rkey4+","+rkey5+","+rname;
        }else{
            $("#"+spanName).html("");
            $G("pathcategory_"+index).value="";
            $G("maincategory_"+index).value="";
       }
    }
}
function onShowDetailCatalogSubCom(spanName,index) {
	if($G("detailid_"+index)==null||$G("detailid_"+index).value==''){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24460,user.getLanguage())%>");
		return;
	}
	var selectvalue=$G("detailid_"+index).value;
	url =escape("/workflow/field/SubcompanyDocCategoryBrowser.jsp?isBill=1&selectValue="+selectvalue)
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
}
function noGoChildren(){
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82470,user.getLanguage())%>");
}
function goToChildren(index,cancel){
	if(cancel&&cancel==1){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82572,user.getLanguage())%>!");
		return;
	}
	if($G("detailid_"+index)==null||$G("detailid_"+index).value==''){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82470,user.getLanguage())%>");
		return;
	}
	var statelev = parseInt($G("statelev").value);
	statelev = statelev + 1;
	var id = $G("id").value;
	var detailid = $G("detailid_"+index).value;
	location.href="/formmode/setup/selectItemPageBase.jsp?id=<%=id%>&appid=<%=appid%>&pid="+detailid+"&statelev="+statelev;
}
function goToState(pid,statelev){
	location.href="/formmode/setup/selectItemPageBase.jsp?id=<%=id%>&appid=<%=appid%>&pid="+pid+"&statelev="+statelev;
}</script>
</body>
</html>