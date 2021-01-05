<%@ include file="/page/element/operationCommon.jsp"%>
<%@ include file="common.jsp"%>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<%
	String    slide_picShow=request.getParameter("slide_t_picShow");//auto or normal
     String 	slide_AutoChangeTime=request.getParameter("slide_t_AutoChangeTime");
     String 	slide_changeStyle=request.getParameter("slide_t_changeStyle");
     String 	slide_changeTime=request.getParameter("slide_t_changeTime");
     String 	slide_changeStyleBar=request.getParameter("slide_t_changeStyleBar");
     String 	slide_position=request.getParameter("slide_t_position");
     String strSettingSql = "select count(*) maxId from slideElement " ;
     rs_Setting.execute(strSettingSql);
	int maxid=0;
	if (rs_Setting.next())
	{
		maxid = rs_Setting.getInt("maxId");
	}
	maxid++;
		
     ArrayList nameList=new ArrayList();
     ArrayList valueList=new ArrayList();
     nameList.add("slide_t_AutoChangeTime");
     nameList.add("slide_t_changeStyle");
     nameList.add("slide_t_changeTime");
     nameList.add("slide_t_changeStyleBar");
     nameList.add("slide_t_position");
     nameList.add("slide_t_picShow");
     
     valueList.add(slide_AutoChangeTime);
     valueList.add(slide_changeStyle);
     valueList.add(slide_changeTime);
     valueList.add(slide_changeStyleBar);
     valueList.add(slide_position);
     valueList.add(slide_picShow);
	
     String sql1="delete from hpelementsetting where eid="+eid;
	 //baseBean.writeLog(sql1);
     rs_Setting.execute(sql1);
     String sql2="";
	 try{
 	for(int i=0;i<nameList.size();i++){
    	sql2=" insert into hpelementsetting(id,eid,name,value) values("+(maxid+1)+","+eid+",'"+nameList.get(i)+"','"+valueList.get(i)+"')";
		//baseBean.writeLog(sql2);
		 rs_Setting.execute(sql2);
 	}
	}catch(Exception e){
		baseBean.writeLog(e);
	}
     
%>