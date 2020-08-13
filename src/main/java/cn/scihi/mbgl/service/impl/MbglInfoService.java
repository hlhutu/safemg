/**
 * 
 */
package cn.scihi.mbgl.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.scihi.comm.util.CONST;
import cn.scihi.mbgl.ucc.impl.SMbglInfoUcc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.mbgl.mapper.MbglInfoMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

/**
 * @author 岳开
 * 我的注释
 */
@Service
public class MbglInfoService extends ServiceAdapter {

	@Resource
	private MbglInfoMapper mbglInfoMapper;
	@Autowired
	private TaskService taskService;
	@Autowired
	private PropService propService;
	@Autowired
	private SMbglInfoUcc sMbglInfoUcc;

	public void init() {
		super.baseMapper = mbglInfoMapper;
	}

	public int updateRowHist(Map<String, Object> map) {
		return mbglInfoMapper.updateRowHist(map);
	};

	public List<Map<String, Object>> getTaskDefsByModelId(String modelId) {
		Map<String, Object> param = new HashMap<>();
		param.put("glid", modelId);
		List<Map<String, Object>> taskDefs = mbglInfoMapper.select(param);
		return taskDefs;
	}

	/**
	 * 查询任务项
	 * @param id
	 * @param username
	 */
    public List<Map<String, Object>> selectTaskDefs(String id, String username, String stat) throws Exception {
		Map<String, Object> param1 = new HashMap<>();
		param1.put("glid", id);
		List<Map<String, Object>> taskDefs = sMbglInfoUcc.select(param1);//查询当前模板下的任务项
		if(CollectionUtils.isEmpty(taskDefs)){
			return new ArrayList<>(0);
		}
		if(StringUtils.isEmpty(username)){
			return taskDefs;
		}
		List<Map<String, Object>> newResult = new ArrayList<>();
		Map<String, Object> param2 = new HashMap<>();
		for (Map<String, Object> taskDef : taskDefs) {
			param2.put("infoid", taskDef.get("id"));
			param2.put("zxr", username);
			param2.put("needFile", "1");
			List<Map<String, Object>> tasks = taskService.select(param2);//查询当前模板，当前用户的所有任务
			taskDef.put("taskTotal", 0);
			taskDef.put("taskFinished", 0);
			taskDef.put("progress", "未开始");
			if(CollectionUtils.isEmpty(tasks)){
				taskDef.put("taskTotal", 0);
			}else{
				taskDef.put("taskTotal", tasks.size());
			}
			taskDef.put("tasks", tasks);
			int doing = 0, finished=0;
			for (Map<String, Object> task : tasks) {
				if((Integer)task.get("status")==2){//状态为2或者3，则表示该任务已完成或进行中
					finished++;
				}else if((Integer)task.get("status")==3){
					doing++;
				}
			}
			taskDef.put("taskFinished", finished);
			if(finished>=tasks.size()){
				taskDef.put("progress", "已完成");
			}else if(doing==0 && finished==0){
				taskDef.put("progress", "未开始");
			}else{
				taskDef.put("progress", "进行中");
			}
			if(StringUtils.isEmpty(stat)){//不筛选进度
				newResult.add(taskDef);
			}else{
				if(!stat.equals(taskDef.get("progress"))){//进度不匹配，跳过
					continue;
				}else{
					newResult.add(taskDef);
				}
			}
		}
		return newResult;
    }

    public void deleteTaskDefByModelId(String modelId) {
		Map<String, Object> param = new HashMap<>();
		param.put("status", -1);
		Map<String, Object> condition = new HashMap<>();
		condition.put("glid", modelId);
		mbglInfoMapper.updateForCondition(param, condition);
    }
}
