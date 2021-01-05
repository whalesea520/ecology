<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.alibaba.fastjson.JSONArray"%>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.common.util.string.StringUtil"%>
<%@page import="weaver.conn.BatchRecordSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%
	String userId  = user.getUID()+"";
	String customerId = request.getParameter("customerId");
	String contacterId = Util.null2String(request.getParameter("contacterId"));
	String datas = Util.null2String(request.getParameter("datas"));
	String old_parent = Util.null2String(request.getParameter("old_parent"));
	String new_parent = Util.null2String(request.getParameter("new_parent"));
	String action = Util.null2String(request.getParameter("action"));
	String firstname = request.getParameter("firstname");
	String jobtitle = Util.null2String(request.getParameter("jobtitle"));
	String title = Util.null2String(request.getParameter("title"));
	String mobilephone = Util.null2String(request.getParameter("mobilephone"));
	String email = Util.null2String(request.getParameter("email"));
	String phoneoffice =  Util.null2String(request.getParameter("phoneoffice"));
	String imcode =  Util.null2String(request.getParameter("imcode"));
	String attitude =  Util.null2String(request.getParameter("attitude"));
	String attention =  Util.null2String(request.getParameter("attention"));
	String contacterName = "";
	if(StringUtil.isNotNullAndEmpty(contacterId)){
		rs.execute( "select firstname from crm_customercontacter where id = "+contacterId);
		rs.first();
		contacterName = rs.getString("firstname");
	}
	
	if(StringUtil.isNotNullAndEmpty(firstname)){
		if(StringUtil.isNotNullAndEmpty(contacterId)){//更新联系人
			String para = "firstname = '"+firstname+"',title = '"+title+"',jobtitle = '"+jobtitle+"',mobilephone = '"+mobilephone+"',phoneoffice = '"+phoneoffice+"',attention = '"+attention+"',email = '"+email+"',imcode = '"+imcode+"',attitude = '"+attitude+"'";
			String updateSql = "update crm_customercontacter set "+para+" where id = "+contacterId;
			rs.execute(updateSql);
			String operate_value = "联系人 ["+firstname+"]";
			recordLog(customerId,firstname,1,operate_value,userId);
		}else{//新建联系人
			String parentid = request.getParameter("parentid");
			String direction = request.getParameter("direction");
			if(StringUtil.isNullOrEmpty(parentid)){
					parentid = "root";
				}
			String para = "('"+firstname+"',"+"'"+firstname+"',"+"'"+title+"',"+"'"+jobtitle+"',"+"'"+mobilephone+"',"+"'"+email+"',"+"'"+phoneoffice+"',"+"'"+customerId+"',"+"'"+attitude+"',"+"'"+imcode+"',"+"'"+attention+"')";
			String insertSql = "insert into crm_customercontacter(fullname,firstname,title,jobtitle,mobilephone,email,phoneoffice,customerid,attitude,imcode,attention) values "+para;
			rs.execute(insertSql);
			rs.execute("select id from crm_customercontacter where mobilephone = '"+mobilephone+"' and firstname = '"+firstname+"'");
			rs.first();
			contacterId = rs.getString("id");
			/**保存节点关系**/
			para = "("+"'"+customerId+"',"+"'"+contacterId+"',"+"'"+parentid+"',"+"'"+direction+"')";
			insertSql = "insert into crm_customercontacter_mind(customerid,contacterid,parentid,direction) values"+para;
			rs.execute(insertSql);
			String operate_value = "联系人 ["+firstname+"]";
			recordLog(customerId,firstname,0,operate_value,userId);
		}
	}
	/**删除联系人**/
	if("delete".equals(action)){
		/**将当前节点的子节点的parentid修改前前一节点的id**/
		rs.execute("update crm_customercontacter_mind set parentid = (select parentid from crm_customercontacter_mind where contacterid = '"+contacterId+"') where parentid = '"+contacterId+"'");
		rs.execute("delete from crm_customercontacter where id = "+contacterId);
		rs.execute("delete from crm_customercontacter_mind where contacterid = "+contacterId);
		String operate_value = "联系人 ["+contacterName+"]";
		recordLog(customerId,contacterName,2,operate_value,userId);
	}
	/**保存关系图**/
	//记录拖拽日志
	if(!old_parent.equals(new_parent) && StringUtil.isNotNullAndEmpty(new_parent) && StringUtil.isNotNullAndEmpty(old_parent) && StringUtil.isNotNullAndEmpty(contacterId)){
		String[] arr = {contacterId,old_parent,new_parent};
		List<String> list = new ArrayList<String>();
		for(String s : arr){
			if(!"root".equals(s)){
				rs.execute( "select firstname from crm_customercontacter where id = "+s);
				rs.first();
				list.add(rs.getString("firstname"));
			}else{
				list.add("根节点");
			}
		}
		String operate_value ="["+list.get(0).toString()+"]" + " 由 ["+list.get(1).toString()+"] 之后拖拽至 ["+list.get(2).toString()+"] 之后";
		recordLog(customerId,contacterName,3,operate_value,userId);
		
	}
	if(StringUtil.isNotNullAndEmpty(datas)){
		rs.execute("delete from crm_customercontacter_mind where customerid = "+customerId);
		String insertSql = "insert into crm_customercontacter_mind(customerid,contacterid,parentid,direction) values(?,?,?,?)";
		JSONArray arr = JSONArray.parseArray(datas);
		char separator = Util.getSeparator();
		String para = null;
		List<String> paraList = new ArrayList<String>();
		BatchRecordSet batchRs = new BatchRecordSet();
		String contacterid = "";
		String parentid = "";
		String direction = "";
		for(int i = 0 ;i < arr.size();i++){
			JSONObject obj = arr.getJSONObject(i);
			contacterid = Util.null2String(obj.getString("id"));
			parentid = Util.null2String(obj.getString("parentid"));
			direction = obj.getString("direction");
			para = customerId + separator
			+ contacterid + separator
			+ parentid + separator 
			+ direction ;
			paraList.add(para);
		}
		batchRs.executeSqlBatch(insertSql, paraList);
	}
	/**重置关系图**/
	if("reset".equals(action)){
		rs.execute("delete from crm_customercontacter_mind where customerid = "+customerId);
		String operate_value = "重置了联系人地图";
		recordLog(customerId,contacterName,3,operate_value,userId);
	}
%>
<%!
	private void recordLog(String customerId,String contacterId,int operate_type,String operate_value,String userId){
		String nowDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		String nowTime = new SimpleDateFormat("HH:mm:ss").format(new Date());
		String para = "'"+customerId+"','"+contacterId+"','"+operate_type+"','"+operate_value+"','"+nowDate+"','"+nowTime+"','"+userId+"'";
		String sql = "insert into crm_customercontacter_mind_log(customerid,contacterid,operate_type,operate_value,operate_date,operate_time,operate_usr) values("+para+")";
		RecordSet rs = new RecordSet();
		rs.execute(sql);
		
}
%>

