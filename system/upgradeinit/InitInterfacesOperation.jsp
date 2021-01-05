<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.io.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
StringBuffer sqlsb = null;
String operate = Util.null2String(request.getParameter("operate"));
if(operate.equals("action")){//初始化Action
    if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
        RecordSet.executeSql("update workflowactionset set actionname = replace(actionname,'action.','') where instr(actionname,'action.')>0");
        RecordSet.executeSql("update workflowactionset set interfaceid = replace(interfaceid,'action.','') where instr(interfaceid,'action.')>0");
    }else{
        RecordSet.executeSql("update workflowactionset set actionname = replace(actionname,'action.','') where CHARINDEX('action.',actionname)>0");
        RecordSet.executeSql("update workflowactionset set interfaceid = replace(interfaceid,'action.','') where  CHARINDEX('action.',interfaceid)>0");
    }
}else if(operate.equals("actionxml")){
    String xmlfilechart = Util.null2String(RecordSet.getPropValue("xmlfile","xmlfilechart"));
    if(xmlfilechart.equalsIgnoreCase("GBK")){
        String content = "xmlfilechart = UTF-8";
        File file = new File(GCONST.getPropertyPath()+"xmlfile.properties");
        //System.out.println(file.getPath());//270944,lv,[80]集成中心－解决代码质量问题修复--代码里不允许使用 "System.out.println()"
        Writer w = new OutputStreamWriter(new FileOutputStream(file), "UTF-8");
        w.write(content);
        w.close();
        
        String axtionXMLPath = GCONST.getRootPath()+"WEB-INF"+File.separatorChar+"service"+File.separatorChar+"action.xml";
        //System.out.println(axtionXMLPath);//270944,lv,[80]集成中心－解决代码质量问题修复--代码里不允许使用 "System.out.println()"
        org.dom4j.io.SAXReader reader=new org.dom4j.io.SAXReader();
        org.dom4j.Document doc=reader.read(new File(axtionXMLPath));
        org.dom4j.io.OutputFormat format=new org.dom4j.io.OutputFormat();
        format.setEncoding("UTF-8");
        org.dom4j.io.XMLWriter writer=new org.dom4j.io.XMLWriter(new FileOutputStream(axtionXMLPath),format);
        writer.write(doc);
        writer.close();
    }
}else if(operate.equals("webservice")){
    sqlsb = new StringBuffer();
    if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
        sqlsb.append("select t.* from wsformactionset t  ");
        sqlsb.append(" where not exists (");
        sqlsb.append("     select 1 from wsformactionset t1 join wsregiste t2 ");
        sqlsb.append("      on t1.wsurl = to_char(t2.id) where t.id=t1.id");
        sqlsb.append(" )");
    }else{
        sqlsb.append("select t.* from wsformactionset t  ");
        sqlsb.append(" where not exists (");
        sqlsb.append("     select 1 from wsformactionset t1 join wsregiste t2 ");
        sqlsb.append("      on t1.wsurl = convert(varchar(1000),t2.id) where t.id=t1.id");
        sqlsb.append(" )");
    }
    RecordSet.executeSql(sqlsb.toString());
    while(RecordSet.next()){
        String id = Util.null2String(RecordSet.getString("id"));
        String actionname = Util.null2String(RecordSet.getString("actionname"));	//名称
        String wsurl = Util.null2String(RecordSet.getString("wsurl"));				//webservice地址
        String wsoperation = Util.null2String(RecordSet.getString("wsoperation"));	//webservice方法
        String inpara = Util.null2String(RecordSet.getString("inpara"));			//webservice入参
        String rettype = Util.null2String(RecordSet.getString("rettype"));			//返回值类型
        
        int wsregisteid = 0;
        int wsregistemethod = 0;
        //webservice注册表信息
        if(!wsurl.equals("")){
            rs.executeSql("select id from wsregiste where webserviceurl='"+wsurl+"'");
            if(rs.next()){
                wsregisteid = rs.getInt("id");
            }
            if(wsregisteid == 0){//webserviceurl在webservice注册表中不存在则新增
            	rs.execute("insert into wsregiste(customname,webserviceurl) values('"+actionname+"','"+wsurl+"') ");
	            rs.execute("select max(id) from wsregiste");
	            rs.next();
	            wsregisteid = rs.getInt(1);
            }
        }
        //webservice方法表信息
        if(!wsoperation.equals("")){
            rs.executeSql("select id from wsregistemethod  where methodname='"+wsoperation+"'");
            if(rs.next()){
                wsregistemethod = rs.getInt("id");
            }
            if(wsregistemethod == 0){
                String returnType = rettype.equals("0")?"string":"";
	            rs.execute("insert into wsregistemethod(mainid,methodname,methodreturntype) values('"+wsregisteid+"','"+wsoperation+"','"+returnType+"') ");
	            rs.execute("select max(id) from wsregistemethod");
	            rs.next();
	            wsregistemethod = rs.getInt(1);
            }
        }
        //webservice方法参数表
        if(!inpara.equals("")){
            int param = 0;
            rs.execute("select id from wsregistemethodparam where methodid='"+wsregistemethod+"' and paramname='"+inpara+"'");
            if(rs.next()){
                param = rs.getInt(1);
            }
            if(param == 0)
            	rs.execute("insert into wsregistemethodparam(methodid,paramname,paramtype,isarray) values('"+wsregistemethod+"','"+inpara+"','string','0')");
        }
        if(wsregisteid > 0 && wsregistemethod > 0){
        	rs.execute("update wsformactionset set wsurl='"+wsregisteid+"',wsoperation='"+wsregistemethod+"' where id="+id);
        }
    }
    /*
    if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
        RecordSet.executeSql("update wsformactionset set wsurl=(select id from wsregiste where webserviceurl=wsurl) where not exists (select 1 from wsformactionset t1 join wsregiste t2 on t1.wsurl = to_char(t2.id) where wsformactionset.id=t1.id)");
    }else{
        RecordSet.executeSql("update wsformactionset set wsurl=(select id from wsregiste where webserviceurl=wsurl) where not exists (select 1 from wsformactionset t1 join wsregiste t2 on t1.wsurl = convert(varchar(1000),t2.id) where wsformactionset.id=t1.id)");
    }
    */
} else if(operate.equals("dml")) {
	if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())) {
        RecordSet.executeSql("select a.id, a.formid from formactionset a, formactionsqlset b where a.id = b.actionid and a.formid < 0 and instr(b.actiontable, -a.formid) = 0 ");
    } else {
        RecordSet.executeSql("select a.id, a.formid from formactionset a, formactionsqlset b where a.id = b.actionid and a.formid < 0 and charindex(cast(-a.formid as varchar), b.actiontable) = 0");
    }
	
	while(RecordSet.next()) {
		String id = Util.null2String(RecordSet.getString("id"));
      	int formid = Util.getIntValue(Util.null2String(RecordSet.getString("formid")));
      	//System.err.println("update formactionsqlset set actiontable = 'formtable_main_"+(-formid)+"' where actionid = '"+id+"' ");
		RecordSet.executeSql("update formactionsqlset set actiontable = 'formtable_main_"+(-formid)+"' where actionid = '"+id+"' ");
	}
}
response.sendRedirect("/system/upgradeinit/InitInterfaces.jsp");
%>