<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SelectItemManager" class="weaver.workflow.selectItem.SelectItemManager" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_si" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="mainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="subCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="FormFieldTransMethod" class="weaver.general.FormFieldTransMethod" scope="page"/>
<HTML><HEAD>


<%
String isclose = Util.null2String(request.getParameter("isclose"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="";
String needhelp ="";
 %>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dojo_wev8.js"></script>
<script type="text/javascript" src="/js/tab_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type="text/css" />
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script type="text/javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<script type="text/javascript" src="/js/jquery-autocomplete/browser_wev8.js"></script>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
	
	function btn_cancle(){
		dialog.closeByHand();
		try{
			//parentWin._table.reLoad();
		}catch(e){}
	}
	
</script>
<%

int fieldid = Util.getIntValue(request.getParameter("fieldid"));
//int rownum = Util.getIntValue(request.getParameter("rownum"));
String sql = "";
titlename = SystemEnv.getHtmlLabelName(32714,user.getLanguage());


String formid = "";
String canDeleteCheckBox = "";
String para = "";
String fieldname = "";//数据库字段名称
int fieldlabel = 0;//字段显示名标签id
String fieldlabelname = "";//字段显示名
String fielddbtype = "";//字段数据库类型
String fieldhtmltype = "";//字段页面类型
String type = "";//字段详细类型
String dsporder = "";//显示顺序
String viewtype = "0";//viewtype="0"表示主表字段,viewtype="1"表示明细表字段
String detailtable = "";//明细表名
int childfieldid = 0;
String childfieldname = "";
int isdetail = 0;
Hashtable selectitem_sh = new Hashtable();
rs.executeSql("select * from workflow_billfield where id="+fieldid);
if(rs.next()){
	int billid = Util.getIntValue(Util.null2String(rs.getString("billid")),0);
    fieldname = Util.null2String(rs.getString("fieldname"));
    fieldlabel = Util.getIntValue(Util.null2String(rs.getString("fieldlabel")),0);
    fieldlabelname = Util.null2String(SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage()));
    fielddbtype = Util.null2String(rs.getString("fielddbtype"));
    fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
    type = Util.null2String(rs.getString("type"));
    dsporder = Util.null2String(rs.getString("dsporder"));
    viewtype = Util.null2String(rs.getString("viewtype"));
	isdetail = Util.getIntValue(Util.null2String(rs.getString("viewtype")),0);
    detailtable = Util.null2String(rs.getString("detailtable"));
    formid = ""+billid;
	childfieldid = Util.getIntValue(Util.null2String(rs.getString("childfieldid")),0);
	
    if(viewtype.equals("0")) para = fieldname+"+"+viewtype+"+"+fieldhtmltype+"+ +"+formid+"+"+type;
    if(viewtype.equals("1")) para = fieldname+"+"+viewtype+"+"+fieldhtmltype+"+"+detailtable+"+"+formid+"+"+type;
    canDeleteCheckBox = FormFieldTransMethod.getCanCheckBox(para);
}

if(fieldid!=0 && childfieldid!=0){
	rs_si.execute("select fieldlabel from workflow_billfield where id="+childfieldid);
	if(rs_si.next()){
		int fieldlabel_tmp = Util.getIntValue(rs_si.getString("fieldlabel"));
		childfieldname = SystemEnv.getHtmlLabelName(fieldlabel_tmp, user.getLanguage());
	}
	
	rs_si.execute("select id, selectvalue, selectname from workflow_SelectItem where isbill=1 and fieldid="+childfieldid);
	while(rs_si.next()){
		int selectvalue_tmp = Util.getIntValue(rs_si.getString("selectvalue"), 0);
		String selectname_tmp = Util.null2String(rs_si.getString("selectname"));
		selectitem_sh.put("si_"+selectvalue_tmp, selectname_tmp);
	}
}

String detailtableStr = "";
if(isdetail==1){
	detailtableStr = "&detailtable="+detailtable;
}


//String url = "/systeminfo/BrowserMain.jsp?url=escape('/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and billid="+formid + detailtableStr + "&isdetail=" + isdetail + "&isbill=1')";
String url = "/workflow/selectItem/selectItemMain.jsp?topage=fieldBrowser&fieldhtmltype=5&billid="+formid + detailtableStr + "&isdetail=" + isdetail + "&isbill=1&fieldid="+fieldid;

//System.out.println(url);
%>

</head>
<BODY>

<script type="text/javascript">
    function refreshParentWin(){
		try{
		    var parentWin0 = parent.parent.getParentWindow(parent);
			parentWin0.refreshParentWin();
		}catch(e){alert(e);}
	}
	if("<%=isclose%>"=="1"){
	    refreshParentWin();	
		
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
		
		dialog.close();
	}
</script>

	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave(this);">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    <form id="formCustomSearch" name="formCustomSearch" method="post" action="/workflow/selectItem/selectItemOperator.jsp">
	<input type="hidden" name="fieldid" id="fieldid" value="<%=fieldid %>" />
	<input type="hidden" name="method" id="method" value="saveselectitem"/>
	
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%></wea:item>
			<wea:item>
				<span id="childfieldNotesSpan">&nbsp;</span>
				
					<brow:browser name="childfieldid" 
					viewType="0" 
					hasBrowser="true" 
					hasAdd="false" 
					isMustInput="1" 
					isSingle="true" 
					hasInput="true"
					browserUrl=""
					completeUrl="/data.jsp?type=fieldBrowser&isbill=0"   
					width="150px" 
					browserValue='<%=childfieldid+""%>' 
					browserSpanValue='<%=childfieldname%>' 
					_callback="clearChildItem"
					getBrowserUrlFn="onShowChildField_new"/>
				 
					
				
			</wea:item>
		</wea:group>
		
		<wea:group context='<%=SystemEnv.getHtmlLabelName(124984,user.getLanguage())%>' >
			    <wea:item type="groupHead">
			        <span style="float:right;">
					<input type="button" class="addbtn" style="width:21px !important;"  title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="addoTableRow()"/>
					<input type="button" class="delbtn" style="width:21px !important;"  title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="submitClear()"/>
					</span>
				</wea:item>
				<wea:item attributes="{'isTableList':'true'}">
					<table class=ListStyle cellspacing=0   cols=6 id="choiceTable0">
						<colgroup>
						<col width="5%">
						<col width="15%">
						<col width="5%">
						<col width="20%">
						<col width="8%">
						<col width="7%">
						</colgroup>  
						
						 <tr class="header notMove">
						    <td><input type="checkbox" name="selectall" id="selectall" onclick="SelAll(this)"></td>
			            	<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td><!-- 可选择项文字 -->
			            	<td><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></td><!-- 默认值 -->
			            	<td><%=SystemEnv.getHtmlLabelName(19207,user.getLanguage())%></td><!-- 关联文档目录 -->
			            	<td><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td><!-- 子选项 -->
			            	<td><%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%></td><!-- 封存 -->
						</tr>
						
						<%
					    int rowindex = 0;
						rs1.executeSql("select * from workflow_SelectItem where isbill=1 and fieldid="+fieldid+" order by listorder ");
				  		while(rs1.next()){
				  			rowindex++;
							String childitemid_tmp = Util.null2String(rs1.getString("childitemid"));
							String id_temp = Util.null2String(rs1.getString("id"));
							String childitemidStr = "";
	
							String docspath = "";
							String docscategory = rs1.getString("docCategory");
							if(!"".equals(docscategory) && null != docscategory){//根据路径ID得到路径名称
	
							    List nameList = Util.TokenizerString(docscategory, ",");
								try{
								    String mainCategory = (String)nameList.get(0);
								    String subCategory = (String)nameList.get(1);
								    String secCategory = (String)nameList.get(2);
								    docspath = secCategoryComInfo.getAllParentName(secCategory,true);
								}catch(Exception e){
									docspath = secCategoryComInfo.getAllParentName(docscategory,true);
								}
							}
	
							int isAccordToSubCom_tmp = Util.getIntValue(rs1.getString("isaccordtosubcom"), 0);
							String isAccordToSubCom_Str = "";
							if(isAccordToSubCom_tmp == 1){
								isAccordToSubCom_Str = " checked ";
							}
							if(!"".equals(childitemid_tmp)){
								String[] itemid_sz = Util.TokenizerString2(childitemid_tmp, ",");
								for(int cx=0; cx<itemid_sz.length; cx++){
									String itemid_tmp = itemid_sz[cx];
									try{
										String[] checktmp_sz = Util.TokenizerString2(itemid_tmp, "a");
										String itemidStr_tmp = Util.null2String((String)selectitem_sh.get("si_"+checktmp_sz[0]));
										if(!"".equals(itemidStr_tmp)){
											childitemidStr += (itemidStr_tmp + ",");
										}
									}catch(Exception e){}
								}
								if(!"".equals(childitemidStr)){
									childitemidStr = childitemidStr.substring(0, childitemidStr.length()-1);
								}
							}
	
	
				  		%>
				  		<tr class="DataDark">
					  		<td><input type="checkbox" name="chkField" id="chkField_<%=rowindex%>" index="<%=rowindex%>" value="0" <%if(canDeleteCheckBox.equals("false")){%>disabled<%}%>>
					  			&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>' />
					  			<input type="hidden" name="id_<%=rowindex %>" value="<%=id_temp %>"/>
					  		</td>
					  		<td><input class="InputStyle" value='<%=rs1.getString("selectname")%>' type="text" id="field_name_<%=rowindex%>" name="field_name_<%=rowindex%>" onchange="checkinput('field_name_<%=rowindex%>','field_span_<%=rowindex%>');">
					  		<span id="field_span_<%=rowindex%>"><%if(rs1.getString("selectname").equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
					  		<input class="InputStyle" type="hidden" style="width:40px!important;" value ='<%=rs1.getString("listorder")%>' name="field_count_name_<%=rowindex%>" onKeyPress="ItemNum_KeyPress('field_count_name_<%=rowindex%>')" >
					  		</td>
					  		<td><input type="checkbox" name="field_checked_name_<%=rowindex%>"  onchange="" onclick="if(this.checked){this.value=1;}else{this.value=0}" <%if(rs1.getString("isdefault").equals("y")){%>checked<%}%> value="1"></td>
					  			
					  		<td><input type="hidden" id="selectvalue<%=rowindex%>" name="selectvalue<%=rowindex%>" value='<%=rs1.getString("selectvalue")%>'>
								<input type='checkbox' id="isAccordToSubCom<%= rowindex%>" name='isAccordToSubCom<%=rowindex%>'  onchange=""  value='1' <%=isAccordToSubCom_Str%>><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;								
               <brow:browser viewType="0" name='<%="maincategory_"+rowindex%>' browserValue='<%=rs1.getString("docCategory")%>'  
	            getBrowserUrlFn="onShowCatalog"   getBrowserUrlFnParams='<%=""+rowindex%>'
	            idKey="id" nameKey="path"
				_callback="afterSelect"
				_callbackParams='<%=""+rowindex%>'
	            hasInput="true" isSingle="true" hasBrowser = "true"  isMustInput='1'
	            completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" linkUrl="#" width="60%"
	            browserSpanValue="<%=docspath%>"></brow:browser>

								
							  <input type=hidden id="pathcategory_<%=rowindex%>" name="pathcategory_<%=rowindex%>" value="<%=docspath%>">
							<td>
								<%-- <BUTTON type='button' class="Browser" onClick="onShowChildSelectItem('childItemSpan<%=rowindex%>', 'childItem<%=rowindex%>')" id="selectChildItem<%=rowindex%>" name="selectChildItem<%=rowindex%>"></BUTTON> --%>
								<brow:browser viewType="0" name='<%="childItemshow_"+rowindex%>' 
					                getBrowserUrlFn="onShowChildItem"   getBrowserUrlFnParams='<%=""+rowindex%>'
					                idKey="id" 
					                _callback="afterSelectChildItem"
					                _callbackParams='<%=""+rowindex%>'
					                hasInput="false" isSingle="true" hasBrowser = "true"  isMustInput='1'
					                linkUrl="#" width="20px"
					                browserSpanValue="">
					            </brow:browser>
								<input type="hidden" id="childItem<%=rowindex%>" name="childItem<%=rowindex%>" value="<%=childitemid_tmp%>" >
								<span id="childItemSpan<%=rowindex%>" name="childItemSpan<%=rowindex%>" style="display:inline-block;word-break:keep-all;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:80px;"><%=childitemidStr%></span>
							</td>
		                    <td><input type="checkbox" name="cancel_<%=rowindex%>_name"  value='<%=rs1.getString("cancel")%>' onclick="if(this.checked){this.value=1;}else{this.value=0}" <%if(rs1.getString("cancel").equals("1")){%>checked<%}%>></td>   
				  		</tr>
				  		
				  		<%
				  		}
				  		%>
						
						
					</table>
						
					<input type="hidden" id="choiceRows_rows" name="choiceRows_rows" value="<%=rowindex%>">
					<input type="hidden" id="rowno" name="rowno" value="">
				</wea:item>
			</wea:group>
	</wea:layout>
	</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
</wea:layout>
</div>
<script type="text/javascript">

    jQuery(document).ready(function(){
        jQuery("[id^='outchildItemshow_']").each(function(){
            jQuery(this).parent().find(".e8_innerShowMust").css("display","none");
            jQuery(this).parent().find(".e8_outScroll").css("display","none");
        });
    });
function onShowChildSelectItem(spanname, inputname) {
	var cfid = $G("childfieldid").value;
	var resourceids = $G(inputname).value;
	var isdetail = "<%=isdetail%>";
	var url=escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=" + isdetail + "&childfieldid=" + cfid + "&resourceids=" + resourceids);
	var id = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
	
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			var resourceids = rid.substr(1);
			var resourcenames = rname.substr(1);
			
			$G(inputname).value = resourceids;
			$G(spanname).innerHTML = resourcenames;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}

var childfield_oldvalue = "";
function onShowChildField_new() {
    url = "<%=url%>";
    childfield_oldvalue = jQuery("#childfieldid").val();
    return url;
}

function clearChildItem(){
    var childfield_value = jQuery("#childfieldid").val();
	if (childfield_oldvalue != childfield_value) {
        jQuery("input[name^='childItem']").each(function(){
        	jQuery(this).val("");
        });
        jQuery("span[name^='childItemSpan']").each(function(){
        	jQuery(this).html("");
        });
    }
}

function onShowChildField(spanname, inputname) {
    id = showModalDialog("/systeminfo/BrowserMain.jsp?url=<%=url%>");
    if (id) {
        if (wuiUtil.getJsonValueByIndex(id,0)!= "") {
            inputname.value =wuiUtil.getJsonValueByIndex(id,0);
            spanname.innerHTML =wuiUtil.getJsonValueByIndex(id,1);
        } else {
            inputname.value = "";
            spanname.innerHTML = "";
        }
    }
    if (oldvalue != inputname.value) {
        onChangeChildField();
    }
}

function onChangeChildField(){
	var rownum = parseInt(rowindex);
	for(var i=0; i<rownum; i++){
		var inputObj = $G("childItem"+i);
		var spanObj = $G("childItemSpan"+i);
		try{
			if(inputObj!=null && spanObj!=null){
				inputObj.value = "";
				spanObj.innerHTML = "";
			}
		}catch(e){}
	}
}

function onShowChildItem(choiceitemindex){
    var cfid = $G("childfieldid").value;
    var resourceids = jQuery("#childItem" + choiceitemindex).val();
    var isdetail = "<%=isdetail%>";
    var url=escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=" + isdetail + "&childfieldid=" + cfid + "&resourceids=" + resourceids);
    url = "/systeminfo/BrowserMain.jsp?url=" + url;
    
    return url;
}
function onShowCatalog(choicerowindex){
    var url="";
	var isAccordToSubCom=0;	
	if(document.getElementById("isAccordToSubCom"+choicerowindex)!=null){
		if(document.getElementById("isAccordToSubCom"+choicerowindex).checked){
			isAccordToSubCom=1;
		}
	}
	if(isAccordToSubCom==1){
		url=onShowCatalogSubCom(choicerowindex);
	}else{
		url=onShowCatalogHis(choicerowindex);
	}
	return url;
}
function afterSelect(e,rt,name,choicerowindex){
	var docsec=rt.mainid+","+rt.subid+","+rt.id ;
    jQuery("input[name=maincategory_"+choicerowindex+"]").val(docsec);
    jQuery("input[name=pathcategory_"+choicerowindex+"]").val(jQuery("span[name=maincategory_"+choicerowindex+"span]").text());   

}
function afterSelectChildItem(e,rt,name,choicerowindex){
    if (rt != null) {
        var rid = wuiUtil.getJsonValueByIndex(rt, 0);
        var rname = wuiUtil.getJsonValueByIndex(rt, 1);
        if (rid != "") {
            var resourceids = rid.substr(1);
            var resourcenames = rname.substr(1);
            
            $("#childItem" + choicerowindex).val(resourceids);
            $("#childItemSpan" + choicerowindex).html(resourcenames);
        } else {
            $("#childItem" + choicerowindex).val("");
            $("#childItemSpan" + choicerowindex).html("");
        }
    }   

}

function onShowCatalogHis(choicerowindex) {	
	   
	 return "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp";   
}

function onShowCatalogSubCom(index) {
	var selectvalue=document.getElementById("selectvalue"+index).value;
    return "/systeminfo/BrowserMain.jsp?url=/docs/field/SubcompanyDocCategoryBrowser.jsp?fieldId=<%=fieldid%>&isBill=1&selectValue="+selectvalue;
	
}


jQuery(document).ready(function(){
	resizeDialog(document);
});
	
	
jQuery(document).ready(function(){
	registerDragEvent();
	jQuery("tr.notMove").bind("mousedown", function() {
		return false;
	});
});	
	
	
	
function registerDragEvent() {
	var fixHelper = function(e, ui) {
		ui.children().each(function() {
		    $(this).width($(this).width()); // 在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了

		    $(this).height($(this).height());
		});
		return ui;
	};

	var copyTR = null;
	var startIdx = 0;

	var idStr = "#choiceTable0";
	jQuery(idStr + " tbody tr").bind("mousedown", function(e) {
		copyTR = jQuery(this).next("tr.Spacing");
	});
        
    jQuery(idStr + " tbody").sortable({ // 这里是talbe tbody，绑定 了sortable
        helper: fixHelper, // 调用fixHelper
        axis: "y",
        start: function(e, ui) {
            ui.helper.addClass("e8_hover_tr") // 拖动时的行，要用ui.helper
            if(ui.item.hasClass("notMove")) {
            	e.stopPropagation && e.stopPropagation();
            	e.cancelBubble = true;
            }
            if(copyTR) {
       			copyTR.hide();
       		}
       		startIdx = ui.item.get(0).rowIndex;
            return ui;
        },
        stop: function(e, ui) {
            ui.item.removeClass("e8_hover_tr"); // 释放鼠标时，要用ui.item才是释放的行
        	if(ui.item.get(0).rowIndex < 1) { // 不能拖动到表头上方

                if(copyTR) {
           			copyTR.show();
           		}
        		return false;
        	}
           	if(copyTR) {
	       	  	/* if(ui.item.get(0).rowIndex > startIdx) {
	        	  	ui.item.before(copyTR.clone().show());
				}else {
	        	  	ui.item.after(copyTR.clone().show());
				} */
				if(ui.item.prev("tr").attr("class") == "Spacing") {
					ui.item.after(copyTR.clone().show());
				}else {
					ui.item.before(copyTR.clone().show());
				}
	       	  	copyTR.remove();
	       	  	copyTR = null;
       		}
           	return ui;
        }
    });
}
	

var rowindex = jQuery("#choiceRows_rows").val();
function addoTableRow(){
  	obj = document.getElementById("choiceTable0");
  	rowindex = jQuery("#choiceRows_rows").val();
  	rowindex=rowindex*1+1;
	ncol=obj.rows[0].cells.length;
	oRow = obj.insertRow(-1);
	jQuery(oRow).addClass("DataDark");
	for(i=0; i<ncol; i++){
		oCell1 = oRow.insertCell(i);
		switch(i){
			case 0:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input type='checkbox' id='chkField_"+rowindex+"' name='chkField' index='"+rowindex+"' value='1'>"+
				             "<input class='Inputstyle' type='hidden' size='4' value = '0.00' id='field_count_name_"+rowindex+"' name='field_count_name_"+rowindex+"' > "+
				             "&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>' />";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 1:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input class='Inputstyle' type='text' id='field_name_"+rowindex+"' name='field_name_"+rowindex+"' "+
								" onchange=checkinput('field_name_"+rowindex+"','field_span_"+rowindex+"')>"+
							 " <span id='field_span_"+rowindex+"'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;

			case 2:
				var oDiv1 = document.createElement("div");
				var sHtml1 = " <input type='checkbox' name='field_checked_name_"+rowindex+"' onclick='if(this.checked){this.value=1;}else{this.value=0}'>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 3:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input type='checkbox' id='isAccordToSubCom"+rowindex+"' name='isAccordToSubCom"+rowindex+"' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;"
							+ "<input type='hidden' id='selectvalue"+rowindex+"' name='selectvalu"+rowindex+"' value='' />"
							+ "<span  id='maincategory_"+rowindex+"' name='maincategory_"+rowindex+"' ></span>"
						    + "<input type=hidden id='pathcategory_"+rowindex+"' name='pathcategory_"+rowindex+"' value=''>";
						   

				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				 jQuery("#maincategory_"+rowindex).e8Browser({
                 name:"maincategory_"+rowindex,
                 viewType:"0",
                 browserValue:"",
                 isMustInput:"1",
                 browserSpanValue:"",
                 hasInput:true,
                 linkUrl:"#",
                 isSingle:true,
                 completeUrl:"/data.jsp?type=categoryBrowser&onlySec=true",
				 getBrowserUrlFn:'onShowCatalog',
				 getBrowserUrlFnParams:''+rowindex,
				 _callback:"afterSelect",
				 _callbackParams:rowindex,
         
                 width:"60%",
                 hasAdd:false,
                 isSingle:true
                 });
				break;
			case 4:
				var oDiv1 = document.createElement("div");
				/*
				var sHtml1 = "<BUTTON type='button' class=\"Browser\" onClick=\"onShowChildSelectItem('childItemSpan"+rowindex+"', 'childItem"+rowindex+"')\" id=\"selectChildItem"+rowindex+"\" name=\"selectChildItem"+rowindex+"\"></BUTTON>"
							+ "<input type=\"hidden\" id=\"childItem"+rowindex+"\" name=\"childItem"+rowindex+"\" value=\"\" >"
							+ "<span id=\"childItemSpan"+rowindex+"\" name=\"childItemSpan"+rowindex+"\" style=\"display:inline-block;word-break:keep-all;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:80px;\"></span>";
							*/
                var sHtml1 = "<span  id='childItemshow_"+rowindex+"' name='childItemshow_"+rowindex+"' ></span>"
                            + "<input type=\"hidden\" id=\"childItem"+rowindex+"\" name=\"childItem"+rowindex+"\" value=\"\" >"
                            + "<span id=\"childItemSpan"+rowindex+"\" name=\"childItemSpan"+rowindex+"\" style=\"display:inline-block;word-break:keep-all;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:80px;\"></span>";

				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
                 jQuery("#childItemshow_"+rowindex).e8Browser({
                 name:"childItemshow_"+rowindex,
                 viewType:"0",
                 browserValue:"",
                 isMustInput:"1",
                 hasBrowser:"true",
                 browserSpanValue:"",
                 hasInput:false,
                 linkUrl:"#",
                 isSingle:true,
                 getBrowserUrlFn:'onShowChildItem',
                 getBrowserUrlFnParams:''+rowindex,
                 _callback:"afterSelectChildItem",
                 _callbackParams:rowindex,
                 width:"20px",
                 hasAdd:false,
                 isSingle:true
                 });
                 
		        jQuery("#childItemshow_"+rowindex).find(".e8_innerShowMust").css("display","none");
		        jQuery("#childItemshow_"+rowindex).find(".e8_outScroll").css("display","none");
				break;
			case 5:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input type='checkbox' name='cancel_"+rowindex+"_name' id='cancel_"+rowindex+"_name' value='1'>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
		}		
	}
	
	jQuery("#choiceRows_rows").val(rowindex);
	jQuery("#choiceTable0").jNice();
  
}

function submitClear(){
	//检查是否选中要删除的数据项
	var flag = false;
	var col = document.getElementsByName("chkField");
	for(var i = 0; i<col.length; i++){
		if(col[i] && col[i].checked){
			flag = true;
			break;
		}
	}
	if(flag){
		//if (isdel()){
		//	deleteRow1();
		//}
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			deleteRow1();
		}, function () {}, 320, 90,true);
	} else {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
		return false;
	}
}

