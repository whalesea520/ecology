
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<DIV id="workPlanShareSplash" style="display:none;padding-top:10px;padding-bottom:10px;height: 450px;">


<DIV id="workPlanShareSetSplash" name="workPlanShareSetSplash" >
	<INPUT type="hidden" id="workPlanArrayIdShare" name="workPlanArrayIdShare" value="">
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' attributes="{'groupDisplay':\"none\"}" >
			<wea:item>
				<SELECT id="shareTypeShare" name="shareTypeShare" onchange="onChangeShareType()" class=InputStyle style="width:100px">
					<OPTION value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION> 
					<OPTION value="5"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION> 
					<OPTION value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION> 
					<OPTION value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></OPTION> 
					<OPTION value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></OPTION>
					<option value="6"><%=SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></option>
				</SELECT>
			</wea:item>
			<wea:item>
				<span id="useridedSP" style="display:none"> 
				<brow:browser viewType="0" name="userided" browserValue="" tempTitle='<%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="300px"
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
				browserSpanValue=""></brow:browser>
				</span>
				
				<span id="subidsdSP" style="display:none">
				<brow:browser viewType="0" name="subidsd" browserValue=""  tempTitle='<%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids=" 
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="300px"
				completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
				browserSpanValue=""></brow:browser>
				</span>
				
				<span id="departmentidedSP">
				<brow:browser viewType="0" name="departmentided" browserValue=""  tempTitle='<%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="300px"
				completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
				browserSpanValue=""></brow:browser>
				</span>
				
				<span id="roleidSPd" style="display:none">
				<brow:browser viewType="0" name="roleided" browserValue="" tempTitle='<%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
				hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="300px"
				completeUrl="/data.jsp?type=65" linkUrl="/hrm/roles/HrmRolesShowEdit.jsp?type=0&id=" 
				browserSpanValue=""></brow:browser>
				</span>
				<INPUT  id="shareIdShare" type="hidden" name="shareIdShare" value=""  />
				<span id="shareIdShareSpan" style="display:none"></span>
			</wea:item>
			<wea:item attributes="{'samePair':\"roleLevelSpanShare\"}" ><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':\"roleLevelSpanShare\"}" >
					<SELECT id="roleLevelShare" name="roleLevelShare" class=InputStyle>
						<OPTION value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
						<OPTION value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
						<OPTION value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
					</SELECT>
			</wea:item>
			<wea:item attributes="{'samePair':\"secLevelSpanShare\"}" >
				<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
			</wea:item>
			<wea:item attributes="{'samePair':\"secLevelSpanShare\"}" >
				<INPUT class=InputStyle id="secLevelShare" name="secLevelShare" maxLength=3 size=5 onKeyPress="ItemCount_KeyPress()" onBlur="checknumber('secLevelShare');checkinput('secLevelShare','secLevelImageShare')" value="10">
				<SPAN id="secLevelImageShare" name="secLevelImageShare"></SPAN>
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<SELECT id="shareLevelShare" name="shareLevelShare" class=InputStyle>
					<OPTION value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>									  
					<OPTION value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>						
				</SELECT>
			</wea:item>
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':\"none\"}" >
			<wea:item type="toolbar" >
				<button id="addShareBtn" type="button" class="e8_btn_submit" type=button onclick="addShare()" title="" style="margin-right: 10px;"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
			</wea:item>
		</wea:group>
	</wea:layout>

<BR>
</DIV>
<TABLE class="ListStyle">
	<TBODY> 
	<TR class=Title> 
		<TH style="padding-left:5px;text-align:left;"><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></TH>
	</TR>
	<tr>
	<TD style="padding-left:0px;padding-right:0px;">
	<div id="scrollbardiv" style="position: relative;height: 200px;overflow-y: hidden;">
	<DIV id="workPlanShareListSplash" >
	<!--================== 共享列表 ==================-->
	<TABLE name="workPlanShareListTable" id="workPlanShareListTable" class="ViewForm">
		<COLGROUP> 
			<COL width="25%"> 
			<COL width="65%"> 
			<COL width="10%"> 
		<TBODY> 
		<TR class="Spacing" style="height:1px!important;"> 
			<TD class="Line1" colspan="3" style="padding:0;"></TD>
		</TR>
		

		</TBODY>
	</TABLE>
	</DIV>
	</TD>
	</tr>
	</TBODY>
</TABLE>



</DIV>

