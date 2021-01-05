
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_item" class="weaver.conn.RecordSet" scope="page" />
<%
int fieldid = Util.getIntValue(request.getParameter("fieldid"), 0);
int childfieldid = Util.getIntValue(request.getParameter("childfieldid"), 0);
int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
int selectvalue = Util.getIntValue(request.getParameter("selectvalue"), -1);
String multiselectflag = Util.null2String(Util.getIntValue(request.getParameter("multiselectflag"),0));
String multiselectvalue = Util.null2String(request.getParameter("multiselectvalue"));
int childvalue = Util.getIntValue(request.getParameter("childvalue"), -1);
int isdetail = Util.getIntValue(request.getParameter("isdetail"), 0);
int rowindex = Util.getIntValue(request.getParameter("rowindex"), 0);
int pageParams = Util.getIntValue(request.getParameter("pageParams"),0);
int isSearch = Util.getIntValue(request.getParameter("isSearch"),0);
int customid = Util.getIntValue(request.getParameter("customid"),0);
int browserid = Util.getIntValue(request.getParameter("browserid"),0);

String fieldname = "";
if(isdetail == 0){
	fieldname = "con"+childfieldid+"_value";
}else{
	fieldname = "con"+childfieldid+"_value_"+rowindex;
}
int childfieldidconditionTransition = 0;
if(!"0".equals(customid+"")){
	String sql1="select conditionTransition from mode_CustomDspField where fieldid="+childfieldid+" and customid="+customid;
	rs.executeSql(sql1);
	if(rs.next()){
		childfieldidconditionTransition = Util.getIntValue(rs.getString("conditionTransition"),0);
	}
}else if(!"0".equals(browserid+"")){
	String sql1="select conditionTransition from mode_CustombrowserDspField where fieldid="+childfieldid+" and customid="+browserid;
	rs.executeSql(sql1);
	if(rs.next()){
		childfieldidconditionTransition = Util.getIntValue(rs.getString("conditionTransition"),0);
	}
}
//con<%=id%>_value

%>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script type="text/javascript">
var childfieldValue = "<%=childvalue%>";
if(childfieldValue=="-1"){

	try{
	
		childfieldValue = window.parent.document.getElementById("<%=fieldname%>").value;
	}catch(e){
		childfieldValue = "";
	}
	if(childfieldValue==null || childfieldValue=="-1"){
		childfieldValue = "";
	}
}
var selectfield = null;
function getSelectField(){
	try{
		var elements = window.parent.document.getElementsByName("<%=fieldname%>");
		//alert(elements.length);
		if(elements.length==null){
			selectfield = elements;
		}else{
			for(var i=0; i<elements.length; i++) {
				try{
					//alert(elements[i]);
					//alert(elements[i].name);
					//alert(elements[i].tagName);
					if(elements[i].tagName=="SELECT"){
						selectfield = elements[i];
						break;
					}
				}catch(e){}
			}
		}
	}catch(e){}
	//alert(selectfield);
	//alert(selectfield.tagName);
}
function onChangeSelectField_All(){
	try{
		//var selectfield = window.parent.document.getElementById("<%=fieldname%>");
		if(selectfield != null){
			parent.jQuery("#<%=fieldname%>").get(0).options.length = 0;
			<%if(childfieldidconditionTransition!=1){%>
				parent.jQuery("#<%=fieldname%>").append("<option></option>");
			<%}%>
		}
	}catch(e){}
}
getSelectField();
if(selectfield != null){
	if('<%=browserid%>'=='0'){
		//onChangeSelectField_All();
	}
}
</script>
<%
String sql = "";
String changeSelectJSStr = "";
String changeSelectOptionStr = "$(selectfield).append(new Option('',''));\n";
String multiselect=" = "+selectvalue;
int cx_tmp = 1;

if(multiselectflag.equals("1")){
	if(!"".equals(multiselectvalue)){
		multiselect = " in ("+multiselectvalue+") ";
	}
}
if(childfieldidconditionTransition==1){
	changeSelectOptionStr="";
	cx_tmp = 0;
}
String selectSql="";

if(isSearch==1&&(!"-1".equals(selectvalue+"")||!"".equals(multiselectvalue))){
	selectSql=" and selectvalue "+multiselect;
}
sql = "select childitemid from workflow_selectitem where fieldid="+fieldid+" and isbill="+isbill+selectSql;

