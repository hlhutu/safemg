/**
 * 
 */
package cn.scihi.mbgl.mapper;

import java.util.List;
import java.util.Map;

import cn.scihi.sdk.base.mapper.IBaseMapper;

/**
 * @author wyc
 *
 */
public interface MbOrgMapper extends IBaseMapper {
	
	

	 public List<Map<String,Object>> selectCanAddMb(Map<String,Object> map);
}