<SCRIPT language="JavaScript">
$(document).ready(function() {
	jQuery("#addShareBtn").closest("td").css("text-align","right");
});
function onShowShareResource(inputname,spanname,e){
	changeUrl(inputname,spanname,e);
}
function changeUrl(inputname,spanname,e) 
{
	var thisValue = $("#shareTypeShare").val();
	//$("input[name=shareIdShare]").val("");
	//$("#shareIdShareSpan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	$("#secLevelSpanShare").show();
	$("#roleLevelSpanShare").hide();
	
	$("#multiHumanResourceShare").hide();
	$("#multiDepartmentShare").hide();
	$("#singleRoleShare").hide();
	$("#multiSubcompanyShare").hide();
	
	$("input[name=secLevelShare]").val(10);
	$("#shareIdShareBtn").show();
	//人力资源
	if(1 == thisValue)
	{
		
		$("#secLevelSpanShare").hide();
		onShowResource(inputname,spanname);
	}	
	//部门
	else if(2 == thisValue)
	{
		onShowDepartment(inputname,spanname);
	}	
	//角色
	else if(3 == thisValue)
	{
 		$("#singleRoleShare").show();
		$("#roleLevelSpanShare").show();
		onShowRole(inputname,spanname);
	}
    //所有人
	else if(4 == thisValue)
	{
		$("#shareIdShareBtn").hide();
		$("#shareIdShare").val("-1");
		$("#shareNameShare").html("");
	}	
	//分部
	else if(5 == thisValue){
 		//$("multiSubcompanyShare").style.display = "";
		onShowSubcompany(inputname,spanname);
	}
}
function onChangeShareType() 
{
	var thisValue = $("#shareTypeShare").val();
	
	if (thisValue == 1) {
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","");
		jQuery($GetEle("roleidSPd")).css("display","none");
		
		hideEle("secLevelSpanShare", true);
		hideEle("roleLevelSpanShare", true);
    } else if(thisValue == 2){
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","none");
		showEle("secLevelSpanShare");
		hideEle("roleLevelSpanShare", true);
	}else if(thisValue == 3){
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","");
		showEle("secLevelSpanShare");
		showEle("roleLevelSpanShare");
	}else if(thisValue == 4){
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","none");
		showEle("secLevelSpanShare");
		hideEle("roleLevelSpanShare", true);
	}else if(thisValue == 5){
		jQuery($GetEle("subidsdSP")).css("display","");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","none");
		showEle("secLevelSpanShare");
		hideEle("roleLevelSpanShare", true);
	}else if(thisValue == 6){
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","none");
		hideEle("secLevelSpanShare", true);
		hideEle("roleLevelSpanShare", true);
	}
	$("input[name=secLevelShare]").val(10);
}
function addShare(){
	var checkstr="";
	var thisValue = $("#shareTypeShare").val();
	if (thisValue == 1) {
		jQuery($GetEle("shareIdShare")).val(jQuery($GetEle("userided")).val());
		checkstr ="userided";
    } else if(thisValue == 2){
		jQuery($GetEle("shareIdShare")).val(jQuery($GetEle("departmentided")).val());
		checkstr ="departmentided";
	}else if(thisValue == 3){
		jQuery($GetEle("shareIdShare")).val(jQuery($GetEle("roleided")).val());
		checkstr ="roleided";
	}else if(thisValue == 4){
		jQuery($GetEle("shareIdShare")).val("");
	}else if(thisValue == 5){
		jQuery($GetEle("shareIdShare")).val(jQuery($GetEle("subidsd")).val());
		checkstr ="subidsd";
	}else if(thisValue == 6){
		jQuery($GetEle("shareIdShare")).val("");
	}
	if(checkstr !="" && $.trim($("#"+checkstr).val())==""){
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(30933,user.getLanguage())%>");
		return;
	}
	var param={
			 method:"addCalendarShare"
			 ,id:$("#workPlanArrayIdShare").val()
			 ,shareType:$("#shareTypeShare").val()
			 ,shareId:$("#shareIdShare").val()
			 ,roleLevel:$("#roleLevelShare").val()
			 ,secLevel:$("#secLevelShare").val()			 
			 ,shareLevel:$("#shareLevelShare").val()
	}
	$.post("/workplan/data/WorkPlanViewOperation.jsp",param,function(data){
		if(data.isSuccess){
			var eventId = $("#workPlanArrayIdShare").val();
			fillShare(eventId);
			
			var shareType = $("#shareTypeShare").val();
			/*
			var oRow = $("#workPlanShareListTable")[0].insertRow(-1);		        
			var oCell;
			var oDiv;

			oRow.setAttribute("shareId", data.shareId);

			// 类型
			oCell = oRow.insertCell(-1);
		    oDiv = document.createElement("div");        
		    oDiv.innerHTML = $($("#shareTypeShare")[0].options[$("#shareTypeShare")[0].selectedIndex]).text();
		    oCell.appendChild(oDiv);
		    
		    //内容
			var content = "";
			if (thisValue == 1) {
				content += $("#useridedspan").text();
			} else if(thisValue == 2){
				content += $("#departmentidedspan").text();
			}else if(thisValue == 3){
				content += $("#roleidedspan").text();
			}else if(thisValue == 4){
			}else if(thisValue == 5){
				content += $("#subidsdspan").text();
			}else if(thisValue == 6){
			}
			
			//框
			if(4 != shareType)
			{
				content += $("#shareIdShareSpan").text();
			}
			
			//角色
			if(3 == shareType)
			{	content += " ";
				content += $($("#roleLevelShare")[0].options[$("#roleLevelShare")[0].selectedIndex]).text();
			}		
			//安全级别
			if(1 != shareType && 6!=shareType)
			{
				if(4 != shareType )
				{
					content += " / ";
				}
				content += "<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>";
				content += " : ";
				content += $("#secLevelShare").val();
			}	
			//查看编辑
            if( 6!=shareType)    {
			content += " / ";
            }
			content += $($("#shareLevelShare")[0].options[$("#shareLevelShare")[0].selectedIndex]).text();
			
		    oCell = oRow.insertCell(-1);
		    oCell.className = "Field";
		    oDiv = document.createElement("div");
		    oDiv.innerHTML = content;        
		    oCell.appendChild(oDiv);

			// 删除
		    oCell = oRow.insertCell(-1);
		    oCell.className = "Field";
		    oDiv = document.createElement("div");        
		    oDiv.innerHTML = "<A href='javascript:void(0)' onclick='doDelete(" + data.shareId + ")'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>"
		    oCell.appendChild(oDiv);
		       
		    //下划线
		    oRow = $("#workPlanShareListTable")[0].insertRow(-1);
		    oRow.style.height="1px";
		    oCell = oRow.insertCell(-1);
		    oCell.setAttribute("colSpan", 3);
		    
		    oCell.className = "Line";
		    $(oCell).css("padding","0");
		    resizeDialog2();
		    */
		    if(shareType!=4 && shareType!=6){
				$("#workPlanShareSetSplash").find(".Browser").siblings("span").html("");
				$("#workPlanShareSetSplash").find(".Browser").siblings("input[type='hidden']").val("");
				$("#workPlanShareSetSplash").find(".e8_os").find("input[type='hidden']").val("");
				$("#workPlanShareSetSplash").find(".e8_outScroll .e8_innerShow span").html("");
				jQuery($GetEle("shareIdShare")).val("");
		    }   
		}
		
		
	},"json");
}
function fillShare(eventId){
	 $("#shareTypeShare").val(2)
	 onChangeShareType();
	 $("#workPlanArrayIdShare").val(eventId);
	 /*
	 var table=$("#workPlanShareListTable")[0];
	 for(var i=2;i<table.rows.length-1;i++){
		$(table.rows[i]).remove();
	 }
	 */
	 $("#workPlanShareListTable").find("tr:gt(0)").remove();
	var param={
		method:"getCalendarShare",
		id:eventId
	}
	$.post("/workplan/data/WorkPlanViewOperation.jsp",param,function(shareInfo){
		var table=$("#workPlanShareListTable")[0];
		var data=shareInfo.data;
		for(var i=0;i<data.length;i++){
			var row=table.insertRow(-1);
			row.setAttribute("shareId",data[i].shareId);
			var cell1=row.insertCell(-1);
			$(cell1).html(data[i].shareTypeName);
			var cell2=row.insertCell(-1);
			$(cell2).attr("class","Field");
			$(cell2).html(data[i].shareContent);
			var cell3=row.insertCell(-1);
			$(cell3).attr("class","Field");
			//$(cell3).html("<a onclick=\"doDelete("+data[i].shareId+")\" href=\"javascript:void(0)\">删除</a>");
			$(cell3).html("<button id=\"addShareBtn\" type=\"button\" class=\"delbtn\" type=button onclick=\"doDelete("+data[i].shareId+")\" title=\"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>\"></button>");
			//var rowLine=table.insertRow(-1);
			//$(rowLine).css("height","1px");
			//var cellLine=rowLine.insertCell(-1);
			//cellLine.setAttribute("class","Line");
			//cellLine.setAttribute("colSpan","3");
			//$(cellLine).css("padding","0");
		}
		resizeDialog2();
		jQuery("#scrollbardiv").perfectScrollbar('update');
	},"json");
}

