
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String checkid = Util.null2String(request.getParameter("checkid"));
	String str = "";
	
	//验证
	if(!checkid.equals("")){
		ArrayList list = Util.TokenizerString(checkid, ",");
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				String onlyid = (String)list.get(i);
				String sql = "SELECT count(*) cnt  \n" +
						" from FnaBudgetInfo a \n" +
						" join FnaBudgetInfoDetail b on a.id = b.budgetinfoid \n" +
						" where b.budgetaccount <> 0\n" +
						" and a.status = 1 \n" +
						" and b.budgettypeid = "+Util.getIntValue(onlyid, 0);
				rs.executeSql(sql);
				if(rs.next() && rs.getInt("cnt") > 0){
					str = "1";
					break;
				}
			}
		}
	}
	out.print(str);
%>
