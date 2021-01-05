
<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*,weaver.matrix.*,weaver.workflow.workflow.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%!
   private void checkMatrixTable(String matrixid){
	 String tableName = MatrixUtil.MATRIXPREFIX+matrixid;
	 
	  RecordSet matrixRs = new RecordSet();
	  List<String> fieldnamelist= new ArrayList<String>();
	 String sql = "select fieldname  from MatrixFieldInfo where matrixid='"
			+ matrixid + "' order by fieldtype asc, priority";
	  matrixRs.execute(sql);
	  while(matrixRs.next()){
		  fieldnamelist.add(matrixRs.getString(1));
	  }
	  matrixRs.executeSql("select * from "+tableName);
	  String[] columnNames = matrixRs.getColumnName();
	  
	  List<String> needAddColumn = new ArrayList<String>();
	  for(int i =0;i<fieldnamelist.size();i++){
		  String fieldname= fieldnamelist.get(i);
		  boolean ishave = false;
		  for(int j = 0;j<columnNames.length;j++){
			  if(fieldname.toUpperCase().equals(columnNames[j].toUpperCase())){
				  ishave = true;
			  }
		  }
		  if(!ishave){
			  needAddColumn.add(fieldname);
		  }
	  }
	  
	  for(int i =0;i<needAddColumn.size();i++){
		  matrixRs.executeSql("alter table "+tableName+" add "+needAddColumn.get(i)+" varchar(1000)");
	  }
   }
%>
<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
char flag=Util.getSeparator();
int userid=user.getUID();
request.setCharacterEncoding("UTF-8");
int pageindex=Util.getIntValue(request.getParameter("pageindex"));
int pagesize=Util.getIntValue(request.getParameter("pagesize"));
//查询字段名
String qfieldname=Util.null2String(request.getParameter("qfieldname"));
//查询字段值
String qfieldvalue=Util.null2String(request.getParameter("qfieldvalue"));

String matrixid=request.getParameter("matrixid");
checkMatrixTable(matrixid);
StringBuffer sqlwhereinfo=new StringBuffer(" 1=1 ");

if(!"".equals(qfieldname)  &&  !"".equals(qfieldvalue)){
	String[] qvalues=qfieldvalue.split(",");
	StringBuffer sb=new StringBuffer();
    String qvstr="";
    int num = 0;
	sqlwhereinfo.append(" and(");
	for(String qvalue:qvalues){
		if(num >0 ){
			sqlwhereinfo.append(" or ");
		}
		sqlwhereinfo.append("").append(qfieldname).append(" like '%,"+qvalue+",%' or "+qfieldname+" like '"+qvalue+",%' or "+qfieldname+"='"+qvalue+"' or "+qfieldname+" like '%,"+qvalue+"'") ;
		num++;
	}
	sqlwhereinfo.append(")");
	//System.out.println(sqlwhereinfo.toString());
}

//根据id值获取具体的名称
GetShowCondition conditions=new GetShowCondition();

SplitPageParaBean bean=new  SplitPageParaBean();
bean.setSortWay(0);
bean.setBackFields(" * ");
String dbType = rs2.getDBType();
String dataorder = "dataorder";
if("oracle".equalsIgnoreCase(dbType)){
	dataorder = "dataorder-1";
}else if("sqlserver".equalsIgnoreCase(dbType)){
	dataorder = "cast(dataorder as float)";
}
bean.setSqlOrderBy(" "+dataorder+"  ");
//矩阵表名
bean.setSqlFrom(" "+MatrixUtil.MATRIXPREFIX+matrixid+" ");
bean.setSqlWhere(sqlwhereinfo.toString());
bean.setPrimaryKey("uuid");
SplitPageUtil util=new SplitPageUtil();
util.setSpp(bean);
List<Map<String,String>>  items=new ArrayList<Map<String,String>>();
Map<String,String> item;
RecordSet   rs=util.getCurrentPageRs(pageindex,pagesize);
int pageRecord=util.getRecordCount();
int columncount;
Map<String, Map<String, String>>  fieldinfos=MatrixUtil.getFieldDetail(matrixid);

int isSystem = -1;
rs2.executeSql("select issystem from MatrixInfo where id = " +matrixid +" and issystem is not null");
if(rs2.next()){
	isSystem = rs2.getInt("issystem");
}

if(pageRecord==0)
{
	item=new HashMap<String,String>();
	item.put("pagecount",pageRecord+"");
	items.add(item);
}
else{
	double f;
	while(rs.next())
	{  
		  columncount=rs.getColCounts();
		  item=new HashMap<String,String>();
		  item.put("pagecount",pageRecord+"");
		  //添加列值
		  for(int i=0;i<columncount;i++){
			String tempstr = rs.getColumnName(i+1);
			if(!"".equals(tempstr)) tempstr = tempstr.toLowerCase();
			//System.out.println("tempstr==="+tempstr);
			if("uuid".equals(tempstr) || "dataorder".equals(tempstr)){
				String tmValue = rs.getString(tempstr);
			   if("dataorder".equals(tempstr)){
				   if(tmValue.endsWith(".0")){
					   tmValue = tmValue.substring(0,tmValue.lastIndexOf(".0"));
				   }
			   }
   	           item.put(tempstr,tmValue);		  
			//浏览框
			}else{
			   item.put(tempstr,rs.getString(tempstr));	
			   String value = "";
			   if(!"".equals(rs.getString(tempstr).trim())){
			       try{
				   	value = MatrixUtil.getSpanValueByIds(fieldinfos.get(tempstr),conditions,rs.getString(tempstr));
			       }catch(Exception e){
						
				   }
			   }
			   item.put(tempstr+"_name",value);		  
			}
			//增加系统矩阵中，分部、部门鼠标悬浮上之后，显示全路径
			if("id".equalsIgnoreCase(tempstr)){
				String titleValue = "";
				if(isSystem != -1){
					try{
					    MatrixManager matrixManager = new MatrixManager();
						if(isSystem == 1){ //分部
							titleValue =matrixManager.getSubcompany(rs.getString(tempstr));
						}else if(isSystem ==2){ //部门
							titleValue =matrixManager.getDepartment(rs.getString(tempstr));
						}
					}catch(Exception e){
						
					}
				}
				item.put("title", titleValue);
			}
		  }
		  items.add(item);
	}
}
JSONArray  jsonarray=new JSONArray(items);
out.print(jsonarray.toString());
%>