<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.UserManager"%>
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.docs.news.DocNewsManager"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.share.ShareManager"%>
<%@ page import="net.sf.json.JSONArray"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page"/>
<%!
public static final int COLUMN_CUSTOM = 0;//自定义

public static final int COLUMN_NEWEST = -1;//最新

public static final int COLUMN_HOT = -2;//最热

public static final int COLUMN_UNREAD = -3;//未读

public static final int COLUMN_MINE = -4;//我的

/**
 * 获取查看文档列表的sql，参考weaver.mobile.plugin.ecology.service.DocumentService中的getDocumentList2
 * @param module 2:新闻中心 3:文档中心
 * @param user
 * @param pageIndex
 * @param pageSize
 * @param columnid
 * @param conditions
 * @return
 */
public Map<String, Object> getDocumentListQuerySql(int module, User user, int pageIndex, int pageSize, int columnid, List<String> conditions){
	Map<String, Object> result = new HashMap<String, Object>();
	try{
		String baseSql = "";
		String fields = "";
		String orderby = "";
		RecordSet rs = new RecordSet();
		ShareManager shareManager = new ShareManager();
		
		if (rs.getDBType().equals("oracle")) {
			fields = " t1.*,t2.sharelevel,t3.doccontent ";
			baseSql = " from DocDetail t1,"+shareManager.getShareDetailTableByUser("doc", user)+" t2,DocDetailContent t3 where t1.id = t2.sourceid and t1.id = t3.docid ";
		} else {
			fields = " t1.*,t2.sharelevel ";
			baseSql = " from DocDetail t1,"+shareManager.getShareDetailTableByUser("doc", user)+" t2 where t1.id = t2.sourceid ";
		}

		baseSql += " and t1.seccategory <> 0 and (t1.ishistory is null or t1.ishistory = 0) ";
		
		if(module == 3 && columnid == COLUMN_MINE) {
			baseSql += " and (t1.doccreaterid = "+user.getUID()+" or t1.ownerid = "+user.getUID()+") ";
		} else {
			baseSql += " and ((t1.docstatus = 7 and (t2.sharelevel>1 or (t1.doccreaterid="+user.getUID()+")) ) or t1.docstatus in ('1','2','5')) ";
		}
		
		String settingWhere = getSettingSql(columnid);
		if(columnid == COLUMN_CUSTOM
				|| columnid == COLUMN_NEWEST
				|| columnid == COLUMN_HOT
				|| columnid == COLUMN_UNREAD
				|| columnid == COLUMN_MINE
				|| (columnid > 0 && settingWhere != null)) {
			baseSql += StringUtils.trimToEmpty(settingWhere);
			
			if(conditions != null && conditions.size() > 0) {
				for(String condition : conditions) {
					if(StringUtils.isBlank(condition)) continue;
					baseSql += " and " + condition + " ";
				}
			}
			
			if(module == 3 && columnid == COLUMN_UNREAD) {
				baseSql += " and t1.doccreaterid <> "+user.getUID()+" and not exists (select 1 from docReadTag where userid="+user.getUID()+" and docid = t1.id) ";
			}
			
			if(columnid == COLUMN_NEWEST
					|| columnid == COLUMN_HOT
					|| columnid == COLUMN_UNREAD
					|| columnid == COLUMN_MINE) {
				baseSql += " and (t1.isreply is null or t1.isreply <> 1) ";
			}

			orderby = " order by t1.doclastmoddate desc, t1.doclastmodtime desc, t1.id desc";
			if(module == 3 && columnid == COLUMN_HOT) orderby = " order by t1.sumReadCount desc, t1.id desc";
			if(module == 3 && columnid == COLUMN_NEWEST) orderby = " order by t1.doccreatedate desc, t1.doccreatetime desc, t1.id desc";
			
			result.put("fromsql", baseSql);
			result.put("backfields", fields);
			result.put("orderby", orderby);
		}
	}catch (Exception e) {
		e.printStackTrace();
	}
	return result;
}
	
