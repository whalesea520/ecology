
<%@page import="weaver.general.Util"%><%
	out.clear();
    String returnvalues="";
	int languageid = weaver.general.Util.getIntValue(request.getParameter("languageid"),7);
    int modeId=weaver.general.Util.getIntValue(request.getParameter("modeId"));
    int type = weaver.general.Util.getIntValue(request.getParameter("type"),0);
    String fieldId=weaver.general.Util.null2String(request.getParameter("fieldId"));
    String option=weaver.general.Util.null2String(request.getParameter("option"));
    weaver.formmode.setup.ModeLinkageInfo modeLinkageInfo = new weaver.formmode.setup.ModeLinkageInfo();
    modeLinkageInfo.setModeId(modeId);
    modeLinkageInfo.setType(type);
    modeLinkageInfo.init();
    java.util.Map map = null;
    
    if(option.equals("selfield")){ 
    	weaver.hrm.User user = new weaver.hrm.User();
    	user.setLanguage(languageid);
    	modeLinkageInfo.setUser(user);
    	java.util.List selectFields = modeLinkageInfo.getSelectFieldByEdit();
    	for(int i =0;i<selectFields.size();i++){
    		map = (java.util.Map)selectFields.get(i);
    		String fieldid = (String)map.get("fieldid");
    		String fieldname = (String)map.get("fieldname");
    		String isdetail = (String)map.get("isdetail");
    		if(returnvalues.equals(""))
    			returnvalues = fieldid+"_"+isdetail+"$"+Util.formatMultiLang(fieldname, user.getLanguage()+"");
    		else
    			returnvalues += ","+fieldid+"_"+isdetail+"$"+Util.formatMultiLang(fieldname, user.getLanguage()+"");
    	}
    }
    if(option.equals("selfieldvalue")&&fieldId.indexOf("_")>-1){
    	int fid = weaver.general.Util.getIntValue(fieldId.substring(0,fieldId.indexOf("_")),0);
    	java.util.List selectList = modeLinkageInfo.getSelectFieldItem(fid);
    	for(int i=0;i<selectList.size();i++){
    		map = (java.util.Map)selectList.get(i);
    		String selectvalue = (String)map.get("selectvalue");
    		String selectname = (String)map.get("selectname");
    		if(returnvalues.equals("")) 
    			returnvalues = selectvalue+"$"+Util.formatMultiLang(selectname, languageid+"");
    		else
    			returnvalues += ","+selectvalue+"$"+Util.formatMultiLang(selectname, languageid+"");
    	}
    }
    response.setContentType("text/text;charset=UTF-8");
    out.print(returnvalues);
%>