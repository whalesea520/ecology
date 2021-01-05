
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_item" class="weaver.conn.RecordSet" scope="page" />
<%
String fieldid = Util.null2String(request.getParameter("fieldid"));
String childfield = Util.null2String(request.getParameter("childfield"));
int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
int selectvalue = Util.getIntValue(request.getParameter("selectvalue"), -1);
int rownum = Util.getIntValue(request.getParameter("rownum"), -1);
int childFieldValue = Util.getIntValue(request.getParameter("childfieldValue"), -1);
int ismanager = Util.getIntValue(request.getParameter("ismanager"), 0);//这个参数现在应该没用了，当初怎么用上的我也记不清了
int init = Util.getIntValue(request.getParameter("init"), 0);
String fieldname = "";
int isdetail = 0;
int groupid = 0;
int childfieldid = 0;
int index = childfield.indexOf("_");
String childfieldtmpid = "";
if(index > -1){
	isdetail = 1;
	childfieldid = Util.getIntValue(childfield.substring(0, index), 0);
	groupid = Util.getIntValue(childfield.substring(index+1, childfield.length()));
	childfieldtmpid = "" + childfieldid + "_" + rownum;
}else{
	childfieldid = Util.getIntValue(childfield, 0);
	childfieldtmpid = childfield;
}

//System.out.println("fieldid = " + fieldid);
//System.out.println("childfieldid = " + childfieldid);
//System.out.println("groupid = " + groupid);
%>
<script type="text/javascript">
var childFieldValue = "<%=childFieldValue%>";

function doInit(){
	try{
		var wcell = window.parent.document.all("ChinaExcel");
		<%if(isdetail==0){%>
		var nrowChild = wcell.GetCellUserStringValueRow("field<%=childfield%>_1_5");
		var ncolChild = wcell.GetCellUserStringValueCol("field<%=childfield%>_1_5");
		<%}else{
			//if(ismanager==0){
		%>
				//var selcol = wcell.GetCellUserStringValueCol("detail<%=groupid%>_sel");
			<%//}else{%>
		var selcol = window.parent.rowgroup[<%=groupid%>];
			<%//}//end if(ismanager==0)%>
		var nrowChild = wcell.GetCellUserStringValueRow("field<%=childfieldid%>_0_1_5");
		nrowChild = nrowChild + <%=rownum+1%>*selcol;
		var ncolChild = wcell.GetCellUserStringValueCol("field<%=childfieldid%>_0_1_5");
		<%}%>
		if(childFieldValue=="-1"){
			try{
				childFieldValue = wcell.GetCellComboSelectedActualValue(nrowChild,ncolChild);
			}catch(e){
				childFieldValue = "";
			}
		}
		var ismand=wcell.GetCellUserValue(nrowChild,ncolChild);
		if(ismand>=1 || <%=init%>==1){
			wcell.SetCellComboType1(nrowChild, ncolChild, false, true, false, ";;", ";;");
			wcell.SetCellVal(nrowChild, ncolChild, "");
		}
	}catch(e){}
	if(childFieldValue==null || childFieldValue=="-1"){
		childFieldValue = "";
	}
}
doInit();
</script>
<%
String comboStr = "";
String selValue = "";
String sql = "";
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
			sql = "select id, selectvalue, selectname, listorder from workflow_selectitem where fieldid="+childfieldid+" and isbill="+isbill+" and selectvalue in ("+childitemid+")  and ( cancel!=1 or cancel is null) order by listorder, id asc";
			rs_item.execute(sql);
			while(rs_item.next()){
				String selectvalue_tmp = Util.null2String(rs_item.getString("selectvalue"));
				String selectname_tmp = Util.toScreen(rs_item.getString("selectname"), 7);
				comboStr += ";"+selectname_tmp;
				selValue += ";"+selectvalue_tmp;
			}
		}
	}
}
if("".equals(comboStr)){
	comboStr = ";;";
	selValue = ";;";
}
%>
<script type="text/javascript">
function insertSelect_All(){
	try{
		var wcell = window.parent.document.all("ChinaExcel");
		<%if(isdetail==0){ %>
		var nrowChild = wcell.GetCellUserStringValueRow("field<%=childfield%>_1_5");
		var ncolChild = wcell.GetCellUserStringValueCol("field<%=childfield%>_1_5");
		<%}else{
			//if(ismanager==0){
		%>
				//var selcol = wcell.GetCellUserStringValueCol("detail<%=groupid%>_sel");
			<%//}else{%>
			var selcol = window.parent.rowgroup[<%=groupid%>];
			<%//}//end if(ismanager==0)%>
		var nrowChild = wcell.GetCellUserStringValueRow("field<%=childfieldid%>_0_1_5");

		<%if(rownum > -1){%>
			nrowChild = nrowChild + <%=rownum+1%>*selcol;
		<%}else{%>
			nrowChild = nrowChild;
		<%}//end if(rownum > -1) else%>

		var ncolChild = wcell.GetCellUserStringValueCol("field<%=childfieldid%>_0_1_5");
		<%}//end if(isdetail==0) else%>
		
		var ismand=wcell.GetCellUserValue(nrowChild,ncolChild);
		
		window.parent.$G("field<%=childfieldtmpid%>").value="";

		if(ismand>=1 || <%=init%>==1){
			wcell.SetCellComboType1(nrowChild, ncolChild, false, true, false, "<%=comboStr%>", "<%=selValue%>");
			var hasSet = false;
			var selectname = "";
			if(childFieldValue!="" && childFieldValue!="-1"){
				var comboStr = "<%=comboStr%>";
				var valueStr = "<%=selValue%>";
				if(comboStr!="" && valueStr!=""){
					var selNames = comboStr.split(";");
					var selValues = valueStr.split(";");
					for(var i=0; i<selValues.length; i++){
						if(selValues[i]==childFieldValue && childFieldValue!=""){
							selectname = selNames[i];
							wcell.SetCellVal(nrowChild,ncolChild,selectname); 
							$GetEle("field<%=childfieldtmpid%>",window.parent.document).value=childFieldValue;
							hasSet = true;
							break;
						}
					}
				}
			}
			if(hasSet == false){
				wcell.SetCellVal(nrowChild, ncolChild, "");
				var usershowtype = wcell.GetCellUserValue(nrowChild,ncolChild);
				//alert(usershowtype);
				if(usershowtype==2){
					wcell.ReadHttpImageFile("/images/BacoError_wev8.gif",nrowChild,ncolChild,true,true);
				}else{
					wcell.DeleteCellImage(nrowChild,ncolChild,nrowChild,ncolChild);
				}
			}else{
				wcell.DeleteCellImage(nrowChild,ncolChild,nrowChild,ncolChild);
			}
		}
	}catch(e){}
	try{
		wcell.RefreshViewSize();
	}catch(e){}
}
insertSelect_All();

function $GetEle(identity, _document) {
	var rtnEle = null;
	if (_document == undefined || _document == null) _document = document;
	
	rtnEle = _document.getElementById(identity);
	if (rtnEle == undefined || rtnEle == null) {
		rtnEle = _document.getElementsByName(identity);
		if (rtnEle.length > 0) rtnEle = rtnEle[0];
		else rtnEle = null;
	}
	return rtnEle;
}
</script>
