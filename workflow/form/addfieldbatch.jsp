<!DOCTYPE html>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<% weaver.filter.ECompatibleSetting.setVersion(weaver.filter.ECompatibleSetting.ECOLOGY_JSP_VERSION_E8,request); %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="weaver.general.StaticObj"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InputReportItemManager" class="weaver.datacenter.InputReportItemManager" scope="page" />
<jsp:useBean id="browserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="formmanager" class="weaver.workflow.form.FormManager" scope="page"/>
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<script language="javascript" src="/js/browsertypechooser/btc_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/browsertypechooser/browserTypeChooser_wev8.css">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src="/js/ecology8/request/autoSelect_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<style type="text/css">
	select{
		width:100px!important;
	}
	
	input.InputStyle{
		width:100px!important;
	}
   	.tablenameCheckLoading{
   		background: url('/images/messageimages/loading_wev8.gif') no-repeat;
   		padding-left: 18px;
   		display: block;
   	}
	.tablenameCheckSuccess{
		background: url('/images/BacoCheck_wev8.gif') no-repeat;
		padding-left: 18px;
		background-position: left 2px;
		display: block;
	}
	.tablenameCheckError{
		background: url('/images/BacoCross_wev8.gif') no-repeat;
		padding-left: 18px;
		color: red;
		background-position: left 2px;
		display: block;
	}
	input.Inputstyle0{
		width:300px!important;
		border-top:0px!important;
		border-left:0px!important;
		border-right:0px!important;
		border-bottom:0px!important;
	}
</style>
</head>


<%
String formRightStr = "FormManage:All";
int isFromMode = Util.getIntValue(request.getParameter("isFromMode"),0);
if(isFromMode==1){
	formRightStr = "FORMMODEFORM:ALL";
}

if(!HrmUserVarify.checkUserRight(formRightStr, user)){
	response.sendRedirect("/notice/noright.jsp");
	
	return;
}

RecordSet rs2 = new RecordSet();
String treeSql = "select a.id,a.treename from mode_customtree a where a.showtype=1 order by a.treename";
rs2.executeSql(treeSql);
List treeList = new ArrayList();
while(rs2.next()){
	Map map = new HashMap();
	map.put("id",rs2.getString("id"));
	map.put("treebrowsername",rs2.getString("treename"));
	treeList.add(map);
}

