
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.docs.category.security.MultiAclManager" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryCustomSearchComInfo" class="weaver.docs.category.SecCategoryCustomSearchComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/prototype_wev8.js" type="text/javascript"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript">

function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function afterDoWhenLoaded(){
	//hideTH();
	registerDragEvent();
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
    String id = Util.null2String(request.getParameter("id"));
    SecCategoryCustomSearchComInfo.checkDefaultCustomSearch(Util.getIntValue(id));
	RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();
	String subcategoryid=RecordSet.getString("subcategoryid");
	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);
	//初始值
    boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	MultiAclManager am = new MultiAclManager();
	//hasSubManageRight = am.hasPermission(mainid, MultiAclManager.CATEGORYTYPE_MAIN, user, MultiAclManager.OPERATION_CREATEDIR);
	//hasSecManageRight = am.hasPermission(Integer.parseInt(subcategoryid.equals("")?"-1":subcategoryid), MultiAclManager.CATEGORYTYPE_SUB, user, MultiAclManager.OPERATION_CREATEDIR);
	int parentId = Util.getIntValue(scc.getParentId(""+id));
	if(parentId>0){
		hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
	}
    String disableLable = "disabled";
    boolean canEdit = false ;
	if (HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add",user) || hasSecManageRight) {
		canEdit = true ;
        disableLable="";
    }
  int detachable = ManageDetachComInfo.isUseDocManageDetach()?1:0;
  int operatelevel=0;
  if(detachable==1){
	   operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryAdd:Add",Util.getIntValue(scc.getSubcompanyIdFQ(id+""),0));
  }else{
	   if(HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user) || hasSecManageRight)
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
}
%>
	<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(canEdit){ %>
				<input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<FORM METHOD="POST" name="frmCustomSearch" ACTION="DocSecCategoryCustomSearchEditOperation.jsp">
	<INPUT TYPE="hidden" NAME="method" VALUE="save">
	<INPUT TYPE="hidden" NAME="secCategoryId" value="<%=id%>">
	<%
	int useCustomSearch = 0;
	RecordSet.executeSql("select * from DocSecCategory where id = " + id);
	if(RecordSet.next()){
	    useCustomSearch = RecordSet.getInt("useCustomSearch");
	}
	%>
	<wea:layout attributes="{'expandAllGroup':'true'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20237,user.getLanguage())%></wea:item>
			<wea:item><input class=InputStyle type=checkbox value=1 name=useCustomSearch <%=(useCustomSearch==1)?"checked":""%>  <%=disableLable%>></wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20237,user.getLanguage())+SystemEnv.getHtmlLabelName(68, user.getLanguage())%>'>
			<wea:item attributes="{'isTableList':'true'}">
				<%
					String sqlWhere = "secCategoryId="+id+" and (docPropertyId not in (select id from DocSecCategoryDocProperty where secCategoryId = "+id+" and labelid in ("+MultiAclManager.MAINCATEGORYLABEL+","+MultiAclManager.SUBCATEGORYLABEL+")))";
					if(!qname.equals("")){
						//sqlWhere = "customname like '%"+qname+"%'";
					}							
					String  operateString= "";
					 String tabletype="none";
					String tableString=""+
					   "<table instanceid=\"docMouldTable\" needPage=\"false\" pagesize=\"1000\" tabletype=\""+tabletype+"\">"+
						" <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getDocSecDirPropCheckbox\" popedompara = \"column:docPropertyId\" />"+
					   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"DocSecCategoryCusSearch\" sqlorderby=\"viewindex\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
					   "<head>"+
					   "<col width=\"0%\" hide=\"true\" text=\"\" editPlugin=\"propertyIdPlugin\" column=\"id\"/>"+
					   "<col width=\"0%\" hide=\"true\" text=\"\" editPlugin=\"docPropertyIdPlugin\" column=\"docPropertyId\"/>"+
					   "<col width=\"0%\" hide=\"true\"  text=\"\" editPlugin=\"isCondPlugin\" column=\"isCond\"/>"+
					   "<col width=\"0%\"  hide=\"true\" text=\"\" editPlugin=\"visiblePlugin\" column=\"visible\"/>"+					 
							 "<col width=\"10%\" transmethod=\"weaver.general.KnowledgeTransMethod.getSortImage\" text=\""+SystemEnv.getHtmlLabelName(338, user.getLanguage())+"\" column=\"id\"/>"+
							 "<col width=\"50%\"  transmethod=\"weaver.general.KnowledgeTransMethod.getPropName\" otherpara=\""+user.getLanguage()+"\" column=\"docPropertyId\" text=\""+SystemEnv.getHtmlLabelName(261,user.getLanguage())+"\"/>"+
							 "<col width=\"20%\" editPlugin=\"chkVisiblePlugin\" editEnableMethod=\"weaver.splitepage.transform.SptmForDoc.chkVisibleSearch\" editpara=\"column:docPropertyId\" text=\""+SystemEnv.getHtmlLabelName(15603,user.getLanguage())+"\" column=\"visible\"/>"+
							 "<col width=\"20%\" editPlugin=\"chkMustInputPlugin\" editEnableMethod=\"weaver.splitepage.transform.SptmForDoc.chkVisibleQuery\" editpara=\"column:docPropertyId\" text=\""+SystemEnv.getHtmlLabelName(22837,user.getLanguage())+"\" column=\"isCond\"/>"+
							 "<col width=\"0%\" hide=\"true\" editPlugin=\"columnWidthPlugin\" text=\""+SystemEnv.getHtmlLabelName(19509,user.getLanguage())+"\" column=\"condColumnWidth\"/>"+
							 
					   "</head>"+
					   "</table>"; 
				%>
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
				var visible = jQuery(this).closest("tr").find("input[name='visible']");
				if(!checked){//不显示
					visible.val(0);
				}else{
					visible.val(1);
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
			{text:"",value:"1",name:"chk_isCond"},
		],
		bind:[
			{type:"click",fn:function(){
				var checked = jQuery(this).attr("checked");
				var mustInput = jQuery(this).closest("tr").find("input[name='isCond']");
				if(checked){//必填
					mustInput.val(1);
				}else{
					mustInput.val(0);
				}
				}
			}]
	};
	

