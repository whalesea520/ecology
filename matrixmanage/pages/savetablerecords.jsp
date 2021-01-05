
<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*,java.text.*,weaver.matrix.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmOutInterface" class="weaver.hrm.outinterface.HrmOutInterface" scope="page" />

<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;

char flag=Util.getSeparator();
int userid=user.getUID();
request.setCharacterEncoding("UTF-8");
//数据库类型
List<String>  sqls=new ArrayList<String>();
//主要分更新，新增部分
List<Map<String,String>>  updaterecords=new ArrayList<Map<String,String>>();
List<Map<String,String>>  addrecords=new ArrayList<Map<String,String>>();
//编辑条数
int  recordnum=Integer.valueOf(request.getParameter("recordnum"));
String matrixid=request.getParameter("matrixid");
//矩阵对应的表名
String matrixtablename=MatrixUtil.MATRIXPREFIX+matrixid;
//矩阵字段集合
List<String>  matrixfields=MatrixUtil.getMatrixFieldsArray(matrixid);
Map<String,String>  record;
String uuid;
String dataorder;
float maxMatrixDataOrder = 0;
String dbType = rs3.getDBType();
String dataorderStr = "dataorder";
if("oracle".equalsIgnoreCase(dbType)){
	dataorderStr = "dataorder+0";
}else if("sqlserver".equalsIgnoreCase(dbType)){
	dataorderStr = "cast(dataorder as float)";
}
rs3.executeSql("select max("+dataorderStr+") from "+MatrixUtil.MATRIXPREFIX+matrixid);
if(rs3.next()){
	maxMatrixDataOrder = rs3.getFloat(1);
	if(maxMatrixDataOrder == -1){
		maxMatrixDataOrder = 0;
	}
}

//插入数据
for(int i=0;i<recordnum;i++){
	 record=new HashMap<String,String>();
	 uuid=Util.null2String(request.getParameter("uuid_"+i));
	 dataorder=request.getParameter("dataorder_"+i);
	 if(!"".equals(dataorder.trim())){
		try{
			 float dataorderf = 0;
			 dataorderf = Float.parseFloat(dataorder);
			 dataorder = String.valueOf(dataorderf);
		 }catch(Exception e){
			 out.println("{\"success\":\"2\"}");
			 return;
		 }
	 }
	 for(String field:matrixfields){
     	 record.put(field,Util.null2String(request.getParameter((field+"_"+i).toLowerCase())));
	 }
	 //新增
	 if("".equals(uuid)){
		 if("".equals(dataorder.trim())){
			 maxMatrixDataOrder++;
			 dataorder=maxMatrixDataOrder+"";
		 }
		 record.put("dataorder",dataorder);
		 addrecords.add(record);
		 record.put("uuid",UUID.randomUUID().toString());
     //更新		 
	 }else{
		 record.put("dataorder",String.valueOf(dataorder));
		 updaterecords.add(record); 
		 record.put("uuid",uuid);
	 }
}


try{//修改客户卡片客户经理时，同步修改 客户纬度 客户经理部门下面的人员，更新矩阵下面的人员
	String name = "";
	String sql = "select name from MatrixInfo where id="+matrixid;
	rs3.executeSql(sql);
	if(rs3.next()){
		name= rs3.getString("name");
	}
	if(name.equals("外部用户")){
		for(int i=0;i<recordnum;i++){
			String subcompanyid = Util.null2String(request.getParameter("subcompany_"+i));
			String crmmanager = Util.null2String(request.getParameter("crmmanager_"+i));
			String outmanager = Util.null2String(request.getParameter("outmanager_"+i));
			if(subcompanyid.length()>0){
				rs3.executeSql("select customid from customresourceout where subcompanyid= "+subcompanyid);
				if(rs3.next()){
					String customerid = Util.null2String(rs3.getString("customid"));
					if(customerid.length()>0){
						HrmOutInterface.changeCustomManager(customerid,crmmanager,"MatrixInfo");
						HrmOutInterface.changeOutManager(customerid,outmanager);
					}
				}
			}
		}
	}
}catch(Exception e){
 new BaseBean().writeLog(e);
}

//添加批量脚本
MatrixUtil.getAddSql(matrixtablename,sqls,matrixfields,addrecords);
//更新批量脚本
MatrixUtil.getUpdateSql(matrixtablename,sqls,matrixfields,updaterecords);



try{
	RecordSetTrans.setAutoCommit(false);
	for(String sqlitem:sqls){
		//System.out.println(sqlitem);
		RecordSetTrans.execute(sqlitem);
	}	
	//提交事务
	RecordSetTrans.commit();
	//同步矩阵数据到 部门或分部，只更新数据
	RecordSet.executeSql("select issystem from MatrixInfo where id = " +matrixid +" and issystem is not null");
	if(RecordSet.next()){
		int isSystem = RecordSet.getInt(1);
		if(isSystem != -1){
			MatrixUtil.sysMatrixDataToSubOrDep(matrixid,isSystem);
		}
	}
	out.println("{\"success\":\"1\"}");
}catch(Exception e){
	//e.printStackTrace();
	out.println("{\"success\":\"0\"}");
}



%>