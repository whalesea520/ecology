
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ page import="weaver.docs.category.security.MultiAclManager" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="DocMouldComInfo1" class="weaver.docs.mouldfile.DocMouldComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
	#propTable table.ListStyle tbody tr td{
		border-bottom:1px solid #f3f2f2;
	}
</style>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript">

function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function reloadPage(){
	window.location.reload();
}

function __beforeJNice__(){
	jQuery("#_xTable div.table").data("_horizrailenabled",false);
}

//当加载完成时，对table进行格式化处理
function afterDoWhenLoaded(){
	var table = jQuery("#propTable").find("table.ListStyle:last");
	table.attr("id","inputface");
	var trs = table.find("tbody tr[class!='Spacing']");
	trs.each(function(){
		var tdId = jQuery(this).children(":eq(5)");
		var tdMouldType = jQuery(this).children("::eq(1)");
		var id = tdId.children("::eq(0)").val();
		//处理隐藏域
		var hMouldType = jQuery("<input type='hidden' name='mouldType"+id+"'/>");
		hMouldType.val(tdMouldType.children("::eq(0)").val());
		tdMouldType.append(tdId.children("::eq(0)"));
		tdMouldType.append(hMouldType);
		
		//处理默认
		var tdIsDefault = jQuery(this).children("::eq(3)");
		tdIsDefault.find("input[name='isDefault']").attr("value",id);
		var isDefaultDisabled = jQuery("<input type='checkbox' name='isDefault_disabled' disabled='' style='display:none'/>");
		tdIsDefault.append(isDefaultDisabled);
		
		//处理模板绑定
		var tdMouldBind = jQuery(this).children("::eq(4)");
		var mouldBindDisabled = tdMouldBind.children(":first").clone();
		mouldBindDisabled.removeAttr("onchange");
		mouldBindDisabled.attr("disabled","");
		mouldBindDisabled.css("display","none");
		mouldBindDisabled.attr("name","mouldBind_disabled");
		var hMouldBind = jQuery("<input type='hidden' name='mouldBind"+id+"'/>");
		hMouldBind.val(tdMouldBind.children(":first").val());
		tdMouldBind.append(mouldBindDisabled);
		tdMouldBind.append(hMouldBind);
		
		//根据模板绑定的值来决定默认值的显示
		var mouldBind = tdMouldBind.children(":first");
		if(mouldBind.val()!=1){
			isDefaultDisabled.css("display","inline");
			tdIsDefault.find("span.jNiceWrapper").css("display","none");
			jQuery("#inputface").jNice();
		}
	});
	
	//删除选择框
	table.find("tr").each(function(){
		jQuery(this).children(":first").remove();
	});
	
	//删除第一个col列
	//table.find("col:first").remove();
	//table.find("col").eq(1).css("width","45.5%");
	//hideTH();
}

</script>
</HEAD>

