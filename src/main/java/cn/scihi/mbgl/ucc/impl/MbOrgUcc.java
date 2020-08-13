/**
 * 
 */
package cn.scihi.mbgl.ucc.impl;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

import cn.scihi.mbgl.service.impl.MbOrgService;
import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;

/**
 * @author wyc
 *
 */
@Service
public class MbOrgUcc extends UccAdapter {

	@Autowired
	private MbOrgService mbOrgService;
 

	public void init() {
		super.baseService = mbOrgService;
	}
	public List<Map<String, Object>> selectCanAddMb(Map<String, Object> map) throws Exception {
		return mbOrgService.selectCanAddMb(map);
	}
	
 
	public int insertRealtions(Map<String, Object> map, HttpServletRequest request) throws Exception {
		List<Map> realtionList = JSONObject.parseArray((String) map.get("realtionList"), Map.class);
		int res =0;
		if (null!=realtionList&&realtionList.size()!=0) {
			for (Map dtlObject : realtionList) {
				res += mbOrgService.insert(dtlObject);
			}
		}
		return res;
	}
}
