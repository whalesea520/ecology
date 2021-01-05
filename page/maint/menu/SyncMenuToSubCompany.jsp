
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%
	String resourceId = Util.null2String(request.getParameter("resourceId"));
	String resourceType = Util.null2String(request.getParameter("resourceType"));
	String type =  Util.null2String(request.getParameter("type"));
	String closeDialog = Util.null2String(request.getParameter("closeDialog"));
	String titlename = SystemEnv.getHtmlLabelName(84124,user.getLanguage());
	String menuId=Util.null2String(request.getParameter("menuId"));
%>

<html>
	<body>
		<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(84124,user.getLanguage())%>"/> 
		</jsp:include>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(18240,user.getLanguage())+",javascript:checkSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ; 
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(18240,user.getLanguage()) %>" class="e8_btn_top"
							onclick="checkSubmit(this);" />
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage()) %>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		<div class="zDialog_div_content" style="height:200px;">
			<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="/page/maint/menu/SyncMenuToSubCompanyOperation.jsp">
				<input type="hidden" name="resourceId" value='<%=resourceId %>'>
				<input type="hidden" name="resourceType" value='<%=resourceType %>'>
				<input type="hidden" name="type" value='<%=type %>'>
				<input type="hidden" name="menuSort" value="0"/>
				<input type="hidden" name="menuMode" value="0"/>
				<input type="hidden" name="menuAdd" value="0"/>
				<input type="hidden" name="menuRight" value="0"/>
				<input type="hidden" name="menuId" value='<%=menuId%>'>
				<wea:layout type="2Col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
					<wea:item type="groupHead">
					</wea:item>	
					<wea:item><%=SystemEnv.getHtmlLabelName(32333,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="targetids" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubCompanyByRightBrowser.jsp?rightStr=SubMenu:Maint&selectedids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
					</wea:item>

					
				    <wea:item></wea:item>
				     <wea:item><input type="checkbox" id="menuSort"/><%=SystemEnv.getHtmlLabelName(130334,user.getLanguage())%></wea:item>
                  
                    <wea:item></wea:item>
                     <wea:item><input type="checkbox" id="menuMode"/><%=SystemEnv.getHtmlLabelName(130335,user.getLanguage())%></wea:item>
                    
				    <wea:item></wea:item>
				    <wea:item><input type="checkbox" id="menuAdd"/><%=SystemEnv.getHtmlLabelName(130336,user.getLanguage())%></wea:item>
				    
				    <wea:item></wea:item>
				    <wea:item>
				     <input type="checkbox" id="menuRight"/><%=SystemEnv.getHtmlLabelName(130337,user.getLanguage())%>
				        <select name='menuSyncType'>
                            <option value='1'><%=SystemEnv.getHtmlLabelName(31259,user.getLanguage())%></option> 
                            <option value='2'><%=SystemEnv.getHtmlLabelName(84563,user.getLanguage())%></option>
                        </select>
				    </wea:item>
				</wea:group>
				</wea:layout>
			</FORM>	
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
	    </td></tr>
	</table>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
	</body>
	
<script type="text/javascript">
	function checkSubmit(obj){
		var menuSortVal=$('input[name=menuSort]').val();
	    var menuModeVal=$('input[name=menuMode]').val();
	    var menuAddVal=$('input[name=menuAdd]').val();
	    var menuRightVal=$('input[name=menuRight]').val();
		if(menuSortVal==0&&menuModeVal==0&&menuAddVal==0&&menuRightVal==0){
		  Dialog.alert("<%=SystemEnv.getHtmlLabelName(130441,user.getLanguage())%>");
		  return;
		}
		if(check_form(frmMain,'targetids')){
			var subid = "<%=resourceId %>";
			var subType = "<%=resourceType %>";
			var tagids = jQuery("#targetids").val();
			var tempsubids = "";
			var hasInclude = false;
			var tempids =  tagids.split(",");
			if(subType == 1 && subid == 1 ){
				
			}else{
				for(var i=0;i<tempids.length;i++){
					if(subid == tempids[i]){
						hasInclude = true;
						break;
					}
				}
			}
			if(hasInclude){
				top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(84126,user.getLanguage())%>",function(){
					for(var i=0;i<tempids.length;i++){
						if(subid==tempids[i])continue;
						tempsubids += tempids[i]+",";
					}
					tagids = tempsubids.substring(0,tempsubids.length-1);
					jQuery("#targetids").val(tagids);
					if(tagids==""){
						location.href="/page/maint/menu/SyncMenuToSubCompany.jsp?closeDialog=close";
						return;
					}
					frmMain.submit();
					obj.disabled=true;
				})
			}else{
				frmMain.submit();
				obj.disabled=true;
			}
		}
	}
	
	function onCancel(){
		var dialog = parent.getDialog(window);	
		dialog.close();
	}
	jQuery(document).ready(function(){
		if("<%=closeDialog%>"=="close"){
			onCancel();
		}
		
		$('#menuSort').click(function(){
		  if($(this).attr('checked')){
               $('input[name=menuSort]').val(1);
	       }else{
	           $('input[name=menuSort]').val(0);
	       }
		});
		
		$('#menuMode').click(function(){
          if($(this).attr('checked')){
               $('input[name=menuMode]').val(1);
           }else{
               $('input[name=menuMode]').val(0);
           }
        });
       
        $('#menuAdd').click(function(){
          if($(this).attr('checked')){
               $('input[name=menuAdd]').val(1);
           }else{
               $('input[name=menuAdd]').val(0);
           }
        });
      
        $('#menuRight').click(function(){
          if($(this).attr('checked')){
               $('input[name=menuRight]').val(1);
           }else{
               $('input[name=menuRight]').val(0);
           }
        });
	})
</script>
</html>
