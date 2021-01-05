<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.UserManager"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.jsoup.Jsoup"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.mobile.plugin.ecology.service.DocumentService"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="cici" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="sptmForDoc" class="weaver.splitepage.transform.SptmForDoc" scope="page"/>
<jsp:useBean id="formatter" class="weaver.mobile.HtmlToPlainText" scope="page"/>
<%!
private String getDocTypeByDocId(String docid,String docextendname,String doccontent){
	BaseBean baseBean = new BaseBean();
	String doctype=docextendname;
	try {
		if((!"".equals(docextendname))&&(!"html".equals(docextendname))){
			return doctype;
		}
		//html编辑框有内容则返回html
		int tmppos = doccontent.indexOf("!@#$%^&*");
		if(tmppos!=-1){
			doccontent = doccontent.substring(tmppos+8,doccontent.length());
		}
		//替换HTML标签
		String strDoccontent=Util.replace(doccontent,"<[^>]*>","",0);
		//替换空字符串
		strDoccontent=Util.replace(strDoccontent,"&nbsp;","",0);
		//替换换行
		strDoccontent=Util.replace(strDoccontent,"\r\n","",0);
	    //替换空格
		strDoccontent=Util.replace(strDoccontent," ","",0);
		if("initFlashVideo();".equals(strDoccontent)||"".equals(strDoccontent)){
			int fileNum=0;
			RecordSet rs = new RecordSet();
			rs.executeSql("select count(distinct id) as fileNum  from DocImageFile where docid="+docid);
			if(rs.next()){
				fileNum=Util.getIntValue(rs.getString("fileNum"));
			}
			if(fileNum==1){
				rs.executeSql("select imageFileName  from DocImageFile where docid="+docid+" order by imageFileId desc");
				if(rs.next()){
					String imageFileName=Util.null2String(rs.getString("imageFileName"));
					if(imageFileName.lastIndexOf(".")>=0){
						if(!(imageFileName.endsWith("."))){
							doctype=imageFileName.substring(imageFileName.lastIndexOf(".")+1);					
						}
					}						
				}
			}
		}else{
			return doctype;
		}
		
	}catch (Exception e) {
		baseBean.writeLog(e);
	}
	return doctype;
}
/**
 * @param extendName - 文件扩展名
 * @return 根据扩展名返回相应文件类型的图标路径 
 * 
 * 根据扩展名返回相应文件类型的图标路径
 * 
 */
