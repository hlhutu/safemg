/**
 * 
 */
package cn.scihi.aqfxdzzh.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.scihi.aqfxdzzh.mapper.JddMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;

/**
 * @author wyc
 *
 */
@Service
public class JddService extends ServiceAdapter {

	@Resource
	private JddMapper jddMapper;

	public void init() {
		super.baseMapper = jddMapper;
	} 
}
