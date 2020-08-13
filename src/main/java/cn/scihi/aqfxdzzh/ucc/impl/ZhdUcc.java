/**
 * 
 */
package cn.scihi.aqfxdzzh.ucc.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import cn.scihi.aqfxdzzh.service.impl.JddService;
import cn.scihi.aqfxdzzh.service.impl.ZhdService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import cn.scihi.sdk.core.MyApiUtils;

/**
 * @author wyc
 *
 */
@Service
public class ZhdUcc extends UccAdapter {

	@Resource
	private ZhdService zhdService;

	public void init() {
		super.baseService = zhdService;
	}
	
	public List<Map<String, Object>> select(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> dataList = super.select(map);
		// 查询附件
		if (!"null".equals(map.get("id")+"") && !dataList.isEmpty() ) {
			try {
				String delflag =map.containsKey("delflag")?(StringUtils.isEmpty((String)map.get("delflag"))?"0":(String)map.get("delflag")):"0";
				String fk_id =  (String) map.get("id");
				map = new HashMap<String, Object>(); 
				Object attachListStr =  MyApiUtils.getFileStr(fk_id,delflag);
				
				dataList.get(0).put("attachList", attachListStr == null ? "" : attachListStr);
			} catch (Exception e) {
				throw new Exception("附件查询失败！");
			}
		} 
		return dataList;
	}

    public List<Map<String, Object>> countByStatus(String year, String month) {
		return zhdService.countByStatus(year, month);
    }
}