<%
	
	String titlename = "";
	String qname = Util.null2String(request.getParameter("qname"));
	String id = Util.null2String(request.getParameter("id"));
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

    boolean canEdit = false;
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user) || hasSecManageRight) {
		canEdit = true;
	}
	boolean canEditMode=HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user);

    String isUseET=BaseBean.getPropValue("weaver_obj","isUseET");
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
<BODY >
<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.DOC_SECCATEGORMOULDLIST %>"/>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
  //菜单
  if (canEdit){
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addNewRow(),_top} " ;
	  RCMenuHeight += RCMenuHeightStep ;
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	  RCMenuHeight += RCMenuHeightStep ;
  }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(canEdit){ %>
				<input type=button class="e8_btn_top" onclick="addNewRow();" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<FORM METHOD="POST" name="frmTemplet" ACTION="DocSecCategoryTempletOperation.jsp">
<input type="hidden" name="isedit" id="isedit" value="0">
<INPUT TYPE="hidden" NAME="method" id="method" VALUE="save">
<INPUT TYPE="hidden" NAME="secCategoryId"  id="secCategoryId" value="<%=id%>">
<input type="hidden" name="dMouldType"  id="dMouldType" value="" />
<input type="hidden" name="dIsDefault" id="dIsDefault" value="" />
<input type="hidden" name="dMouldBind" id="dMouldBind" value="" />

<%
	String sqlWhere = "secCategoryId="+id;
	if(!qname.equals("")){
		//sqlWhere = "customname like '%"+qname+"%'";
	}							
	String  operateString= "";
	 String tabletype="none";
	 if(canEdit){
	operateString = "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getTemplateOperate\" otherpara=\"column:mouldType\"></popedom> ";
	 	      operateString+="     <operate href=\"javascript:contentSet()\" otherpara=\"column:mouldId\" text=\""+SystemEnv.getHtmlLabelName(19480,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="     <operate href=\"javascript:deleteRow()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="</operates>";	
	 }
	String tableString=""+
	   "<table instanceid=\"inputface\" id=\"inputface\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_SECCATEGORMOULDLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
	    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getTempletCheckbox\" popedompara = \"column:id\" />"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"DocSecCategoryMould\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+
			 "<col width=\"30%\" editPlugin=\"mouldTypePlugin\" column=\"mouldType\" text=\""+SystemEnv.getHtmlLabelName(19471,user.getLanguage())+"\"/>"+
			 "<col width=\"40%\" editPlugin=\"mouldIdPlugin\"  transmethod=\"weaver.general.KnowledgeTransMethod.getMouldName\" text=\""+SystemEnv.getHtmlLabelName(19472,user.getLanguage())+"\" otherpara=\"column:mouldType\" column=\"mouldId\"/>"+
			 "<col width=\"10%\" editPlugin=\"chkIsDefaultPlugin\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(149,user.getLanguage())+"\" column=\"isDefault\"/>"+
			 "<col width=\"20%\" editPlugin=\"mouldBindPlugin\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(19473,user.getLanguage())+"\" column=\"mouldBind\"/>"+
			  "<col width=\"0%\" hide=\"true\" text=\"\" editPlugin=\"idPlugin\" column=\"id\"/>"+
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

<div id="message_table_Div" style='padding:3px;display:none'></div>

<script>

function addNewRow(){
		//jQuery("#inputface").addNewRow();
		addrow();
	}


var idPlugin = {
	type:"hidden",
	name:"id",
	addIndex:false
}

var isDefaultPlugin = {
	type:"hidden",
	name:"isDefault",
	defaultValue:"0",
	addIndex:false
}

var mouldIdPlugin={
		type:"browser",
		addIndex:false,
		attr:{
			name:"mouldId",
			//nameBak:"mouldId",
			viewType:"0",
			browserValue:"0",
			isMustInput:"1",
			browserSpanValue:"",
			hasInput:false,
			//linkUrl:"javascript:openhrm($id$);",
			isSingle:true,
			//completeUrl:"/data.jsp",
			browserUrl:"#",
			getBrowserUrlFn:"onShowMouldUrl",
			getBrowserUrlFnParams:"this",
			//browserOnClickBak:"onShowMould(this)",
			width:"80%",
			hasAdd:false
			
		}
	};

var chkIsDefaultPlugin = {
		type:"checkbox",
		addIndex:false,
		options:[
			{text:"",value:"1",name:"isDefault"}
		],
		bind:[
			{type:"click",fn:function(){
				onCheckIsDefault(this);
			}
			}]
	};

var mouldBindPlugin = {
	type:"select",
	name: "mouldBind",
	addIndex:false,
	defaultValue:"1",
	options:[
		{text:"<%=SystemEnv.getHtmlLabelName(166, user.getLanguage())%>",value:"1"},
		{text:"<%=SystemEnv.getHtmlLabelName(19478, user.getLanguage())%>",value:"2"},
		{text:"<%=SystemEnv.getHtmlLabelName(19479, user.getLanguage())%>",value:"3"}
	],
	bind:[
		{type:"change",fn:function(){onChangeBind(this);}}
	]
};

var mouldTypePlugin = {
	type:"select",
	name:"mouldType",
	addIndex:false,
	defaultValue:"1",
	options:[
		{text:"<%=SystemEnv.getHtmlLabelName(19474, user.getLanguage())%>",value:"1"},
		{text:"<%=SystemEnv.getHtmlLabelName(19475, user.getLanguage())%>",value:"2"},
		{text:"<%=SystemEnv.getHtmlLabelName(19476, user.getLanguage())%>",value:"3"},
		{text:"<%=SystemEnv.getHtmlLabelName(19477, user.getLanguage())%>",value:"4"},
		{text:"<%=SystemEnv.getHtmlLabelName(22314, user.getLanguage())%>",value:"6"},
		{text:"<%=SystemEnv.getHtmlLabelName(22361, user.getLanguage())%>",value:"7"},
		{text:"<%=SystemEnv.getHtmlLabelName(22362, user.getLanguage())%>",value:"8"}
		<%if("1".equals(isUseET)){%>
		,{text:"<%=SystemEnv.getHtmlLabelName(24546, user.getLanguage())%>",value:"10"}		
		<%}%>
	],
	bind:[
		{type:"onchange",fn:function(){
			onChangeMould(this);
		}
	}]
}

jQuery(document).ready(function(){

	//jQuery(".wuiBrowser").modalDialog();
	
})
function bindUrl(opts,e){
	var obj = e.srcElement||e.target;
	var openmouldurl = new Array(10)
	openmouldurl[0] = "/docs/mould/DocMouldBrowser.jsp?doctype=.htm"
	openmouldurl[1] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.htm"
	openmouldurl[2] = "/docs/mould/DocMouldBrowser.jsp?doctype=.doc"
	openmouldurl[3] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.doc"
	openmouldurl[4] = "/docs/mould/DocMouldBrowser.jsp?doctype=.xls"
	openmouldurl[5] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.xls"
	openmouldurl[6] = "/docs/mould/DocMouldBrowser.jsp?doctype=.wps"
	openmouldurl[7] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.wps"
	openmouldurl[8] = "/docs/mould/DocMouldBrowser.jsp?doctype=.et"
	openmouldurl[9] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.et"
		//alert(jQuery("#"+id).attr("tagName"))
		//alert(jQuery("#"+id).parent().parent().children(":first").children(":first").val())
	opts._url = openmouldurl[jQuery(obj).parent().parent().children(":first").children(":first").val()-1];
	
	//alert(jQuery("#"+id).attr("_url"));
	//jQuery(".wuiBrowser").modalDialog();
}



function showPrompt(content,show){
    var message_table_Div  = document.getElementById("message_table_Div");
    if(show){
        message_table_Div.style.display="";
        message_table_Div.innerHTML=content;
    } else {
        message_table_Div.style.display="none";
    }
}

function addrow(){
  jQuery('#isedit').val("1");
  var url = '/docs/category/DocSecCategoryTempletOperation.jsp';
  var pars = 'secCategoryId=<%=id%>&mouldType=1&mouldId=0&isDefault=0&mouldBind=1&method=add';
  
  //showPrompt("<%=SystemEnv.getHtmlLabelName(19205, user.getLanguage())%>",true);
  
  /*var myAjax = new Ajax.Request(
	url,
	{method: 'post', parameters: pars, onComplete: doAddrow}
  );*/
  jQuery.ajax({
  	url:url,
  	type:"post",
  	dataType:"json",
  	beforeSend:function(){
		e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
		try{
			parent.disableTabBtn();
		}catch(e){}
	},
	complete:function(){
		e8showAjaxTips("",false);
		try{
			parent.enableTabBtn();
		}catch(e){}
	},
  	data:{
  		secCategoryId:<%=id%>,
  		mouldType:1,
  		mouldId:0,
  		isDefault:0,
  		mouldBind:1,
  		method:"add"
  	},
  	success:function(data){
  		/*var trs = jQuery("#inputface").find("tr");
  		var tr = trs.eq(trs.length-2);
  		tr.find("input[name='id']").val(data.id);
		var tdId = jQuery(tr).children(":eq(5)");
		var tdMouldType = jQuery(tr).children("::eq(1)");
		var id = tdId.children("::eq(0)").val();
		//处理隐藏域
		var hMouldType = jQuery("<input type='hidden' name='mouldType"+id+"'/>");
		hMouldType.val(tdMouldType.children("::eq(0)").val());
		tdMouldType.append(tdId.children("::eq(0)"));
		tdMouldType.append(hMouldType);
		
		//处理默认
		var tdIsDefault = jQuery(tr).children("::eq(3)");
		var isDefaultDisabled = jQuery("<input type='checkbox' name='isDefault_disabled' disabled='' style='display:none'/>");
		tdIsDefault.find("input[name='isDefault']").attr("value",id);
		tdIsDefault.append(isDefaultDisabled);
		
		//处理模板绑定
		var tdMouldBind = jQuery(tr).children("::eq(4)");
		var mouldBindDisabled = tdMouldBind.children(":first").clone();
		mouldBindDisabled.removeAttr("onchange");
		mouldBindDisabled.attr("disabled","");
		mouldBindDisabled.css("display","none");
		mouldBindDisabled.attr("name","mouldBind_disabled");
		var hMouldBind = jQuery("<input type='hidden' name='mouldBind"+id+"'/>");
		hMouldBind.val(tdMouldBind.children(":first").val());
		tdMouldBind.append(mouldBindDisabled);
		tdMouldBind.append(hMouldBind);
		//删除第一列
		tr.children(":first").remove();
		jQuery("#inputface").jNice();
		beautySelect();*/
		if(_table.nowPage==_table.pageNum){
			_table.reLoad();
		}else{
			_table.lastPage();
		}
  	}
  });
}

function doAddrow(req){
	var id = req.responseXML.getElementsByTagName('id')[0].firstChild.data;
	
	var oRow;
	var oCell;
	
	var inputface = document.getElementById("inputface");
	
	oRow = inputface.insertRow(-1);
	
	if(inputface.rows.length % 2==0)
		oRow.className = "datadark";
	else
		oRow.className = "datalight";
	
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
    oCell.style.padding="10px 5px";
	oCell.innerHTML = flable1.innerHTML.replace("#value#",id);
	
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
    oCell.style.padding="10px 5px";
	oCell.innerHTML = flable2.innerHTML;
	
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
    oCell.style.padding="10px 5px";
	oCell.innerHTML = flable3.innerHTML.replace("#value#",id) ;
	
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
    oCell.style.padding="10px 5px";
	oCell.innerHTML = flable4.innerHTML.replace("#value#",id) ;
	
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
    oCell.style.padding="10px 5px";
    oCell.innerHTML = flable5.innerHTML ;
    
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
    oCell.style.padding="10px 5px";
	oCell.innerHTML = flable6.innerHTML ;

	showPrompt("",false);

	checkAdd(jQuery(oRow).children("::eq(3)").children(":first"));
}

function checkAdd(obj){
	//新增行的初始数据固定
	//alert(0)
	//var trobj = obj.parentElement;
	//while(trobj.tagName!="TR") trobj = trobj.parentElement;
	var trobj = jQuery(obj).parents("tr:first");
	var inputface = document.getElementById("inputface");
	
	//var row = inputface.rows.length;
	jQuery("#inputface").children("tr").each(function(i,obj){

		if(i<2) return true;
		if(obj==trobj) return true;
		if(jQuery(obj).children("::eq(3)")==undefined) return true;
		if(jQuery(obj).children("::eq(3)").children(":first")==undefined) return true;

		var mouldType = jQuery(obj).children("::eq(0)").children(":first").val();
		var isDefault = jQuery(obj).children("::eq(2)").children(":first").attr("checked");
		var mouldBind = jQuery(obj).children("::eq(3)").children(":first").val();
		if(mouldType != 1){
			return true;
		}
		if(mouldType == '1' && isDefault == true){
			jQuery(trobj).children("::eq(2)").children(":first").attr("checked",false);
			jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked",false);
			//trobj.children(2).children(1).checked = false;
			jQuery(trobj).children("::eq(2)").children(":first").hide();
			jQuery(trobj).children("::eq(2)").children("::eq(1)").css("display","");
			//trobj.children(2).children(0).style.display = "none";
			//trobj.children(2).children(1).style.display = "";
			//break;
			return false;
		}
		if(mouldType == '1' && mouldBind == '2'){
			jQuery(trobj).children("::eq(2)").children(":first").attr("checked",false);
			jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked",false);
			//trobj.children(2).children(0).checked = false;
			//trobj.children(2).children(1).checked = false;
			jQuery(trobj).children("::eq(2)").children(":first").hide();
			jQuery(trobj).children("::eq(2)").children("::eq(1)").css("display","");
			//trobj.children(2).children(0).style.display = "none";
			//trobj.children(2).children(1).style.display = "";
			jQuery(trobj).children("::eq(3)").children(":first").val("1");
			jQuery(trobj).children("::eq(3)").children("::eq(2)").val("1");
			//trobj.children(3).children(0).style.display = "none";
			//trobj.children(3).children(1).style.display = "";
			
			jQuery(trobj).children("::eq(3)").children(":first").hide();
			jQuery(trobj).children("::eq(3)").children("::eq(1)").css("display","");
			//break;
			return false;
		}
	})
}

function deleteRow(id){
var tr=jQuery.getSelectedRow();
var obj = jQuery(tr).children(":first").children(":first");
window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(30952, user.getLanguage())%>",function(){
  jQuery('#isedit').val("1");
  //var id = jQuery(obj).parent().parent().children(":first").children("::eq(1)").val();//parentElement.parentElement.children(0).children(1).value;

  var mouldType = jQuery(obj).parent().parent().children(":first").children("::eq(0)").val();//obj.parentElement.parentElement.children(0).children(0).value;
  var mouldId = jQuery(obj).parent().parent().children("::eq(1)").children("::eq(2)").val();//obj.parentElement.parentElement.children(1).children(2).value;
  mouldId = 0
  //预处理3个暂存input，保存将被删除的行的信息 Start
  document.frmTemplet.dMouldType.value = jQuery(obj).parent().parent().children(":first").children(":first").val();
  if(jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").attr("checked") == true){
		document.frmTemplet.dIsDefault.value = '1';
  }else{
	  document.frmTemplet.dIsDefault.value = '0';
  }
 document.frmTemplet.dMouldBind.value = jQuery(obj).parent().parent().children("::eq(3)").children(":first").val();
 //预处理3个暂存input，保存将被删除的行的信息 End
 id = jQuery.trim(id)
 
  var url = 'DocSecCategoryTempletOperation.jsp';
  var pars = 'id='+id+'&method=delete&mouldType='+mouldType+'&mouldId='+mouldId+'&secCategoryId=<%=id%>';
  
  showPrompt("<%=SystemEnv.getHtmlLabelName(19205, user.getLanguage())%>",true);
  
  /*var myAjax = new Ajax.Request(
	url,
	{method: 'post', parameters: pars, onComplete: doDeleteRow}
  );*/
  jQuery.ajax({
  	url:url+"?"+pars,
  	type:"post",
  	dataType:"json",
  	complete:function(data){
  		doDeleteRow(data);
  	}
  });
});
}

