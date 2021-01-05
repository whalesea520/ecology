
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.docs.category.security.MultiAclManager" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.general.StaticObj" %>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="DocMouldComInfo1" class="weaver.docs.mouldfile.DocMouldComInfo" scope="page" />
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<%
	String id = Util.null2String(request.getParameter("id")); 
	String scope = "DocCustomFieldBySecCategory";	
	String selectids = "";
	RecordSet.executeSql("select fieldid from DocSecCategoryDocProperty where secCategoryId="+id+" and scope='"+scope+"' and isCustom=1");
	while(RecordSet.next()){
		if(selectids.equals("")){
			selectids = RecordSet.getString(1);
		}else{
			selectids = selectids + ","+ RecordSet.getString(1);
		}
	}
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript">

jQuery(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:null,params:{container:'td.field'}});
	jQuery("#hoverBtnSpan").hoverBtn();
});

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
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
		jQuery.ajax({
			url:"DocSecCategoryDocPropertiesEditOperation.jsp?isdialog=1&method=delete&secCategoryId=<%=id%>&ids="+id,
			type:"post",
			complete:function(xhr,status){
				//window.location.reload();
				_table.reLoad();
			}
		});
	});
}


var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function newCusField(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=56&isdialog=1&scope=<%=scope%>";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,17037",user.getLanguage())%>";
		dialog.Height = 400;
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=57&isdialog=1&scope=<%=scope%>&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,17037",user.getLanguage())%>";
		dialog.Height = 400;
	}
	dialog.maxiumnable = true;
	dialog.Width = 600;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

var _selectids = "<%=selectids%>";

