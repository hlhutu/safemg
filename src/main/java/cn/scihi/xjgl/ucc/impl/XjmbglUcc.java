package cn.scihi.xjgl.ucc.impl;

import cn.scihi.xjgl.service.impl.XjmbglInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author uplus
 *
 */
@Service
public class XjmbglUcc extends UccAdapter {

	@Autowired
	private IBaseService xjmbglService;
	@Autowired
	private XjmbglInfoService xjmbglInfoService;

	public void init() throws Exception {
		super.setBaseService(xjmbglService);
	}

    public List<Map<String, Object>> queryByFxId(String fxid) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("fxid", fxid);
		List<Map<String, Object>> mbs = super.select(param);
		if(CollectionUtils.isEmpty(mbs)){
			return new ArrayList<>(0);
		}
		Map<String, Object> param1 = new HashMap<>();
		for (Map<String, Object> mb : mbs) {
			param1.put("xj_id", mb.get("id"));
			mb.put("infos", xjmbglInfoService.select(param1));
		}
		return mbs;
    }
}
