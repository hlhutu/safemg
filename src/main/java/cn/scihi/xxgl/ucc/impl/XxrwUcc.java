package cn.scihi.xxgl.ucc.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;

/**
* @author xiongxiaojing
* @version 创建时间：2020年6月2日 下午5:48:23
*/
@Service
public class XxrwUcc extends UccAdapter{
	@Resource
	private IBaseService xxrwglService;

	@Override
	public void init() throws Exception {
		super.baseService = xxrwglService;
	}
	
	@Override
	public List<Map<String, Object>> select(Map<String, Object> map) throws Exception {
		if(map.get("ids")!=null && !StringUtils.isEmpty(map.get("ids").toString())) {
			List<String> strList = new ArrayList<String>();
			for(String str : map.get("ids").toString().split(",")) {
				strList.add("'"+str+"'");
			}
			map.put("ids", StringUtils.join(strList,","));
		}
		return super.select(map);
	}
}
