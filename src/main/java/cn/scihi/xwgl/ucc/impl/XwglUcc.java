package cn.scihi.xwgl.ucc.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;

/**
* @author xiongxiaojing
* @version 创建时间：2020年4月28日 下午5:10:29
*/
@Service
public class XwglUcc extends UccAdapter{
	@Resource
	private IBaseService xwglService;

	@Override
	public void init() throws Exception {
		super.baseService = xwglService;
	}

	@Override
	public int insert(Map<String, Object> map, HttpServletRequest request) throws Exception {
		//判断是否发布,如果发布,填充发布时间
		if(map.get("status")!=null && StringUtils.equals("1", map.get("status").toString())) {
			map.put("xwgl_publish_time",new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
		}
		//处理图片
		processPic(request, map);
		return super.insert(map, request);
	}
	
	@Override
	public int update(Map<String, Object> map, HttpServletRequest request) throws Exception {
		//判断是否发布,如果发布,填充发布时间
		if((map.get("xwgl_publish_time")==null || StringUtils.isEmpty(map.get("xwgl_publish_time").toString())) && map.get("status")!=null && StringUtils.equals("1", map.get("status").toString())) {
			map.put("xwgl_publish_time",new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
		}
		//处理图片
		processPic(request, map);
		return super.update(map, request);
	}
	
	/**
	 * 处理图片
	 */
	private void processPic(HttpServletRequest request,Map<String,Object> map) throws Exception{
		//处理图片
		if(request instanceof MultipartHttpServletRequest) {
			MultipartHttpServletRequest mrequest = (MultipartHttpServletRequest) request;
			MultipartFile minPicfile = mrequest.getFile("xwgl_minpic");
			if(minPicfile!=null && !minPicfile.isEmpty()) {
				map.put("xwgl_minpic", minPicfile.getInputStream());
			}else {
				map.remove("xwgl_minpic");
			}
			MultipartFile maxPicfile = mrequest.getFile("xwgl_maxpic");
			if(maxPicfile!=null && !maxPicfile.isEmpty()) {
				map.put("xwgl_maxpic", maxPicfile.getInputStream());
			}else {
				map.remove("xwgl_maxpic");
			}
		}
	}
}