function doDeleteRow(req){
	//alert(req)
	//var id = req.responseXML.getElementsByTagName('id')[0].firstChild.data.replace(/(^\s*)|(\s*$)/g,"");
	var id = req.id;
	id = jQuery.trim(id);
	var arrayinputid = document.frmTemplet.id;
	
	var obj = null;
	if(arrayinputid!=null){
		if(arrayinputid.value!=null){
			obj = arrayinputid;
		} else {
			
			for(var i=0;i<arrayinputid.length;i++){
				//alert(arrayinputid[i].value+"%%%"+id)
				if(jQuery.trim(arrayinputid[i].value)==id)
					obj = arrayinputid[i];
			}
		}
	}
	
	if(obj!=null){
		obj = jQuery(obj).parents("tr:first");
		obj.remove();
	}

	showPrompt("",false);
	
	checkDelete(document.frmTemplet.id[0]);
	
}

function checkDelete(obj){
	
	
	var inputface = document.getElementById("inputface");
	var trobj = jQuery(obj).parents("tr:first");
	
	//while(trobj.tagName!="TR") trobj =  jQuery(trobj).parent();
	
	if(document.frmTemplet.dIsDefault.value == '1'){//被删除项原来是默认模板绑定
		var row = inputface.rows.length;
		for(var i=1; i<=row; i++){
			if(jQuery(inputface).find("::eq("+i+")") == undefined){
				continue;
			}
			if(jQuery(inputface).find("::eq("+i+")").children("::eq(0)") == undefined){
				continue;
			}
			if(jQuery(inputface).find("::eq("+i+")").children("::eq(0)").children("::eq(0)") == undefined){
				continue;
			}
			var mouldType = jQuery(inputface).find("::eq("+i+")").children("::eq(0)").children("::eq(0)").val();
			var isDefault = jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(0)").attr("checked");
			var mouldBind = jQuery(inputface).find("::eq("+i+")").children("::eq(3)").children("::eq(0)").val();
			if(mouldType == document.frmTemplet.dMouldType.value){
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(0)").attr("checked",false);
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(1)").attr("checked",false);
				
				//inputface.rows(i).cells(2).children(1).checked = false;
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(0)").css("display","");
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(1)").hide()
				
				//inputface.rows(i).cells(2).children(0).style.display = "";
				//inputface.rows(i).cells(2).children(1).style.display = "none";
			}
		}
	}
	
	//alert(document.frmTemplet.dMouldBind.value);
	if(document.frmTemplet.dMouldBind.value == '2'){//被删除项原来是正常模板绑定 mouldBind==2
		var row = inputface.rows.length;
		for(var i=1; i<=row; i++){
			if(jQuery(inputface).find("::eq("+i+")") == undefined){
				continue;
			}
			if(jQuery(inputface).find("::eq("+i+")").children("::eq(0)") == undefined){
				continue;
			}
			if(jQuery(inputface).find("::eq("+i+")").children("::eq(0)").children("::eq(0)") == undefined){
				continue;
			}
			var mouldType = jQuery(inputface).find("::eq("+i+")").children("::eq(0)").children("::eq(0)").val();
			var isDefault = jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(0)").attr("checked");
			var mouldBind = jQuery(inputface).find("::eq("+i+")").children("::eq(3)").children("::eq(0)").val();
			
			if(mouldType == document.frmTemplet.dMouldType.value){
				//inputface.rows(i).cells(2).children(0).checked = false;
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(0)").attr("checked",false);
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(1)").attr("checked",false);
				//inputface.rows(i).cells(2).children(1).checked = false;
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(0)").css("display","");
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(1)").hide();
				//inputface.rows(i).cells(2).children(0).style.display = "";
				//inputface.rows(i).cells(2).children(1).style.display = "none";
				jQuery(inputface).find("::eq("+i+")").children("::eq(3)").children("::eq(0)").val("1");
				//inputface.rows(i).cells(3).children(0).value = '1';
				jQuery(inputface).find("::eq("+i+")").children("::eq(3)").children("::eq(1)").val("1")
				//inputface.rows(i).cells(3).children(1).value = inputface.rows(i).cells(3).children(0).value;
				jQuery(inputface).find("::eq("+i+")").children("::eq(3)").children("::eq(2)").val("1")
				//inputface.rows(i).cells(3).children(2).value = inputface.rows(i).cells(3).children(0).value;
				//inputface.rows(i).cells(3).children(0).style.display = "";
				jQuery(inputface).find("::eq("+i+")").children("::eq(3)").children("::eq(0)").css("display","");
				jQuery(inputface).find("::eq("+i+")").children("::eq(3)").children("::eq(1)").hide();
				//inputface.rows(i).cells(3).children(1).style.display = "none";
			}
		}
	}
	_table.reLoad();
}

function gotoMould(d,id){
	if(($('isedit').value=="1"&&window.confirm("<%=SystemEnv.getHtmlLabelName(18407, user.getLanguage())%>"))||$('isedit').value=="0"){
		if(d==1){
			window.parent.location = "/docs/mould/DocMouldDsp.jsp?id="+id;
		} else if(d==2){
			window.parent.location = "/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=";
		} else if(d==3){
			window.parent.location = "/docs/mould/DocMouldDspExt.jsp?id="+id;
		} else if(d==4){
			window.parent.location = "/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=";
		} else if(d==5){
			window.parent.location = "/docs/mould/DocMouldDspExt.jsp?id="+id;
		} else if(d==6){
			window.parent.location = "/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=";
		} else if(d==7){
			window.parent.location = "/docs/mould/DocMouldDspExt.jsp?id="+id;
		} else if(d==8){
			window.parent.location = "/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=";
		} else if(d==9){
			window.parent.location = "/docs/mould/DocMouldDspExt.jsp?id="+id;
		} else if(d==10){
			window.parent.location = "/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=";
		}
	}
}

