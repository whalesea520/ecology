
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
int childvalue = Util.getIntValue(request.getParameter("childvalue"), -1);
int isdetail = Util.getIntValue(request.getParameter("isdetail"), 0);
int rowindex = Util.getIntValue(request.getParameter("rowindex"), 0);
int pageParams = Util.getIntValue(request.getParameter("pageParams"),0);
int isinit = Util.getIntValue(request.getParameter("isinit"),0);
String fieldname = "";
if(isdetail == 0){
	fieldname = "con"+childfieldid+"_value";
}else{
	fieldname = "con"+childfieldid+"_"+rowindex+"_value";
}
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
		if(elements.length==null){
			selectfield = elements;
		}else{
			for(var i=0; i<elements.length; i++) {
				try{
					if(elements[i].tagName=="SELECT"){
						selectfield = elements[i];
						break;
					}
				}catch(e){}
			}
		}
	}catch(e){}
}
function onChangeSelectField_All(){
	try{
		var selectfield = window.parent.document.getElementById("<%=fieldname%>");
		if(selectfield != null){
			for(var i = selectfield.length-1; i>0; i--) {
				if (selectfield.options[i] != null){
					selectfield.options[i] = null;
				}
			}
			selectfield.options[0] = new Option("", "");
		}
	}catch(e){}
}
getSelectField();
if(selectfield != null){
	onChangeSelectField_All();
}
</script>
<%
String sql = "";
String changeSelectJSStr = "";
String changeSelectOptionStr = "$(selectfield).append(new Option('',''));\n";
sql = "select id,name from mode_selectitempagedetail where pid='"+selectvalue+"'  and (cancel=0 or cancel is null)  order by disorder asc,id asc";
rs.executeSql(sql);
int cx_tmp = 1;
while(rs.next()){
	String selectvalue_tmp = Util.null2String(rs.getString("id"));
	String selectname_tmp = Util.null2String(rs.getString("name"));
	changeSelectJSStr += ("selectfield.options["+cx_tmp+"] = new Option(\""+selectname_tmp+"\", \""+selectvalue_tmp+"\");\n");
	changeSelectOptionStr += ("$(selectfield).append(new Option(\""+selectname_tmp+"\", \""+selectvalue_tmp+"\"));\n");
	cx_tmp++;
}
%>
<script type="text/javascript">
function insertSelect_All(){
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
			jQuery(selectSbHolderSpan).width(originalWidth);
			if(childfieldValue!=null && childfieldValue!=""){
				var findOption = window.parent.jQuery(selectfield).find("option[value="+childfieldValue+"]");
				if(typeof(findOption.attr('value'))!="undefined"){
				//	window.parent.jQuery(selectfield).selectbox("change",findOption.attr('value'),findOption.html());
				}
			}
			if(<%=pageParams%>==1){
				jQuery(selectSbHolderSpan).click(function(){
					window.parent.setChangelevel(this);
				});
			}
		}else{
			selectfield.options[0] = new Option("", "");
			<%=changeSelectJSStr%>
			if(childfieldValue!=null && childfieldValue!=""){
				try{
					for(var i=selectfield.length-1; i>=0; i--){
						if (selectfield.options[i] != null){
							var value_tmp = selectfield.options[i].value;
							if(value_tmp==childfieldValue){
								selectfield.options[i].selected = true;
								break;
							}
						}
					}
				}catch(e){}
			}
		}
		
		//---触发下一级联动
		var childfieldid = <%=childfieldid%>;
		var childsel = jQuery(selectfield).attr("childsel");
		var childSelObj = parent.jQuery("#<%=fieldname%>");
		//-----------初始值------------
		if(<%=isinit==1%>){
			if(childSelObj.length>0&&childSelObj.val()==""){
				var initvalue = childSelObj.attr("initvalue");
				if(initvalue!=""){
					var selobj = childSelObj.get(0);
					for(var i=0;i<selobj.options.length;i++){
						var value_tmp = selobj.options[i].value;
						if(initvalue==value_tmp){
							selectfield.options[i].selected = true;
							flag = true;
							break;
						}
					}
				}
			}
		}
		
		//公共选择项触发onchange事件
		var selectObj = childSelObj;
		var onchangeStr = selectObj.attr('onchange');
		if(onchangeStr&&onchangeStr!=""){
			var selObj = selectObj.get(0);
			if (selObj.fireEvent){
				selObj.fireEvent('onchange');
			}else{
				selObj.onchange();
			}
		}
		
		<%if(isinit==1){%>
			if(childsel&&childsel>0){
				if(typeof(parent.changeChildSelectItemField)=="function"){
					parent.changeChildSelectItemField(0,childfieldid,childsel,1);
				}
			}
		<%}%>
		
	}catch(e){}

}
if(selectfield != null){
	insertSelect_All();
}
</script>
