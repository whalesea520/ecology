
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.BaseBean" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CapitalModifyFieldComInfo" class="weaver.cpt.capital.CapitalModifyFieldComInfo" scope="page"/>
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 java.util.List,
                 weaver.docs.docs.FieldParam,
                 java.util.ArrayList"%>

<%
String whickField = Util.null2String(request.getParameter("whickField"));
if(whickField.length() >0)
{
	String scope = "";
	int scopeid = 0;
	if(whickField.equals("c1"))
	{
		scope = "CrmCustomFieldByInfoType";
		scopeid = 84;
	}else if(whickField.equals("c2"))
	{
		scope = "CrmContacterFieldByInfoType";
		scopeid = 85;
	}else if(whickField.equals("c3"))
	{
		scope = "CrmAddressFieldByInfoType";
		scopeid = 86;
	}
		
	String[] fieldlable = request.getParameterValues("fieldlable");
	String[] fieldid = request.getParameterValues("fieldid");
	String[] fieldhtmltype = request.getParameterValues("fieldhtmltype");
	String[] type = request.getParameterValues("type");
	String[] flength = request.getParameterValues("flength");
	String[] isuse = request.getParameterValues("isuse");
	String[] ismand = request.getParameterValues("ismand");
	String[] filedOrder = request.getParameterValues("filedOrder");
	String[] selectitemid = request.getParameterValues("selectitemid");
	String[] selectitemvalue = request.getParameterValues("selectitemvalue");
	
	//基本信息需要保存老字段
	String[] ffnames = request.getParameterValues("ffname");
	String[] fflabels = request.getParameterValues("fflabel");
	String[] ffuses =  request.getParameterValues("ffuse");
	int whereid = 28;
	if(ffnames!=null)
	{
		for(int i=0;i<ffnames.length;i++)
		{
			
			if(i>1)break;
			String ffname = ffnames[i];
			String fflabel = fflabels[i];
			String ffuse = ffuses[i];
			whereid = 28;
			if(ffname.indexOf("dff") != -1 || ffname.indexOf("nff") != -1 || ffname.indexOf("tff") != -1 || ffname.indexOf("bff") != -1){
				if (ffname.indexOf("dff") != -1) whereid +=0;
				if (ffname.indexOf("nff") != -1) whereid +=5;
				if (ffname.indexOf("tff") != -1) whereid +=10;
				if (ffname.indexOf("bff") != -1) whereid +=15;
				whereid = whereid + (Util.getIntValue(ffname.substring(3,5),0) - 1);
			}else if(ffname.indexOf("docff") != -1 || ffname.indexOf("depff") != -1 || ffname.indexOf("crmff") != -1 || ffname.indexOf("reqff") != -1){
				if (ffname.indexOf("docff") != -1) whereid +=28;
				if (ffname.indexOf("depff") != -1) whereid +=33;
				if (ffname.indexOf("crmff") != -1) whereid +=38;
				if (ffname.indexOf("reqff") != -1) whereid +=43;
				whereid = whereid + (Util.getIntValue(ffname.substring(5,7),0) - 1);	
			}
		
			RecordSet.executeSql("update CptCapitalModifyField set name = '" + fflabel + "' where field = " + whereid);
		
			CapitalModifyFieldComInfo.removeCapitalModifyFieldCache();
			RecordSet.executeSql("update Base_FreeField set "+ffname+"name='"+fflabel+"',"+ffname+"use="+ffuse+" where tablename='"+whickField+"'");
		}
	}
	
	CustomFieldManager cfm = new CustomFieldManager(scope,scopeid);
	List delFields = cfm.getAllFields2();
	FieldParam fp = new FieldParam();
	
	if(fieldlable!=null&&fieldid!=null&&fieldhtmltype!=null&&type!=null&&ismand!=null&&flength!=null){
	    int selectIndex = 0;
	    for(int i=0; i<fieldlable.length ; i++){
	        if(type[i].equals("")){
	            type[i] = "0";
	        }
	        delFields.remove(fieldid[i]);
	        if(fieldhtmltype[i].equals("1")){
	            fp.setSimpleText(Util.getIntValue(type[i],-1),flength[i]);
	        }else if(fieldhtmltype[i].equals("2")){
	            fp.setText();
	        }else if(fieldhtmltype[i].equals("3")){
	            fp.setBrowser(Util.getIntValue(type[i],-1));
	        }else if(fieldhtmltype[i].equals("4")){
	            fp.setCheck();
	        }else if(fieldhtmltype[i].equals("5")){
	            fp.setSelect();
	        }else if(fieldhtmltype[i].equals("6")){
	          	fp.setAttach();
	      	}else{
	            continue;
	        }
	        if(Util.null2String(filedOrder[i]).length()==0)filedOrder[i]="0";
	        int temId = cfm.checkField(Util.getIntValue(fieldid[i]),fieldlable[i],fp.getFielddbtype(),fp.getFieldhtmltype(),type[i],isuse[i],ismand[i],filedOrder[i]);
	        if(fieldhtmltype[i].equals("5")&&temId != -1){
	            ArrayList temItemValue = new ArrayList();
	            ArrayList temItemName = new ArrayList();
	            for(;selectIndex<selectitemid.length;selectIndex++){
	                if(selectitemid[selectIndex].equals("--")){
	                    selectIndex++;
	                    break;
	                }
	                temItemValue.add(selectitemid[selectIndex]);
	                temItemName.add(selectitemvalue[selectIndex]);
	            }
	            cfm.checkSelectField(temId, temItemValue, temItemName);
	        }
	    }
	}
	cfm.deleteFields(delFields);
}
if(whickField.equals("c1"))
	response.sendRedirect("ListCustomerFreeFieldInner.jsp");
else if(whickField.equals("c2"))
	response.sendRedirect("ListContacterFreeFieldInner.jsp");
else if(whickField.equals("c3"))
	response.sendRedirect("ListAddressFreeFieldInner.jsp");
return;

%>