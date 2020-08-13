package cn.scihi.xxgl.ucc.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONArray;

import cn.scihi.mbgl.service.impl.TaskInstanceService;
import cn.scihi.mbgl.ucc.impl.TaskUcc;
import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import cn.scihi.sdk.core.MyApiUtils;
import cn.scihi.xxgl.service.impl.XxrwglService;
import org.springframework.util.CollectionUtils;

/**
* @author xiongxiaojing
* @version 创建时间：2020年4月28日 下午5:10:29
*/
@Service
public class XxjlglUcc extends UccAdapter{
	@Resource
	private IBaseService xxjlglService;
	@Autowired
	private XxrwglService xxrwglService;
	@Autowired
	private TaskUcc taskUcc;

	@Override
	public void init() throws Exception {
		super.baseService = xxjlglService;
	}
	
	@Override
	public int insert(Map<String, Object> map, HttpServletRequest request) throws Exception {
		String myUserName = MyApiUtils.getUser("user_name");
		//判断是否已经学习过了
		Map<String,Object> queryMap1 = new HashMap<String,Object>();
		queryMap1.put("xxjlgl_xxkid", map.get("xxjlgl_xxkid"));
		queryMap1.put("file_id", map.get("file_id"));
		queryMap1.put("creator", myUserName);
		List<Map<String, Object>> oldList = this.xxjlglService.select(queryMap1);
		int insert = 0;
		if(oldList==null || oldList.size()==0) {
			insert = super.insert(map, request);
		}
		//查询本文件关联的学习任务
		Map<String,Object> queryMap2 = new HashMap<>();
		queryMap2.put("xxk_id", map.get("xxjlgl_xxkid"));
		queryMap2.put("username", MyApiUtils.getUser("user_name"));
		List<Map<String, Object>> tasks = xxrwglService.select(queryMap2);
		if(!CollectionUtils.isEmpty(tasks)){
			for (Map<String, Object> task : tasks) {
				String xxTaskId = (String) task.get("id");
				String status = xxrwglService.queryStatus((String) map.get("xxjlgl_xxkid"), myUserName, null);//查询学习进度
				if("2".equals(status)){//如果已经完成
					xxrwglService.finish(xxTaskId);//更新学习进度
				}else{
					xxrwglService.doing(xxTaskId);
				}
			}
		}
		return insert;
	}
}
