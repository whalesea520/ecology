<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*,java.text.*,weaver.matrix.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.page.maint.layout.PageLayoutUtil"%>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.homepage.cominfo.HomepageBaseLayoutCominfo"%>
<jsp:useBean id="baseB" class="weaver.general.BaseBean" scope="page" />

<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
char flag=Util.getSeparator();
int userid=user.getUID();
request.setCharacterEncoding("UTF-8");
String dirLayout=pc.getConfig().getString("layout.path");
String layoutid=request.getParameter("layoutid");
String layoutname=Util.null2String(request.getParameter("layoutname"));
String layoutdesc=Util.null2String(request.getParameter("layoutdesc"));
if("".equals(layoutdesc)){
	layoutdesc = " ";
}
String layouttemplate=request.getParameter("layouttemplate");
String cellmergeinfo=request.getParameter("cellmergeinfo");
String layouttable=request.getParameter("layouttable");
String ftlname=UUID.randomUUID().toString()+".htm";
String sql = "";

try{	
	if(!"".equals(layoutid) && layoutid != null){
		rs.execute("select ftl  from pagelayout where id='"+layoutid+"'");
        if(rs.next()){
        	ftlname=rs.getString("ftl");
        }
	}

	PageLayoutUtil plu = new PageLayoutUtil();
	boolean issuccess=plu.replaceLayoutTemplateForLayoutDesign(dirLayout,layouttemplate,ftlname);
	baseB.writeLog("issuccess"+issuccess);
	if(issuccess){
	    if(!"".equals(layoutid) && layoutid != null){
	    	sql = "update pagelayout set  layoutname=?, layoutdesc=?, layouttable=?,cellmergeinfo=?,allowArea=?, ftl=?,layoutdir='',zipname=''  where id=?";
	    	
	    	rs.executeUpdate(sql,new Object[]{layoutname,layoutdesc,layouttable,cellmergeinfo,plu.getAllowArea(),ftlname,layoutid});

			//baseB.writeLog("aaaaaaaaa========="+layoutid+"update pagelayout");

	    	//往 hpbaselayout 表中更新数据，保持 hpbaselayout  与 pagelayout 表字段id 一致
	    	
	    	//查询现有的areaflag，若是新布局中有，则保留，否则删除，并将新布局中新增的areaflag插入到hpLayout中	    
	    	//此处为防止hpLayout中部分历史数据layoutbaseid不一致问题，查询、插入、删除均使用hpinfo的layoutid来判断布局id
	    	String[] tmpArr = plu.getAllowArea().split(",");
	    	Set<String> newAreaFlags = new HashSet<String>();
	    	for(String tmpS : tmpArr){
	    		newAreaFlags.add(tmpS);
	    	}
	    	sql = "select areaflag from hpLayout a where a.hpid=(select max(id) from hpinfo where layoutid=?)";
	    	rs.executeQuery(sql,new Object[]{layoutid});
	    	
	    	boolean hasData= false;
	    	while(rs.next()){
	    		hasData= true;
	    		if(newAreaFlags.contains(rs.getString(1))){
	    			newAreaFlags.remove(rs.getString(1));
	    		}
	    	}
	    	if(hasData){//有数据进行，否则下面代码无用。
		    	//布局中多出来的areaFlag插入hpLayout每个areaflag用一条sql插入
		    	for(String tmpS : newAreaFlags){
		    		sql = "insert into hpLayout(hpid,layoutbaseid,areaflag,userid,usertype,areasize,areaElements) select hpid,"+layoutid+",'"+tmpS+"',userid,usertype,'','' from hpLayout th where exists(select 1 from hpinfo tb where tb.layoutid=? and tb.id=th.hpid) group by hpid,userid,usertype";
		    		rs.executeUpdate(sql,new Object[]{layoutid});
		    		baseB.writeLog("newAreaFlag:"+sql);
		    	}
		    	//在hpLayout中删除更新后的布局库中已经不存在的areaflag
		    	sql="delete from hpLayout where areaflag not in ('"+plu.getAllowArea().replaceAll(",","','")+"') and exists(select 1 from hpinfo tb where tb.layoutid=? and tb.id=hpid)";
		    	rs.executeUpdate(sql,new Object[]{layoutid});
		    	baseB.writeLog("deleteOldAreaFlag:"+sql);
	    	}
	    	
	    	//rs.execute("update pagelayout set  layoutname='"+layoutname+"', layoutdesc='"+layoutdesc+"', layouttable='"+layouttable+"',cellmergeinfo='"+cellmergeinfo+"',allowArea='"+plu.getAllowArea()+"', ftl='"+ftlname+"'  where id='"+layoutid+"'");
	    }else{
	    	
			//获取id
			sql = "insert into pagelayout (layoutname,layoutdesc,layouttable,cellmergeinfo,allowArea,ftl,layouttype,layoutdir,zipname,layoutimage,layoutcode) values(?,?,?,?,?,?,?,?,?,-1,-1)";
	    	
	    	rs.executeUpdate(sql,new Object[]{layoutname,layoutdesc,layouttable,cellmergeinfo,plu.getAllowArea(),ftlname,"design","",""});
	    	baseB.writeLog("aaaaaaaaaaaa=inserted");
	    }
	  //更新缓存
		HomepageBaseLayoutCominfo hpblc=new HomepageBaseLayoutCominfo();	
		hpblc.updateHomepageLayoutCache();
		
	}
	out.println("{\"success\":\""+layoutid+"\"}");
}catch(Exception e){
	e.printStackTrace();
    //baseB.writeLog("aaaaaaaaa========"+e.getMessage());
	out.println("{\"success\":\"0\"}");
}



%>