
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.matrix.MatrixUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MatrixManager" class="weaver.matrix.MatrixManager" scope="page" />

<%

/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

request.setCharacterEncoding("UTF-8");
//矩阵id
String matrixid = Util.null2String(request.getParameter("matrixid"));
//需要被替换的人员id
String olduserid = Util.null2String(request.getParameter("olduserid")).trim();

//需要 替换成人员的id, 可为空
String newuserid = Util.null2String(request.getParameter("newuserid")).trim();

String method = Util.null2String(request.getParameter("method"));

//System.out.println("olduserid="+olduserid+"====newuserid="+newuserid);

String issystem = "";
RecordSet.execute("select issystem from MatrixInfo where id= "+matrixid);
if(RecordSet.next()){
	issystem = RecordSet.getString("issystem");
}
  //处理 替换 和 删除。根据  matrixid olduserid 查询符合条件的记录数
  if("replacerecord".equals(method)){
	//查询在 matrixid 矩阵中，涉及 olduserid 有多少条记录
	   //判断表名是否创建
		String sql ="select *  from MatrixFieldInfo where matrixid="+matrixid;
	    List<String> backfiledlist = new ArrayList<String>();
		RecordSet.execute(sql);
	    //获取当前表的所有字段，不包括id
        while(RecordSet.next()){
        	//只获取 取值 字段
	        if(!"0".equals(RecordSet.getString("fieldtype"))){
        	    backfiledlist.add(RecordSet.getString("fieldname"));	
	        }
        }
	    
	    String backvalue = "1";
	    
	    try{
		    //说明有记录
		    if(backfiledlist.size() != 0){
		        //因这些数据是由用户维护，整记录数不会太多，不会超过 十万。 所以可一次性把所有数据查询，然后循环替换
		         //存储所有的记录
				List<Properties> records = new ArrayList<Properties>();
				Properties pro = null;
				sql = "select * from Matrixtable_"+matrixid;
				RecordSet.execute(sql);
				//是否有记录
				while(RecordSet.next()){
					pro = new Properties();
					for(String fieldname : backfiledlist){
						String value = RecordSet.getString(fieldname);
						//值 替换
						if(!"".equals(value) && value != null){
							//System.out.print(value+"========");
							if(value.contains(","+olduserid+",")){
								value = value.replaceAll(","+olduserid+",",","+newuserid+",");
							}else if(value.startsWith(olduserid+",")){
								value = value.replaceAll(olduserid+",",newuserid+",");
							}else if(value.endsWith(","+olduserid)){
								value = value.replaceAll(","+olduserid,","+newuserid);
							}else if(value.equals(olduserid)){
								value = newuserid;
							}
							//System.out.println(value+"========");
						}
						//存储替换后的值
						pro.put(fieldname,value);
					}			
					//将id 放到 prop 中
					pro.put("uuid",RecordSet.getString("uuid"));
					// 加入到 list 中
					records.add(pro);
				}
				
				StringBuffer sb = null;
				for(Properties prop : records){
					sb = new StringBuffer();
					sb.append("update ").append(" Matrixtable_"+matrixid).append(" set ")
					.append(MatrixManager.createUpdateColSql(prop, backfiledlist))
					.append(" where uuid").append(" = '").append(prop.get("uuid")).append("'");
					//System.out.println(sb+"===========");
					RecordSet.execute(sb+"");
				}
		    }
		    if("1".equals(issystem) || "2".equals(issystem)){
		    	MatrixUtil.sysMatrixDataToSubOrDep(matrixid,Util.getIntValue(issystem));
		    }
	    }catch(Exception e){
	    	backvalue = e.getMessage();
	    }
	    
		//返回记录数
		out.print(backvalue);
		return;
  }

%>

