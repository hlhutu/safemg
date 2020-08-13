package cn.scihi.xjgl.ucc.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;

import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;

/**
 * @author uplus
 *
 */
@Service
public class XjmbglInfoUcc extends UccAdapter {

	@Autowired
	private IBaseService xjmbglService;
	@Autowired
	private IBaseService xjmbglInfoService;

	public void init() throws Exception {
		super.setBaseService(xjmbglInfoService);
	}
	
	@Override
	public int insert(Map<String, Object> map, HttpServletRequest request) throws Exception {
		Map<String, Object> para = new HashMap<String, Object>();
		para.put("id", map.get("xj_id"));
		List<Map<String, Object>> list = xjmbglService.select(para);
		if (null == list || list.size() < 1) {
			throw new Exception("巡检模板数据不存在！id:" + para.get("id"));
		}
		xjmbglInfoService.delete(map);
		if (null != map.get("xjgl_info_size")) {
			int size = Integer.valueOf((String) map.get("xjgl_info_size"));
			if (size > 0) {
				Map details = JSON.parseObject((String) map.get("xjgl_info_list"), Map.class);
				for (int i = 0; i < size; i++) {
					Map detail = (Map) details.get(i + "");

					if (null != detail.get("lnglat")) {
						String lnglat = detail.get("lnglat") + "";
						detail.put("rwjd", StringUtils.substringBefore(lnglat, ","));// 任务经度
						detail.put("rwwd", StringUtils.substringAfter(lnglat, ","));// 任务纬度
					}

					detail.put("xj_id", map.get("xj_id"));
					detail.put("zxr", map.get("zxr"));
					detail.put("status", "1");
					xjmbglInfoService.insert(detail);
				}
			}
			return size;
		} else {
			return xjmbglInfoService.insert(map);
		}
	}
}
