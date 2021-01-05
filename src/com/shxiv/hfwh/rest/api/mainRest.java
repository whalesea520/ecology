package com.shxiv.hfwh.rest.api;

import org.apache.log4j.Logger;
import weaver.conn.RecordSet;
import weaver.general.BaseBean;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

/**
 * Created by zsd on 2019/1/17.
 */
@Path("/Mes_Main")
public class mainRest extends BaseBean {

    private Logger log = Logger.getLogger(this.getClass());

    /**
     *
     *
     * @return 返回响应JSON字符串
     */
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public String getMsg(@QueryParam("userId") String userId) {
        log.error("userId:"+userId);
        String json="111111111111";
        RecordSet rs=new RecordSet();
        String sqlS="";

        return json;
    }

}