var propertyIdPlugin = {
	type:"hidden",
	name:"propertyid",
	addIndex:false
}
var docPropertyIdPlugin = {
	type:"hidden",
	name:"docpropertyid",
	addIndex:false
}

var isCondPlugin = {
	type:"hidden",
	name:"isCond",
	addIndex:false
}

var columnWidthPlugin = {
	type:"select",
	name:"condColumnWidth",
	addIndex:false,
	defaultValue:"1",
	options:[
		{text:"<%=SystemEnv.getHtmlLabelName(83400,user.getLanguage())%>",value:"1"},
		{text:"<%=SystemEnv.getHtmlLabelName(83401,user.getLanguage())%>",value:"3"}
	]
}

function registerDragEvent(){
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
                 ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
                 if(ui.item.hasClass("notMove")){
                 	e.stopPropagation();
                 }
                 return ui;  
             },  
             stop:function(e, ui){
                 //ui.item.removeClass("ui-state-highlight"); //释放鼠标时，要用ui.item才是释放的行  
                 jQuery(ui.item).hover(function(){
                	jQuery(this).addClass("e8_hover_tr");
                },function(){
                	jQuery(this).removeClass("e8_hover_tr");
                });
                return ui;  
             }  
         });  
    }

function onSave(obj){
	obj.disabled = true;
	document.frmCustomSearch.submit();
}
var colNum = 5;

function onSettingUp(obj){
	var currRow = obj.parentElement.parentElement;
	
	if(currRow!=null){
		var currTable = currRow.parentElement.parentElement;
		if(currRow.rowIndex-1<=0) return;

		var insRow1 = currTable.insertRow(currRow.rowIndex-2<0?0:currRow.rowIndex-2);
		var insCell1 = insRow1.insertCell();
		insCell1.colSpan = colNum;
		insCell1.className = "Line";

		var insRow2 = currTable.insertRow(insRow1.rowIndex<0?0:insRow1.rowIndex);
		
		for(var i=0; i<colNum; i++){
			var insCell2 = insRow2.insertCell();
	    	if(i>1) insCell2.className = "field";
			insCell2.innerHTML = currRow.cells[i].innerHTML;
	    	
		}

		currTable.deleteRow(obj.parentElement.parentElement.rowIndex+1);
		currTable.deleteRow(obj.parentElement.parentElement.rowIndex);
	}
	setImgArrow();
}

function onSettingDown(obj){
	var currRow = obj.parentElement.parentElement;
	if(currRow!=null){
		var currTable = currRow.parentElement.parentElement;
		if(currRow.rowIndex+2>=currTable.rows.length) return;

		var insRow1 = currTable.insertRow(currRow.rowIndex+3>currTable.rows.length?currTable.rows.length:currRow.rowIndex+3);
		var insCell1 = insRow1.insertCell();
		insCell1.colSpan = colNum;
		insCell1.className = "Line";

		var insRow2 = currTable.insertRow(insRow1.rowIndex+1>currTable.rows.length?currTable.rows.length:insRow1.rowIndex+1);
		for(var i=0; i<colNum; i++){
			var insCell2 = insRow2.insertCell();
	    	if(i>1) insCell2.className = "field";
			insCell2.innerHTML = currRow.cells[i].innerHTML;
		}

		currTable.deleteRow(obj.parentElement.parentElement.rowIndex-1);
		currTable.deleteRow(obj.parentElement.parentElement.rowIndex);
		
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
		if(i==(imgArrow.length-1)) imgArrow[i].style.visibility = "hidden";
		else imgArrow[i].style.visibility = "visible";
	}
}

</SCRIPT>


</FORM>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

</BODY>
</HTML>