public static String getIconPathByExtendName(String extendName) {
    String returnValue="universal_icon_wev8.png";
    RecordSet rs = new RecordSet();
    
    rs.executeSql("select iconPath from workflow_filetypeicon where extendName='"+extendName.toLowerCase()+"'"); 
    if (rs.next())
    	returnValue=rs.getString(1);           
    
    return returnValue;
}
%>
<%
try{
	out.clear();
	int _userid = Util.getIntValue(request.getParameter("userid"));
	UserManager userManager = new UserManager();
	User user = userManager.getUserByUserIdAndLoginType(_userid, "1");
	String operation = Util.null2String(request.getParameter("operation"));
	String sql = "";
	StringBuffer restr = new StringBuffer();
	//获取列表数据
	List<Map<String, String>> imglist = new ArrayList<Map<String, String>>();
	
	String querysql = (String)request.getSession().getAttribute("DOC_LIST_SQL");
	String orderby = Util.null2String((String)request.getSession().getAttribute("DOC_LIST_SQL_ORDERBY")).trim();
	int module = Util.getIntValue(request.getParameter("module"));
	int columnid = Util.getIntValue(request.getParameter("columnid"));
	
	int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
	int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
	int total = Util.getIntValue(request.getParameter("total"),0);
	int iNextNum = currentpage * pagesize;
	
	if(rs.getDBType().equals("oracle")){
 		sql = "select rownum rownum_,t1.* from(" + querysql + " "+orderby+" nulls last) t1 ";
 		sql = "select * from ("+sql+") t12 where rownum_ > " + (iNextNum - pagesize) + " and rownum_ <= " + iNextNum;
 	}else{
 		sql = "select ROW_NUMBER() OVER ("+orderby+") AS rownum_,* from (" + querysql + ") t1 ";
 		sql = "select * from (" + sql + ") t12 where rownum_> " + (iNextNum - pagesize) + " and rownum_ <= " + iNextNum;
 	}
	rs.executeSql(sql);
	restr.append("{\"totalSize\":"+total+",\"datas\":[");
	
	int _index = 0;
	while(rs.next()){
		_index++;
		Map<String, String> doc = new HashMap<String, String>();
		String docid = rs.getString("id");
		doc.put("docid", docid);
		
		String docsubject_tmp = rs.getString("docsubject");
		docsubject_tmp = docsubject_tmp.replaceAll("\n", "");// TD11607
		doc.put("docsubject",docsubject_tmp);
		
		String ownerid = rs.getString("ownerid");
		String owner = rs.getInt("ownerType") == 1 ? rci.getResourcename(ownerid) : cici.getCustomerInfoname(ownerid);
		doc.put("ownerid", ownerid);
		doc.put("owner", owner);
		doc.put("ownermobile", rci.getMobile(ownerid));
		doc.put("ownerloginid", rci.getLoginID(ownerid));
		doc.put("doccreatedate", rs.getString("doccreatedate")+" "+rs.getString("doccreatetime"));
		
		sql = "select count(0) as c from DocDetail t where t.id="+docid+" and t.doccreaterid<>"+user.getUID()+" and not exists (select 1 from docReadTag where userid="+user.getUID()+" and docid=t.id)";
		rs1.execute(sql);
		if(rs1.next()&&rs1.getInt("c")>0) {
			doc.put("isnew", "1");
		} else {
			doc.put("isnew", "0");
		}
		
		String doccontent = Util.null2String(rs.getString("doccontent"));						
		String docextendname=Util.null2String(rs.getString("docextendname"));
		String doctype=getDocTypeByDocId(docid,docextendname,doccontent);
		doc.put("doctype", doctype);
		String iconpath = getIconPathByExtendName(doctype);
		doc.put("iconpath",iconpath);
		
		if(module == 2) {
			String docimg = "";
			sql = "select i.imagefileid from docimagefile di,imagefile i where di.imagefileid=i.imagefileid and di.docid="+docid+" and di.docfiletype='1' order by i.imagefileid";
			rs1.execute(sql);
			if(rs1.next()) {
				docimg = rs1.getString("imagefileid");
			}
			
			doc.put("docimg", docimg);
			
			String summary = "";
			
			if(StringUtils.isNotBlank(doccontent)) {
				int tmppos = doccontent.indexOf("!@#$%^&*");
				if(tmppos!=-1){
					summary = doccontent.substring(0,tmppos);
				} else {
					summary = formatter.getPlainText(Jsoup.parse(doccontent));
					summary = StringUtils.replace(summary, "\n", "");
				}
				summary = (summary.length()) > 100 ? summary.substring(0, 100) : summary;
			}
			
			doc.put("summary", summary);
			
			if(currentpage == 1 && Util.getIntValue(docimg) > 0 && imglist.size() < 5) {
				Map<String, String> img = new HashMap<String, String>();
				img.put("docimg", docimg);
				img.put("docid", docid);
				img.put("docsubject", docsubject_tmp);
				imglist.add(img);
			}
		} else {
			if(columnid == DocumentService.COLUMN_MINE) {
				int docstatus = rs.getInt("docstatus");
				doc.put("docstatusid", ""+docstatus);
				
				int seccategory = rs.getInt("seccategory");
				String docstatusname = sptmForDoc.getDocStatus3(docid, ""+user.getLanguage()+"+"+docstatus+"+"+seccategory);
				doc.put("docstatus", docstatusname);
			}
		}
		doc.put("showtype","0");
		JSONObject jsonObject = JSONObject.fromObject(doc);
		
		if(_index>1){
			restr.append(",");
		}
		restr.append(jsonObject.toString());
	}
	restr.append("]}");
	out.print(restr.toString());
}catch(Exception e){
	out.print("error: "+e.toString());
}
out.flush();
out.close();
%>