function gotoMouldNew(obj){
	if(!obj)return false;
	var d = parseInt(jQuery(obj).attr("_mouldType"));
	var id = jQuery(obj).attr("_id");
	var url = "";
	if(d==1){
		url = ("/docs/tabs/DocCommonTab.jsp?_fromURL=23&isdialog=2&id="+id);
	} else if(d==2){
		url = ("/docs/tabs/DocCommonTab.jsp?_fromURL=27&isdialog=2&urlfrom=&id="+id);
	} else if(d==3){
		url = ("/docs/tabs/DocCommonTab.jsp?_fromURL=23&isdialog=2&id="+id);
	} else if(d==4){
		url = ("/docs/tabs/DocCommonTab.jsp?_fromURL=27&urlfrom=&isdialog=2&id="+id);
	} else if(d==5){
		url = ("/docs/tabs/DocCommonTab.jsp?_fromURL=23&isdialog=2&id="+id);
	} else if(d==6){
		url = ("/docs/tabs/DocCommonTab.jsp?_fromURL=27&urlfrom=&isdialog=2&id="+id);
	} else if(d==7){
		url = ("/docs/tabs/DocCommonTab.jsp?_fromURL=23&isdialog=2&id="+id);
	} else if(d==8){
		url = ("/docs/tabs/DocCommonTab.jsp?_fromURL=27&urlfrom=&isdialog=2&id="+id);
	} else if(d==9){
		url = ("/docs/tabs/DocCommonTab.jsp?_fromURL=23&isdialog=2&id="+id);
	} else if(d==10){
		url = ("/docs/tabs/DocCommonTab.jsp?_fromURL=27&urlfrom=&isdialog=2&id="+id);
	}
	viewMould(url);
}

function viewMould(url){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window; 
	<%if(canEditMode){%>
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>";
		<%}else{%>
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(33025,user.getLanguage())%>";
			<%}%>
	
	dialog.Width =jQuery(top.window).width()*0.95;
	dialog.Height = jQuery(top.window).height()*0.95;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.checkDataChange = false;
	dialog.maxiumnable = true;
	dialog.show();
}
	function closeDialog(){
		if(dialog)
			dialog.close();
	}
function onCheckIsDefault(obj){
	document.frmTemplet.dMouldType.value = jQuery(obj).parent().parent().children("::eq(0)").children("::eq(2)").val();
	jQuery(obj).parent().parent().children("::eq(0)").children("::eq(2)").val(jQuery(obj).parent().parent().children("::eq(0)").children("::eq(0)").val());
	if(jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").attr("checked")){
		document.frmTemplet.dIsDefault.value = '1';
	}else{
		document.frmTemplet.dIsDefault.value = '0';
	}
	document.frmTemplet.dMouldBind.value = jQuery(obj).parent().parent().children("::eq(3)").children("::eq(2)").val();
	jQuery(obj).parent().parent().children("::eq(3)").children("::eq(2)").val(jQuery(obj).parent().parent().children("::eq(3)").children("::eq(0)").val());
	var trobj = jQuery(obj).closest("tr").get(0);
	
	var inputface = document.getElementById("inputface");
	//while(trobj.tagName!="TR") trobj = trobj.parentElement;
	var row = inputface.rows.length;
	for(var i=1; i<=row; i++){
		if(inputface.rows[i] == undefined){
			continue;
		}
		if(inputface.rows[i] == trobj){
			continue;
		}
		if(inputface.rows[i].cells[0] == undefined){
			continue;
		}
		if(inputface.rows[i].cells[0].children[0] == undefined){
			continue;
		}
		var mouldType = inputface.rows[i].cells[0].children[0].value;
		var isDefault = inputface.rows[i].cells[2].children[0].checked;
		var mouldBind = inputface.rows[i].cells[3].children[0].value;
		if(mouldType == document.frmTemplet.dMouldType.value){
			if(mouldBind != '3' && document.frmTemplet.dIsDefault.value == '1' && inputface.rows[i].cells[2].children[0].style.display == ""){//勾选
				/*inputface.rows[i].cells[2].children[0].checked = false;
				inputface.rows[i].cells[2].children[1].checked = false;*/
				changeCheckboxStatus(inputface.rows[i].cells[2].children[0],false);
				changeCheckboxStatus(inputface.rows[i].cells[2].children[1],false);
				inputface.rows[i].cells[2].children[0].style.display = "none";
				inputface.rows[i].cells[2].children[1].style.display = "";
			}else if(mouldBind != '3' && document.frmTemplet.dIsDefault.value == '0' && inputface.rows[i].cells[2].children[0].style.display == "none"){//取消勾选
				/*inputface.rows[i].cells[2].children[0].checked = false;
				inputface.rows[i].cells[2].children[1].checked = false;*/
				changeCheckboxStatus(inputface.rows[i].cells[2].children[0],false);
				changeCheckboxStatus(inputface.rows[i].cells[2].children[1],false);
				inputface.rows[i].cells[2].children[0].style.display = "";
				inputface.rows[i].cells[2].children[1].style.display = "none";
			}
		}
	}
}

function onChangeMould(obj){
	jQuery('#isedit').val("1");
	jQuery(obj).parent().parent().children("::eq(1)").children("::eq(1)").html("");
	//obj.parentElement.parentElement.children(1).children(1).innerHTML = "";
	jQuery(obj).parent().parent().children("::eq(1)").children("::eq(2)").val("");
	//obj.parentElement.parentElement.children(1).children(2).value = "";
	if(jQuery(obj).parent().parent().children("::eq(0)").children("::eq(0)").val()==3){
		jQuery(obj).parent().parent().children("::eq(4)").children("::eq(0)").css("display","");
		//obj.parentElement.parentElement.children(4).children(0).style.display = "";
	} else {
		//obj.parentElement.parentElement.children(4).children(0).style.display = "none";
		jQuery(obj).parent().parent().children("::eq(4)").children("::eq(0)").hide();
	}
	//预处理3个暂存input
	document.frmTemplet.dMouldType.value = jQuery(obj).parent().parent().children("::eq(0)").children("::eq(2)").val();
	jQuery(obj).parent().parent().children("::eq(0)").children("::eq(2)").val(jQuery(obj).parent().parent().children("::eq(0)").children("::eq(0)").val());
	if(jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").attr("checked") == true){
		document.frmTemplet.dIsDefault.value = '1';
		jQuery(obj).parent().parent().children("::eq(0)").children("::eq(0)").attr("checked",false);
		jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").attr("checked",false);
	}else{
		document.frmTemplet.dIsDefault.value = '0';
	}
	document.frmTemplet.dMouldBind.value = jQuery(obj).parent().parent().children("::eq(3)").children("::eq(2)").val();
	jQuery(obj).parent().parent().children("::eq(3)").children("::eq(0)").val("1");
	//obj.parentElement.parentElement.children(3).children(1).value = obj.parentElement.parentElement.children(3).children(0).value;
	//obj.parentElement.parentElement.children(3).children(2).value = obj.parentElement.parentElement.children(3).children(0).value;
	jQuery(obj).parent().parent().children("::eq(3)").children("::eq(1)").val("1");
	jQuery(obj).parent().parent().children("::eq(3)").children("::eq(2)").val("1");
	checkChangeMouldType(obj);
}

