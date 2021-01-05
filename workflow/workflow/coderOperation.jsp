
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
	boolean canEdit=true;
	int wfid = Util.getIntValue(request.getParameter("wfid"),-1);
	if(!HrmUserVarify.checkUserRight("FLOWCODE:All", user) && !HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
	    return;
	}

 
  String wfcode=  Util.null2String(request.getParameter("wfcode"));
  if(!"".equals(wfcode)){
	  rs.executeSql("update workflow_nodelink set isbulidcode = '0' where workflowid = "+wfid+"");
	  rs.executeSql("update workflow_nodelink set isbulidcode = '1' where id in ("+wfcode+")");
  }

  String formid=  Util.null2String(request.getParameter("formid"));
  String isBill=  Util.null2String(request.getParameter("isBill"));
  String selectField=  Util.null2String(request.getParameter("selectField"));
  String wfconcrete=  Util.null2String(request.getParameter("wfconcrete"));
  String wfcodevalue=  Util.null2String(request.getParameter("wfcodevalue"));
  if(selectField.equals("")){
	  selectField="-1";
  }
  String postValue=  Util.null2String(request.getParameter("postValue"));
  String fieldSequenceAlone=  Util.null2String(request.getParameter("fieldSequenceAlone"));
  int selectCorrespondField =  Util.getIntValue(Util.null2String(request.getParameter("sltCorrespondField")));
  String workflowSeqAlone=  Util.null2String(request.getParameter("workflowSeqAlone"));
  String dateSeqAlone=  Util.null2String(request.getParameter("dateSeqAlone"));
  String dateSeqSelect=  Util.null2String(request.getParameter("dateSeqselect"));
  String struSeqAlone=  Util.null2String(request.getParameter("struSeqAlone"));
  String struSeqSelect=  Util.null2String(request.getParameter("struSeqselect"));
  String correspondField=  Util.null2String(request.getParameter("struCorrespondField"));
  String correspondDate=  Util.null2String(request.getParameter("dateCorrespondField"));
  
  
  if(struSeqAlone.equals("1")){
	  if(struSeqSelect.equals("")){
		  struSeqSelect="1";
	  }
  }
  
  int txtUserUse=  Util.getIntValue(request.getParameter("txtUserUse"),0);

