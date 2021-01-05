<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%! 
/**
 * 把所有分部组合成的树放到集合中
 * @return
 */
private LinkedHashMap<String,LinkedHashMap<String, String>> getShowMap(LinkedHashMap<String,LinkedHashMap<String, String>> dataMap,
		LinkedHashMap<String,LinkedHashMap<String, String>> treeMap,
		String subcompanyids){
    LinkedHashMap<String,LinkedHashMap<String, String>> resultMap = new LinkedHashMap<String,LinkedHashMap<String, String>>();
    LinkedHashMap<String,String> curMap = null;
    LinkedHashMap<String, String> tempCurDataMap = null;
    LinkedHashMap<String, String> tempSupDataMap = null;
    
    ListIterator<Map.Entry<String,LinkedHashMap<String,String>>> i=new ArrayList<Map.Entry<String,LinkedHashMap<String,String>>>(treeMap.entrySet()).listIterator(treeMap.size());
    while(i.hasPrevious()) {
    	Entry<String,LinkedHashMap<String,String>> obj=i.previous();
        curMap = obj.getValue();
        //如果是第1层级分部
        if("1".equals(curMap.get("level"))){
        	//判断值是否为空
        	if(dataMap.get(obj.getKey()) == null){
                continue;
            }
        	//如果现在没有设置子级分部则设置无下级分部
        	if(dataMap.get(obj.getKey()).get("hasSub")==null){
                dataMap.get(obj.getKey()).put("hasSub","no");
            }
        	//如果subcompanyids是空或包含则添加
        	if(subcompanyids == null || "".equals(subcompanyids) || (","+subcompanyids+",").contains(","+obj.getKey()+",")){
            	resultMap.put(obj.getKey(),dataMap.get(obj.getKey()));
        	}
        }else{
        	//得到当前数据
        	tempCurDataMap = dataMap.get(curMap.get("id"));
        	//得到父级数据
        	tempSupDataMap = dataMap.get(curMap.get("supsubcomid"));
        	if(tempCurDataMap == null || tempSupDataMap == null){
        		continue;
        	}
            tempSupDataMap.put("exist",(Integer.parseInt(tempCurDataMap.get("exist"))+Integer.parseInt(tempSupDataMap.get("exist")))+"");
            tempSupDataMap.put("without",(Integer.parseInt(tempCurDataMap.get("without"))+Integer.parseInt(tempSupDataMap.get("without")))+"");
            tempSupDataMap.put("scoring",(Integer.parseInt(tempCurDataMap.get("scoring"))+Integer.parseInt(tempSupDataMap.get("scoring")))+"");
            tempSupDataMap.put("assessing",(Integer.parseInt(tempCurDataMap.get("assessing"))+Integer.parseInt(tempSupDataMap.get("assessing")))+"");
            tempSupDataMap.put("back",(Integer.parseInt(tempCurDataMap.get("back"))+Integer.parseInt(tempSupDataMap.get("back")))+"");
            tempSupDataMap.put("finish",(Integer.parseInt(tempCurDataMap.get("finish"))+Integer.parseInt(tempSupDataMap.get("finish")))+"");
            tempSupDataMap.put("oscoring",(Integer.parseInt(tempCurDataMap.get("oscoring"))+Integer.parseInt(tempSupDataMap.get("oscoring")))+"");
            tempSupDataMap.put("oassessing",(Integer.parseInt(tempCurDataMap.get("oassessing"))+Integer.parseInt(tempSupDataMap.get("oassessing")))+"");
            tempSupDataMap.put("oback",(Integer.parseInt(tempCurDataMap.get("oback"))+Integer.parseInt(tempSupDataMap.get("oback")))+"");
            //设置父级有子分部
        	tempSupDataMap.put("hasSub","yes");
        }        
    }
    return resultMap;
}

/**
 * 把所有分部组合成的树放到集合中
 * @return
 */