function openDialog(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("611,91,17037",user.getLanguage())%>";
	var url = escape("/docs/category/DocSecCategoryCusFieldMutiBrowser.jsp?scope=<%=scope%>&secCategoryId=<%=id%>&selectids="+_selectids);
	url = "/systeminfo/BrowserMain.jsp?url="+url;
	dialog.Width = 500;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function afterDoWhenLoaded(){
	//hideTH();
	registerDragEvent();
	/*jQuery("select[class!=_pageSize]").selectbox({
		effect: "slide",
		onOpen: function(inst){
			 var optionsItems=$(this).next().find(".sbOptions");
             var selectValue=$(this).val();

             optionsItems.find("a").removeClass("selectorfontstyle");

             var item=optionsItems.find("a[href='#"+selectValue+"']");

             item.addClass("selectorfontstyle");

		}
	});*/
	jQuery("div#propTable").find("table.ListStyle tbody tr[class!='Spacing']").hover(
		function(){
			jQuery(this).find('img[_moveimg]').attr('src','/proj/img/move-hot_wev8.png');
		},function(){
			jQuery(this).find('img[_moveimg]').attr('src','/proj/img/move_wev8.png');
	});
}

</script>
</HEAD>

<%
	String titlename = "";
	String qname = Util.null2String(request.getParameter("qname"));

	RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();
	String subcategoryid=RecordSet.getString("subcategoryid");
	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);
	//初始值
    boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	MultiAclManager am = new MultiAclManager();
	//hasSubManageRight = am.hasPermission(mainid, MultiAclManager.CATEGORYTYPE_MAIN, user, MultiAclManager.OPERATION_CREATEDIR);
	int parentId = Util.getIntValue(scc.getParentId(""+id));
	if(parentId>0){
		hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
	}
    String disableLable = "disabled";
    boolean canEdit = false ;
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user) || hasSecManageRight) {
		canEdit = true ;
        disableLable="";
    }

	int detachable = ManageDetachComInfo.isUseDocManageDetach()?1:0;
  int operatelevel=0;
  if(detachable==1){
	   operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryEdit:Edit",Util.getIntValue(scc.getSubcompanyIdFQ(id+""),0));
  }else{
	   if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) || hasSecManageRight)
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
<%//菜单
if (canEdit) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(33431,user.getLanguage())+",javascript:openDialog(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,33331",user.getLanguage())+",javascript:newCusField(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
	<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(canEdit){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(33431, user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<FORM METHOD="POST" name="frmProperties" ACTION="DocSecCategoryDocPropertiesEditOperation.jsp">
	<INPUT TYPE="hidden" NAME="method" VALUE="save">
	<INPUT TYPE="hidden" NAME="secCategoryId" value="<%=id%>">

	
	
	<%
	SecCategoryDocPropertiesComInfo.addDefaultDocProperties(Util.getIntValue(id));
	String sqlWhere = "secCategoryId="+id+" and (labelid is null or labelid not in ("+MultiAclManager.MAINCATEGORYLABEL+","+MultiAclManager.SUBCATEGORYLABEL+"))";
	if(!qname.equals("")){
		sqlWhere += " and customname like '%"+qname+"%'";
	}
	String  operateString= "";
	 String tabletype="checkbox";
	String tableString=""+
	   "<table instanceid=\"docMouldTable\" needPage=\"false\" pagesize=\"1000\" tabletype=\""+tabletype+"\">"+
	    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getDocSecDirPropCheckbox\" popedompara = \"column:id\" />"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"DocSecCategoryDocProperty\" sqlorderby=\"viewindex\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
	   "<head>"+
	   "<col width=\"0%\" hide=\"true\" text=\"\" editPlugin=\"propertyIdPlugin\" column=\"id\"/>"+
	   "<col width=\"0%\" hide=\"true\" text=\"\" editPlugin=\"isCustomPlugin\" column=\"isCustom\"/>"+
	   "<col width=\"0%\" hide=\"true\"  text=\"\" editPlugin=\"scopePlugin\" column=\"scope\"/>"+
	   "<col width=\"0%\" hide=\"true\" text=\"\" editPlugin=\"scopeIdPlugin\" column=\"scopeid\"/>"+
	   "<col width=\"0%\" hide=\"true\" text=\"\" editPlugin=\"fieldId1Plugin\" column=\"fieldid\"/>"+
	   "<col width=\"0%\" hide=\"true\" text=\"\" editPlugin=\"stypePlugin\" column=\"type\"/>"+	
	   "<col width=\"0%\" hide=\"true\" text=\"\" editPlugin=\"labelIdPlugin\" column=\"labelId\"/>"+
	   "<col width=\"0%\" hide=\"true\" text=\"\" editPlugin=\"mustInputPlugin\" column=\"mustInput\"/>"+	
	   "<col width=\"0%\" hide=\"true\" text=\"\" editPlugin=\"visiblePlugin\" column=\"visible\"/>"+					 
			 "<col width=\"5%\" transmethod=\"weaver.general.KnowledgeTransMethod.getSortImage\" text=\""+SystemEnv.getHtmlLabelName(338, user.getLanguage())+"\" column=\"id\"/>"+
			 "<col width=\"10%\"  transmethod=\"weaver.general.KnowledgeTransMethod.getPropName\" otherpara=\""+user.getLanguage()+"\" column=\"id\" text=\""+SystemEnv.getHtmlLabelName(261,user.getLanguage())+"\"/>"+
			 "<col width=\"8%\" editPlugin=\"chkVisiblePlugin\"  editEnableMethod=\"weaver.splitepage.transform.SptmForDoc.chkVisible\" editpara=\"column:labelId\" text=\""+SystemEnv.getHtmlLabelName(15603,user.getLanguage())+"\" column=\"visible\"/>"+
			 "<col width=\"15%\" editPlugin=\"customNamePlugin\" text=\""+SystemEnv.getHtmlLabelNames("17607",user.getLanguage())+"\" column=\"customname\"/>"+
			
			 "<col width=\"15%\" editPlugin=\"columnWidthPlugin\" text=\""+SystemEnv.getHtmlLabelName(19509,user.getLanguage())+"\" column=\"columnWidth\"/>"+
			 "<col width=\"7%\" editPlugin=\"chkMustInputPlugin\" editEnableMethod=\"weaver.splitepage.transform.SptmForDoc.chkMustInput\" editpara=\"column:labelId+column:isCustom\" text=\""+SystemEnv.getHtmlLabelName(18019,user.getLanguage())+"\" column=\"mustInput\"/>"+
	   "</head>"+
	   "</table>"; 
%>
<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<div id="propTable">
				<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
			</div>
		</wea:item>
	</wea:group>
</wea:layout>

<SCRIPT LANGUAGE=javascript>

var chkVisiblePlugin = {
		type:"checkbox",
		addIndex:false,
		options:[
			{text:"",value:"1",name:"chk_visible"},
		],
		bind:[
			{type:"click",fn:function(){
				var checked = jQuery(this).attr("checked");
				var mustInput = jQuery(this).closest("tr").find("input[name='mustInput']");
				var visible = jQuery(this).closest("tr").find("input[name='visible']");
				if(!checked){//不显示
					mustInput.attr("checked",false);
					mustInput.val(0);
					visible.val(0);
					var chk_visible = jQuery(this).closest("tr").find("input[name='chk_"+mustInput.attr("name")+"']");
					chk_visible.attr("checked",false);
					chk_visible.siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
				}else{
					visible.val(1);
					if(!jQuery(this).hasClass("jNiceChecked"))
						jQuery(this).addClass("jNiceChecked");
				}
				}
			}]
	};
	
var visiblePlugin = {
	type:"hidden",
	name:"visible",
	addIndex:false
}

var chkMustInputPlugin = {
		type:"checkbox",
		addIndex:false,
		options:[
			{text:"",value:"1",name:"chk_mustInput"},
		],
		bind:[
			{type:"click",fn:function(){
				var checked = jQuery(this).attr("checked");
				var mustInput = jQuery(this).closest("tr").find("input[name='mustInput']");
				var visible = jQuery(this).closest("tr").find("input[name='visible']");
				if(checked){//必填
					visible.attr("checked",true);
					visible.val(1);
					mustInput.val(1);
					var chk_mustInput = jQuery(this).closest("tr").find("input[name='chk_"+visible.attr("name")+"']");
					var obj = chk_mustInput.siblings("span.jNiceCheckbox");
					chk_mustInput.attr("checked",true);
					if(!obj.hasClass("jNiceChecked")){
					 obj.addClass("jNiceChecked");
					}
				}else{
					mustInput.val(0);
					jQuery(this).removeClass("jNiceChecked");
				}
				}
			}
		]
	};
	
var customNamePlugin = {
	type:"input",
	name:"customName",
	addIndex:false,
	notNull:false
}

var customNameEngPlugin = {
	type:"input",
	name:"customNameEng",
	addIndex:false,
	notNull:false
}

var customNameTranPlugin = {
	type:"input",
	name:"customNameTran",
	addIndex:false,
	notNull:false
}

var propertyIdPlugin = {
	type:"hidden",
	name:"propertyid",
	addIndex:false
}
var mustInputPlugin = {
	type:"hidden",
	name:"mustInput",
	addIndex:false
}

var isCustomPlugin = {
	type:"hidden",
	name:"isCustom",
	addIndex:false
}

var scopePlugin = {
	type:"hidden",
	name:"scope",
	addIndex:false
}

var scopeIdPlugin = {
	type:"hidden",
	name:"scopeid",
	addIndex:false
}

var fieldId1Plugin = {
	type:"hidden",
	name:"fieldid1",
	addIndex:false
}

var stypePlugin = {
	type:"hidden",
	name:"stype",
	addIndex:false
}

var labelIdPlugin = {
	type:"hidden",
	name:"labelId",
	addIndex:false
}

var columnWidthPlugin = {
	type:"select",
	name:"columnWidth",
	addIndex:false,
	defaultValue:"1",
	options:[
		{text:"<%=SystemEnv.getHtmlLabelName(19802,user.getLanguage())%>",value:"1"},
		{text:"<%=SystemEnv.getHtmlLabelName(19803,user.getLanguage())%>",value:"2"}
	]
}

function registerDragEvent(){
		var copyTR = null;
		var startIdx = 0;
		jQuery("#propTable").find("table.ListStyle tbody tr").bind("mousedown",function(e){
			copyTR = jQuery(this).next("tr.Spacing");
		});

    	 var fixHelper = function(e, ui) {
            ui.children().each(function() {  
                jQuery(this).width(jQuery(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了  
            });  
            return ui;  
        }; 
         jQuery("#propTable").find("table.ListStyle tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
             helper: fixHelper,                  //调用fixHelper  
             axis:"y",  
             start:function(e, ui){
             	if(copyTR){
             		copyTR.hide();
             	}
             	startIdx = ui.item.get(0).rowIndex;
                 ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
                 return ui;  
             },  
             stop:function(e, ui){
             	if(copyTR){
             	  if(ui.item.get(0).rowIndex>startIdx){
             	  	ui.item.before(copyTR.clone().show());
             	  }else{
             	  	ui.item.after(copyTR.clone().show());
             	  }
             	  copyTR.remove();
             	  copyTR = null;
             	}
                 ui.item.removeClass("e8_hover_tr");
                return ui;  
             }  
         });  
    }

function onSave(obj){
	if(checkUserDefinitionFieldLabel()){
		obj.disabled = true;
		document.frmProperties.submit();
	}
}

function checkUserDefinitionFieldLabel(){
  var fieldlabels = eval("document.frmProperties.fieldlable");
  /*if(fieldlabels!=null&&fieldlabels.value!=null&&fieldlabels.value==""){
  		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19522, user.getLanguage())%>!");
  		return false;
  }
  for(var i=0;fieldlabels!=null&&fieldlabels.length!=null&&i<fieldlabels.length;i++){
  	if(fieldlabels[i].value==""){
  		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19522, user.getLanguage())%>!");
  		return false;
  	}
  	for(var j=0;j<fieldlabels.length;j++){
  		if(fieldlabels[i].value==fieldlabels[j].value&&i!=j){
	  		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19523, user.getLanguage())%>!");
	  		return false;
	  	}
  	}
  }*/
  return true;
}

function addToSettingInput(){
	
	if(!checkUserDefinitionFieldLabel()) return;
	
	var inputsetting = $('inputsetting');
	var inputface = $('inputface');
	
	var needaddlist = new Array();
	var needupdlist = new Array();
	var needdellist = new Array();
	
	if(inputface!=null&&inputsetting!=null){
		for(var i=0;i<inputsetting.rows.length;i++){
			var settingrow = inputsetting.rows[i];
			if(settingrow!=null&&settingrow.children[0].children[0]!=null&&(settingrow.children[0].children[0].value==-1||settingrow.children[0].children[1].value==1)){
				var settinglablename = settingrow.children[3].children[0].value.substring(0,settingrow.children[3].children[0].value.lastIndexOf("("));
				var settingfieldid =  settingrow.children[0].children[4].value;
				var flag = true;
				for(var j=0;j<inputface.rows.length;j++){
					var facerow = inputface.rows[j];
					if(facerow!=null&&facerow.children[0].children[0]!=null){
						var facelablename = facerow.children[0].children[0].value;
						var facefieldid = facerow.children[0].children[1].value;
						if(settinglablename!=facelablename&&(settingfieldid==facefieldid&&facefieldid!=-1)){
							flag = false;
							break;
						}
					}
				}
				if(!flag){
					needupdlist[needupdlist.length]=settingrow;
					needupdlist[needupdlist.length]=facerow;
				}
			}
		}
		
		for(var i=0;i<needupdlist.length;i+=2){
			var currrow1 = needupdlist[i];
			var currrow2 = needupdlist[i+1];
			currrow1.children[1].innerHTML=currrow1.children[1].innerHTML.replace(currrow1.children[3].children[0].value.substring(0,currrow1.children[3].children[0].value.lastIndexOf("(")),currrow2.children[0].children[0].value);
			currrow1.children[3].children[0].value=currrow1.children[3].children[0].value.replace(currrow1.children[3].children[0].value.substring(0,currrow1.children[3].children[0].value.lastIndexOf("(")),currrow2.children[0].children[0].value);
		}

		for(var j=0;j<inputface.rows.length;j++){
			var facerow = inputface.rows[j];
			if(facerow!=null&&facerow.children[0].children[1]!=null){
				var facelablename = facerow.children[0].children[0].value;
				var flag = false;
				for(var i=0;i<inputsetting.rows.length;i++){
					var settingrow = inputsetting.rows[i];
					if(settingrow!=null&&settingrow.children[0].children[1]!=null&&settingrow.children[0].children[1].value==1){
						var settinglablename = settingrow.children[3].children[0].value.substring(0,settingrow.children[3].children[0].value.lastIndexOf("("))
						if(settinglablename==facelablename){
							flag = true;
							break;
						}
					}
				}
				if(!flag){
					needaddlist[needaddlist.length]=facerow;
				}
			}
		}
		
		for(var i=0;i<inputsetting.rows.length;i++){
			var settingrow = inputsetting.rows[i];
			if(settingrow!=null&&settingrow.children[0].children[0]!=null&&(settingrow.children[0].children[0].value==-1||settingrow.children[0].children[1].value==1)){
				var settinglablename = settingrow.children[3].children[0].value.substring(0,settingrow.children[3].children[0].value.lastIndexOf("("));
				var settingfieldid =  settingrow.children[0].children[4].value;
				var flag = false;
				for(var j=0;j<inputface.rows.length;j++){
					var facerow = inputface.rows[j];
					if(facerow!=null&&facerow.children[0].children[0]!=null){
						var facelablename = facerow.children[0].children[0].value;
						var facefieldid = facerow.children[0].children[1].value;
						if(settinglablename==facelablename||(settingfieldid==facefieldid&&facefieldid!=-1)){
							flag = true;
							break;
						}
					}
				}
				if(!flag){
					needdellist[needdellist.length]=settingrow;
				}
			}
		}
		
		for(var i=0;i<needaddlist.length;i++){
			var currrow = needaddlist[i];
			var oRow = inputsetting.insertRow(-1);
			var oCell = oRow.insertCell(-1);
			oCell.innerHTML = $('settinglabel1').innerHTML;
			oCell = oRow.insertCell(-1);
			oCell.innerHTML = $('settinglabel2').innerHTML.replace("#name#",currrow.children[0].children[0].value+"(<%=SystemEnv.getHtmlLabelName(19516, user.getLanguage())%>)");
			oCell = oRow.insertCell(-1);
			oCell.className = "Field";
			oCell.innerHTML = $('settinglabel3').innerHTML;
			oCell = oRow.insertCell(-1);
			oCell.className = "Field";
			oCell.innerHTML = $('settinglabel4').innerHTML.replace("#name#",currrow.children[0].children[0].value.replace(new RegExp(" ","gm"),"@")+"(<%=SystemEnv.getHtmlLabelName(19516, user.getLanguage())%>)");
			oCell = oRow.insertCell(-1);
			oCell.className = "Field";
			oCell.innerHTML = $('settinglabel5').innerHTML;
			oCell = oRow.insertCell(-1);
			oCell.className = "Field";
			oCell.innerHTML = $('settinglabel6').innerHTML.replace("#checked#",(currrow.children[4].children[0].value==1?"checked":"")).replace("#mustInput#",currrow.children[4].children[0].value);
			
			oRow = inputsetting.insertRow(-1);
			oRow.style.height="1px"
			oCell = oRow.insertCell(-1);
			oCell.colSpan = 6;
			oCell.className = "Line";
		}
		
		for(var i=0;i<needdellist.length;i++){
			var currrow = needdellist[i];
			
			var curtable = jQuery(currrow).parents("table:first")[0]
			
			curtable.deleteRow(currrow.rowIndex+1);
			curtable.deleteRow(currrow.rowIndex);
		}
	}
	setImgArrow();
}


function onSettingUp(obj){
	var currRow = jQuery(obj).parents("tr:first")[0];//.parentElement.parentElement;
	
	if(currRow!=null){
		var currTable = jQuery(currRow).parents("table:first")[0];
		if(currRow.rowIndex-1<=0) return;

		var insRow1 = currTable.insertRow(currRow.rowIndex-2<0?0:currRow.rowIndex-2);
		//style.height="1px!important;"
			insRow1.style.height="1px"
		var insCell1 = insRow1.insertCell(-1);
		insCell1.colSpan = 6;
		insCell1.className = "Line";

		var insRow2 = currTable.insertRow(insRow1.rowIndex<0?0:insRow1.rowIndex);
		
		for(var i=0; i<6; i++){
			var insCell2 = insRow2.insertCell(-1);
	    	if(i>1) insCell2.className = "field";
				insCell2.innerHTML = currRow.cells[i].innerHTML;
	    	
		}
		//jQuery(currRow).next().remove();
		//jQuery(currRow).remove();
		currTable.deleteRow(currRow.rowIndex+1);
		currTable.deleteRow(currRow.rowIndex);
	}
	setImgArrow();
}

function onSettingDown(obj){
	var currRow = jQuery(obj).parents("tr:first")[0]
	if(currRow!=null){
		var currTable = jQuery(currRow).parents("table:first")[0];
		if(currRow.rowIndex+2>=currTable.rows.length) return;

		var insRow1 = currTable.insertRow(currRow.rowIndex+3>currTable.rows.length?currTable.rows.length:currRow.rowIndex+3);
		insRow1.style.height="1px"
		var insCell1 = insRow1.insertCell(-1);
		insCell1.colSpan = 6;
		
		insCell1.className = "Line";

		var insRow2 = currTable.insertRow(insRow1.rowIndex+1>currTable.rows.length?currTable.rows.length:insRow1.rowIndex+1);
		for(var i=0; i<6; i++){
			var insCell2 = insRow2.insertCell(-1);
	    if(i>1) insCell2.className = "field";
			insCell2.innerHTML = currRow.cells[i].innerHTML;
		}

		currTable.deleteRow(currRow.rowIndex-1);
		currTable.deleteRow(currRow.rowIndex);
		
	}
	setImgArrow();
}

function setImgArrow(){
	var imgArrow = $A(document.getElementsByName('imgArrowUp'));
	for(var i=0;imgArrow!=null&&i<imgArrow.length;i++){
		if(i==0) imgArrow[i].style.visibility = "hidden";
		else imgArrow[i].style.visibility = "visible";
	}
	var imgArrow = $A(document.getElementsByName('imgArrowDown'));
	for(var i=0;imgArrow!=null&&i<imgArrow.length;i++){
		if(i==imgArrow.length-2) imgArrow[i].style.visibility = "hidden";
		else imgArrow[i].style.visibility = "visible";
	}
}

function setCheckBox(obj,flag){
	var another = jQuery(obj).parent().parent()[0].children[(flag==1?5:2)].children[0];
	var another1 = jQuery(obj).parent().parent()[0].children[(flag==1?5:2)].children[1];
	
	if(flag==1){
		if(another!=null){
			if(obj.checked) return;
			if(another.style.display!="none"){
				another.checked = obj.checked;
				another1.value = another.checked?1:0;
			}
		}
	}else{
		if(another!=null){
			if(!obj.checked) return;

			another.checked = obj.checked;
			another1.value = another.checked?1:0;
		}
	}
}

</SCRIPT>


<!-- 自定义字段 -->
<SCRIPT LANGUAGE=javascript>
function addrow(){
	var oRow;
	var oCell;

	oRow = inputface.insertRow(-1);
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = flable.innerHTML ;
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = fhtmltype.innerHTML;
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = ftype1.innerHTML ;
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = ftype5.innerHTML ;
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
    oCell.innerHTML = fismand.innerHTML ;
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = action.innerHTML ;
}

function addrow2(obj){
	var tobj = jQuery(obj).parent().parent()[0].cells[3].children[0];
	var oRow;
	var oCell;

	oRow = tobj.insertRow(-1);
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = fselectitem.innerHTML ;
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = itemaction.innerHTML ;

}

function delitem(obj){
	var rowobj = jQuery(obj).parent().parent()[0];
	
	jQuery(rowobj).parent().parent()[0].deleteRow(rowobj.rowIndex);
}

function upitem(obj){
	if(jQuery(obj).parent().parent()[0].rowIndex==0){
		return;
	}
	var tobj = jQuery(obj).parent().parent().parent()[0];
	var rowobj = tobj.insertRow(jQuery(obj).parent().parent()[0].rowIndex-1);
	for(var i=0; i<2; i++){
		var cellobj = rowobj.insertCell(-1)
        cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = jQuery(obj).parent().parent()[0].cells[i].innerHTML;
		cellobj.children[0].value = jQuery(obj).parent().parent()[0].cells[i].children[0].value
	}

	tobj.deleteRow(jQuery(obj).parent().parent()[0].rowIndex);
}

function downitem(obj){
	var ctr = jQuery(obj).parent().parent()[0];
	var tobj = jQuery(ctr).parent()[0];
	if(ctr.rowIndex==tobj.rows.length-1){
		return;
	}
	//var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(ctr.rowIndex+2);
	for(var i=0; i<2; i++){
		var cellobj = rowobj.insertCell(-1)
        cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = ctr.cells[i].innerHTML;
		cellobj.children[0].value = ctr.cells[i].children[0].value
	}

	tobj.deleteRow(ctr.rowIndex);
}

function del(obj){
	
	jQuery(obj).parents("tr:first").remove();
	//var rowobj = obj.parentElement.parentElement;
	//rowobj.parentElement.deleteRow(rowobj.rowIndex);
}

function up(obj){
	var ctr = jQuery(obj).parent().parent()[0];
	var tobj = jQuery(ctr).parent()[0];
	if(ctr.rowIndex==0){
		return;
	}
	//var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(ctr.rowIndex-1);
	for(var i=0; i<6; i++){
		var cellobj = rowobj.insertCell(-1)
        cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = ctr.cells[i].innerHTML;
	}

	tobj.deleteRow(ctr.rowIndex);
}

function down(obj){
	var ctr = jQuery(obj).parent().parent()[0];
	var tobj = jQuery(ctr).parent()[0];
	if(ctr.rowIndex==tobj.rows.length-1){
		return;
	}
	//var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(ctr.rowIndex+2);
	for(var i=0; i<6; i++){
		var cellobj = rowobj.insertCell(-1)
        cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = ctr.cells[i].innerHTML;
	}

	tobj.deleteRow(ctr.rowIndex);
}

function htmltypeChange(obj){
	if(obj.selectedIndex == 0){
		jQuery(obj).parent().parent().children("::eq(2)").html(ftype1.innerHTML) ;
		jQuery(obj).parent().parent().children("::eq(3)").html(ftype5.innerHTML) ;
	}else if(obj.selectedIndex == 2){
		jQuery(obj).parent().parent().children("::eq(2)").html(ftype2.innerHTML) ;
		jQuery(obj).parent().parent().children("::eq(3)").html(ftype4.innerHTML+fdefinebroswerTypeDefault.innerHTML) ;
	}else if(obj.selectedIndex == 4){
		jQuery(obj).parent().parent().children("::eq(2)").html(fselectaction.innerHTML) ;
		jQuery(obj).parent().parent().children("::eq(3)").html(fselectitems.innerHTML) ;
	}else{
		jQuery(obj).parent().parent().children("::eq(2)").html(ftype3.innerHTML) ;
		jQuery(obj).parent().parent().children("::eq(3)").html(ftype4.innerHTML) ;
	}
}

function typeChange(obj){
	if(obj.selectedIndex == 0){
		jQuery(obj).parent().parent().children("::eq(3)").html(ftype5.innerHTML) ;
	}else{
		jQuery(obj).parent().parent().children("::eq(3)").html(ftype4.innerHTML) ;
	}
}

function broswertypeChange(obj){
    var  broswertype=obj.options[obj.selectedIndex].value;
	if(broswertype==161||broswertype==162){
		jQuery(obj).parent().parent().children("::eq(3)").html(ftype4.innerHTML+fdefinebroswerType.innerHTML) ;
	}else{
		jQuery(obj).parent().parent().children("::eq(3)").html(ftype4.innerHTML+fdefinebroswerTypeDefault.innerHTML) ;
	}
}

function clearTempObj(){
    flable.innerHTML="";
    fhtmltype.innerHTML="";
    ftype1.innerHTML="";
    ftype2.innerHTML="";
    ftype3.innerHTML="&nbsp;";
    ftype4.innerHTML="&nbsp;";
    ftype5.innerHTML="";
    fselectaction.innerHTML="";
    fselectitems.innerHTML="";
    fselectitem.innerHTML="";
    fismand.innerHTML="";
}

var selectRowObj;
function importSel(obj){
    selectRowObj = obj;
    //id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CustomSelectFieldBrowser.jsp");
    var ret = showSelectRow();
    if(ret != ""){
        document.all("selectItemGetter").src="SelectRowGetter.jsp?fieldid="+ret;
    }
}

function showSelectRow(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_scroll:"no",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	var data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CustomSelectFieldBrowser.jsp",null,"addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	return data.id
}

</SCRIPT>

<iframe name="selectItemGetter" style="width:100%;height:200;display:none"></iframe>

	<table class="viewForm" style="display:none;">
		<COLGROUP>
		<COL width="25%">
		<COL width="75%">
		<TBODY>
		<TR class=Spacing>
           	<TD colSpan=2></TD>
		</TR>
		<TR class=Title>
			<TH><%=SystemEnv.getHtmlLabelName(17037,user.getLanguage())%></TH>
			<TH>
			<%
		    if(canEdit){
			%>
				<div align="right">
					<BUTTON Class=Btn type=button accessKey=A onclick="addrow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%></BUTTON>
					<BUTTON Class=Btn type=button accessKey=S onclick="addToSettingInput()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
				</div>
			<%
			}
			%>
			</TH>
		</TR>
		<TR class=Spacing  style="height: 1px!important;">
           	<TD class=Line1 colSpan=2></TD>
		</TR>
		</TBODY>
	</table>

<%
    CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",Util.getIntValue(id));
    cfm.getCustomFields();
%>
<TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 id="inputface" style="display:none;">
<COLGROUP>
	<col width="21%" valign="top">
	<col width="20%" valign="top">
	<col width="21%" valign="top">
	<col width="21%" valign="top">
	<col width="10%" valign="top">
	<col width="*" valign="top">
    <%while(cfm.next()){
    %>
   
    <tr>
    <td style="border-bottom:silver 1pt solid"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>:<input class=InputStyle name="fieldlable" value="<%=cfm.getLable()%>" <%=disableLable%> size=16 onblur="addToSettingInput()"><input type="hidden" name="fieldid" value="<%=cfm.getId()%>" ></td>
    <td style="border-bottom:silver 1pt solid">
    <%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%>:
    <%if(cfm.getHtmlType().equals("1")){%>
        <%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%>
    <%} else if(cfm.getHtmlType().equals("2")){%>
        <%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%>
    <%} else if(cfm.getHtmlType().equals("3")){%>
        <%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%>
    <%} else if(cfm.getHtmlType().equals("4")){%>
        <%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%>
    <%} else if(cfm.getHtmlType().equals("5")){%>
        <%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%>
    <%} %>
    <input name="fieldhtmltype" type="hidden" value="<%=cfm.getHtmlType()%>" >
    </td>

    <%if(cfm.getHtmlType().equals("1")){%>
        <td style="border-bottom:silver 1pt solid">
        <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
        <%if(cfm.getType() == 1){%>
            <%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%>
        <%} else if(cfm.getType() == 2){%>
            <%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%>
        <%} else if(cfm.getType() == 3){%>
            <%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%>
        <%} %>
        <input name="type" type="hidden" value="<%=cfm.getType()%>">
        <input name="definebroswerType" type="hidden" value="">
        </td>
        <td style="border-bottom:silver 1pt solid">
            <%if(cfm.getType()==1){%>
                <%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>:<%=cfm.getStrLength()%>
                <input  name="flength" type="hidden" value="<%=cfm.getStrLength()%>">
            <%}else{%>
                <input name="flength" type="hidden" value="100">
            <%}%>
        </td>
    <%}else if(cfm.getHtmlType().equals("3")){%>
        <td style="border-bottom:silver 1pt solid">
            <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(String.valueOf(cfm.getType())),0),7)%>
            <input name="type" type="hidden" value="<%=cfm.getType()%>">
            <input name="definebroswerType" type="hidden" value="<%=(cfm.getType()==161||cfm.getType()==162)?cfm.getFieldDbType():""%>">
			<%=(cfm.getType()==161||cfm.getType()==162)?cfm.getFieldDbType():""%>
       </td>
        <td style="border-bottom:silver 1pt solid">
            <input name="flength" type="hidden" value="100">
        </td>
    <%}else if(cfm.getHtmlType().equals("5")){%>
        <td style="border-bottom:silver 1pt solid">
            <input name="type" type="hidden" value="0">
            <input name="definebroswerType" type="hidden" value="">
<%
    if(canEdit){
%>
            <BUTTON Class=Btn type=button accessKey=A onclick="addrow2(this)"><%=SystemEnv.getHtmlLabelName(18597,user.getLanguage())%></BUTTON><br>
            <BUTTON Class=Btn type=button accessKey=I onclick="importSel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></BUTTON>
<%
    }
%>
        </td>
        <td style="border-bottom:silver 1pt solid">

            <TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 >
            <COLGROUP>
                <col width="40%">
                <col width="60%">
            </COLGROUP>
     <%
        cfm.getSelectItem(cfm.getId());
        while(cfm.nextSelect()){
     %>
        <tr>
            <td>
            	<input name="selectitemid" type="hidden" value="<%=cfm.getSelectValue()%>" >
	            <input  class=InputStyle name="selectitemvalue" type="text" value="<%=cfm.getSelectName()%>" style="width:100"  <%=disableLable%>>
            </td>
            <td>
                <%if(canEdit){%>
                <img src="/images/icon_ascend_wev8.gif" height="14" onclick="upitem(this)" style="cursor:pointer">
                <img src="/images/icon_descend_wev8.gif" height="14" onclick="downitem(this)" style="cursor:pointer">
                <img src="/images/delete_wev8.gif" height="14" onclick="delitem(this)" style="cursor:pointer">
                <%}%>
            </td>
        </tr>

     <%}%>

            </TABLE>
            <input name="selectitemid" type="hidden" value="--">
            <input name="selectitemvalue" type="hidden" >

            <input name="flength" type="hidden" value="100">
        </td>
    <%}else{%>
        <td style="border-bottom:silver 1pt solid">
            <input name="type" type="hidden" value="0">
            <input name="definebroswerType" type="hidden" value="">
        </td>
        <td style="border-bottom:silver 1pt solid">
            <input name="flength" type="hidden" value="100">
        </td>
    <%}%>
    <%%>
        <td style="border-bottom:silver 1pt solid">
            <%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>:
            <select size="1" name="ismand"  <%=disableLable%>>
                <option value="0" <%=cfm.isMand()?"":"selected"%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
                <option value="1" <%=cfm.isMand()?"selected":""%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
            </select>
        </td>
    <%%>

        <td style="border-bottom:silver 1pt solid">
            <%if(canEdit){%>
            <img src="/images/icon_ascend_wev8.gif" height="14" onclick="up(this)" style="cursor:pointer;visibility:hidden">
            <img src="/images/icon_descend_wev8.gif" height="14" onclick="down(this)" style="cursor:pointer;visibility:hidden">
            <img src="/images/delete_wev8.gif" height="14" onclick="del(this);addToSettingInput();" style="cursor:pointer">
            <%}%>
        </td>
    </tr>
    <%}%>

</TABLE>

</FORM>

<div style="DISPLAY: none" id="flable">
<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>:<input class=InputStyle name="fieldlable" size=16 onblur="addToSettingInput()" <%=disableLable%>><input  type="hidden" name="fieldid" value="-1">
</div>

<div style="DISPLAY: none" id="fhtmltype">
	<%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%>:
    <select size="1" name="fieldhtmltype" onChange = "htmltypeChange(this)" <%=disableLable%>>
		<option value="1" selected><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
		<option value="2" ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
		<option value="3" ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
		<option value="4" ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
		<option value="5" ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
    </select>
</div>

<div style="DISPLAY: none" id="ftype1">
	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
	<select size=1 name=type onChange = "typeChange(this)" <%=disableLable%>>
		<option value="1" selected><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
	</select>
	<input name=definebroswerType type=hidden value="">
</div>

<div style="DISPLAY: none" id="ftype2">
	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
	<select size=1 name=type onChange = "broswertypeChange(this)" <%=disableLable%>>
    <%while(BrowserComInfo.next()){
    		 	 if(("226".equals(BrowserComInfo.getBrowserid()))||"227".equals(BrowserComInfo.getBrowserid())||"224".equals(BrowserComInfo.getBrowserid())||"225".equals(BrowserComInfo.getBrowserid())){
	        	 //屏蔽集成浏览按钮-zzl
				continue;
			}
    %>
		<option value="<%=BrowserComInfo.getBrowserid()%>" ><%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),7)%></option>
    <%}%>
	</select>