if("1".equals(workflowSeqAlone)){

    rs.executeSql("select * from  workflow_code  where flowId="+wfid);
    if (rs.next()){
        rs.executeSql("update  workflow_code  set codeFieldId="+selectField+",isUse='"+txtUserUse+"',fieldSequenceAlone='"+fieldSequenceAlone+"',workflowSeqAlone='"+workflowSeqAlone+"',dateSeqAlone='"+dateSeqAlone+"',dateSeqSelect='"+dateSeqSelect+"',struSeqAlone='"+struSeqAlone+"',struSeqSelect='"+struSeqSelect+"',correspondField='"+correspondField+"',correspondDate='"+correspondDate+"', selectCorrespondField=" + selectCorrespondField + " where flowId="+wfid);
    }else{
		rs.executeSql("insert into  workflow_code (formId,flowId,isUse,codeFieldId,isBill,fieldSequenceAlone,workflowSeqAlone,dateSeqAlone,dateSeqSelect,struSeqAlone,struSeqSelect,correspondField,correspondDate, selectCorrespondField) values(-1,"+wfid+",'"+txtUserUse+"',"+selectField+",'0','"+fieldSequenceAlone+"','"+workflowSeqAlone+"','"+dateSeqAlone+"','"+dateSeqSelect+"','"+struSeqAlone+"','"+struSeqSelect+"','"+correspondField+"','"+correspondDate+"', " + selectCorrespondField + ")");
    }

    rs.executeSql("delete workflow_codeRegulate where workflowId="+wfid);
    String[] members = Util.TokenizerString2(postValue,"\u0007");
    for (int i=0;i<members.length;i++){
      String member = members[i];
      String memberAttibutes[] = Util.TokenizerString2(member,"\u001b");
      String text = memberAttibutes[0];
      String value = memberAttibutes[1];
      if ("[(*_*)]".equals(value)){value="";}
      String codeSelect = memberAttibutes[2];
      if ("[(*_*)]".equals(codeSelect)){codeSelect="0";}
      String concrete =  memberAttibutes[3];
      String type = memberAttibutes[4];
      String insertStr = "insert into workflow_codeRegulate (formid,showId,showType,codeValue,codeOrder,isBill,workflowId,concreteField,enablecode) values (-1,"+text+",'"+type+"','"+value+"',"+i+",'0',"+wfid+",'"+concrete+"','"+codeSelect+"')";	  
      rs.executeSql(insertStr);          
    }
}else{
	rs.executeSql("update workflow_Code set workflowSeqAlone='0' where flowId="+wfid);
    //rs.executeSql("select * from  workflow_code  where formId="+formid);
    rs.executeSql("select * from workflow_code where formId="+formid+" and isBill='"+isBill+"'");
    if (rs.next())
    {
    	String currentcode = rs.getString("currentcode");
    	if(!currentcode.equals("") && currentcode != null){
    		rs1.executeSql("select * from workflow_codeRegulate where formId="+formid+" and isBill='"+isBill+"' and concreteField = '8'");
    		String flowwater = "";
    		if(rs1.next()){
    			flowwater = rs1.getString("codevalue");
				String flowCode="1"+(currentcode.substring(currentcode.length()-Util.getIntValue(flowwater)));
				flowCode=String.valueOf(Util.getIntValue(flowCode)+1);
				flowCode=flowCode.substring(1);
				rs2.executeSql("select * from workflow_codeSeq where formId="+formid+" and isBill='"+isBill+"'");
				if(rs2.next()){
					rs2.executeSql("update workflow_codeSeq set sequenceid="+flowCode+" where formId="+formid+" and isBill='"+isBill+"'");
				}else{
					rs2.executeSql("insert into workflow_codeSeq (departmentId,yearId,sequenceid,formId,isBill,workflowid,monthId,dateId,fieldId,fieldvalue,supSubCompanyId,subCompanyId) values(-1,-1,"+flowCode+","+formid+","+isBill+",-1,-1,-1,-1,-1,-1,-1)");
				}
    		}
    	}
     //rs.executeSql("update  workflow_code  set codeFieldId="+selectField+",isUse='"+txtUserUse+"' where formId="+formid);
     //rs.executeSql("update  workflow_code  set codeFieldId="+selectField+",isUse='"+txtUserUse+"' where formId="+formid+" and isBill='"+isBill+"'");
     rs.executeSql("update  workflow_code  set codeFieldId="+selectField+",isUse='"+txtUserUse+"',currentcode = null ,fieldSequenceAlone='"+fieldSequenceAlone+"',workflowSeqAlone='0',dateSeqAlone='"+dateSeqAlone+"',dateSeqSelect='"+dateSeqSelect+"',struSeqAlone='"+struSeqAlone+"',struSeqSelect='"+struSeqSelect+"',correspondField='"+correspondField+"',correspondDate='"+correspondDate+"', selectCorrespondField=" + selectCorrespondField + " where formId="+formid+" and isBill='"+isBill+"'");
    }
    else
    {
    //rs.executeSql("insert into  workflow_code (formId,flowId,isUse,codeFieldId) values("+formid+","+wfid+",'"+txtUserUse+"',"+selectField+")");
    //rs.executeSql("insert into  workflow_code (formId,flowId,isUse,codeFieldId,isBill) values("+formid+","+wfid+",'"+txtUserUse+"',"+selectField+",'"+isBill+"')");
    rs.executeSql("insert into  workflow_code (formId,flowId,isUse,currentcode,codeFieldId,isBill,fieldSequenceAlone,workflowSeqAlone,dateSeqAlone,dateSeqSelect,struSeqAlone,struSeqSelect,correspondField,correspondDate, selectCorrespondField) values("+formid+",-1,'"+txtUserUse+"',null,"+selectField+",'"+isBill+"','"+fieldSequenceAlone+"','0','"+dateSeqAlone+"','"+dateSeqSelect+"','"+struSeqAlone+"','"+struSeqSelect+"','"+correspondField+"','"+correspondDate+"', " + selectCorrespondField + ")");
    }

    //rs.executeSql("delete workflow_codeDetail where mainId="+formid);
    rs.executeSql("delete workflow_codeRegulate where formid="+formid+" and isBill='"+isBill+"'");
    String[] members = Util.TokenizerString2(postValue,"\u0007");
    for (int i=0;i<members.length;i++){
      String member = members[i];
      String memberAttibutes[] = Util.TokenizerString2(member,"\u001b");
      String text = memberAttibutes[0];
      String value = memberAttibutes[1];
      if ("[(*_*)]".equals(value)){value="";}
      String codeSelect = memberAttibutes[2];
      if ("[(*_*)]".equals(codeSelect)){codeSelect="";}
      String concrete =  memberAttibutes[3];
      String type = memberAttibutes[4];
      //int iformId = Integer.parseInt(formid);
      String insertStr = "insert into workflow_codeRegulate (formid,showId,showType,codeValue,codeOrder,isBill,workflowId,concreteField,enablecode) values ("+formid+","+text+",'"+type+"','"+value+"',"+i+",'"+isBill+"',-1,'"+concrete+"','"+codeSelect+"')";	  
      rs.executeSql(insertStr);
    }
}
%>
<script language="javascript">
<%if(wfconcrete.equals("0")){%>
window.parent.shortNameSetting("<%=wfid%>","<%=formid%>","<%=isBill%>","<%=wfcodevalue%>");
<%}else if(wfconcrete.equals("1")){%>
window.parent.deptAbbr("<%=wfid%>","<%=formid%>","<%=isBill%>","<%=wfcodevalue%>");
<%}else if(wfconcrete.equals("2")){%>
window.parent.subComAbbr("<%=wfid%>","<%=formid%>","<%=isBill%>","<%=wfcodevalue%>");
<%}else if(wfconcrete.equals("3")){%>
window.parent.supSubComAbbr("<%=wfid%>","<%=formid%>","<%=isBill%>","<%=wfcodevalue%>");
<%}else if(wfconcrete.equals("100")){%>
window.parent.codeSeqSet("<%=wfid%>","<%=formid%>","<%=isBill%>");
<%}else if(wfconcrete.equals("101")){%>
<% if(dateSeqAlone.equals("1") || fieldSequenceAlone.equals("1") || struSeqAlone.equals("1")){%>
window.parent.codeSeqReservedSet("<%=wfid%>","<%=formid%>","<%=isBill%>");
<%}else{%>
window.parent.codeSeqReservedSetForDigit("<%=wfid%>","<%=formid%>","<%=isBill%>");
<%}%>
<%}else{
	response.sendRedirect("WFCode.jsp?ajax=1&wfid="+wfid);
}%>
</script>WFCodeReservedForDigit.jsp