function checkChangeMouldType(obj){
	//与删除操作类似，解开被disable的页面元素
	//var trobj = obj.parentElement;
	//while(trobj.tagName!="TR") trobj = trobj.parentElement;
	var trobj = jQuery(obj).parents("tr:first");
	
	//用于标识目的模板类型中，是否已经有默认或正常模板绑定
	var hasIsDefault = false;
	var hasMouldBind2 = false;

	var inputface = document.getElementById("inputface");
	
	var row = inputface.rows.length;

	jQuery("#inputface").children("tr").each(function(i,obj){
		if(i>1) return true;
		if(obj==trobj) return true;
		if(jQuery(obj).children("::eq(0)")==undefined) return true;
		if(jQuery(obj).children("::eq(0)").children(":first")==undefined) return true;
		
		var mouldType = jQuery(obj).children("::eq(0)").children(":first").val();
		var isDefault = jQuery(obj).children("::eq(2)").children(":first").attr("checked");
		var mouldBind = jQuery(obj).children("::eq(3)").children(":first").val();
		if(document.frmTemplet.dIsDefault.value == '1' && mouldType == document.frmTemplet.dMouldType.value){
			jQuery(obj).children("::eq(2)").children(":first").attr("checked",false);
			jQuery(obj).children("::eq(2)").children("::eq(1)").attr("checked",false);
			//inputface.rows[i].cells(2).children(0).checked = false;
			//inputface.rows[i].cells(2).children(1).checked = false;
			jQuery(obj).children("::eq(2)").children(":first").css("display","");
			jQuery(obj).children("::eq(2)").children("::eq(1)").hide();
			//inputface.rows[i].cells(2).children(0).style.display = "";
			//inputface.rows(i).cells(2).children(1).style.display = "none";
		}
		if(document.frmTemplet.dMouldBind.value == '2' && mouldType == document.frmTemplet.dMouldType.value){
			//inputface.rows(i).cells(2).children(0).checked = false;
			//inputface.rows(i).cells(2).children(1).checked = false;
			jQuery(obj).children("::eq(2)").children(":first").attr("checked",false);
			jQuery(obj).children("::eq(2)").children("::eq(1)").attr("checked",false);
			//inputface.rows(i).cells(2).children(0).style.display = "";
			//inputface.rows(i).cells(2).children(1).style.display = "none";
			jQuery(obj).children("::eq(2)").children(":first").css("display","");
			jQuery(obj).children("::eq(2)").children("::eq(1)").hide();
			jQuery(obj).children("::eq(3)").children(":first").val("1");
			jQuery(obj).children("::eq(3)").children("::eq(1)").val("1");
			jQuery(obj).children("::eq(3)").children("::eq(2)").val("1");
			//inputface.rows(i).cells(3).children(0).value = '1';
			//inputface.rows(i).cells(3).children(1).value = inputface.rows(i).cells(3).children(0).value;
			//inputface.rows(i).cells(3).children(2).value = inputface.rows(i).cells(3).children(0).value;
			//inputface.rows(i).cells(3).children(0).style.display = "";
			//inputface.rows(i).cells(3).children(1).style.display = "none";
			jQuery(obj).children("::eq(3)").children(":first").css("display","");
			jQuery(obj).children("::eq(3)").children("::eq(1)").hide();
			if(mouldType == jQuery(trobj).children("::eq(0)").children("::eq(0)").val()){
				if(isDefault == true){
					hasIsDefault = true;
				}
				if(mouldBind == '2'){
					hasMouldBind2 = true;
				}
			}
		}
		
		})
	
	if(hasIsDefault == true && hasMouldBind2 == false){
		jQuery(trobj).children("::eq(2)").children("::eq(0)").attr("checked",false);
		jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked",false);
		//trobj.children(2).children(1).checked = false;
		jQuery(trobj).children("::eq(2)").children("::eq(0)").hide();
		jQuery(trobj).children("::eq(2)").children("::eq(1)").css("display","");
		//trobj.children(2).children(0).style.display = "none";
		//trobj.children(2).children(1).style.display = "";
	}else if(hasIsDefault == false && hasMouldBind2 == true){
		//trobj.children(2).children(0).checked = false;
		//trobj.children(2).children(1).checked = false;
		jQuery(trobj).children("::eq(2)").children("::eq(0)").attr("checked",false);
		jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked",false);
		//trobj.children(2).children(0).style.display = "none";
		//trobj.children(2).children(1).style.display = "";
		jQuery(trobj).children("::eq(2)").children("::eq(0)").hide();
		jQuery(trobj).children("::eq(2)").children("::eq(1)").css("display","");
		jQuery(trobj).children("::eq(3)").children("::eq(0)").val("1");
		jQuery(trobj).children("::eq(3)").children("::eq(1)").val("1");
		jQuery(trobj).children("::eq(3)").children("::eq(2)").val("1");
		//trobj.children(3).children(0).value = '1';
		//trobj.children(3).children(1).value = trobj.children(3).children(0).value;
		//trobj.children(3).children(2).value = trobj.children(3).children(0).value;
		//trobj.children(3).children(0).style.display = "none";
		//trobj.children(3).children(1).style.display = "";
		jQuery(trobj).children("::eq(3)").children("::eq(0)").hide();
		jQuery(trobj).children("::eq(3)").children("::eq(1)").css("display","");
	}else if(hasIsDefault == false && hasMouldBind2 == false){
		//trobj.children(2).children(0).checked = false;
		//trobj.children(2).children(1).checked = false;
		jQuery(trobj).children("::eq(2)").children("::eq(0)").attr("checked",false);
		jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked",false);
		//trobj.children(2).children(0).style.display = "";
		//trobj.children(2).children(1).style.display = "none";
		jQuery(trobj).children("::eq(2)").children("::eq(1)").hide();
		jQuery(trobj).children("::eq(2)").children("::eq(0)").css("display","");
		//trobj.children(3).children(0).value = '1';
		//trobj.children(3).children(1).value = trobj.children(3).children(0).value;
		//trobj.children(3).children(2).value = trobj.children(3).children(0).value;
		jQuery(trobj).children("::eq(3)").children("::eq(0)").val("1");
		jQuery(trobj).children("::eq(3)").children("::eq(1)").val("1");
		jQuery(trobj).children("::eq(3)").children("::eq(2)").val("1");
		//trobj.children(3).children(0).style.display = "";
		//trobj.children(3).children(1).style.display = "none";
		jQuery(trobj).children("::eq(3)").children("::eq(1)").hide();
		jQuery(trobj).children("::eq(3)").children("::eq(0)").css("display","");
	}
}

function onChangeBind(obj){
	jQuery('#isedit').val("1");
	//修改绑定类型会联动check框，所以先保存原来的check框的display类型
	var cdisplay0 = jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").css("display");
	var cdisplay1 = jQuery(obj).parent().parent().children("::eq(2)").children("::eq(1)").css("display");
	if(jQuery(obj).parent().parent().children("::eq(3)").children("::eq(0)").val()!=1){
		jQuery(obj).parent().parent().children("::eq(2)").find("input[name='isDefault']").attr("checked",false);
		jQuery(obj).parent().parent().children("::eq(2)").find("input[name='isDefault']").siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
		jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").hide();
		jQuery(obj).parent().parent().children("::eq(2)").children("::eq(1)").css("display","");
		jQuery("#inputface").jNice();
	} else {
		jQuery(obj).parent().parent().children("::eq(2)").children("::eq(1)").hide();
		jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").css("display","");
	}
	//预处理3个暂存input
	document.frmTemplet.dMouldType.value = jQuery(obj).parent().parent().children("::eq(0)").children("::eq(2)").val();//存原来的模版类型
	//obj.parentElement.parentElement.children(0).children(2).value = jQuery(obj).parent().parent().children("::eq(0)").children("::eq(0)").val();
	jQuery(obj).parent().parent().children("::eq(0)").children("::eq(3)").val(jQuery(obj).parent().parent().children("::eq(0)").children("::eq(0)").val());
	if(jQuery(obj).parent().parent().children("::eq(2)").find("input[name='isDefault']").attr("checked") == true){//存原来的默认信息
		document.frmTemplet.dIsDefault.value = '1';
	}else{
		document.frmTemplet.dIsDefault.value = '0';
	}
	document.frmTemplet.dMouldBind.value = jQuery(obj).parent().parent().children("::eq(3)").children("::eq(2)").val();//存原来的绑定类型
	jQuery(obj).parent().parent().children("::eq(3)").children("::eq(2)").val(jQuery(obj).parent().parent().children("::eq(3)").children("::eq(0)").val());

	checkChangeBind(obj, cdisplay0, cdisplay1);
}


