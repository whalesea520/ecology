package com.shxiv.dingding.api;

import com.dingtalk.api.DefaultDingTalkClient;
import com.dingtalk.api.DingTalkClient;
import com.dingtalk.api.request.OapiDepartmentListRequest;
import com.dingtalk.api.request.OapiUserGetDeptMemberRequest;
import com.dingtalk.api.response.OapiDepartmentListResponse;
import com.dingtalk.api.response.OapiUserGetDeptMemberResponse;
import com.taobao.api.ApiException;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Administrator on 2020/1/7.
 */
public class GetUserId {

    /**
     * 获取部门id列表
     * @return 部门id集合
     */
    public static List<String> getDepartmentList(){
        List<String> departmentList=new ArrayList<String>();
        GetAccessToken getAccessToken=new GetAccessToken();
        String accessToken=getAccessToken.accessToken();
        DingTalkClient client = new DefaultDingTalkClient("https://oapi.dingtalk.com/department/list");
        OapiDepartmentListRequest request = new OapiDepartmentListRequest();
        request.setHttpMethod("GET");

        try {
            OapiDepartmentListResponse response = client.execute(request, accessToken);
            String errmsg=response.getErrmsg();
            if ("ok".equals(errmsg)) {
                List<OapiDepartmentListResponse.Department> list = response.getDepartment();
                for (int i = 0; i < list.size(); i++) {
                    String department=list.get(i).getId().toString();
//                    System.out.println("部门："+department);
                    departmentList.add(department);
                }
            }
        } catch (ApiException e) {
            e.printStackTrace();
        }

        return departmentList;
    }

    /**
     * 获取部门的用户ID
     * @return 用户ID集合
     */
    public List<String> getUsers(){
        List<String> users=new ArrayList<String>();
        GetAccessToken getAccessToken=new GetAccessToken();
        String accessToken=getAccessToken.accessToken();
        List<String> departmentList=new ArrayList<String>();
        departmentList=GetUserId.getDepartmentList();
//        System.out.println("部门集合："+departmentList.toString());
        for (int i = 0; i < departmentList.size(); i++) {
            DingTalkClient client = new DefaultDingTalkClient("https://oapi.dingtalk.com/user/getDeptMember");
            OapiUserGetDeptMemberRequest req = new OapiUserGetDeptMemberRequest();
            req.setDeptId(departmentList.get(i));
            req.setHttpMethod("GET");
            try {
                OapiUserGetDeptMemberResponse rsp = client.execute(req, accessToken);
//                System.out.println(rsp.getBody());
                String errmsg=rsp.getErrmsg();
                if ("ok".equals(errmsg)) {
                    List userIds= rsp.getUserIds();
                    if(userIds.size()>0){
//                        System.out.println(users.toString());
                        for (int j = 0; j <userIds.size() ; j++) {
                            String userId=userIds.get(j).toString();
                            users.add(userId);
                        }
                    }
                }
            } catch (ApiException e) {
                e.printStackTrace();
            }
        }

        return users;
    }

}
