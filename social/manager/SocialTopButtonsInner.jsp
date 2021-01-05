
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CRMFreeFieldManage" class="weaver.crm.Maint.CRMFreeFieldManage" scope="page"/>
<%@ page import="weaver.general.Util" %>

<%
	int rowsum = 0;
	String dbfieldnamesForCompare = ",";
	
	if (!HrmUserVarify.checkUserRight("message:manager", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	try{
           //$("#detaildata").html(ajax.responseText);
           jQuery("body").jNice();
           beautySelect();
           registerDragEvent();
       }catch(e){
           return false;
       }
	//绑定鼠标移动事件
	jQuery("tr[forsort='ON']").live("mouseover mouseout",function(e){
		e = e || window.event;
		if(e.type == "mouseover"){
	  		$(this).find('.navicobtn').css('display', 'inline-block');
			$(this).find('.navhoticobtn').css('display', 'inline-block');
	 	}else if(e.type == "mouseout"){
	  		$(this).find('.navicobtn').hide();
			$(this).find('.navhoticobtn').hide();
	 	}
	});
	//单点登录下拉框,站外登陆选择框
	jQuery("select[name^='groupid_']").each(function(){
		var selObj = $(this);
		var rowindex = $(this).attr("name").substring("groupid_".length);
		if(selObj.val() != '0'){
			checkUriType(this,rowindex);
		}
	});
});

//选择图标
function checkFileType(upload) {
	var picPath = upload.value;
    var type = picPath.substring(picPath.lastIndexOf(".") + 1, picPath.length).toLowerCase();
    if (type != "jpg" && type != "bmp" && type != "gif" && type != "png") {
        alert("请上传正确的图片格式");
        return false;
    }
    
    var rowindex = $(upload).attr("id");
    rowindex = rowindex.split("_")[1];
    var target = $(upload).attr("target");
    if(upload.files && upload.files[0]) {
    	var reader = new FileReader();
    	reader.onload = function(e) {
			$("#"+target+"_"+rowindex).show().attr("src", e.target.result);
		}
    	reader.readAsDataURL(upload.files[0]);
    	setChange(rowindex);
    }
    checkUriTypeByRow(rowindex);
}

/***************************漂亮的分隔线******************************/

jQuery(function(){
	setTimeout(function(){
		hiddenRCMenuItem(5);
	},1000)
})

function showAllField(flag){
	document.body.click();
	if(1 == flag){
		
		jQuery("tr[forsort='ON']").each(function(){
			jQuery(this).show();
		});
		hiddenRCMenuItem(4);
		showRCMenuItem(5);
	}else{
		jQuery("input[type='checkbox'][name^='isopen_']").each(function(){
			if(!jQuery(this).is(":checked")){
				jQuery(this).parents("tr[forsort='ON']").css("display","none");
			}
		});
		hiddenRCMenuItem(5);
		showRCMenuItem(4);
	}

}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

