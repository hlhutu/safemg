package cn.scihi.xxgl.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.scihi.mbgl.service.impl.TaskInstanceService;
import cn.scihi.mbgl.ucc.impl.TaskUcc;
import cn.scihi.sdk.core.MyApiUtils;
import com.alibaba.fastjson.JSONArray;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.springframework.util.CollectionUtils;

/**
* @author xiongxiaojing
* @version 创建时间：2020年6月2日 下午5:46:40
*/
@Service
public class XxrwglService extends ServiceAdapter{
	@Resource
	private IBaseMapper xxrwglMapper;
	@Autowired
	private XxkglService xxkglService;
	@Autowired
	private TaskUcc taskUcc;
	@Autowired
	private XxjlglService xxjlglService;
	@Value("${app.sys_id}")
	private String SYS_ID;

	@Override
	public void init() throws Exception {
		super.baseMapper = xxrwglMapper;
	}
	
	public Map<String,Object> newInstance(String modelId, String userName, String token) throws Exception{
		Map<String,Object> xxrwObj = new HashMap<String, Object>();
		Map<String, Object> xxk = xxkglService.selectById(modelId);
		xxrwObj.put("sys_id", xxk.get("sys_id"));
		xxrwObj.put("xxk_id", modelId);
		xxrwObj.put("req_model_id", modelId);
		xxrwObj.put("user_name", userName);
		String status = this.queryStatus(modelId, userName, token);
		xxrwObj.put("realStatus", status);
		if("2".equals(status)){
			xxrwObj.put("status", "0");//已完成
		}else {
			xxrwObj.put("status", "1");//进行中
		}
		super.insert(xxrwObj);
		return xxrwObj;
	}

	/**
	 * 查询一个学习库的学习进度
	 * @param req_model_id
	 * @return 1 未开始 2已完成 3进行中
	 */
	public String queryStatus(String req_model_id, String username, String token) throws Exception {
		//查询该学习库的资料
		Map<String, Object> parameter = new HashMap<String,Object>();
		parameter.put("fk_id", req_model_id);
		if(!StringUtils.isEmpty(token)){
			parameter.put("token", token);
		}
		Map<String, Object> fileResult = MyApiUtils.queryFile(parameter);
		int totalSize = 0;
		if(StringUtils.equals("success", fileResult.get("resCode").toString())) {
			if(fileResult.get("datas")!=null) {
				JSONArray arrayList = JSONArray.parseArray(fileResult.get("datas").toString());
				totalSize = arrayList.size();
			}
		}
		if(totalSize==0){
			return "2";//总数为0直接完成
		}
		//查询本人在该库下的学习记录
		Map<String, Object> parameter1 = new HashMap<String,Object>();
		parameter1.put("xxjlgl_xxkid", req_model_id);
		parameter1.put("creator", username);
		List<Map<String, Object>> studylog = xxjlglService.select(parameter1);
		int studied = 0;
		if(!CollectionUtils.isEmpty(studylog)){
			studied = studylog.size();
		}
		if(studied==0){
			return "1";//未开始
		}else if(studied>0 && studied<totalSize){
			return "3";//进行中
		}else {//已完成
			return "2";
		}
	}
	public void finish(String xxTaskId) throws Exception {
		Map<String,Object> updateMap = new HashMap<String,Object>();
		updateMap.put("id", xxTaskId);
		updateMap.put("status", "0");
		updateMap.put("xxrw_endtime", new Date());
		super.update(updateMap);
		//调用任务结束
		taskUcc.completeByOther(TaskInstanceService.STUDY, xxTaskId);
	}

    public void doing(String xxTaskId) throws Exception {
		//调用任务进行中
		taskUcc.statusByOther(TaskInstanceService.STUDY, xxTaskId, 3);
    }
}
