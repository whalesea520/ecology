
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CRMFreeFieldManage" class="weaver.crm.Maint.CRMFreeFieldManage" scope="page"/>
<%@ page import="weaver.general.Util" %>

<%
	String usetable = Util.null2String(request.getParameter("usetable"));
    String message= Util.null2String(request.getParameter("message"));
	boolean canedit = false;
	if(usetable.equals("c1")){
		usetable = "CRM_CustomerInfo";
		canedit = HrmUserVarify.checkUserRight("CustomerAccountFreeFeildEdit:Edit", user);
	}else if(usetable.equals("c2")){
		usetable = "CRM_CustomerContacter";
		canedit = HrmUserVarify.checkUserRight("CustomerContactorFreeFeildEdit:Edit", user);
	}else if(usetable.equals("c3")){
		usetable = "CRM_CustomerAddress";
		canedit = HrmUserVarify.checkUserRight("CustomerAddressFreeFeildEdit:Edit", user);
	}else if(usetable.equals("c4")){
		usetable = "CRM_SellChance";
		canedit = HrmUserVarify.checkUserRight("CustomerAddressFreeFeildEdit:Edit", user);
	}
	
	boolean isoracle = (rs.getDBType()).equals("oracle") ;
	int rowsum = 0;
	String dbfieldnamesForCompare = ",";
	String sql = " select fieldname from CRM_CustomerDefinField where viewtype=0 and usetable='"+usetable+"' order by dsporder";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
	    rowsum++;
	    String fieldname = RecordSet.getString("fieldname");
	    dbfieldnamesForCompare += fieldname.toUpperCase()+",";
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript">
$(document).ready(function(){
    <%if(message.equals("1")){%>
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");
 <%}else if(message.equals("-1")){%>
 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83912,user.getLanguage())%>");
 <%}else if(message.equals("-2")){%>
 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83912,user.getLanguage())%>现有字段不存在！");
 <%}else if(message.equals("-3")){%>
 window.top.Dialog.alert("保存现有字段出错，字段类型不一致！");
 <%}%>
});
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
function showdetaildata(){
    var ajax=ajaxinit();
    ajax.open("POST", "/base/ffield/CRM_FreeFieldDetail.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("usetable=<%=usetable%>");
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.all("detaildata").innerHTML=ajax.responseText;
                jQuery("body").jNice();
                beautySelect();
                if("<%=canedit%>"=="true"){
					registerDragEvent();
				}
            }catch(e){
                return false;
            }
            
			jQuery("input[type='checkbox'][name^='isopen_']").each(function(){
				if(!jQuery(this).is(":checked")){
					jQuery(this).parents("tr[forsort='ON']").hide();
				}
			});
			
        }
    }
    
    
}

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
var index = null;
function openDialog(rowindex){
	index = rowindex;
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

function changeSelectItemInfo(rowindex){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/base/ffield/CRM_FreeFieldSelectEdit.jsp?index="+rowindex;
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
            jQuery(this).height("40");						//在CSS中定义为40px,目前不能动态获取
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
if(HrmUserVarify.checkUserRight("AddSectorInfo:add", user) && canedit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addRow(),''} " ;
    RCMenuHeight += RCMenuHeightStep ;
    
    RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDel(),''} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:copyRow(),''} " ;
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
<%if(canedit){ %>
	<table id="topTitle" cellpadding="0" cellspacing="0" >
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:addRow();"/>&nbsp;&nbsp;
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage()) %>" class="e8_btn_top" onclick="javascript:doDel();"/>&nbsp;&nbsp;
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(77, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:copyRow();"/>&nbsp;&nbsp;
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top" onclick="javascript:onSave(this);"/>&nbsp;&nbsp;
				
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table> 
<%} %>

<FORM id=weaver name="weaver" action="CRM_FreeFieldOperation.jsp" method=post >
<input type="hidden" name="method" value="savefieldbatch">
<input type="hidden" name="usetable" value="<%=usetable %>">
<input type="hidden" value="0" name="recordNum">
<input type="hidden" value="" name="delids">
<input type="hidden" value="" name="changeRowIndexs">
<input type="hidden" value="" name="sortname">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0"  style="padding-bottom: 30px;">
<tr>
	<td valign="top" width="100%">
			<div id="detaildata">
				<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
				<script>showdetaildata();</script>
			<div>
	</td>