private LinkedHashMap<String,LinkedHashMap<String, String>> getShowMap2(LinkedHashMap<String,LinkedHashMap<String, String>> dataMap,
		LinkedHashMap<String,LinkedHashMap<String, String>> treeMap,
		String subcompanyids){
    LinkedHashMap<String,LinkedHashMap<String, String>> resultMap = new LinkedHashMap<String,LinkedHashMap<String, String>>();
    LinkedHashMap<String,String> curMap = null;
    LinkedHashMap<String, String> tempCurDataMap = null;
    LinkedHashMap<String, String> tempSupDataMap = null;
    
    ListIterator<Map.Entry<String,LinkedHashMap<String,String>>> i=new ArrayList<Map.Entry<String,LinkedHashMap<String,String>>>(treeMap.entrySet()).listIterator(treeMap.size());
    while(i.hasPrevious()) {
    	Entry<String,LinkedHashMap<String,String>> obj=i.previous();
        curMap = obj.getValue();
        //如果是第1层级分部
        if("1".equals(curMap.get("level"))){
        	//判断值是否为空
        	if(dataMap.get(obj.getKey()) == null){
                continue;
            }
        	//如果现在没有设置子级分部则设置无下级分部
        	if(dataMap.get(obj.getKey()).get("hasSub")==null){
                dataMap.get(obj.getKey()).put("hasSub","no");
            }
        	//如果subcompanyids是空或包含则添加
        	if(subcompanyids == null || "".equals(subcompanyids) || (","+subcompanyids+",").contains(","+obj.getKey()+",")){
            	resultMap.put(obj.getKey(),dataMap.get(obj.getKey()));
        	}
        }else{
        	//得到当前数据
        	tempCurDataMap = dataMap.get(curMap.get("id"));
        	//得到父级数据
        	tempSupDataMap = dataMap.get(curMap.get("supsubcomid"));
        	if(tempCurDataMap == null || tempSupDataMap == null){
        		continue;
        	}
        }        
    }
    return resultMap;
}
/**
 * 把所有要展示的分部数据放到集合中
 * @return
 */
private LinkedHashMap<String,LinkedHashMap<String, String>> getSubcpyShowMap(LinkedHashMap<String,LinkedHashMap<String, String>> dataMap,
		LinkedHashMap<String,LinkedHashMap<String, String>> treeMap,
		String subCpyId){
    LinkedHashMap<String,LinkedHashMap<String, String>> resultMap = new LinkedHashMap<String,LinkedHashMap<String, String>>();
    LinkedHashMap<String,String> curMap = null;
    LinkedHashMap<String, String> tempCurDataMap = null;
    LinkedHashMap<String, String> tempSupDataMap = null;
    for (Entry<String,LinkedHashMap<String,String>> obj : treeMap.entrySet()) {
        curMap = obj.getValue();
        if(dataMap.get(obj.getKey()) == null){
            continue;
        }
        if("1".equals(curMap.get("level"))){
            continue;
        }else{  	
            tempCurDataMap = dataMap.get(curMap.get("id"));
            tempSupDataMap = dataMap.get(curMap.get("supsubcomid"));
            if(tempCurDataMap == null || tempSupDataMap == null){
                continue;
            }
            tempSupDataMap.put("exist",(Integer.parseInt(tempCurDataMap.get("exist"))+Integer.parseInt(tempSupDataMap.get("exist")))+"");
            tempSupDataMap.put("without",(Integer.parseInt(tempCurDataMap.get("without"))+Integer.parseInt(tempSupDataMap.get("without")))+"");
            tempSupDataMap.put("scoring",(Integer.parseInt(tempCurDataMap.get("scoring"))+Integer.parseInt(tempSupDataMap.get("scoring")))+"");
            tempSupDataMap.put("assessing",(Integer.parseInt(tempCurDataMap.get("assessing"))+Integer.parseInt(tempSupDataMap.get("assessing")))+"");
            tempSupDataMap.put("back",(Integer.parseInt(tempCurDataMap.get("back"))+Integer.parseInt(tempSupDataMap.get("back")))+"");
            tempSupDataMap.put("finish",(Integer.parseInt(tempCurDataMap.get("finish"))+Integer.parseInt(tempSupDataMap.get("finish")))+"");
            tempSupDataMap.put("oscoring",(Integer.parseInt(tempCurDataMap.get("oscoring"))+Integer.parseInt(tempSupDataMap.get("oscoring")))+"");
            tempSupDataMap.put("oassessing",(Integer.parseInt(tempCurDataMap.get("oassessing"))+Integer.parseInt(tempSupDataMap.get("oassessing")))+"");
            tempSupDataMap.put("oback",(Integer.parseInt(tempCurDataMap.get("oback"))+Integer.parseInt(tempSupDataMap.get("oback")))+"");
            tempSupDataMap.put("hasSub","yes");
            //如果subCpyId是空或包含则添加
            if(subCpyId.equals(curMap.get("supsubcomid"))){
            	tempCurDataMap.put("curtype","subcpy");
                resultMap.put(curMap.get("id"),tempCurDataMap);
            }
        }
        
    }
    return resultMap;
}
/**
 * 把所有要展示的分部数据放到集合中
 * @return
 */
