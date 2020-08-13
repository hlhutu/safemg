/**
 * 
 */
package cn.scihi.mbgl.ucc.impl;

import cn.scihi.mbgl.service.impl.*;
import cn.scihi.sdk.base.ucc.UccAdapter;
import cn.scihi.sdk.core.MyApiUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * @author 岳开
 *
 */
@Service
public class MbglUcc extends UccAdapter {

	@Autowired
	private MbglService mbglService;

	@Autowired
	private MbglInfoService mbglInfoService;
	@Autowired
	private CycleService cycleService;
	@Autowired
	private MbglInfoUcc mbglInfoUcc;
	@Autowired
	private TaskService taskService;
	@Autowired
	private TaskUcc taskUcc;
	@Autowired
	private AssignLogService assignLogService;

	public void init() {
		super.baseService = mbglService;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public int insert(Map<String, Object> map, HttpServletRequest request) throws Exception {//保存新模板
		int rs = 0;
		if (map.containsKey("id")) {//如果id存在则从旧版本发布新版

		} else {//否则表示全新创建

		}

		return rs;
	}

	public List<Map<String, Object>> selectRolesByOrg(Map<String, Object> map) throws Exception {
		try {
			return mbglService.selectRolesByOrg(map);
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
	}

	@Transactional(rollbackFor = Exception.class)
	public String insertMyTask(Map<String, Object> map) throws Exception {
		try {
			String username = (String) map.get("user_name");
			String id = (String) map.get("id");
			Map<String, Object> para = new HashMap<String, Object>();
			para.put("ext1", id);
			para.put("ext2", username);
			List<Map<String, Object>> list = mbglService.select(para);
			if (list != null && list.size() > 0) {
				return (String) list.get(0).get("id");
			} else {
				para.clear();
				para.put("id", map.get("id"));
				String glid = "";

				List<Map<String, Object>> mgList = mbglService.select(para);
				for (Map<String, Object> m : mgList) {
					m.put("ext1", id);// 清单模板id
					m.put("ext2", username);// 用户名
					m.put("sfmb", 0);// 是否模板（1.是，0.否）
					m.remove("id");
					mbglService.insert(m);

					glid = (String) m.get("id");// 新生成清单id
					para.clear();
					para.put("glid", id);
					List<Map<String, Object>> mgInfoList = mbglInfoService.select(para);
					for (Map<String, Object> mg : mgInfoList) {
						mg.remove("id");
						mg.put("glid", glid);
						mg.put("sfmb", 0);// 是否模板（1.是，0.否）
						mg.put("ext1", id);// 清单模板id
						mg.put("ext2", username);// 用户名
						mbglInfoService.insert(mg);
					}
				}
				return glid;
			}
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
	}
	
	public int softDelete(Map<String, Object> map) throws Exception {
		String modelIds = (String) map.get("id");
		if(!StringUtils.isEmpty(modelIds)){
			for (String modelId : modelIds.split(",")) {
				Map<String, Object> modelMap = mbglService.getModelById(modelId, "true".equals(map.get("ifTime")));
				if((Integer)modelMap.get("status")!=1){
					//throw  new Exception("模板不可删除");
				}
				//删除任务
				taskService.deleteTaskByModelId(modelId);
				//删除任务项
				mbglInfoService.deleteTaskDefByModelId(modelId);
				//删除模板
				mbglService.deleteModelById(modelId);
				//删除周期记录
				cycleService.deleteByModelId(modelId);
			}
		}
		return 1;
	}

	public Integer create(Map<String, Object> map, HttpServletRequest request) throws Exception {
		int rs = 0;
		map.put("key_", UUID.randomUUID().toString());//生成key
		map.put("version", 1);
		map.put("status", 1);//状态为已保存
		rs = super.insert(map, request);
		return rs;
	}

	public Integer createFromExistVersion(Map<String, Object> old, HttpServletRequest request) throws Exception {
		Map<String, Object> para = new HashMap<String, Object>();
		String oldId = (String) old.get("id");
		//2.保存新版本
		old.remove("id");
		old.put("version", mbglService.getLastVersion((String) old.get("key_"))+1);//最大版本+1
		old.put("status", 1);//状态为已保存
		mbglService.insert(old);
		//3.拷贝任务项
		para.put("glid", oldId);
		para.put("status", 1);// 有效状态
		List<Map<String, Object>> list = mbglInfoService.select(para);
		for (Map<String, Object> m : list) {
			m.put("glid", old.get("id"));// 新模板id
			mbglInfoUcc.insert(m, request);
		}
		return 1;
	}

	public Map<String, Object> publish(String modelId) throws Exception {
		return this.publish(modelId, false);
	}

	public Map<String, Object> publish(String modelId, boolean ifTime) throws Exception {
		Map<String, Object> modelMap = mbglService.getModelById(modelId, ifTime);
		if(CollectionUtils.isEmpty(modelMap)){
			throw new Exception("发布失败，模板不存在");
		}else if(modelMap.get("status")!=null && (Integer) modelMap.get("status")!=1){
			throw new Exception("发布失败，模板的状态不为1未发布，实际状态为："+modelMap.get("status"));
		}else{
			List<Map<String, Object>> taskDefs = mbglInfoService.getTaskDefsByModelId(modelId);
			if(CollectionUtils.isEmpty(taskDefs)){
				throw new Exception("发布失败，模板的任务项为空");
			}
		}
		Map<String, Object> update = new HashMap<>();
		update.put("status", "0");//禁用
		Map<String, Object> condition = new HashMap<>();
		condition.put("key_", modelMap.get("key_"));
		condition.put("status", "2");//当前状态为发布中
		mbglService.updateForCondition(update, condition);//将旧版本禁用
		modelMap.put("status", "2");//状态改为2-已发布
		mbglService.update(modelMap);
		return modelMap;
	}

	public Integer disable(String modelId) throws Exception {
		Map<String, Object> updateMap = new HashMap<>();
		updateMap.put("status", 0);
		Map<String, Object> conditionMap = new HashMap<>();
		conditionMap.put("id", modelId);
		conditionMap.put("status", 2);
		return mbglService.updateForCondition(updateMap, conditionMap);
	}

	public Integer enable(String modelId) throws Exception {
		Map<String, Object> updateMap = new HashMap<>();
		updateMap.put("status", 2);
		Map<String, Object> conditionMap = new HashMap<>();
		conditionMap.put("id", modelId);
		conditionMap.put("status", 0);
		return mbglService.updateForCondition(updateMap, conditionMap);
	}

	/**
	 * 查询我的模板列表
	 * @param map
	 * @return
	 */
    public List<Map<String, Object>> selectMyModels(Map<String, Object> map, String qdlx, String taskStat) throws Exception {
		map.put("qdlx", qdlx);
		map.put("taskStat", taskStat);//任务状态，待办
		map.put("orderStr_", "order by t.xh");
		List<Map<String, Object>> list = mbglService.select(map);
		if(CollectionUtils.isEmpty(list)){
			return list;
		}
		for (Map<String, Object> modelMap : list) {
			List<Map<String, Object>> taskDefs = mbglInfoService.selectTaskDefs((String)modelMap.get("id"), (String)map.get("username"), null);
			modelMap.put("taskDefs", taskDefs);
		}
		return list;
    }

	public List<Map<String, Object>> selectMyTimeModels(String username) throws Exception {
		List<Map<String, Object>> list = mbglService.selectMyTimeModels(username);
		if(CollectionUtils.isEmpty(list)){
			return list;
		}
		for (Map<String, Object> modelMap : list) {
			List<Map<String, Object>> taskDefs =mbglInfoService.selectTaskDefs((String)modelMap.get("id"), username, null);
			modelMap.put("taskDefs", taskDefs);
		}
		return list;
	}

    public Integer assign(String modelId, List<String> usernames) throws Exception {
		List<Map<String, Object>> taskDefList = mbglInfoService.getTaskDefsByModelId(modelId);
		if(CollectionUtils.isEmpty(taskDefList)){
			throw new Exception("该模板下没有任何任务项");
		}
    	Map<String, Object> modelMap = mbglService.getModelById(modelId, true);
		for (String username : usernames) {
			for (Map<String, Object> taskDef : taskDefList) {
				taskUcc.generatorForTaskDef(modelMap, taskDef, username, true);
			}
			Map<String, Object> insertMap = new HashMap<>();
			insertMap.put("model_id", modelId);
			insertMap.put("username", username);
			assignLogService.insert(insertMap);
		}
		return 1;
    }

	public List<Map<String, Object>> assignlog(String modelId) {
    	return assignLogService.queryAssignLogByModelId(modelId);
	}
}
