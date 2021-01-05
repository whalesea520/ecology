<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	int index = 0;
	String type2 = Util.fromScreen3(request.getParameter("type2"),user.getLanguage());
	if(!type2.equals("")){
		String sql = "select distinct t1.scoreid from GP_AccessScoreDetail t1,GP_AccessScoreDetail t2,gp_accessitem t3,gp_accessscore t4"
			+" where t1.scoreid=t2.scoreid and t1.accessitemid=t2.accessitemid and t1.id<>t2.id"
			+" and t1.accessitemid=t3.id and t3.itemtype=2"
			+" and t1.scoreid=t4.id and t4.type2='"+type2+"' and t4.status=3";
		rs.executeSql(sql);
		while(rs.next()){
			String scoreid = Util.null2String(rs.getString(1));
			this.updateTarget(scoreid);
			index++;
		}
		
	}

	String scoreids = Util.fromScreen3(request.getParameter("scoreids"),user.getLanguage());
	List scoreidlist = Util.TokenizerString(scoreids,",");
	
	for(int i=0;i<scoreidlist.size();i++){
		String scoreid = (String)scoreidlist.get(i);
		this.updateTarget(scoreid);
		index++;
	}
%>
<%if(index>0){ %>
	共设置<%=index %>个考核
<%} %>
<form action="settarget.jsp" method="post">
	<input type="text" name="type2" value="" style="width: 200px;"/>
	<br>
	<input type="text" name="scoreids" value="" style="width: 500px;"/>
	<br>
	<input type="submit" value="提交"/>
</form>
<%!
	/**
	 * 更新下一周期的目标值
	 * @param scoreid
	 */
	public void updateTarget(String scoreid){
		if(!"".equals(scoreid)){
			RecordSet rs = new RecordSet();
			RecordSet rs2 = new RecordSet();
			rs.executeSql("select t2.id from GP_AccessScore t1,GP_AccessScore t2 "
					+" where t1.userid=t2.userid and t1.type1=t2.type1 and t1.id="+scoreid+" and t2.status=0"
					+" and ( ((t1.type1=3 or t1.type1=4) and t1.year=t2.year-1)"
					+" or ((t1.type1=1 or t1.type1=2) and t1.year=t2.year and t1.type2=t2.type2-1)"
					+" or (t1.type1=1 and t1.year=t2.year-1 and t1.type2=12 and t2.type2=1)"
					+" or (t1.type1=2 and t1.year=t2.year-1 and t1.type2=4 and t2.type2=1))");
			if(rs.next()){
				String nextscoreid = Util.null2String(rs.getString(1));
				rs.executeSql("select accessitemid,next1,next2,description from GP_AccessScoreDetail where scoreid="+scoreid);
				String accessitemid = "";
				String description = "";
				double target1 = 0;
				String target2 = "";
				while(rs.next()){
					accessitemid = Util.null2String(rs.getString("accessitemid"));
					description = Util.null2String(rs.getString("description"));
					target1 = Util.getDoubleValue(rs.getString("next1"),0);
					target2 = Util.null2String(rs.getString("next2"));
					rs2.executeSql("update GP_AccessScoreDetail set target1='"+target1+"',target2='"+target2+"',next1='"+target1+"',next2='"+target2+"' where scoreid="+nextscoreid+" and accessitemid="+accessitemid+" and description='"+description+"'");
				}
			}
		}
	}
%>