private String getSettingSql(int columnid) throws Exception {
	if(columnid <= 0) return null;
	
	String where = null;
	RecordSet rs = new RecordSet();
	RecordSet rs1 = new RecordSet();
	
	rs.executeSql("SELECT * FROM MobileDocSetting WHERE columnid="+columnid);
	if(rs.next()) {
		where = "";
		int source = rs.getInt("source");
		int isreplay = rs.getInt("isreplay");

		if (source == 1) {
			//来源新闻中心
			rs1.executeSql("SELECT docid FROM MobileDocColSetting WHERE columnid="+columnid);
			if(rs1.next()) {
				DocNewsManager dnm = new DocNewsManager();
				dnm.setId(rs1.getInt("docid"));
				dnm.getDocNewsInfoById();
				
				where = dnm.getNewsclause();
				where = StringUtils.isNotBlank(where) ? " and "+where : "";
				where += " and t1.docpublishtype in ('2','3') ";
			}
		} else if (source == 2) {
			//来源文档目录
			rs1.executeSql("SELECT docid FROM MobileDocColSetting WHERE columnid="+columnid);
			if(rs1.next()) {
				where = " and exists (select id from docseccategory where id = t1.seccategory and id in (select docid from MobileDocColSetting where columnid="+columnid+"))";
			}
		} else if (source == 3) {
			//来源虚拟目录
			rs1.executeSql("SELECT docid FROM MobileDocColSetting WHERE columnid="+columnid);
			if(rs1.next()) {
				where = " and exists (select 1 from DocDummyDetail where docid = t1.id and catelogid in (select docid from MobileDocColSetting where columnid="+columnid+")) ";
			}
		} else if (source == 4) {
			//来源指定文档
			List<String> docids = new ArrayList<String>();
			rs1.executeSql("SELECT docid FROM MobileDocColSetting WHERE columnid="+columnid);
			while(rs1.next()) {
				String docid = rs1.getString("docid");
				String newdocid = docid;
				
				RecordSet rs3 = new RecordSet();
				rs3.executeSql("select doceditionid from docdetail where id=" + docid);
				if(rs3.next()) {
					int editionid = rs3.getInt("doceditionid");
					if (editionid > 0) {
						rs3.executeSql("select id from docdetail where docedition=(select max(docedition) from docdetail where doceditionid=" + editionid + ") and doceditionid=" + editionid);
						if(rs3.next()) {
							newdocid = rs3.getString("id");
						}
					}
				}
				
				docids.add(newdocid);
			}
			
			if(docids != null && docids.size() > 0) where = " and t1.id in (" + StringUtils.join(docids, ',') + ") ";
		}
		
		if(isreplay != 1){
			where += " and (t1.isreply is null or t1.isreply <> 1) ";
		}
	}
	
	return where;
}
%>
<%
try{
	out.clear();
	int _userid = Util.getIntValue(request.getParameter("userid"));
	UserManager userManager = new UserManager();
	User user = userManager.getUserByUserIdAndLoginType(_userid, "1");
	String sql = "";
	
	int parentid = Util.getIntValue(request.getParameter("parentid"),-1);
	int module = 2;//2:新闻中心
	int columnid = 0;
	
	int _pageNo = 1;
	int _pagesize = 10;
	
	List<String> conditions = new ArrayList<String>();
	if(parentid>0){
		conditions.add("t1.seccategory="+parentid);
	}
	conditions.add("(t1.isreply is null or t1.isreply='' or t1.isreply=0)");
	
	Map<String, Object> result = getDocumentListQuerySql(module, user, _pageNo, _pagesize, columnid, conditions);
	
	String fromsql = StringHelper.null2String(result.get("fromsql"));
	String backfields = StringHelper.null2String(result.get("backfields"));
	String orderby = StringHelper.null2String(result.get("orderby"));
	String querysql = "select "+backfields+" "+fromsql;
	
	//获取列表数据
	List<Map<String, String>> imglist = new ArrayList<Map<String, String>>();
	
	int currentpage = _pageNo;
	int pagesize = _pagesize;
	int iNextNum = currentpage * pagesize;
	
	if(rs.getDBType().equals("oracle")){
 		sql = "select rownum rownum_,t1.* from(" + querysql + " "+orderby+" nulls last) t1 ";
 		sql = "select * from ("+sql+") t12 where rownum_ > " + (iNextNum - pagesize) + " and rownum_ <= " + iNextNum;
 	}else{
 		sql = "select ROW_NUMBER() OVER ("+orderby+") AS rownum_,* from (" + querysql + ") t1 ";
 		sql = "select * from (" + sql + ") t12 where rownum_> " + (iNextNum - pagesize) + " and rownum_ <= " + iNextNum;
 	}
	rs.executeSql(sql);
	
	while(rs.next()){
		String docid = rs.getString("id");
		
		String docsubject_tmp = rs.getString("docsubject");
		docsubject_tmp = docsubject_tmp.replaceAll("\n", "");// TD11607
		
		
		String docimg = "";
		sql = "select i.imagefileid from docimagefile di,imagefile i where di.imagefileid=i.imagefileid and di.docid="+docid+" and di.docfiletype='1' order by i.imagefileid";
		rs1.execute(sql);
		if(rs1.next()) {
			docimg = rs1.getString("imagefileid");
		}
			
		if(currentpage == 1 && Util.getIntValue(docimg) > 0 && imglist.size() < 5) {
			Map<String, String> img = new HashMap<String, String>();
			String action = "try{slideImgClick("+docid+");}catch(e){}";
			String pic_path = "/weaver/weaver.file.FileDownload?fileid="+docimg;
			String pic_desc = docsubject_tmp;
			
			img.put("action", action);
			img.put("pic_path", pic_path);
			img.put("pic_desc", pic_desc);
			imglist.add(img);
		}
	}
	if(imglist.size()==0){
		out.print("[{}]");
	}else{
		JSONArray imgArray = JSONArray.fromObject(imglist);
		//System.out.println(imgArray.toString());
		out.print(imgArray.toString());
	}
}catch(Exception e){
	out.print("error: "+e.toString());
}
out.flush();
out.close();
%>