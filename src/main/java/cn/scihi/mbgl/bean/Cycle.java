package cn.scihi.mbgl.bean;

import lombok.Data;

import java.util.Date;

@Data
public class Cycle {
    String id;
    String username;
    String model_id;
    String task_def_id;
    String cycle;
    Integer cycle_count;
    Integer repeat_;
    Date last_date;
    Date last_version;
}
