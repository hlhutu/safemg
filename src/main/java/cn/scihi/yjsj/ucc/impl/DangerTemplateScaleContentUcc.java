package cn.scihi.yjsj.ucc.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import cn.scihi.yjsj.service.impl.DangerTemplateTaskOrderService;

/**
* @author bayueshiwu
* @version 创建时间：2020年6月5日 下午3:45:18
*/
@Service
public class DangerTemplateScaleContentUcc extends UccAdapter{
	@Resource
	private IBaseService dangerTemplateScaleContentService;
	@Autowired
	private DangerTemplateTaskOrderService dangerTemplateTaskOrderService;

	@Override
	public void init() throws Exception {
		super.baseService = dangerTemplateScaleContentService;
	}
	
	@Override
	public List<Map<String, Object>> select(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> dataList = super.select(map);
		//填充是否已经被执行
		if(map.get("task_id")!=null && !StringUtils.isEmpty(map.get("task_id").toString())) {
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("task_id", map.get("task_id"));
			List<Map<String, Object>> orderList = this.dangerTemplateTaskOrderService.select(map1);
			for(Map<String, Object> data : dataList) {
				data.put("isFinish", "0");
				for(Map<String, Object> order : orderList) {
					if(StringUtils.equals(order.get("content_id").toString(), data.get("id").toString())) {
						data.put("isFinish", "1");
						break;
					}
				}
			}
		}
		return dataList;
	}
}