function doDelete(shareId){
	var param={
		method:"deleteCalendarShare",
		id:shareId
	};
	$.post("/workplan/data/WorkPlanViewOperation.jsp",param,function(data){
		if(data.IsSuccess){
			var curRow=$("tr[shareId="+shareId+"]");
			curRow.next().remove();
			curRow.remove();
			resizeDialog2();
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(83473,user.getLanguage())%>");
		}
	},"json");
}
function resizeDialog2(){
	//var curHeight=$("#workPlanShareSplash").height();
	//dialog2.setSize(dialog2.Width,curHeight<400?400:curHeight+20);
}

function onShowSubcompany(inputname,spanname)  {
		linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
	    		"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	   if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
}
function onShowDepartment(inputname,spanname){
	linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
			"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	 if (datas) {
	    if (datas.id!= "") {
	        ids = datas.id.split(",");
		    names =datas.name.split(",");
		    sHtml = "";
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
			    }
		    }
		    $("#"+spanname).html(sHtml);
		    $("input[name="+inputname+"]").val(datas.id);
	    }
	    else	{
    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		    $("input[name="+inputname+"]").val("");
	    }
	}
}


function onShowRole(inputename,tdname){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp","","dialogHeight=550px;dialogWidth=550px;");
	
	if (datas){
	    if (datas.id!="") {
		    $("#"+tdname).html(datas.name);
		    $("input[name="+inputename+"]").val(datas.id);
	    }else{
		    	$("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		    $("input[name="+inputename+"]").val("");
	    }
	}
}

</SCRIPT>
