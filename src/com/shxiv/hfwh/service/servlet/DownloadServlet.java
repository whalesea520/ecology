package com.shxiv.hfwh.service.servlet;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import sun.misc.BASE64Encoder;
import weaver.conn.RecordSet;
import weaver.file.AESCoder;
import weaver.rsa.security.IOUtils;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.zip.ZipInputStream;

/**
 * Created by zsd on 2019/1/21.
 */
public class DownloadServlet extends HttpServlet {

    @SuppressWarnings("unchecked")
    public void doGet(HttpServletRequest req, HttpServletResponse resp)

            throws ServletException, IOException {

        Log log= LogFactory.getLog("文件下载:");
        String fileId=req.getParameter("fileId");
        log.error("Id是："+fileId);
        //从系统获取压缩后的附件并解压
        InputStream inputStream=null;
        ArrayList filecontents = new ArrayList();
        String sqlw = "";

        RecordSet rs=new RecordSet();

        rs.execute("select imagefileid from DocImageFile where docid = "+fileId);
        if (rs.next()){
            sqlw = rs.getString("imagefileid");
        }
        rs.execute(" select isaesencrypt,aescode,filerealpath,iszip,imagefilename from imagefile where imagefileid='"+sqlw+"'");
        if(rs.next()) {
            String isAesencrypt = rs.getString("isaesencrypt");
            String aesCode = rs.getString("aescode");
            String filename = (rs.getString("imagefilename"));
            log.error("filename是："+filename);
            File filePath = new File(rs.getString("filerealpath"));
            if (rs.getString("iszip").equals("1")) {
                ZipInputStream zin = new ZipInputStream(new FileInputStream(filePath));
                if (zin.getNextEntry() != null) filecontents.add(new BufferedInputStream(zin));
            } else {
                filecontents.add(new BufferedInputStream(new FileInputStream(filePath)));
            }
            if (isAesencrypt.equals("1")) {
                try {
                    inputStream= AESCoder.decrypt((InputStream)filecontents.get(0), aesCode);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }else{
                inputStream=(InputStream)filecontents.get(0);
            }

            String framename = filenameEncoding(filename, req);

            String contentType = this.getServletContext()

                    .getMimeType(filename);//通过文件名称获取MIME类型

            String contentDisposition = "attachment;filename=" + framename;

            /*FileInputStream input = new FileInputStream(filename);*/

            resp.setHeader("Content-Type", contentType);

            resp.setHeader("Content-Disposition", contentDisposition);

            ServletOutputStream output = resp.getOutputStream();

            IOUtils.copy(inputStream, output);//把输入流中的数据写入到输出流中。---输出流的节点就是客户端

            assert inputStream != null;
            inputStream.close();
        }
    }



// 用来对下载的文件名称进行编码的！

    public static String filenameEncoding(String filename, HttpServletRequest request) throws IOException {

        String agent = request.getHeader("User-Agent"); //获取浏览器

        if (agent.contains("Firefox")) {

            BASE64Encoder base64Encoder = new BASE64Encoder();

            filename = "=?utf-8?B?"

                    + base64Encoder.encode(filename.getBytes("utf-8"))

                    + "?=";

        } else if(agent.contains("MSIE")) {

            filename = URLEncoder.encode(filename, "utf-8");

        } else {

            filename = URLEncoder.encode(filename, "utf-8");

        }

        return filename;

    }

}

