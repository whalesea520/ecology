
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

<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
char flag=Util.getSeparator();
int userid=user.getUID();
request.setCharacterEncoding("UTF-8");
//RecordSet对应的sql
String rssql="";
//RecordSetTrans对应的sql
String sql="";
//数据库类型
String dbtype=RecordSet.getDBType();
List<String>  sqls=new ArrayList<String>();
StringBuffer sb=new StringBuffer("");
StringBuffer createsb=new StringBuffer("");
//主要分更新，新增部分
List<Map<String,String>>  updateitems=new ArrayList<Map<String,String>>();
List<Map<String,String>>  additems=new ArrayList<Map<String,String>>();
List<String> updateids=new ArrayList<String>();
int  count=Integer.valueOf(request.getParameter("count"));
String[]  itemids=new String[count];
String[]  fieldlables=new String[count]; 
String[]  fieldorders=new String[count]; 
String[]  htmltypes=new String[count]; 
String[]  iscusttypes=new String[count]; 
String[]  namelabels=new String[count]; 
String[]  types=new String[count]; 
String[]  typeids=new String[count]; 
String[]  widths=new String[count];
String matrixid=request.getParameter("matrixid");


//矩阵对应的表名
String matrixtablename=MatrixUtil.MATRIXPREFIX+matrixid;
String itemid;
String fieldlable;
String filedorder;
String htmltype;
String iscusttype;
String namelabel;
String typeid;
String type;
String width;

String fieldname;
String fieldlabel;
boolean needadd=true;

Map<String,String>  item;
//获取表单数据
for(int i=0;i<count;i++){
	
	itemids[i]=request.getParameter("itemid_"+i);
	fieldlables[i]=request.getParameter("fieldlable_"+i);
	fieldorders[i]=request.getParameter("filedorder_"+i);
	htmltypes[i]=request.getParameter("htmltype_"+i);
	iscusttypes[i]=request.getParameter("iscusttype_"+i);
	namelabels[i]=request.getParameter("namelabel_"+i);
	types[i]=request.getParameter("type_"+i);
	typeids[i]=request.getParameter("typeid_"+i);
	widths[i]=request.getParameter("width_"+i);
}
//获取新增,更新条目
for(int i=0;i<itemids.length;i++){
	 itemid=itemids[i];
	 item=new HashMap<String,String>();
	 item.put("itemid",itemid);
	 item.put("fieldlabel",fieldlables[i]);
	 item.put("fieldorder",fieldorders[i]);
	 item.put("htmltype",htmltypes[i]);
	 item.put("iscusttype",iscusttypes[i]);
	 item.put("namelabel",namelabels[i]);
	 item.put("typeid",typeids[i]);
	 item.put("type",types[i]);
	 //item.put("width",widths[i]);
	 String thiswidth = widths[i];
	 if(thiswidth.indexOf(".")>0){
		 thiswidth = thiswidth.substring(0,thiswidth.indexOf("."));
	 }
	 item.put("width",thiswidth);
	 //新增条目
	 if("".equals(itemid)){
	    additems.add(item);
	 //更新条目	 
	 }else{
	    updateitems.add(item); 
	    updateids.add(itemid); 
	 }
	 
}

//是否是第一次创建表 1表示第一次创建 0 非第一次创建
String firstcreatetable = "0";

//判断表名是否创建
rssql="select *  from MatrixFieldInfo where matrixid='"+matrixid+"'";
RecordSet.execute(rssql);
//不存在表记录,则默认新建表
if(!RecordSet.next()){
    	
    createsb.append("create table "+matrixtablename).append(" ( uuid  varchar(100), dataorder  float, ");
	for(int i=0,len=additems.size();i<len;i++){
		createsb.append(additems.get(i).get("fieldlabel")).append(" varchar(1000) ").append(",");	
	}
	rssql = createsb.substring(0,createsb.length()-1)+" ) ";
	//生成表结构
    new RecordSet().execute(rssql);
	
	//判断更新还是新建  true:update false:new
    needadd=false;
	//一次创建
    firstcreatetable= "1";
}

