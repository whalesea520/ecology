<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SelectItemManager" class="weaver.workflow.selectItem.SelectItemManager" scope="page" />
<jsp:useBean id="mainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="subCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
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
		parentWin._table.reLoad();
	}
</script>
<%

if (!HrmUserVarify.checkUserRight("WORKFLOWPUBLICCHOICE:VIEW", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String src = Util.null2String(request.getParameter("src")).trim();
int id = Util.getIntValue(request.getParameter("id"));
int rowno = 0;
int statelev = Util.getIntValue(request.getParameter("statelev"),1);
int initpid = Util.getIntValue(request.getParameter("pid"),0);
String selectitemname = "";
String selectitemdesc = "";
String sql = "";
String statename = SystemEnv.getHtmlLabelName(124984,user.getLanguage());


if(src.equals("add")){
	titlename = SystemEnv.getHtmlLabelName(124895,user.getLanguage());
}else if(src.equals("edit")){
	titlename = SystemEnv.getHtmlLabelName(124896,user.getLanguage());
	
	sql = "SELECT id,selectitemname,selectitemdesc,formids,operatetime FROM mode_selectitempage WHERE id="+id;
	rs.executeSql(sql);
	if(rs.next()){
		selectitemname = Util.null2String(rs.getString("selectitemname"));
		selectitemdesc = Util.null2String(rs.getString("selectitemdesc"));
	}
	//System.out.println(sql);
	statename = SystemEnv.getHtmlLabelName(124984,user.getLanguage())+SelectItemManager.getAllStateName(initpid,id,"",user);
	//if(statename.equals("")){
	//	statename = SystemEnv.getHtmlLabelName(124984,user.getLanguage());
	//}
}
%>


</head>
<BODY>
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
	<input type="hidden" name="id" id="id" value="<%=id %>" />
	<input type="hidden" name="action" id="action" value="selectitemedit"/>
	<input type="hidden" name="method" id="method" value="saveorupdate"/>
	<input type="hidden" name="detailjson" id="detailjson" value=""/>
	<input type="hidden" name="statelev" id="statelev" value="<%=statelev %>"/>
	<input type="hidden" name="pid" id="pid" value="<%=initpid %>"/>
	<input type="hidden" name="delids" id="delids" value=""/>
	<input type="hidden" name="src" id="src" value="<%=src %>" />
	
	
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>'>
			<wea:item> <%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> </wea:item>
			<wea:item>
				<input type="text" id="selectitemname" name="selectitemname" onchange='checkinput("selectitemname","selectitemnamespan")' value="<%=selectitemname %>"/> 
				<span id="selectitemnamespan">
				    <%if ("".equals(selectitemname)) { %>
						<img src="/images/BacoError_wev8.gif"/>
					<% } %>
				</span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
			<wea:item>
				<textarea name="selectitemdesc" style="width:80%;height:50px;"><%=selectitemdesc %></textarea>
			</wea:item>
		</wea:group>
		
		<wea:group context='<%=statename %>' >
		    <wea:item type="groupHead">
				<input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="addRow();"/>
				<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="deleteRows();"/>
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				
				<table class=ListStyle cellspacing=0   cols=6 id="oTable">
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
		            	<td><%=SystemEnv.getHtmlLabelName(124920,user.getLanguage())%></td><!-- 子选项 -->
		            	<td><%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%></td><!-- 封存 -->
					</tr>
					
					<%
					boolean candel = true;
					sql = "SELECT s.selectvalue FROM workflow_billfield b , workflow_SelectItem s WHERE b.id=s.fieldid AND b.selectItemType IN ('1','2') AND s.pubid in (select id from mode_selectitempagedetail d where d.mainid = "+id+" and d.pid="+initpid+")";
					rs.executeSql(sql);
					if(rs.next()){
						candel = false;
					}
					
					//System.out.println(sql);
					
					
					String needcheck = "";
					if(id>0){//新增的时候子表不加入。在编辑的时候才能进行子表编辑
	    			sql = "select b.*,(select count(1) from mode_selectitempagedetail a where a.pid=b.id ) as subcount from mode_selectitempagedetail b where mainid = "+id+" and statelev='"+statelev+"' and pid='"+initpid+"' order by disorder asc,id asc ";
	    			rs.executeSql(sql);
	    			//System.out.println(sql);
	    			while(rs.next()){
	    				String detailid = Util.null2String(rs.getString("id"));
	    		    	String name = Util.null2String(rs.getString("name"));
	    		    	String defaultvalue = Util.null2String(rs.getString("defaultvalue"));
	    		    	String pathcategory = Util.null2String(rs.getString("pathcategory"));
	    		    	String maincategory = Util.null2String(rs.getString("maincategory")).trim();
	    		    	String docspath = "";
						String docscategory = rs.getString("maincategory");
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
						//maincategory = maincategory.replaceAll(",","/"); 		 								
	    		    	
	    		    	
	    		    	String pid = Util.null2String(rs.getString("pid"));
	    		    	String subcount = Util.null2String(rs.getString("subcount"));
	    		    	double disorder = Util.getDoubleValue(rs.getString("disorder"),0);
	    		    	int cancel = Util.getIntValue(rs.getString("cancel"),0);
	    		    	int isAccordToSubCom = Util.getIntValue(rs.getString("isAccordToSubCom"),0);
	    		    	needcheck += ",name_"+rowno;
	    		%>
	    				<tr class="DataDark">
	    					<td height="23">
	    						<input <%if(cancel==1 || !candel){%>style="display:none;"<%} %> type="checkbox" name="check_node" value="<%=detailid %>">
	    						<%if(cancel==1 || !candel){%><input disabled="disabled" type="checkbox" ><%} %>
	    						&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>' />
	    						<input type="hidden" class="detailid" id="detailid_<%=rowno%>" name="detailid_<%=rowno%>" value="<%=detailid %>">
	    						<input class=inputstyle type='hidden' maxlength='400' name='disorder_<%=rowno%>' id='disorder_<%=rowno%>' value="<%=disorder%>" >
	    					</td>
	    					<td>
	    						<input <%if(cancel==1){%>style="display:none;"<%} %> class=inputstyle type='text' maxlength='400' name='name_<%=rowno%>' id='name_<%=rowno%>' value="<%=name%>"  onchange="checkinput('name_<%=rowno%>','name_<%=rowno%>span')">
	    						<%if(cancel==1){%><input disabled="disabled" class=inputstyle type='text' maxlength='400' name='name_<%=rowno%>' id='name_<%=rowno%>' value="<%=name%>"  onchange="checkinput('name_<%=rowno%>','name_<%=rowno%>span')"><%} %>
	    						<span id='name_<%=rowno%>span'>
	    						<%if(name.equals("")){ %>
	    						<IMG src="/images/BacoError_wev8.gif" align="absMiddle">
	    						<%} %>
	    						</span>
	    					</td>
	    					
	    					<td>
	    						<input <%if(cancel==1){%>style="display:none;"<%} %> vname='defaultvalue' class=inputstyle type='checkbox' <%if("1".equals(defaultvalue)){%>checked<%} %> onclick='changeBoxVal(this);' name='defaultvalue_<%=rowno%>' id='defaultvalue_<%=rowno%>' value="<%=defaultvalue%>">
	    						<%if(cancel==1){%><input <%if("1".equals(defaultvalue)){%>checked<%} %>  disabled="disabled" type="checkbox" ><%} %>
	    					</td>
	    					<td>
	    						<input type='checkbox' <%if(isAccordToSubCom==1){ %>checked<%} %> name='isAccordToSubCom_<%=rowno%>' id='isAccordToSubCom_<%=rowno%>' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;
								<brow:browser viewType="0" name='<%="maincategory_"+rowno%>' browserValue='<%=maincategory%>'  
					            getBrowserUrlFn="onShowCatalog"   getBrowserUrlFnParams='<%=""+rowno%>'
					            idKey="id" nameKey="path"
								_callback="afterSelect"
								_callbackParams='<%=""+rowno%>'
								afterDelCallback="delCategoryCallback"
					
					            hasInput="true" isSingle="true" hasBrowser = "true"  isMustInput='1'
					            completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" width="60%"
					            browserSpanValue="<%=docspath%>"></brow:browser>
								
								<input type=hidden id='pathcategory_<%=rowno%>' name='pathcategory_<%=rowno%>' value='<%=docspath %>'>
	    					</td>
	    					<td>
	    						<input class=inputstyle type='hidden' maxlength='400' name='pid_<%=rowno%>' id='pid_<%=rowno%>' value="<%=pid%>"/>
	    						<button type='button' class=Browser1 onclick="goToChildren('<%=rowno%>','<%=cancel %>')"></button>
	    						<span  name="img_<%=rowno%>_span" id="img_<%=rowno%>_span"><%if(Util.getIntValue(subcount)>0){%><img src="/workflow/ruleDesign/images/ok_hover_wev8.png" border=0></img>
	    						<%}%>
			    				</span>
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
				
			<%
				}
			%>
			
				<input type="hidden" id="needcheck" name="needcheck" value="<%=needcheck%>">
				<input type="hidden" id="rowno" name="rowno" value="<%=rowno%>">
				<input type="hidden" id="noGoChildren" name="noGoChildren" value="">
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

if("<%=isclose%>"=="1"){
	btn_cancle();
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

function onShowCatalogHis(choicerowindex) {	
	 return "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp";   
}
function onShowCatalogSubCom(index) {
	var selectvalue=document.getElementById("detailid_"+index).value;
    return "/systeminfo/BrowserMain.jsp?url=/docs/field/SubcompanyDocCategoryBrowser.jsp?fieldId=<%=-id%>&isBill=1&selectValue="+selectvalue;
	
}

function onShowCatalog(choicerowindex){
    var url="";
	var isAccordToSubCom=0;	
	if(document.getElementById("isAccordToSubCom_"+choicerowindex)!=null){
		if(document.getElementById("isAccordToSubCom_"+choicerowindex).checked){
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
	var docsec="";
	if(rt.mainid && rt.subid && rt.id ){
		docsec=rt.mainid+","+rt.subid+","+rt.id ;
	}
    jQuery("input[name=maincategory_"+choicerowindex+"]").val(docsec);
    jQuery("input[name=pathcategory_"+choicerowindex+"]").val(jQuery("span[name=maincategory_"+choicerowindex+"span]").text());   

}	
	
	
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

	var idStr = "#oTable";
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
	


var rowindex = "<%=rowno%>";
function addRow()
{	
	if(!isNaN(rowindex)){
		rowindex = parseInt(rowindex);
	}
	oRow = oTable.insertRow(-1);
	jQuery(oRow).addClass("DataDark");
	for(j=0; j<6; j++) {//6列数据
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.wordBreak = "break-all";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node'>&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>' />"
						   +"<input type='hidden' class='detailid' id='detailid_"+rowindex+"' name='detailid_"+rowindex+"' value=''>"
						   +"<input class=inputstyle type='hidden' maxlength='400' name='disorder_"+rowindex+"' id='disorder_"+rowindex+"' value='"+(rowindex+1)+".0'>";
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
				var sHtml = "<input vname='defaultvalue' class=inputstyle type='checkbox'  onclick='changeBoxVal(this);' name='defaultvalue_"+rowindex+"' id='defaultvalue_"+rowindex+"' value='0'>";
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv); 
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' id='isAccordToSubCom"+rowindex+"' name='isAccordToSubCom"+rowindex+"' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;"
							+ "<span  id='maincategory_"+rowindex+"span' name='maincategory_"+rowindex+"span' ></span>"
						    + "<input type=hidden id='pathcategory_"+rowindex+"' name='pathcategory_"+rowindex+"' value=''>";
						   

				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				 jQuery("#maincategory_"+rowindex+"span").e8Browser({
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
                 afterDelCallback:"delCategoryCallback",
                 width:"60%",
                 hasAdd:false,
                 isSingle:true
                 });
				
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='hidden' maxlength='10' name='pid_"+rowindex+"' id='pid_"+rowindex+"' value='<%=initpid %>'>";
					//sHtml +="<a href='javascript:noGoChildren()'><%=SystemEnv.getHtmlLabelName(82467,user.getLanguage())%></a>";//<!-- 子项 -->
				    sHtml +="<button type='button' name='' class=Browser1 onclick=\"noGoChildrenBtn(this,"+rowindex+")\"></button>";
				    sHtml +="<input type='hidden' name='jump_"+rowindex+"' id='jump_"+rowindex+"' value='0'>";
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv);
				break;
			case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<input vname='cancel' class=inputstyle type='checkbox'  onclick='changeCalcelVal(this);' name='cancel_"+rowindex+"' id='cancel_"+rowindex+"' value='0'>";
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv);
				break;
		}
	}
	
	/*
	oRow = oTable.insertRow(-1);
	oRow.class="Spacing";
	oRow.style="height:1px!important;";
	oCell = oRow.insertCell(-1); 
	oCell.colspan = 6;
	*/
	
	//<tr class='Spacing' style="height:1px!important;"><td colspan=6 class='paddingLeft18'>
	
	var needcheck = jQuery("#needcheck").val();
	jQuery("#needcheck").val(needcheck+",name_"+rowindex+"");
	
	rowindex = rowindex*1 +1;
	jQuery("#rowno").val(rowindex);
	jQuery("#oTable").jNice();
}

function deleteRows(){
   var haschecked = false;
   var chks = document.getElementsByName("check_node"); 
   for (var i=0;i<chks.length;i++){
       var chk = chks[i];
       if(chk.checked==true) {
       	haschecked=true;
       }
   }  
    
   if(!haschecked){
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
    	return;
   }

   window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		var delids = jQuery("#delids");
		var delidsVal = delids.val();
		
		$("input[name=check_node]").each(function(){
			if($(this).attr("checked")){
			    var td = jQuery(this).closest("td");
			    var detailid = td.find(".detailid");
				if(detailid.length>0&&detailid.val()!=0){
					delidsVal = delidsVal+","+detailid.val();
				}
				$(this).closest("tr").remove();
			}
		});
		
		if(delidsVal!=""){
			if(delidsVal.indexOf(",")==0){
				delidsVal = delidsVal.substring(1);
			}
			delids.val(delidsVal);
		}
	});
	
}