function checkChangeBind(obj, cdisplay0, cdisplay1){
	//alert(document.frmTemplet.dMouldType.value);
	//alert(document.frmTemplet.dIsDefault.value);
	//alert(document.frmTemplet.dMouldBind.value);
	//var trobj = obj.parentElement;
	//while(trobj.tagName!="TR") trobj = trobj.parentElement;
	var trobj = jQuery(obj).parents("tr:first");
	var hasMouldBind2 = false;
	var isChange = true;
	//做循环，检查是否需要改变check和selection Start
	
	var inputface = document.getElementById("inputface");
	
	var row = inputface.rows.length;

	jQuery("#inputface").children("tr").each(function(i,obj){
		if(i>1) return true;
		if(obj==trobj) return true;
		if(jQuery(obj).children("::eq(0)")==undefined) return true;
		if(jQuery(obj).children("::eq(0)").children(":first")==undefined) return true;
		
		var mouldType = jQuery(obj).children("::eq(0)").children(":first").val();
		var isDefault = jQuery(obj).children("::eq(2)").children(":first").attr("checked");
		var mouldBind = jQuery(obj).children("::eq(3)").children(":first").val();

		if(mouldType == jQuery(trobj).children("::eq(0)").children("::eq(0)").val() && mouldBind == '3' && jQuery(trobj).children("::eq(3)").children("::eq(0)").val()=='3'){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19507, user.getLanguage())%>");
			if(document.frmTemplet.dIsDefault.value == '1'){//原来是默认绑定
				
				jQuery(trobj).children("::eq(2)").children("::eq(0)").attr("checked","true");
				jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked","true");
				//trobj.children(2).children(1).checked = true;
				jQuery(trobj).children("::eq(2)").children("::eq(0)").css("display","");
				jQuery(trobj).children("::eq(2)").children("::eq(1)").hide();
				//trobj.children(2).children(0).style.display = "";
				//trobj.children(2).children(1).style.display = "none";
				jQuery(trobj).children("::eq(3)").children("::eq(0)").val("1");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").val("1");
				jQuery(trobj).children("::eq(3)").children("::eq(2)").val("1");
				//trobj.children(3).children(0).value = '1';
				//trobj.children(3).children(1).value = trobj.children(3).children(0).value;
				//trobj.children(3).children(2).value = trobj.children(3).children(0).value;
				//trobj.children(3).children(0).style.display = "";
				//trobj.children(3).children(1).style.display = "none";
				jQuery(trobj).children("::eq(3)").children("::eq(0)").css("display","");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").hide();
			}else if(document.frmTemplet.dMouldBind.value == '1'){
				//trobj.children(2).children(0).checked = false;
				//trobj.children(2).children(1).checked = false;
				jQuery(trobj).children("::eq(2)").find("input[name='isDefault']").attr("checked",false);
				jQuery(trobj).children("::eq(2)").find("input[name='isDefault_disabled']").attr("checked",false);
				//trobj.children(2).children(0).style.display = cdisplay0;
				//trobj.children(2).children(1).style.display = cdisplay1;
				jQuery(trobj).children("::eq(2)").children("::eq(0)").css("display",cdisplay0);
				jQuery(trobj).children("::eq(2)").children("::eq(1)").css("display",cdisplay1);
				//trobj.children(3).children(0).value = '1';
				//trobj.children(3).children(1).value = trobj.children(3).children(0).value;
				//trobj.children(3).children(2).value = trobj.children(3).children(0).value;
				jQuery(trobj).children("::eq(3)").children("::eq(0)").val("1");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").val("1");
				jQuery(trobj).children("::eq(3)").children("::eq(2)").val("1");
				//trobj.children(3).children(0).style.display = "";
				//trobj.children(3).children(1).style.display = "none";
				jQuery(trobj).children("::eq(3)").children("::eq(0)").css("display","");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").hide();
			}else if(document.frmTemplet.dMouldBind.value == '2'){
				//trobj.children(2).children(0).checked = false;
				//trobj.children(2).children(1).checked = false;
				jQuery(trobj).children("::eq(2)").find("input[name='isDefault']").attr("checked",false);
				jQuery(trobj).children("::eq(2)").find("input[name='isDefault_disabled']").attr("checked",false);
				//trobj.children(2).children(0).style.display = cdisplay0;
				//trobj.children(2).children(1).style.display = cdisplay1;
				jQuery(trobj).children("::eq(2)").children("::eq(0)").css("display",cdisplay0);
				jQuery(trobj).children("::eq(2)").children("::eq(1)").css("display",cdisplay1);
				//trobj.children(3).children(0).value = '2';
				//trobj.children(3).children(1).value = trobj.children(3).children(0).value;
				//trobj.children(3).children(2).value = trobj.children(3).children(0).value;
				jQuery(trobj).children("::eq(3)").children("::eq(0)").val("2");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").val("2");
				jQuery(trobj).children("::eq(3)").children("::eq(2)").val("2");
				//trobj.children(3).children(0).style.display = "";
				//trobj.children(3).children(1).style.display = "none";
				jQuery(trobj).children("::eq(3)").children("::eq(0)").css("display","");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").hide();
			}
			isChange = false;
			return true;
		}
		if(mouldType == jQuery(trobj).children("::eq(0)").children("::eq(0)").val() && mouldBind == '2' && jQuery(trobj).children("::eq(3)").children("::eq(0)").val()=='2'){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19506, user.getLanguage())%>");
			//mouldBind不能变成2，却变成了2，只能是3->2
			//trobj.children(2).children(0).checked = false;
			//trobj.children(2).children(1).checked = false;
			jQuery(trobj).children("::eq(2)").find("input[name='isDefault']").attr("checked",false);
			jQuery(trobj).children("::eq(2)").find("input[name='isDefault_disabled']").attr("checked",false);
			//trobj.children(2).children(0).style.display = cdisplay0;
			//trobj.children(2).children(1).style.display = cdisplay1;
			jQuery(trobj).children("::eq(2)").children("::eq(0)").css("display",cdisplay0);
			jQuery(trobj).children("::eq(2)").children("::eq(1)").css("display",cdisplay1);
			//trobj.children(3).children(0).value = '3';
			//trobj.children(3).children(1).value = trobj.children(3).children(0).value;
			//trobj.children(3).children(2).value = trobj.children(3).children(0).value;
			jQuery(trobj).children("::eq(3)").children("::eq(0)").val("3");
			jQuery(trobj).children("::eq(3)").children("::eq(1)").val("3");
			jQuery(trobj).children("::eq(3)").children("::eq(2)").val("3");
			//trobj.children(3).children(0).style.display = "";
			//trobj.children(3).children(1).style.display = "none";
			jQuery(trobj).children("::eq(3)").children("::eq(0)").css("display","");
			jQuery(trobj).children("::eq(3)").children("::eq(1)").hide();
			isChange = false;
			return true;
		}
		if(mouldType == trobj.children(0).children(0).value && mouldBind == '2'){
			hasMouldBind2 = true;
		}
	})

	//做循环，检查是否需要改变check和selection End
	//确实改变了绑定类型 Start
	if(isChange == true){
		jQuery("#inputface").children("tr").each(function(i,obj){
			if(i>1) return true;
			if(obj==trobj) return true;
			if(jQuery(obj).children("::eq(0)")==undefined) return true;
			if(jQuery(obj).children("::eq(0)").children(":first")==undefined) return true;
			var mouldType = jQuery(obj).children("::eq(0)").children(":first").val();
			var isDefault = jQuery(obj).children("::eq(2)").children(":first").attr("checked");
			var mouldBind = jQuery(obj).children("::eq(3)").children(":first").val();
			if(mouldType != document.frmTemplet.dMouldType.value ||  mouldBind == '3'){//模板类型不同，或者是临时绑定，不改变
				return true;
			}
			if(document.frmTemplet.dMouldBind.value == '2' && (jQuery(trobj).children("::eq(3)").children("::eq(0)").val() == '1' || jQuery(trobj).children("::eq(3)").children("::eq(0)").value == '3')){//2->1的解锁，全解
				//inputface.rows(i).cells(2).children(0).checked = false;//原来有
				//inputface.rows(i).cells(2).children(1).checked = false;
				jQuery(obj).children("::eq(2)").find("input[name='isDefault']").attr("checked",false);
				jQuery(obj).children("::eq(2)").find("input[name='isDefault_disabled']").attr("checked",false);
				//inputface.rows(i).cells(2).children(0).style.display = "";
				//inputface.rows(i).cells(2).children(1).style.display = "none";
				jQuery(obj).children("::eq(2)").children("::eq(0)").css("display","");
				jQuery(obj).children("::eq(2)").children("::eq(1)").hide();
				//inputface.rows(i).cells(3).children(0).value = '1';
				//inputface.rows(i).cells(3).children(1).value = inputface.rows(i).cells(3).children(0).value;
				//inputface.rows(i).cells(3).children(2).value = inputface.rows(i).cells(3).children(0).value;
				jQuery(obj).children("::eq(3)").children("::eq(0)").val("1");
				jQuery(obj).children("::eq(3)").children("::eq(1)").val("1");
				jQuery(obj).children("::eq(3)").children("::eq(2)").val("1");
				//inputface.rows(i).cells(3).children(0).style.display = "";
				//inputface.rows(i).cells(3).children(1).style.display = "none";
				jQuery(obj).children("::eq(3)").children("::eq(0)").css("display","");
				jQuery(obj).children("::eq(3)").children("::eq(1)").hide();
			}else if(document.frmTemplet.dMouldBind.value == '1' && jQuery(trobj).children("::eq(3)").children("::eq(0)").val() == '2'){//1->2的关锁，全关
				//inputface.rows(i).cells(2).children(0).checked = false;
				//inputface.rows(i).cells(2).children(1).checked = false;
				jQuery(obj).children("::eq(2)").find("input[name='isDefault']").attr("checked",false);
				jQuery(obj).children("::eq(2)").find("input[name='isDefault_disabled']").attr("checked",false);
				//inputface.rows(i).cells(2).children(0).style.display = "none";
				//inputface.rows(i).cells(2).children(1).style.display = "";
				jQuery(obj).children("::eq(2)").children("::eq(1)").css("display","");
				jQuery(obj).children("::eq(2)").children("::eq(0)").hide();
				//inputface.rows(i).cells(3).children(0).value = '1';
				//inputface.rows(i).cells(3).children(1).value = inputface.rows(i).cells(3).children(0).value;
				//inputface.rows(i).cells(3).children(2).value = inputface.rows(i).cells(3).children(0).value;
				jQuery(obj).children("::eq(3)").children("::eq(0)").val("1");
				jQuery(obj).children("::eq(3)").children("::eq(1)").val("1");
				jQuery(obj).children("::eq(3)").children("::eq(2)").val("1");
				//inputface.rows(i).cells(3).children(0).style.display = "none";
				//inputface.rows(i).cells(3).children(1).style.display = "";
				jQuery(obj).children("::eq(3)").children("::eq(1)").css("display","");
				jQuery(obj).children("::eq(3)").children("::eq(0)").hide();
			}else if(document.frmTemplet.dMouldBind.value == '1' && jQuery(trobj).children("::eq(3)").children("::eq(0)").val() == '3'){//1->3 不影响其他的
				//操作留空
			}else if(document.frmTemplet.dMouldBind.value == '3' && jQuery(trobj).children("::eq(3)").children("::eq(0)").val() == '2'){//3->2 关锁
				//inputface.rows(i).cells(2).children(0).checked = false;
				//inputface.rows(i).cells(2).children(1).checked = false;
				jQuery(obj).children("::eq(2)").find("input[name='isDefault']").attr("checked",false);
				jQuery(obj).children("::eq(2)").find("input[name='isDefault_disabled']").attr("checked",false);
				//inputface.rows(i).cells(2).children(0).style.display = "none";
				//inputface.rows(i).cells(2).children(1).style.display = "";
				jQuery(obj).children("::eq(2)").children("::eq(1)").css("display","");
				jQuery(obj).children("::eq(2)").children("::eq(0)").hide();
				//inputface.rows(i).cells(3).children(0).value = '1';
				//inputface.rows(i).cells(3).children(1).value = inputface.rows(i).cells(3).children(0).value;
				//inputface.rows(i).cells(3).children(2).value = inputface.rows(i).cells(3).children(0).value;
				jQuery(obj).children("::eq(3)").children("::eq(0)").val("1");
				jQuery(obj).children("::eq(3)").children("::eq(1)").val("1");
				jQuery(obj).children("::eq(3)").children("::eq(2)").val("1");
				
				//inputface.rows(i).cells(3).children(0).style.display = "none";
				//inputface.rows(i).cells(3).children(1).style.display = "";
				jQuery(obj).children("::eq(3)").children("::eq(1)").css("display","");
				jQuery(obj).children("::eq(3)").children("::eq(0)").hide();
			}
			})
		
		if(document.frmTemplet.dMouldBind.value == '3' && jQuery(trobj).children("::eq(3)").children("::eq(0)").val() == '1'){//3->1 不影响其他的，但要判断本身是否该display
			//当存在mouldBind2时，要display
			//因为不影响其他的行，所以不放在循环中
			if(hasMouldBind2 == true){
				//trobj.children(2).children(0).checked = false;
				//trobj.children(2).children(1).checked = false;
				jQuery(trobj).children("::eq(2)").find("input[name='isDefault']").attr("checked",false);
				jQuery(trobj).children("::eq(2)").find("input[name='isDefault_disabled']").attr("checked",false);
				//trobj.children(2).children(0).style.display = "none";
				//trobj.children(2).children(1).style.display = "";
				jQuery(trobj).children("::eq(2)").children("::eq(0)").css("display","");
				jQuery(trobj).children("::eq(2)").children("::eq(1)").hide();
				//trobj.children(3).children(0).value = '1';
				//trobj.children(3).children(1).value = trobj.children(3).children(0).value;
				//trobj.children(3).children(2).value = trobj.children(3).children(0).value;
				jQuery(trobj).children("::eq(3)").children("::eq(0)").val("1");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").val("1");
				jQuery(trobj).children("::eq(3)").children("::eq(2)").val("1");
				//trobj.children(3).children(0).style.display = "none";
				//trobj.children(3).children(1).style.display = "";
				jQuery(trobj).children("::eq(3)").children("::eq(0)").css("display","");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").hide();
			}
		}
	}
	//确实改变了绑定类型 End
}

