package cn.scihi.yjsj.ucc.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import cn.scihi.yjsj.service.impl.DangerTemplateScaleContentService;
import cn.scihi.yjsj.service.impl.DangerTemplateTaskService;

/**
* @author bayueshiwu
* @version 创建时间：2020年6月9日 上午10:17:23
*/
@Service
public class DangerTemplateTaskOrderUcc extends UccAdapter{
	@Resource
	private IBaseService dangerTemplateTaskOrderService;
	@Autowired
	private DangerTemplateScaleContentService dangerTemplateScaleContentService;
	@Autowired
	private DangerTemplateTaskService dangerTemplateTaskService;

	@Override
	public void init() throws Exception {
		super.baseService = dangerTemplateTaskOrderService;
	}
	
	@Override
	public int insert(Map<String, Object> map, HttpServletRequest request) throws Exception {
		//判断是否已经执行过了
		Map<String,Object> queryMap = new HashMap<String,Object>();
		queryMap.put("task_id", map.get("task_id"));
		queryMap.put("content_id", map.get("content_id"));
		List<Map<String, Object>> oldList = this.dangerTemplateTaskOrderService.select(queryMap);
		int insert = 0;
		if(oldList==null || oldList.size()==0) {
			map.put("status", 1);
			insert = super.insert(map, request);
			
			//判断是不是第一个
			queryMap.clear();
			queryMap.put("task_id", map.get("task_id"));
			List<Map<String, Object>> firstList = this.dangerTemplateTaskOrderService.select(queryMap);
			//获取任务实体
			queryMap.clear();
			queryMap.put("id", map.get("task_id"));
			List<Map<String, Object>> taskList = this.dangerTemplateTaskService.select(queryMap);
			if(firstList!=null && firstList.size()==1) {
				Map<String,Object> task = taskList.get(0);
				task.put("start_time", new Date());
				task.put("status", 1);
				this.dangerTemplateTaskService.update(task);
			}
		}
		
		return insert;
	}
	
	@Override
	public int update(Map<String, Object> map, HttpServletRequest request) throws Exception {
		int update = super.update(map, request);
		//判断是否是最后一个执法项
		Map<String,Object> queryMap = new HashMap<String,Object>();
		if(map.get("task_id")==null || StringUtils.isEmpty(map.get("task_id").toString())) {
			queryMap.put("id", map.get("id"));
			List<Map<String, Object>> nowMap = this.dangerTemplateTaskOrderService.select(queryMap);
			map.put("task_id", nowMap.get(0).get("task_id"));
		}
		
		queryMap.clear();
		queryMap.put("id", map.get("task_id"));
		List<Map<String, Object>> taskList = this.dangerTemplateTaskService.select(queryMap);
		if(taskList!=null && taskList.size()==1) {
			queryMap.clear();
			queryMap.put("scale_id", taskList.get(0).get("template_id"));
			List<Map<String, Object>> contents = this.dangerTemplateScaleContentService.select(queryMap);
			queryMap.clear();
			queryMap.put("task_id", map.get("task_id"));
			List<Map<String, Object>> newList = this.dangerTemplateTaskOrderService.select(queryMap);
			
			Integer index = 0;
			for(Map<String, Object> order : newList) {
				if(order.get("status")!=null && !StringUtils.isEmpty(order.get("status").toString()) && StringUtils.equals("2", order.get("status").toString())) {
					index++;
				}
			}
			if(index == contents.size()) {
				Map<String,Object> task = taskList.get(0);
				task.put("status", 2);
				task.put("end_time", new Date());
				//更新状态
				this.dangerTemplateTaskService.update(task);
			}
		}
		return update;
	}
}