//构建sql 1.删除条目,更新条目,添加条目
if(updateids.size()>0){
	String tempstr="";
	for(int i=0,len=updateids.size();i<len;i++){
		sb.append("'"+updateids.get(i)+"'").append(",");
	}
	if(sb.length()>0){
		tempstr=sb.substring(0,sb.length()-1);
	}
	if(needadd){
		rssql="select fieldname from MatrixFieldInfo where id not in ("+tempstr+")  and matrixid='"+matrixid+"'";
		RecordSet.execute(rssql);
		//删除数据列
		while(RecordSet.next()){
		    sql="alter table "+matrixtablename+" drop column "+RecordSet.getString("fieldname");	
			sqls.add(sql);
		}
	}
	sql="delete from MatrixFieldInfo where id not in ("+tempstr+")  and matrixid='"+matrixid+"'";
	sqls.add(sql);
}
//更新条目
if(updateitems.size()>0){
	 
	for(Map<String,String>  itemdata:updateitems){
	      
		rssql="select fieldname  from MatrixFieldInfo where id='"+itemdata.get("itemid")+"'";
		RecordSet.execute(rssql);
		if(RecordSet.next()){
			fieldname=RecordSet.getString("fieldname");
			fieldlabel=itemdata.get("fieldlabel");
		    //更改列名操作
			if(!fieldname.equals(fieldlabel)){
		 		if("oracle".equals(dbtype) || "db2".equals(dbtype)){
		    	   sql="alter table "+matrixtablename+" rename column "+fieldname+" to "+fieldlabel+"";	
		    	}else if("sqlserver".equals(dbtype)){
		    	   sql="EXEC sp_rename '"+matrixtablename+"."+fieldname+"', '"+fieldlabel+"', 'COLUMN'";
		    	}
				sqls.add(sql);
		    }
		 }
		 sql="update MatrixFieldInfo set browsertypeid='"+itemdata.get("htmltype")+"',browservalue='"+itemdata.get("typeid")+"',custombrowser='"+itemdata.get("iscusttype")+"',displayname='"+itemdata.get("namelabel")+"',fieldname='"+itemdata.get("fieldlabel")+"',fieldtype='"+itemdata.get("type")+"',priority='"+itemdata.get("fieldorder")+"',colwidth='"+itemdata.get("width")+"'  where id='"+itemdata.get("itemid")+"'";
	     sqls.add(sql);
	}
	
}
//新增条目
if(additems.size()>0){
	//获取 最大的id
	int mfmaxid = 0;
	RecordSet.executeSql("select max(id) as id from MatrixFieldInfo");
	while(RecordSet.next()){
		mfmaxid = Util.getIntValue(RecordSet.getString("id"),1);
	}

	for(Map<String,String>  itemdata:additems){
		 
		 if(needadd){
			 //添加列
			 sql="alter table "+matrixtablename+" add "+itemdata.get("fieldlabel")+" varchar(1000)";
			 sqls.add(sql);
		 }
		 
		//插入列详细信息
		  mfmaxid ++;
		 if("oracle".equals(dbtype)){
			 sql="insert into MatrixFieldInfo(id,matrixid,browsertypeid,browservalue,custombrowser,displayname,fieldname,fieldtype,priority,colwidth) values("+mfmaxid+",'"+matrixid+"','"+itemdata.get("htmltype")+"','"+itemdata.get("typeid")+"','"+itemdata.get("iscusttype")+"','"+itemdata.get("namelabel")+"','"+itemdata.get("fieldlabel")+"','"+itemdata.get("type")+"','"+itemdata.get("fieldorder")+"','"+itemdata.get("width")+"')";
	      }else if("sqlserver".equals(dbtype)){
	    	  sql="insert into MatrixFieldInfo(matrixid,browsertypeid,browservalue,custombrowser,displayname,fieldname,fieldtype,priority,colwidth) values('"+matrixid+"','"+itemdata.get("htmltype")+"','"+itemdata.get("typeid")+"','"+itemdata.get("iscusttype")+"','"+itemdata.get("namelabel")+"','"+itemdata.get("fieldlabel")+"','"+itemdata.get("type")+"','"+itemdata.get("fieldorder")+"','"+itemdata.get("width")+"')";
	     }
		 
		 
	     sqls.add(sql);
	}
}
try{
	RecordSetTrans.setAutoCommit(false);
	for(String sqlitem:sqls){
		//System.out.println(sqlitem );
		RecordSetTrans.execute(sqlitem);
	}	
	//提交事务
	RecordSetTrans.commit();
    String fieldinfojson=MatrixUtil.getMatrixJsonByIdForDesignList(matrixid);
	out.println("{\"success\":\"1\",\"fieldarray\":"+fieldinfojson+",\"firstcreatetable\":\""+firstcreatetable+"\"}");
	//out.println("{\"success\":\"1\"}");
}catch(Exception e){
	//e.printStackTrace();
	out.println("{\"success\":\"0\"}");
}



%>