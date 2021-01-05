
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%
    String action = Util.null2String(request.getParameter("action"));
	String excludeIds = "10, 11, 64, 6, 56, 5, 3, 26,235,242,243,246,224,225,14,15,267,261,258,264,265,33,266";
    String noneedtree = Util.null2String(request.getParameter("noneedtree"));
	if(noneedtree.equals("1")){
		excludeIds += ",256,257";
	}
	if(action.equals("queryHead")){
	    String sql = "select id,labelname from workflow_browsertype where useable is null or useable = 1 order by orderid";
	    RecordSet.executeSql(sql);
	    JSONObject map = new JSONObject();
	    JSONArray array = new JSONArray();
	    while(RecordSet.next()){
	    	JSONObject obj = new JSONObject();
	    	obj.put("key",RecordSet.getString("id"));
	    	obj.put("value",RecordSet.getString("labelname"));
	    	array.add(obj);
	    }
	    map.put("map",array);
		response.getWriter().println(map.toString());
	}else if(action.equals("queryContent")){
		User user = HrmUserVarify.getUser (request , response) ;
		JSONArray groupAll = new JSONArray();
		Map<String,JSONObject> groupMap = new HashMap<String,JSONObject>();
		ArrayList<String>  groupids = new ArrayList<String>();
		Map<String,JSONArray>  itemsMap = new HashMap<String,JSONArray>();
		String sql = "select id,labelname,orderid from workflow_browsertype where useable = 1";
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
	    	JSONObject group = new JSONObject();
	    	group.put("groupname",RecordSet.getString("labelname"));
	    	group.put("groupid",RecordSet.getString("id"));
	    	group.put("grouporderid",RecordSet.getString("orderid"));
	    	groupids.add(RecordSet.getString("id"));
	    	groupMap.put(RecordSet.getString("id"),group);
	    	itemsMap.put(RecordSet.getString("id"),new JSONArray());
	    }	
		sql = "update workflow_browserurl set typeid = 13 where typeid is null";
		RecordSet.executeSql(sql);
		sql = "update workflow_browserurl set orderid = 0 where orderid is null";
		RecordSet.executeSql(sql);
		
		//144104树形浏览框字段暂时在流程表单新建时隐藏
		String isFromMode = Util.null2String(request.getParameter("isFromMode"));
		//if(!isFromMode.equals("1")){
		//	excludeIds += ",256,257";
		//}
		
		sql = "select w.typeid as groupid,w.id as itemid,w.labelid as itemlabel,w.orderid as orderid from  workflow_browserurl w left join HtmlLabelInfo h on w.labelid=h.indexid where h.languageid=7 and w.id not in ("+excludeIds+") and w.browserurl is not null and w.useable = 1 and w.browserurl is not null order by groupid,orderid desc";
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
	    	JSONObject obj = new JSONObject();
	    	obj.put("key",RecordSet.getString("itemid"));
	    	obj.put("itemorderid",RecordSet.getString("orderid"));
	    	obj.put("value",SystemEnv.getHtmlLabelName(RecordSet.getInt("itemlabel"),user.getLanguage()));
	    	if(null != itemsMap.get(RecordSet.getString("groupid"))){
	    		itemsMap.get(RecordSet.getString("groupid")).add(obj);
	    	}
	    }	
		for(String groupid:groupids){
		  if(null != itemsMap.get(groupid)){
			groupMap.get(groupid).put("items",sortArray(itemsMap.get(groupid),"itemorderid"));
		  }
		}
		groupAll = JSONArray.fromObject(groupMap.values());
		groupAll = sortArray(groupAll,"grouporderid");
		response.getWriter().println("{'groups':"+groupAll.toString()+"}");
	}else if(action.equals("delete")){
		String ids = request.getParameter("ids");
		String idArray[] = ids.split(",");
		String undoIds = "";
		if(null != ids&&ids.length()>0){
			for(int i = 0;i<idArray.length;i++){
				RecordSet.executeSql("select * from workflow_browserurl  where typeid ="+idArray[i]);
				if(RecordSet.next()){
					if(undoIds.equals("")){
						undoIds = idArray[i];
					}else{
						undoIds += ","+idArray[i];
					}
				}
			}
            if(ids.length()>0){
			String sql = "delete from workflow_browsertype where id in ("+ids+")";
			if(undoIds.length()>0){
				sql+=" and id not in("+undoIds+")";
			}			   
			RecordSet.executeSql(sql);
            }
		}
		out.println("{undoIds:'"+undoIds+"'}");
	}else if(action.equals("addrow")){
		String sql = "insert into workflow_browsertype(labelname,useable,changeable,orderid) values (' ',1,1,0)";
		RecordSet.executeSql(sql);
		sql = "select max(id) as id from workflow_browsertype";
		RecordSet.executeSql(sql);
		if(RecordSet.next()){
			response.getWriter().println(RecordSet.getString("id"));
		}
	}
%>
<%!
   public JSONArray sortArray(JSONArray array,String orderby){
		JSONArray returnval = new JSONArray();
		int[] groupids = new int[array.size()];
		for(int i = 0 ; i < array.size(); i++){
			JSONObject obj = (JSONObject)array.get(i);
			groupids[i] = Integer.parseInt(obj.get(orderby).toString());		
		}
		Arrays.sort(groupids);
        for(int i = 0 ; i < groupids.length; i++){
        	for(int j=0 ; j< array.size() ; j++){
        		JSONObject obj = (JSONObject)array.get(j);
        		int arrayId = Integer.parseInt(obj.get(orderby).toString());
        		if(arrayId == groupids[i]){
        			returnval.add(obj);
        		}
        	}
        }
		return returnval;
   }
%>