//新建、编辑地址类型 add by Dracula @2014-1-24
function openDialog(rowindex){
	var index = rowindex;
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/base/ffield/CRM_FreeFieldSelect.jsp?index="+index;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage()) %>";
	dialog.Width = 400;
	dialog.Height = 300;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function setSelectOption(resultDatas){
	var selectObj = jQuery.find("select[name=selectOption_"+index+"]");
	jQuery(selectObj).empty();
	var value = "";
	for(var i=0;i<resultDatas.length;i++){
		var resultData = resultDatas[i];
		if(i>=1){
			value+=",,,";
		}
			
		var selectitemvalue = resultData[0].selectitemvalue;
		var selectitemid = resultData[1].selectitemid;
		value += selectitemid+"***"+selectitemvalue;
		jQuery(selectObj).append("<option value='"+selectitemid+"'>"+selectitemvalue+"</option>");
	}
	if(jQuery("#selectOption_"+index+"_value").val()){
		jQuery("#selectOption_"+index+"_value").val(value);
	}else{
		jQuery("form").append("<input type='hidden' id='selectOption_"+index+"_value' name='selectOption_"+index+"_value' value ='"+value+"'>");
	}
	
	setChange(index);
}


function registerDragEvent(){

	 var fixHelper = function(e, ui) {
        ui.children().each(function() {  
            jQuery(this).width(jQuery(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了  
            jQuery(this).height("30");						//在CSS中定义为40px,目前不能动态获取
        });  
        return ui;  
    }; 
     jQuery(".ListStyle tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
         helper: fixHelper,                  //调用fixHelper  
         axis:"y",  
         items:'tr.DataLight',  
         start:function(e, ui){
         	 ui.helper.addClass("moveMousePoint");
             ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
             if(ui.item.hasClass("notMove")){
             	e.stopPropagation();
             }
             $(".hoverDiv").css("display","none");
             return ui;  
         },  
         stop:function(e, ui){
             //ui.item.removeClass("ui-state-highlight"); //释放鼠标时，要用ui.item才是释放的行  
             jQuery(ui.item).hover(function(){
            	jQuery(this).addClass("e8_hover_tr");
            },function(){
            	jQuery(this).removeClass("e8_hover_tr");
            	
            });
            jQuery(ui.item).removeClass("moveMousePoint");
            sortOrderTitle();
            var id_index = jQuery(ui.item).find("input[name='check_select']").val();
            var rowindex = id_index.split("_")[1];
            var newIndex = $('#oTable tr.DataLight').index(ui.item);
			// 向上移动
			if(newIndex < rowindex) {
				for(var i = newIndex; i <= rowindex; ++i){
					checkUriTypeByRow(i);
				}
			}else if(newIndex > rowindex) {
				for(var i = rowindex; i <= newIndex; ++i){
					checkUriTypeByRow(i);
				}
			}
            return ui;  
         }  
     });  
}

function sortOrderTitle()
  {
  	var _fieldname = "";
  	$("#oTable tbody").find("tr[forsort=ON]").children("td:nth-child(2)").each(function(){
  		if(typeof($(this).find("input[type=text][name^=itemDspName_]").val()) == "undefined")
    			_fieldname += ","+$(this).find("input[type=hidden][name^=itemDspName_]").val();
			else
				_fieldname += ","+$(this).find("input[type=text][name^=itemDspName_]").val();
		
  	});
  	$("input[name=sortname]").val(_fieldname);
  }
  
  function maintOption(rowindex)
  {
  	openDialog(rowindex);
  }
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(570,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("AddSectorInfo:add", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addRow(),''} " ;
    RCMenuHeight += RCMenuHeightStep ;
    
    RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDel(),''} " ;
    RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),''} " ;
    RCMenuHeight += RCMenuHeightStep ;
    
    RCMenu += "{显示未启用字段,javascript:showAllField(1),''} " ;
    RCMenuHeight += RCMenuHeightStep ;
    
    RCMenu += "{显示启用字段,javascript:showAllField(0),''} " ;
    RCMenuHeight += RCMenuHeightStep ;
    
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:addRow();"/>&nbsp;&nbsp;
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage()) %>" class="e8_btn_top" onclick="javascript:doDel();"/>&nbsp;&nbsp;
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top" onclick="javascript:onSave(this);"/>&nbsp;&nbsp;
			
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 

<FORM id=weaver name="weaver" action="SocialManagerOperation.jsp" method=post enctype="multipart/form-data" onkeydown="if(event.keyCode==13)return false;">
<input type="hidden" name="method" value="savefieldbatch0">
<input type="hidden" value="0" name="maxRowIndex">
<input type="hidden" value="" name="deleteRowIds">
<input type="hidden" value="" name="changeRowIndexs">
<input type="hidden" value="" name="showIndexs">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0"  style="padding-bottom: 30px;">
<tr>
	<td valign="top" width="100%">
			<div id="detaildata">
				<jsp:include page="/social/manager/SocialTopButtonsDetail.jsp"></jsp:include>
			</div>
	</td>