function delCategoryCallback(text,fieldid,params){
    jQuery("#"+fieldid).val("");
}


function doSave(obj){
	jQuery("#noGoChildren").val("0");
    rightMenu.style.visibility = "hidden";
	if (checkSave()){
		enableAllmenu();
		formCustomSearch.submit();
    }
}

function checkSave(){
	var checkfields = "selectitemname";
    var nameArr = jQuery("[name^=name_]");
    for(var i=0;i<nameArr.length;i++){
    	if(nameArr.get(i).value==""){
    		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");
    		return false;
    	}
    }
    if ($("#id").val()==0) {
        jQuery("#action").val("selectitemadd");
	}
	var disorder = 0;
	jQuery("input[name^=disorder_]").each(function(){
		jQuery(this).val(disorder);
		disorder++;
	});
	
	if (!checkFieldValue(checkfields)){
		return false;
	}
	
	return true;
}



function noGoChildrenBtn(obj,rowindex){
	jQuery("#noGoChildren").val("1");
	if (checkSave()){
		enableAllmenu();
		obj.disabled = true;
		//var statelev = parseInt($G("statelev").value);
		//var pid = parseInt($G("pid").value);
		//if(pid!=0){
		//	statelev = statelev + 1;
	    //	jQuery("#statelev").val(statelev);
		//}
		//alert(statelev)
		
		jQuery("input[name^='jump_']").each(function(){
			jQuery(this).val("0");
		});
		jQuery("#jump_"+rowindex).val("1");
		formCustomSearch.submit();
    }
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
	
	
	if (checkSave()){
		formCustomSearch.action = "selectItemEdit.jsp";
		jQuery("#pid").val(detailid);
		jQuery("#statelev").val(statelev);
		formCustomSearch.submit();
    }
}

function goToState(pid,statelev){

	if (checkSave()){
		formCustomSearch.action = "selectItemEdit.jsp";
		jQuery("#pid").val(pid);
		jQuery("#statelev").val(statelev);
		formCustomSearch.submit();
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

/**
 * 解禁此项以及子项
 * @param {Object} selid 
 */
function notCancel(detailid){
	jQuery.ajax({
	   type: "POST",
	   url: "/workflow/selectItem/selectItemAjaxData.jsp?src=notcancel&id=<%=id%>",
	   data: "detailid="+detailid,
	   dataType:"json",
	   success: function(data){
			if(data&&data.detailid>0){
				window.location.href = "/workflow/selectItem/selectItemEdit.jsp?id=<%=id%>&pid=<%=initpid%>&statelev=<%=statelev%>&src=edit";
			}
	   }
	});
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
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		document.formCustomSearch.action.value="selectitemdelete";
		enableAllmenu();
		document.formCustomSearch.submit();
	});
	
}
</script>
</body>

</html>
