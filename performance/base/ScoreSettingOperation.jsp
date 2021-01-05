<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)){
		response.sendRedirect("ScoreSetting.jsp");
        return;
	}
	String idStr = Util.null2String(request.getParameter("ids"));       
    String[] ids = idStr.split(","); 
    rs.execute("DELETE FROM GP_ScoreSetting ");
    for(int i = 0;i<ids.length;i++){
        String gardename = Util.null2String(request.getParameter("gardename_"+ids[i]));
        String beginSymbol = Util.null2String(request.getParameter("beginSymbol_"+ids[i]));
        String beginscore = Util.null2String(request.getParameter("beginscore_"+ids[i]));
        String endSymbol = Util.null2String(request.getParameter("endSymbol_"+ids[i]));
        String endscore =Util.null2String(request.getParameter("endscore_"+ids[i])); 
        String rank = Util.null2String(request.getParameter("rank_"+ids[i])); 
        if("".equals(beginscore.trim())){
            //continue;
        }
        rs.execute("INSERT INTO GP_ScoreSetting(gardename,beginSymbol,beginscore,endSymbol,endscore,rank) "+
                                   " VALUES ('"+gardename+"','"+beginSymbol+"','"+beginscore+"','"+endSymbol+"','"+endscore+"','"+rank+"')");  
    }
	
	
	
	
	response.sendRedirect("ScoreSetting.jsp?isSaveSuccess=1");
%>