int formid = Util.getIntValue(request.getParameter("formid"),0);
String dialog = Util.null2String(request.getParameter("dialog"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isValue = Util.null2String(request.getParameter("isValue"));
String fromwhere = Util.null2String(request.getParameter("fromwhere"));
int jumpfieldid = Util.getIntValue(request.getParameter("jumpfieldid"),0);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(20839,user.getLanguage())+SystemEnv.getHtmlLabelName(17998,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if("excelimp".equals(fromwhere)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(125029, user.getLanguage())+",javascript:onSave(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(125030, user.getLanguage())+",javascript:cancelSaveNextImport(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("201,18596",user.getLanguage())+",javascript:cancelImport(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:cancleback(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
String tablename = "";
RecordSet.executeSql("select tablename from workflow_bill where id="+formid);
if(RecordSet.next()){
	tablename = Util.null2String(RecordSet.getString("tablename"));
}
DecimalFormat decimalFormat=new DecimalFormat("0.00");//使用系统默认的格式
int detailtables = 0;
int detailtableMaxIndex = 0;
String detailtableIndexs = ",";
RecordSet.executeSql("select * from Workflow_billdetailtable where billid="+formid+" order by orderid");
while(RecordSet.next()){
	detailtables++;
	detailtableMaxIndex = RecordSet.getInt("orderid");
	detailtableIndexs += ""+detailtableMaxIndex+",";
}
boolean isCustomNameTable = tablename.startsWith("uf_");
%>

<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(125028,user.getLanguage()) %>"/>
</jsp:include>
<%}%>
<FORM id="frmMain" name="frmMain" action="form_operation.jsp" method=post >
	<input type="hidden" name=src value="addfieldbatch">
	<input type="hidden" name=formid value=<%=formid%>>
	<input type="hidden" value="0" name="recordNum">
	<input type="hidden" value="" name="delids">
	<input type="hidden" value="" name="changeRowIndexs">	
	<input type="hidden" value="<%=detailtables%>" name="detailtables">
	<input type="hidden" value="<%=detailtableIndexs%>" name="detailtableIndexs">
	<input type="hidden" value="<%=dialog %>" name="dialog">
	<input type="hidden" value="<%=isFromMode %>" name="isFromMode">
	<input type="hidden" value="<%=fromwhere %>" name="fromwhere" />
	<input type='hidden' id="jumpRowindex" name="jumpRowindex" value=""/>
<div style="display:none">
<table id="hidden_tab" cellpadding='0' width=0 cellspacing='0'>
</table>
</div>	
<table id="topTitle" cellpadding="0" cellspacing="0">

		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<%if("excelimp".equals(fromwhere)){ %>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(125029,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top"  onclick="javascript:onSave(this)">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(125030,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top"  onclick="javascript:cancelSaveNextImport(this)">
				<%}else{ %>
    				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top"  onclick="javascript:onSave(this)">
    			<%} %>
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table> 
<%
	String dbfieldnamesForCompare = ",";
    String tablenameString = SystemEnv.getHtmlLabelName(15190,user.getLanguage())+ "："+tablename;
 %>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18549,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage()) + tablenameString%>'>
		<wea:item type="groupHead">
			<input type=button  class=addbtn accessKey=A onClick="addRow()" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
			<input type=button  class=delbtn accessKey=E onClick="deleteRow()" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
			<input type=button  class=copybtn accessKey=C onClick="copyRow()" title="C-<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%>"></input>		
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<table class=ListStyle id="oTable" cols=5  border=0 cellspacing=0>
				<tr class=header>
					<td NOWRAP width='3%'><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
					<td NOWRAP width='15%' ><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
					<td NOWRAP width='16%'><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></td>
					<td NOWRAP width='60%' ><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></td>
					<td NOWRAP width='6%'><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>
				</tr>
				<%			
				String sql = "select * from workflow_billfield where billid="+formid+" and viewtype=0 order by dsporder,id";
				RecordSet.executeSql(sql);
				while(RecordSet.next()){
					String fieldname = RecordSet.getString("fieldname");
					dbfieldnamesForCompare += fieldname.toUpperCase()+",";
				}
				%>
			</table>		
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%>' attributes="{'groupOperDisplay':'block'}">
		<wea:item type="groupHead">
			<input type=button  class=addbtn onClick="addDetailTable()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18903,user.getLanguage())%>"></input>
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<table class=viewform style="width: 100%;height:100%;margin-bottom:10px;">
				<tbody>
				<%
				int tempint = 0;
				RecordSet.executeSql("select * from Workflow_billdetailtable where billid="+formid+" order by orderid");
				while(RecordSet.next()){
					tempint++;
					String detailtablename = RecordSet.getString("tablename");
					String tableNumber = RecordSet.getString("orderid");
				%>
				<input type="hidden" id="detailTable_name_<%=tempint%>" value="<%=detailtablename%>">
				<tr>
					<td class=field style="padding-left:0px;">
						<table id="detailTable_<%=tableNumber%>" class=ListStyle cols=5  border=0 cellspacing=0>
							<input type="hidden" value="" name="detaildelids_<%=tableNumber%>">
							<input type="hidden" value="" name="detailChangeRowIndexs_<%=tableNumber%>">
							<colgroup>
								<col width="3%"/>
								<col width="14%"/>
								<col width="15.5%"/>
								<col width="56%"/>
								<col width="11.5%"/>
							</colgroup>							
							<tr>
								<td colspan=4 ><b><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())+tempint%></b>
									<span style='margin-left:30px;margin-right:5px;'><b><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%>:</b></span>
									<input type='hidden' class='Inputstyle' size='20' maxlength='30' id='detailtablename_db_<%=tableNumber%>' name='detailtablename_db_<%=tableNumber%>' value="<%=detailtablename %>"/>
									<span id='detailtablename<%=tableNumber%>_span'><%=detailtablename %></span>
								</td>
								<td colspan=1 align="right">
									<input type=button  class=addbtn accessKey=A onClick="addDetailRow(<%=tableNumber%>)" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
									<input type=button  class=delbtn accessKey=E onClick="deleteDetailRow(<%=tableNumber%>)" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
									<input type=button  class=copybtn accessKey=C onClick="copyDetailRow(<%=tableNumber%>)" title="C-<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%>"></input>								
								</td>
							</tr>
							<tr style="height:1px;"><td colspan=5 class=line1 style='height:1px;padding:0;margin:0px;'></td></tr>
							<tr class=header>
								<td  NOWRAP><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
								<td  NOWRAP><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
								<td  NOWRAP><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></td>
								<td  NOWRAP><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></td>
								<td  NOWRAP><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>
							</tr>
							<%
							String dbdetailfieldnamesForCompare = ",";
							RecordSet1.executeSql("select * from workflow_billfield where billid="+formid+" and viewtype=1 and detailtable='"+detailtablename+"' order by dsporder,id");
							while(RecordSet1.next()){
								String detailfieldname = RecordSet1.getString("fieldname");
								dbdetailfieldnamesForCompare += detailfieldname.toUpperCase()+",";
							}%>
							<input type="hidden" value="<%=dbdetailfieldnamesForCompare%>" name="dbdetailfieldnamesForCompare_<%=tableNumber%>">
						</table>
					</td>
				</tr>
				<%}%>
				<tr>
					<td class=field id="addDetail"><br><br></td>
				</tr>
				</tbody> 
			</table> 		
		</wea:item>
	</wea:group>
</wea:layout>
 </form>
 <%if("1".equals(dialog)){ %>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<%if("excelimp".equals(fromwhere)){ %>
					<input type="button" value='<%=SystemEnv.getHtmlLabelNames("201,18596",user.getLanguage()) %>' id="zd_btn_cancle"  class="zd_btn_cancle" onclick="cancelImport()" style="width: 80px!important;">
				<%}else{ %>
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 60px!important;">
		    	<%} %>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%} %>
<div>
	<brow:browser width="150px" viewType="0" name="definebroswerType"
	    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
	    completeUrl="/data.jsp"
		hasInput="false" isSingle="true"
		isMustInput="2"
		browserDialogWidth="550px"
		browserDialogHeight="650px"
		_callback="OnChangeDefineBroswerType"></brow:browser>
</div>
</BODY></HTML>
<script language="JavaScript">
	if("<%=dialog%>"==1){
		var dialog = parent.getDialog(window);
		var parentWin = parent.getParentWindow(window);
		function btn_cancle(){
			parentWin.closeDialog();
		}
	}
	
	if("<%=isclose%>"==1){
		var dialog = parent.getDialog(window);
		var parentWin = parent.getParentWindow(window);
		if("<%=fromwhere %>" == "excelimp"){		//新表单设计器-excel导入保存跳转
			dialog.close("nextImport");
		}else{
			if("<%=isValue%>" == 1){
			 parentWin.location="/workflow/form/editformfield.jsp?formid="+<%=formid%>+"&ajax=0&isFromMode=<%=isFromMode%>";
			}
			//parent.parentWin.closeDialog();
			dialog.close();
		}
	}
	
	function refreshParentWin(){
	    var parentWin = parent.getParentWindow(window);
		parentWin._table.reLoad();
		//parentWin.location="/workflow/form/editformfield.jsp?formid="+<%=formid%>+"&ajax=0&isFromMode=<%=isFromMode%>";
	}

	function setChangeDetail0(event,datas,name,tableid,rowid){
		top.Dialog.alert(tableid,rowid);
		setChangeDetail(tableid, rowid);
	}
	function setChangeDetail1(event,datas,name){
		var ids = name.split('_');
		setChange(ids[1], ids[2]);
	}
	function setChangeDetail2(event,datas,name,str){
		var ids = str.split(',');
		setChangeDetail(ids[0], ids[1]);
	}
	
	function setChangeDetail(tableid,rowid){
		var oldDetailChangeRowIndexs = $G("detailChangeRowIndexs_"+tableid).value;
		if(oldDetailChangeRowIndexs.indexOf(rowid + ",")<0)
			$G("detailChangeRowIndexs_"+tableid).value += rowid + ",";
		try{
			var dbnames = $G("dbdetailfieldnamesForCompare_"+tableid).value;
			var dbname = $G("itemDspName_detail"+tableid+"_"+rowid).value.toUpperCase();
			//$G("dbdetailfieldnamesForCompare_"+tableid).value = dbnames.replace(","+dbname+",",",");
		}catch(e){}
	}
	detailtables = <%=detailtableMaxIndex%>;
	function addDetailTable(){
		detailtables = detailtables*1+1;
		$G("detailtables").value = $G("detailtables").value*1 + 1;
		$G("detailtableIndexs").value = $G("detailtableIndexs").value + detailtables + ",";
		//oRow = addDetail.insertRow(-1);
		//oCell = oRow.insertCell(-1);
		//oCell.noWrap=true;
		//oCell.style.background="#fff";

		var oDiv = document.createElement("div");
		var sHtml = "<table id='detailTable_"+detailtables+"' class=ListStyle cols=5  border=0 cellspacing=0>"+
								"<input type='hidden' value='' name='detaildelids_"+detailtables+"'>"+
								"<input type='hidden' value='' name='detailChangeRowIndexs_"+detailtables+"'>"+
								"<colgroup>"+
								"<col width='5%'/>"+
								"<col width='10%'/>"+
								"<col width='10%'/>"+
								"<col width='60%'/>"+
								"<col width='15%'/>"+
								"</colgroup>"+								
								"<tr>"+
									"<td colspan=4>" +
										"<span id='detailtablenamecheck"+detailtables+"_span'></span>" +
										"<b><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%>"+$G("detailtables").value+"</b>" +
										<%if(isCustomNameTable){%>
										"<span style='margin-left:30px;margin-right:5px;'><b><%=SystemEnv.getHtmlLabelName(15190, user.getLanguage())%>:</b></span>" +
										"uf_<input type='text' class='Inputstyle0' readOnly size='20' maxlength='30' id='detailtablename"+detailtables+"' name='detailtablename"+detailtables+"' onChange=\"checkinput('detailtablename"+detailtables+"','detailtablename"+detailtables+"_span');checkDetailTablename('"+detailtables+"');\" flagtype='detailtablename'/>" +
										<%}%>
										"<input type='hidden' id='detailtablename_db_"+detailtables+"' name='detailtablename_db_"+detailtables+"'/>" +
										"<span id='detailtablename"+detailtables+"_span'></span>" +
									"</td>"+
									"<td colspan=1 align='right'>"+
										"<input type=button  class=addbtn onClick='addDetailRow("+detailtables+")' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'></input>"+
										"<input type=button  class=delbtn onClick='deleteDetailRow("+detailtables+")' title='<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>'></input>"+
										"<input type=button  class=copybtn onClick='copyDetailRow("+detailtables+")' title='<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%>'></input></td>"+
								"</tr>"+
								"<tr style='height:1px;'>"+
									"<td colspan=5 class=line1 style='height:1px;padding:0;margin:0px;'></td>"+
								"</tr>"+
								
								"<tr class=header>"+
									"<td NOWRAP><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>"+
									"<td NOWRAP><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>"+
									"<td NOWRAP><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></td>"+
									"<td NOWRAP><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></td>"+
									"<td NOWRAP><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>"+
								"</tr>"+
								"</table>";
		/*异步获取合法的子表数据库名称*/
		var detailEndIndex = detailtables;
		
		var pageNoSaveTablenames = getPageNoSaveTablenames();
		
		var ajax=ajaxinit();
	    ajax.open("POST", "/formmode/setup/formSettingsAction.jsp", true);
	    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	    ajax.send("action=getDetailTablename&maintablename=<%=tablename%>&detailEndIndex="+detailEndIndex + "&pageNoSaveTablenames=" + pageNoSaveTablenames);
	    ajax.onreadystatechange = function() {
	    	oDiv.innerHTML = sHtml;
	    	addDetail.appendChild(oDiv);
	        if (ajax.readyState == 4 && ajax.status == 200) {
	        	try{
	        		<%if(isCustomNameTable){%>
	        			document.getElementById("detailtablename"+detailEndIndex).value = jQuery.trim(ajax.responseText);
	        			document.getElementById("detailtablename_db_"+detailEndIndex).value = "uf_" + jQuery.trim(ajax.responseText);
	        		<%}else{%>
	        			document.getElementById("detailtablename_db_"+detailEndIndex).value = jQuery.trim(ajax.responseText);
	        		<%}%>
	        	}catch(e){}
	        }
	    }
}

	function getPageNoSaveTablenames(){
		var pageNoSaveTablenames = "";
		var $detailtablenames = jQuery("input[type='text'][flagtype='detailtablename']");
		jQuery.each($detailtablenames, function(){
			if(jQuery.trim(this.value) != ""){
				pageNoSaveTablenames += this.value + ",";
			}
		});
		return pageNoSaveTablenames;
	}
	
	function checkDetailTablename(detailtableIndex){
		
		var $detailtablenamecheckspan = jQuery("#detailtablenamecheck"+detailtableIndex+"_span");
		$detailtablenamecheckspan.removeClass("tablenameCheckLoading");
		$detailtablenamecheckspan.removeClass("tablenameCheckError");
		$detailtablenamecheckspan.removeClass("tablenameCheckSuccess");
		$detailtablenamecheckspan.html("");
		
		var detailtablenameObj = document.getElementById("detailtablename"+detailtableIndex);
		var detailtablenameVal = jQuery.trim(detailtablenameObj.value);
		if(detailtablenameVal != ""){
			
			var rep = /[^\w]/ig;
			if(rep.test(detailtablenameVal)){
				$detailtablenamecheckspan.addClass("tablenameCheckError");
		        $detailtablenamecheckspan.html("<%=SystemEnv.getHtmlLabelName(21900, user.getLanguage())%> "+"uf_"+detailtablenameVal+" <%=SystemEnv.getHtmlLabelName(129050, user.getLanguage())%><b><%=SystemEnv.getHtmlLabelName(129051, user.getLanguage())%></b>");
		        detailtablenameObj.value = "";
				return;
			}
			
			$detailtablenamecheckspan.addClass("tablenameCheckLoading");
			$detailtablenamecheckspan.html("<%=SystemEnv.getHtmlLabelName(129049, user.getLanguage())%>");
			detailtablenameObj.disabled = true;
			//enableAllmenu();
			
			var checkDetailtablenameVal = "uf_" + detailtablenameVal;
			var errorMsg = "<%=SystemEnv.getHtmlLabelName(21900, user.getLanguage())%> "+checkDetailtablenameVal+" <%=SystemEnv.getHtmlLabelName(129050, user.getLanguage())%>";
			var pageNoSaveTablenames = getPageNoSaveTablenames();
			if(pageNoSaveTablenames.indexOf(detailtablenameVal + ",") != pageNoSaveTablenames.lastIndexOf(detailtablenameVal + ",")){
				$detailtablenamecheckspan.addClass("tablenameCheckError");
				errorMsg += "<b><%=SystemEnv.getHtmlLabelName(129052, user.getLanguage())%></b>";
				$detailtablenamecheckspan.html(errorMsg);
				detailtablenameObj.value = "";
				detailtablenameObj.disabled = false;
				return;
			}
			
			var ajax=ajaxinit();
		    ajax.open("POST", "/workflow/form/form_operation.jsp", true);
		    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		    ajax.send("src=checktablename&tablename="+checkDetailtablenameVal);
		    ajax.onreadystatechange = function() {
		        if (ajax.readyState == 4 && ajax.status == 200) {
		            try{
		            	if(ajax.responseText == "-1"){
		            		$detailtablenamecheckspan.addClass("tablenameCheckSuccess");
		            		$detailtablenamecheckspan.html("<%=SystemEnv.getHtmlLabelName(22083, user.getLanguage())%>");
		            	}else{
		            		$detailtablenamecheckspan.addClass("tablenameCheckError");
		            		if(ajax.responseText == "0"){
		            			errorMsg += "<b><%=SystemEnv.getHtmlLabelName(129053, user.getLanguage())%> </b>";
		            		}else if(ajax.responseText == "1"){
		            			errorMsg += "<b><%=SystemEnv.getHtmlLabelName(129054, user.getLanguage())%></b>";
		            		}else if(ajax.responseText == "2"){
		            			errorMsg += "<b><%=SystemEnv.getHtmlLabelName(129051, user.getLanguage())%></b>";
		            		}else{
		            			errorMsg += "<b><%=SystemEnv.getHtmlLabelName(463, user.getLanguage())%></b>";
		            		}
		            		$detailtablenamecheckspan.html(errorMsg);
		            		detailtablenameObj.value = "";
		            	}
		            }catch(e){}
		        }
		        try{
		        	document.getElementById("detailtablename_db_"+detailtableIndex).value = checkDetailtablenameVal;
		        	detailtablenameObj.disabled = false;
		        	displayAllmenu();
		        }catch(e){}
		    }
		}
		
		
	}
	
	function ajaxinit(){
	    var ajax=false;
	    try {
	        ajax = new ActiveXObject("Msxml2.XMLHTTP");
	    } catch (e) {
	        try {
	            ajax = new ActiveXObject("Microsoft.XMLHTTP");
	        } catch (E) {
	            ajax = false;
	        }
	    }
	    if (!ajax && typeof XMLHttpRequest!='undefined') {
	    ajax = new XMLHttpRequest();
	    }
	    return ajax;
	}	
function copyDetailRow(detailtables){//复制明细
	var copyedRow="";
	len = document.getElementsByName("check_select_detail_"+detailtables).length;
	var i=0;
	for(i=len-1; i >= 0;i--){
			if(document.getElementsByName("check_select_detail_"+detailtables)[i].checked==true){//选中的复制
				checkSelectValue=document.getElementsByName("check_select_detail_"+detailtables)[i].value;
				checkSelectArray=checkSelectValue.split("_");
				rowNum=checkSelectArray[1];
				copyedRow+=","+rowNum;
			}
	}
	var copyedRowArray =copyedRow.split(",");
	fromRow=0;
	for (loop=copyedRowArray.length-1; loop >=0 ;loop--){
		fromRow=copyedRowArray[loop] ;
		if(fromRow==""){
			continue;
		}
		itemDspName=$G("itemDspName_detail"+detailtables+"_"+fromRow).value;
		itemDspName=trim(itemDspName);
		itemFieldName=$G("itemFieldName_detail"+detailtables+"_"+fromRow).value;
		itemFieldName=trim(itemFieldName);
		itemFieldType=$G("itemFieldType_"+detailtables+"_"+fromRow).value;
		addDetailRow(detailtables);//插入新行
		//obj_table = $G("detailTable_"+detailtables); 
		//nowRowIndex = obj_table.rows.length-3;
		detailrowindex = detailRowCntArray[detailtables];
	    nowRowIndex = detailrowindex;
		//为新行赋值
		$G("itemDspName_detail"+detailtables+"_"+nowRowIndex).value = itemDspName;
		if(itemDspName!="") $G("itemDspName_detail"+detailtables+"_"+nowRowIndex+"_span").innerHTML = "";
		$G("itemFieldName_detail"+detailtables+"_"+nowRowIndex).value = itemFieldName;
		if(itemFieldName!="") $G("itemFieldName_detail"+detailtables+"_"+nowRowIndex+"_span").innerHTML = "";
		$G("itemFieldType_"+detailtables+"_"+nowRowIndex).value = itemFieldType;
		if(itemFieldType==1){//单行文本框
			documentType_index = $G("documentType_"+detailtables+"_"+fromRow).value;
			$G("documentType_"+detailtables+"_"+nowRowIndex).value=documentType_index;
			if(documentType_index == 1){
				$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="";
				doclength = $G("itemFieldScale1_"+detailtables+"_"+fromRow).value;
				if(doclength!=""){
					$G("itemFieldScale1_"+detailtables+"_"+nowRowIndex).value = doclength;
					$G("itemFieldScale1span_"+detailtables+"_"+nowRowIndex).innerHTML = "";
				}
				onChangDetailType(detailtables,nowRowIndex);
			}else if(documentType_index == 3||documentType_index == 5){//浮点数或者千分位
				$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="none";
				$G("detail_div1_3_"+detailtables+"_"+nowRowIndex).style.display="inline";
				$G("decimaldigits_"+detailtables+"_"+nowRowIndex).value = $G("decimaldigits_"+detailtables+"_"+fromRow).value;
			}else{
				$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="none";
				$G("detail_div1_3_"+detailtables+"_"+nowRowIndex).style.display="none";
			}
		}
		if(itemFieldType==2){//多行文本框
			$G("detail_div1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_3_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div2_"+detailtables+"_"+nowRowIndex).style.display="inline";
			$G("textheight_"+detailtables+"_"+nowRowIndex).value = $G("textheight_"+detailtables+"_"+fromRow).value;
			$G("htmledit_"+detailtables+"_"+nowRowIndex).checked = $G("htmledit_"+detailtables+"_"+fromRow).checked;
		}
		if(itemFieldType==3){//浏览按钮
			$G("detail_div1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_3_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div3_"+detailtables+"_"+nowRowIndex).style.display="inline";
			broswerType_value = $G("broswerType_"+detailtables+"_"+fromRow).value;
			//复制排序
			sortOption($G("broswerType_"+detailtables+"_"+nowRowIndex));
			$G("broswerType_"+detailtables+"_"+nowRowIndex).value=broswerType_value;
			if(broswerType_value==161||broswerType_value==162){
				$G("detail_div3_0_"+detailtables+"_"+nowRowIndex).style.display='none';
				$G("detail_div3_1_"+detailtables+"_"+nowRowIndex).style.display='inline';
				$G("detail_div3_4_"+detailtables+"_"+nowRowIndex).style.display='none';
				$G("detail_div3_4_"+detailtables+"_"+nowRowIndex).style.display='none';
				//$G("definebroswerType_"+detailtables+"_"+nowRowIndex).selectedIndex=$G("definebroswerType_"+detailtables+"_"+fromRow).selectedIndex;
				//$G("definebroswerType_"+detailtables+"_"+nowRowIndex).value=$G("definebroswerType_"+detailtables+"_"+fromRow).value;
			}else if(broswerType_value==224||broswerType_value==225){
				$G("detail_div3_0_"+detailtables+"_"+nowRowIndex).style.display='none';
				$G("detail_div3_1_"+detailtables+"_"+nowRowIndex).style.display='none';
				$G("detail_div3_4_"+detailtables+"_"+nowRowIndex).style.display='inline';
				$G("detail_div3_5_"+detailtables+"_"+nowRowIndex).style.display='none';
				$G("sapbrowser_"+detailtables+"_"+nowRowIndex).value=$G("sapbrowser_"+detailtables+"_"+fromRow).value;
			}else if(broswerType_value==226||broswerType_value==227){
					//zzl
					$G("detail_div3_0_"+detailtables+"_"+nowRowIndex).style.display='none';
					$G("detail_div3_1_"+detailtables+"_"+nowRowIndex).style.display='none';
					$G("detail_div3_4_"+detailtables+"_"+nowRowIndex).style.display='none';
					$G("detail_div3_5_"+detailtables+"_"+nowRowIndex).style.display='inline';
					$("#newsapbrowser_"+detailtables+"_"+nowRowIndex).css("height","16px");
					$("#newsapbrowser_"+detailtables+"_"+nowRowIndex).css("vertical-align","middle");
					$("#newsapbrowser_"+detailtables+"_"+nowRowIndex).css("background-color","transparent");
					if($G("showvalue_"+detailtables+"_"+fromRow).value=="")
					{
						$G("showimg_"+detailtables+"_"+nowRowIndex).style.display='inline';
					}else
					{
						//$G("showinner_"+detailtables+"_"+nowRowIndex).innerHTML=$G("showinner_"+detailtables+"_"+fromRow).innerHTML;
						//$G("showvalue_"+detailtables+"_"+nowRowIndex).value=$G("showvalue_"+detailtables+"_"+fromRow).value;
						//$G("showimg_"+detailtables+"_"+nowRowIndex).style.display='none';
					}
					
			}
			else{
				
				$G("detail_div3_0_"+detailtables+"_"+nowRowIndex).style.display='none';
				$G("detail_div3_1_"+detailtables+"_"+nowRowIndex).style.display='none';
				$G("detail_div3_4_"+detailtables+"_"+nowRowIndex).style.display='none';
				
				//zzl
				$G("detail_div3_5_"+detailtables+"_"+nowRowIndex).style.display='none';
				
			}
			if(broswerType_value==165||broswerType_value==166||broswerType_value==167||broswerType_value==168){
				$G("detail_div3_2_"+detailtables+"_"+nowRowIndex).style.display='inline';
				//$G("decentralizationbroswerType_"+detailtables+"_"+nowRowIndex).selectedIndex=$G("decentralizationbroswerType_"+detailtables+"_"+fromRow).selectedIndex;
				$G("decentralizationbroswerType_"+detailtables+"_"+nowRowIndex).value=$G("decentralizationbroswerType_"+detailtables+"_"+fromRow).value;
			}else{
				$G("detail_div3_2_"+detailtables+"_"+nowRowIndex).style.display='none';
			}
			
			
			jQuery('#detail_div3_'+detailtables+'_'+nowRowIndex + ' select').autoSelect();
			onChangDetailBroswerType(detailtables, nowRowIndex, fromRow);
		}
		if(itemFieldType==4||itemFieldType==6){//check框或附件上传
			$G("detail_div1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_3_"+detailtables+"_"+nowRowIndex).style.display="none";
		}
		if(itemFieldType==5){//选择框
			$G("detail_div1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_3_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div5_"+detailtables+"_"+nowRowIndex).style.display="inline";
			//$G("detail_div5_1_"+detailtables+"_"+nowRowIndex).style.display="inline";
			
			selectItemTypeChange('selectItemType',detailtables+"_"+nowRowIndex,fromRow);
			DetailPubChoice(detailtables,nowRowIndex,fromRow);
            DetailPubchilchoiceId(detailtables,nowRowIndex,fromRow);
			setPreviewPub('','','',detailtables+"_"+nowRowIndex);
			setSelectItemType(detailtables+"_"+nowRowIndex);
		}
		
		if(itemFieldType==6){
			$G("detail_div1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_3_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div5_"+detailtables+"_"+nowRowIndex).style.display="none";
			//$G("detail_div5_1_"+detailtables+"_"+nowRowIndex).style.display="none";
			
			$G("detail_div6_"+detailtables+"_"+nowRowIndex).style.display='inline';
			$G("detail_div6_1_"+detailtables+"_"+nowRowIndex).style.display='none';
			
			var _uploadtype_fromRow = $G("uploadtype_"+detailtables+"_"+fromRow);
			var _uploadtype_rowindex = $G("uploadtype_"+detailtables+"_"+nowRowIndex);
			for(var itemFieldType_i=0;itemFieldType_i<_uploadtype_rowindex.options.length;itemFieldType_i++){
				_uploadtype_rowindex.options[itemFieldType_i].selected
					=_uploadtype_fromRow.options[itemFieldType_i].selected;
				if(_uploadtype_fromRow.options[itemFieldType_i].selected){
					break;
				}
			}
			onDetailuploadtype(_uploadtype_rowindex,detailtables, nowRowIndex);
			var uploadtype_value = _uploadtype_fromRow.value;
			if(uploadtype_value==2){
				//$G("strlength_"+detailtables+"_"+nowRowIndex).value=$G("strlength_"+detailtables+"_"+fromRow).value;
				$G("imgwidth_"+detailtables+"_"+nowRowIndex).value=$G("imgwidth_"+detailtables+"_"+fromRow).value;
				$G("imgheight_"+detailtables+"_"+nowRowIndex).value=$G("imgheight_"+detailtables+"_"+fromRow).value;
			}
		}
		//为新行赋值
	}
}
function deleteDetailRow(detailtables){
    var flag = false;
	var ids = document.getElementsByName("check_select_detail_"+detailtables);
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
    	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
    	top.Dialog.confirm(str, function (){
            var deleteIds = $G("detaildelids_"+detailtables).value;
            var detailChangeRowIndexs = $G("detailChangeRowIndexs_"+detailtables).value;
            obj_table1 = $G("detailTable_"+detailtables);
            len = document.getElementsByName("check_select_detail_"+detailtables).length;
            var i=0;
            var rowsum1 = 0;
            for(i=len-1; i >= 0;i--){
                if(document.getElementsByName("check_select_detail_"+detailtables)[i].checked==true) {
                    checkSelectValue=document.getElementsByName("check_select_detail_"+detailtables)[i].value;
                    checkSelectArray=checkSelectValue.split("_");
                    itemId=checkSelectArray[0];
                    if(itemId!='0'){//新添加的行该标记为“0”，不用在后台做删除操作。
                        deleteIds +=itemId+",";
                    }
                    try{
                        var dbnames = $G("dbdetailfieldnamesForCompare_"+detailtables).value;
                        var dbname = $G("itemDspName_detail"+detailtables+"_"+checkSelectArray[1]).value.toUpperCase();
                        $G("dbdetailfieldnamesForCompare_"+detailtables).value = dbnames.replace(","+dbname+",",",");
                    }catch(e){}
                    detailChangeRowIndexs = detailChangeRowIndexs.replace(checkSelectArray[1]+",","");
                obj_table1.deleteRow(i+3);
                }
            }
            $G("detaildelids_"+detailtables).value = deleteIds;
            $G("detailChangeRowIndexs_"+detailtables).value = detailChangeRowIndexs;
        }, function () {}, 320, 90,true);
    }else{
        top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}
	var detailRowCntArray = new Array();
	
function addDetailRow(detailtables){
    obj_table = $G("detailTable_"+detailtables);
    if (detailRowCntArray[detailtables] != null && detailRowCntArray[detailtables] != undefined) {
    	detailrowindex = detailRowCntArray[detailtables] + 1;
    	detailRowCntArray[detailtables] = detailrowindex;
    } else {
    	detailRowCntArray[detailtables] = obj_table.rows.length-2;
    }
    detailrowindex = detailRowCntArray[detailtables];//明细行号
    $G("detailChangeRowIndexs_"+detailtables).value += detailrowindex+",";
		ncol = obj_table.rows[2].cells.length;
		oRow = obj_table.insertRow(-1);
		oRow.style.height=24;
		oRow.className="DataLight";
		for(j=0; j<ncol; j++) {
			oCell = oRow.insertCell(-1);
			oCell.noWrap=true;
			oCell.style.background="#fff";
			switch(j){
				case 0:
					var oDiv = document.createElement("div");
					var sHtml = "<input   type='checkbox' name='check_select_detail_"+detailtables+"' value='0_"+detailrowindex+"'>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;	
				case 1:
					var oDiv = document.createElement("div");
						var sHtml = "<input class='InputStyle' type='text'  maxlength='30' name='itemDspName_detail"+detailtables+"_"+detailrowindex+"' style='width:90%'  onblur=\"checkKey(this);checkinput_char_num('itemDspName_detail"+detailtables+"_"+detailrowindex+"');checkinput('itemDspName_detail"+detailtables+"_"+detailrowindex+"','itemDspName_detail"+detailtables+"_"+detailrowindex+"_span')\"><span id='itemDspName_detail"+detailtables+"_"+detailrowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 2:
					var oDiv = document.createElement("div");
					var sHtml = "<input class='InputStyle' type='text'  name='itemFieldName_detail"+detailtables+"_"+detailrowindex+"' style='width:90%'   onchange=\"checkinput('itemFieldName_detail"+detailtables+"_"+detailrowindex+"','itemFieldName_detail"+detailtables+"_"+detailrowindex+"_span')\" ><span id='itemFieldName_detail"+detailtables+"_"+detailrowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 3:
					var oDiv = document.createElement("div");
					var sHtml = "<div style='display:block;float:left;'><select class='InputStyle' style='float:left' name='itemFieldType_"+detailtables+"_"+detailrowindex+"'  onChange='onChangDetailItemFieldType("+detailtables+","+detailrowindex+")'>"+
	                      "<option value='1' selected><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>"+
	                      "<option value='2'><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>"+
	                      "<option value='3'><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>"+
	                      "<option value='4'><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>"+
	                      "<option value='5'><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>"+
	                      "<option value='6'><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>"+
                      "</select>&nbsp;&nbsp;</div>"+
                      "<div id=detail_div5_"+detailtables+"_"+detailrowindex+" style='display:none'>"+
                      	    "<div style='float: left;'>"+
							"    <span style='float: left;vertical-align:middle;line-height:30px;'><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>"+
							"    <select id='selectItemType"+detailtables+"_"+detailrowindex+"' name='selectItemType"+detailtables+"_"+detailrowindex+"' class=inputstyle  style='float: left;width: 125px !important;' onchange=selectItemTypeChange('selectItemType','"+detailtables+"_"+detailrowindex+"') >"+
						    "        <option value='0' ><%=SystemEnv.getHtmlLabelName(124929,user.getLanguage())%></option>"+
						    "        <option value='1' ><%=SystemEnv.getHtmlLabelName(124930,user.getLanguage())%></option>"+
						    "        <option value='2' ><%=SystemEnv.getHtmlLabelName(124931,user.getLanguage())%></option>"+
						    "    </select>"+
							"</div>"+
							
							"<div id='pubchoiceIdDIV"+detailtables+"_"+detailrowindex+"' style='display:none;float: left;margin-left:10px;'>"+
							"<span id='pubchoiceIdSpan"+detailtables+"_"+detailrowindex+"'></span>"+
							"<span style='line-height:30px;'><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></span>"+
							"<select id='previewPubchoiceId"+detailtables+"_"+detailrowindex+"' name='previewPubchoiceId"+detailtables+"_"+detailrowindex+"' notBeauty=true onfocus=setPreviewPub0('"+detailtables+"_"+detailrowindex+"')>"+
							"	<option value='' ></option>"+
							"</select>"+
						    "</div>"+
						    "<div id='pubchilchoiceIdDIV"+detailtables+"_"+detailrowindex+"' style='display:none;float: left;margin-left:10px;'>"+
						    "<span style='float:left;line-height:30px;margin-right:10px;'><%=SystemEnv.getHtmlLabelName(124957 ,user.getLanguage()) %></span>"+
						    "<span id='pubchilchoiceIdSpan"+detailtables+"_"+detailrowindex+"'></span>"+	
						    "</div>"+
							"<div id='childfielddiv"+detailtables+"_"+detailrowindex+"' style='float: left;'>"+
							"<input class='e8_btn_submit' type='button' id='childfieldbtn"+detailtables+"_"+detailrowindex+"' name='childfieldbtn"+detailtables+"_"+detailrowindex+"'  onclick=childfieldFun(0,'"+detailtables+"_"+detailrowindex+"') value='<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage())%>'/>"+
						  	"</div>"+
                      "</div>"+
                      
                      "<div id=detail_div1_"+detailtables+"_"+detailrowindex+" style='display:inline'>"+
                      	"<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>"+
                      	"<select class='InputStyle' name='documentType_"+detailtables+"_"+detailrowindex+"'  onChange='onChangDetailType("+detailtables+","+detailrowindex+")'>"+
                        	"<option value='1'><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>"+
                         	"<option value='2'><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>"+
                        	"<option value='3'><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>"+
                         	"<option value='4'><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option>"+
                         	"<option value='5'><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>"+
		                     "</select>&nbsp;&nbsp;"+
                      "</div>"+
                      "<div id=detail_div1_1_"+detailtables+"_"+detailrowindex+" style='display:inline'>"+
                      	"<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())+" "%>"+
                      	"<input class='InputStyle' type='text' size=3 maxlength=3 id='itemFieldScale1_"+detailtables+"_"+detailrowindex+"' name='itemFieldScale1_"+detailtables+"_"+detailrowindex+"' onKeyPress='ItemPlusCount_KeyPress()' onblur='checkPlusnumber1(this);checklength(itemFieldScale1_"+detailtables+"_"+detailrowindex+",itemFieldScale1span_"+detailtables+"_"+detailrowindex+");checkcount1(itemFieldScale1_"+detailtables+"_"+detailrowindex+")' style='text-align:right;padding-right:1px;'><span id=itemFieldScale1span_"+detailtables+"_"+detailrowindex+"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"+
                      "</div>"+
						"<div id=detail_div1_3_"+detailtables+"_"+detailrowindex+" style='display:none'>"+
                    	"<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>"+
                    	"<select id='decimaldigits_"+detailtables+"_"+detailrowindex+"' name='decimaldigits_"+detailtables+"_"+detailrowindex+"'>"+
						"<option value='1' >1</option>"+
						"<option value='2' selected>2</option>"+
						"<option value='3' >3</option>"+
						"<option value='4' >4</option>"+
						"</select>"+
						"</div>"+

						//明细表中的多行文本框字段html格式不可用, 故将其设为disabled
                      "<div id=detail_div2_"+detailtables+"_"+detailrowindex+" style='display:none'>"+
                      	"<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"+
                      	"<input class='InputStyle' type='text' size=4 maxlength=2 value=4 id=textheight_"+detailtables+"_"+detailrowindex+" name='textheight_"+detailtables+"_"+detailrowindex+"' onKeyPress='ItemPlusCount_KeyPress()' onblur='checkPlusnumber1(this);checkcount1(textheight_"+detailtables+"_"+detailrowindex+")' style='text-align:right;padding-right:1px;'>"+
                      	"<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>"+
                      	"<input type='checkbox' value='1' name='htmledit_"+detailtables+"_"+detailrowindex+"' id='htmledit_"+detailtables+"_"+detailrowindex+"' disabled onclick='onfirmdetailhtml("+detailtables+","+detailrowindex+")'>"+
                      "</div>"+
                      "<div id=detail_div3_"+detailtables+"_"+detailrowindex+" style='display:none;float:left'>"+
                      	"<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>"+
                      	"<select notBeauty=true style='width: 130px!important;' notBeauty=true class='InputStyle' name='broswerType_"+detailtables+"_"+detailrowindex+"' onChange='onChangDetailBroswerType("+detailtables+","+detailrowindex+")'><option></option>";
                      	<%
	                      	String IsOpetype=IntegratedSapUtil.getIsOpenEcology70Sap();
	                      	while(browserComInfo.next()){
                      	%>
                      	<%if(browserComInfo.getBrowserurl().equals("")){ continue;}%>
                      	<%
				  			 if("0".equals(IsOpetype)&&("224".equals(browserComInfo.getBrowserid()))||"225".equals(browserComInfo.getBrowserid())){
				  				 		continue;
				  			}
                      		if (browserComInfo.notCanSelect()) continue;
                      	%>
               sHtml += "<option match='<%=browserComInfo.getBrowserPY(user.getLanguage())%>' value='<%=browserComInfo.getBrowserid()%>'><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>";     		
                      	<%}%>
               sHtml += "</select><span class='selecthtmltypespan' style='diaplsy:none;'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"+
                      "</div>"+
                			"<div id=detail_div3_0_"+detailtables+"_"+detailrowindex+" style='display:none'> "+
                				"<span><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"+
                      "</div>"+
                      "<div id=detail_div3_1_"+detailtables+"_"+detailrowindex+" style='display:none:float:left'> "+
                      	"<span>";
               sHtml += "</span>"+
                      "</div>"+
                      "<div id=detail_div3_4_"+detailtables+"_"+detailrowindex+" style='display:none'> "+
	                  	"<select class='InputStyle' name='sapbrowser_"+detailtables+"_"+detailrowindex+"' onChange='detaildiv3_4_show("+detailtables+","+detailrowindex+")'>";
	                  	<%
	                  	List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
	                  	for(int j=0;j<AllBrowserId.size();j++){
	                  	%>
	           				sHtml += "<option value='<%=AllBrowserId.get(j)%>'><%=AllBrowserId.get(j)%></option>";
	                  	<%}%>
	           				sHtml += "</select>"+
	                  "</div>"+
	                  "<div id=detail_div3_5_"+detailtables+"_"+detailrowindex+" style='display:none'> "+
	                  " <button type=button  class='Browser browser' name=newsapbrowser_"+detailtables+"_"+detailrowindex+" id=newsapbrowser_"+detailtables+"_"+detailrowindex+" onclick=OnNewChangeSapBroswerTypeDetails("+detailtables+","+detailrowindex+")></button>"+
	                  " <span id=showinner_"+detailtables+"_"+detailrowindex+"></span>"+
	                  " <span id=showimg_"+detailtables+"_"+detailrowindex+"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"+
	                   "<input type='hidden' name=showvalue_"+detailtables+"_"+detailrowindex+" id=showvalue_"+detailtables+"_"+detailrowindex+">"+
	                  "</div>"+
	                  
	                  
	                  "<div id=detail_div6_"+detailtables+"_"+detailrowindex+" style='display:none'>"+
							"<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>"+
							"<select class='InputStyle' name='uploadtype_"+detailtables+"_"+detailrowindex+"' notBeauty=true onChange='onDetailuploadtype(this, "+detailtables+","+detailrowindex+");setChangeDetail("+detailtables+","+detailrowindex+")'>"+
								"<option value='1' selected><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>"+
								"<option value='2'><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>"+
							"</select>"+
						"</div>"+
		                
		                "<div id=detail_div6_1_"+detailtables+"_"+detailrowindex+" style='display:none'>"+
							//"<%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%>"+
							//"<input  type=input class='InputStyle' size=6 maxlength=3 name='strlength_"+detailtables+"_"+detailrowindex+"' onchange='setChangeDetail("+detailtables+","+detailrowindex+")' onKeyPress='ItemPlusCount_KeyPress()' onBlur='checkPlusnumber1(this)' value='5'>"+
							"<%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%>"+
							"<input  type=input class='InputStyle' size=6 maxlength=4 name='imgwidth_"+detailtables+"_"+detailrowindex+"'  onchange='setChangeDetail("+detailtables+","+detailrowindex+")' onKeyPress='ItemPlusCount_KeyPress()' onBlur='checkPlusnumber1(this)' value='50'>"+
							"<%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%>"+
							"<input  type=input class='InputStyle' size=6 maxlength=4 name='imgheight_"+detailtables+"_"+detailrowindex+"' onchange='setChangeDetail("+detailtables+","+detailrowindex+")' onKeyPress='ItemPlusCount_KeyPress()' onBlur='checkPlusnumber1(this)' value='50'>"+
						"</div>"+
	                  
	                  "<div id=detail_div3_7_"+detailtables+"_"+detailrowindex+" style='display:none:float:left'> "+
                      	"<span>";
               sHtml += "</span>"+
                      "</div>"+
	                   
                       "<div id=detail_div3_2_"+detailtables+"_"+detailrowindex+" style='display:none'> "+
	                   	
					    "<div style='float:left;'><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%></div>"+
						"<span id='show_decentralizationbroswerType_"+detailtables+"_"+detailrowindex+"'>本部门</span>"+  
						                
	                    "</div>"+
	                    
                      "";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 4:
					var oDiv = document.createElement("div");
						var sHtml = " <input class='InputStyle' type='text'  style='width:95%' maxlength=7 name='itemDspOrder_detail"+detailtables+"_"+detailrowindex+"' value='"+detailrowindex+".00'  onKeyPress='ItemNum_KeyPress(\"itemDspOrder_detail"+detailtables+"_"+detailrowindex+"\")' onchange='checknumber(\"itemDspOrder_detail"+detailtables+"_"+detailrowindex+"\");checkDigit(\"itemDspOrder_detail"+detailtables+"_"+detailrowindex+"\",15,2)' style='text-align:right;'>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;				
				case 5:
					var oDiv = document.createElement("div");
					var sHtml = "<button type=button  class=\"Browser\" onClick=\"onShowChildSelectItem('childItemSpan_detail"+detailtables+"_"+choicerowindex+"', 'childItem_detail"+detailtables+"_"+choicerowindex+"','_detail"+detailtables+"')\" id=\"selectChildItem_detail"+detailtables+"_"+choicerowindex+"\" name=\"selectChildItem_detail"+detailtables+"_"+choicerowindex+"\"></BUTTON>"
								+ "<input type=\"hidden\" id=\"childItem_detail"+detailtables+"_"+choicerowindex+"\" name=\"childItem_detail"+detailtables+"_"+choicerowindex+"\" value=\"\" >"
								+ "<span id=\"childItemSpan_detail"+detailtables+"_"+choicerowindex+"\" name=\"childItemSpan_detail"+detailtables+"_"+choicerowindex+"\"></span>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
			}
		}
	//jQuery("body").jNice();
	//$(obj_table).find("select").selectbox();
	//jQuery(oRow).jNice();
	//jQuery(oRow).find("select").selectbox();
}


function RightAttrBrowser(detailtableid,detailtablerowid){
    var bv = '1';
    var bsv = '本部门';
    try{
	    bv = $G("decentralizationbroswerType_"+detailtableid+"_"+detailtablerowid).value;
	    bsv = $G("decentralizationbroswerType_"+detailtableid+"_"+detailtablerowid+"_span").innerHTML;
    }catch(e){
    	bv = '1';
        bsv = '本部门';
    }
	jQuery('#show_decentralizationbroswerType_' + detailtableid+'_'+detailtablerowid).e8Browser({
	   name:'decentralizationbroswerType_' + detailtableid+'_'+detailtablerowid,
	   browserValue:bv,
	   browserSpanValue:bsv,
	   viewType:"1",
	   hasInput:false,
	   isSingle:false,
	   hasBrowser:true, 
	   isMustInput:2,
	   completeUrl:"/data.jsp",
	   browserDialogHeight:"290",
	   browserDialogWidth:"400",
	   temptitle:"<%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%>", 
	   width:"105px",
	   browserUrl:"/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#",
		_callback:"setChangeDetail"
	});
}


function MainRightAttrDepat(rowid){
    var bv = '1';
    var bsv = '本部门';
    try{
	    bv = $G("#decentralizationbroswerType_"+rowid).val();
	    bsv = $G("decentralizationbroswerType_"+rowid+"_span").innerHTML;
    }catch(e){
    	bv = '1';
        bsv = '本部门';
    }
	jQuery('#show_decentralizationbroswerType_'+rowid).e8Browser({
	   name:'decentralizationbroswerType_'+rowid,
	   browserValue:bv,
	   browserSpanValue:bsv,
	   viewType:"0",
	   hasInput:false,
	   isSingle:false,
	   hasBrowser:true, 
	   isMustInput:2,
	   completeUrl:"/data.jsp",
	   width:"105px",
	   browserDialogHeight:"290",
	   browserDialogWidth:"400",
	   temptitle:"<%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%>",
	   browserUrl:"/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#",
		_callback:"setChange1"
	});
}



//明细表字段 选择框 删除选项
function submitDetailClear(tableid,rowid){
	setChangeDetail(tableid,rowid);
	var flag = false;
	var ids = document.getElementsByName('chkDetailField');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
    	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
    	top.Dialog.confirm(str, function (){
    		deleteRow2(tableid,rowid);
    	}, function () {}, 320, 90,true);
    }else{
    	top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}
//明细表字段 选择框 删除选项
function deleteRow2(tableid,rowid){
	$("#choiceTable_"+tableid+"_"+rowid).find("input[name=chkDetailField]").each(function(){
		var obj = $(this);
		if(obj.attr("checked")){
			obj.closest("tr").remove();
		}
	});	
}

//明细表字段 选择框 添加选项
function addDetailTableRow(tableid,tablerowid){
  rowColor1 = getRowBg();
  obj1 = $G("choiceTable_"+tableid+"_"+tablerowid);
  choicerowindex = $G("choiceRows_"+tableid+"_"+tablerowid).value*1+1;
  $G("choiceRows_"+tableid+"_"+tablerowid).value = choicerowindex;
	ncol1 = obj1.rows[0].cells.length;
	oRow1 = obj1.insertRow(-1);
	for(j=0; j<ncol1; j++) {
		oCell1 = oRow1.insertCell(-1);
		oCell1.style.height=24;
		oCell1.style.padding=0;
		oCell1.style.background="";
		switch(j) {
			case 0:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input   type='checkbox' name='chkDetailField' index='"+choicerowindex+"' value='0'>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 1:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input class='InputStyle' type='text' size='10' name='field_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_name' style='width=90%'"+
							" onchange=checkinput('field_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_name','field_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_span')>"+
							" <span id='field_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 2:
				var oDiv1 = document.createElement("div");
				var sHtml1 = " <input class='InputStyle' type='text' size='4' value = '0.00' name='field_count_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_name' style='width=90%'"+
							" onKeyPress=ItemNum_KeyPress('field_count_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_name') onchange=checknumber('field_count_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_name')>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 3:
				var oDiv1 = document.createElement("div");
				var sHtml1 = " <input type='checkbox' name='field_checked_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_name' onclick='if(this.checked){this.value=1;}else{this.value=0}'>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 4:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input type='checkbox' name='isAccordToSubCom"+tableid+"_"+tablerowid+"_"+choicerowindex+"' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;"
							+ "<button type=button  class=Browser onClick=\"onShowDetailCatalog(mypath_"+tableid+"_"+tablerowid+"_"+choicerowindex+","+tableid+","+tablerowid+","+choicerowindex+")\" name=selectCategory></BUTTON>"
							+ "<span id=mypath_"+tableid+"_"+tablerowid+"_"+choicerowindex+"></span>"
						    + "<input type=hidden id='pathcategory_" + tableid+"_"+tablerowid + "_"+choicerowindex+"' name='pathcategory_" + tableid+"_"+tablerowid + "_"+choicerowindex+"' value=''>"
						    + "<input type=hidden id='maincategory_" + tableid+"_"+tablerowid + "_"+choicerowindex+"' name='maincategory_" + tableid+"_"+tablerowid + "_"+choicerowindex+"' value=''>";

				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 5:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<button type=button  class=\"Browser\" onClick=\"onShowChildSelectItem('childItemSpan_detail" + tableid+"_"+tablerowid + "_"+choicerowindex+"', 'childItem_detail" + tableid+"_"+tablerowid + "_"+choicerowindex+"','_detail"+tableid+"_"+tablerowid+"')\" id=\"selectChildItem_" + tableid+"_"+tablerowid + "_"+choicerowindex+"\" name=\"selectChildItem_" + tableid+"_"+tablerowid + "_"+choicerowindex+"\"></BUTTON>"
							+ "<input type=\"hidden\" id=\"childItem_detail" + tableid+"_"+tablerowid + "_"+choicerowindex+"\" name=\"childItem_" + tableid+"_"+tablerowid + "_"+choicerowindex+"\" value=\"\" >"
							+ "<span id=\"childItemSpan_detail" + tableid+"_"+tablerowid + "_"+choicerowindex+"\" name=\"childItemSpan_" + tableid+"_"+tablerowid + "_"+choicerowindex+"\"></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
		}		
	}
	//jQuery("body").jNice();
	//jQuery(oRow1).jNice();
}
function detaildiv3_0_show(detailtableid,detailtablerowid){
	detaildiv3_1_value = $G("definebroswerType_"+detailtableid+"_"+detailtablerowid).value;
	if(detaildiv3_1_value=="")
		$G("div3_0_"+detailtableid+"_"+detailtablerowid).style.display='inline';
	else
		$G("div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';

}
function detaildiv3_4_show(detailtableid,detailtablerowid){
	detaildiv3_4_value = $G("sapbrowser_"+detailtableid+"_"+detailtablerowid).value;
	if(detaildiv3_4_value=="")
		$G("div3_0_"+detailtableid+"_"+detailtablerowid).style.display='inline';
	else
		$G("div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';

}
function onChangDetailItemFieldType(detailtableid,detailtablerowid){
		itemFieldType = $G("itemFieldType_"+detailtableid+"_"+detailtablerowid).value;
		if(itemFieldType==1){
			$G("detail_div1_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			$G("documentType_"+detailtableid+"_"+detailtablerowid).selectedIndex=0;
			//jQuery("name=[documentType_"+detailtableid+"_"+detailtablerowid+"]").selectbox("detach");
			//jQuery("name=[documentType_"+detailtableid+"_"+detailtablerowid+"]").selectbox("attach");
			$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div6_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div6_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			
			$G("detail_div3_7_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			//$G("detail_div5_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		}
		if(itemFieldType==2){
			$G("detail_div1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			$G("detail_div3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
			//zzl
			$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			
			$G("detail_div6_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div6_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			
			$G("detail_div3_7_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			//$G("detail_div5_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		}
		if(itemFieldType==3){
			$G("detail_div1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
			//zzl
			$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			
			$G("detail_div6_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div6_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			
			$G("detail_div3_7_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			//$G("detail_div5_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		    sortOption($("#detail_div3_"+detailtableid+"_"+detailtablerowid+" select")[0]);
		    if($G("broswerType_"+detailtableid+"_"+detailtablerowid).value==224){
		    	$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			}
			//zzl
			if($G("broswerType_"+detailtableid+"_"+detailtablerowid).value==226||$G("broswerType_"+detailtableid+"_"+detailtablerowid).value==227){
		    	$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			}
			jQuery('#detail_div3_'+detailtableid+'_'+detailtablerowid + ' select').autoSelect();
			onChangDetailBroswerType(detailtableid, detailtablerowid);
		}
		if(itemFieldType==4){
			$G("detail_div1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
			
			//zzl
			$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			
			$G("detail_div6_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div6_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			
			$G("detail_div3_7_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			//$G("detail_div5_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		}
    if(itemFieldType==5){
			$G("detail_div1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
			//zzl
			$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			
			$G("detail_div6_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div6_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			
			$G("detail_div3_7_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			//$G("detail_div5_1_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			
			DetailPubChoice(detailtableid,detailtablerowid);
    		DetailPubchilchoiceId(detailtableid,detailtablerowid);
    		setSelectItemType(detailtableid+"_"+detailtablerowid);
		}
    if(itemFieldType==6){
			$G("detail_div1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
			//zzl
			$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			
			$G("detail_div6_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			$G("detail_div6_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			var _uploadtype_rowindex = $G("uploadtype_"+detailtableid+"_"+detailtablerowid);
			onDetailuploadtype(_uploadtype_rowindex,detailtableid, detailtablerowid);
			
			$G("detail_div3_7_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			//$G("detail_div5_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		}
		BTCOpen($("[name=broswerType_"+detailtableid+"_"+detailtablerowid+"]"));
}
function onChangDetailType(detailtableid,detailtablerowid){
	itemFieldType = $G("documentType_"+detailtableid+"_"+detailtablerowid).value;
	if(itemFieldType==1){
		$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
	}else if(itemFieldType==3){
		$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
	}else if(itemFieldType==5){
		$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
	}else{
		$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
	}
}
function onfirmdetailhtml(detailtableid,detailtablerowid){
	if($G("htmledit_"+detailtableid+"_"+detailtablerowid).checked==true){
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(20867,user.getLanguage())%>');
		$G("htmledit_"+detailtableid+"_"+detailtablerowid).value=2;
	}
	//else{
	//	$G("htmledit_"+detailtableid+"_"+detailtablerowid).value=1;
	//}
}
function onChangDetailBroswerType(detailtableid,detailtablerowid,fromIndex){
	$G("detail_div3_7_"+detailtableid+"_"+detailtablerowid).style.display='none';
	broswerType = $G("broswerType_"+detailtableid+"_"+detailtablerowid).value;
	if (broswerType == '') {
		jQuery('#detail_div3_'+detailtableid+"_"+detailtablerowid+' .selecthtmltypespan').show();
	} else {
		jQuery('#detail_div3_'+detailtableid+"_"+detailtablerowid+' .selecthtmltypespan').hide();
	}
	if(broswerType==161||broswerType==162){
		if (jQuery('#detail_div3_1_' + detailtableid + '_' + detailtablerowid + ' #definebroswerType_' + detailtableid+'_'+detailtablerowid).length == 0) {
			var bv = '';
		    var bsv = '';
		    if (fromIndex != null) {
		    	bv = jQuery('#definebroswerType_' + detailtableid+'_'+fromIndex).val();
		    	bsv = jQuery('#definebroswerType_' + detailtableid+'_'+fromIndex + 'span span a').text();
		    }
			jQuery('#detail_div3_1_' + detailtableid + '_' + detailtablerowid + ' span').e8Browser({
			   name:'definebroswerType_' + detailtableid+'_'+detailtablerowid,
			   browserValue:bv,
			   browserSpanValue:bsv,
			   viewType:"1",
			   hasInput:false,
			   isSingle:true,
			   hasBrowser:true, 
			   isMustInput:2,
			   completeUrl:"/data.jsp",
			   width:"105px",
			   browserUrl:"/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp",
				_callback:"setChangeDetail1"
			});
		}
		//$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
		
		//zzl
		$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
	}else if(broswerType==256||broswerType==257){
		$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
		
		//zzl
		$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_7_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		
		if (jQuery('#detail_div3_7_' + detailtableid + '_' + detailtablerowid + ' #defineTreeBroswerType_' + detailtableid+'_'+detailtablerowid).length == 0) {
			var bv = '';
		    var bsv = '';
		    if (fromIndex != null) {
		    	bv = jQuery('#defineTreeBroswerType_' + detailtableid+'_'+fromIndex).val();
		    	bsv = jQuery('#defineTreeBroswerType_' + detailtableid+'_'+fromIndex + 'span span a').text();
		    }
			jQuery('#detail_div3_7_' + detailtableid + '_' + detailtablerowid + ' span').e8Browser({
			   name:'defineTreeBroswerType_' + detailtableid+'_'+detailtablerowid,
			   browserValue:bv,
			   browserSpanValue:bsv,
			   viewType:"1",
			   hasInput:false,
			   isSingle:true,
			   hasBrowser:true, 
			   isMustInput:2,
			   completeUrl:"/data.jsp",
			   width:"105px",
			   browserUrl:"/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/TreeBrowser.jsp",
				_callback:"setChangeDetail1"
			});
		}	
	}else if(broswerType==224||broswerType==225){
		//$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		//zzl
		$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
		var sapbrowserOptionValue = $G("sapbrowser_"+detailtableid+"_"+detailtablerowid).value;
		if(sapbrowserOptionValue==''||sapbrowserOptionValue==0){
		    $G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display="inline"
		}else{
		    $G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display="none"
		}
	}else if(broswerType==226||broswerType==227){
		//zzl
		$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		$("#newsapbrowser_"+detailtableid+"_"+detailtablerowid).css("height","16px");
		$("#newsapbrowser_"+detailtableid+"_"+detailtablerowid).css("vertical-align","middle");
		$("#newsapbrowser_"+detailtableid+"_"+detailtablerowid).css("background-color","transparent");
	}
	else{
		$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
	}
	if(broswerType==165||broswerType==166||broswerType==167||broswerType==168){
		$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		RightAttrBrowser(detailtableid,detailtablerowid);
	}else{
		$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='none';
	}
	
	
}
function onShowDetailCatalog(spanName, tableid, index, choicerowindex){
	var isAccordToSubCom=0;
	if($G("isAccordToSubCom"+tableid+"_"+index+"_"+choicerowindex)!=null){
		if($G("isAccordToSubCom"+tableid+"_"+index+"_"+choicerowindex).checked){
			isAccordToSubCom=1;
		}
	}
	if(isAccordToSubCom==1){
		onShowDetailCatalogSubCom();
	}else{
		onShowDetailCatalogHis(spanName, tableid, index, choicerowindex);
	}
}
function onShowDetailCatalogHis(spanName, tableid, index, choicerowindex) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
    if (result != null){
    	var rid = wuiUtil.getJsonValueByIndex(result, 0);
    	var rname = wuiUtil.getJsonValueByIndex(result, 1);
    	var rkey3 = wuiUtil.getJsonValueByIndex(result, 2);
    	var rkey4 = wuiUtil.getJsonValueByIndex(result, 3);
    	var rkey5 = wuiUtil.getJsonValueByIndex(result, 4);
        
        if (rid > 0){
        	setChangeDetail(tableid,index);
            spanName.innerHTML=rkey3;
            $G("pathcategory_"+tableid+"_"+index+"_"+choicerowindex).value=rkey3;
            $G("maincategory_"+tableid+"_"+index+"_"+choicerowindex).value=rkey4+","+rrkey5+","+rrkey2;
        }else{
            spanName.innerHTML="";
            $G("pathcategory_"+tableid+"_"+index+"_"+choicerowindex).value="";
            $G("maincategory_"+tableid+"_"+index+"_"+choicerowindex).value="";
       }
    }
}
function onShowDetailCatalogSubCom() {
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24460,user.getLanguage())%>");
}
</script>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >
</script>
<script language=javascript>


function MainPubChoice(rowid){
    var bv = '';
    var bsv = '';
    
    var numargs = arguments.length;
    if(numargs>1){
    	var fromIndex = arguments[1];
    	bv = jQuery('#pubchoiceId' + fromIndex).val();
		bsv = jQuery('#pubchoiceId' + fromIndex + 'span span a').text();
		bsv = "<a title="+bsv+" href=javaScript:eidtSelectItem("+bv+")>"+bsv+"</a>";
		
    }
    
    try{
    	jQuery('#pubchoiceIdSpan'+rowid).e8Browser({
		   name:'pubchoiceId'+rowid,
		   browserValue:bv,
		   browserSpanValue:bsv,
		   viewType:"0",
		   hasInput:true,
		   isSingle:true,
		   hasBrowser:true, 
		   isMustInput:2,
		   completeUrl:"/data.jsp?type=pubChoice",
		   width:"150px",
		   browserDialogHeight:"650px",
		   browserDialogWidth:"550px",
		   temptitle:"",
		   browserUrl:"/workflow/selectItem/selectItemMain.jsp?topage=selectItemBrowser&url=/workflow/selectItem/selectItemBrowser.jsp",
		   _callbackParams:""+rowid,
		   _callback:"setPreviewPub"
		});
    }catch(e){}
	
}

function MainPubchilchoiceId(rowid){
    var bv = '';
    var bsv = '';
    
    var numargs = arguments.length;
    if(numargs>1){
    	var fromIndex = arguments[1];
    	bv = jQuery('#pubchilchoiceId' + fromIndex).val();
		bsv = jQuery('#pubchilchoiceId' + fromIndex + 'span span a').text();
		bsv = "<a title="+bsv+" href=javaScript:eidtSelectItem("+bv+")>"+bsv+"</a>";
    }
    
	try{
    	jQuery('#pubchilchoiceIdSpan'+rowid).e8Browser({
		   name:'pubchilchoiceId'+rowid,
		   browserValue:bv,
		   browserSpanValue:bsv,
		   viewType:"0",
		   hasInput:true,
		   isSingle:true,
		   hasBrowser:true, 
		   isMustInput:2,
		   completeUrl:"javascript:getcompleteurl('0#0#0#"+rowid+"')",
		   width:"150px",
		   browserDialogHeight:"650px",
		   browserDialogWidth:"550px",
		   temptitle:"",
		   browserUrl:"",
		   _callbackParams:""+rowid,
		   _callback:"setChange0",
		   getBrowserUrlFnParams:"0#0#0#"+rowid,
		   getBrowserUrlFn:"onShowPubchilchoiceId"
		});
    }catch(e){}
}
function DetailPubChoice(tableNumber,detailrowsum){
    var bv = '';
    var bsv = '';
    
    var numargs = arguments.length;
    if(numargs>2){
    	var fromIndex = arguments[2];
    	bv = jQuery('#pubchoiceId' +tableNumber+"_"+ fromIndex).val();
		bsv = jQuery('#pubchoiceId'+tableNumber+"_"+ fromIndex + 'span span').html();
    }
    
	try{
    	jQuery('#pubchoiceIdSpan'+tableNumber+"_"+detailrowsum).e8Browser({
		   name:'pubchoiceId'+tableNumber+"_"+detailrowsum,
		   browserValue:bv,
		   browserSpanValue:bsv,
		   viewType:"1",
		   hasInput:true,
		   isSingle:true,
		   hasBrowser:true, 
		   isMustInput:2,
		   completeUrl:"/data.jsp?type=pubChoice",
		   width:"150px",
		   browserDialogHeight:"650px",
		   browserDialogWidth:"550px",
		   temptitle:"",
		   browserUrl:"/workflow/selectItem/selectItemMain.jsp?topage=selectItemBrowser&url=/workflow/selectItem/selectItemBrowser.jsp",
		   _callbackParams:tableNumber+"_"+detailrowsum,
		   _callback:"setPreviewPub"
		});
    }catch(e){}
}

function DetailPubchilchoiceId(tableNumber,detailrowsum){
    var bv = '';
    var bsv = '';
    
    var numargs = arguments.length;
    if(numargs>2){
    	var fromIndex = arguments[2];
    	bv = jQuery('#pubchilchoiceId' +tableNumber+"_"+ fromIndex).val();
		bsv = jQuery('#pubchilchoiceId'+tableNumber+"_"+ fromIndex + 'span span a').text();
    }
    
	try{
    	jQuery('#pubchilchoiceIdSpan'+tableNumber+"_"+detailrowsum).e8Browser({
		   name:'pubchilchoiceId'+tableNumber+"_"+detailrowsum,
		   browserValue:bv,
		   browserSpanValue:bsv,
		   viewType:"1",
		   hasInput:true,
		   isSingle:true,
		   hasBrowser:true, 
		   isMustInput:2,
		   completeUrl:"javascript:getcompleteurl('1#0#"+tableNumber+"#"+detailrowsum+"')",
		   width:"150px",
		   browserDialogHeight:"650px",
		   browserDialogWidth:"550px",
		   temptitle:"",
		   browserUrl:"",
		   _callback:"setChangeDetail2",
		   _callbackParams:tableNumber+","+detailrowsum,
		   getBrowserUrlFnParams:"1#0#"+tableNumber+"#"+detailrowsum,
		   getBrowserUrlFn:"onShowPubchilchoiceId"
		});
    }catch(e){}
}


function setSelectItemType(rowindex){
	var detailtable = "";
    var isdetail = 0;
    var detailtablenum = "";
    var paramstr = "";
    if(rowindex.indexOf("_")!=-1){
		isdetail = 1;    
		detailtable = "";
		var strarray = rowindex.split("_");
		detailtablenum = strarray[0];
		rowindex = strarray[1];
	    detailtable = $G("detailtablename_db_"+detailtablenum).value;
	    
	    paramstr = detailtablenum+"_"+rowindex;
    }else{
    	detailtable = "";
        isdetail = 0;
        paramstr = rowindex+"";
    }
    
	jQuery.ajax({
			type: "POST",
			cache: false,
			url: "/workflow/selectItem/selectItemAjaxData.jsp?src=hasPubChoice&isdetail="+isdetail+"&formid=<%=formid%>&detailtable="+detailtable,
		    dataType: "text",  
		    async:false,
		    //contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(){
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
		    success : function (data, textStatus) {
		        var _data = data.trim();
		        if(_data=="true"){
					//jQuery("#selectItemType"+paramstr+"").append("<option value='2'><%=SystemEnv.getHtmlLabelName(124931,user.getLanguage())%></option>");		        
		        }else{
		        	jQuery("#selectItemType"+paramstr+" option[value='2']").remove();
		        }
		    	//__jNiceNamespace__.reBeautySelect("#selectItemType"+paramstr+"");
		    	var sb = jQuery("#selectItemType"+paramstr+"").attr("sb");
		    	//jQuery("#sbHolderSpan_"+sb).css({"width":width});
		    	jQuery("#sbHolderSpan_"+sb).css({"width":"125px"});
		    } 
	}); 
}


function selectItemTypeChange(obj,rowindex){
	var value = jQuery("#"+obj+rowindex).val();
	var numargs = arguments.length;
    if(numargs>2){
    	var fromIndex = arguments[2];
    	var str = "";
    	rowindex = rowindex+"";
    	if(rowindex.indexOf("_")!=-1){
    		str = obj+""+rowindex.split("_")[0]+"_";
    		value = jQuery("#"+str+fromIndex).val();
    		jQuery("#"+obj+rowindex).val(value);
    	}else{
    		value = jQuery("#"+obj+fromIndex).val();
    		jQuery("#"+obj+rowindex).val(value);
    	}
    	
    }
    
	if(value != 0){
		///jQuery("#choicediv"+rowindex).hide();
		jQuery("#childfielddiv"+rowindex).hide();
	}else{
		//jQuery("#choicediv"+rowindex).show();
		jQuery("#childfielddiv"+rowindex).show();
	}
	
	if(value==1){
		jQuery("#pubchoiceIdDIV"+rowindex).show();
	}else{
		jQuery("#pubchoiceIdDIV"+rowindex).hide();
	}
	
	if(value==2){
		jQuery("#pubchilchoiceIdDIV"+rowindex).show();
	}else{
		jQuery("#pubchilchoiceIdDIV"+rowindex).hide();
	}
	
	
}

function setPreviewPub0(rowindex){
	setPreviewPub('','','',rowindex)
}

function setPreviewPub(event,datas,name,rowindex){
	var pubchoiceId = jQuery("#pubchoiceId"+rowindex).val()
	
	if(rowindex.indexOf("_")!=-1){
	    var strarray = rowindex.split("_");
		setChangeDetail(strarray[0],strarray[1]);
	}else{
		setChange(rowindex);
	}
	
	
	jQuery("#previewPubchoiceId"+rowindex).empty();
	jQuery.ajax({
			type: "POST",
			cache: false,
			url: "/workflow/selectItem/selectItemAjaxData.jsp?src=pubchoiceback&id="+pubchoiceId,
		    dataType: "json",  
		    async:false,
		    //contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(){
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
		    success : function (data, textStatus) {
		        jQuery("#previewPubchoiceId"+rowindex).append("<option value=''></option>");
		        var _data = data;
		    	for(var i=0;i<_data.length;i++){
		    	    var tt = _data[i];
		    	    var _id = tt.id;
		    	    var _name = tt.name;
		    		jQuery("#previewPubchoiceId"+rowindex).append("<option value='"+_id+"'>"+_name+"</option>");
		    	}
		    	//beautySelect("#previewPubchoiceId");
		    	__jNiceNamespace__.reBeautySelect("#previewPubchoiceId"+rowindex);
		    } 
	}); 
	
	
}

function eidtSelectItem(id){
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelName(124896,user.getLanguage())%>";
	url="/workflow/selectItem/selectItemMain.jsp?topage=selectItemEdit&src=edit&id="+id;
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.maxiumnable = true;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}


	
function getcompleteurl(obj) {
    var strarray = obj.split("#");
    var isdetail = strarray[0];
    var fieldid = strarray[1];
    var detailnumber = strarray[2];
    var rowindex = strarray[3];
    
    var detailtable = "";
    if(isdetail==1){
    	var detailtable = $G("detailtablename_db_"+detailnumber).value;
        detailtable = " &detailtable="+detailtable+" ";
    }
    url = "/data.jsp?type=pubChoice&pubchild=1&fieldhtmltype=5&billid=<%=formid%>" + detailtable + "&isdetail=" + isdetail + "&isbill=1&fieldid="+fieldid;
    return url;
}

function onShowPubchilchoiceId(obj) {
	 //"0#"+fieldid+"#0#"+rowsum
    var strarray = obj.split("#");
    var isdetail = strarray[0];
    var fieldid = strarray[1];
    var detailnumber = strarray[2];
    var rowindex = strarray[3];
    
    var detailtable = "";
    if(isdetail==1){
    	var detailtable = $G("detailtablename_db_"+detailnumber).value;
        detailtable = " &detailtable="+detailtable+" ";
    }
    url = "/workflow/selectItem/selectItemMain.jsp?topage=selectItemSupFieldBrowser&fieldhtmltype=5&billid=<%=formid%>" + detailtable + "&isdetail=" + isdetail + "&isbill=1&fieldid="+fieldid;
    return url;
}


function childfieldFun(fieldid,rowindex){
	var title = "";
	var url = "";
	if(fieldid==0){
		jQuery("#jumpRowindex").val(rowindex);
		var obj = document.getElementById("childfieldbtn"+rowindex);
		jQuery("button[name^=childfieldbtn]").each(function(){
			jQuery(this).attr("disabled",true);
		});
		onSave(obj);
		return;
	}
	refreshParentWin();
	title = "<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage())%>";
	url="/workflow/selectItem/selectItemMain.jsp?topage=selectItemEdit0&fieldid="+fieldid;
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.maxiumnable = true;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}




rowindex = 0;
delids = ",";
changeRowIndexs = ",";
var rowColor="" ;
var paraStr="";
function addRow(){			
    rowColor = getRowBg();
    
	//ncol = oTable.cols;
	ncol = oTable.rows[0].cells.length;
	
	oRow = oTable.insertRow(-1);
	oRow.style.height=24;
	oRow.className="DataLight";
	setChange(rowindex);
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.noWrap=true;
		//oCell.style.height=24;
		oCell.style.background="#fff";
		switch(j){
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input   type='checkbox' name='check_select' value='0_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
				
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text' maxlength='30' name='itemDspName_"+rowindex+"' onblur=\"checkKey(this);checkinput_char_num('itemDspName_"+rowindex+"');checkinput('itemDspName_"+rowindex+"','itemDspName_"+rowindex+"_span')\"><span id='itemDspName_"+rowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='itemFieldName_"+rowindex+"' onchange=\"checkinput('itemFieldName_"+rowindex+"','itemFieldName_"+rowindex+"_span')\" ><span id='itemFieldName_"+rowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<%=formmanager.getItemFieldTypeSelectForAddMainRow(user,isFromMode)%>";	
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = " <input class='InputStyle' type='text' maxlength=7 name='itemDspOrder_"+rowindex+"' value='"+(rowindex*1 +1)+".00'  onKeyPress='ItemNum_KeyPress(\"itemDspOrder_"+rowindex+"\")' onchange='checknumber(\"itemDspOrder_"+rowindex+"\");checkDigit(\"itemDspOrder_"+rowindex+"\",15,2)' style='text-align:right;'>";						   
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;				
			case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<button type=button  class=\"Browser\" onClick=\"onShowChildSelectItem('childItemSpan_"+rowindex+"', 'childItem_"+rowindex+"','_"+rowindex+"')\" id=\"selectChildItem_"+rowindex+"\" name=\"selectChildItem_"+rowindex+"\"></BUTTON>"
							+ "<input type=\"hidden\" id=\"childItem_"+rowindex+"\" name=\"childItem_"+rowindex+"\" value=\"\" >"
							+ "<span id=\"childItemSpan_"+rowindex+"\" name=\"childItemSpan_"+rowindex+"\"></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	
	MainPubChoice(rowindex);
    MainPubchilchoiceId(rowindex);
    
	rowindex = rowindex*1 +1;
	//jQuery("body").jNice();
	//$("#oTable").find("select").selectbox();
	//jQuery(oRow).jNice();
	//jQuery(oRow).find("select").selectbox();
}
function checklength(elementname,spanid){
	tmpvalue = elementname.value;
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if(tmpvalue!=""&&tmpvalue!=0){
		 spanid.innerHTML='';
	}
	else{
	 spanid.innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 elementname.value = "";
	}
}
function deleteRow(){
	var flag = false;
	var ids = document.getElementsByName('check_select');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
    	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
    	top.Dialog.confirm(str, function (){
    		len = document.getElementsByName("check_select").length;
            var i=0;
            var rowsum1 = 0;
            for(i=len-1; i >= 0;i--){
                if(document.getElementsByName("check_select")[i].checked==true) {
                    checkSelectValue=document.getElementsByName("check_select")[i].value;
                    checkSelectArray=checkSelectValue.split("_");
                    itemId=checkSelectArray[0];
                    if(itemId!='0'){
                        delids +=itemId+",";
                    }
                    changeRowIndexs = changeRowIndexs.replace(checkSelectArray[1]+",","");
                    try{
                    var dbfieldname = $G("itemDspName_"+checkSelectArray[1]).value.toUpperCase();
                    dbfieldnames = dbfieldnames.replace(","+dbfieldname+",",",");
                    }catch(e){}
                oTable.deleteRow(i+1);
                }
            }
    	}, function () {}, 320, 90,true);
    }else{
    	top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}

function copyRow(){
	var copyedRow="";
	len = document.getElementsByName("check_select").length;
	var i=0;
	for(i=len-1; i >= 0;i--){
			if(document.getElementsByName("check_select")[i].checked==true) {
				checkSelectValue=document.getElementsByName("check_select")[i].value;
				checkSelectArray=checkSelectValue.split("_");
				rowNum=checkSelectArray[1];
				copyedRow+=","+rowNum;
			}
	}
	var copyedRowArray =copyedRow.substring(1).split(",");
	fromRow=0;
	for (loop=copyedRowArray.length-1; loop >=0 ;loop--){
		setChange(rowindex);
		fromRow=copyedRowArray[loop] ;
		if(fromRow==""){
			continue;
		}
		itemDspName=$G("itemDspName_"+fromRow).value;
		itemDspName=trim(itemDspName);
		itemFieldName=$G("itemFieldName_"+fromRow).value;
		itemFieldName=trim(itemFieldName);
		itemFieldType=$G("itemFieldType_"+fromRow).value;

		rowColor = getRowBg();
	  ncol = oTable.rows[0].cells.length;
	  oRow = oTable.insertRow(-1);

	  for(i=0; i<ncol; i++) {
		oCell = oRow.insertCell(-1);
		oCell.noWrap=true;
		oCell.style.height=24;
		oCell.style.background=rowColor;
		switch(i) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input   type='checkbox' name='check_select' value='0_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text' size='35' maxlength='30' name='itemDspName_"+rowindex+"' value='"+itemDspName+"' style='width:90%'   onblur=\"checkKey(this);checkinput_char_num('itemDspName_"+rowindex+"');checkinput('itemDspName_"+rowindex+"','itemDspName_"+rowindex+"_span')\"><span id='itemDspName_"+rowindex+"_span'>";
				if(itemDspName==""){
					sHtml+="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				}
				sHtml+="</span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='itemFieldName_"+rowindex+"' value='"+itemFieldName+"' style='width:90%'   onchange=\"checkinput('itemFieldName_"+rowindex+"','itemFieldName_"+rowindex+"_span')\" ><span id='itemFieldName_"+rowindex+"_span'>";
				if(itemFieldName==""){
					sHtml+="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				}
				sHtml+="</span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<%=formmanager.getItemFieldTypeSelectForAddMainRow(user)%>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				itemFieldType_index = $G("itemFieldType_"+fromRow).value;
				$G("itemFieldType_"+rowindex).value=itemFieldType_index;
				if(itemFieldType_index==1){
					var documentType_index = $G("documentType_"+fromRow).value;
					$G("documentType_"+rowindex).value=documentType_index;
					if(documentType_index == 1){
						$G("div1_1_"+rowindex).style.display="";
						doclength = $G("itemFieldScale1_"+fromRow).value;
						if(doclength!=""){
							$G("itemFieldScale1_"+rowindex).value = doclength;
							$G("itemFieldScale1span_"+rowindex).innerHTML = "";
						}
						$G("div1_3_"+rowindex).style.display="none";
						onChangType(rowindex);
					}else if(documentType_index == 3){
						$G("div1_1_"+rowindex).style.display="none";
						$G("div1_3_"+rowindex).style.display="inline";
						$G("decimaldigits_"+rowindex).value = $G("decimaldigits_"+fromRow).value;
					}else if(documentType_index == 5){
						$G("div1_1_"+rowindex).style.display="none";
						$G("div1_3_"+rowindex).style.display="inline";
						$G("decimaldigits_"+rowindex).value = $G("decimaldigits_"+fromRow).value;
					}else{
						$G("div1_1_"+rowindex).style.display="none";
						$G("div1_3_"+rowindex).style.display="none";
					}
				}
				if(itemFieldType_index==2){
					$G("div1_"+rowindex).style.display="none";
					$G("div1_1_"+rowindex).style.display="none";
					$G("div1_3_"+rowindex).style.display="none";
					$G("div2_"+rowindex).style.display="inline";
					$G("textheight_"+rowindex).value = $G("textheight_"+fromRow).value;
					$G("htmledit_"+rowindex).checked = $G("htmledit_"+fromRow).checked;
				}
				if(itemFieldType_index==3){
					$G("div1_"+rowindex).style.display="none";
					$G("div1_1_"+rowindex).style.display="none";
					$G("div1_3_"+rowindex).style.display="none";
					$G("div3_"+rowindex).style.display="inline";
					$G("broswerType_"+rowindex).value=$G("broswerType_"+fromRow).value;
					
					var broswerType_index = $G("broswerType_"+fromRow).value;
					//alert(broswerType_index);
					if(broswerType_index==161||broswerType_index==162){
						$G("div3_1_"+rowindex).style.display="inline";
						$G("div3_4_"+rowindex).style.display="none";
						//$G("definebroswerType_"+rowindex).value=$G("definebroswerType_"+fromRow).value;
					}
					if(broswerType_index==224||broswerType_index==225){
						$G("div3_1_"+rowindex).style.display="none";
						$G("div3_4_"+rowindex).style.display="inline";
						$G("div3_5_"+rowindex).style.display="none";
						
						if($G("sapbrowser_"+fromRow).value=="") $G("div3_0_"+rowindex).style.display="inline";
						$G("sapbrowser_"+rowindex).value=$G("sapbrowser_"+fromRow).value;
					}
					//zzl--start
					if(broswerType_index==226||broswerType_index==227){
							
							$G("div3_1_"+rowindex).style.display="none";
							$G("div3_4_"+rowindex).style.display="none";
							$G("div3_5_"+rowindex).style.display="inline";
							if($G("showvalue_"+fromRow).value=="")
							{
								$G("showimg_"+rowindex).style.display="inline";
							}else
							{
								//$G("showinner_"+rowindex).innerHTML=$G("showinner_"+fromRow).innerHTML;
								//$G("showvalue_"+rowindex).value=$G("showvalue_"+fromRow).value;
								//$G("showimg_"+rowindex).style.display="none";
							}
							
					}
					//zzl--end
					
					if(broswerType_index==165||broswerType_index==166||broswerType_index==167||broswerType_index==168){
						$G("div3_2_"+rowindex).style.display="inline";
						MainRightAttrDepat(rowindex);
						$G("decentralizationbroswerType_"+rowindex).value=$G("decentralizationbroswerType_"+fromRow).value;
					}
					if(broswerType_index==169||broswerType_index==170){
						$G("div3_2_"+rowindex).style.display="inline";
						$G("subcombroswerType_"+rowindex).value=$G("subcombroswerType_"+fromRow).value;
					}
					jQuery('#div3_'+rowindex + ' select').autoSelect({width:130});
					onChangBroswerType(rowindex, fromRow);
				}
				if(itemFieldType_index==4){
					$G("div1_"+rowindex).style.display="none";
					$G("div1_1_"+rowindex).style.display="none";
					$G("div1_3_"+rowindex).style.display="none";
				}
				if(itemFieldType_index==5){
					$G("div1_"+rowindex).style.display="none";
					$G("div1_1_"+rowindex).style.display="none";
					$G("div1_3_"+rowindex).style.display="none";
					$G("div5_"+rowindex).style.display="inline";
					//$G("div5_5_"+rowindex).style.display="inline";
					
					selectItemTypeChange('selectItemType',rowindex,fromRow);
					MainPubChoice(rowindex,fromRow);
    				MainPubchilchoiceId(rowindex,fromRow);
					setPreviewPub('','','',rowindex+"");
					setSelectItemType(rowindex+"");
				}
				if(itemFieldType_index==6){
					$G("div1_"+rowindex).style.display="none";
					$G("div1_1_"+rowindex).style.display="none";
					$G("div1_3_"+rowindex).style.display="none";
					
					onChangItemFieldType(rowindex);
					var _uploadtype_fromRow = $G("uploadtype_"+fromRow);
					var _uploadtype_rowindex = $G("uploadtype_"+rowindex);
					for(var itemFieldType_i=0;itemFieldType_i<_uploadtype_rowindex.options.length;itemFieldType_i++){
						_uploadtype_rowindex.options[itemFieldType_i].selected
							=_uploadtype_fromRow.options[itemFieldType_i].selected;
						if(_uploadtype_fromRow.options[itemFieldType_i].selected){
							break;
						}
					}
					onuploadtype(_uploadtype_rowindex, rowindex);
					var uploadtype_value = _uploadtype_fromRow.value;
					if(uploadtype_value==2){
						$G("strlength_"+rowindex).value=$G("strlength_"+fromRow).value;
						$G("imgwidth_"+rowindex).value=$G("imgwidth_"+fromRow).value;
						$G("imgheight_"+rowindex).value=$G("imgheight_"+fromRow).value;
					}
				}
				if(itemFieldType_index==7){
					$G("div1_"+rowindex).style.display="none";
					$G("div1_1_"+rowindex).style.display="none";
					$G("div1_3_"+rowindex).style.display="none";
				    $G("div7_"+rowindex).style.display="inline";
				    var specialfieldtype = $G("specialfield_"+fromRow).value;

				    if(specialfieldtype==1){
					    $G("div7_1_"+rowindex).style.display="";
					    $G("div7_2_"+rowindex).style.display="none";
					    $G("displayname_"+rowindex).value = $G("displayname_"+fromRow).value;
					    $G("linkaddress_"+rowindex).value = $G("linkaddress_"+fromRow).value;					
					}else{
					    $G("div7_1_"+rowindex).style.display="none";
					    $G("div7_2_"+rowindex).style.display="";
				    	$G("descriptivetext_"+rowindex).value = $G("descriptivetext_"+fromRow).value;					
					}
				}
				break;	
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = " <input class='InputStyle' type='text' size=10 maxlength=7 name='itemDspOrder_"+rowindex+"' value='"+(rowindex*1 +1)+".00' onKeyPress='ItemNum_KeyPress(\"itemDspOrder_"+rowindex+"\")' onchange='checknumber(\"itemDspOrder_"+rowindex+"\");checkDigit(\"itemDspOrder_"+rowindex+"\",15,2)'  style='text-align:right;'>";
						   
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;				
			case 5:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<button type=button  class=\"Browser\" onClick=\"onShowChildSelectItem('childItemSpan_"+index+"_"+choicerowindex+"','childItem_"+index+"_"+choicerowindex+"','_"+index+"')\" id=\"selectChildItem_"+index+"_"+choicerowindex+"\" name=\"selectChildItem_"+index+"_"+choicerowindex+"\"></BUTTON>"
							+ "<input type=\"hidden\" id=\"childItem_"+index+"_"+choicerowindex+"\" name=\"childItem_"+index+"_"+choicerowindex+"\" value=\"\" >"
							+ "<span id=\"childItemSpan_"+index+"_"+choicerowindex+"\" name=\"childItemSpan_"+index+"_"+choicerowindex+"\"></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
		}
	  }
	  rowindex = rowindex*1 +1;
	  //jQuery("body").jNice();
	  //$("#oTable").find("select").selectbox();
	  //jQuery(oRow).jNice();
	  //jQuery(oRow).find("select").selectbox();
	}
}
function onChangType(rowNum){
	itemFieldType = $G("documentType_"+rowNum).value;
	if(itemFieldType==1){
		$G("div1_1_"+rowNum).style.display='inline';
		$G("div1_3_"+rowNum).style.display='none';
		$G("div2_"+rowNum).style.display='none';
	}else if(itemFieldType==3){
		$G("div1_1_"+rowNum).style.display='none';
		$G("div1_3_"+rowNum).style.display='inline';
		$G("div2_"+rowNum).style.display='none';
	}else if(itemFieldType==5){
		$G("div1_1_"+rowNum).style.display='none';
		$G("div1_3_"+rowNum).style.display='inline';
		$G("div2_"+rowNum).style.display='none';
	}else{
		$G("div1_1_"+rowNum).style.display='none';
		$G("div1_3_"+rowNum).style.display='none';
		$G("div2_"+rowNum).style.display='none';
	}
}
function onfirmhtml(index){
	if ($G("htmledit_"+index).checked==true){
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(20867,user.getLanguage())%>');
		$G("htmledit_"+index).value=2;
	}
	//else{
	//	$G("htmledit_"+index).value=1;
	//}
}
function onChangItemFieldType(rowNum){

		itemFieldType = $G("itemFieldType_"+rowNum).value;

		if(itemFieldType==1){
			$G("div1_"+rowNum).style.display='inline';
			$G("div1_1_"+rowNum).style.display='inline';
			$G("documentType_"+rowNum).selectedIndex=0;
			//jQuery("name=[documentType_"+rowNum+"]").selectbox("detach");
			//jQuery("name=[documentType_"+rowNum+"]").selectbox("attach");
        	$G("div9_"+rowNum).style.display='none';
			//$G("div9_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
			$G("div3_"+rowNum).style.display='none';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			//zzl
			$G("div3_5_"+rowNum).style.display='none';
			$G("div3_7_"+rowNum).style.display='none';
			$G("div5_"+rowNum).style.display='none';
			//$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		}
		if(itemFieldType==2){
        	$G("div9_"+rowNum).style.display='none';
			//$G("div9_1_"+rowNum).style.display='none';		
			$G("div1_"+rowNum).style.display='none';
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='inline';
			$G("div3_"+rowNum).style.display='none';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			
			//zzl
			$G("div3_5_"+rowNum).style.display='none';
			$G("div3_7_"+rowNum).style.display='none';
			
			$G("div5_"+rowNum).style.display='none';
			//$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		}
		if(itemFieldType==3){
        	$G("div9_"+rowNum).style.display='none';
			//$G("div9_1_"+rowNum).style.display='none';		
			$G("div1_"+rowNum).style.display='none';
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
			$G("div3_"+rowNum).style.display='inline';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			//zzl
			$G("div3_5_"+rowNum).style.display='none';
			$G("div3_7_"+rowNum).style.display='none';
			
			$G("div5_"+rowNum).style.display='none';
			//$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		    sortOption($("#div3_"+rowNum+" select")[0]);
		    if($G("broswerType_"+rowNum).value==224){
		    	$G("div3_4_"+rowNum).style.display='inline';
			}
			
			if($G("broswerType_"+rowNum).value==226||$G("broswerType_"+rowNum).value==227){
		    	$G("div3_5_"+rowNum).style.display='inline';
			}
			jQuery('#div3_'+rowNum + ' select').autoSelect({width:130});
			onChangBroswerType(rowNum);
		}
		if(itemFieldType==4){
        	$G("div9_"+rowNum).style.display='none';
			//$G("div9_1_"+rowNum).style.display='none';		
			$G("div1_"+rowNum).style.display='none';
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
			$G("div3_"+rowNum).style.display='none';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			//zzl
			$G("div3_5_"+rowNum).style.display='none';
			$G("div3_7_"+rowNum).style.display='none';
			$G("div5_"+rowNum).style.display='none';
			//$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		}
        if(itemFieldType==5){        
        	$G("div9_"+rowNum).style.display='none';
			//$G("div9_1_"+rowNum).style.display='none';        
			$G("div1_"+rowNum).style.display='none';
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
			$G("div3_"+rowNum).style.display='none';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			//zzl
			$G("div3_5_"+rowNum).style.display='none';
			$G("div3_7_"+rowNum).style.display='none';
			$G("div5_"+rowNum).style.display='inline';
			//$G("div5_5_"+rowNum).style.display='inline';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		    
		    setSelectItemType(rowNum+"");
		}
        if(itemFieldType==6){
            $G("strlength_"+rowNum).value='5';
            $G("imgwidth_"+rowNum).value='100';
            $G("imgheight_"+rowNum).value='100';
            $G("div9_"+rowNum).style.display='none';
			//$G("div9_1_"+rowNum).style.display='none';
			$G("div1_"+rowNum).style.display='none';
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
			$G("div3_"+rowNum).style.display='none';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			//zzl
			$G("div3_5_"+rowNum).style.display='none';
			$G("div3_7_"+rowNum).style.display='none';
			$G("div5_"+rowNum).style.display='none';
			//$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="inline";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
            $G("uploadtype_"+rowNum).options[0].selected=true;
		}
        if(itemFieldType==7){
        	$G("div9_"+rowNum).style.display='none';
			//$G("div9_1_"+rowNum).style.display='none';
			$G("div1_"+rowNum).style.display='none';
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
			$G("div3_"+rowNum).style.display='none';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			//zzl
			$G("div3_5_"+rowNum).style.display='none';
			$G("div3_7_"+rowNum).style.display='none';
			$G("div5_"+rowNum).style.display='none';
			//$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="inline";
		    $G("div7_1_"+rowNum).style.display="";
		    $G("div7_2_"+rowNum).style.display="none";
            $G("specialfield_"+rowNum).options[0].selected=true;
		}
		if(itemFieldType==9){
			$G("div9_"+rowNum).style.display='inline';
			//$G("div9_1_"+rowNum).style.display='inline';
			$G("documentType_"+rowNum).selectedIndex=0;
			//jQuery("name=[documentType_"+rowNum+"]").selectbox("detach");
			//jQuery("name=[documentType_"+rowNum+"]").selectbox("attach");
			$G("div1_"+rowNum).style.display='none';
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
			$G("div3_"+rowNum).style.display='none';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			//zzl
			$G("div3_5_"+rowNum).style.display='none';
			$G("div3_7_"+rowNum).style.display='none';
			$G("div5_"+rowNum).style.display='none';
			//$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		    
		}
	
}
function onuploadtype(obj,index) {
    if (obj.value == 1) {
        $G("div6_1_" + index).style.display = "none";
    } else {
        $G("div6_1_" + index).style.display = "";
    }
}

function onDetailuploadtype(obj,tableid,index) {
    if (obj.value == 1) {
        $G("detail_div6_1_" + tableid+"_"+index).style.display = "none";
    } else {
        $G("detail_div6_1_" + tableid+"_"+index).style.display = "inline";
    }
}

function specialtype(obj,index){
    if(obj.value==1){
        $G("div7_1_"+index).style.display="";
	    $G("div7_2_"+index).style.display="none";
    }else{
        $G("div7_1_"+index).style.display="none";
	    $G("div7_2_"+index).style.display="";
    }
}

//zzl
function OnNewChangeSapBroswerType(tempindex)
{
	var updateTableName="";//"",表示integrationBatchOA.jsp页面默认查主表字段
	var browsertype=$G("broswerType_"+tempindex).value;
	var showinner=$G("showinner_"+tempindex);
	var mark=showinner.innerHTML;
	var showimg=$G("showimg_"+tempindex);
	var showvalue=$G("showvalue_"+tempindex);
	var left = Math.ceil((screen.width - 1086) / 2);   //实现居中
    var top = Math.ceil((screen.height - 600) / 2);  //实现居中
    var urls = "/integration/browse/integrationBrowerMain.jsp?browsertype="+browsertype+"&mark="+mark+"&formid=<%=formid%>";
	var tempstatus = "dialogWidth:1086px;dialogHeight:600px;scroll:yes;status:no;dialogLeft:"+left+";dialogTop:"+top+";";
    var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = urls;
	dialog.callbackfun = function (temp) {
		if(temp)
		{
			showvalue.value=temp;
			showinner.innerHTML=temp;
			showimg.innerHTML="";
			
		}
		showimg.style.display='';
	}
	dialog.Title = "SAP";
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.maxiumnable = true;
	dialog.DefaultMax = true;
	dialog.show();
}


//zzl
function OnNewChangeSapBroswerTypeDetails(detailtables,detailrowindex)
{
	var updateTableName="";
	try
	{
	 	updateTableName=$G("detailTable_name_"+detailtables).value;//得到主表或明细表的名字
	}catch(e)
	{
		//报错，表示是新添加的明细表	
		updateTableName="_dt";//表示是明细表
	}
	
	var browsertype=$G("broswerType_"+detailtables+"_"+detailrowindex).value;
	var showinner=$G("showinner_"+detailtables+"_"+detailrowindex);
	var mark=$G("showinner_"+detailtables+"_"+detailrowindex).innerHTML;
	var showimg=$G("showimg_"+detailtables+"_"+detailrowindex);
	var showvalue=$G("showvalue_"+detailtables+"_"+detailrowindex);
	var left = Math.ceil((screen.width - 1086) / 2);   //实现居中
    var top = Math.ceil((screen.height - 600) / 2);  //实现居中
    var tempstatus = "dialogWidth:1086px;dialogHeight:600px;scroll:yes;status:no;dialogLeft:"+left+";dialogTop:"+top+";";
	var urls = "/integration/browse/integrationBrowerMain.jsp?browsertype="+browsertype+"&mark="+mark+"&formid=<%=formid%>&updateTableName="+updateTableName;
    //var temp=window.showModalDialog(urls,"",tempstatus);
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = urls;
	dialog.callbackfun = function (temp) {
		if(temp)
		{
			showvalue.value=temp;
			showinner.innerHTML=temp;
			showimg.innerHTML="";
			
		}
		showimg.style.display='';
	}
	dialog.Title = "SAP";
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.maxiumnable = true;
	dialog.DefaultMax = true;
	
	
	dialog.show();
	
	
	
}
	
function onChangBroswerType(index, fromIndex){
	broswerType = $G("broswerType_"+index).value;
	if (broswerType == '') {
   		jQuery('#div3_' + index + ' .selecthtmltypespan').show();
   	} else {
   		jQuery('#div3_' + index + ' .selecthtmltypespan').hide();
   	}
	$G("div3_7_"+index).style.display='none';
	if(broswerType==161||broswerType==162){
		$G("div3_1_"+index).style.display='inline';
		if (jQuery('#div3_1_' + index + ' #definebroswerType_' + index).length == 0) {
			var bv = '';
		    var bsv = '';
		    if (fromIndex != null) {
		    	bv = jQuery('#definebroswerType_' + fromIndex).val();
		    	bsv = jQuery('#definebroswerType_' + fromIndex + 'span span a').text();
		    }
			jQuery('#div3_1_' + index + ' span').e8Browser({
			   name:"definebroswerType_" + index,
			   browserValue:bv,
			   browserSpanValue:bsv,
			   viewType:"0",
			   hasInput:false,
			   isSingle:true,
			   hasBrowser:true, 
			   isMustInput:2,
			   completeUrl:"/data.jsp",
			   width:"130px",
			   browserUrl:"/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp",
			   _callback:"setChange1"
			});
		}
		
		$G("div3_4_"+index).style.display="none"
		//zzl
		$G("div3_5_"+index).style.display='none';
	}else if(broswerType==256||broswerType==257){
		
		$G("div3_0_"+index).style.display='none';
		$G("div3_1_"+index).style.display='none';
		$G("div3_4_"+index).style.display="none"
		//zzl
		$G("div3_5_"+index).style.display='none';
		$G("div3_7_"+index).style.display='inline';
			
		if (jQuery('#div3_7_' + index + ' #defineTreeBroswerType_' + index).length == 0) {
		    var bv = '';
		    var bsv = '';
		    if (fromIndex != null) {
		    	bv = jQuery('#defineTreeBroswerType_' + fromIndex).val();
		    	bsv = jQuery('#defineTreeBroswerType_' + fromIndex + 'span span a').text();
		    }
			jQuery('#div3_7_' + index + ' span').e8Browser({
			   name:"defineTreeBroswerType_" + index,
			   browserValue:bv,
			   browserSpanValue:bsv,
			   viewType:"0",
			   hasInput:false,
			   isSingle:true,
			   hasBrowser:true, 
			   isMustInput:2,
			   completeUrl:"/data.jsp",
			   width:"105px",
			   browserUrl:"/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/TreeBrowser.jsp",
				_callback:"setChange1"
			});
		}
	}else if(broswerType==224||broswerType==225){
		$G("div3_1_"+index).style.display='none';
		$G("div3_4_"+index).style.display='inline';
		//zzl
		$G("div3_5_"+index).style.display='none';
		
		var sapbrowserOptionValue = $G("sapbrowser_"+index).value;
		if(sapbrowserOptionValue==''||sapbrowserOptionValue==0){
		    $G("div3_0_"+index).style.display="inline"
		}else{
		    $G("div3_0_"+index).style.display="none"
		}
	}else if(broswerType==226||broswerType==227){
		//zzl
		$G("div3_1_"+index).style.display='none';
		$G("div3_4_"+index).style.display='none';
		$G("div3_5_"+index).style.display='inline';
		var sapbrowserOptionValue = $G("showvalue_"+index).value;
		$("#newsapbrowser_"+index).css("height","16px");
		$("#newsapbrowser_"+index).css("height","16px");
		$("#newsapbrowser_"+index).css("vertical-align","middle");
		$("#newsapbrowser_"+index).css("background-color","transparent");
		if(sapbrowserOptionValue==''){
		    $G("showimg_"+index).style.display="inline"
		}else{
		    $G("showimg_"+index).style.display="none"
		}
	}
	else{
		$G("div3_0_"+index).style.display='none';
		$G("div3_1_"+index).style.display='none';
		$G("div3_4_"+index).style.display='none';
		$G("div3_5_"+index).style.display='none';
	}
	if(broswerType==165||broswerType==166||broswerType==167||broswerType==168){
		$G("div3_2_"+index).style.display='inline';
		MainRightAttrDepat(index);
	}else{
		$G("div3_2_"+index).style.display='none';
	}
	BTCOpen($("[name=broswerType_"+index+"]"));
}
function div3_0_show(index){
	div3_1_value = $G("definebroswerType_"+index).value;
	if(div3_1_value=="")
		$G("div3_0_"+index).style.display='inline';
	else
		$G("div3_0_"+index).style.display='none';
}
function div3_4_show(index){
	div3_4_value = $G("sapbrowser_"+index).value;
	if(div3_4_value=="")
		$G("div3_0_"+index).style.display='inline';
	else
		$G("div3_0_"+index).style.display='none';
}

//主表选择框字段删除选项
function submitClear(index){
  setChange(index);
  var flag = false;
	var ids = document.getElementsByName('chkField');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
    	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
    	top.Dialog.confirm(str, function (){
    		deleteRow1(index);
    	}, function () {}, 320, 90,true);
    }else{
    	top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}

//主表选择框字段删除选项
function deleteRow1(index){
	$("input[name=chkField]").each(function(){
		var obj = $(this);
		if(obj.attr("checked")){
			obj.closest("tr").remove();
		}
	});	
}

function cancleback(){
	var dialog = parent.getDialog(window);
	dialog.close();
}

//主表字段 选择框 添加选项
function addoTableRow(index){
  setChange(index);
  rowColor1 = getRowBg();
  obj1 = $G("choiceTable_"+index);
  choicerowindex = $G("choiceRows_"+index).value*1+1;
  $G("choiceRows_"+index).value = choicerowindex;
	ncol1 = obj1.rows[0].cells.length;
	oRow1 = obj1.insertRow(-1);
	for(j=0; j<ncol1; j++) {
		oCell1 = oRow1.insertCell(-1);
		oCell1.style.height=24;
		oCell1.style.background="#fff";
		switch(j) {
			case 0:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input   type='checkbox' name='chkField' index='"+choicerowindex+"' value='0'>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 1:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input class='InputStyle' type='text' size='10' name='field_"+index+"_"+choicerowindex+"_name' style='width=90%'"+
							" onchange=\"checkinput('field_"+index+"_"+choicerowindex+"_name','field_"+index+"_"+choicerowindex+"_span'),setChange("+index+")\">"+
							" <span id='field_"+index+"_"+choicerowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 2:
				var oDiv1 = document.createElement("div");
				var sHtml1 = " <input class='InputStyle' type='text' size='4' value = '0.00' onchange='setChange("+index+")' name='field_count_"+index+"_"+choicerowindex+"_name' style='width=90%'"+
							" onKeyPress=ItemNum_KeyPress('field_count_"+index+"_"+choicerowindex+"_name') onchange=checknumber('field_count_"+index+"_"+choicerowindex+"_name')>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 3:
				var oDiv1 = document.createElement("div");
				var sHtml1 = " <input type='checkbox' name='field_checked_"+index+"_"+choicerowindex+"_name' onchange='setChange("+index+")' onclick='if(this.checked){this.value=1;}else{this.value=0}'>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 4:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input type='checkbox' name='isAccordToSubCom"+index+"_"+choicerowindex+"' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;"
							+ "<button type=button  class=Browser onClick=\"onShowCatalog(mypath_"+index+"_"+choicerowindex+","+index+","+choicerowindex+")\" name=selectCategory></BUTTON>"
							+ "<span id=mypath_"+index+"_"+choicerowindex+"></span>"
						    + "<input type=hidden id='pathcategory_" + index + "_"+choicerowindex+"' name='pathcategory_" + index + "_"+choicerowindex+"' value=''>"
						    + "<input type=hidden id='maincategory_" + index + "_"+choicerowindex+"' name='maincategory_" + index + "_"+choicerowindex+"' value=''>";

				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 5:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<button type=button  class=\"Browser\" onClick=\"onShowChildSelectItem('childItemSpan_"+index+"_"+choicerowindex+"', 'childItem_"+index+"_"+choicerowindex+"','_"+index+"')\" id=\"selectChildItem_"+index+"_"+choicerowindex+"\" name=\"selectChildItem_"+index+"_"+choicerowindex+"\" style='margin-top:4px;'></BUTTON>"
							+ "<input type=\"hidden\" id=\"childItem_"+index+"_"+choicerowindex+"\" name=\"childItem_"+index+"_"+choicerowindex+"\" value=\"\" >"
							+ "<span id=\"childItemSpan_"+index+"_"+choicerowindex+"\" name=\"childItemSpan_"+index+"_"+choicerowindex+"\"></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
		}		
	}
	//jQuery("body").jNice();
	//jQuery(oRow1).jNice();
}


function onShowCatalog(spanName, index, choicerowindex){
	var isAccordToSubCom=0;
	if($G("isAccordToSubCom"+index+"_"+choicerowindex)!=null){
		if($G("isAccordToSubCom"+index+"_"+choicerowindex).checked){
			isAccordToSubCom=1;
		}
	}
	if(isAccordToSubCom==1){
		onShowCatalogSubCom();
	}else{
		onShowCatalogHis(spanName, index, choicerowindex);
	}
}

function onShowCatalogHis(spanName, index, choicerowindex) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
    if (result != null){
        if (wuiUtil.getJsonValueByIndex(result,0)> 0){
        		setChange(index);
            spanName.innerHTML=wuiUtil.getJsonValueByIndex(result,2);
            $G("pathcategory_"+index+"_"+choicerowindex).value=wuiUtil.getJsonValueByIndex(result,2);
            $G("maincategory_"+index+"_"+choicerowindex).value=wuiUtil.getJsonValueByIndex(result,3)+","+wuiUtil.getJsonValueByIndex(result,4)+","+wuiUtil.getJsonValueByIndex(result,1);
        }else{
            spanName.innerHTML="";
            $G("pathcategory_"+index+"_"+choicerowindex).value="";
            $G("maincategory_"+index+"_"+choicerowindex).value="";
       }
    }
}

function onShowCatalogSubCom() {
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24460,user.getLanguage())%>");
}

function check_formself(thiswins, items){
	if(items == ""){
		return true;
	}
	var itemlist = items.split(",");
	for(var i=0;i<itemlist.length;i++){
		if($G(itemlist[i])){
			var tmpname = $G(itemlist[i]).name;
			var tmpvalue = $G(itemlist[i]).value;
			if(tmpvalue==null){
				continue;
			}
			while(tmpvalue.indexOf(" ") >= 0){
				tmpvalue = tmpvalue.replace(" ", "");
			}
			while(tmpvalue.indexOf("\r\n") >= 0){
				tmpvalue = tmpvalue.replace("\r\n", "");
			}

			if(tmpvalue == ""){
				if($G(itemlist[i]).getAttribute("temptitle")!=null){
					top.Dialog.alert("\""+$G(itemlist[i]).getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
					return false;
				}else{
					top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
					return false;
				}
			}
		}
	}
	return true;
}

function BTCOpen(thisObj){
            //清空已有BTC对象
            var btc = new BTC();
            var tempBtc;
            while(tempBtc = BTCArray.shift()){
              thisObj.next("span").find(".sbToggle").removeClass("sbToggle-btc-reverse")
              tempBtc.remove();
            }
    	    //浏览框类型选择框处理
            thisObj.next("span").find(".sbToggle").addClass("sbToggle-btc");
            thisObj.next("span").find(".sbToggle").unbind("click");
            thisObj.next("span").find(".sbSelector").unbind("focus");
            thisObj.next("span").find(".sbSelector").unbind("click"); 
            thisObj.next("span").find(".sbSelector").unbind("blur");    
            thisObj.next("span").find(".sbSelector").css("text-indent","0"); 
            <%
            if (HrmUserVarify.checkUserRight("SysadminRight:Maintenance", user)){ 
            %>
            thisObj.next("span").find(".sbHolder").next(".btc_type_edit").remove();
            thisObj.next("span").find(".sbHolder").after("<img onclick='setBTC()' style='cursor:pointer;' class='btc_type_edit' src='/images/ecology8/workflow/setting_wev8.png'>");
    	    thisObj.next("span").css("width",thisObj.next("span").width()+15);
    	    thisObj.next("span").css("display","inline");
    	    <%}%>    
            thisObj.next("span").find(".sbSelector").bind("focus",function(){
				    if(thisObj.next("span").find(".sbToggle").hasClass("sbToggle-btc-reverse")){
				       if(BTCArray.length>0){
				       	thisObj.next("span").find(".sbToggle").trigger("click");
				       }
				    };
			});
			
			thisObj.next("span").find(".sbToggle").bind("click",function(){
			   if(thisObj.next("span").find(".sbToggle").hasClass("sbToggle-btc-reverse")){
               	  btc.remove();
			   }else{
			   	  btc.init({
					  renderTo:thisObj.next("span").find(".sbHolder"),
				      headerURL:"/workflow/field/BTCAjax.jsp?action=queryHead",
					  contentURL:"/workflow/field/BTCAjax.jsp?action=queryContent&isFromMode=<%=isFromMode%>",
					  contentHandler:function(value){
						    thisObj.val(value);
						    thisObj.trigger("change");
						    btc.remove();
					  }
			  	  });  
			  	  btc.setContainerStyle(['top','right','min-height'],['25px','auto','150px']);
			  	  try{
			   	  	 $("#e8_autocomplete_div").hide();			
		          }catch(e){}
			   }
			   thisObj.next("span").find(".sbToggle").toggleClass("sbToggle-btc-reverse");
	});
}  

 function setBTC(){
            var url = "/systeminfo/BrowserMain.jsp?url=/workflow/field/browsertypesetting.jsp?isFromMode=<%=isFromMode%>";
            var dlg=new window.top.Dialog();//定义Dialog对象
			var title = "<%=SystemEnv.getHtmlLabelName(125117, user.getLanguage())%>";
			dlg.Width=550;//定义长度
			dlg.Height=600;
			dlg.URL=url;
			dlg.Title=title;
			dlg.show();
    }

var dbfieldnames = "<%=dbfieldnamesForCompare%>";
function onSave(obj){
	changeRows = 0;
	var changeRowIndexsArray;
	if(changeRowIndexs!=","){
		changeRowIndexsArray = changeRowIndexs.substring(1,changeRowIndexs.length-1).split(",");
		changeRows = changeRowIndexsArray.length;
	}
	var itemDspNames = ",";
	for(i=0;i<changeRows;i++){//主字段检查
			j=changeRowIndexsArray[i];
			check_String = "itemDspName_"+j+",itemFieldName_"+j;
			if(check_formself(frmMain,check_String)){
				if (!!!$G("itemFieldType_"+j)) {
					continue;
				}
				if($G("documentType_"+j).value==1&&$G("itemFieldType_"+j).value==1){
					if($G("itemFieldScale1_"+j).value==""){//单行文本框的文本长度必填
						top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if($G("itemFieldType_"+j).value==3&&$G("broswerType_"+j).value==''){
					top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return;
				}
				if($G("itemFieldType_"+j).value==3&&($G("broswerType_"+j).value==161||$G("broswerType_"+j).value==162)){
					if($G("definebroswerType_"+j).value==""){//自定义浏览框必选
						top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if($G("itemFieldType_"+j).value==3&&($G("broswerType_"+j).value==256||$G("broswerType_"+j).value==257)){
					if($G("defineTreeBroswerType_"+j).value==""){//自定义浏览框必选
						top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if($G("itemFieldType_"+j).value==3&&($G("broswerType_"+j).value==224||$G("broswerType_"+j).value==225)){
					if($G("sapbrowser_"+j).value==""){//自定义浏览框必选
						top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if($G("itemFieldType_"+j).value==3&&($G("broswerType_"+j).value==165||$G("broswerType_"+j).value==166||$G("broswerType_"+j).value==167||$G("broswerType_"+j).value==168)){
					if(document.all("decentralizationbroswerType_"+j).value==""){//人力、部门分权 必填属性
						top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}				
				//zzl
				if($G("itemFieldType_"+j).value==3&&($G("broswerType_"+j).value==226||$G("broswerType_"+j).value==227)){
					if($G("showvalue_"+j).value==""){//zzl集成按钮必填
						top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				
				if($G("itemFieldType_"+j).value==5){//选择框可选项文字check
					var selectItemType = jQuery("#selectItemType"+j).val();
				    if(selectItemType==0){
				    
				    }else if(selectItemType==1){
				    	if(!check_form(frmMain,"pubchoiceId"+j)){
				    		return;
				    	}
				    }else if(selectItemType==2){
				    	if(!check_form(frmMain,"pubchilchoiceId"+j)){
				    		return;
				    	}
				    }
					
				}
				var itemDspName = $G("itemDspName_"+j).value;
				itemDspName = itemDspName.toUpperCase();
				if(itemDspName=="ID"||itemDspName=="REQUESTID"){
					top.Dialog.alert(itemDspName+"<%=SystemEnv.getHtmlLabelName(21810,user.getLanguage())%>");
					$G("itemDspName_"+j).select();
					return;
				}
				if(dbfieldnames.indexOf(","+itemDspName.toUpperCase()+",")>=0||itemDspNames.indexOf(","+itemDspName.toUpperCase()+",")>=0){//数据库字段名称不能重复
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>");
					$G("itemDspName_"+j).select();
					return;
				}else{itemDspNames += itemDspName.toUpperCase()+",";}
			}else{
				return;
			}
	}
	var detailTableNums = $G("detailtables").value;
	var detailtableIndexs = $G("detailtableIndexs").value;
	var detailtableIndexsArray;
	if(detailtableIndexs!=",")
		detailtableIndexsArray = detailtableIndexs.substring(0,detailtableIndexs.length-1).split(",");
	for(var tempi=1;tempi<=detailTableNums;tempi++){//明细字段检查
		var i = detailtableIndexsArray[tempi];
		var detailTableChangeRows = 0;
		var detailTableChangeRowsArray;
		var detailChangeRowIndexs = $G("detailChangeRowIndexs_"+i).value;
		if(detailChangeRowIndexs!=""){
			detailTableChangeRowsArray = detailChangeRowIndexs.substring(0,detailChangeRowIndexs.length-1).split(",");
			detailTableChangeRows = detailTableChangeRowsArray.length;
		}
		
		var dbfieldnames_detail = "";
		if($G("dbdetailfieldnamesForCompare_"+i))
			dbfieldnames_detail = $G("dbdetailfieldnamesForCompare_"+i).value;
		var itemDspNamesDetail = ",";
		for(var j=0;j<detailTableChangeRows;j++){
			var tIndex = detailTableChangeRowsArray[j];
			check_String = "itemDspName_detail"+i+"_"+tIndex+",itemFieldName_detail"+i+"_"+tIndex;
			if(check_formself(frmMain,check_String)){
				if($G("documentType_"+i+"_"+tIndex).value==1&&$G("itemFieldType_"+i+"_"+tIndex).value==1){//单行文本框的文本长度必填
					if($G("itemFieldScale1_"+i+"_"+tIndex).value==""){
						top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if($G("itemFieldType_"+i+"_"+tIndex).value==3&&$G("broswerType_"+i+"_"+tIndex).value==''){
					top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return;
				}
				if($G("itemFieldType_"+i+"_"+tIndex).value==3&&($G("broswerType_"+i+"_"+tIndex).value==161||$G("broswerType_"+i+"_"+tIndex).value==162)){
					if($G("definebroswerType_"+i+"_"+tIndex).value==""){//自定义浏览框必选
						top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if($G("itemFieldType_"+i+"_"+tIndex).value==3&&($G("broswerType_"+i+"_"+tIndex).value==256||$G("broswerType_"+i+"_"+tIndex).value==257)){
					if($G("defineTreeBroswerType_"+i+"_"+tIndex).value==""){//自定义浏览框必选
						top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if($G("itemFieldType_"+i+"_"+tIndex).value==3&&($G("broswerType_"+i+"_"+tIndex).value==224||$G("broswerType_"+i+"_"+tIndex).value==225)){
					if($G("sapbrowser_"+i+"_"+tIndex).value==""){//自定义浏览框必选
						top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if($G("itemFieldType_"+i+"_"+tIndex).value==3&&($G("broswerType_"+i+"_"+tIndex).value==165||$G("broswerType_"+i+"_"+tIndex).value==166||$G("broswerType_"+i+"_"+tIndex).value==167||$G("broswerType_"+i+"_"+tIndex).value==168)){
					if($G("decentralizationbroswerType_"+i+"_"+tIndex).value==""){//人力、部门分权 必填属性
						top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}				
				//zzl
				if($G("itemFieldType_"+i+"_"+tIndex).value==3&&($G("broswerType_"+i+"_"+tIndex).value==226||$G("broswerType_"+i+"_"+tIndex).value==227)){
					if($G("showvalue_"+i+"_"+tIndex).value==""){//集成按钮必选
						top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				
				if($G("itemFieldType_"+i+"_"+tIndex).value==5){//选择框可选项文字check
										
					var selectItemType = jQuery("#selectItemType"+i+"_"+tIndex).val();
				    if(selectItemType==0){
				    
				    }else if(selectItemType==1){
				    	if(!check_form(frmMain,"pubchoiceId"+i+"_"+tIndex)){
				    		return;
				    	}
				    }else if(selectItemType==2){
				    	if(!check_form(frmMain,"pubchilchoiceId"+i+"_"+tIndex)){
				    		return;
				    	}
				    }
				}
				var itemDspNameDetail = $G("itemDspName_detail"+i+"_"+tIndex).value;
				itemDspNameDetail = itemDspNameDetail.toUpperCase();
				if(itemDspNameDetail=="ID"||itemDspNameDetail=="MAINID"){
					top.Dialog.alert(itemDspNameDetail+"<%=SystemEnv.getHtmlLabelName(21810,user.getLanguage())%>");
					$G("itemDspName_detail"+i+"_"+tIndex).select();
					return;
				}
				if(dbfieldnames_detail.indexOf(","+itemDspNameDetail.toUpperCase()+",")>=0||itemDspNamesDetail.indexOf(","+itemDspNameDetail.toUpperCase()+",")>=0){//数据库字段名称不能重复
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>");
					$G("itemDspName_detail"+i+"_"+tIndex).select();
					return;
				}else{itemDspNamesDetail += itemDspNameDetail.toUpperCase()+",";}

			}else{
				return;
			}
		}
	}
	
	//主字段中的选择框转换
	for(i=0;i<changeRows;i++){
		j=changeRowIndexsArray[i];
		
		if (!!!$G("itemFieldType_"+j)) {
			continue;
		}
		
		//只对选择框进行处理
		//if($G("itemFieldType_"+j).value == 5){
		//	var choiceRows = $G("choiceRows_"+j).value * 1;
			//遍历选择框的所有选项
		//	for(var tempchoiceRows=1; tempchoiceRows<=choiceRows; tempchoiceRows++){
		//		var optionObj = $G("field_"+j+"_"+tempchoiceRows+"_name");
		//		if(optionObj != null){
		//			optionObj.value = dealSpecial(optionObj.value);
		//		}
		//	}
		//}
	}
	
	//对每个明细表中的选择框进行转换
	for(var tempi=1;tempi<=detailTableNums;tempi++){
		var i = detailtableIndexsArray[tempi];
		var detailTableChangeRows = 0;
		var detailTableChangeRowsArray;
		var detailChangeRowIndexs = $G("detailChangeRowIndexs_"+i).value;
		if(detailChangeRowIndexs!=""){
			detailTableChangeRowsArray = detailChangeRowIndexs.substring(0,detailChangeRowIndexs.length-1).split(",");
			detailTableChangeRows = detailTableChangeRowsArray.length;
		}
		
		//遍历单个明细表中的每个字段
		//for(var j=0;j<detailTableChangeRows;j++){
		//	var tIndex = detailTableChangeRowsArray[j];
		//	if($G("itemFieldType_"+i+"_"+tIndex).value==5){
		//		var choiceRows = $G("choiceRows_"+i+"_"+tIndex).value * 1;
		//		for(var tempchoiceRows=1;tempchoiceRows<=choiceRows;tempchoiceRows++){
		//			var optionObj = $G("field_"+i+"_"+tIndex+"_"+tempchoiceRows+"_name");
		//			if(optionObj != null){
		//				optionObj.value = dealSpecial(optionObj.value);
		//			}
		//		}
		//	}
		//}
	}
	try{
		var jumpRowindex = jQuery("#jumpRowindex").val();
		if(jumpRowindex!=""){ //点击独立下拉框 维护选项时，判断是独立选择框 才弹出维护选项
		    var selectItemType = jQuery("#selectItemType"+jumpRowindex).val();
			var itemFieldType = $G("itemFieldType_"+jumpRowindex).value;
			if(itemFieldType!="5" || selectItemType !="0"){
				jQuery("#jumpRowindex").val("");
			}
		}
	}catch(e){}
	
	var checksuccess = checkPubchilchoiceId();
	if(!checksuccess){
		return;
	}
	
	obj.disabled=true;
	document.frmMain.recordNum.value=rowindex;
	document.frmMain.delids.value=delids;
	document.frmMain.changeRowIndexs.value=changeRowIndexs;	
	document.frmMain.submit();
	//enableAllmenu();
}

/**
 * 公共选择框子项 上级选择框 ，同一个表单中不能被重复引用到字段中。
 */
function checkPubchilchoiceId(){
	var result = true;
	var maintablenameStr = "";
    try{
    	var pubchilchoiceIdStr = ",";
    	jQuery("select[name^='itemFieldType_']").each(function(){
    		var v = jQuery(this).val();
    		var vArray = jQuery(this).attr("name").split("_");
    		var rowindex = vArray[1];
    		var selectItemType = jQuery("#selectItemType"+rowindex).val();
    		if(vArray.length == 2 && v == "5" && selectItemType == "2"){ //公共选择框及公共选择框子项
    			var pubchilchoiceId = jQuery("#pubchilchoiceId"+rowindex).val();
    		    if(pubchilchoiceIdStr.indexOf(","+pubchilchoiceId+",") != -1){
    		    	result = false;
    		    }
    		    if(pubchilchoiceId.length>0){
    		    	pubchilchoiceIdStr += pubchilchoiceId+",";	
    		    }
    		}
    	});
	}catch(e){}
	
	if(!result){
		maintablenameStr = "<%=tablename%><br>"; //21778 主表	
	}
	try{
		var detailtablenameStr = "";
    	jQuery("input[name^='detailtablename_db_']").each(function(){
    		var resutl0 = true;
    		var pubchilchoiceIdStr0 = ",";
    		var tablename = jQuery(this).val();
    		var tabindex = jQuery(this).attr("name").split("_")[2];
    		jQuery("select[name^='itemFieldType_"+tabindex+"_']").each(function(){
    			var v = jQuery(this).val();
        		var vArray = jQuery(this).attr("name").split("_");
        		var rowindex = vArray[2];
        		//selectItemType1_2
        		var selectItemType = jQuery("#selectItemType"+tabindex+"_"+rowindex).val();
        		if(vArray.length == 3 && v == "5" && selectItemType == "2"){ //公共选择框及公共选择框子项
        			//pubchilchoiceId1_2
        			var pubchilchoiceId = jQuery("#pubchilchoiceId"+tabindex+"_"+rowindex).val();
        		    if(pubchilchoiceIdStr0.indexOf(","+pubchilchoiceId+",") != -1){
        		    	result = false;
        		    	resutl0 = false; 
        		    }
        		    if(pubchilchoiceId.length>0){
        		    	pubchilchoiceIdStr0 += pubchilchoiceId+",";	
        		    }
        		}
    		});
    		if(!resutl0){
    			detailtablenameStr += tablename+"<br>";
    		}
    	});
	}catch(e){alert(e);}
	
	if(!result){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130446,user.getLanguage())%><br><%=SystemEnv.getHtmlLabelName(130729,user.getLanguage())%>:<br>"+maintablenameStr+detailtablenameStr); //公共选择框子项上级选择框不能重复,请检查！
	}
	return result;
}

//对特殊符号进行处理
function dealSpecial(val){
	//本字符串是欧元符号的unicode码, GBK编辑中不支持欧元符号(需更改为UTF-8), 故只能使用unicode码
	var euro = "\u20AC";
	//本字符串是欧元符号在HTML中的特别表现形式
	var symbol = "&euro;";
	var reg = new RegExp(euro);
	while(val.indexOf(euro) != -1){
		val = val.replace(reg, symbol);
	}  
	return val;
}

	function checkKey(obj){
		
		var keys=",PERCENT,PLAN,PRECISION,PRIMARY,PRINT,PROC,PROCEDURE,PUBLIC,RAISERROR,READ,READTEXT,RECONFIGURE,REFERENCES,REPLICATION,RESTORE,RESTRICT,RETURN,REVOKE,RIGHT,ROLLBACK,ROWCOUNT,ROWGUIDCOL,RULE,SAVE,SCHEMA,SELECT,SESSION_USER,SET,SETUSER,SHUTDOWN,SOME,STATISTICS,SYSTEM_USER,TABLE,TEXTSIZE,THEN,TO,TOP,TRAN,TRANSACTION,TRIGGER,TRUNCATE,TSEQUAL,UNION,UNIQUE,UPDATE,UPDATETEXT,USE,USER,VALUES,VARYING,VIEW,WAITFOR,WHEN,WHERE,WHILE,WITH,WRITETEXT,EXCEPT,EXEC,EXECUTE,EXISTS,EXIT,FETCH,FILE,FILLFACTOR,FOR,FOREIGN,FREETEXT,FREETEXTTABLE,FROM,FULL,FUNCTION,GOTO,GRANT,GROUP,HAVING,HOLDLOCK,IDENTITY,IDENTITY_INSERT,IDENTITYCOL,IF,IN,INDEX,INNER,INSERT,INTERSECT,INTO,IS,JOIN,KEY,KILL,LEFT,LIKE,LINENO,LOAD,NATIONAL,NOCHECK,NONCLUSTERED,NOT,NULL,NULLIF,OF,OFF,OFFSETS,ON,OPEN,OPENDATASOURCE,OPENQUERY,OPENROWSET,OPENXML,OPTION,OR,ORDER,OUTER,OVER,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUTHORIZATION,BACKUP,BEGIN,BETWEEN,BREAK,BROWSE,BULK,BY,CASCADE,CASE,CHECKPOINT,CLOSE,CLUSTERED,COALESCE,COLLATE,COLUMN,COMMIT,COMPUTE,CONSTRAINT,CONTAINS,CONTAINSTABLE,CONTINUE,CONVERT,CREATE,CROSS,CURRENT,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,DATABASE,DBCC,DEALLOCATE,DECLARE,DEFAULT,DELETE,DENY,DESC,DISK,DISTINCT,DISTRIBUTED,DOUBLE,DROP,DUMMY,DUMP,ELSE,END,ERRLVL,ESCAPE,";
		//以下for oracle.update by cyril on 2008-12-08 td:9722
		keys+="ACCESS,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUDIT,BETWEEN,BY,CHAR,"; 
		keys+="CHECK,CLUSTER,COLUMN,COMMENT,COMPRESS,CONNECT,CREATE,CURRENT,";
		keys+="DATE,DECIMAL,DEFAULT,DELETE,DESC,DISTINCT,DROP,ELSE,EXCLUSIVE,";
		keys+="EXISTS,FILE,FLOAT,FOR,FROM,GRANT,GROUP,HAVING,IDENTIFIED,";
		keys+="IMMEDIATE,IN,INCREMENT,INDEX,INITIAL,INSERT,INTEGER,INTERSECT,";
		keys+="INTO,IS,LEVEL,LIKE,LOCK,LONG,MAXEXTENTS,MINUS,MLSLABEL,MODE,";
		keys+="MODIFY,NOAUDIT,NOCOMPRESS,NOT,NOWAIT,NULL,NUMBER,OF,OFFLINE,ON,";
		keys+="ONLINE,OPTION,OR,ORDER,PCTFREE,PRIOR,PRIVILEGES,PUBLIC,RAW,";
		keys+="RENAME,RESOURCE,REVOKE,ROW,ROWID,ROWNUM,ROWS,SELECT,SESSION,";
		keys+="SET,SHARE,SIZE,SMALLINT,START,SUCCESSFUL,SYNONYM,SYSDATE,TABLE,";
		keys+="THEN,TO,TRIGGER,UID,UNION,UNIQUE,UPDATE,USER,VALIDATE,VALUES,";
		keys+="VARCHAR,VARCHAR2,VIEW,WHENEVER,WHERE,WITH,";
		var fname=obj.value;
		if (fname!=""){
			fname=","+fname.toUpperCase()+",";
			if (keys.indexOf(fname)>0){
				top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(19946,user.getLanguage())%>');
				//obj.focus();
				return false;
			}
		}
		return true;
	}
/*
p（精度）
指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。

s（小数位数）
指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
*/
function checkDigit(elementName,p,s){
	tmpvalue = $G(elementName).value;

    var len = -1;
    if(elementName){
		len = tmpvalue.length;
    }

	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var newIntValue="";
	var newDecValue="";
    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
    $G(elementName).value=newValue;
}
function setChange0(event,datas,name,rowIndex){
	setChange(rowIndex);
}
function setChange1(event,datas,name){
	var rowIndex = name.split('_')[1];
	setChange(rowIndex);
}
function setChange(rowIndex){
	if(changeRowIndexs.indexOf(","+rowIndex+",")<0){
		changeRowIndexs+=rowIndex+",";
	}
	//try{
	//var dbfieldname = $G("itemDspName_"+rowIndex).value.toUpperCase();
	//dbfieldnames = dbfieldnames.replace(","+dbfieldname+",",",");
	//}catch(e){}
}

function checkItemFieldScale(oldObj,newObj,minValue,maxValue){
	oldValue=oldObj.value;
	newValue=newObj.value;

    try{
        oldValue=parseInt(oldValue);
        if(isNaN(oldValue)){
            oldValue=0;
        }
    }catch(e){
        oldValue=0;
    }

    try{
        newValue=parseInt(newValue);
        if(isNaN(newValue)){
            newValue=0;
        }
    }catch(e){
        newValue=0;
    }

	if(newValue<oldValue){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20881,user.getLanguage())%>");
		newObj.value=oldValue;
		return ;
	}
	if(newValue<minValue||newValue>maxValue){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20882,user.getLanguage())%>："+minValue+"-"+maxValue);
		newObj.value=oldValue;
		return ;
	}
}

function checkItemFieldScaleForAdd(newObj,minValue,maxValue,defaultValue){

	newValue=newObj.value;

    try{
        newValue=parseInt(newValue);
        if(isNaN(newValue)){
            newValue=0;
        }
    }catch(e){
        newValue=0;
    }

	if(newValue<minValue||newValue>maxValue){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20882,user.getLanguage())%>："+minValue+"-"+maxValue);
		newObj.value=defaultValue;
		return ;
	}
}
function onChangeChildField(childstr){
	var len = document.frmMain.elements.length;
    for(i=len-1; i>=0; i--) {
        if(document.frmMain.elements[i].id.indexOf("childItem"+childstr) == 0){
			var inputObj = document.frmMain.elements[i];
			var idstr = document.frmMain.elements[i].id;
			idstr = idstr.substring(("childItem"+childstr).length, idstr.length);
			var spanid = "childItemSpan"+childstr+idstr;
			var spanObj = $G(spanid);
			try{
				inputObj.value = "";
				spanObj.innerHTML = "";
			}catch(e){}
    	}
	}
}

function sortRule(a,b) {
	var x = a._text;
	var y = b._text;
	return x.localeCompare(y);
}
function op(){
	var _value;
	var _text;
}
function sortOption(obj){
	//var obj = $G(id);
	var tmp = new Array();
	for(var i=0;i<obj.options.length;i++){
	var ops = new op();
	ops._value = obj.options[i].value;
	ops._text = obj.options[i].text;
	ops._match = jQuery(obj.options[i]).attr('match');
	tmp.push(ops);
    }
	tmp.sort(sortRule);
	for(var j=0;j<tmp.length;j++){
	obj.options[j].value = tmp[j]._value;
	obj.options[j].text = tmp[j]._text;
	jQuery(obj.options[j]).attr('match', tmp[j]._match);
	}
}

</script>



<script language="JavaScript">
function getDetailTableName(childstr){
	var tablename = "";
	try{
		if(childstr.indexOf("detail")>-1){
			childstr = "_"+childstr.substring(7, childstr.lastIndexOf("_"));
			tablename = $G("detailTable_name"+childstr).value;
		}
	}catch(e){}
	return tablename;
}

function onShowChildField(spanname, inputname, childstr) {
	var isdetail = "0"
	var hasdetail = childstr.indexOf("detail");//Instr(childstr, "detail")
	if (hasdetail > 0) {
		isdetail = "1"
	}

	var pfieldidsql = "";
    if (hasdetail > 0) {
        tablename = getDetailTableName(childstr);
        pfieldidsql = " AND detailtable='" + tablename + "' ";
    }
    var oldvalue = inputname.value;
	var url=escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and billid=<%=formid%>" + pfieldidsql + "&isdetail="+isdetail+"&isbill=1");
	var id = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if(rid != "") {
			inputname.value = rid;
			spanname.innerHTML = rname;
		} else {
			inputname.value = "";
			spanname.innerHTML = "";
		}
	}
	if (oldvalue != inputname.value ) {
		onChangeChildField(childstr);
	}
}

function onShowChildSelectItem(spanname, inputname, childidstr) {
	var cfid = $G("childfieldid"+childidstr).value
	var oldids = $G(inputname).value
	url=escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=1&childfieldid=" + cfid + "&resourceids=" + oldids);
	id = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if(rid != "") {
			$G(inputname).value = rid.substr(1);
			$G(spanname).innerHTML = rname.substr(1);
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}

//以下为新表单设计器-Excel模板导入-批量添加字段相关JS
jQuery(document).ready(function(){
	var fromwhere = jQuery("input[name='fromwhere']").val();
	if(fromwhere!="excelimp")	return;
	var parentWin = parent.getParentWindow(window);
	var lackfields = parentWin.check_result;
	lackfields = JSON.parse(lackfields);
	
	var needDetailNum = 0;
	for(var key in lackfields){
		if(key.indexOf("_lack_field")==-1)	continue;
		if(key=="main_lack_field"){
			var main_lackfield = lackfields[key];
			for(var i=0; i<main_lackfield.length; i++){
				addRow();
				var fieldname = main_lackfield[i];
				jQuery("table#oTable").find("input[name='itemFieldName_"+i+"']")
					.val(fieldname).attr("readonly",true).next().html("");
			}
		}else{	//明细字段
			var index1 = key.indexOf("_")+1;
			var index2 = key.indexOf("_", index1)
			var detailIndex = key.substring(index1, index2);
			if(detailIndex>needDetailNum)
				needDetailNum = detailIndex;
		}
	}
	if(needDetailNum>0){		//明细字段添加
		var existDetailNum = jQuery("table[id^=detailTable_]").size();
		for(var diff=needDetailNum-existDetailNum; diff>0; diff--){		//先自动添加明细Table
			addDetailTable();
		}
		window.setTimeout(function(){		//addDetailTable含异步操作，延时加字段
			for(var index=1; index<=needDetailNum; index++){
				if(lackfields['detail_'+index+'_lack_field']){
					var detail_lackfield = lackfields['detail_'+index+'_lack_field'];
					for(var i=0; i<detail_lackfield.length; i++){
						addDetailRow(index);
						var fieldname = detail_lackfield[i];
						//console.log(index+"_"+i+"____"+fieldname)
						jQuery("table#detailTable_"+index).find("input[name='itemFieldName_detail"+index+"_"+(i+1)+"']")
							.val(fieldname).attr("readonly",true).next().html("");
					}
				}
			}
		},500);
	}
});

function cancelSaveNextImport(){
	var dialog = parent.getDialog(window);
	dialog.close("nextImport");
}

function cancelImport(){
	var dialog = parent.getDialog(window);
	dialog.close();
}
</script>

<script language="javascript">
/*
sub onShowChildField(spanname, inputname, childstr)
	isdetail = "0"
	hasdetail = Instr(childstr, "detail")
	if hasdetail>0 then
		isdetail = "1"
	end if

	oldvalue = inputname.value
	url=escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and billid=<%=formid%>&isdetail="+isdetail+"&isbill=1")
	id = showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
	if Not isempty(id) then
		if id(0) <> "" then
			inputname.value = id(0)
			spanname.innerHtml = id(1)
		else
			inputname.value = ""
			spanname.innerHtml = ""
		end if
	end if
	if oldvalue <> inputname.value then
		onChangeChildField childstr
	end if
end sub

sub onShowChildSelectItem(spanname, inputname, childidstr)
	cfid = $G("childfieldid"+childidstr).value
	oldids = inputname.value
	url=escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=1&childfieldid="&cfid&"&resourceids="&oldids)
	id = showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
	if Not isempty(id) then
		if id(0) <> "" then
			resourceids = id(0)
			resourcenames = id(1)
			resourceids = Mid(resourceids, 2, len(resourceids))
			resourcenames = Mid(resourcenames, 2, len(resourcenames))
			inputname.value = resourceids
			spanname.innerHtml = resourcenames
		else
			inputname.value = ""
			spanname.innerHtml = ""
		end if
	end if
end sub
*/
</script>
