/**
 * 
 */
package cn.scihi.aqfxdzzh.mapper;


import cn.scihi.sdk.base.mapper.IBaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;


/**
 * @author wyc
 *
 */
public interface ZhdMapper extends IBaseMapper {
    List<Map<String, Object>> countByStatus(@Param("year") String year, @Param("month") String month);
}
