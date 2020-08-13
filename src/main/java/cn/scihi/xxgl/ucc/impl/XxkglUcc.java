package cn.scihi.xxgl.ucc.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import cn.scihi.sdk.core.MyApiUtils;
import cn.scihi.xxgl.service.impl.XxjlglService;

/**
* @author xiongxiaojing
* @version 创建时间：2020年4月28日 下午5:10:29
*/
@Service
public class XxkglUcc extends UccAdapter{
	@Resource
	private IBaseService xxkglService;
	@Autowired
	private XxjlglService xxjlglService;

	@Override
	public void init() throws Exception {
		super.baseService = xxkglService;
	}
	
	@Override
	public int delete(Map<String, Object> map) throws Exception {
		int delete = super.delete(map);
		//删除上传的文件
		if(map.get("id")!=null && !StringUtils.isEmpty(map.get("id").toString())) {
			for(String id : map.get("id").toString().split(",")) {
				MyApiUtils.deleteFile(id);
			}
		}
		return delete;
	}
	
	@Override
	public List<Map<String, Object>> select(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> dataList = super.select(map);
		if(map.get("id")!=null && !StringUtils.isEmpty(map.get("id").toString()) && dataList!=null && dataList.size()==1) {
			//查询该用户在该任务下的学习记录
			List<Map<String, Object>> xxjlList = null;
			if(map.get("username")!=null && !StringUtils.isEmpty(map.get("username").toString())) {
				Map<String,Object> queryMap = new HashMap<String,Object>();
				queryMap.put("xxjlgl_xxkid", dataList.get(0).get("id"));
				queryMap.put("creator", map.get("username"));
				xxjlList = this.xxjlglService.select(queryMap);
			}
			Map<String, Object> parameter = new HashMap<String,Object>();
			parameter.put("fk_id", map.get("id"));
			Map<String, Object> fileResult = MyApiUtils.queryFile(parameter);
			//输出文件id
			if(StringUtils.equals("success", fileResult.get("resCode").toString())) {
				JSONArray fileArray = new JSONArray();
				String url = "/sys/file/download.do";
				
				if(fileResult.get("datas")!=null) {
					JSONArray arrayList = JSONArray.parseArray(fileResult.get("datas").toString());
					for(int i = 0;i < arrayList.size();i++) {
						JSONObject obj = arrayList.getJSONObject(i);
						obj.put("down_url", url+"?id="+obj.getString("id"));
						//判断该文件是否已经被学习
						obj.put("isRead","0");
						if(xxjlList!=null) {
							for(Map<String, Object> xxjl : xxjlList) {
								if(StringUtils.equals(xxjl.get("file_id").toString(), obj.getString("id"))) {
									obj.put("isRead","1");
								}
							}
						}
						fileArray.add(obj);
					}
				}
				dataList.get(0).put("fileObjs", fileArray);
			}
		}
		
		return dataList;
	}
}
