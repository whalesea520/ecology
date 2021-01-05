<%@page import="weaver.formmode.cuspage.cpt.Cpt4modeUtil"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%

User user = HrmUserVarify.getUser(request, response);
StringBuffer result = new StringBuffer("{");

if(user == null){
	result.append("\"info\":{\"success\":false,\"msg\":\"user error!\"}");
}else{
	
	String operatorId=""+user.getUID();
	String modeid=Util.null2String(request.getParameter("modeid"));
	String modename=""+Cpt4modeUtil.getModename(modeid);
	String poststr=Util.null2String(request.getParameter("poststr"));
	int requestid=Util.getIntValue(request.getParameter("requestid"),0);
	int currentnodetype=Util.getIntValue(request.getParameter("currentnodetype"),0);
	int formid=Util.getIntValue(request.getParameter("formid"),0);
	int workflowid=Util.getIntValue(request.getParameter("workflowid"),0);
	
	
	String msg="";
	HashMap tmpMap=new HashMap<String,String>();
	if(!"".equals(poststr)){
		
		String[] s= Util.TokenizerString2(poststr, ",");
		for(int i=0;i<s.length;i++){
			String billid=""+Util.getIntValue(s[i]);
			if("zcz".equalsIgnoreCase(modename) ){//资产组
				String sql=""+
						" WITH allhrm(id,supassortmentid,assortmentname ) as (SELECT id ,supassortmentid,assortmentname FROM uf_CptAssortment where id="+billid+" "+
						" UNION ALL SELECT a.id,a.supassortmentid,a.assortmentname FROM uf_CptAssortment a,allhrm b where a.supassortmentid = b.id and a.supassortmentid !=a.id "+ 
						" ) select t1.id,t1.assortmentname from allhrm t1,uf_cptcapital t2 where t2.capitalgroupid=t1.id "
				;
				if("oracle".equalsIgnoreCase(rs.getDBType())){
					sql=""+
						" select t1.id,t1.assortmentname from (select id,supassortmentid,assortmentname from uf_CptAssortment where id="+billid+" "+
						" union "+
						"    select  a.id,a.supassortmentid,a.assortmentname from uf_CptAssortment a  start with a.id = "+billid+" connect by prior a.id=a.supassortmentid "+
						" ) t1,uf_cptcapital t2 where t2.capitalgroupid=t1.id "
							;
					
				}
				rs.executeSql(sql);
				if(rs.next()){
					//msg=rs.getString("assortmentname") +" "+SystemEnv.getHtmlLabelName(22688, user.getLanguage());
					msg=SystemEnv.getHtmlLabelName(22688, user.getLanguage());
					break;
				}
				sql="select t1.assortmentname from uf_CptAssortment t1,uf_CptAssortment t2 where t1.id=t2.supassortmentid and t1.id="+billid;
				rs.executeSql(sql);
				if(rs.next()){
					//msg=rs.getString("assortmentname") +" "+SystemEnv.getHtmlLabelName(28472, user.getLanguage());
					msg=SystemEnv.getHtmlLabelName(22688, user.getLanguage());
					break;
				}
				
				
			}else if("zclx".equalsIgnoreCase(modename)){
				String sql=""+
						" select t1.id,t1.name FROM uf_cptcapitaltype t1,uf_cptcapital t2 where t1.id=t2.capitaltypeid and t1.id="+billid+" ";
				;
				rs.executeSql(sql);
				if(rs.next()){
					msg=rs.getString("name") +" "+SystemEnv.getHtmlLabelName(22688, user.getLanguage());
					break;
				}
			}else if("jldw".equalsIgnoreCase(modename)){
				String sql=""+
						" select t1.id,t1.unitname FROM uf_LgcAssetUnit t1,uf_cptcapital t2 where t1.id=t2.unitid and t1.id="+billid+" ";
				;
				rs.executeSql(sql);
				if(rs.next()){
					msg=rs.getString("unitname") +" "+SystemEnv.getHtmlLabelName(22688, user.getLanguage());
					break;
				}
			}else if("zczl".equalsIgnoreCase(modename)){
				String sql=""+
						" select top 1 t1.id,t1.name FROM uf_cptcapital t1,uf_cptcapital t2 where t1.id=t2.datatype and t1.id="+billid+" "+
						" union "+
						" select top 1 t1.id,t1.name from uf_cptcapital t1,uf_CptStockIn_dt1 t2,uf_CptStockIn t3 where t1.id=t2.cpttype and t2.mainid=t3.id and t3.ischecked='0' and t1.id="+billid+" ";
				
				;
				if("oracle".equalsIgnoreCase(rs.getDBType())){
					sql=""+
							" select t1.id,t1.name FROM uf_cptcapital t1,uf_cptcapital t2 where t1.id=t2.datatype and t1.id="+billid+" and rownum=1 "+
							" union "+
							" select  t1.id,t1.name from uf_cptcapital t1,uf_CptStockIn_dt1 t2,uf_CptStockIn t3 where t1.id=t2.cpttype and t2.mainid=t3.id and t3.ischecked='0' and t1.id="+billid+" and rownum=1 ";
				}
				rs.executeSql(sql);
				if(rs.next()){
					msg=rs.getString("name") +" "+SystemEnv.getHtmlLabelName(22688, user.getLanguage());
					break;
				}
			}
			
		}
		
		
		
	}
		
	result.append("\"msg\":\""+msg+"\",");
	
	result.append("\"info\":{\"success\":true,\"msg\":\"\"}");
	
}
result.append("}");

%>
<%=result.toString() %>
