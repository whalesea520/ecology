<%
    String returnvalues="";
    int wfid=weaver.general.Util.getIntValue(request.getParameter("workflowid"));
    int formid = weaver.general.Util.getIntValue(request.getParameter("formid"),0);
    int isbill = weaver.general.Util.getIntValue(request.getParameter("isbill"),0);
    int languageid=weaver.general.Util.getIntValue(request.getParameter("languageid"),7);
    int nodeid=weaver.general.Util.getIntValue(request.getParameter("nodeid"));
    String fieldid=weaver.general.Util.null2String(request.getParameter("fieldid"));
    String option=weaver.general.Util.null2String(request.getParameter("option"));
    weaver.workflow.workflow.WfLinkageInfo wfli=new weaver.workflow.workflow.WfLinkageInfo();
    wfli.setFormid(formid);
    wfli.setIsbill(isbill);
    wfli.setWorkflowid(wfid);
    wfli.setLangurageid(languageid);
    if(option.equals("selfield")){
        java.util.ArrayList[] selectfields=wfli.getSelectFieldByEdit(nodeid);
        returnvalues = "$";
        for(int i=0;i<selectfields[0].size();i++){
            if(returnvalues.equals("")) returnvalues=selectfields[0].get(i)+"_"+selectfields[2].get(i)+"$"+selectfields[1].get(i);
            else returnvalues+=","+selectfields[0].get(i)+"_"+selectfields[2].get(i)+"$"+selectfields[1].get(i);
        }
    }
    if(option.equals("selfieldvalue")&&fieldid.indexOf("_")>-1){
        java.util.ArrayList[] selectfieldvalues=wfli.getSelectFieldItem(weaver.general.Util.getIntValue(fieldid.substring(0,fieldid.indexOf("_"))));
        returnvalues = "_$";
        for(int i=0;i<selectfieldvalues[0].size();i++){
            if(returnvalues.equals("")) returnvalues=selectfieldvalues[0].get(i)+"$"+selectfieldvalues[1].get(i);
            else returnvalues+=","+selectfieldvalues[0].get(i)+"$"+selectfieldvalues[1].get(i);
        }
    }
    response.setContentType("text/text;charset=UTF-8");//返回的是txt文本文件
    out.print(returnvalues);
%>