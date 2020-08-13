package cn.scihi.yjsj.ucc.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import cn.scihi.sdk.core.MyApiUtils;
import cn.scihi.yjsj.service.impl.DangerTemplateScaleContentService;
import cn.scihi.yjsj.service.impl.DangerTemplateScaleService;
import cn.scihi.yjsj.service.impl.DangerTemplateTaskOrderService;
import org.springframework.util.CollectionUtils;

/**
* @author bayueshiwu
* @version 创建时间：2020年6月9日 上午10:17:23
*/
@Service
public class DangerTemplateTaskUcc extends UccAdapter{
	@Resource
	private IBaseService dangerTemplateTaskService;
	@Autowired
	private DangerTemplateScaleContentService dangerTemplateScaleContentService;
	@Autowired
	private DangerTemplateTaskOrderService dangerTemplateTaskOrderService;
	@Autowired
	private DangerTemplateScaleService dangerTemplateScaleService;
	@Autowired
	private DangerTempalteScaleUcc dangerTempalteScaleUcc;

	@Override
	public void init() throws Exception {
		super.baseService = dangerTemplateTaskService;
	}
	
	@Override
	public int delete(Map<String, Object> map) throws Exception {
		//删除关联的任务执行项
		if(map!=null && map.get("id")!=null && !StringUtils.isEmpty(map.get("id").toString())) {
			//查询所有的执行项
			Map<String, Object> contentMap = new HashMap<String,Object>();
			contentMap.put("taskIds", map.get("id"));
			List<Map<String, Object>> orderList = this.dangerTemplateTaskOrderService.select(contentMap);
			if(orderList!=null && orderList.size()>0) { //如果有执行项
				List<String> orderIds = new ArrayList<String>();
				for(Map<String, Object> order : orderList) {
					orderIds.add(order.get("id").toString());
				}
				//删除
				Map<String, Object> delOrderMap = new HashMap<String,Object>();
				delOrderMap.put("id", StringUtils.join(orderIds,","));
				this.dangerTemplateTaskOrderService.delete(delOrderMap);
			}
		}
		//删除任务
		return super.delete(map);
	}
	
	@Override
	public int insert(Map<String, Object> map, HttpServletRequest request) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("parent_id", map.get("template_id"));
		List<Map<String, Object>> list = dangerTempalteScaleUcc.select(param);
		if(CollectionUtils.isEmpty(list)){
			throw new Exception("所选行业没有执法清单");
		}
		map.put("status", 0);
		return super.insert(map, request);
	}
	
	@Override
	public List<Map<String, Object>> select(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> dataList = super.select(map);
		//填充执法项
		for(Map<String, Object> data : dataList) {
			List<Map<String, Object>> newContentList = new LinkedList<Map<String, Object>>();
			
			Map<String, Object> queryMap = new HashMap<String, Object>();
			queryMap.put("scale_id", data.get("template_id"));
			List<Map<String, Object>> contentList = this.dangerTemplateScaleContentService.select(queryMap);
			
			for(Map<String, Object> content : contentList) {
				Map<String, Object> newMap = new HashMap<String, Object>();
				
				newMap.putAll(content);
				fillContent(content,data.get("template_id").toString(),newMap);
				newMap.put("status", "0");
				
				Map<String,Object> queryMap1 = new HashMap<String,Object>();
				queryMap1.put("task_id", data.get("id"));
				queryMap1.put("content_id", content.get("id"));
				List<Map<String, Object>> oldList = this.dangerTemplateTaskOrderService.select(queryMap1);
				if(oldList!=null && oldList.size()!=0) {
					newMap.put("status", oldList.get(0).get("status"));
					newMap.put("orderId", oldList.get(0).get("id"));
					newMap.put("taskDate", oldList.get(0).get("modified"));
					//填充附件
					Map<String, Object> parameter = new HashMap<String,Object>();
					parameter.put("fk_id", oldList.get(0).get("id"));
					Map<String, Object> fileResult = MyApiUtils.queryFile(parameter);
					newMap.put("fileList", fileResult.get("datas"));
					
					newMap.put("result", oldList.get(0).get("result"));
					newMap.put("lt", oldList.get(0).get("lt"));
					newMap.put("ld", oldList.get(0).get("ld"));
					newMap.put("remark", oldList.get(0).get("remark"));
				}
				
				
				newContentList.add(newMap);
			}
			data.put("contentList", newContentList);
		}
		return dataList;
	}
	
	/**
	 * 填充父级别信息
	 */
	private void fillContent(Map<String, Object> content,String tempalteId,Map<String, Object> newMap) throws Exception{
		Map<String,Object> queryMap = new HashMap<String,Object>();
		queryMap.put("id", content.get("scale_id"));
		List<Map<String, Object>> list = this.dangerTemplateScaleService.select(queryMap);
		
		List<Object> resultList = new LinkedList<Object>();
		if(list!=null && list.size()==1) {
			resultList.add(list.get(0).get("scale_name"));
			
			Object parentId = list.get(0).get("parent_id");
			while(true) {
				queryMap.clear();
				queryMap.put("id", parentId);
				List<Map<String, Object>> newList = this.dangerTemplateScaleService.select(queryMap);
				if(newList==null || newList.size()==0 || StringUtils.equals(tempalteId, newList.get(0).get("id").toString())) {
					break;
				}
				resultList.add(0,newList.get(0).get("scale_name"));
				parentId = newList.get(0).get("parent_id");
			}
		}
		newMap.put("parentContent", resultList);
	}
	
	/**
	 * 获取待办执法任务数量
	 */
	public Integer getCountDealt(String lawUser) throws Exception{
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("law_user", lawUser);
		map.put("notStatus", "2");
		List<Map<String, Object>> list = super.select(map);
		if(list==null) {
			return 0;
		}
		return list.size();
	}
}