</div>

<div style="DISPLAY: none" id="fdefinebroswerType">
	<select size=1 name=definebroswerType <%=disableLable%>>
<%--
    List l=StaticObj.getServiceIds(Browser.class);
    for(int j=0;j<l.size();j++){
%>
        <option value='<%=l.get(j)%>' ><%=l.get(j)%></option>
<%
	}
--%>
	</select>
</div>

<div style="DISPLAY: none" id="fdefinebroswerTypeDefault">
	<input name=definebroswerType type=hidden value="">
</div>

<div style="DISPLAY: none" id="ftype3">
	&nbsp;<input name=type type=hidden value="0">
	<input name=definebroswerType type=hidden value="">
</div>

<div style="DISPLAY: none" id="ftype4">
	&nbsp;<input name=flength type=hidden  value="100">
</div>

<div style="DISPLAY: none" id="ftype5">
	<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>:<input  class=InputStyle name=flength type=text value="100" maxlength=4 style="width:50" <%=disableLable%>>
</div>

<div style="DISPLAY: none" id="fismand">
	<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>:
	<select size=1 name=ismand <%=disableLable%>>
		<option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
		<option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	</select>
</div>

<div style="DISPLAY: none" id="fselectaction">
	<input name=type type=hidden  value="0">
	<input name=definebroswerType type=hidden value="">
	<BUTTON Class=Btn type=button accessKey=A onclick="addrow2(this)" <%=disableLable%>><%=SystemEnv.getHtmlLabelName(18597,user.getLanguage())%></BUTTON><br>
    <BUTTON Class=Btn type=button accessKey=I onclick="importSel(this)" <%=disableLable%>><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></BUTTON>