function deleteRow1(){
	$("input[name=chkField]").each(function(){
		if($(this).attr("checked") && !$(this).attr("disabled")){
			$(this).closest("tr").remove();
		}
	});
}

function doSave(obj){
    rightMenu.style.visibility = "hidden";
    
    var choiceRows = rowindex;
	for(var tempchoiceRows=1;tempchoiceRows<=choiceRows;tempchoiceRows++){
		if(document.getElementById("field_name_"+tempchoiceRows)&&document.getElementById("field_name_"+tempchoiceRows).value==""){//选择框的可选项文字必填
			top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
			return;
		}
	}
	jQuery("choiceRows_rows").val(rowindex);
	
	if(document.getElementById("choiceTable0")){
		var disorder = 0;
		jQuery("input[name^=field_count_name_]").each(function(){
			jQuery(this).val(disorder);
			disorder++;
		});
	}
    
    enableAllmenu();
	formCustomSearch.submit();
}


function SelAll(obj){
	//$("input[type=checkbox]").attr("checked",obj.checked);
	var ckd = jQuery(obj).attr("checked");
	jQuery("input[id^='chkField_']").each(function(){
		if(ckd){
			jQuery(this).attr("checked",true);
			changeCheckboxStatus(this, true);
		}else{
			jQuery(this).attr("checked",false);
			changeCheckboxStatus(this, false);
		}
	});
}

setInterval(clearDetail,50);
function clearDetail(){
	var childfieldid = jQuery('#childfieldid').val();
	if(childfieldid == ''){
		jQuery("input[name^='childItem']").val('');
		jQuery("span[name^='childItemSpan']").html('');
	}
}
</script>
</body>

</html>