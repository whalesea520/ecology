
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />

<html>
<%


boolean canEdit=false;
if(HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)){
	canEdit=true;
}

int mouldId = Util.getIntValue(request.getParameter("mouldId"),0);

MouldManager.setId(mouldId);
MouldManager.getMouldInfoById();
String mouldname=MouldManager.getMouldName();
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));

%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>

<script type="text/javascript">
var dialog = parent.parent.getDialog(parent); 
var parentWin = parent.parent.getParentWindow(parent);
if("<%=isclose%>"=="1"){
	try{
		parentWin._table.reLoad();
	}catch(e){}
	parentWin.closeDialog();	
}
</script>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16450,user.getLanguage())+"："+mouldname;
String needfav ="";
String needhelp ="";
%>
</head>

<body>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

int rowNum=0;

if(canEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

/*RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='DocMouldDspExt.jsp?id="+mouldId+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;*/

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(canEdit){ %>
				<input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<form id="weaver" name="weaver" method=post action="DocMouldLabelOrderOperation.jsp" >

       <wea:layout attributes="{'expandAllGroup':'true'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	            <wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
	            <wea:item><%=mouldId%></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
				<wea:item><%=mouldname%></wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(21412,user.getLanguage())%>'>
				<wea:item attributes="{'isTableList':'true'}">
					<wea:layout needImportDefaultJsAndCss="false" type="table" attributes="{'formTableId':'labelOrder','cols':'3','cws':'10%,40%,40%'}">
						<wea:group context="" attributes="{'groupDisplay':'none'}">
							<wea:item type="thead"></wea:item>
							<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(33307,user.getLanguage())%></wea:item>
							<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(33308,user.getLanguage())%></wea:item>
							<%
								int tempRecordId=0;
								String tempName=null;
								String tempDescript=null;
								double tempShowOrder=0;
								
								
								RecordSet.executeSql("select * from MouldBookMark where mouldId="+mouldId+" order by showOrder asc,id asc");
								while(RecordSet.next()){
									
									tempRecordId  =Util.getIntValue(RecordSet.getString("id"),0);
									tempName=Util.null2String(RecordSet.getString("name"));
									tempDescript=Util.null2String(RecordSet.getString("descript"));
									tempShowOrder=Util.getDoubleValue(RecordSet.getString("showOrder"),0);
								    if(tempShowOrder==0){
										tempShowOrder=rowNum;
									}
								%>
									<wea:item>
										<img src="/images/ecology8/move_wev8.png" width="16px" style="display:none;"/>
										<input type="hidden" id="labelOrder_recordId" name="labelOrder_recordId" value="<%=tempRecordId%>">
										<input type="hidden" value="<%=tempShowOrder %>" id="labelOrder<%=rowNum%>_showOrder" name="labelOrder<%=rowNum%>_showOrder" >
									</wea:item>
									<wea:item><%=tempName%></wea:item>
									<wea:item><%=tempDescript%></wea:item>
								<%
									rowNum++;
								} %>
							</wea:group>
					</wea:layout>
				</wea:item>
			</wea:group>
		</wea:layout>

<input type="hidden" value="<%=mouldId%>" name="mouldId">
<input type="hidden" value="<%=rowNum%>" name="rowNum">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
</form>

<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>

</body>
</html>


<Script language=javascript>
try{
	parent.setTabObjName("<%= mouldname %>");
}catch(e){}

jQuery(document).ready(function(){
<%if(canEdit){%>
	registerDragEvent();
<%}%>
});

function registerDragEvent(){
    	 var fixHelper = function(e, ui) {
            ui.children().each(function() { 
                $(this).width($(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了
                $(this).height($(this).height());  
            });  
            return ui;  
        };
        
        var copyTR = null;
 		var startIdx = 0;
        
        jQuery("#labelOrder tbody tr").bind("mousedown",function(e){
			copyTR = jQuery(this).next("tr.Spacing");
		});
		
		jQuery("#labelOrder tbody tr[class!='Spacing']").hover(function(){
			jQuery(this).find("img").show();
		},function(){
			jQuery(this).find("img").hide();
		});
        
         jQuery("#labelOrder tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
             helper: fixHelper,                  //调用fixHelper  
             axis:"y",  
             start:function(e, ui){
                 ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
                 if(copyTR){
            		copyTR.hide();
            	}
            	startIdx = ui.item.get(0).rowIndex;
                 return ui;  
             },  
             stop:function(e, ui){
                 ui.item.removeClass("e8_hover_tr"); //释放鼠标时，要用ui.item才是释放的行  
                if(copyTR){
                  var endIdx = ui.item.get(0).rowIndex;
            	  if(endIdx>startIdx){
             	  	ui.item.before(copyTR.clone().show());
             	  }else{
             	  	ui.item.after(copyTR.clone().show());
             	  }
             	  //ui.item.find("#labelOrder"+Math.floor(startIdx)+"_showOrder").val(Math.floor(endIdx));
            	  copyTR.remove();
            	  copyTR = null;
            	}
                return ui;  
             }  
         });  
    }

function onSave(obj) {

		obj.disabled = true;
		document.weaver.action="DocMouldLabelOrderOperation.jsp" ;
		document.weaver.submit();

}


/*
p（精度）
指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。

s（小数位数）
指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
*/
function checkDigit(elementName,p,s){
	tmpvalue = document.all(elementName).value;

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
    document.all(elementName).value=newValue;
}


</script>