function onCheckMould(obj){
	jQuery('#isedit').val("1");
	onCheckIsDefault(obj);
}

function checkSelection(){
    var flag = true;

	var amouldtype = document.frmTemplet.mouldType;
	var amouldbind = document.frmTemplet.mouldBind;
	var aid = document.frmTemplet.id;
	var amouldid = document.frmTemplet.mouldId;
	var aisdefault = document.frmTemplet.isDefault;

    if(aid!=null&&typeof(aid.length)=="undefined"){
        if(aid.value==0||amouldid.value==0){
            flag = false;
        }
	}
	
    for(var i=0;aid!=null&&aid.length>0&&i<aid.length;i++){
        //checkSave(amouldtype[i]);
		if(aid.length==1){
            if(aid[i].value==0||amouldid.value==0){
                flag = false;
                break;
            }
		}else{
			
            if(aid[i].value==0||amouldid[i].value==0){
                flag = false;
                break;
            }
		}
    }
    return flag;
}

//function checkSave(obj){


//}

function checkLoad(){
	//alert('Load OK !');
	var hasIsDefault = new Array();
	hasIsDefault[0] = false;
	hasIsDefault[1] = false;
	hasIsDefault[2] = false;
	hasIsDefault[3] = false;
	var hasMouldBind2 = new Array();
	hasMouldBind2[0] = false;
	hasMouldBind2[1] = false;
	hasMouldBind2[2] = false;
	hasMouldBind2[3] = false;
	//做循环，检查4种模板类型是否有默认或正常绑定（可选择和临时绑定不影响同类型其他行） Start
	
	var inputface = document.getElementById("inputface");
	
	var row = inputface.rows.length;
	jQuery("#inputface").children("tr").each(function(i,obj){
		if(i<1) return true;
		if(jQuery(obj).children("::eq(0)")==undefined) return true;
		if(jQuery(obj).children("::eq(0)").children(":first")==undefined) return true;
		var mouldType = jQuery(obj).children("::eq(0)").children(":first").val();
		var isDefault = jQuery(obj).children("::eq(2)").children(":first").attr("checked");
		var mouldBind = jQuery(obj).children("::eq(3)").children(":first").val();
		if(isDefault == true){
			hasIsDefault[mouldType] = true;
		}
		if(mouldBind == '2'){
			hasMouldBind2[mouldType] = true;
		}
	})
	
	jQuery("#inputface").children("tr").each(function(i,obj){
		if(i<1) return true;
		if(jQuery(obj).children("::eq(0)")==undefined) return true;
		if(jQuery(obj).children("::eq(0)").children(":first")==undefined) return true;
		var mouldType = jQuery(obj).children("::eq(0)").children(":first").val();
		var isDefault = jQuery(obj).children("::eq(2)").children(":first").attr("checked");
		var mouldBind = jQuery(obj).children("::eq(3)").children(":first").val();
		if(hasIsDefault[mouldType] == true && isDefault == false && mouldBind == '1'){//同模板类型有默认值，但当前不是默认，并且不是临时绑定
			//inputface.rows(i).cells(2).children(0).checked = false;
			//inputface.rows(i).cells(2).children(1).checked = false;
			jQuery(obj).children("::eq(2)").children(":first").attr("checked",false);
			jQuery(obj).children("::eq(2)").children("::eq(1)").attr("checked",false);
			jQuery(obj).children("::eq(2)").children(":first").hide();
			jQuery(obj).children("::eq(2)").children("::eq(1)").css("display","");
			//inputface.rows(i).cells(2).children(0).style.display = "none";
			//inputface.rows(i).cells(2).children(1).style.display = "";
			//inputface.rows(i).cells(3).children(0).value = '1';
			//inputface.rows(i).cells(3).children(2).value = inputface.rows(i).cells(3).children(0).value;
			//inputface.rows(i).cells(3).children(0).style.display = "";
			//inputface.rows(i).cells(3).children(1).style.display = "none";
		}
		if(hasMouldBind2[mouldType] == true && mouldBind != '2' && mouldBind != '3'){//同模板类型有正常绑定，但当前不是正常绑定，并且不是临时绑定
			//inputface.rows(i).cells(2).children(0).checked = false;
			//inputface.rows(i).cells(2).children(1).checked = false;
			jQuery(obj).children("::eq(2)").children(":first").attr("checked",false);
			jQuery(obj).children("::eq(2)").children("::eq(1)").attr("checked",false);
			//inputface.rows(i).cells(2).children(0).style.display = "none";
			//inputface.rows(i).cells(2).children(1).style.display = "";
			jQuery(obj).children("::eq(2)").children(":first").hide();
			jQuery(obj).children("::eq(2)").children("::eq(1)").css("display","");
			//inputface.rows(i).cells(3).children(0).value = '1';
			//inputface.rows(i).cells(3).children(1).value = inputface.rows(i).cells(3).children(0).value;
			//inputface.rows(i).cells(3).children(2).value = inputface.rows(i).cells(3).children(0).value;
			jQuery(obj).children("::eq(3)").children(":first").val("1");
			jQuery(obj).children("::eq(3)").children("::eq(1)").val("1");
			jQuery(obj).children("::eq(3)").children("::eq(2)").val("1");
			//inputface.rows(i).cells(3).children(0).style.display = "none";
			//inputface.rows(i).cells(3).children(1).style.display = "";
			jQuery(obj).children("::eq(3)").children(":first").hide();
			jQuery(obj).children("::eq(3)").children("::eq(1)").css("display","");
			//break;
		}
	})
	//做循环，检查4种模板类型是否有默认或正常绑定（可选择和临时绑定不影响同类型其他行） End
}

