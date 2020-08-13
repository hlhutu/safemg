package cn.scihi.emer.ucc.impl;

import cn.scihi.emer.service.impl.EmerEventService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import cn.scihi.sdk.core.MyApiUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author uplus
 *
 */
@Service
public class EmerEventUcc extends UccAdapter {

	@Autowired
	private EmerEventService emerEventService;

	public void init() throws Exception {
		super.setBaseService(emerEventService);
	}

	public List<Map<String, Object>> select(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> dataList = super.select(map);
		// 查询附件
		if (!"null".equals(map.get("id")+"") && !dataList.isEmpty() ) {
			try {
				String fk_id =  (String) map.get("id");
				Object attachListStr =  MyApiUtils.getFileStr(fk_id,(String)map.get("delflag"));
				dataList.get(0).put("attachList", attachListStr == null ? "" : attachListStr);
			} catch (Exception e) {
				throw new Exception("附件查询失败！");
			}
		}
		return dataList;
	}
}