private void getSubcpyShowMap(LinkedHashMap<String,LinkedHashMap<String, String>> dataMap,LinkedHashMap<String,LinkedHashMap<String, String>> treeMap){
    LinkedHashMap<String,String> curMap = null;
    LinkedHashMap<String, String> tempCurDataMap = null;
    LinkedHashMap<String, String> tempSupDataMap = null;
    for (Entry<String,LinkedHashMap<String,String>> obj : treeMap.entrySet()) {
        curMap = obj.getValue();
        if(dataMap.get(obj.getKey()) == null){
            continue;
        }
        if("1".equals(curMap.get("level"))){
            continue;
        }else{  	
            tempCurDataMap = dataMap.get(curMap.get("id"));
            tempSupDataMap = dataMap.get(curMap.get("supsubcomid"));
            if(tempCurDataMap == null || tempSupDataMap == null){
                continue;
            }
            tempSupDataMap.put("exist",(Integer.parseInt(tempCurDataMap.get("exist"))+Integer.parseInt(tempSupDataMap.get("exist")))+"");
            tempSupDataMap.put("without",(Integer.parseInt(tempCurDataMap.get("without"))+Integer.parseInt(tempSupDataMap.get("without")))+"");
            tempSupDataMap.put("scoring",(Integer.parseInt(tempCurDataMap.get("scoring"))+Integer.parseInt(tempSupDataMap.get("scoring")))+"");
            tempSupDataMap.put("assessing",(Integer.parseInt(tempCurDataMap.get("assessing"))+Integer.parseInt(tempSupDataMap.get("assessing")))+"");
            tempSupDataMap.put("back",(Integer.parseInt(tempCurDataMap.get("back"))+Integer.parseInt(tempSupDataMap.get("back")))+"");
            tempSupDataMap.put("finish",(Integer.parseInt(tempCurDataMap.get("finish"))+Integer.parseInt(tempSupDataMap.get("finish")))+"");
            tempSupDataMap.put("oscoring",(Integer.parseInt(tempCurDataMap.get("oscoring"))+Integer.parseInt(tempSupDataMap.get("oscoring")))+"");
            tempSupDataMap.put("oassessing",(Integer.parseInt(tempCurDataMap.get("oassessing"))+Integer.parseInt(tempSupDataMap.get("oassessing")))+"");
            tempSupDataMap.put("oback",(Integer.parseInt(tempCurDataMap.get("oback"))+Integer.parseInt(tempSupDataMap.get("oback")))+"");
            tempSupDataMap.put("hasSub","yes");
        }
        
    }
}
/**
 * 把所有要展示的分部数据放到集合中
 * @return
 */
private LinkedHashMap<String,LinkedHashMap<String, String>> getSubcpyShowMap2(LinkedHashMap<String,LinkedHashMap<String, String>> dataMap,
		LinkedHashMap<String,LinkedHashMap<String, String>> treeMap,
		String subCpyId){
    LinkedHashMap<String,LinkedHashMap<String, String>> resultMap = new LinkedHashMap<String,LinkedHashMap<String, String>>();
    LinkedHashMap<String,String> curMap = null;
    LinkedHashMap<String, String> tempCurDataMap = null;
    LinkedHashMap<String, String> tempSupDataMap = null;
    for (Entry<String,LinkedHashMap<String,String>> obj : treeMap.entrySet()) {
        curMap = obj.getValue();
        if(dataMap.get(obj.getKey()) == null){
            continue;
        }
        if("1".equals(curMap.get("level"))){
            continue;
        }else{  	
            tempCurDataMap = dataMap.get(curMap.get("id"));
            tempSupDataMap = dataMap.get(curMap.get("supsubcomid"));
            if(tempCurDataMap == null || tempSupDataMap == null){
                continue;
            }
            //如果subCpyId是空或包含则添加
            if(subCpyId.equals(curMap.get("supsubcomid"))){
            	tempCurDataMap.put("curtype","subcpy");
                resultMap.put(curMap.get("id"),tempCurDataMap);
            }
        }
        
    }
    return resultMap;
}