//checkLoad();

function onSave(obj){
	try{
		parent.disableTabBtn();
	}catch(e){}
	if(checkSelection()){
		document.frmTemplet.submit();
	} else {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19508, user.getLanguage())%>!");
		try{
			parent.enableTabBtn();
		}catch(e){}
	}
}

function contentSet(id,mould,obj){
	
	/*if((jQuery('#isedit').val() == 1&&window.confirm("<%=SystemEnv.getHtmlLabelName(18407, user.getLanguage())%>"))||jQuery('#isedit').val() == 0){
		window.parent.location = "ContentSetting.jsp?id="+jQuery(obj).parent().parent().children("::eq(0)").children("::eq(1)").val()+"&mould="+jQuery(obj).parent().parent().children("::eq(1)").children("::eq(2)").val()+"&seccategory="+document.frmTemplet.secCategoryId.value;
	}*/
	//alert(jQuery('#isedit').val());
	//if(jQuery('#isedit').val() == 1){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		if(id==null){
			id="";
		}
		var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=92&isdialog=1&id="+id+"&mould="+mould+"&seccategory=<%=id%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("19480",user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 600;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	//}
}

function onShowMouldUrl(obj){
	var openmouldurl = new Array(10)
	openmouldurl[0] = "/docs/mould/DocMouldBrowser.jsp?doctype=.htm"
	openmouldurl[1] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.htm"
	openmouldurl[2] = "/docs/mould/DocMouldBrowser.jsp?doctype=.doc"
	openmouldurl[3] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.doc"
	openmouldurl[4] = "/docs/mould/DocMouldBrowser.jsp?doctype=.xls"
	openmouldurl[5] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.xls"
	openmouldurl[6] = "/docs/mould/DocMouldBrowser.jsp?doctype=.wps"
	openmouldurl[7] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.wps"
	openmouldurl[8] = "/docs/mould/DocMouldBrowser.jsp?doctype=.et"
	openmouldurl[9] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.et"
	return "/systeminfo/BrowserMain.jsp?url="+openmouldurl[jQuery(obj).closest("tr").children("::eq(0)").children(":first").val()-1];
}

function onShowMould(obj){
	var openmouldurl = new Array(10)
	openmouldurl[0] = "/docs/mould/DocMouldBrowser.jsp?doctype=.htm"
	openmouldurl[1] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.htm"
	openmouldurl[2] = "/docs/mould/DocMouldBrowser.jsp?doctype=.doc"
	openmouldurl[3] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.doc"
	openmouldurl[4] = "/docs/mould/DocMouldBrowser.jsp?doctype=.xls"
	openmouldurl[5] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.xls"
	openmouldurl[6] = "/docs/mould/DocMouldBrowser.jsp?doctype=.wps"
	openmouldurl[7] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.wps"
	openmouldurl[8] = "/docs/mould/DocMouldBrowser.jsp?doctype=.et"
	openmouldurl[9] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.et"
		var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_scroll:"auto",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	var data = window.showModalDialog(openmouldurl[jQuery(obj).closest("tr").children("::eq(3)").children(":first").val()-1],null,"addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
	/*jQuery(obj).parent().parent().children("::eq(1)").children("::eq(1)").html( "<a style='cursor:pointer' onclick='gotoMould("+jQuery(obj).parent().parent().children(":first").children(":first").val()+","+data.id+");'>"+data.name+"</a>")
	jQuery(obj).parent().parent().children("::eq(1)").children("::eq(2)").val(data.id)*/
	if(data){
		if (data.id != ""){
			jQuery(obj).closest("div.e8_os").find("span#mouldIdspan:first").html( "<a style='cursor:pointer' _id="+data.id+" onclick='gotoMould("+jQuery(obj).closest("tr").children("::eq(3)").children(":first").val()+","+data.id+");'>"+data.name+"</a>");
			jQuery(obj).closest("div.e8_os").find("input#mouldId:first").val(data.id);
		}else{
			jQuery(obj).closest("div.e8_os").find("span#mouldIdspan:first").html("");
			jQuery(obj).closest("div.e8_os").find("input#mouldId:first").val("");
		}
	}
	frmTemplet.isedit.value = "1"
	
}
</script>

</FORM>

<div style="display:none" id="flable1">
   	<select name="mouldType" onChange="onChangeMould(this);">
   	<option value="1"><%=SystemEnv.getHtmlLabelName(19474, user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(19475, user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(19476, user.getLanguage())%></option>
		<option value="4"><%=SystemEnv.getHtmlLabelName(19477, user.getLanguage())%></option>
<!--		<option value="5"><%=SystemEnv.getHtmlLabelName(22313, user.getLanguage())%></option>-->
		<option value="6"><%=SystemEnv.getHtmlLabelName(22314, user.getLanguage())%></option>
		<option value="7"><%=SystemEnv.getHtmlLabelName(22361, user.getLanguage())%></option>
		<option value="8"><%=SystemEnv.getHtmlLabelName(22362, user.getLanguage())%></option>
<%if("1".equals(isUseET)){%>
<!--		<option value="9">WPS表格显示模板</option>-->
		<option value="10"><%=SystemEnv.getHtmlLabelName(24546, user.getLanguage())%></option>
<%}%>
    </select>
	<input type="hidden" name="id" value="#value#">
	<input type="hidden" name="mouldType#value#" value="1" />
</div>

<div style="display:none" id="flable2">
	 <button class=browser onclick="onShowMould(this)" type="button"></button> 
	
	<span id=mouldIdspan></span>
	<input type=hidden name="mouldId" value="">	        
</div>

<div style="display:none" id="flable3">
  	<INPUT class=InputStyle type=checkbox value="#value#" name="isDefault" style="display:;" onclick="onCheckMould(this);">
  	<INPUT class=InputStyle type=checkbox disabled name="isDefault_disabled" style="display:none;">
</div>

<div style="display:none" id="flable4">
  	<select name="mouldBind" onChange="onChangeBind(this);" style="display:">
  		<option value="1"><%=SystemEnv.getHtmlLabelName(166, user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(19478, user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(19479, user.getLanguage())%></option>
	</select>
  	<select name="mouldBind_disabled" disabled style="display:none">
  		<option value="1"><%=SystemEnv.getHtmlLabelName(166, user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(19478, user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(19479, user.getLanguage())%></option>
	</select>
	<input type="hidden" name="mouldBind#value#" value="1" />
</div>

<div style="display:none" id="flable5">
	<a style='cursor:pointer;display:none' onclick="contentSet(this);"><%=SystemEnv.getHtmlLabelName(19480, user.getLanguage())%></a>
</div>

<div style="display:none" id="flable6">
	<a style='cursor:pointer' onclick="deleteRow(this);"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>
</div>

</BODY>
</HTML>