</div>

<div style="DISPLAY: none" id="fselectitems">
	<TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 >
	<COLGROUP>
		<col width="40%">
		<col width="60%">
	</COLGROUP>
	</TABLE>
    <input name=selectitemid type=hidden value="--">
	<input name=selectitemvalue type=hidden >

    <input name=flength type=hidden  value="100">
</div>

<div style="DISPLAY: none" id="fselectitem">
	<input name=selectitemid type=hidden value="-1" >
	<input  class=InputStyle name=selectitemvalue type=text style="width:100" <%=disableLable%>>
</div>

<div style="DISPLAY: none" id="itemaction">
  <img src="/images/icon_ascend_wev8.gif" height="14" onclick="upitem(this)" style="cursor:pointer" <%=disableLable%>>
  <img src="/images/icon_descend_wev8.gif" height="14" onclick="downitem(this)" style="cursor:pointer" <%=disableLable%>>
	<img src="/images/delete_wev8.gif" height="14" onclick="delitem(this)" style="cursor:pointer" <%=disableLable%>>
</div>

<div style="DISPLAY: none" id="action">
    <img src="/images/icon_ascend_wev8.gif" height="14" onclick="up(this)" style="cursor:pointer;visibility:hidden" <%=disableLable%>>
    <img src="/images/icon_descend_wev8.gif" height="14" onclick="down(this)" style="cursor:pointer;visibility:hidden" <%=disableLable%>>
	<img src="/images/delete_wev8.gif" height="14" onclick="del(this);addToSettingInput();" style="cursor:pointer" <%=disableLable%>>