/**
* 把所有要展示的部门数据放到集合中
* @return
*/
private LinkedHashMap<String,LinkedHashMap<String, String>> getDeptShowMap(LinkedHashMap<String,LinkedHashMap<String, String>> dataMap,
    LinkedHashMap<String,LinkedHashMap<String, String>> treeMap,
    String subCpyId,
    String curtype){
	LinkedHashMap<String,LinkedHashMap<String, String>> resultMap = new LinkedHashMap<String,LinkedHashMap<String, String>>();
	LinkedHashMap<String,String> curMap = null;
	LinkedHashMap<String, String> tempCurDataMap = null;
	LinkedHashMap<String, String> tempSupDataMap = null;
	for (Entry<String,LinkedHashMap<String,String>> obj : treeMap.entrySet()) {
	    curMap = obj.getValue();
	    if(dataMap.get(obj.getKey()) == null){
	        continue;
	    }
	
	    tempCurDataMap = dataMap.get(curMap.get("id"));
	    tempSupDataMap = dataMap.get(curMap.get("superid"));
	    if(tempCurDataMap == null && tempSupDataMap == null){
	        continue;
	    }else if(tempCurDataMap != null && tempSupDataMap == null){
	    	if("subcpy".equals(curtype) && subCpyId.equals(curMap.get("subcompanyid1")) && "1".equals(curMap.get("level"))){
	    		tempCurDataMap.put("curtype","dept");
	            resultMap.put(curMap.get("id"),tempCurDataMap);
	        }
	    	continue;
	    }
	    
	    tempSupDataMap.put("exist",(Integer.parseInt(tempCurDataMap.get("exist"))+Integer.parseInt(tempSupDataMap.get("exist")))+"");
	    tempSupDataMap.put("without",(Integer.parseInt(tempCurDataMap.get("without"))+Integer.parseInt(tempSupDataMap.get("without")))+"");
	    tempSupDataMap.put("scoring",(Integer.parseInt(tempCurDataMap.get("scoring"))+Integer.parseInt(tempSupDataMap.get("scoring")))+"");
	    tempSupDataMap.put("assessing",(Integer.parseInt(tempCurDataMap.get("assessing"))+Integer.parseInt(tempSupDataMap.get("assessing")))+"");
	    tempSupDataMap.put("back",(Integer.parseInt(tempCurDataMap.get("back"))+Integer.parseInt(tempSupDataMap.get("back")))+"");
	    tempSupDataMap.put("finish",(Integer.parseInt(tempCurDataMap.get("finish"))+Integer.parseInt(tempSupDataMap.get("finish")))+"");
	    tempSupDataMap.put("oscoring",(Integer.parseInt(tempCurDataMap.get("oscoring"))+Integer.parseInt(tempSupDataMap.get("oscoring")))+"");
	    tempSupDataMap.put("oassessing",(Integer.parseInt(tempCurDataMap.get("oassessing"))+Integer.parseInt(tempSupDataMap.get("oassessing")))+"");
	    tempSupDataMap.put("oback",(Integer.parseInt(tempCurDataMap.get("oback"))+Integer.parseInt(tempSupDataMap.get("oback")))+"");
	    tempSupDataMap.put("hasSub","yes");
	    //如果subCpyId是空或包含则添加
	    if("subcpy".equals(curtype)){
	        if(subCpyId.equals(curMap.get("subcompanyid1")) && "1".equals(curMap.get("level"))){
	        	tempCurDataMap.put("curtype","dept");
	            resultMap.put(curMap.get("id"),tempCurDataMap);
	        }
	    }else{
	    	if(subCpyId.equals(curMap.get("superid"))){
	            tempCurDataMap.put("curtype","dept");
	            resultMap.put(curMap.get("id"),tempCurDataMap);
	        }
	    }
	}
	return resultMap;
}


