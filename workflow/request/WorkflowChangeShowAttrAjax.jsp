<%
    String returnvalues="";
    int wfid=weaver.general.Util.getIntValue(request.getParameter("workflowid"));
    int nodeid=weaver.general.Util.getIntValue(request.getParameter("nodeid"));
    String fieldid=weaver.general.Util.null2String(request.getParameter("fieldid"));
    String fieldvalue=weaver.general.Util.null2String(request.getParameter("fieldvalue"));
    if(fieldvalue.equals("")) fieldvalue=" ";
    weaver.workflow.workflow.WfLinkageInfo wfli=new weaver.workflow.workflow.WfLinkageInfo();
	String aaa = fieldvalue;
	String bbb = "";
	String ccc = "";
	int hh = 0;
	while(aaa.indexOf(",")>=0){
		bbb = aaa.substring(0,aaa.indexOf(","));
		if(hh==0 && bbb.equals("")){
			//ccc += ",";
		}else{
			if(bbb.equals("")){
			  ccc += ",-1";
			}else{
			  ccc += ","+bbb;
			} 
		}
			aaa = aaa.substring(aaa.indexOf(",")+1);
			hh++;
	}
	if(aaa.equals("")){
		fieldvalue = ccc;
	}else{
		fieldvalue = ccc+","+aaa;
	}
    returnvalues=wfli.getChangeFieldByselectvalue(wfid,nodeid,fieldid,fieldvalue);
    response.setContentType("text/text;charset=UTF-8");//返回的是txt文本文件
    out.print(returnvalues);
%>