</div>

<!-- 自定义字段结束 -->

<div style="DISPLAY: none" id="settinglabel1">
	<input type="hidden" name="propertyid" value="-1">
	<input type="hidden" name="isCustom" value="1">
	<input type="hidden" name="scope" value="">
	<input type="hidden" name="scopeid" value="-1">
	<input type="hidden" name="fieldid1" value="-1">
	<input type="hidden" name="stype" value="0">
    <%if(canEdit){%>
    <img id="imgArrowUp" src="/images/ArrowUpGreen_wev8.gif" onclick="onSettingUp(this);" style="cursor:pointer">&nbsp;
	<img id="imgArrowDown" src="/images/ArrowDownRed_wev8.gif" onclick="onSettingDown(this);" style="cursor:pointer;visibility:hidden">
    <%}%>
</div>

<div style="DISPLAY: none" id="settinglabel2">
	#name#<input type="hidden" name="labelId" value="-1">
</div>

<div style="DISPLAY: none" id="settinglabel3">
	<INPUT type="checkbox" class=InputStyle name="chk_visible" <%=disableLable%> onclick="jQuery(this).parent().children('::eq(1)')[0].value=(this.checked)?1:0;setCheckBox(this,1);" checked>
	<INPUT type="hidden" class=InputStyle name="visible" value="1">
</div>

<div style="DISPLAY: none" id="settinglabel4">
	<INPUT type="text" class=InputStyle name="customName" value="#name#" style="display:none" <%=disableLable%>>&nbsp;
</div>

<div style="DISPLAY: none" id="settinglabel5">
	<select class=InputStyle name="columnWidth" <%=disableLable%>>
		<option value="1" selected><%=SystemEnv.getHtmlLabelName(19802,user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(19803,user.getLanguage())%></option>
	</select>
	<%--<INPUT type="text" class=InputStyle name="columnWidth" size="3" maxLength="2" value="2">--%>
</div>
		
<div style="DISPLAY: none" id="settinglabel6">
	<INPUT type="checkbox" class=InputStyle name="chk_mustInput" <%=disableLable%> style='display:none' onclick="jQuery(this).parent().children('::eq(1)')[0].value=(this.checked)?1:0;setCheckBox(this,2);" #checked#>
	<INPUT type="hidden" class=InputStyle name="mustInput" value="#mustInput#">
</div>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
