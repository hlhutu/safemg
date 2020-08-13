/**
 * 
 */
package cn.scihi.mbgl.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.scihi.mbgl.mapper.MbOrgMapper;
import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;

/**
 * @author wyc
 *
 */
@Service
public class MbOrgService extends ServiceAdapter {

	@Resource
	private MbOrgMapper mbOrgMapper;

	public void init() {
		super.baseMapper = mbOrgMapper;
	}
	
	public List<Map<String,Object>> selectCanAddMb(Map<String,Object> map) throws Exception{
		try {
			return mbOrgMapper.selectCanAddMb(map);
		} catch (Throwable e) {
			e.printStackTrace();
			throw new Exception(e.getMessage());
		}
	}
}