rs.execute(sql);
while(rs.next()){
	String childitemid = Util.null2String(rs.getString("childitemid"));
	if(!"".equals(childitemid.trim())){
		if(!"".equals(childitemid)){
			if(childitemid.indexOf(",")==0){
				childitemid = childitemid.substring(1);
			}
			if(childitemid.endsWith(",")){
				childitemid = childitemid.substring(0, childitemid.length()-1);
			}
			
			sql = "select id, selectvalue, selectname, listorder from workflow_selectitem where fieldid="+childfieldid+" and isbill="+isbill+" and selectvalue in ("+childitemid+")  and ( cancel!=1 or cancel is null) order by listorder, id asc";

			rs_item.execute(sql);
			while(rs_item.next()){
				String selectvalue_tmp = Util.null2String(rs_item.getString("selectvalue"));
				String selectname_tmp = Util.toScreen(rs_item.getString("selectname"), 7);
				changeSelectJSStr += ("$(selectfield).append(\"<option value='"+selectvalue_tmp+"'>"+selectname_tmp+"</option>\");\n");
				changeSelectOptionStr += ("$(selectfield).append(\"<option value='"+selectvalue_tmp+"'>"+selectname_tmp+"</option>\");\n");
				cx_tmp++;
			}
		}
	}
}
%>
<script type="text/javascript">
function insertSelect_All(){
	//var selectfield = null;
	//var hasSelected = false;
	//var fieldSpan;
	//var viewtype;
	try{
		//selectfield = window.parent.document.getElementById("<%=fieldname%>");
		//viewtype = selectfield.viewtype;
	}catch(e){
		//viewtype = "0";
	}
	//if(viewtype=="undefined" || viewtype==undefined){
		//viewtype = "0";
	//}
	try{
		var attr_sb = $(selectfield).attr("sb");
		if(typeof(attr_sb)!="undefined" && attr_sb != null){
			jQuery(selectfield).empty();
			var selectSbHolderSpan = window.parent.document.getElementById("sbHolderSpan_"+attr_sb);
			var originalWidth  = jQuery(selectSbHolderSpan).width();
			window.parent.jQuery(selectfield).selectbox("detach");
			<%=changeSelectOptionStr%>
			window.parent.jQuery(selectfield).selectbox();
			attr_sb = $(selectfield).attr("sb");
			selectSbHolderSpan = window.parent.document.getElementById("sbHolderSpan_"+attr_sb);
			//jQuery(selectSbHolderSpan).width(originalWidth);
			if(childfieldValue!=null && childfieldValue!=""){
				var findOption = window.parent.jQuery(selectfield).find("option[value="+childfieldValue+"]");
				if(typeof(findOption.attr('value'))!="undefined"){
					window.parent.jQuery(selectfield).selectbox("change",findOption.attr('value'),findOption.html());
				}
			}
			if(<%=pageParams%>==1){
				jQuery(selectSbHolderSpan).click(function(){
					window.parent.setChangelevel(this);
				});
			}
			beautySelect(selectfield);
		}else{
			parent.jQuery("#<%=fieldname%>").get(0).options.length = 0;
			<%if(childfieldidconditionTransition!=1){%>
				parent.jQuery("#<%=fieldname%>").append("<option></option>");
			<%}%>
			<%=changeSelectJSStr%>
			
			if(childfieldValue!=null && childfieldValue!=""){
				try{
					//fieldSpan = window.parent.document.getElementById("<%=fieldname%>span");
					for(var i=selectfield.length-1; i>=0; i--){
						if (selectfield.options[i] != null){
							var value_tmp = selectfield.options[i].value;
							if(value_tmp==childfieldValue){
								//alert("111 >>>"+value_tmp);
								selectfield.options[i].selected = true;
								//hasSelected = true;
								//fieldSpan.innerHTML = "";
								break;
							}
						}
					}
				}catch(e){}
			}
		}
	}catch(e){}
	//选择项触发onchange事件
	var selectObj = parent.jQuery("#<%=fieldname%>");
	var onchangeStr = selectObj.attr('onchange');
	if(onchangeStr&&onchangeStr!=""){
		var selObj = selectObj.get(0);
		if (selObj.fireEvent){
			selObj.fireEvent('onchange');
		}else{
			selObj.onchange();
		}
	}
	<%if(childfieldidconditionTransition==1){%>
		//parent.refreshMultiSelect("con<%=fieldid%>_value");
		parent.nextSelectRefreshMultiSelect("con<%=childfieldid%>_value");
	<%}%>
	//if(hasSelected==false && viewtype=="1"){
		//try{
			//fieldSpan = window.parent.document.getElementById("<%=fieldname%>span");
			//fieldSpan.innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
		//}catch(e){}
	//}
}
if(selectfield != null){
	insertSelect_All();
}
</script>
