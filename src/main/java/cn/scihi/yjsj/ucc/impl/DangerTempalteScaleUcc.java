package cn.scihi.yjsj.ucc.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import cn.scihi.yjsj.service.impl.DangerTemplateScaleContentService;

/**
* @author xiongxiaojing
* @version 创建时间：2020年6月2日 上午10:37:30
*/
@Service
public class DangerTempalteScaleUcc extends UccAdapter{
	@Resource
	private IBaseService dangerTemplateScaleService;
	
	@Autowired
	private DangerTemplateScaleContentService dangerTemplateScaleContentService;

	@Override
	public void init() throws Exception {
		super.baseService = dangerTemplateScaleService;
	}
	
	@Override
	public int delete(Map<String, Object> map) throws Exception {
		//删除树下所有的清单项
		Map<String,Object> delMap = new HashMap<String,Object>();
		delMap.put("scale_tree_id", map.get("id"));
		this.dangerTemplateScaleContentService.delete(delMap);
		return super.delete(map);
	}
	
	public Object getTemplateOrder() throws Exception{
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("parent_id", "1");
		List<Map<String, Object>> dataList = this.dangerTemplateScaleService.select(map);
		for(Map<String, Object> data : dataList) {
			map.clear();
			map.put("parent_id", data.get("id"));
			data.put("orderList", this.dangerTemplateScaleService.select(map));
		}
		return dataList;
	}
}
