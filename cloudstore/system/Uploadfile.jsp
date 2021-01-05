
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.Map,java.util.HashMap" %>
<%@ page import="weaver.docs.docs.DocUpload" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>

<%

	User user = HrmUserVarify.getUser(request, response);
	if (user == null) return;

    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
    //request.setCharacterEncoding("utf-8");

	
    FileUpload fu = new FileUpload(request, "utf-8");
    int wfId = Util.getIntValue(fu.getParameter("wfId"),0);
    if(0 == wfId){
    	return ;
    }
    int mainId = 0;
    int subId = 0;
    int secId = 0;
    
	WFManager.setWfid(wfId);
	WFManager.getWfInfo();
    String tempcategory = Util.null2String(WFManager.getDocCategory());
    System.out.println("wfId :"+wfId+"   tempcategory :"+tempcategory);
    if("".equals(tempcategory)) return ;
    
    mainId=Util.getIntValue(tempcategory.substring(0,tempcategory.indexOf(',')),0);
  	subId=Util.getIntValue(tempcategory.substring(tempcategory.indexOf(',')+1,tempcategory.lastIndexOf(',')),0);
  	secId=Util.getIntValue(tempcategory.substring(tempcategory.lastIndexOf(',')+1,tempcategory.length()),0);
    user = HrmUserVarify.getUser(request, response);

    if (user == null) return;
    String[] filedata = new String[1];
    filedata[0] = "Filedata";
    int[] returnarry = null;
    returnarry = DocUpload.uploadDocsToImgs(fu, user, filedata,mainId,subId,secId,"","");
    String tempvalue = "";
    if (returnarry != null) {
        for (int i = 0; i < returnarry.length; i++) {
            if (returnarry[i] != -1)
                if (tempvalue.trim().equals(""))
                    tempvalue = String.valueOf(returnarry[i]);
                else
                    tempvalue = tempvalue + "," + String.valueOf(returnarry[i]);
        }
    }
    
    String returnFileid = Util.null2String(fu.getParameter("returnFileid"));
    
        System.out.println("returnFileid is :"+returnFileid);
    if("1".equals(returnFileid)){
        String []values = tempvalue.split(",");
        RecordSet rs = new RecordSet();
        rs.executeSql("select d.id,f.imagefileid from DocDetail d join DocImageFile di on d.id=di.docid join ImageFile f on f.imagefileid=di.imagefileid where d.id in(" + tempvalue + ")");
        Map<String,String> map = new HashMap<String,String>();
        while(rs.next()){
            map.put(rs.getString("id"),rs.getString("imagefileid") + "_" + rs.getString("id"));
        }
        tempvalue = "";
       for(String value : values){
            tempvalue += "," + map.get(value);
        }
       tempvalue = tempvalue.length() > 0 ? tempvalue.substring(1) : tempvalue;
    }
    
    
    out.println(tempvalue);
%>