package cn.scihi.mbgl.mapper;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @author uplus
 *
 */
public interface ReportMapper extends IBaseMapper {
    List<Map<String, Object>> lvzhi1(@Param("year") String year, @Param("month") String month, @Param("org_id") String org_id);

    List<Map<String, Object>> lvzhi2(@Param("year") String year, @Param("month") String month, @Param("org_id") String org_id);

    Map<String, Object> zhifaByMonth(@Param("year") String year, @Param("month")String month,  @Param("org_id")String org_id);

    List<Map<String, Object>> zaihailevel(@Param("year") String year, @Param("month")String month,  @Param("org_id")String org_id);

    List<Map<String, Object>> zaihaiqushi( @Param("org_id")String org_id, @Param("startDate") Date startDate);
}
