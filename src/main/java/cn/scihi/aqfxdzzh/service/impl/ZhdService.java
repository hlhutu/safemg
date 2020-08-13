/**
 * 
 */
package cn.scihi.aqfxdzzh.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.scihi.aqfxdzzh.mapper.ZhdMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;

import java.util.List;
import java.util.Map;

/**
 * @author wyc
 *
 */
@Service
public class ZhdService extends ServiceAdapter {

	@Resource
	private ZhdMapper zhdMapper;

	public void init() {
		super.baseMapper = zhdMapper;
	}

	public List<Map<String, Object>> countByStatus(String year, String month) {
		return zhdMapper.countByStatus(year, month);
	}
}