/**
* 把所有要展示的部门数据放到集合中
* @return
*/
private void getDeptShowMap(LinkedHashMap<String,LinkedHashMap<String, String>> dataMap, LinkedHashMap<String,LinkedHashMap<String, String>> treeMap){
	LinkedHashMap<String,String> curMap = null;
	LinkedHashMap<String, String> tempCurDataMap = null;
	LinkedHashMap<String, String> tempSupDataMap = null;
	for (Entry<String,LinkedHashMap<String,String>> obj : treeMap.entrySet()) {
	    curMap = obj.getValue();
	    if(dataMap.get(obj.getKey()) == null){
	        continue;
	    }
	
	    tempCurDataMap = dataMap.get(curMap.get("id"));
	    tempSupDataMap = dataMap.get(curMap.get("superid"));
	    if(tempCurDataMap == null || tempSupDataMap == null){
	        continue;
	    }
	    
	    tempSupDataMap.put("exist",(Integer.parseInt(tempCurDataMap.get("exist"))+Integer.parseInt(tempSupDataMap.get("exist")))+"");
	    tempSupDataMap.put("without",(Integer.parseInt(tempCurDataMap.get("without"))+Integer.parseInt(tempSupDataMap.get("without")))+"");
	    tempSupDataMap.put("scoring",(Integer.parseInt(tempCurDataMap.get("scoring"))+Integer.parseInt(tempSupDataMap.get("scoring")))+"");
	    tempSupDataMap.put("assessing",(Integer.parseInt(tempCurDataMap.get("assessing"))+Integer.parseInt(tempSupDataMap.get("assessing")))+"");
	    tempSupDataMap.put("back",(Integer.parseInt(tempCurDataMap.get("back"))+Integer.parseInt(tempSupDataMap.get("back")))+"");
	    tempSupDataMap.put("finish",(Integer.parseInt(tempCurDataMap.get("finish"))+Integer.parseInt(tempSupDataMap.get("finish")))+"");
	    tempSupDataMap.put("oscoring",(Integer.parseInt(tempCurDataMap.get("oscoring"))+Integer.parseInt(tempSupDataMap.get("oscoring")))+"");
	    tempSupDataMap.put("oassessing",(Integer.parseInt(tempCurDataMap.get("oassessing"))+Integer.parseInt(tempSupDataMap.get("oassessing")))+"");
	    tempSupDataMap.put("oback",(Integer.parseInt(tempCurDataMap.get("oback"))+Integer.parseInt(tempSupDataMap.get("oback")))+"");
	    tempSupDataMap.put("hasSub","yes");
	   
	}
}
/**
* 把所有要展示的部门数据放到集合中 
* @return
*/
private LinkedHashMap<String,LinkedHashMap<String, String>> getDeptShowMap2(LinkedHashMap<String,LinkedHashMap<String, String>> dataMap,
	    LinkedHashMap<String,LinkedHashMap<String, String>> treeMap,
	    String subCpyId,
	    String curtype){
	LinkedHashMap<String,LinkedHashMap<String, String>> resultMap = new LinkedHashMap<String,LinkedHashMap<String, String>>();
	LinkedHashMap<String,String> curMap = null;
	LinkedHashMap<String, String> tempCurDataMap = null;
	LinkedHashMap<String, String> tempSupDataMap = null;
	for (Entry<String,LinkedHashMap<String,String>> obj : treeMap.entrySet()) {
	    curMap = obj.getValue();
	    if(dataMap.get(obj.getKey()) == null){
	        continue;
	    }

	    tempCurDataMap = dataMap.get(curMap.get("id"));
	    tempSupDataMap = dataMap.get(curMap.get("superid"));
	    if(tempCurDataMap == null && tempSupDataMap == null){
	        continue;
	    }else if(tempCurDataMap != null && tempSupDataMap == null){
	    	if("subcpy".equals(curtype) && subCpyId.equals(curMap.get("subcompanyid1")) && "1".equals(curMap.get("level"))){
	    		tempCurDataMap.put("curtype","dept");
	            resultMap.put(curMap.get("id"),tempCurDataMap);
	        }
	    	continue;
	    }
	    
	    //如果subCpyId是空或包含则添加
	    if("subcpy".equals(curtype)){
	        if(subCpyId.equals(curMap.get("subcompanyid1")) && "1".equals(curMap.get("level"))){
	        	tempCurDataMap.put("curtype","dept");
	            resultMap.put(curMap.get("id"),tempCurDataMap);
	        }
	    }else{
	    	if(subCpyId.equals(curMap.get("superid"))){
	            tempCurDataMap.put("curtype","dept");
	            resultMap.put(curMap.get("id"),tempCurDataMap);
	        }
	    }
	}
	return resultMap;
}
    
%>