</tr>
</table>
</FORM>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<script type="text/javascript">

	//全局变量
	var TBVars = {
		changeRowIndexs: ",",
		deleteRowIds: ",",
		showIndexs: ",",
		maxRowIndex: 0
	}
	//追加行
	function addRow(){
		var rowColor = getRowBg();
		var ncol = oTable.rows[0].cells.length;
		var rowindex = oTable.rows.length - 1;
		var oRow = oTable.insertRow(-1);
		oRow.style.height=24;
		$(oRow).attr("forsort","ON");
		$(oRow).attr("rowindex",rowindex);
		$(oRow).addClass("DataLight");
		setChange(rowindex);
		for(j=0; j<ncol; j++) {
			
			oCell = oRow.insertCell(j);
			oCell.noWrap=true;
			oCell.style.background=rowColor;
			switch(j){
				case 0:
					var oDiv = document.createElement("div");
					var sHtml = "<input   type='checkbox' name='check_select' value='0_"+rowindex+"'>";
					sHtml +="<input type='hidden' name='modifyflag_"+rowindex+"' value='0'>";
					sHtml += "&nbsp;<img moveimg='' src='/CRM/images/move_wev8.png' title='拖动' >";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
					
				case 1:
					var oDiv = document.createElement("div");
					var sHtml = "<input class='InputStyle' type='text' size='15' maxlength='30' id='itemDspName_"+rowindex+"' name='itemDspName_"+rowindex+"' style='width:90%' onfocus=\"checkUriTypeByRow("+rowindex+");\"  onblur=\"checkinput('itemDspName_"+rowindex+"','itemDspName_"+rowindex+"_span')\"><span id='itemDspName_"+rowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 2:
					var oDiv = document.createElement("div");
					var sHtml = 
					"<div style='display: inline-block;height: 24px;width: 24px;float: left;text-align: center;'>" +
						"<span style='height: 100%;display: inline-block;vertical-align: middle;'></span><img id='navico_"+rowindex+"' src='/social/images/pcmodels/htb_default_wev8.png' style='max-width: 24px; max-height: 24px;vertical-align: middle;'/>" +
					"</div>" +
					"<div class='navicobtn' style='position: relative;display: none;margin-left: 20px;'>" +
						"<button type = 'button' style='background: #30b5ff;color: #fff; width: 75px;height: 24px;text-align: center;'>" +
							"<%=SystemEnv.getHtmlLabelName(126779, user.getLanguage()) %>" +
			  			"</button>"+
			  			"<input id='navicobrowser_"+rowindex+"' type='file'  name='navico_"+rowindex+"' onchange='checkFileType(this);' target='navico' class='Inputstyle' style='position: absolute;left: 0;top: 0;opacity: 0;width: 75px;heigth: 24px;cursor: pointer;' multiple='false' accept='image/gif, image/jpeg, image/png, image/gif'>" +
		  			"</div>" +
		  			"<div style='clear:both;'></div>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 3:
					var oDiv = document.createElement("div");
					var sHtml = 
					"<div style='display: inline-block;height: 24px;width: 24px;float: left;text-align: center;'>" +
						"<span style='height: 100%;display: inline-block;vertical-align: middle;'></span><img id='navhotico_"+rowindex+"' src='/social/images/pcmodels/htb_default_h_wev8.png' style='max-width: 24px; max-height: 24px;vertical-align: middle;'/>" +
					"</div>" +
					"<div class='navhoticobtn' style='position: relative;display: none;margin-left: 20px;'>" +
						"<button type = 'button' style='background: #30b5ff;color: #fff; width: 75px;height: 24px;text-align: center;'>" +
							"<%=SystemEnv.getHtmlLabelName(126779, user.getLanguage()) %>" +
			  			"</button>"+
			  			"<input id='navhoticobrowser_"+rowindex+"' type='file' name='navhotico_"+rowindex+"' onchange='checkFileType(this);' target='navhotico' class='Inputstyle' style='position: absolute;left: 0;top: 0;opacity: 0;width: 75px;heigth: 24px;cursor: pointer;' multiple='false' accept='image/gif, image/jpeg, image/png, image/gif'>" +
		  			"</div>" +
		  			"<div style='clear:both;'></div>";	
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 4:
					var oDiv = document.createElement("div");
					oDiv.innerHTML = "<input type='checkbox' name='isopen_"+rowindex+"' value='1' checked='checked' onchange='checkSelect(this, "+rowindex+");setChange("+rowindex+");'>" +
					" <input type='hidden' name='isopen_"+rowindex+"' value='1'>";
					oCell.appendChild(oDiv);
					break;		
	            case 5:
	            {
	                var oDiv = document.createElement("div");
	                var sHtml = "<select name='groupid_"+rowindex+"' onchange='checkUriType(this,"+rowindex+");setChange("+rowindex+")' style='width:100px;'>" +
									"<option selected value='0'><%=SystemEnv.getHtmlLabelName(126788, user.getLanguage()) %></option>" +
									"<option value='1'><%=SystemEnv.getHtmlLabelName(126787, user.getLanguage()) %></option>" +
									"<option value='2'><%=SystemEnv.getHtmlLabelName(126789, user.getLanguage()) %></option>" +
								"</select>";
	                oDiv.innerHTML = sHtml;
	                oCell.appendChild(oDiv);
	                break;
	            }  				
					
				case 6:
					var oDiv = document.createElement("div");
					var sHtml = "<input class=Inputstyle type=\"text\" name=\"itemLinkUri_"+rowindex+"\" style=\"width:90%\" onfocus=\"checkUriTypeByRow("+rowindex+");\" onchange=\"checkinput(\'itemLinkUri_"+rowindex+"\',\'itemLinkUri_"+rowindex+"_span\');setChange("+rowindex+")\">" +
				  		"<span id=\"itemLinkUri_"+rowindex+"_span\"><IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle></span>";
				  		sHtml += "<span class=\"ssoWrap_"+rowindex+"_span\" style=\"display:none;\">";
				  		sHtml += "<select name=\"itemLinkUri_"+rowindex+"\" style=\"width:160px;\">";
				  		sHtml += $("#ssoMapOptions").html();
				  		sHtml += "</select>";
				  		sHtml += "</span>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 7:
					var oDiv = document.createElement("div");
					var sHtml = "<input class=Inputstyle type=\"text\" name=\"itemNumLinkUri_"+rowindex+"\" style=\"width:90%\" onfocus=\"checkUriTypeByRow("+rowindex+");\" onchange=\"checkinput(\'itemNumLinkUri_"+rowindex+"\',\'itemNumLinkUri_"+rowindex+"_span\');setChange("+rowindex+")\">" +
				  		"<span id=\"itemNumLinkUri_"+rowindex+"_span\"></span>";			   
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
							
			}
		}
		TBVars.maxRowIndex = rowindex;
	  	jQuery("body").jNice();
	  	beautySelect();
	}
	
	function checkUriType(obj, rowindex){
		var value = obj.value;
		var nextTd = $(obj).parent().next();
		
		if(value == 1 || value ==2 ){
			//选择站外连接需要隐藏后面的输入框
			jQuery("input[name='itemNumLinkUri_"+rowindex+"']").hide();
		}else{
			jQuery("input[name='itemNumLinkUri_"+rowindex+"']").show();
		}

		//单点登录
		if(value == 2){			
			jQuery("select[name='itemLinkUri_"+rowindex+"']").removeAttr("disabled");
			jQuery(".ssoWrap_"+rowindex+"_span").show();
			jQuery("input[name='itemLinkUri_"+rowindex+"']").attr("disabled", "true").hide();
			jQuery("#itemLinkUri_"+rowindex+"_span img").remove();
		}else{			
			jQuery("input[name='itemLinkUri_"+rowindex+"']").removeAttr("disabled").show();
			jQuery("select[name='itemLinkUri_"+rowindex+"']").attr("disabled", "true");
			jQuery(".ssoWrap_"+rowindex+"_span").hide();	
		}
		
		
	}
	
	function checkUriTypeByRow(rowindex){
		var groupSelObj = jQuery("select[name^='groupid_"+rowindex+"']");
		if(groupSelObj.length > 0) {
			checkUriType(groupSelObj.get(0), rowindex);
		}
	}
	
	function setChange(rowIndex){
		if(typeof rowIndex == 'object'){
			var name = $(rowIndex).attr("name");
			rowIndex = name.split('_')[1];
		}
		if(TBVars.changeRowIndexs.indexOf(","+rowIndex+",")<0){
			TBVars.changeRowIndexs+=rowIndex+",";
		}
	}
	
	
	var dbfieldnames = "<%=dbfieldnamesForCompare%>";
	function onSave(obj){
		if(jQuery("img[src='/images/BacoError_wev8.gif']").length !=0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
			return;
		}
		var changeRows = 0;
		var changeRowIndexsArray;
		if(TBVars.changeRowIndexs!=","){
			changeRowIndexsArray = TBVars.changeRowIndexs.substring(1,TBVars.changeRowIndexs.length-1).split(",");
			changeRows = changeRowIndexsArray.length;
		}
		var itemDspNames = ",";
		for(i=0;i<changeRows;i++){
			j=changeRowIndexsArray[i];
			//检查图标设置
			if($('#navico_'+j).attr('src') == '' || $('#navhotico_'+j).attr('src') == ''){
				top.Dialog.alert("请检查图标设置");
				return;
			}
		}
		var $checks = $("input[name='check_select']"), rowindex;
		for(i = 0; i < $checks.length; ++i){
			rowindex = $($checks[i]).val().split("_")[1];
			if(rowindex != ''){
				TBVars.showIndexs += rowindex + ',';
			}
			//显示顺序改变了
			if(rowindex != i){
				setChange(rowindex);
			}
		}
		
		//obj.disabled=true;
		//alert("TBVars.maxRowIndex:"+TBVars.maxRowIndex);
		//alert("TBVars.deleteRowIds:"+TBVars.deleteRowIds);
		//alert("TBVars.changeRowIndexs:"+TBVars.changeRowIndexs);
		//alert("TBVars.showIndexs:"+TBVars.showIndexs);
		document.weaver.maxRowIndex.value=TBVars.maxRowIndex;
		document.weaver.deleteRowIds.value=TBVars.deleteRowIds;
		document.weaver.changeRowIndexs.value=TBVars.changeRowIndexs;	
		document.weaver.showIndexs.value=TBVars.showIndexs;
		document.weaver.submit();
		//enableAllmenu();
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
		tmp.push(ops);
	    }
		tmp.sort(sortRule);
		for(var j=0;j<tmp.length;j++){
		obj.options[j].value = tmp[j]._value;
		obj.options[j].text = tmp[j]._text;
		}
	}
	
	function formCheckAll(obj){
		$("input[name='check_select']").each(function(){
			if(!jQuery(this).parents("tr[forsort='ON']").is(":hidden")){
				if(obj.checked){
					jQuery(this).siblings("span.jNiceCheckbox").addClass("jNiceChecked");
				}else{
					jQuery(this).siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
				}
				this.checked=obj.checked;
			}
		}); 
	}
	
	function formCheckAll1(obj){
		
		$("input[name^='isopen_']").each(function(){
			if(!jQuery(this).parents("tr[forsort='ON']").is(":hidden")){
				if(obj.checked){
					jQuery(this).siblings("span.jNiceCheckbox").addClass("jNiceChecked");
				}else{
					jQuery(this).siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
				}
				this.checked=obj.checked;
			}
			$(this).val(obj.checked?1:0);
		}); 
		TBVars.maxRowIndex = $("input[name='check_select']").length - 1;
		//alert(TBVars.maxRowIndex);
		TBVars.changeRowIndexs = ",";
		for(var num=0 ; num <= TBVars.maxRowIndex ; num++){
			setChange(num);
		}
	}
	
	function checkSelect(checkObj, rowindex){
		var name = $(checkObj).attr("name");
		var value = $(checkObj).val();
		$("input[name='"+name+"']").val(1 - value);
		checkUriTypeByRow(rowindex);
	}
	
	function doDel(){
		var flag = false;
		
		if(jQuery(":checkbox[name='check_select']").nextAll(".jNiceChecked").length == 0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686 ,user.getLanguage())%>");
			return;
		}
		
        window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
        	var cks = jQuery(":checkbox[name='check_select']").nextAll(".jNiceChecked");
        	for(var i=0; i<cks.length; i++){
        		 checkSelectValue = jQuery(cks[i]).prevAll(":checkbox").attr("value");
                 checkSelectArray=checkSelectValue.split("_");
                 itemId=checkSelectArray[0];
                 if(itemId!='0'){
                      TBVars.deleteRowIds +=itemId+",";
                 }
                 TBVars.changeRowIndexs = TBVars.changeRowIndexs.replace(checkSelectArray[1]+",","");
                 try{
	                  var dbfieldname = document.all("itemDspName_"+checkSelectArray[1]).value.toUpperCase();
	                  dbfieldnames = dbfieldnames.replace(","+dbfieldname+",",",");
                 }catch(e){}
	        	jQuery(cks[i]).closest("tr").remove();
	       	}
	       	onSave(null);
        });
	            
	}
	
</script>
</BODY>
</HTML>
