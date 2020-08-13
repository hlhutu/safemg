/**
 * 
 */
package cn.scihi.mbgl.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.scihi.mbgl.mapper.TaskMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.springframework.util.CollectionUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author 岳开
 *
 */
@Service
public class TaskService extends ServiceAdapter {

	@Resource
	private TaskMapper taskMapper;

	public void init() {
		super.baseMapper = taskMapper;
	}

	public Map<String, Object> getTaskById(String taskId) {
		Map<String, Object> param = new HashMap<>();
		param.put("id", taskId);
		List<Map<String, Object>> tasks = taskMapper.select(param);
		if(CollectionUtils.isEmpty(tasks)){
			return null;
		}else if(CollectionUtils.isEmpty(tasks.get(0))){
			return null;
		}else{
			return tasks.get(0);
		}
	}

    public void deleteTaskByModelId(String modelId) {
		Map<String, Object> param = new HashMap<>();
		param.put("status", -1);
		Map<String, Object> condition = new HashMap<>();
		condition.put("mbid", modelId);
		taskMapper.updateForCondition(param, condition);
    }
}
