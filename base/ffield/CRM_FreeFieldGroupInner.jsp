
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<HTML>
<HEAD>


<%
    String ajax=Util.null2String(request.getParameter("ajax"));
%>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<%
	
String usetable=Util.null2String(request.getParameter("usetable"));
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

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
int rowsum = -1;
%>
<script>
</script>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),''} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDel(),''} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="weaver" id=weaver method=post action="CRM_FreeFieldOperation.jsp">
<input type="hidden" value="editGroupInfo" name="method">
<input type="hidden" value="" name="delids">
<input type="hidden" value="" name="changeRowIndexs">
<input type="hidden" value="<%=usetable %>" name="usetable">
<input type="hidden" value="" name="sortInfo">
<%if(canedit){%>
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
<%} %>

<TABLE class=ListStyle id="oTable" cols=7  border=0 cellspacing=0>
	<COLGROUP>
		<%if(canedit){%>
			<COL width="7%">
		<%} %>
		<COL width="31%">
		<COL width="31%">
		<COL width="31%">
	</COLGROUP>
	<TBODY>
		<tr class=header>
			<%if(canedit){%>
				<td><input type='checkbox' class="checkall"></td>
			<%} %>
			<td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(English)</td>
			<td><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>)</td>
		</tr>
		
		<%
		RecordSet.executeSql("select t1.* , ( SELECT count(*) FROM CRM_CustomerDefinField WHERE groupid = t1.id ) num "+
				 " from CRM_CustomerDefinFieldGroup t1 where  usetable='"+usetable+"' order by dsporder asc");
		
		while(RecordSet.next()){
			String id = RecordSet.getString("id");
			String candel = RecordSet.getString("candel");
			if(RecordSet.getInt("num")!=0){
				candel = "n";
			}
			String lablename = SystemEnv.getHtmlLabelName(RecordSet.getInt("grouplabel"),7);
			String lablenameE = SystemEnv.getHtmlLabelName(RecordSet.getInt("grouplabel"),8);
			String lablenameT = SystemEnv.getHtmlLabelName(RecordSet.getInt("grouplabel"),9);
			++rowsum;
		%>
		 <tr forsort="ON" class="DataLight">
		 	<%if(canedit){%>
			 	<td>
			 		<%if(candel.equals("y")){ %>
						<input type='checkbox' name="check_select" checkindex='<%=rowsum %>' value="<%=id%>" class="check_child">
					    <input type='hidden' name='modifyflag_<%=rowsum%>' id='modifyflag_<%=rowsum%>' value="<%=id%>">
				    <%}else{ %>
				    	<input type='hidden' name='check_select' checkindex='<%=rowsum %>'  value="<%=id%>">
					    <input type='hidden' name='modifyflag_<%=rowsum%>' id='modifyflag_<%=rowsum%>' value="<%=id%>">
					    <input type="checkbox" disabled="disabled">
					<%} %>
					<img moveimg="" src="/CRM/images/move_wev8.png" title="拖动" >	
			 	</td>
		 	<%} %>
		 	
			<td class=Inputstyle>
				<%if(canedit){%>
					<input type="text" class="inputstyle" style="width:90%;" name="CN_<%=rowsum %>" value="<%=lablename%>" 
						onchange="setChange(<%=rowsum%>),checkinput('CN_<%=rowsum%>','CN_<%=rowsum%>_span')" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)">
						<span id='CN_<%=rowsum%>_span'></span>
				<%}else{ %>
					<%=lablename %>
				<%} %>
			</td>
			<td class=Inputstyle>
				<%if(canedit){%>
					<input type="text" class="inputstyle" style="width:90%;" name="EN_<%=rowsum %>" value="<%=lablenameE%>" 
						onchange="setChange(<%=rowsum%>),checkinput('EN_<%=rowsum%>','CEN_<%=rowsum%>_span')" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)">
					<span id='EN_<%=rowsum%>_span'></span>
				<%}else{ %>
					<%=lablenameE%>
				<%} %>
			</td>
			
			<td class=Inputstyle>
				<%if(canedit){%>
	  				<input type="text" class="inputstyle" style="width:90%;" name="TW_<%=rowsum %>" value="<%=lablenameT%>" 
	  					onchange="setChange(<%=rowsum%>),checkinput('TN_<%=rowsum%>','TN_<%=rowsum%>_span')" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)">
					<span id='TW_<%=rowsum%>_span'></span>
				<%}else{ %>
					<%=lablenameT%>
				<%} %>
			</td>
		 </tr>
		<%}%>
		</TBODY>
</TABLE>	


</form>
<script type="text/javascript">
jQuery(function(){
	if("<%=canedit%>"=="true"){
		registerDragEvent();
	}
	
	jQuery(".checkall").bind("click",function(){
		changeCheckboxStatus(jQuery(".check_child"),jQuery(this).is(":checked"));
	});
});

rowindex = "<%=++rowsum%>";
delids = ",";
changeRowIndexs = ",";

function setChange(rowIndex){
	if(changeRowIndexs.indexOf(","+rowIndex+",")<0){
		changeRowIndexs+=rowIndex+",";
	}
}
	
function addRow(){
		
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
				var sHtml = "<input  type='checkbox' checkindex='"+rowindex+"' class='check_child' value='0'>";
				sHtml += "&nbsp;<img moveimg='' src='/CRM/images/move_wev8.png' title='拖动' >";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
				
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text' size='15' maxlength='30' name='CN_"+rowindex+"' style='width:90%' "+
					" onchange=\"checkinput('CN_"+rowindex+"','CN_"+rowindex+"_span')\" onblur=\"checkKey(this)\">"+
					" <span id='CN_"+rowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='EN_"+rowindex+"' style='width:90%'   "+
					" onchange=\"checkinput('EN_"+rowindex+"','EN_"+rowindex+"_span')\" onblur=\"checkKey(this)\">"+
					" <span id='EN_"+rowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='TW_"+rowindex+"' style='width:90%'   "+
					" onchange=\"checkinput('TW_"+rowindex+"','TW_"+rowindex+"_span')\" onblur=\"checkKey(this)\">"+
					" <span id='TW_"+rowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex = rowindex*1 +1;
  	jQuery("body").jNice();
  	beautySelect();

}

function onSave(obj){
	if(jQuery("img[src='/images/BacoError_wev8.gif']").length !=0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
		return;
	}
	
	
	obj.disabled=true;
	document.weaver.delids.value=delids;
	document.weaver.changeRowIndexs.value=changeRowIndexs;	
	document.weaver.submit();
	enableAllmenu();

	
}

function doDel(){
		
	if(jQuery(".check_child:checked").length == 0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686 ,user.getLanguage())%>");
		return;
	}
	
    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
       
       	var cks = jQuery(".check_child:checked");
       	
       	for(var i=0; i<cks.length; i++){
       		changeRowIndexs = changeRowIndexs.replace(jQuery(cks[i]).attr("checkindex")+",","");
       		var itemId = jQuery(cks[i]).attr("value");
       		if(itemId!='0'){
                   delids += itemId+",";
            }
            jQuery(cks[i]).parents("tr").remove();
       	}
     });
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

function sortOrderTitle(){
  	var info = "";
  	jQuery("input[name='check_select']").each(function(){
  		info +=jQuery(this).attr("checkindex")+"-"+jQuery(this).attr("value")+",";
  	})
  	if(""!=info){
  		info = info.substring(0 ,info.length);
  	}
  	$("input[name=sortInfo]").val(info);
  }
  
  function maintOption(rowindex){
  	openDialog(rowindex);
  }

</script>

</body>

</html>