</tr>
</table>
</FORM>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<script type="text/javascript">


	rowindex = "<%=rowsum%>";
	delids = ",";
	changeRowIndexs = ",";
	function addRow(){
		
		jQuery.post("CRM_FreeFieldOperation.jsp",{method:"getTableGroupInfo",rowindex:rowindex,"usetable":"<%=usetable%>"},function(data){
			var groupHtml = jQuery.trim(data);
			rowColor = getRowBg();
			ncol = oTable.rows[0].cells.length;
			oRow = oTable.insertRow(-1);
			oRow.style.height=24;
			$(oRow).attr("forsort","ON");
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
						sHtml += "&nbsp;<img moveimg='' src='/CRM/images/move_wev8.png' title='拖动' >";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
						
					case 1:
						var oDiv = document.createElement("div");
						var sHtml = "<input class='InputStyle' type='text' size='15' maxlength='30' name='itemDspName_"+rowindex+"' style='width:90%'  onblur=\"checkKey(this);checkinput_char_num('itemDspName_"+rowindex+"');checkinput('itemDspName_"+rowindex+"','itemDspName_"+rowindex+"_span')\"><span id='itemDspName_"+rowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 2:
						var oDiv = document.createElement("div");
						var sHtml = "<input class='InputStyle' type='text'  name='itemFieldName_"+rowindex+"' style='width:90%'   onchange=\"checkinput('itemFieldName_"+rowindex+"','itemFieldName_"+rowindex+"_span')\" onblur=\"checkKey(this)\"><span id='itemFieldName_"+rowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 3:
						var oDiv = document.createElement("div");
						var sHtml = "<%=CRMFreeFieldManage.getItemFieldTypeSelectForAddMainRow(user)%>";	
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 4:
						var oDiv = document.createElement("div");
						oDiv.innerHTML = groupHtml;
						oCell.appendChild(oDiv);
						break;		
		            case 5:
		            {
		                var oDiv = document.createElement("div");
		                var sHtml = "<input type='checkbox' class=inputstyle name='isopen_"+rowindex+"' value='1' checked>";
		                oDiv.innerHTML = sHtml;
		                oCell.appendChild(oDiv);
		                break;
		            }  				
						
					case 6:
						var oDiv = document.createElement("div");
						var sHtml = " <input class='InputStyle' type='checkbox' name='ismust_"+rowindex+"' value='1'>";						   
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 7:
					    {
						var oDiv = document.createElement("div");
						var sHtml = " <input class='InputStyle' type='checkbox' name='issearch_"+rowindex+"' value='1'>";                          
						<%if(usetable.equals("CRM_CustomerAddress")){%>
							sHtml="<input class='InputStyle' type='checkbox' name='isfixed_"+rowindex+"' value='1'>";
						<%}%>
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					    }
					case 8:
						var oDiv = document.createElement("div");
						var sHtml = " <input class='InputStyle' type='checkbox' name='isdisplay_"+rowindex+"' value='1'>";
			                        <%if(!usetable.equals("CRM_CustomerInfo")){%>
			                            sHtml="<input class='InputStyle' type='checkbox' name='isfixed_"+rowindex+"' value='1'>";
			                        <%}%>						   
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 9:
						var oDiv = document.createElement("div");
						var sHtml = " <input class='InputStyle' type='checkbox' name='isexport_"+rowindex+"' value='1'>";						   
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 10:
						var oDiv = document.createElement("div");
						var sHtml = " <input class='InputStyle' type='checkbox' name='isfixed_"+rowindex+"' value='1'>";                          
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
								
				}
			}
			rowindex = rowindex*1 +1;
		  	jQuery("body").jNice();
		  	beautySelect();
	  	});
	}
	
	function setChange(rowIndex){
		if(changeRowIndexs.indexOf(","+rowIndex+",")<0){
			changeRowIndexs+=rowIndex+",";
			// alert(changeRowIndexs);
		}
		try{
		var olddbfieldname = document.all("olditemDspName_"+rowIndex).value.toUpperCase();
		dbfieldnames = dbfieldnames.replace(","+olddbfieldname+",",",");
		}catch(e){}
	}
	
	
	function onChangItemFieldType(rowNum){
	
		itemFieldType = $G("itemFieldType_"+rowNum).value;
		$G("div6_1_"+rowNum).style.float="right";
		if("<%=usetable%>" != "CRM_CustomerAddress"){
			disOrEnableCheckbox($G("issearch_"+rowNum),false);
		}
		if(itemFieldType==1){
			$G("div1_"+rowNum).style.display='inline';
			$G("div1_1_"+rowNum).style.display='inline';
			$G("documentType_"+rowNum).selectedIndex=0;
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
			$G("div3_"+rowNum).style.display='none';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			//zzl
			$G("div3_5_"+rowNum).style.display='none';
			
			$G("div5_"+rowNum).style.display='none';
			$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		}
		if(itemFieldType==2){
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
			
			
			$G("div5_"+rowNum).style.display='none';
			$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		}
		if(itemFieldType==3){
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
			
			$G("div5_"+rowNum).style.display='none';
			$G("div5_5_"+rowNum).style.display='none';
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
		}
		if(itemFieldType==4){
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
			
			$G("div5_"+rowNum).style.display='none';
			$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		}
        if(itemFieldType==5){
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
			
			$G("div5_"+rowNum).style.display='inline';
			$G("div5_5_"+rowNum).style.display='inline';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		}
        if(itemFieldType==6){
            //$G("strlength_"+rowNum).value='5';
            $G("imgwidth_"+rowNum).value='100';
            $G("imgheight_"+rowNum).value='100';
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
			
			$G("div5_"+rowNum).style.display='none';
			$G("div5_5_"+rowNum).style.display='none';
            // $G("div6_"+rowNum).style.display="inline";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
            $G("uploadtype_"+rowNum).options[0].selected=true;
           // alert( jQuery("input[name='issearch_"+rowNum+"']").html());
            //jQuery("input[name='issearch_"+rowNum+"']").attr("disabled","disabled");
            
            changeCheckboxStatus($G("issearch_"+rowNum),false);
			disOrEnableCheckbox($G("issearch_"+rowNum),true);
            
		}
        if(itemFieldType==7){
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
			
			$G("div5_"+rowNum).style.display='none';
			$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="inline";
		    $G("div7_1_"+rowNum).style.display="";
		    $G("div7_2_"+rowNum).style.display="none";
            $G("specialfield_"+rowNum).options[0].selected=true;
		}
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
			if(jQuery("input[name=candel_"+j+"]").val() == "n"){//系统字段，则不检测
				if($("input[type=checkbox][name=isopen_"+j+"]").attr("checked"))
					$("input[type=checkbox][name=isopen_"+j+"]").val("1");
				if($("input[type=checkbox][name=ismust_"+j+"]").attr("checked"))
					$("input[type=checkbox][name=ismust_"+j+"]").val("1");
				if($("input[type=checkbox][name=issearch_"+j+"]").attr("checked"))
					$("input[type=checkbox][name=issearch_"+j+"]").val("1");
				if($("input[type=checkbox][name=isdisplay_"+j+"]").attr("checked"))
					$("input[type=checkbox][name=isdisplay_"+j+"]").val("1");
				if($("input[type=checkbox][name=isexport_"+j+"]").attr("checked"))
					$("input[type=checkbox][name=isexport_"+j+"]").val("1");
				if($("input[type=checkbox][name=isfixed_"+j+"]").attr("checked"))
					$("input[type=checkbox][name=isfixed_"+j+"]").val("1");
				continue;
			}
			
			if(check_formself(weaver,check_String)){
				
				if($("input[type=checkbox][name=isopen_"+j+"]").attr("checked"))
					$("input[type=checkbox][name=isopen_"+j+"]").val("1");
				if($("input[type=checkbox][name=ismust_"+j+"]").attr("checked"))
					$("input[type=checkbox][name=ismust_"+j+"]").val("1");
				if($("input[type=checkbox][name=issearch_"+j+"]").attr("checked"))
					$("input[type=checkbox][name=issearch_"+j+"]").val("1");
				if($("input[type=checkbox][name=isdisplay_"+j+"]").attr("checked"))
					$("input[type=checkbox][name=isdisplay_"+j+"]").val("1");
				if($("input[type=checkbox][name=isexport_"+j+"]").attr("checked"))
					$("input[type=checkbox][name=isexport_"+j+"]").val("1");
				if($G("itemFieldType_"+j).value==1 && $G("documentType_"+j).value==1){
					if($G("itemFieldScale1_"+j).value==""){//单行文本框的文本长度必填
						window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				/************
				if($G("itemFieldType_"+j).value==3&&($G("broswerType_"+j).value==161||$G("broswerType_"+j).value==162)){
					if($G("definebroswerType_"+j).value==""){//自定义浏览框必选
						window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if($G("itemFieldType_"+j).value==3&&($G("broswerType_"+j).value==224||$G("broswerType_"+j).value==225)){
					if($G("sapbrowser_"+j).value==""){//自定义浏览框必选
						window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				
				//zzl
				if($G("itemFieldType_"+j).value==3&&($G("broswerType_"+j).value==226||$G("broswerType_"+j).value==227)){
					if($G("showvalue_"+j).value==""){//zzl集成按钮必填
						window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				*************/
				if($G("itemFieldType_"+j).value==5){//选择框可选项文字check
					
					if(jQuery("select[name=selectOption_"+j).find("option").length==0){//选择框的可选项文字必填
						window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				var itemDspName = $G("itemDspName_"+j).value;
				if(itemDspName=="id"||itemDspName=="requestId"){
					window.top.Dialog.alert(itemDspName+"<%=SystemEnv.getHtmlLabelName(21810,user.getLanguage())%>");
					$G("itemDspName_"+j).select();
					return;
				}
				if(dbfieldnames.indexOf(","+itemDspName.toUpperCase()+",")>=0||itemDspNames.indexOf(","+itemDspName.toUpperCase()+",")>=0){//数据库字段名称不能重复
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>");
					$G("itemDspName_"+j).select();
					return;
				}else{itemDspNames += itemDspName.toUpperCase()+",";}
			}else{
				
				return;
			}
		}
		obj.disabled=true;
		document.weaver.recordNum.value=rowindex;
		document.weaver.delids.value=delids;
		document.weaver.changeRowIndexs.value=changeRowIndexs;	
		document.weaver.submit();
		enableAllmenu();
	}
	
	function checkKey(obj){
		var keys=",PERCENT,PLAN,PRECISION,PRIMARY,PRINT,PROC,PROCEDURE,PUBLIC,RAISERROR,READ,READTEXT,RECONFIGURE,REFERENCES,REPLICATION,RESTORE,RESTRICT,RETURN,REVOKE,RIGHT,ROLLBACK,ROWCOUNT,ROWGUIDCOL,RULE,SAVE,SCHEMA,SELECT,SESSION_USER,SET,SETUSER,SHUTDOWN,SOME,STATISTICS,SYSTEM_USER,TABLE,TEXTSIZE,THEN,TO,TOP,TRAN,TRANSACTION,TRIGGER,TRUNCATE,TSEQUAL,UNION,UNIQUE,UPDATE,UPDATETEXT,USE,USER,VALUES,VARYING,VIEW,WAITFOR,WHEN,WHERE,WHILE,WITH,WRITETEXT,EXCEPT,EXEC,EXECUTE,EXISTS,EXIT,FETCH,FILE,FILLFACTOR,FOR,FOREIGN,FREETEXT,FREETEXTTABLE,FROM,FULL,FUNCTION,GOTO,GRANT,GROUP,HAVING,HOLDLOCK,IDENTITY,IDENTITY_INSERT,IDENTITYCOL,IF,IN,INDEX,INNER,INSERT,INTERSECT,INTO,IS,JOIN,KEY,KILL,LEFT,LIKE,LINENO,LOAD,NATIONAL,NOCHECK,NONCLUSTERED,NOT,NULL,NULLIF,OF,OFF,OFFSETS,ON,OPEN,OPENDATASOURCE,OPENQUERY,OPENROWSET,OPENXML,OPTION,OR,ORDER,OUTER,OVER,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUTHORIZATION,BACKUP,BEGIN,BETWEEN,BREAK,BROWSE,BULK,BY,CASCADE,CASE,CHECK,CHECKPOINT,CLOSE,CLUSTERED,COALESCE,COLLATE,COLUMN,COMMIT,COMPUTE,CONSTRAINT,CONTAINS,CONTAINSTABLE,CONTINUE,CONVERT,CREATE,CROSS,CURRENT,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,DATABASE,DBCC,DEALLOCATE,DECLARE,DEFAULT,DELETE,DENY,DESC,DISK,DISTINCT,DISTRIBUTED,DOUBLE,DROP,DUMMY,DUMP,ELSE,END,ERRLVL,ESCAPE,";
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
				window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(19946,user.getLanguage())%>');
				obj.focus();
				return false;
			}
		}
		return true;
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
	
	function onChangType(rowNum){
		itemFieldType = $G("documentType_"+rowNum).value;
		if(itemFieldType==1){
			$G("div1_1_"+rowNum).style.display='';
			$G("div1_1_"+rowNum).style.float='left';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
		}else if(itemFieldType==3){
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='';
			$G("div1_3_"+rowNum).style.float='left';
			$G("div2_"+rowNum).style.display='none';
		}else if(itemFieldType==5){
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='';
			$G("div1_3_"+rowNum).style.float='left';
			$G("div2_"+rowNum).style.display='none';
		}else{
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
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
		var mval = $(obj).val();
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
		$(obj).find("option[value='"+mval+"']").attr("selected",true);

	}
	
	function onuploadtype(obj,index) {
	    if (obj.value == 1) {
	        $G("div6_1_" + index).style.display = "none";
	    } else {
	        $G("div6_1_" + index).style.display = "";
	    }
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
						window.top.Dialog.alert("\""+$G(itemlist[i]).getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
						return false;
					}else{
						window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
						return false;
					}
				}
			}
		}
		return true;
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
		}); 
		
		changeRowIndexs = ",";
		dbfieldnames = ",";
		for(var num=0 ; num < rowindex ; num++){
			// setChange(num);
			changeRowIndexs += num+",";
		}
	}
	function formCheckAll2(obj){
		
		$("input[name^='ismust_']").each(function(){
			if(!jQuery(this).parents("tr[forsort='ON']").is(":hidden")){
				if(obj.checked){
					jQuery(this).siblings("span.jNiceCheckbox").addClass("jNiceChecked");
				}else{
					jQuery(this).siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
				}
				this.checked=obj.checked;
			}
		}); 
		// alert("==="+changeRowIndexs+"=="+dbfieldnames+"===");
		changeRowIndexs = ",";
		dbfieldnames = ",";
		for(var num=0 ; num < rowindex ; num++){
			// setChange(num);
			changeRowIndexs += num+",";
		}
		// alert("==="+changeRowIndexs+"=="+dbfieldnames+"===");
	}
	
	function formCheckAll3(obj){
		
		$("input[name^='issearch_']").each(function(){
			if(!jQuery(this).parents("tr[forsort='ON']").is(":hidden")){
				if(obj.checked){
					jQuery(this).siblings("span.jNiceCheckbox").addClass("jNiceChecked");
				}else{
					jQuery(this).siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
				}
				this.checked=obj.checked;
			}
		}); 
		changeRowIndexs = ",";
		dbfieldnames = ",";
		for(var num=0 ; num < rowindex ; num++){
			// setChange(num);
			changeRowIndexs += num+",";
		}
	}
	
	function formCheckAll4(obj){
		
		$("input[name^='isdisplay_']").each(function(){
			if(!jQuery(this).parents("tr[forsort='ON']").is(":hidden")){
				if(obj.checked){
					jQuery(this).siblings("span.jNiceCheckbox").addClass("jNiceChecked");
				}else{
					jQuery(this).siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
				}
				this.checked=obj.checked;
			}
		}); 
		changeRowIndexs = ",";
		dbfieldnames = ",";
		for(var num=0 ; num < rowindex ; num++){
			// setChange(num);
			changeRowIndexs += num+",";
		}
	}
	function formCheckAll5(obj){
		
		$("input[name^='isexport_']").each(function(){
			if(!jQuery(this).parents("tr[forsort='ON']").is(":hidden")){
				if(obj.checked){
					jQuery(this).siblings("span.jNiceCheckbox").addClass("jNiceChecked");
				}else{
					jQuery(this).siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
				}
				this.checked=obj.checked;
			}
		}); 
		changeRowIndexs = ",";
		dbfieldnames = ",";
		for(var num=0 ; num < rowindex ; num++){
			// setChange(num);
			changeRowIndexs += num+",";
		}
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
                     delids +=itemId+",";
                 }
                 changeRowIndexs = changeRowIndexs.replace(checkSelectArray[1]+",","");
                 try{
	                  var dbfieldname = document.all("itemDspName_"+checkSelectArray[1]).value.toUpperCase();
	                  dbfieldnames = dbfieldnames.replace(","+dbfieldname+",",",");
                 }catch(e){}
	            jQuery(cks[i]).closest("tr").remove();
	       	}
        });
	            
	}
	
	function copyRow(){
		var hasSelect = false;
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
		jQuery.post("CRM_FreeFieldOperation.jsp",{method:"getTableGroupInfo",rowindex:rowindex,"usetable":"<%=usetable%>"},function(data){
			var groupHtml = jQuery.trim(data);
			
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
				isopen=$G("isopen_"+fromRow).value;
				ismust=$G("ismust_"+fromRow).value;
				issearch = "";
				isdisplay = "";
				isexport = "";
				
				isopen=trim(isopen);
				ismust=trim(ismust);
				
				checkedFlag="";
				checkedFlag2 = "";
				checkedFlag3 = "";
				checkedFlag4 = "";
				checkedFlag5 = "";
				if($("input[type=checkbox][name=isopen_"+fromRow+"]").attr("checked")){
			  		checkedFlag="checked";
				}
				if($("input[type=checkbox][name=ismust_"+fromRow+"]").attr("checked")){
			  		checkedFlag2="checked";
				}
				
				if(<%=!usetable.equals("CRM_CustomerAddress")%>){
					issearch = $G("issearch_"+fromRow).value;
					issearch = trim(issearch);
					if($("input[type=checkbox][name=issearch_"+fromRow+"]").attr("checked")){
			  			checkedFlag3="checked";
					}
				}
				if(<%=!usetable.equals("CRM_CustomerInfo")%>){
					isdisplay = $G("isdisplay_"+fromRow).value;
					isdisplay = trim(isdisplay);
					if($("input[type=checkbox][name=isdisplay_"+fromRow+"]").attr("checked")){
			  			checkedFlag4="checked";
					}
					
					isexport = $G("isexport_"+fromRow).value;
					isexport = trim(isexport);
					if($("input[type=checkbox][name=isexport_"+fromRow+"]").attr("checked")){
			  			checkedFlag5="checked";
					}
				}
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
						sHtml += "&nbsp;<img moveimg='' src='/CRM/images/move_wev8.png' title='拖动' >";
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
						var sHtml = "<input class='InputStyle' type='text'  name='itemFieldName_"+rowindex+"' value='"+itemFieldName+"' style='width:90%'   onchange=\"checkinput('itemFieldName_"+rowindex+"','itemFieldName_"+rowindex+"_span')\" onblur=\"checkKey(this)\"><span id='itemFieldName_"+rowindex+"_span'>";
						if(itemFieldName==""){
							sHtml+="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
						}
						sHtml+="</span>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 3:
						var oDiv = document.createElement("div");
						var sHtml = "<%=CRMFreeFieldManage.getItemFieldTypeSelectForAddMainRow(user)%>";
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
								$G("div1_3_"+rowindex).style.display="";
								onChangType(rowindex);
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
							//$G("htmledit_"+rowindex).checked = $G("htmledit_"+fromRow).checked;
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
								if($G("definebroswerType_"+fromRow).value=="") $G("div3_0_"+rowindex).style.display="inline";
								$G("definebroswerType_"+rowindex).value=$G("definebroswerType_"+fromRow).value;
								$G("custombrow_"+rowindex).value=$G("custombrow_"+fromRow).value;
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
								$G("decentralizationbroswerType_"+rowindex).value=$G("decentralizationbroswerType_"+fromRow).value;
							}
							
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
							$G("div5_5_"+rowindex).style.display="inline";
							hasSelect = true;
							
						}
						if(itemFieldType_index==6){
							$G("div1_"+rowindex).style.display="none";
							$G("div1_1_"+rowindex).style.display="none";
							$G("div1_3_"+rowindex).style.display="none";
							
							/***********
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
							****************/
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
						oDiv.innerHTML = groupHtml;
						oCell.appendChild(oDiv);
						break;		
					case 5:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' class=inputstyle name='isopen_"+rowindex+"' value='"+isopen+"' "+checkedFlag+" >";
								   
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;	
					case 6:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' class=inputstyle name='ismust_"+rowindex+"' value='"+ismust+"' "+checkedFlag2+" >";
								   
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 7:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' class=inputstyle name='issearch_"+rowindex+"' value='"+issearch+"' "+checkedFlag3+" >";
						<%if(usetable.equals("CRM_CustomerAddress")){%>
							sHtml="<input class='InputStyle' type='checkbox' name='isfixed_"+rowindex+"' value='1'>";
						<%}%>
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;			
					case 8:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' class=inputstyle name='isdisplay_"+rowindex+"' value='"+isdisplay+"' "+checkedFlag4+" >";
						<%if(usetable.equals("CRM_CustomerInfo")){%>
							sHtml="<input class='InputStyle' type='checkbox' name='isfixed_"+rowindex+"' value='1'>";
						<%}%>	
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 9:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' class=inputstyle name='isexport_"+rowindex+"' value='"+isexport+"' "+checkedFlag5+" >";
								   
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break
					case 10:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' class=inputstyle name='isfixed_"+rowindex+"' value='1' >";
                                   
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break; 
					
				}
			  }
			  
			 	 if(hasSelect){
			  								
			  		
			  		var select_options = jQuery("select[name=selectOption_"+fromRow).find("option");
			  		
					if(select_options.length > 0){
						
						var selectObj = jQuery.find("select[name=selectOption_"+rowindex+"]");
						jQuery(selectObj).empty();
						var value = "";
						for(var i = 0 ; i <select_options.length ;i++){
							if(i>=1){
								value+=",,,";
							}
							
							var selectitemvalue = jQuery(select_options[i]).html();
							value += "-1***"+selectitemvalue;
							jQuery(selectObj).append("<option value='-1'>"+selectitemvalue+"</option>");
						}
						
						if(jQuery("#selectOption_"+rowindex+"_value").val()){
							jQuery("#selectOption_"+rowindex+"_value").val(value);
						}else{
							jQuery("form").append("<input type='hidden'  id='selectOption_"+rowindex+"_value' name='selectOption_"+rowindex+"_value' value ='"+value+"'>");
						}
					}
					hasSelect = false;
				}
			  
			  rowindex = rowindex*1 +1;
			}
			beautySelect();
			jQuery("body").jNice();
		});
	}
	
	function browserChange(obj, rowindex) {
		var browid = jQuery(obj).val();
		var url = jQuery(obj).find("option:selected").attr('url');
		var isSingle = true;
		if(!(browid == '161' || browid == '162')) {
			jQuery("#browspan_"+rowindex).hide();
			return;
		}
		
		jQuery("#browspan_"+rowindex).show();
		$("#browspan_"+rowindex).e8Browser({
			name: 'custombrow_'+rowindex, 
			viewType:'0',
			isMustInput:'2',
			hasInput:'false',
			isSingle:"true",
			completeUrl:'/data.jsp',
			browserUrl:"/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp",
			width:'200px;',
			hasAdd:false
		});
	
	}
</script>
</BODY>
</HTML>
