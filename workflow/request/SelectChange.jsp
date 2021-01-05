
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
int selectedfieldid = Util.getIntValue(request.getParameter("selectedfieldid"), 0);
int uploadType = Util.getIntValue(request.getParameter("uploadType"), 0);
int selectvalue = Util.getIntValue(request.getParameter("selectvalue"), -1);
int childvalue = Util.getIntValue(request.getParameter("childvalue"), -1);
int isdetail = Util.getIntValue(request.getParameter("isdetail"), 0);
int rowindex = Util.getIntValue(request.getParameter("rowindex"), 0);
int ismobile =  Util.getIntValue(request.getParameter("ismobile"), 0);
String fieldname = "";
if(isdetail == 0){
	fieldname = "field"+childfieldid;
}else{
	fieldname = "field"+childfieldid+"_"+rowindex;
}
//System.out.println("fieldid = " + fieldid);
%>
<script type="text/javascript">
var childfieldValue = "<%=childvalue%>";
if(childfieldValue=="-1"){
	try{
		if (window.parent.$G) {
			childfieldValue = window.parent.$G("<%=fieldname%>").value;
		} else {
			childfieldValue = window.parent.document.getElementById("<%=fieldname%>").value;
		}
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
			parent.jQuery("#<%=fieldname%>").append("<option></option>");
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
sql = "select childitemid from workflow_selectitem where fieldid="+fieldid+" and isbill="+isbill+" and selectvalue="+selectvalue;
rs.execute(sql);
if(rs.next()){
	String childitemid = Util.null2String(rs.getString("childitemid"));
	if(!"".equals(childitemid.trim())){
		if(!"".equals(childitemid)){
			if(childitemid.indexOf(",")==0){
				childitemid = childitemid.substring(1);
			}
			if(childitemid.endsWith(",")){
				childitemid = childitemid.substring(0, childitemid.length()-1);
			}
			int cx_tmp = 1;
			//sql = "select id, selectvalue, selectname, listorder from workflow_selectitem where fieldid="+childfieldid+" and isbill="+isbill+" and selectvalue in ("+childitemid+") and ( cancel!=1 or cancel is null) order by listorder, id asc";
			sql = "select id, isdefault,selectvalue, selectname, listorder from workflow_selectitem where fieldid="+childfieldid+" and isbill="+isbill+" and selectvalue in ("+childitemid+") and ( cancel!=1 or cancel is null) order by listorder, id asc";	
			rs_item.execute(sql);
			while(rs_item.next()){
				String isdefault_tmp = Util.null2String(rs_item.getString("isdefault"));
				String selectvalue_tmp = Util.null2String(rs_item.getString("selectvalue"));
				String selectname_tmp = Util.toScreen(rs_item.getString("selectname"), 7);
				if(isdefault_tmp.equals("y")){
					changeSelectJSStr += ("selectfield.options["+cx_tmp+"] = new Option(\""+selectname_tmp+"\", \""+selectvalue_tmp+"\",false,true);\n");
				}else{
					changeSelectJSStr += ("selectfield.options["+cx_tmp+"] = new Option(\""+selectname_tmp+"\", \""+selectvalue_tmp+"\");\n");
				}
				cx_tmp++;
			}
		}
	}
}
%>
<script type="text/javascript">
function insertSelect_All(){
	//var selectfield = null;
	var hasSelected = false;
	var fieldSpan;
	var viewtype;
	try{
		//selectfield = window.parent.document.getElementById("<%=fieldname%>");
		if (window.parent.jQuery) {
			viewtype = window.parent.jQuery(selectfield).attr('viewtype');
		} else {
			viewtype = selectfield.viewtype;
		}
	}catch(e){
		viewtype = "0";
	}
	if(viewtype=="undefined" || viewtype==undefined){
		viewtype = "0";
	}
	try{
		parent.jQuery("#<%=fieldname%>").find("option").remove();
		parent.jQuery("#<%=fieldname%>").append("<option></option>");
		<%=changeSelectJSStr%>
		if(childfieldValue!=null && childfieldValue!=""){
			try{
				if('<%=ismobile%>' == '1'){
					fieldSpan = window.parent.document.getElementById("<%=fieldname%>_span");
				}else{
					fieldSpan = window.parent.document.getElementById("<%=fieldname%>span");
				}
				
				for(var i=selectfield.length-1; i>=0; i--){
					if (selectfield.options[i] != null){
						var value_tmp = selectfield.options[i].value;
						if(value_tmp==childfieldValue){
							selectfield.options[i].selected = true;
                            if('<%=ismobile%>' == '1' && '<%=isdetail %>' == '1'){
							  selectfield.options[i].setAttribute("selected","selected");
						    }
							hasSelected = true;
							fieldSpan.innerHTML = "";
							break;
						}
					}
				}
			}catch(e){}
		}
	}catch(e){}

	if(hasSelected==false && viewtype=="1" && parent.jQuery(window.parent.document.getElementById("<%=fieldname%>")).parent().is(":visible")){
		try{
			if('<%=ismobile%>' == '1'){
			  fieldSpan = window.parent.document.getElementById("<%=fieldname%>_span");
			}else{
			  fieldSpan = window.parent.document.getElementById("<%=fieldname%>span");
			}
			fieldSpan.innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
		}catch(e){}
	}
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
}
if(selectfield != null){
	insertSelect_All();
<%
	if(selectedfieldid==childfieldid&&selectedfieldid>0&&uploadType==1){
%>
	    try{
	        parent.changeMaxUpload('field<%=childfieldid%>');
			parent.reAccesoryChanage();
        }catch(e){
		}
<%
	}
%>
}

if('<%=ismobile%>' == '1' && '<%=isdetail %>' == '1'){
   try{
      var  selecteddetail = window.parent.document.getElementById("<%=fieldname%>");
	  var  selecteddetaild = window.parent.document.getElementById("<%=fieldname%>_d");
	  if(selecteddetaild){
		 selecteddetaild.innerHTML =  selecteddetail.innerHTML;
	  }
	  
	  if(window.parent.document.getElementById("<%=fieldname%>_span")){
		window.parent.document.getElementById("<%=fieldname%>_span_d").innerHTML =   window.parent.document.getElementById("<%=fieldname%>_span").innerHTML;
	  }
	  if(window.parent.document.getElementById("<%=childfieldid%><%=rowindex%>")){
		  var detailShowDivName = window.parent.document.getElementById("<%=childfieldid%><%=rowindex%>").value;
          if(window.parent.document.getElementById(detailShowDivName)){
              window.parent.document.getElementById(detailShowDivName).innerHTML = selecteddetail.options[selecteddetail.selectedIndex].text;
		  }
	  }
   }catch(e){}
}
</script>
