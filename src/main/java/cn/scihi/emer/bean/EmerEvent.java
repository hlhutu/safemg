package cn.scihi.emer.bean;

import cn.scihi.sdk.base.pojo.BaseBean;
import lombok.Data;

import java.util.Date;

@Data
public class EmerEvent extends BaseBean {
    String id;
    String sys_id;
    String category;//类型
    String event_level;//级别
    Date event_time;//发生时间
    String address;//发生地点
    String lon;//经度
    String lat;//维度
    String title;//标题
    String description;//描述
    String event_result;//处置结果
    String creator;//创建人
    Date created;//创建时间
}
