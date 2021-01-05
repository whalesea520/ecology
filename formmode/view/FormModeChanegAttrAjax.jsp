<%
    String returnvalues="";
    int modeId=weaver.general.Util.getIntValue(request.getParameter("modeId"));
    int type=weaver.general.Util.getIntValue(request.getParameter("type"));
    String fieldid=weaver.general.Util.null2String(request.getParameter("fieldid"));
    String fieldvalue=weaver.general.Util.null2String(request.getParameter("fieldvalue"));
    if(fieldvalue.equals("")) fieldvalue=" ";
    weaver.formmode.setup.ModeLinkageInfo modeLinkageInfo = new weaver.formmode.setup.ModeLinkageInfo();
    returnvalues=modeLinkageInfo.getChangeFieldByselectvalue(modeId,type,fieldid,fieldvalue);
    response.setContentType("text/text;charset=UTF-8");//返回的是txt文本文件
    out.print(returnvalues);
%>